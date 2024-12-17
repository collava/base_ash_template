defmodule AshBaseTemplate.Blog do
  @moduledoc false
  use Ash.Domain, extensions: [AshAdmin.Domain, AshJsonApi.Domain]

  alias AshBaseTemplate.Blog.Post

  admin do
    show?(true)
  end

  # https://hexdocs.pm/ash_json_api/getting-started-with-ash-json-api.html
  # this can also be defined in the resource
  json_api do
    routes do
      base_route "/posts", Post do
        get :by_id
        index :read
        patch :update
        delete :destroy
        # related :comments, :read
        # relationship :comments, :read
        # post_to_relationship :comments
        # patch_relationship :comments
        # delete_from_relationship :comments
      end
    end
  end

  # Define an interface for calling resource actions.
  resources do
    resource Post do
      define :create_post, action: :create
      define :list_posts, action: :read
      define :archived_posts, action: :archived
      define :update_post, action: :update
      define :destroy_post, action: :destroy
      define :get_post, args: [:id], action: :by_id
    end
  end
end
