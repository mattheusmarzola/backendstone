defmodule Backendstone.Repo.Migrations.AddTransactionStatusIdOnTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :transaction_status_id, references(:transaction_status, on_delete: :delete_all)
    end
  end
end
