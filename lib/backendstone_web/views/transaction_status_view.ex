defmodule BackendstoneWeb.TransactionStatusView do
  use BackendstoneWeb, :view
  alias BackendstoneWeb.TransactionStatusView

  def render("index.json", %{transaction_status: transaction_status}) do
    %{data: render_many(transaction_status, TransactionStatusView, "transaction_status.json")}
  end

  def render("show.json", %{transaction_status: transaction_status}) do
    %{data: render_one(transaction_status, TransactionStatusView, "transaction_status.json")}
  end

  def render("transaction_status.json", %{transaction_status: transaction_status}) do
    %{id: transaction_status.id,
      name: transaction_status.name}
  end
end
