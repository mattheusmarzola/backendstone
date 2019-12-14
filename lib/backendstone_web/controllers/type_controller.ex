defmodule BackendstoneWeb.TypeController do
  use BackendstoneWeb, :controller

  alias Backendstone.Transactions
  alias Backendstone.Transactions.Type

  action_fallback BackendstoneWeb.FallbackController

  def index(conn, _params) do
    types = Transactions.list_types()
    render(conn, "index.json", types: types)
  end

  def create(conn, %{"type" => type_params}) do
    with {:ok, %Type{} = type} <- Transactions.create_type(type_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.type_path(conn, :show, type))
      |> render("show.json", type: type)
    end
  end

  def show(conn, %{"id" => id}) do
    type = Transactions.get_type!(id)
    render(conn, "show.json", type: type)
  end

  def update(conn, %{"id" => id, "type" => type_params}) do
    type = Transactions.get_type!(id)

    with {:ok, %Type{} = type} <- Transactions.update_type(type, type_params) do
      render(conn, "show.json", type: type)
    end
  end

  def delete(conn, %{"id" => id}) do
    type = Transactions.get_type!(id)

    with {:ok, %Type{}} <- Transactions.delete_type(type) do
      send_resp(conn, :no_content, "")
    end
  end
end
