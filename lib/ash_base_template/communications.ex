defmodule AshBaseTemplate.Communications do
  @moduledoc false

  use Ash.Domain,
    extensions: [
      AshAdmin.Domain
    ]

  resources do
    resource AshBaseTemplate.Communications.Newsletter
  end
end
