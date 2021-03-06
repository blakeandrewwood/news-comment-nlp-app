defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_auth do
    plug :fetch_session
    plug Guardian.Plug.Pipeline, module: ServerWeb.Guardian,
      error_handler: ServerWeb.AuthErrorController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug :get_user
  end

  pipeline :authorized do
    plug :fetch_session
    plug Guardian.Plug.Pipeline, module: ServerWeb.Guardian,
      error_handler: ServerWeb.AuthErrorController
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug :get_user
  end

  scope "/", ServerWeb do
    pipe_through [:browser, :browser_auth]
    get "/", PageController, :index
    get "/register", UserController, :new
    post "/register", UserController, :create
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end

  scope "/api", ServerWeb do
    pipe_through :api
    resources "/comments", CommentController, only: [:index, :show]
    scope "/" do
      pipe_through :authorized
      resources "/comments", CommentController, only: [:create, :update, :delete]
    end
  end

  defp get_user(conn, _) do
    case Server.Accounts.get_current_user(conn) do
      nil ->
        conn
      user ->
        assign(conn, :current_user, user)
    end
  end

end
