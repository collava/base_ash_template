defmodule Reet.Accounts.User.Senders.SendDataChangeConfirmationEmail do
  @moduledoc """
  Sends an email change confirmation email
  """
  use AshAuthentication.Sender
  use ReetWeb, :verified_routes

  @impl AshAuthentication.Sender
  def send(user, token, _opts) do
    Reet.Accounts.Emails.deliver_data_change_confirmation_instructions(
      user,
      url(~p"/auth/user/confirm_change?#{[confirm: token]}")
    )
  end
end
