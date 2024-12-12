defmodule Reet.Accounts.UserIdentity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.UserIdentity],
    domain: Reet.Accounts

  user_identity do
    user_resource Reet.Accounts.User
  end

  postgres do
    table "user_identities"
    repo Reet.Repo
  end
end
