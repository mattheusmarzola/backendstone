defmodule BackendstoneWeb.TypeControllerTest do
  use BackendstoneWeb.ConnCase

  alias Backendstone.Transactions
  alias Backendstone.Transactions.Type

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:type) do
    {:ok, type} = Transactions.create_type(@create_attrs)
    type
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all types", %{conn: conn} do
      conn = get(conn, Routes.type_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create type" do
    test "renders type when data is valid", %{conn: conn} do
      conn = post(conn, Routes.type_path(conn, :create), type: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.type_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.type_path(conn, :create), type: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update type" do
    setup [:create_type]

    test "renders type when data is valid", %{conn: conn, type: %Type{id: id} = type} do
      conn = put(conn, Routes.type_path(conn, :update, type), type: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.type_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, type: type} do
      conn = put(conn, Routes.type_path(conn, :update, type), type: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete type" do
    setup [:create_type]

    test "deletes chosen type", %{conn: conn, type: type} do
      conn = delete(conn, Routes.type_path(conn, :delete, type))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.type_path(conn, :show, type))
      end
    end
  end

  defp create_type(_) do
    type = fixture(:type)
    {:ok, type: type}
  end
end
