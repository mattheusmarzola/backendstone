defmodule Backendstone.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :decimal
      add :account_to, :integer

      timestamps()
    end

  end
end
