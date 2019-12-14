defmodule Backendstone.Reports do

  import Ecto.Query, warn: false
  alias Backendstone.Repo

  alias Backendstone.Transactions.Transaction


  @doc """
  Returns the report data of transactions.
  The parameter is a map with a list of attributes to filter on. 
  If the value 0 is entered to a attribute, it will be ignored in the filter.
  
  They accepted attributes: :year, :month, :day, :transaction_status_id, :type_id.

  Returns a decimal with total amount of transactions
  ## Examples

      iex> list_transactions([year: 2019, month: 12, day: 0])
      #Decimal<2600.0>

  """
  def total_transaction(params) do
    Transaction
     |> select([t], sum(t.amount))
     |> where(^filter_total_transactions(params))
     |> Repo.one()
  end

  defp filter_total_transactions(params) do
    Enum.reduce(params, dynamic(true), fn
      {_, "0"}, dynamic ->
        dynamic

      {"year", value}, dynamic ->
        dynamic([t], ^dynamic and fragment("EXTRACT(YEAR FROM updated_at) = ?", ^String.to_integer(value)))

      {"month", value}, dynamic ->
        dynamic([t], ^dynamic and fragment("EXTRACT(MONTH FROM updated_at) = ?", ^String.to_integer(value)))

      {"day", value}, dynamic ->
        dynamic([t], ^dynamic and fragment("EXTRACT(DAY FROM updated_at) = ?", ^String.to_integer(value)))

      {"transaction_status_id", value}, dynamic ->
        dynamic([t], ^dynamic and t.transaction_status_id == ^value)

      {"type_id", value}, dynamic ->
        dynamic([t], ^dynamic and t.type_id == ^value)

      {_, _}, dynamic ->
        dynamic
    end)
  end
end
