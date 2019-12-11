defmodule Backendstone.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Backendstone.Repo

  alias Backendstone.Transactions.Transaction
  alias Backendstone.Accounts.Account
  alias Backendstone.Accounts
  alias Decimal

  @initial_transaction_status 1
  @transaction_type_withdrawal 1
  @transaction_type_deposit 2
  @transaction_status_denied 2
  @transaction_status_executed 3

  @doc """
    Returns the amount of initial deposit.

    ## Examples

      iex> get_initial_deposit_amount()
      1000.00
  """
  def get_initial_deposit_amount, do: @initial_deposit

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id) do
    Repo.get!(Transaction, id)
    |> Repo.preload(:transaction_status)
    |> Repo.preload(:type)
  end

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%User{id: 1}, %{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%User{id: nil}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(user, attrs \\ %{}) do
    attrs = attrs
    |> put_account!(user)
    |> put_initial_transaction_status!()

    {:ok, transaction} =
      %Transaction{}
      |> Transaction.changeset(attrs)
      |> Repo.insert()

    result = start_transaction(transaction, user)

    result
  end

  def start_transaction(transaction, user) do
    process_transaction(transaction, user)
  end

  def process_transaction(transaction, user) do
    case transaction do
      %Transaction{type_id: @transaction_type_withdrawal} -> process_withdrawal(transaction, user)
      %Transaction{type_id: @transaction_type_deposit} -> process_deposit(transaction, user)
      _ -> {:error, "Invalid Transaction"}
    end
  end

  def process_deposit(transaction, user) do
    account = Accounts.get_account!(transaction.account_id)

    account
     |> add_transaction(transaction)
     |> (&(Accounts.update_account(account, %{balance: &1}))).()

    update_transaction(transaction, %{transaction_status_id: @transaction_status_executed})
     |> process_reply()
  end

  def process_withdrawal(transaction, user) do
    account = Accounts.get_account!(transaction.account_id)

    account
    |> has_funds?(transaction)
    |> apply_withdrawal(account)
  end

  def apply_withdrawal({:error, %Transaction{} = transaction}, _account) do
    update_transaction(transaction, %{transaction_status_id: @transaction_status_denied})

    {:ok, transaction}
    |> process_reply()
  end

  def apply_withdrawal({:ok, %Transaction{} = transaction}, account) do
    sub_transaction(account, transaction)
     |> (&(Accounts.update_account(account, %{balance: &1}))).()

    update_transaction(transaction, %{transaction_status_id: @transaction_status_executed})
     |> process_reply()
  end


  def process_reply({:ok, %Transaction{} = transaction}), do: {:ok, get_transaction!(transaction.id)}
  def process_reply({:error, transaction}), do: {:error, transaction}

  def has_funds?(account, transaction) do
    has_funds =
      sub_transaction(account, transaction)
      |> Decimal.positive?()

    case has_funds do
      true -> {:ok, transaction}
      false -> {:error, transaction}
    end
  end

  def sub_transaction(account, transaction) do
    Decimal.new(account.balance)
      |> Decimal.sub(transaction.amount)
  end

  def add_transaction(account, transaction) do
    Decimal.new(account.balance)
      |> Decimal.add(transaction.amount)
  end

  @doc """
  Add the initial status id on transaction.

  ## Examples

      iex> put_initial_transaction_status( %{"amount" => 100.0, "type" => %{"id" => 1}})
      %{"amount" => 100.0, "type" => %{"id" => 1}, "transaction_status_id" =>  1}
  """
  defp put_initial_transaction_status!(attrs) do
    attrs
    |> Map.put("transaction_status_id", @initial_transaction_status)
  end

  @doc """
  Add the account id on transaction.

  ## Examples

      iex> put_account!(%{"amount" => 100.0, "type" => %{"id" => 1}})
      %{"amount" => 100.0, "type" => %{"id" => 1}, "account_id" =>  1}
  """
  defp put_account!(attrs, user) do
    account = Accounts.get_account_by_user_id!(user.id)

    attrs
    |> Map.put("account_id", account.id)
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  alias Backendstone.Transactions.Type

  @doc """
  Returns the list of types.

  ## Examples

      iex> list_types()
      [%Type{}, ...]

  """
  def list_types do
    Repo.all(Type)
  end

  @doc """
  Gets a single type.

  Raises `Ecto.NoResultsError` if the Type does not exist.

  ## Examples

      iex> get_type!(123)
      %Type{}

      iex> get_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_type!(id), do: Repo.get!(Type, id)

  @doc """
  Creates a type.

  ## Examples

      iex> create_type(%{field: value})
      {:ok, %Type{}}

      iex> create_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_type(attrs \\ %{}) do
    %Type{}
    |> Type.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a type.

  ## Examples

      iex> update_type(type, %{field: new_value})
      {:ok, %Type{}}

      iex> update_type(type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_type(%Type{} = type, attrs) do
    type
    |> Type.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Type.

  ## Examples

      iex> delete_type(type)
      {:ok, %Type{}}

      iex> delete_type(type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_type(%Type{} = type) do
    Repo.delete(type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking type changes.

  ## Examples

      iex> change_type(type)
      %Ecto.Changeset{source: %Type{}}

  """
  def change_type(%Type{} = type) do
    Type.changeset(type, %{})
  end


  alias Backendstone.Transactions.TransactionStatus

  @doc """
  Returns the list of transaction_status.

  ## Examples

      iex> list_transaction_status()
      [%TransactionStatus{}, ...]

  """
  def list_transaction_status do
    Repo.all(TransactionStatus)
  end

  @doc """
  Gets a single transaction_status.

  Raises `Ecto.NoResultsError` if the Transaction status does not exist.

  ## Examples

      iex> get_transaction_status!(123)
      %TransactionStatus{}

      iex> get_transaction_status!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction_status!(id), do: Repo.get!(TransactionStatus, id)

  @doc """
  Creates a transaction_status.

  ## Examples

      iex> create_transaction_status(%{field: value})
      {:ok, %TransactionStatus{}}

      iex> create_transaction_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction_status(attrs \\ %{}) do
    %TransactionStatus{}
    |> TransactionStatus.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction_status.

  ## Examples

      iex> update_transaction_status(transaction_status, %{field: new_value})
      {:ok, %TransactionStatus{}}

      iex> update_transaction_status(transaction_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction_status(%TransactionStatus{} = transaction_status, attrs) do
    transaction_status
    |> TransactionStatus.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TransactionStatus.

  ## Examples

      iex> delete_transaction_status(transaction_status)
      {:ok, %TransactionStatus{}}

      iex> delete_transaction_status(transaction_status)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction_status(%TransactionStatus{} = transaction_status) do
    Repo.delete(transaction_status)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction_status changes.

  ## Examples

      iex> change_transaction_status(transaction_status)
      %Ecto.Changeset{source: %TransactionStatus{}}

  """
  def change_transaction_status(%TransactionStatus{} = transaction_status) do
    TransactionStatus.changeset(transaction_status, %{})
  end
end
