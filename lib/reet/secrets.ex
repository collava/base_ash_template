defmodule Reet.Secrets do
  @moduledoc false
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Reet.Accounts.User, _opts) do
    Application.fetch_env(:reet, :token_signing_secret)
  end
end
