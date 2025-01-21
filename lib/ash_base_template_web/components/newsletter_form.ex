defmodule AshBaseTemplateWeb.Components.NewsletterForm do
  @moduledoc false
  use AshBaseTemplateWeb, :live_component

  alias AshBaseTemplate.Communications
  alias AshBaseTemplate.Communications.Newsletter

  def render(assigns) do
    ~H"""
    <div class="shadow-lg w-content p-4 rounded-lg">
      <.form for={@form} phx-submit="subscribe" phx-target={@myself} class="space-y-4">
        <div>
          <.label>Subscribe to our newsletter</.label>
          <div class="mt-2 flex flex-start items-center">
            <.input
              type="email"
              name={@form[:email].name}
              value={@form[:email].value}
              required
              placeholder="Enter your email"
              class="rounded-none rounded-l-lg"
            />
            <.button class="rounded-none rounded-r-lg border border-zinc-900">Subscribe</.button>
          </div>
          <.error :for={error <- @form[:email].errors}>{error}</.error>
        </div>
      </.form>
    </div>
    """
  end

  def update(assigns, socket) do
    form = to_form(%{"email" => ""}, as: :newsletter)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:form, form)}
  end

  def handle_event("subscribe", %{"newsletter" => params}, socket) do
    case Communications.create(Newsletter, :subscribe, params) do
      {:ok, _newsletter} ->
        {:noreply,
         socket
         |> put_flash(:info, "Please check your email to confirm your subscription.")
         |> push_navigate(to: "/")}

      {:error, changeset} ->
        form = to_form(%{"email" => params["email"]}, as: :newsletter)
        {:noreply, assign(socket, :form, form)}
    end
  end
end
