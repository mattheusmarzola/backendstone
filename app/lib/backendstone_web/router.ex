defmodule BackendstoneWeb.Router do
  use BackendstoneWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendstoneWeb do
    pipe_through :api
  end
end
