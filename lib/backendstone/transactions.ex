defmodule Backendstone.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Backendstone.Repo

  alias Backendstone.{TransactionServer, TransactionServerSupervisor}
  alias Backendstone.Transactions.Transaction
  alias Backendstone.Accounts
  alias Backendstone.Email.{Email, Mailer}
  alias Decimal

  @initial_transaction_status 1
  @transaction_type_withdrawal 1
  @transaction_type_deposit 2
  @transaction_type_transference 3
  @transaction_status_denied 2
  @transaction_status_executed 3

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
    |> Repo.preload(:account)
    |> Repo.preload(:target_account)
  end

  @doc """
  Creates a transaction.

  Before create, insert the account information and the initial status of transaction (Pending)

  ## Examples

      iex> create_transaction(%User{id: 1}, %{type_id: 1, amount: #Decimal<200>})
      {:ok, %Transaction{}}

      iex> create_transaction(%User{id: nil}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(user, attrs \\ %{}) do
    attrs = attrs
    |> put_account!(user)
    |> put_initial_transaction_status!()

    %Transaction{}
     |> Transaction.changeset(attrs)
     |> Repo.insert()
  end

  @doc """
  Start the processing of a transaction. Only accepts transaction with status Pending

  The process consist in load the transaction from data base, valid funds if necessary,
   processes the transaction, send e-mail to user account and finalize the transaction updating his status.


  ## Example

      iex> start_transaction(%Transaction{type_id: 1}, %User{})
      {:ok, %Transaction{}}

  """
  def start_transaction(%Transaction{type_id: 1} = transaction, user) do
    case TransactionServer.transaction_server_pid(transaction.account_id) do
      pid when is_pid(pid) ->
        IO.puts("ACHOU O POOLLL")
      nil ->
        case TransactionServerSupervisor.start_transaction_server(transaction.account_id, transaction) do
          {:ok, _transaction_pid} ->
            IO.puts("INICIOU O POOL DE TRANSACOES")

          {:error, _error} ->
            IO.puts("NAOOOOOO INICIOU O POOL DE TRANSACOES")
        end
    end
    get_transaction!(transaction.id)
    |> has_funds?()
    |> process_transaction()
    |> send_email(user)
    |> finalize_transaction()
  end

  @doc """
  Validate if a account has funds to make a transaction. If the transaction is a Deposit, just return :ok.

  ## Example

      iex> has_funds?(%Transaction{type_id: 2})
      {:ok, %Transaction{}}

      iex> has_funds?(%Transaction{type_id: 1, amount: "20000.00"})
      {:without_funds, %Transaction{}}

  """
  def has_funds?(%Transaction{type_id: @transaction_type_deposit} = transaction), do: {:ok, transaction}
  def has_funds?(%Transaction{} = transaction) do
    has_funds =
      Decimal.new(transaction.account.balance)
      |> Decimal.sub(transaction.amount)
      |> Decimal.positive?()

    case has_funds do
      true -> {:ok, transaction}
      false -> {:without_funds, transaction}
    end
  end

  @doc """
  Processes the transaction, if recive a :without_funds just send :without_funds.
  If recive :ok, handle the transaction to respective function to process the operation
  If receive a transaction with a incorret type, return {:error, "Invalid Transaction"}
  ##Examples

      iex> process_transaction({:ok, %Transaction{} = transaction})
      {:ok, %Transaction{}}

      iex> process_transaction({:without_funds, _})
      {:without_funds, %Transaction{}}

      iex> process_transaction({:ok, %Transaction{type_id: 9999}})
      {:error, "Invalid Transaction"}
  """
  def process_transaction({:without_funds, %Transaction{} = transaction}), do: {:without_funds, transaction}
  def process_transaction({:ok, %Transaction{} = transaction}) do
    case transaction do
      %Transaction{type_id: @transaction_type_withdrawal} -> process_withdrawal(transaction, transaction.account)
      %Transaction{type_id: @transaction_type_deposit} -> process_deposit(transaction, transaction.account)
      %Transaction{type_id: @transaction_type_transference} -> process_transference(transaction)
      _ -> {:error, "Invalid Transaction"}
    end
  end

  @doc """
  Receive a account and a deposit transaction, calling Accounts context to handler the operation.
  Returns a transaction if :ok. 

  ##Exemples
      iex> process_transaction(%Transaction{}, %Account{})
      {:ok, %Transaction{} = transaction}
  """
  def process_deposit(%Transaction{} = transaction, account) do
    with {:ok, _} <- Accounts.credit_amount(account, transaction) do
      {:ok, %Transaction{} = transaction}
    end
  end

  @doc """
  Receive a account and a withdrawal transaction, calling Accounts context to handler the operation.
  Returns a transaction if :ok.

  ##Exemples
      iex> process_withdrawal(%Transaction{}, %Account{})
      {:ok, %Transaction{} = transaction}
  """
  def process_withdrawal(%Transaction{} = transaction, account) do
    with {:ok, _} <- Accounts.debit_amount(account, transaction) do
      {:ok, %Transaction{} = transaction}
    end
  end

  @doc """
  Receives a account and a transference transaction, calling process_withdrawal to source account and process_deposit to target account.
  Returns a transaction if :ok.

  ##Exemples
      iex> process_transference(%Transaction{})
      {:ok, %Transaction{} = transaction}
  """
  def process_transference(%Transaction{} = transaction) do
    IO.inspect(transaction)
    with {:ok, _} <- process_withdrawal(transaction, transaction.account),
                      process_deposit(transaction, transaction.target_account) do
      {:ok, %Transaction{} = transaction}
    end
  end

  @doc """
    Recives a transaction and a User to send e-mail when transaction is a withdrawal type,

  ##Exemples

    iex> process_transference({:ok, %Transaction{}}, %User{})
      {:ok, %Transaction{} = transaction}
  """
  def send_email({:without_funds, %Transaction{} = transaction}, _), do: {:without_funds, transaction}
  def send_email({:ok, %Transaction{type_id: @transaction_type_withdrawal} = transaction}, user) do
    case transaction do
      %Transaction{type_id: @transaction_type_withdrawal} ->  Email.withdrawal_email(user, transaction)
                                                               |> Mailer.deliver_now()
      _ -> {:ok, transaction}
    end

    {:ok, %Transaction{} = transaction}
  end
  def send_email({:ok, %Transaction{} = transaction}, _), do: {:ok, transaction}

  @doc """
  Recives {:without_funds, %Transaction{} = transaction} and updating transaction status to Denied
  
  ##Exemples

    iex> process_transference({:without_funds, %Transaction{}}, %User{})
      {:ok, %Transaction{} = transaction}
  """
  def finalize_transaction({:without_funds, %Transaction{} = transaction}) do
    with {:ok, _} <- update_transaction(transaction, %{transaction_status_id: @transaction_status_denied}) do
      {:ok, get_transaction!(transaction.id)}
    end
  end

  @doc """
  Recives {:ok, %Transaction{} = transaction} and updating transaction status to Executed
  
  ##Exemples

    iex> process_transference({:ok, %Transaction{}}, %User{})
      {:ok, %Transaction{} = transaction}
  """
  def finalize_transaction({:ok, %Transaction{} = transaction}) do
    with {:ok, _} <- update_transaction(transaction, %{transaction_status_id: @transaction_status_executed}) do
      {:ok, get_transaction!(transaction.id)}
    end
  end

  defp put_initial_transaction_status!(attrs) do
    attrs
    |> Map.put("transaction_status_id", @initial_transaction_status)
  end

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
