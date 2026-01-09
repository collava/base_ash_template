defmodule AshBaseTemplate.MixProject do
  use Mix.Project

  @version "0.1.4"

  def project do
    [
      app: :ash_base_template,
      version: @version,
      elixir: "~> 1.19.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      deps: deps()
    ]
  end

  def cli do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.lcov": :test,
        "coveralls.json": :test,
        "coveralls.github": :test,
        "coveralls.xml": :test,
        "test.watch": :test,
        "mneme.watch": :test,
        "mneme.test": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AshBaseTemplate.Application, []},
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
      {:ash_admin, "~> 0.13"},
      {:ash_archival, "~> 2.0"},
      {:ash_authentication_phoenix, "~> 2.14"},
      {:ash_authentication, "~> 4.13"},
      {:ash_cloak, "~> 0.1"},
      {:ash_double_entry, "~> 1.0"},
      {:ash_csv, "~> 0.9"},
      {:ash_graphql, "~> 1.8"},
      {:ash_json_api, "~> 1.5"},
      {:ash_money, "~> 0.2"},
      {:ash_oban, "~> 0.7"},
      {:ash_phoenix, "~> 2.3"},
      {:ash_postgres, "~> 2.6"},
      {:ash, "~> 3.12"},
      {:bandit, "~> 1.5"},
      {:bcrypt_elixir, "~> 3.0"},
      {:dns_cluster, "~> 0.2"},
      {:ecto_dev_logger, "~> 0.14", only: :dev},
      {:ecto_sql, "~> 3.10"},
      {:esbuild, "~> 0.10", runtime: Mix.env() == :dev},
      {:ex_money_sql, "~> 1.0"},
      {:finch, "~> 0.19"},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.26"},
      {:hackney, "~> 1.20"},
      {:heroicons,
       github: "tailwindlabs/heroicons", tag: "v2.2.0", sparse: "optimized", app: false, compile: false, depth: 1},
      {:igniter, "~> 0.7", override: true},
      {:jason, "~> 1.2"},
      {:oban, "~> 2.18"},
      {:oban_live_dashboard, "~> 0.2.0"},
      {:open_api_spex, "~> 3.21"},
      {:opentelemetry_api, "~> 1.5"},
      {:opentelemetry_bandit, "~> 0.3"},
      {:opentelemetry_ecto, "~> 1.2"},
      {:opentelemetry_phoenix, "~> 2.0"},
      {:opentelemetry_req, "~> 1.0"},
      {:phoenix_ecto, "~> 4.7"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_dashboard, "~> 0.8"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.1"},
      {:phoenix, "~> 1.8"},
      {:picosat_elixir, "~> 0.2"},
      {:postgrex, ">= 0.0.0"},
      {:rename_project, "~> 0.1.0", only: :dev},
      {:swoosh, "~> 1.5"},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, " ~>1.0"},

      # tests
      {:ex_check, "~> 0.16.0", only: [:dev], runtime: false},
      {:ex_unit_notifier, "~> 1.3", only: :test},
      {:excoveralls, "~> 0.18", only: :test, runtime: false},
      {:mix_test_watch, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mneme, ">= 0.0.0", only: [:dev, :test]},
      {:mox, "~> 1.2", only: :test},
      {:phoenix_test, "~> 0.9.1", only: :test, runtime: false},
      {:smokestack, "~> 0.9"},

      # security
      {:cors_plug, "~> 3.0"},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:hammer, "~> 7.0", override: true},
      {:hammer_plug, "~> 3.2"},

      # code quality
      {:circular_buffer, "~> 1.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:credo_binary_patterns, "~> 0.2.3", only: [:dev, :test], runtime: false},
      {:credo_mox, "~> 0.1", only: [:dev, :test], runtime: false},
      {:credo_naming, "~> 2.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:styler, "~> 1.10", only: [:dev, :test], runtime: false},

      # error reporting
      {:error_tracker, "~> 0.7"},
      {:tower, "~> 0.8", override: true},
      {:tower_email, "~> 0.6"},
      {:tower_error_tracker, "~> 0.3"},
      {:tower_honeybadger, "~> 0.3"},
      {:tower_sentry, "~> 0.3"}
    ]
  end

  defp aliases do
    [
      "phx.routes": ["phx.routes", "ash_authentication.phx.routes"],
      setup: ["deps.get", "ash.setup", "assets.setup", "assets.build", "run priv/repo/seeds.exs"],
      "ecto.setup": ["ash.setup", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ash.reset"],
      # "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      # "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ash.setup --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind ash_base_template", "esbuild ash_base_template"],
      "assets.deploy": [
        "tailwind ash_base_template --minify",
        "esbuild ash_base_template --minify",
        "phx.digest"
      ]
    ]
  end
end
