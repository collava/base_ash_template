defmodule AshBaseTemplate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    OpentelemetryPhoenix.setup(adapter: :bandit)
    maybe_install_ecto_dev_logger()
    Oban.Telemetry.attach_default_logger()

    children = [
      AshBaseTemplateWeb.Telemetry,
      AshBaseTemplate.Repo,
      {DNSCluster, query: Application.get_env(:ash_base_template, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AshBaseTemplate.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AshBaseTemplate.Finch},
      # Start a worker by calling: AshBaseTemplate.Worker.start_link(arg)
      # {AshBaseTemplate.Worker, arg},
      # Start to serve requests, typically the last entry
      AshBaseTemplateWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :ash_base_template]},
      {Oban,
       AshOban.config(
         Application.fetch_env!(:ash_base_template, :ash_domains),
         Application.fetch_env!(:ash_base_template, Oban)
       )}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AshBaseTemplate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AshBaseTemplateWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  if Code.ensure_loaded?(Ecto.DevLogger) do
    defp maybe_install_ecto_dev_logger, do: Ecto.DevLogger.install(AshBaseTemplate.Repo)
  else
    defp maybe_install_ecto_dev_logger, do: :ok
  end
end
