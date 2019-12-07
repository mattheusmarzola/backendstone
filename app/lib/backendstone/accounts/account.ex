defmodule Backendstone.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backendstone.UserManager.User
  alias Backendstone.Transactions.Transaction

  schema "accounts" do
    field :balance, :decimal

    belongs_to :user, User
    has_many :transaction, Transaction
    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:balance, :user_id])
    |> validate_required([:balance, :user_id])
  end
end
