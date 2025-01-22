defmodule AshBaseTemplate.FeatureCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      use AshBaseTemplate, :verified_routes

      import AshBaseTemplate.FeatureCase
      import PhoenixTest
    end
  end

  setup tags do
    pid = Sandbox.start_owner!(AshBaseTemplate.Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
