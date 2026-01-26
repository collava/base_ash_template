defmodule AshBaseTemplateWeb.Components.NewsletterForm do
  @moduledoc false
  use AshBaseTemplateWeb, :live_component

  alias AshBaseTemplate.Notifiers

  def render(assigns) do
    ~H"""
    <div class="shadow-lg w-content p-4 rounded-lg bg-transparent">
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

  def handle_event("subscribe", %{"newsletter" => %{"email" => email}}, socket) do
    case Notifiers.subscribe_to_newsletter(email) do
      {:ok, _newsletter} ->
        {:noreply,
         socket
         |> put_flash(:info, "Please check your email to confirm your subscription.")
         |> push_navigate(to: "/")}

      {:error, %Ash.Error.Invalid{errors: [%{field: :email, message: "has already been taken"}]}} ->
        case Notifiers.get_subscriber_by_email(email) do
          {:ok, subscriber} when subscriber.confirmed ->
            {:noreply,
             socket
             |> put_flash(:info, "You are already subscribed to our newsletter.")
             |> push_navigate(to: "/")}

          {:ok, _subscriber} ->
            {:noreply,
             socket
             |> put_flash(
               :info,
               "You are already subscribed. We are waiting for you to confirm your subscription. Please check your email."
             )
             |> push_navigate(to: "/")}

          _ ->
            {:noreply,
             socket
             |> put_flash(:error, "Something went wrong. Please try again.")
             |> push_navigate(to: "/")}
        end

      {:error, _changeset} ->
        form = to_form(%{"email" => email}, as: :newsletter)
        {:noreply, assign(socket, :form, form)}
    end
  end
end
