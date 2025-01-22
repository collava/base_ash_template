defmodule AshBaseTemplateWeb.NewsletterController do
  use AshBaseTemplateWeb, :controller

  alias AshBaseTemplate.Notifiers
  alias AshBaseTemplate.Notifiers.Newsletter

  def confirm(conn, %{"token" => token}) do
    case Phoenix.Token.verify(AshBaseTemplateWeb.Endpoint, "newsletter_confirmation", token, max_age: 86_400) do
      {:ok, id} ->
        newsletter = Ash.get!(Newsletter, id)

        case Notifiers.confirm_newsletter_subscription(newsletter) do
          {:ok, _newsletter} ->
            conn
            |> put_flash(:info, "Newsletter subscription confirmed successfully!")
            |> redirect(to: ~p"/")

          {:error, _} ->
            conn
            |> put_flash(:error, "Error confirming subscription. Please try again.")
            |> redirect(to: ~p"/")
        end

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid or expired confirmation link")
        |> redirect(to: ~p"/")
    end
  end

  def unsubscribe(conn, %{"token" => token}) do
    case Phoenix.Token.verify(AshBaseTemplateWeb.Endpoint, "newsletter_unsubscribe", token, max_age: 31_536_000) do
      {:ok, id} ->
        newsletter = Ash.get!(Newsletter, id)

        case Notifiers.unsubscribe_from_newsletter(newsletter) do
          {:ok, _newsletter} ->
            conn
            |> put_flash(:info, "Successfully unsubscribed from the newsletter.")
            |> redirect(to: ~p"/")

          {:error, _} ->
            conn
            |> put_flash(:error, "Error processing unsubscribe request. Please try again.")
            |> redirect(to: ~p"/")
        end

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid or expired unsubscribe link")
        |> redirect(to: ~p"/")
    end
  end
end
