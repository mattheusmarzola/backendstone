defmodule BackendstoneWeb.TransactionStatusController do
  use BackendstoneWeb, :controller

  alias Backendstone.Transactions
  alias Backendstone.Transactions.TransactionStatus

  action_fallback BackendstoneWeb.FallbackController

  def index(conn, _params) do
    transaction_status = Transactions.list_transaction_status()
    render(conn, "index.json", transaction_status: transaction_status)
  end

  def create(conn, %{"transaction_status" => transaction_status_params}) do
    with {:ok, %TransactionStatus{} = transaction_status} <- Transactions.create_transaction_status(transaction_status_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transaction_status_path(conn, :show, transaction_status))
      |> render("show.json", transaction_status: transaction_status)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction_status = Transactions.get_transaction_status!(id)
    render(conn, "show.json", transaction_status: transaction_status)
  end

  def update(conn, %{"id" => id, "transaction_status" => transaction_status_params}) do
    transaction_status = Transactions.get_transaction_status!(id)

    with {:ok, %TransactionStatus{} = transaction_status} <- Transactions.update_transaction_status(transaction_status, transaction_status_params) do
      render(conn, "show.json", transaction_status: transaction_status)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction_status = Transactions.get_transaction_status!(id)

    with {:ok, %TransactionStatus{}} <- Transactions.delete_transaction_status(transaction_status) do
      send_resp(conn, :no_content, "")
    end
  end
end
