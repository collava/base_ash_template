defmodule AshBaseTemplateWeb.NewsletterController do
  use AshBaseTemplateWeb, :controller

  alias AshBaseTemplate.Communitcations
  alias AshBaseTemplate.Communitcations.Newsletter

  def confirm(conn, %{"token" => token}) do
    case Phoenix.Token.verify(AshBaseTemplateWeb.Endpoint, "newsletter_confirmation", token, max_age: 86_400) do
      {:ok, id} ->
        case Newsletters.get!(Newsletter, id) do
          %Newsletter{} = newsletter ->
            newsletter
            |> Ash.Changeset.for_update(:confirm, %{token: token})
            |> Newsletters.update!()

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
        case Newsletters.get!(Newsletter, id) do
          %Newsletter{} = newsletter ->
            newsletter
            |> Ash.Changeset.for_update(:unsubscribe, %{token: token})
            |> Newsletters.update!()

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
