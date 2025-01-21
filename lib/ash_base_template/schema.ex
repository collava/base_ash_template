defmodule AshBaseTemplate.Schema do
  @moduledoc """
  Used to define the schema for the application.

  Changing all primary keys to binary_id  and the timestamp type to utc_datetime_usec when creating a migration.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @timestamps_opts [type: :utc_datetime_usec]
    end
  end
end
