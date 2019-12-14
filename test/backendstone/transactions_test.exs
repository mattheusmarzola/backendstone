defmodule Backendstone.TransactionsTest do
  use Backendstone.DataCase

  alias Backendstone.Transactions
  alias Backendstone.UserManagerTest

  describe "transactions" do
    alias Backendstone.Transactions.Transaction

    @valid_attrs %{target_account_id: 42, amount: "120.5"}
    @update_attrs %{target_account_id: 43, amount: "456.7"}
    @invalid_attrs %{target_account_id: nil, amount: nil}

    def transaction_fixture(attrs \\ %{}) do
      attrs =
        attrs
        |> Enum.into(@valid_attrs)

      user = UserManagerTest.user_fixture()
      {:ok, transaction} = Transactions.create_transaction(user, attrs)

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(@valid_attrs)
      assert transaction.target_account_id == 42
      assert transaction.amount == Decimal.new("120.5")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Transactions.update_transaction(transaction, @update_attrs)
      assert transaction.target_account_id == 43
      assert transaction.amount == Decimal.new("456.7")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end

  describe "types" do
    alias Backendstone.Transactions.Type

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def type_fixture(attrs \\ %{}) do
      {:ok, type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_type()

      type
    end

    test "list_types/0 returns all types" do
      type = type_fixture()
      assert Transactions.list_types() == [type]
    end

    test "get_type!/1 returns the type with given id" do
      type = type_fixture()
      assert Transactions.get_type!(type.id) == type
    end

    test "create_type/1 with valid data creates a type" do
      assert {:ok, %Type{} = type} = Transactions.create_type(@valid_attrs)
      assert type.name == "some name"
    end

    test "create_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_type(@invalid_attrs)
    end

    test "update_type/2 with valid data updates the type" do
      type = type_fixture()
      assert {:ok, %Type{} = type} = Transactions.update_type(type, @update_attrs)
      assert type.name == "some updated name"
    end

    test "update_type/2 with invalid data returns error changeset" do
      type = type_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_type(type, @invalid_attrs)
      assert type == Transactions.get_type!(type.id)
    end

    test "delete_type/1 deletes the type" do
      type = type_fixture()
      assert {:ok, %Type{}} = Transactions.delete_type(type)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_type!(type.id) end
    end

    test "change_type/1 returns a type changeset" do
      type = type_fixture()
      assert %Ecto.Changeset{} = Transactions.change_type(type)
    end
  end

  describe "transaction_status" do
    alias Backendstone.Transactions.TransactionStatus

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def transaction_status_fixture(attrs \\ %{}) do
      {:ok, transaction_status} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_transaction_status()

      transaction_status
    end

    test "list_transaction_status/0 returns all transaction_status" do
      transaction_status = transaction_status_fixture()
      assert Transactions.list_transaction_status() == [transaction_status]
    end

    test "get_transaction_status!/1 returns the transaction_status with given id" do
      transaction_status = transaction_status_fixture()
      assert Transactions.get_transaction_status!(transaction_status.id) == transaction_status
    end

    test "create_transaction_status/1 with valid data creates a transaction_status" do
      assert {:ok, %TransactionStatus{} = transaction_status} = Transactions.create_transaction_status(@valid_attrs)
      assert transaction_status.name == "some name"
    end

    test "create_transaction_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction_status(@invalid_attrs)
    end

    test "update_transaction_status/2 with valid data updates the transaction_status" do
      transaction_status = transaction_status_fixture()
      assert {:ok, %TransactionStatus{} = transaction_status} = Transactions.update_transaction_status(transaction_status, @update_attrs)
      assert transaction_status.name == "some updated name"
    end

    test "update_transaction_status/2 with invalid data returns error changeset" do
      transaction_status = transaction_status_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction_status(transaction_status, @invalid_attrs)
      assert transaction_status == Transactions.get_transaction_status!(transaction_status.id)
    end

    test "delete_transaction_status/1 deletes the transaction_status" do
      transaction_status = transaction_status_fixture()
      assert {:ok, %TransactionStatus{}} = Transactions.delete_transaction_status(transaction_status)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction_status!(transaction_status.id) end
    end

    test "change_transaction_status/1 returns a transaction_status changeset" do
      transaction_status = transaction_status_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction_status(transaction_status)
    end
  end
end
