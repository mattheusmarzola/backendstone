defmodule BackendstoneWeb.TransactionView do
  use BackendstoneWeb, :view
  alias BackendstoneWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      type: %{id: transaction.type.id,
             name: transaction.type.name},
      amount: transaction.amount,
      target_account_id: transaction.target_account_id,
      transaction_status: %{id: transaction.transaction_status.id,
                           name: transaction.transaction_status.name}}
  end
end
