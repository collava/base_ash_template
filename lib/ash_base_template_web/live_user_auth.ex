defmodule AshBaseTemplateWeb.LiveUserAuth do
  @moduledoc """
  Helpers for authenticating users in LiveViews.
  """

  use AshBaseTemplateWeb, :verified_routes

  import Phoenix.Component

  alias AshBaseTemplate.Accounts

  def on_mount(:live_user_optional, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:cont, assign(socket, :current_user, nil)}
    end
  end

  def on_mount(:live_user_required, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/sign-in")}
    end
  end

  def on_mount(:live_no_user, _params, _session, socket) do
    if socket.assigns[:current_user] do
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
    else
      {:cont, assign(socket, :current_user, nil)}
    end
  end

  def on_mount(:admins_only, _params, %{"user" => user} = _session, socket) do
    if socket.assigns[:current_user] && socket.assigns[:current_user].role == :admin do
      {:cont, socket}
    else
      user_id = user |> String.split("?id=") |> List.last()
      user = Accounts.get_user!(user_id)
      socket = assign(socket, current_user: user)

      if user.role == :admin do
        {:cont, socket}
      else
        {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/sign-in")}
      end
    end
  end
end
