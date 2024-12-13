defmodule Reet.Accounts.User.Senders.SendPasswordResetEmail do
  @moduledoc """
  Sends a password reset email
  """

  use AshAuthentication.Sender
  use ReetWeb, :verified_routes

  alias Reet.Accounts.Emails

  @impl true
  def send(user, token, _) do
    Emails.deliver_reset_password_instructions(
      user,
      url(~p"/password-reset/#{token}")
    )
  end
end
