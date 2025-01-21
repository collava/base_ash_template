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
        <p class="text-[2rem] mt-4 font-semibold leading-10 tracking-tighter text-zinc-900 text-balance">
          Ash Base Template
        </p>
        <p class="mt-4 text-base leading-7 text-zinc-600">
          Dont forget to read the README.md file
        </p>
        <div class="mt-8 max-w-md mx-auto">
          <.live_component module={AshBaseTemplateWeb.Components.NewsletterForm} id="newsletter-form" />
        </div>

        <div class="flex">
          <div class="w-full sm:w-auto">
            <div class="mt-10 grid grid-cols-1 gap-x-6 gap-y-4 sm:grid-cols-3">
              <a
                href={~p"/posts"}
                class="group relative rounded-2xl px-6 py-4 text-sm font-semibold leading-6 text-zinc-900 sm:py-6"
              >
                <span class="absolute inset-0 rounded-2xl bg-zinc-50 transition group-hover:bg-zinc-100 sm:group-hover:scale-105">
                </span>
                <span class="relative flex items-center gap-4 sm:flex-col">
                  <.icon name="hero-document-text" class="h-6 w-6" /> List Posts Example
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
