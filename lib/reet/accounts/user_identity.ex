defmodule Reet.Accounts.UserIdentity do
  @moduledoc false
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.UserIdentity],
    domain: Reet.Accounts

  postgres do
    table "user_identities"
    repo Reet.Repo
  end

  user_identity do
    user_resource Reet.Accounts.User
  end
end
