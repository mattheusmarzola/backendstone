defmodule BackendstoneWeb.TransactionStatusControllerTest do
  use BackendstoneWeb.ConnCase

  alias Backendstone.Transactions
  alias Backendstone.Transactions.TransactionStatus

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:transaction_status) do
    {:ok, transaction_status} = Transactions.create_transaction_status(@create_attrs)
    transaction_status
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transaction_status", %{conn: conn} do
      conn = get(conn, Routes.transaction_status_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction_status" do
    test "renders transaction_status when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transaction_status_path(conn, :create), transaction_status: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transaction_status_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_status_path(conn, :create), transaction_status: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update transaction_status" do
    setup [:create_transaction_status]

    test "renders transaction_status when data is valid", %{conn: conn, transaction_status: %TransactionStatus{id: id} = transaction_status} do
      conn = put(conn, Routes.transaction_status_path(conn, :update, transaction_status), transaction_status: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.transaction_status_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, transaction_status: transaction_status} do
      conn = put(conn, Routes.transaction_status_path(conn, :update, transaction_status), transaction_status: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete transaction_status" do
    setup [:create_transaction_status]

    test "deletes chosen transaction_status", %{conn: conn, transaction_status: transaction_status} do
      conn = delete(conn, Routes.transaction_status_path(conn, :delete, transaction_status))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_status_path(conn, :show, transaction_status))
      end
    end
  end

  defp create_transaction_status(_) do
    transaction_status = fixture(:transaction_status)
    {:ok, transaction_status: transaction_status}
  end
end
