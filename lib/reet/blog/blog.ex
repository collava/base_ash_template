defmodule Reet.Blog do
  use Ash.Domain

  # Define an interface for calling resource actions.
  resources do
    resource Reet.Blog.Post do
      define :create_post, action: :create
      define :list_posts, action: :read
      define :update_post, action: :update
      define :destroy_post, action: :destroy
      define :get_post, args: [:id], action: :by_id
    end
  end
end
