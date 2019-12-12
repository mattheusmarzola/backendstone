defmodule Backendstone.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backendstone.Accounts.Account
  alias Backendstone.Transactions.Type
  alias Backendstone.Transactions.TransactionStatus

  schema "transactions" do
    field :amount, :decimal

    belongs_to :target_account, Account, foreign_key: :target_account_id
    belongs_to :account, Account, foreign_key: :account_id

    belongs_to :type, Type, foreign_key: :type_id
    belongs_to :transaction_status, TransactionStatus, foreign_key: :transaction_status_id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :target_account_id, :type_id, :transaction_status_id, :account_id])
    |> validate_required([:amount, :type_id, :transaction_status_id, :account_id])
  end
end
