defmodule AshBaseTemplateWeb.HomeLive do
  @moduledoc false
  use AshBaseTemplateWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <div class="px-4">
      <div class="">
        <p class="text-[2rem] mt-4 font-semibold leading-10 tracking-tighter text-zinc-900 dark:text-zinc-500 text-balance">
          Ash Base Template
        </p>
        <p class="mt-4 text-base leading-7 text-zinc-400">
          Dont forget to read the README.md file.<br />
          You can check the terminal for links send to the email you provided.<br />
          You can use any email, there's no live sending in development.
        </p>
        <div class="mt-8 max-w-md mx-auto">
          <.live_component module={AshBaseTemplateWeb.Components.NewsletterForm} id="newsletter-form" />
        </div>

        <div class="flex">
          <div class="w-full sm:w-auto">
            <div class="mt-10 grid grid-cols-1 gap-x-6 gap-y-4 sm:grid-cols-6">
              <a
                href={~p"/posts"}
                class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6 dark:bg-zinc-200"
              >
                <span class="absolute inset-0 rounded-2xl bg-zinc-200 transition group-hover:bg-zinc-300 sm:group-hover:scale-105">
                </span>
                <span class="relative flex items-center gap-4 sm:flex-col">
                  <.icon name="hero-document-text" class="h-6 w-6" /> List Posts
                </span>
              </a>
              <a
                href={~p"/admin"}
                target="_blank"
                class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6 dark:bg-zinc-200"
              >
                <span class="absolute inset-0 rounded-2xl bg-zinc-200 transition group-hover:bg-zinc-300 sm:group-hover:scale-105">
                </span>
                <span class="relative flex items-center gap-4 sm:flex-col">
                  <.icon name="hero-cog" class="h-6 w-6" /> Admin
                </span>
              </a>
              <a
                href={~p"/admin/mailbox"}
                target="_blank"
                class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6 dark:bg-zinc-800"
              >
                <span class="absolute inset-0 rounded-2xl bg-zinc-200 transition group-hover:bg-zinc-300 sm:group-hover:scale-105">
                </span>
                <span class="relative flex items-center gap-4 sm:flex-col">
                  <.icon name="hero-envelope" class="h-6 w-6" /> Mailbox
                </span>
              </a>
              <a
                href={
                  ~p"/admin?domain=Notifiers&resource=Newsletter&table=&action_type=read&action=read"
                }
                target="_blank"
                class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6 dark:bg-zinc-800"
              >
                <span class="absolute inset-0 rounded-2xl bg-zinc-200 transition group-hover:bg-zinc-300 sm:group-hover:scale-105">
                </span>
                <span class="relative flex items-center gap-4 sm:flex-col text-center">
                  <.icon name="hero-envelope-solid" class="h-6 w-6" /> All Newsletter Signups
                </span>
              </a>
              <a
                href={~p"/admin/errors"}
                target="_blank"
                class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6 dark:bg-zinc-800"
              >
                <span class="absolute inset-0 rounded-2xl bg-zinc-200 transition group-hover:bg-zinc-300 sm:group-hover:scale-105">
                </span>
                <span class="relative flex items-center gap-4 sm:flex-col">
                  <.icon name="hero-bug-ant" class="h-6 w-6" /> Error Tracking
                </span>
              </a>

              <a
                href={~p"/api/swaggerui"}
                target="_blank"
                class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6 dark:bg-zinc-800"
              >
                <span class="absolute inset-0 rounded-2xl bg-zinc-200 transition group-hover:bg-zinc-300 sm:group-hover:scale-105">
                </span>
                <span class="relative flex items-center gap-4 sm:flex-col">
                  <.icon name="hero-code-bracket" class="h-6 w-6" /> Swagger API
                </span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
