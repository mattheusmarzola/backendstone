defmodule Backendstone.Transactions.TransactionStatus do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backendstone.Transactions.Transaction

  schema "transaction_status" do
    field :name, :string

    has_many :transaction, Transaction
    timestamps()
  end

  @doc false
  def changeset(transaction_status, attrs) do
    transaction_status
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc false
  def changeset_id(transaction_status, attrs) do
    transaction_status
    |> cast(attrs, [:name])
  end
end
