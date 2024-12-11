defmodule Reet.Accounts do
  use Ash.Domain

  resources do
    resource Reet.Accounts.Token
    resource Reet.Accounts.User
  end
end
