defmodule AshBaseTemplate.Communications.Emails do
  @moduledoc """
  Delivers Newsletter related emails.
  """
  import Swoosh.Email

  alias AshBaseTemplate.Utilities.Url

  @unsubscribe_url "newsletters/unsubscribe"
  @confirm_url "newsletters/confirm"

  def deliver_confirmation_instructions(newsletter, _opts) do
    deliver(newsletter.email, "Confirm your newsletter subscription", """
    <html>
      <p>
        Hi,
      </p>

      <p>
        Thank you for subscribing to our newsletter! Please confirm your subscription by clicking the link below:
      </p>

      <p>
        <a href="#{generate_confirm_link(newsletter)}">Click here to confirm your subscription</a>
      </p>

      <p>
        If you didn't request this subscription, please ignore this email or <a href="#{generate_unsubscribe_link(newsletter)}">click here to unsubscribe</a>.
      </p>
    </html>
    """)
  end

  def deliver_newsletter(newsletter, subject, content) do
    deliver(newsletter.email, subject, """
    <html>
      #{content}

      <hr/>
      <p style="font-size: 12px; color: #666;">
        Don't want to receive these emails? <a href="#{generate_unsubscribe_link(newsletter)}">Unsubscribe here</a>
      </p>
    </html>
    """)
  end

  defp deliver(to, subject, body) do
    new()
    |> from({"Newsletter", "newsletter@ash_base_template.com"})
    |> to(to_string(to))
    |> subject(subject)
    |> put_provider_option(:track_links, "None")
    |> html_body(body)
    |> AshBaseTemplate.Mailer.deliver!()
  end

  defp generate_unsubscribe_link(newsletter) do
    token =
      Phoenix.Token.sign(AshBaseTemplateWeb.Endpoint, "newsletter_unsubscribe", newsletter.id)

    Url.merge_base_url("/#{@unsubscribe_url}/#{token}")
  end

  defp generate_confirm_link(newsletter) do
    token =
      Phoenix.Token.sign(AshBaseTemplateWeb.Endpoint, "newsletter_confirmation", newsletter.id)

    Url.merge_base_url("/#{@confirm_url}/#{token}")
  end
end
