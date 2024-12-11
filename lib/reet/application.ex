defmodule Reet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ReetWeb.Telemetry,
      Reet.Repo,
      {DNSCluster, query: Application.get_env(:reet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Reet.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Reet.Finch},
      # Start a worker by calling: Reet.Worker.start_link(arg)
      # {Reet.Worker, arg},
      # Start to serve requests, typically the last entry
      ReetWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :reet]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Reet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
