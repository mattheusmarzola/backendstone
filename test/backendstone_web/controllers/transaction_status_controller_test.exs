defmodule BackendstoneWeb.TransactionStatusControllerTest do
  use BackendstoneWeb.ConnCase

  alias Backendstone.Transactions
  alias Backendstone.UserManagerTest

  @create_attrs %{
    name: "some name"
  }

  def fixture(:transaction_status) do
    {:ok, transaction_status} = Transactions.create_transaction_status(@create_attrs)
    transaction_status
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
    test "lists all transaction_status", %{conn: conn} do
      conn = get(conn, Routes.transaction_status_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
    """
  end

  defp create_transaction_status(_) do
    transaction_status = fixture(:transaction_status)
    {:ok, transaction_status: transaction_status}
  end
end
