defmodule Backendstone.Repo.Migrations.AddAccountIdToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :account_id, references(:accounts, on_delete: :delete_all)
    end
  end
end
