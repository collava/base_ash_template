defmodule AshBaseTemplate.Accounts.User.Senders.SendMagicLinkEmail do
  @moduledoc """
  Sends a magic link email
  """

  use AshAuthentication.Sender
  use AshBaseTemplateWeb, :verified_routes

  alias AshBaseTemplate.Accounts.Emails

  @impl true
  def send(user_or_email, token, _) do
    Emails.deliver_magic_link_email(
      user_or_email,
      url(~p"/auth/user/magic_link/?token=#{token}")
    )
  end
end
