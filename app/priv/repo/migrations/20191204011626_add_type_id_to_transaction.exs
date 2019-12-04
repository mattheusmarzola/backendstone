defmodule Backendstone.Repo.Migrations.AddTypeIdToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :type_id, references(:types, on_delete: :delete_all)
    end
  end
end
