defmodule AshBaseTemplate.Notifiers do
  @moduledoc false

  use Ash.Domain,
    extensions: [
      AshAdmin.Domain
    ]

  resources do
    resource AshBaseTemplate.Notifiers.Newsletter do
      define :subscribe_to_newsletter, args: [:email], action: :subscribe
      define :confirm_newsletter_subscription, action: :confirm
      define :unsubscribe_from_newsletter, action: :unsubscribe
      define :get_subscriber_by_email, args: [:email], action: :by_email
    end
  end
end
