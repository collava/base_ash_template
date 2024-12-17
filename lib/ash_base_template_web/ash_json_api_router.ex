defmodule AshBaseTemplateWeb.AshJsonApiRouter do
  @moduledoc """
    Open api specifications, don't forget to run the command below to generate the openapi file
    mix openapi.spec.json --spec AshBaseTemplateWeb.AshJsonApiRouter

    https://hexdocs.pm/ash_json_api/open-api.html#generate-spec-files-via-cli
  """
  use AshJsonApi.Router,
    domains: [AshBaseTemplate.Blog],
    open_api: "/open_api",
    modify_open_api: {__MODULE__, :modify_open_api, []},
    open_api_file: {__MODULE__, :api_file}

  def api_file do
    if Mix.env() == :prod do
      "priv/static/open_api.json"
    end
  end

  def modify_open_api(spec, _, _) do
    %{
      spec
      | info: %{
          spec.info
          | title: "AshBaseTemplate JSON API",
            version: :ash_base_template |> Application.spec(:vsn) |> to_string()
        }
    }
  end
end
