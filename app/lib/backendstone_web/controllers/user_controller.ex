defmodule BackendstoneWeb.UserController do
  use BackendstoneWeb, :controller

  alias Backendstone.UserManager
  alias Backendstone.UserManager.User
  alias Backendstone.UserManager.Guardian

  action_fallback BackendstoneWeb.FallbackController


  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserManager.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("user.json", user: user)
    end
  end

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end

end
