defmodule BackendstoneWeb.AccountControllerTest do
  use BackendstoneWeb.ConnCase

  alias Backendstone.Accounts
  alias Backendstone.UserManagerTest


  @create_attrs %{
    balance: "120.5"
  }

  def fixture(:account) do
    {:ok, account} = Accounts.create_account(@create_attrs)
    account
  end

  setup %{conn: conn} do
    user = UserManagerTest.user_fixture()
    {:ok, jwt, _} = Guardian.encode_and_sign(user, :api)
    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "bearer: " <> jwt)

    {:ok, conn: conn}
  end

  describe "show" do
    #test "get accounts", %{conn: conn} do
    #  conn = get(conn, Routes.account_path(conn, :show))
    #  assert json_response(conn, 200)["data"] == {}
    #end
  end

  defp create_account(_) do
    account = fixture(:account)
    {:ok, account: account}
  end
end
