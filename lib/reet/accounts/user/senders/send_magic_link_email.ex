defmodule Reet.Accounts.User.Senders.SendMagicLinkEmail do
  @moduledoc """
  Sends a magic link email
  """

  use AshAuthentication.Sender
  use ReetWeb, :verified_routes

  @impl true
  def send(user_or_email, token, _) do
    Reet.Accounts.Emails.deliver_magic_link_email(
      user_or_email,
      url(~p"/auth/user/magic_link/?token=#{token}")
    )
  end
end
