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

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ash_base_template, AshBaseTemplate.Mailer, adapter: Swoosh.Adapters.Local
config :ash_base_template, AshBaseTemplate.Repo, migration_foreign_key: [type: :binary_id]
config :ash_base_template, AshBaseTemplate.Repo, migration_primary_key: [type: :binary_id]
config :ash_base_template, AshBaseTemplate.Repo, migration_timestamps: [type: :utc_datetime_usec]

config :ash_base_template, AshBaseTemplateWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: AshBaseTemplateWeb.ErrorHTML, json: AshBaseTemplateWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AshBaseTemplate.PubSub,
  live_view: [signing_salt: "PIXqUKf8"]

config :ash_base_template, Oban,
  queues: [default: 10, mailers: 20, events: 50, media: 5, imports: 40, post_destroy_forever: 30],
  repo: AshBaseTemplate.Repo,
  plugins: [{Oban.Plugins.Cron, []}]

config :ash_base_template,
  ash_domains: [AshBaseTemplate.Accounts, AshBaseTemplate.Blog, AshBaseTemplate.Notifiers]

config :ash_base_template,
  ecto_repos: [AshBaseTemplate.Repo],
  generators: [timestamp_type: :utc_datetime]

# ErrorTracker.add_breadcrumb("Executed my super secret code")
config :error_tracker,
  repo: AshBaseTemplate.Repo,
  otp_app: :ash_base_template,
  enabled: true,
  # remove resolved after 1 week
  plugins: [{ErrorTracker.Plugins.Pruner, max_age: :timer.hours(168)}]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  ash_base_template: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    # Build-time config (config/{config, dev, test, prod}.exs)
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :ex_cldr, default_backend: AshBaseTemplate.Cldr

config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 60 * 4, cleanup_interval_ms: 60_000 * 10]}

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mime,
  extensions: %{"json" => "application/vnd.api+json"},
  types: %{"application/vnd.api+json" => ["json"]}

config :phoenix, :json_library, Jason

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
  ash_base_template: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :tower, :reporters, [TowerEmail, TowerSentry, TowerHoneybadger]

config :tower_email,
  otp_app: :ash_base_template,
  from: {"Errors", "no-reply@ash_base_template.com"},
  to: "monitoring@ash_base_template.com"

import_config "#{config_env()}.exs"
