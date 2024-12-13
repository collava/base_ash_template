# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

alias AshMoney.Types.Money

config :ash,
  include_embedded_source_by_default?: false,
  default_page_type: :keyset,
  policies: [no_filter_static_forbidden_reads?: false],
  known_types: [Money],
  custom_types: [money: Money]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  reet: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    # Build-time config (config/{config, dev, test, prod}.exs)
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :ex_cldr, default_backend: Reet.Cldr

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mime,
  extensions: %{"json" => "application/vnd.api+json"},
  types: %{"application/vnd.api+json" => ["json"]}

config :phoenix, :json_library, Jason

config :reet, Oban,
  queues: [default: 10, mailers: 20, events: 50, media: 5, imports: 40],
  repo: Reet.Repo

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :reet, Reet.Mailer, adapter: Swoosh.Adapters.Local

config :reet, ReetWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ReetWeb.ErrorHTML, json: ReetWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Reet.PubSub,
  live_view: [signing_salt: "PIXqUKf8"]

config :reet,
  ash_domains: [Reet.Accounts, Reet.Blog]

config :reet,
  ecto_repos: [Reet.Repo],
  generators: [timestamp_type: :utc_datetime]

config :spark,
  formatter: [
    remove_parens?: true,
    "Ash.Resource": [
      section_order: [
        :json_api,
        :authentication,
        :tokens,
        :postgres,
        :resource,
        :code_interface,
        :actions,
        :policies,
        :pub_sub,
        :preparations,
        :changes,
        :validations,
        :multitenancy,
        :attributes,
        :relationships,
        :calculations,
        :aggregates,
        :identities
      ]
    ],
    "Ash.Domain": [
      section_order: [:json_api, :resources, :policies, :authorization, :domain, :execution]
    ]
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  reet: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :tower, :reporters, [TowerEmail, TowerSentry]

config :tower_email,
  otp_app: :reet,
  from: {"Errors", "no-reply@reet.com"},
  to: "monitoring@reet.com"

import_config "#{config_env()}.exs"
