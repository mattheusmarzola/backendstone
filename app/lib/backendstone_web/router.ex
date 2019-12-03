defmodule BackendstoneWeb.Router do
  use BackendstoneWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Backendstone.UserManager.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", BackendstoneWeb do
    pipe_through :api

    scope "/v1", BackendstoneWeb do
      pipe_through [:ensure_auth]
    
      get "/protected", PageController, :protected
    end
  end
end
