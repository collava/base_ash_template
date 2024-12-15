defmodule AshBaseTemplate.Repo.Migrations.Roles do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:users) do
      add :role, :text, null: false, default: "user"
    end
  end

  def down do
    alter table(:users) do
      remove :role
    end
  end
end
