defmodule Backendstone.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backendstone.Accounts.Account
  alias Backendstone.Transactions.Type

  schema "transactions" do
    field :account_to, :integer
    field :amount, :decimal

    belongs_to :account, Account
    has_one :type, Type
    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :account_to])
    |> validate_required([:amount, :account_to])
  end
end
