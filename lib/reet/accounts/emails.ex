defmodule Reet.Accounts.Emails do
  @moduledoc """
  Delivers Accounts related emails.
  """

  import Swoosh.Email

  def deliver_reset_password_instructions(user, url) do
    if !url do
      raise "Cannot deliver reset instructions without a url"
    end

    IO.puts("""
    Click this link to reset your password:

    #{url}
    """)

    deliver(user.email, "Reset Your Password", """
    <html>
      <p>
        Hi #{user.email},
      </p>

      <p>
        <a href="#{url}">Click here</a> to reset your password.
      </p>

      <p>
        If you didn't request this change, please ignore this.
      </p>
    <html>
    """)
  end

  def deliver_email_confirmation_instructions(user, url) do
    if !url do
      raise "Cannot deliver confirmation instructions without a url"
    end

    IO.puts("""
    Click this link to confirm your email:

    #{url}
    """)

    deliver(user.email, "Confirm your email address", """
      <p>
        Hi #{user.email},
      </p>

      <p>
        Someone has tried to register a new account using this email address.
        If it was you, then please click the link below to confirm your identity. If you did not initiate this request then please ignore this email.
      </p>

      <p>
        <a href="#{url}">Click here to confirm your account</a>
      </p>
    """)
  end

  def deliver_magic_link_email(user_or_email, url) do
    if !url do
      raise "Cannot deliver magic link instructions without a url"
    end

    # if you get a user, its for a user that already exists
    # if you get an email, the user does not exist yet
    email =
      case user_or_email do
        %{email: email} -> email
        email -> email
      end

    IO.puts("""
    Click this link to sign in:

    #{url}
    """)

    deliver(email, "Sign in with magic link", """
    <p>
      Hello, #{email}!
    </p>

    <p>
      <a href="#{url}">Click here to sign in</a>
    </p>
    """)
  end

  def deliver_data_change_confirmation_instructions(user, url) do
    if !url do
      raise "Cannot deliver confirmation instructions without a url"
    end

    deliver(user.email, "Confirm your new email address", """
      <p>
        Hi #{user.email},
      </p>

      <p>
        You recently changed your data. Please confirm it.
      </p>

      <p>
        <a href="#{url}">Click here to confirm your new email address</a>
      </p>
    """)
  end

  # For simplicity, this module simply logs messages to the terminal.
  # You should replace it by a proper email or notification tool, such as:
  #
  #   * Swoosh - https://hexdocs.pm/swoosh
  #   * Bamboo - https://hexdocs.pm/bamboo
  #
  defp deliver(to, subject, body) do
    IO.puts("Sending email to #{to} with subject #{subject} and body #{body}")

    new()
    |> from({"Rene", "rene@reet.com.br"})
    |> to(to_string(to))
    |> subject(subject)
    |> put_provider_option(:track_links, "None")
    |> html_body(body)
    |> Reet.Mailer.deliver!()
  end
end
