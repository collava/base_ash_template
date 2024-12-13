import Config

config :ash, disable_async?: true

# In test we don't send emails
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ash_base_template, AshBaseTemplate.Mailer, adapter: Swoosh.Adapters.Test

config :ash_base_template, AshBaseTemplate.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "reet_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  # We don't run a server during test. If one is required,
  # you can enable the server option below.
  pool_size: System.schedulers_online() * 2

config :ash_base_template, AshBaseTemplateWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  # Configure your database
  #
  # The MIX_TEST_PARTITION environment variable can be used
  secret_key_base: "FC4VFoxSRurl0Kah8nEpRQJ8JXbxqDH6fvO21LwVdwivcRL/2WmDS6tO9UbdgsUx",
  server: false

config :ash_base_template, token_signing_secret: "7/l0j7bh48N5Nlmebre01LveHJByHe4T"

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false
