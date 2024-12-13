defmodule AshBaseTemplate.Accounts.UserIdentity do
  @moduledoc false
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.UserIdentity],
    domain: AshBaseTemplate.Accounts

  postgres do
    table "user_identities"
    repo AshBaseTemplate.Repo
  end

  user_identity do
    user_resource AshBaseTemplate.Accounts.User
  end
end
