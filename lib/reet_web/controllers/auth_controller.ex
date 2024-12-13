defmodule ReetWeb.AuthController do
  use ReetWeb, :controller
  use AshAuthentication.Phoenix.Controller

  def success(conn, activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/"

    message =
      case activity do
        {:confirm_new_user, :confirm} -> "Your email address has now been confirmed"
        {:password, :reset} -> "Your password has successfully been reset"
        _ -> "You are now signed in"
      end

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    # If your resource has a different name, update the assign name here (i.e :current_admin)
    |> assign(:current_user, user)
    |> put_flash(:info, message)
    |> redirect(to: return_to)
  end

  def failure(conn, activity, _reason) do
    message =
      case activity do
        {:magic_link, :sign_in} ->
          "You can't sign in with a magic link, because you're regitered with a password and did not confirm your account. Please check your email for a confirmation link."

        _ ->
          "Incorrect email or password"
      end

    conn
    |> put_flash(:error, message)
    |> redirect(to: ~p"/sign-in")
  end

  def sign_out(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> clear_session()
    |> put_flash(:info, "You are now signed out")
    |> redirect(to: return_to)
  end
end
