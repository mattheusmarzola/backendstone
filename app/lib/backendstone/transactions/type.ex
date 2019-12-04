defmodule Backendstone.Transactions.Type do
  use Ecto.Schema
  import Ecto.Changeset

  alias Backendstone.Transactions.Type

  schema "types" do
    field :name, :string

    has_many :transaction, Transaction
    timestamps()
  end

  @doc false
  def changeset(type, attrs) do
    type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
