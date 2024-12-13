defmodule Reet.MixProject do
  use Mix.Project

  def project do
    [
      app: :reet,
      version: "0.0.1",
      elixir: "~> 1.17.3-otp-27",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Reet.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:open_api_spex, "~> 3.0"},
      {:ash_authentication_phoenix, "~> 2.0"},
      {:ash_authentication, "~> 4.1"},
      {:ash_double_entry, "~> 1.0"},
      {:ash_csv, "~> 0.9"},
      {:ash_graphql, "~> 1.0"},
      {:ash_json_api, "~> 1.0"},
      {:ash_money, "~> 0.1"},
      {:ash_oban, "~> 0.2"},
      {:ash_phoenix, "~> 2.0"},
      {:ash_postgres, "~> 2.0"},
      {:ash, "~> 3.0"},
      {:bandit, "~> 1.5"},
      {:bcrypt_elixir, "~> 3.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dns_cluster, "~> 0.1"},
      {:ecto_dev_logger, "~> 0.14", only: :dev},
      {:ecto_sql, "~> 3.10"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:ex_money_sql, "~> 1.0"},
      {:finch, "~> 0.13"},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.26"},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:igniter, "~> 0.4"},
      {:jason, "~> 1.2"},
      {:oban, "~> 2.18"},
      {:opentelemetry_api, "~> 1.4"},
      {:opentelemetry_bandit, "~> 0.2.0"},
      {:opentelemetry_ecto, "~> 1.2"},
      {:opentelemetry_phoenix, "~> 2.0.0-rc.2"},
      {:phoenix_ecto, "~> 4.5"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.0"},
      {:phoenix, "~> 1.7"},
      {:picosat_elixir, "~> 0.2"},
      {:postgrex, ">= 0.0.0"},
      {:swoosh, "~> 1.5"},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"}
    ]
  end

  defp aliases do
    [
      "phx.routes": ["phx.routes", "ash_authentication.phx.routes"],
      setup: ["deps.get", "ash.setup", "assets.setup", "assets.build", "run priv/repo/seeds.exs"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ash.setup --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind reet", "esbuild reet"],
      "assets.deploy": [
        "tailwind reet --minify",
        "esbuild reet --minify",
        "phx.digest"
      ]
    ]
  end
end
