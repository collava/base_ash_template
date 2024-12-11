import Config
config :reet, token_signing_secret: "7/l0j7bh48N5Nlmebre01LveHJByHe4T"
config :ash, disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :reet, Reet.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "reet_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :reet, ReetWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "FC4VFoxSRurl0Kah8nEpRQJ8JXbxqDH6fvO21LwVdwivcRL/2WmDS6tO9UbdgsUx",
  server: false

# In test we don't send emails
config :reet, Reet.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
