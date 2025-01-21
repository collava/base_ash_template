defmodule AshBaseTemplate.Utilities.Url do
  @moduledoc false
  def merge_base_url(path) do
    AshBaseTemplateWeb.Endpoint.url() <> path
  end
end
