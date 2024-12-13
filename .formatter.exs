[
  import_deps: [
    :ash_archival,
    :ash_authentication_phoenix,
    :ash_authentication,
    :ash_json_api,
    :ash_postgres,
    :ash,
    :ecto_sql,
    :ecto,
    :phoenix
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [Spark.Formatter, Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
