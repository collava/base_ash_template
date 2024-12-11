# lib/my_ash_phoenix_app_web/posts_live.ex

defmodule ReetWeb.PostsLive do
  use ReetWeb, :live_view

  alias Reet.Blog
  alias Reet.Blog.Post

  def render(assigns) do
    ~H"""
    <h2 class="text-xl text-center">Your Posts</h2>
    <div class="my-4">
      <div :if={Enum.empty?(@posts)} class="font-bold text-center">
        No posts created yet
      </div>
      <ol class="list-decimal">
        <li :for={post <- @posts} class="mt-4">
          <div class="font-bold"><%= post.title %></div>
          <div><%= if Map.get(post, :content), do: post.content, else: "" %></div>
          <button
            class="mt-2 p-2 bg-black text-white rounded-md"
            phx-click="delete_post"
            phx-value-post-id={post.id}
          >
            Delete post
          </button>
        </li>
      </ol>
    </div>
    <h2 class="mt-8 text-lg">Create Post</h2>
    <.form :let={f} for={@create_form} phx-submit="create_post">
      <.input type="text" field={f[:title]} placeholder="input title" />
      <.button class="mt-2" type="submit">Create</.button>
    </.form>
    <h2 class="mt-8 text-lg">Update Post</h2>
    <.form :let={f} for={@update_form} phx-submit="update_post">
      <.label>Post Name</.label>
      <.input type="select" field={f[:post_id]} options={@post_selector} />
      <.input type="text" field={f[:content]} placeholder="input content" />
      <.button class="mt-2" type="submit">Update</.button>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    posts = Blog.list_posts!()

    socket =
      assign(socket,
        posts: posts,
        post_selector: post_selector(posts),
        create_form: AshPhoenix.Form.for_create(Post, :create) |> to_form(),
        update_form: AshPhoenix.Form.for_update(List.first(posts, %Post{}), :update) |> to_form()
      )

    {:ok, socket}
  end

  def handle_event("delete_post", %{"post-id" => post_id}, socket) do
    post_id |> Blog.get_post!() |> Blog.destroy_post!()
    posts = Blog.list_posts!()

    {:noreply, assign(socket, posts: posts, post_selector: post_selector(posts))}
  end

  def handle_event("create_post", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.create_form, params: form_params) do
      {:ok, _post} ->
        posts = Blog.list_posts!()

        {:noreply, assign(socket, posts: posts, post_selector: post_selector(posts))}

      {:error, create_form} ->
        {:noreply, assign(socket, create_form: create_form)}
    end
  end

  def handle_event("update_post", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.update_form, params: form_params) do
      {:ok, _post} ->
        posts = Blog.list_posts!()

        {:noreply, assign(socket, posts: posts, post_selector: post_selector(posts))}

      {:error, update_form} ->
        {:noreply, assign(socket, update_form: update_form)}
    end
  end

  defp post_selector(posts) do
    for post <- posts do
      {post.title, post.id}
    end
  end
end
