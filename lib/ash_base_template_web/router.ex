defmodule AshBaseTemplateWeb.Router do
  use AshBaseTemplateWeb, :router
  use AshAuthentication.Phoenix.Router
  use ErrorTracker.Web, :router

  import AshAdmin.Router

  alias AshAuthentication.Phoenix.Overrides.Default

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AshBaseTemplateWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  scope "/api/json" do
    pipe_through [:api]

    forward "/swaggerui",
            OpenApiSpex.Plug.SwaggerUI,
            path: "/api/json/open_api",
            default_model_expand_depth: 4

    forward "/", AshBaseTemplateWeb.AshJsonApiRouter
  end

  scope "/", AshBaseTemplateWeb do
    pipe_through :browser
    error_tracker_dashboard("/errors", csp_nonce_assign_key: :csp_nonce_value)

    ash_authentication_live_session :authenticated_routes do
      # in each liveview, add one of the following at the top of the module:
      #
      # If an authenticated user must be present:
      # on_mount {AshBaseTemplateWeb.LiveUserAuth, :live_user_required}
      #
      # If an authenticated user *may* be present:
      # on_mount {AshBaseTemplateWeb.LiveUserAuth, :live_user_optional}
      #
      # If an authenticated user must *not* be present:
      # on_mount {AshBaseTemplateWeb.LiveUserAuth, :live_no_user}
    end
  end

  scope "/", AshBaseTemplateWeb do
    pipe_through :browser
    auth_routes AuthController, AshBaseTemplate.Accounts.User, path: "/auth"
    sign_out_route AuthController

    get "/", PageController, :home
    live "/posts", PostsLive

    ash_authentication_live_session :authentication_required,
      on_mount: {AshBaseTemplateWeb.LiveUserAuth, :live_user_required} do
      live "/protected_route", ProjectLive.Index, :index
    end

    ash_authentication_live_session :authentication_optional,
      on_mount: {AshBaseTemplateWeb.LiveUserAuth, :live_user_optional} do
      live "/optional", ProjectLive.Index, :index
    end

    # https://hexdocs.pm/ash_authentication_phoenix/ui-overrides.html
    sign_in_route register_path: "/register",
                  reset_path: "/reset",
                  auth_routes_prefix: "/auth",
                  on_mount: [{AshBaseTemplateWeb.LiveUserAuth, :live_no_user}],
                  overrides: [AshBaseTemplateWeb.AuthOverrides, Default]

    reset_route auth_routes_prefix: "/auth",
                overrides: [AshBaseTemplateWeb.AuthOverrides, Default]
  end

  scope "/" do
    pipe_through [:browser]
    ash_admin("/admin", csp_nonce_assign_key: :csp_nonce_value)
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ash_base_template, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard",
        metrics: AshBaseTemplateWeb.Telemetry,
        additional_pages: [
          oban: Oban.LiveDashboard,
          obanalyze: Obanalyze.dashboard()
        ],
        on_mount: [
          Obanalyze.hooks()
        ]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end