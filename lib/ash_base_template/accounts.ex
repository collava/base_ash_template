defmodule AshBaseTemplate.Accounts do
  @moduledoc false
  use Ash.Domain, extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource AshBaseTemplate.Accounts.Token
    resource AshBaseTemplate.Accounts.User
    resource AshBaseTemplate.Accounts.UserIdentity
  end
end
