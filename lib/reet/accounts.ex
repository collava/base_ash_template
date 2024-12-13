defmodule Reet.Accounts do
  @moduledoc false
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource Reet.Accounts.Token
    resource Reet.Accounts.User
    resource Reet.Accounts.UserIdentity
  end
end
