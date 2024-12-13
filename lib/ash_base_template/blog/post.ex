defmodule AshBaseTemplate.Blog.Post do
  # Using Ash.Resource turns this module into an Ash resource.
  @moduledoc false
  use Ash.Resource,
    # Tells Ash where the generated code interface belongs
    domain: AshBaseTemplate.Blog,
    # Tells Ash you want this resource to store its data in Postgres.
    data_layer: AshPostgres.DataLayer,
    extensions: [AshArchival.Resource],
    authorizers: [
      Ash.Policy.Authorizer
    ]

  # The Postgres keyword is specific to the AshPostgres module.
  postgres do
    # Tells Postgres what to call the table
    table "posts"
    # Tells Ash how to interface with the Postgres table
    repo AshBaseTemplate.Repo
  end

  # The primary? flag just tells Ash "this is a standard action that should use our authorization policies"
  actions do
    # Exposes default built in actions to manage the resource
    defaults [:read]

    create :create do
      primary? true
      accept [:title]

      # Add the user argument that will be managed by the relationship
      argument :user, :map do
        allow_nil? false
      end

      # Change to use the user argument
      change manage_relationship(:user, type: :append_and_remove)
    end

    update :update do
      accept [:content]
      primary? true
    end

    destroy :destroy do
      primary? true
    end

    # Defines custom read action which fetches post by id.
    read :by_id do
      # This action has one argument :id of type :uuid
      argument :id, :uuid, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter expr(id == ^arg(:id))
    end
  end

  policies do
    # Anyone can read posts
    policy action(:read) do
      authorize_if always()
    end

    # Must be logged in to create posts
    policy action(:create) do
      authorize_if actor_present()
    end

    # Can only update/destroy your own posts
    policy action([:update, :destroy]) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  # Attributes are simple pieces of data that exist in your resource
  attributes do
    # Add an autogenerated UUID primary key called `:id`.
    uuid_primary_key :id
    # Add a string type attribute called `:title`
    attribute :title, :string do
      # We don't want the title to ever be `nil`
      allow_nil? false
    end

    # Add a string type attribute called `:content`
    # If allow_nil? is not specified, then content can be nil
    attribute :content, :string

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, AshBaseTemplate.Accounts.User do
      attribute_writable? true
      allow_nil? false
    end
  end
end
