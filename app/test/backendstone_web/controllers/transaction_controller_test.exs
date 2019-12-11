defmodule BackendstoneWeb.TransactionControllerTest do
  use BackendstoneWeb.ConnCase

  alias Backendstone.Transactions
  alias Backendstone.UserManagerTest

  @create_attrs %{
    account_to: 42,
    amount: "120.5"
  }
  @invalid_attrs %{account_to: nil, amount: nil}

  def fixture(:transaction) do
    {:ok, transaction} = Transactions.create_transaction(@create_attrs)
    transaction
  end

  setup %{conn: conn} do
    user = UserManagerTest.user_fixture()
    {:ok, jwt, _} = Guardian.encode_and_sign(user, :api)
    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "bearer: " <> jwt)

    {:ok, conn: conn}
  end

  describe "create transaction" do
    """
    test "renders transaction when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transaction_path(conn, :show, id))

      assert %{
               "id" => id,
               "account_to" => 42,
               "amount" => "120.5"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
    """

  end

  defp create_transaction(_) do
    transaction = fixture(:transaction)
    {:ok, transaction: transaction}
  end
end
