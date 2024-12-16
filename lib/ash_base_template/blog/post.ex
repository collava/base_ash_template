defmodule AshBaseTemplate.Blog.Post do
  @moduledoc false
  use Ash.Resource,
    domain: AshBaseTemplate.Blog,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshArchival.Resource, AshOban],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "posts"
    repo AshBaseTemplate.Repo
  end

  archive do
    exclude_read_actions [:archived]
    exclude_destroy_actions [:destroy_forever]
  end

  # Add the oban configuration for triggers
  oban do
    triggers do
      trigger :destroy_forever do
        # This will run on archived posts
        where expr(not is_nil(archived_at) and archived_at < ago(180, :day))
        scheduler_cron("0 0 * * *")
        action :destroy_forever
        read_action :archived
      end
    end
  end

  # The primary? flag just tells Ash "this is a standard action that should use our authorization policies"
  actions do
    defaults [:destroy]

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

    destroy :destroy_forever

    read :read do
      prepare build(load: [:user])
      primary? true
    end

    read :archived do
      prepare build(load: [:user])
      filter expr(not is_nil(archived_at))
      # necessary for oban trigger
      pagination keyset?: true
    end

    # Defines custom read action which fetches post by id.
    read :by_id do
      argument :id, :uuid_v7, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      prepare build(load: [:user])
      filter expr(id == ^arg(:id))
    end
  end

  # Policiies authorizing happens from top to bottom
  policies do
    bypass AshOban.Checks.AshObanInteraction do
      authorize_if always()
    end

    bypass actor_attribute_equals(:role, :admin) do
      description "Admins can do it all"
      authorize_if always()
    end

    policy action_type(:read) do
      description "Anyone can read non-archived posts"
      authorize_if always()
    end

    policy action(:archived) do
      description "Only customers and above can see archived posts"
      authorize_if relates_to_actor_via(:user)
    end

    policy action([:create, :by_id]) do
      description "Must be logged in to create posts"
      authorize_if actor_present()
    end

    policy action([:update, :destroy]) do
      description "Support and Admin can manage all posts, regular users can only manage their own posts"
      authorize_if relates_to_actor_via(:user)
      authorize_if actor_attribute_equals(:role, :admin)
      authorize_if actor_attribute_equals(:role, :support)
    end
  end

  # Attributes are simple pieces of data that exist in your resource
  attributes do
    # Add an autogenerated UUID primary key called `:id`.
    uuid_v7_primary_key :id
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
