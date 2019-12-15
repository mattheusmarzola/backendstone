defmodule Backendstone.TransactionServerSupervisor do
  @moduledoc """
  A supervisor that starts `TransactionsServer` processes dynamically.
  """

  use DynamicSupervisor

  alias Backendstone.TransactionServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a `TransactionServer` process and supervises it.
  """
  def start_transaction_server(account_id, intial_state) do
    child_spec = %{
      id: TransactionServer, 
      start: {TransactionServer, :start_link, [account_id, intial_state]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Terminates the `TransactionServer` process normally. It won't be restarted.
  """
  def stop_transaction_server(account_id) do
    :ets.delete(:transactions_table, account_id)
    
    child_pid = TransactionServer.transaction_server_pid(account_id)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end
