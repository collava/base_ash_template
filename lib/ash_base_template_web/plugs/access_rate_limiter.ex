defmodule AshBaseTemplateWeb.Plugs.AccessRateLimiter do
  @moduledoc false
  import Plug.Conn

  alias AshBaseTemplate.RateLimit

  require Logger

  @scale :timer.minutes(1)
  @limit 300
  # half the amount of logged users
  @anonymous_limit max(div(@limit, 2), 1)
  # RateLimit.hit/3 returns retry-after values in milliseconds, so convert to seconds
  @milliseconds_per_second 1000

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{current_user: %{id: user_id}}} = conn, _opts) do
    handle_rate_limit(conn, "access:#{user_id}", @limit)
  end

  def call(conn, _opts) do
    handle_rate_limit(
      conn,
      "access:anonymous:#{format_remote_ip(conn.remote_ip)}",
      @anonymous_limit
    )
  end

  defp handle_rate_limit(conn, key, limit) do
    case RateLimit.hit(key, @scale, limit) do
      {:allow, _count} ->
        conn

      {:deny, retry_after_ms} ->
        retry_after_seconds = Integer.to_string(div(retry_after_ms, @milliseconds_per_second))
        Logger.warning("Rate limit exceeded for #{key}, retry after #{retry_after_seconds}s")

        conn
        |> put_resp_header("retry-after", retry_after_seconds)
        |> send_resp(429, "Too Many Requests")
        |> halt()
    end
  end

  defp format_remote_ip(nil), do: "unknown"

  defp format_remote_ip(remote_ip) do
    case :inet.ntoa(remote_ip) do
      {:error, _reason} -> "unknown"
      ip -> to_string(ip)
    end
  end
end
