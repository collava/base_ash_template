defmodule AshBaseTemplate.Secrets do
  @moduledoc false
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], AshBaseTemplate.Accounts.User, _opts) do
    Application.fetch_env(:ash_base_template, :token_signing_secret)
  end
end
