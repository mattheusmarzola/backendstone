defmodule BackendstoneWeb.SessionController do
  use BackendstoneWeb, :controller

  alias Backendstone.{UserManager,
    UserManager.User,
    UserManager.Guardian,
    UserManager.ErrorHandler}

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    UserManager.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn
    |> put_status(:ok)
    |> put_resp_header("location", Routes.user_path(conn, :show, user))
    |> render("jwt.json", jwt: token)
  end

  defp login_reply({:error, reason}, _conn) do
    {:error, :unauthorized}
  end



end
