defmodule AshBaseTemplate.Accounts.User do
  @moduledoc false

  use Ash.Resource,
    otp_app: :ash_base_template,
    domain: AshBaseTemplate.Accounts,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [
      AshAuthentication,
      AshAdmin.Resource,
      AshCloak,
      AshArchival.Resource,
      AshJsonApi.Resource
    ],
    data_layer: AshPostgres.DataLayer

  # https://hexdocs.pm/ash_archival/unarchiving.html
  alias AshAuthentication.Strategy.Password.HashPasswordChange
  alias AshAuthentication.Strategy.Password.PasswordConfirmationValidation

  json_api do
    type "user"

    routes do
      # read actions that return *only one resource* are allowed to be used with
      # `post` routes.

      post :sign_in_with_password do
        route "/sign_in/:id"

        # given a successful request, we will modify the route to include the
        # generated token
        metadata fn _subject, user, _request ->
          %{token: user.__metadata__.token}
        end
      end
    end
  end

  authentication do
    tokens do
      enabled? true
      token_resource AshBaseTemplate.Accounts.Token
      signing_secret AshBaseTemplate.Secrets
    end

    strategies do
      password :password do
        identity_field :email
        hashed_password_field :hashed_password

        resettable do
          sender AshBaseTemplate.Accounts.User.Senders.SendPasswordResetEmail
        end
      end

      magic_link do
        identity_field :email
        # this creates the user if it does not exist
        registration_enabled? true

        sender AshBaseTemplate.Accounts.User.Senders.SendMagicLinkEmail
      end
    end

    add_ons do
      confirmation :confirm_new_user do
        monitor_fields [:email]
        confirm_on_create? true
        confirm_on_update? false
        auto_confirm_actions [:sign_in_with_magic_link]
        inhibit_updates? false
        sender AshBaseTemplate.Accounts.User.Senders.SendNewUserConfirmationEmail
      end

      # when the fields change, we send an email to the user to confirm the change
      confirmation :confirm_change do
        monitor_fields [:email]
        confirm_on_create? false
        confirm_on_update? true
        confirm_action_name :confirm_change
        inhibit_updates? true
        sender AshBaseTemplate.Accounts.User.Senders.SendDataChangeConfirmationEmail
      end
    end
  end

  # this is to show in the admin dashboard
  admin do
    actor?(true)
  end

  # Encryption some fields - https://hexdocs.pm/ash_cloak/getting-started-with-ash-cloak.html
  cloak do
    # the vault to use to encrypt them
    vault(AshBaseTemplate.Vault)

    # the attributes to encrypt
    # attributes [:address, :phone_number]

    # This is just equivalent to always providing `load: fields` on all calls
    # decrypt_by_default [:address]

    # An MFA or function to be invoked beforce any decryption
    # on_decrypt fn records, field, context ->
    #   # Ash has policies that allow forbidding certain users to load data.
    #   # You should generally use those for authorization rules, and
    #   # only use this callback for auditing/logging.
    #   Audit.user_accessed_encrypted_field(records, field, context)

    #   if context.user.name == "marty" do
    #     {:error, "No martys at the party!"}
    #   else
    #     :ok
    #   end
    # end
  end

  archive do
    archive_related [:posts]
    archive_related_authorize?(false)
  end

  postgres do
    table "users"
    repo AshBaseTemplate.Repo
  end

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept [:email]
    end

    read :get_by_subject do
      description "Get a user by the subject claim in a JWT"
      argument :subject, :string, allow_nil?: false
      get? true
      prepare AshAuthentication.Preparations.FilterBySubject
    end

    read :sign_in_with_password do
      description "Attempt to sign in using a email and password."
      get? true

      argument :email, :ci_string do
        description "The email to use for retrieving the user."
        allow_nil? false
      end

      argument :password, :string do
        description "The password to check for the matching user."
        allow_nil? false
        sensitive? true
      end

      # validates the provided email and password and generates a token
      prepare AshAuthentication.Strategy.Password.SignInPreparation

      metadata :token, :string do
        description "A JWT that can be used to authenticate the user."
        allow_nil? false
      end
    end

    read :sign_in_with_token do
      # In the generated sign in components, we validate the
      # email and password directly in the LiveView
      # and generate a short-lived token that can be used to sign in over
      # a standard controller action, exchanging it for a standard token.
      # This action performs that exchange. If you do not use the generated
      # liveviews, you may remove this action, and set
      # `sign_in_tokens_enabled? false` in the password strategy.

      description "Attempt to sign in using a short-lived sign in token."
      get? true

      argument :token, :string do
        description "The short-lived sign in token."
        allow_nil? false
        sensitive? true
      end

      # validates the provided sign in token and generates a token
      prepare AshAuthentication.Strategy.Password.SignInWithTokenPreparation

      metadata :token, :string do
        description "A JWT that can be used to authenticate the user."
        allow_nil? false
      end
    end

    create :register_with_password do
      description "Register a new user with a email and password."
      accept [:email]

      argument :password, :string do
        description "The proposed password for the user, in plain text."
        allow_nil? false
        constraints min_length: 8
        sensitive? true
      end

      argument :password_confirmation, :string do
        description "The proposed password for the user (again), in plain text."
        allow_nil? false
        sensitive? true
      end

      # Hashes the provided password
      change HashPasswordChange

      # Generates an authentication token for the user
      change AshAuthentication.GenerateTokenChange

      # validates that the password matches the confirmation
      validate PasswordConfirmationValidation

      metadata :token, :string do
        description "A JWT that can be used to authenticate the user."
        allow_nil? false
      end
    end

    update :confirm_change do
      argument :confirm, :string, allow_nil?: false, public?: true
      accept [:email]
      require_atomic? false
      change AshAuthentication.AddOn.Confirmation.ConfirmChange
      change AshAuthentication.GenerateTokenChange
      # other stuff to run when the change is valid
      # change AshBaseTemplate.UpdateCrmSystem, only_when_valid?: true
    end

    action :request_password_reset_with_password do
      description "Send password reset instructions to a user if they exist."

      argument :email, :ci_string do
        allow_nil? false
      end

      # creates a reset token and invokes the relevant senders
      run {AshAuthentication.Strategy.Password.RequestPasswordReset, action: :get_by_email}
    end

    read :get_by_email do
      description "Looks up a user by their email"
      get? true

      argument :email, :ci_string do
        allow_nil? false
      end

      filter expr(email == ^arg(:email))
    end

    update :password_reset_with_password do
      argument :reset_token, :string do
        allow_nil? false
        sensitive? true
      end

      argument :password, :string do
        description "The proposed password for the user, in plain text."
        allow_nil? false
        constraints min_length: 8
        sensitive? true
      end

      argument :password_confirmation, :string do
        description "The proposed password for the user (again), in plain text."
        allow_nil? false
        sensitive? true
      end

      # validates the provided reset token
      validate AshAuthentication.Strategy.Password.ResetTokenValidation

      # validates that the password matches the confirmation
      validate PasswordConfirmationValidation

      # Hashes the provided password
      change HashPasswordChange

      # Generates an authentication token for the user
      change AshAuthentication.GenerateTokenChange
    end

    create :sign_in_with_magic_link do
      description "Sign in or register a user with magic link."

      argument :token, :string do
        description "The token from the magic link that was sent to the user"
        allow_nil? false
      end

      upsert? true
      upsert_identity :unique_email
      upsert_fields [:email]

      # Uses the information from the token to create or sign in the user
      change AshAuthentication.Strategy.MagicLink.SignInChange

      metadata :token, :string do
        allow_nil? false
      end
    end

    action :request_magic_link do
      argument :email, :ci_string do
        allow_nil? false
      end

      run AshAuthentication.Strategy.MagicLink.Request
    end

    read :by_id do
      description "Looks up a user by their id"
      get? true

      argument :id, :uuid do
        allow_nil? false
      end

      filter expr(id == ^arg(:id))
    end
  end

  policies do
    bypass AshOban.Checks.AshObanInteraction do
      authorize_if always()
    end

    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    bypass actor_attribute_equals(:role, :admin) do
      authorize_if always()
    end

    policy changing_attributes([:role]) do
      description "Only Odin can change roles"
      authorize_if expr(actor(:role) == :admin)
    end

    policy action_type(:read) do
      description "Users can read other users' basic info"
      authorize_if always()
    end

    policy action(:update) do
      description "Users can only update their own info (except role)"
      authorize_if relates_to_actor_via(:user)
      forbid_if changing_attributes([:role])
    end

    policy action(:destroy) do
      description "Only Odin can destroy users"
      authorize_if expr(actor(:role) == :admin)
    end
  end

  validations do
    # You can also call the validation inside a action that you want.
    # https://hexdocs.pm/ash/validations.html
    # Left commented out for now, but you can use it if you want.
    # validate {AshBaseTemplate.Validations.Username, attribute: :username} do
    #   on [:create, :update]
    # end
  end

  attributes do
    uuid_v7_primary_key :id
    create_timestamp :inserted_at
    update_timestamp :updated_at

    attribute :email, :ci_string do
      allow_nil? false
      public? true
      sensitive? true
    end

    attribute :hashed_password, :string do
      allow_nil? true
      public? false
      sensitive? true
    end

    attribute :role, :atom do
      description "The role of the user, user: normal user, customer: paid user, support: support, admin: admin"
      allow_nil? false
      default :user
      update_default :user
      constraints one_of: [:user, :customer, :support, :admin]
    end
  end

  identities do
    identity :unique_email, [:email]
  end
end
