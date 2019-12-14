defmodule Backendstone.AccountsTest do
  use Backendstone.DataCase

  alias Backendstone.Accounts
  alias Backendstone.UserManagerTest

  describe "accounts" do
    alias Backendstone.Accounts.Account

    @valid_attrs %{balance: "120.5", user_id: 1}
    @update_attrs %{balance: "456.7" , user_id: 2}
    @invalid_attrs %{balance: nil, user_id: nil}

    @update_attrs %{
      email: "some@updated.email",
      password: "some updated password",
      password_confirmation: "some updated password",
      username: "someupdatedusername"
    }

    def account_fixture(attrs \\ %{}) do
      user = UserManagerTest.user_fixture()
      valid_attrs = @valid_attrs
      valid_attrs = %{valid_attrs | user_id: user.id}

      {Accounts.get_account_by_user_id!(user.id), user}
    end

    test "list_accounts/0 returns all accounts" do
      {account, _} = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      {account, _} = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      {account, user } = account_fixture()
      account = account
      |> Map.put(:user_id, user.id)
      |> Map.put(:balance, "456.7")

      assert {:ok, %Account{} = account} = Accounts.create_account(Map.from_struct(account))
      assert account.balance == Decimal.new("456.7")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      {account, user } = account_fixture()
      update_attrs = @update_attrs
        |> Map.put(:user_id, user.id)

      assert {:ok, %Account{} = account} = Accounts.update_account(account, update_attrs)
      assert account.balance == Decimal.new("1000")
    end

    test "update_account/2 with invalid data returns error changeset" do
      {account, _} = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      {account, _ } = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      {account, _} = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
