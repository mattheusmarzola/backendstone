defmodule Backendstone.Reports do

  import Ecto.Query, warn: false
  alias Backendstone.Repo

  alias Backendstone.Transactions.Transaction

  def total_transaction(params) do
    Transaction
     |> select([t], sum(t.amount))
     |> where(^filter_total_transactions(params))
     |> Repo.one()
  end

  def filter_total_transactions(params) do
    Enum.reduce(params, dynamic(true), fn
      {_, "0"}, dynamic ->
        dynamic

      {"year", value}, dynamic ->
        dynamic([t], ^dynamic and fragment("EXTRACT(YEAR FROM updated_at) = ?", ^String.to_integer(value)))

      {"month", value}, dynamic ->
        dynamic([t], ^dynamic and fragment("EXTRACT(MONTH FROM updated_at) = ?", ^String.to_integer(value)))

      {"day", value}, dynamic ->
        dynamic([t], ^dynamic and fragment("EXTRACT(DAY FROM updated_at) = ?", ^String.to_integer(value)))

      {"status_id", value}, dynamic ->
        dynamic([t], ^dynamic and t.transaction_status_id == ^value)

      {_, _}, dynamic ->
        dynamic
    end)
  end
end
