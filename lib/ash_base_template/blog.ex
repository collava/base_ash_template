defmodule AshBaseTemplate.Blog do
  @moduledoc false
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  # Define an interface for calling resource actions.
  resources do
    resource AshBaseTemplate.Blog.Post do
      define :create_post, action: :create
      define :list_posts, action: :read
      define :archived_posts, action: :archived
      define :update_post, action: :update
      define :destroy_post, action: :destroy
      define :get_post, args: [:id], action: :by_id
    end
  end
end
