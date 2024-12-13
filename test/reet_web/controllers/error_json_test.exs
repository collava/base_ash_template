defmodule AshBaseTemplateWeb.ErrorJSONTest do
  use AshBaseTemplateWeb.ConnCase, async: true

  test "renders 404" do
    assert AshBaseTemplateWeb.ErrorJSON.render("404.json", %{}) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500" do
    assert AshBaseTemplateWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
