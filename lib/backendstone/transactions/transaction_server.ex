defmodule Backendstone.TransactionServer do
  @moduledoc """
  A transaction server process that holds a transaction queue as its state.
  """

  use GenServer

  require Logger

  @timeout :timer.minutes(5)

  # Client (Public) Interface

  @doc """
  Spawns a new transaction server process registered under the given `account_id`.
  """
  def start_link(account_id, size) do
    GenServer.start_link(__MODULE__, 
                         {account_id, size}, 
                         name: via_tuple(account_id))
  end

  def summary(account_id) do
    GenServer.call(via_tuple(account_id), :summary)
  end

  def add_transaction(account_id, transaction) do
    GenServer.call(via_tuple(account_id), {:add_transaction, transaction})
  end

  @doc """
  Returns a tuple used to register and lookup a transaction server process by account_id.
  """
  def via_tuple(account_id) do
    {:via, Registry, {Backendstone.TransactionServerRegistry, account_id}}
  end

  @doc """
  Returns the `pid` of the transaction server process registered under the 
  given `account_id`, or `nil` if no process is registered.
  """
  def transaction_server_pid(account_id) do
    account_id
    |> via_tuple() 
    |> GenServer.whereis()
  end

  # Server Callbacks

  def init({account_id, transaction}) do
    transaction_server = 
      case :ets.lookup(:transactions_table, account_id) do
        [] -> 
          :ets.insert(:transactions_table, {account_id, [transaction]})
          [transaction]

        [{^account_id, [transaction]}] -> 
          [transaction]
    end

    Logger.info("Spawned transaction server process named '#{account_id}'.")

    {:ok, [transaction], @timeout}
  end

  def handle_call(:summary, _from, transactions) do
    {:reply, summarize(transactions), transactions, @timeout}
  end

  def handle_call({:add_transaction, transaction}, _from, transactions) do
    new_transactions = transactions ++ [transaction]

    :ets.insert(:transactions_table, {transactions_server_name(), new_transactions})

    {:reply, summarize(new_transactions), new_transactions, @timeout}
  end

  def summarize(transactions) do
    transactions
      |> Enum.map(fn t -> 
        %{
        type_id: t.type_id,
        amount: t.amount,
        account_id: t.account_id
        } end)
  end

  def handle_info(:timeout, [transactions]) do
    {:stop, {:shutdown, :timeout}, transactions}
  end

  def terminate({:shutdown, :timeout}, _transactions) do
    :ets.delete(:transactions_table, transactions_server_name())
    :ok
  end

  def terminate(_reason, _transactions) do
    :ok
  end

  defp transactions_server_name do
    Registry.keys(Backendstone.TransactionServerRegistry, self()) |> List.first
  end
end
