defmodule AshBaseTemplate.Communitcations.Newsletter do
  @moduledoc false

  use Ash.Resource,
    otp_app: :ash_base_template,
    domain: AshBaseTemplate.Communitcations,
    extensions: [
      AshAdmin.Resource
    ],
    data_layer: AshPostgres.DataLayer

  alias AshBaseTemplate.Communitcations.Emails

  admin do
    actor?(true)
  end

  postgres do
    table "newsletters"
    repo AshBaseTemplate.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    create :subscribe do
      primary? true
      accept [:email]

      change set_attribute(:active, true)
      change set_attribute(:confirmed, false)

      after_transaction(fn _result, changeset ->
        newsletter = Ash.Changeset.get_record(changeset)
        Emails.deliver_confirmation_instructions(newsletter, [])
        :ok
      end)
    end

    update :confirm do
      accept []
      argument :token, :string, allow_nil?: false

      change set_attribute(:confirmed, true)
    end

    update :unsubscribe do
      accept []
      argument :token, :string, allow_nil?: false

      change set_attribute(:active, false)
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :confirmed, :boolean do
      allow_nil? false
      default false
    end

    attribute :active, :boolean do
      allow_nil? false
      default true
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  identities do
    identity :unique_email, [:email]
  end
end
