# lib/ash_base_template_web/plugs/authorizer.ex
defmodule AshBaseTemplateWeb.Plugs.Authorizer do
  @moduledoc false
  import Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = conn |> get_session("user") |> String.split("?id=") |> List.last()

    case AshBaseTemplate.Accounts.get_user!(user_id) do
      %{role: :admin} = _user ->
        conn

      _ ->
        conn
        |> redirect(to: "/sign-in")
        |> halt()
    end
  rescue
    _ ->
      conn
      |> redirect(to: "/sign-in")
      |> halt()
  end
end
