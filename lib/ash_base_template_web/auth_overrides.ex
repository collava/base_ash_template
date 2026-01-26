defmodule AshBaseTemplateWeb.AuthOverrides do
  @moduledoc false

  use AshAuthentication.Phoenix.Overrides

  # configure your UI overrides here

  # First argument to `override` is the component name you are overriding.
  # The body contains any number of configurations you wish to override
  # Below are some examples

  # For a complete reference, see https://hexdocs.pm/ash_authentication_phoenix/ui-overrides.html

  alias AshAuthentication.Phoenix.Components
  alias AshAuthentication.Phoenix.ConfirmLive
  alias AshAuthentication.Phoenix.MagicSignInLive
  alias AshAuthentication.Phoenix.ResetLive
  alias AshAuthentication.Phoenix.SignInLive

  override SignInLive do
    set :root_class, "min-h-screen grid place-items-center bg-gray-50 dark:bg-zinc-900"
  end

  override ConfirmLive do
    set :root_class, "min-h-screen grid place-items-center bg-gray-50 dark:bg-zinc-900"
  end

  override ResetLive do
    set :root_class, "min-h-screen grid place-items-center bg-gray-50 dark:bg-zinc-900"
  end

  override MagicSignInLive do
    set :root_class, "min-h-screen grid place-items-center bg-gray-50 dark:bg-zinc-900"
  end

  override Components.SignIn do
    set :show_banner, false

    set :root_class,
        "flex-1 flex flex-col justify-center py-12 px-4 sm:px-6 lg:flex-none lg:px-20 xl:px-24"

    set :strategy_class, "mx-auto w-full max-w-sm lg:w-96"
    set :authentication_error_container_class, "text-zinc-900 dark:text-zinc-100 text-center"
  end

  override Components.Password.Input do
    set :submit_class,
        "w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-zinc-900 hover:bg-zinc-700 dark:text-zinc-900 dark:bg-zinc-100 dark:hover:bg-zinc-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-zinc-500 mt-4 mb-4"

    set :input_class,
        "appearance-none block w-full px-3 py-2 border border-zinc-300 rounded-md shadow-sm placeholder-zinc-400 focus:outline-none focus:ring-zinc-500 focus:border-zinc-500 sm:text-sm bg-zinc-100 dark:bg-zinc-800 dark:border-zinc-700 dark:text-zinc-100"

    set :label_class, "block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-1"
  end

  override Components.MagicLink.Input do
    set :submit_class,
        "w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-zinc-900 hover:bg-zinc-700 dark:text-zinc-900 dark:bg-zinc-100 dark:hover:bg-zinc-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-zinc-500 mt-4 mb-4"
  end

  override Components.Password do
    set :toggler_class,
        "flex-none text-zinc-600 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-100 px-2 first:pl-0 last:pr-0 underline"
  end

  override Components.Password.SignInForm do
    set :label_class,
        "mt-2 mb-4 text-2xl tracking-tight font-bold text-zinc-900 dark:text-zinc-100"
  end
end
