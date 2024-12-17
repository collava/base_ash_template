defmodule AshBaseTemplateWeb.AshJsonApiRouter do
  @moduledoc """
    Open api specifications, don't forget to run the command below to generate the openapi file
    mix openapi.spec.json --spec AshBaseTemplateWeb.AshJsonApiRouter

    https://hexdocs.pm/ash_json_api/open-api.html#generate-spec-files-via-cli
  """
  use AshJsonApi.Router,
    domains: [AshBaseTemplate.Blog],
    open_api: "/open_api",
    modify_open_api: {__MODULE__, :modify_open_api, []}

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

  # open_api_file: "priv/static/system/openapi.json"

  # open_api_version: "1.0.0",
  # open_api_servers: ["http://domain.com/api/v1"]
end
