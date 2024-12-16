defmodule AshBaseTemplateWeb.Router do
  use AshBaseTemplateWeb, :router
  use AshAuthentication.Phoenix.Router
  use ErrorTracker.Web, :router

  import Phoenix.LiveDashboard.Router

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
    auth_routes AuthController, AshBaseTemplate.Accounts.User, path: "/auth"
    sign_out_route AuthController

    get "/", PageController, :home

    ash_authentication_live_session :authentication_required,
      on_mount: {AshBaseTemplateWeb.LiveUserAuth, :live_user_required} do
      live "/protected_route", ProjectLive.Index, :index
    end

    ash_authentication_live_session :authentication_optional,
      on_mount: {AshBaseTemplateWeb.LiveUserAuth, :live_user_optional} do
      live "/optional", ProjectLive.Index, :index
      live "/posts", PostsLive
    end

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

    live_dashboard "/dashboard",
      on_mount: [{AshBaseTemplateWeb.LiveUserAuth, :admins_only}],
      metrics: AshBaseTemplateWeb.Telemetry,
      additional_pages: [
        oban: Oban.LiveDashboard
      ],
      on_mount: [
        {AshBaseTemplateWeb.LiveUserAuth, :live_user_required}
      ]

    forward "/mailbox", Plug.Swoosh.MailboxPreview
  end

  ash_authentication_live_session :admin_dashboard,
    on_mount: [{AshBaseTemplateWeb.LiveUserAuth, :admins_only}],
    session: {AshAdmin.Router, :__session__, [%{"prefix" => "/admin"}, []]},
    root_layout: {AshAdmin.Layouts, :root} do
    scope "/" do
      pipe_through :browser

      live "/admin/*route",
           AshAdmin.PageLive,
           :page,
           private: %{
             live_socket_path: "/live",
             ash_admin_csp_nonce: %{
               img: "ash_admin-#{:csp_nonce_value}",
               style: "ash_admin-#{:csp_nonce_value}",
               script: "ash_admin-#{:csp_nonce_value}"
             }
           }
    end
  end
end
