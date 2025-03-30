defmodule AshBaseTemplate.Notifiers.Newsletter do
  @moduledoc false

  use Ash.Resource,
    otp_app: :ash_base_template,
    domain: AshBaseTemplate.Notifiers,
    extensions: [
      AshAdmin.Resource
    ],
    data_layer: AshPostgres.DataLayer

  alias AshBaseTemplate.Notifiers.Emails

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
    end

    read :by_email do
      argument :email, :ci_string, allow_nil?: false
      filter expr(email == ^arg(:email))
      get? true
    end

    update :confirm do
      accept []

      change set_attribute(:confirmed, true)
      change set_attribute(:active, true)
    end

    update :unsubscribe do
      accept []
      change set_attribute(:active, false)
    end
  end

  changes do
    change after_transaction(fn
             changeset, {:ok, record}, _context ->
               case Emails.deliver_confirmation_instructions(record, []) do
                 {:ok, _} ->
                   {:ok, record}

                 error ->
                   {:ok, record}
               end

             changeset, {:error, reason}, _context ->
               {:error, reason}
           end),
           on: [:create]
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
      default false
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  identities do
    identity :unique_email, [:email]
  end
end
