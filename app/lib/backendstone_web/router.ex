defmodule BackendstoneWeb.Router do
  use BackendstoneWeb, :router

  alias Backendstone.UserManager.AuthPipeline

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug AuthPipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api/v1", BackendstoneWeb do
    pipe_through :api

    post "/sign_up", UserController, :create
    post "/sign_in", SessionController, :login


  end


  scope "/api/v1", BackendstoneWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/users", UserController, :show
    get "/accounts", AccountController, :show

    resources "/transactions", TransactionController, [:create, :show]

    get "/types/transactions/", TypeController, :index
    get "/status/transactions/", TransactionStatusController, :index
  end
end
