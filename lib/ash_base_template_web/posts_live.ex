# lib/my_ash_phoenix_app_web/posts_live.ex

defmodule AshBaseTemplateWeb.PostsLive do
  @moduledoc false
  use AshBaseTemplateWeb, :live_view

  alias AshBaseTemplate.Blog
  alias AshBaseTemplate.Blog.Post

  def render(assigns) do
    ~H"""
    <h2 class="text-xl text-center">Your Posts</h2>
    <div class="my-4">
      <div :if={Enum.empty?(@posts)} class="font-bold text-center">
        No posts created yet
      </div>
      <ol class="list-decimal">
        <li :for={post <- @posts} class="mt-4">
          <div class="font-bold">{post.title}</div>
          <div>{if Map.get(post, :content), do: post.content, else: ""}</div>
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

    <div>
      <h2 class="mt-8 text-lg">Create Post</h2>
      <.form :let={f} for={@create_form} phx-submit="create_post">
        <.input type="text" field={f[:title]} placeholder="input title" />
        <.button class="mt-2" type="submit">Create</.button>
      </.form>
    </div>

    <div>
      <h2 class="mt-8 text-lg">Update Post</h2>
      <.form :let={f} for={@update_form} phx-submit="update_post" phx-change="select_post">
        <.label>Post Name</.label>
        <.input type="select" field={f[:post_id]} options={@post_selector} />
        <.input type="text" field={f[:content]} placeholder="input content" />
        <.button class="mt-2" type="submit">Update</.button>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    posts = Blog.list_posts!()
    selected_post = List.first(posts) || %Post{}

    socket =
      assign(socket,
        posts: posts,
        selected_post: selected_post,
        post_selector: post_selector(posts),
        create_form:
          Post
          |> AshPhoenix.Form.for_create(:create, actor: socket.assigns.current_user)
          |> to_form(),
        update_form:
          selected_post
          |> AshPhoenix.Form.for_update(:update, actor: socket.assigns.current_user)
          |> to_form()
      )

    {:ok, socket}
  end

  def handle_event("delete_post", %{"post-id" => post_id}, socket) do
    post_id |> Blog.get_post!() |> Blog.destroy_post!()
    posts = Blog.list_posts!()

    {:noreply, assign(socket, posts: posts, post_selector: post_selector(posts))}
  end

  def handle_event("create_post", %{"form" => form_params}, socket) do
    form_params = Map.put(form_params, "user", socket.assigns.current_user)

    case AshPhoenix.Form.submit(
           socket.assigns.create_form,
           params: form_params
         ) do
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

  def handle_event("select_post", %{"form" => %{"post_id" => post_id}}, socket) do
    selected_post = Enum.find(socket.assigns.posts, &(&1.id == post_id))

    update_form =
      selected_post
      |> AshPhoenix.Form.for_update(:update, actor: socket.assigns.current_user)
      |> to_form()

    {:noreply, assign(socket, selected_post: selected_post, update_form: update_form)}
  end

  defp post_selector(posts) do
    for post <- posts do
      {post.title, post.id}
    end
  end
end
