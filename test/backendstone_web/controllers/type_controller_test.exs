defmodule BackendstoneWeb.TypeControllerTest do
  use BackendstoneWeb.ConnCase

  alias Backendstone.Transactions
  alias Backendstone.UserManagerTest

  @create_attrs %{
    name: "some name"
  }

  def fixture(:type) do
    {:ok, type} = Transactions.create_type(@create_attrs)
    type
  end

  setup %{conn: conn} do
    user = UserManagerTest.user_fixture()
    {:ok, jwt, _} = Guardian.encode_and_sign(user, :api)
    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "bearer: " <> jwt)

    {:ok, conn: conn}
  end

  describe "index" do
    """
    test "lists all types", %{conn: conn} do
      conn = get(conn, Routes.type_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
    """
  end

#  describe "show" do
#    test "get type by id", %{conn: conn} do
#      type = create_type(@create_attrs)
#      conn = get(conn, Routes.type_path(conn, :show))
#      assert json_response(conn, 200)["data"] == []
#    end
#  end

  defp create_type(_) do
    type = fixture(:type)
    {:ok, type: type}
  end
end
