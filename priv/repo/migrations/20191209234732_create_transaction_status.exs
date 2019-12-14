defmodule Backendstone.Repo.Migrations.CreateTransactionStatus do
  use Ecto.Migration

  def change do
    create table(:transaction_status) do
      add :name, :string

      timestamps()
    end

  end
end
