defmodule AshBaseTemplate.Accounts.User.Senders.SendNewUserConfirmationEmail do
  @moduledoc """
  Sends an email for a new user to confirm their email address.
  """

  use AshAuthentication.Sender
  use AshBaseTemplateWeb, :verified_routes

  alias AshBaseTemplate.Accounts.Emails

  @impl AshAuthentication.Sender
  def send(user, token, _opts) do
    Emails.deliver_email_confirmation_instructions(
      user,
      url(~p"/auth/user/confirm_new_user?#{[confirm: token]}")
    )
  end
end
