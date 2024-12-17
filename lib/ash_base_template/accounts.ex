defmodule AshBaseTemplate.Accounts do
  @moduledoc false
  use Ash.Domain, extensions: [AshAdmin.Domain, AshJsonApi.Domain]

  admin do
    show?(true)
  end

  resources do
    resource AshBaseTemplate.Accounts.Token

    resource AshBaseTemplate.Accounts.User do
      define :get_user, args: [:id], action: :by_id
    end

    resource AshBaseTemplate.Accounts.UserIdentity
  end
end
