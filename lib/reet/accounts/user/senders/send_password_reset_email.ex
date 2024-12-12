defmodule Reet.Accounts.User.Senders.SendPasswordResetEmail do
  @moduledoc """
  Sends a password reset email
  """

  use AshAuthentication.Sender

  @impl true
  def send(user, token, _) do
    Reet.Accounts.Emails.deliver_reset_password_instructions(
      user,
      token
    )
  end
end
