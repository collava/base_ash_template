defmodule AshBaseTemplate.Communitcations do
  @moduledoc false

  use Ash.Domain,
    extensions: [
      AshAdmin.Domain
    ]

  resources do
    resource AshBaseTemplate.Communitcations.Newsletter
  end
end
