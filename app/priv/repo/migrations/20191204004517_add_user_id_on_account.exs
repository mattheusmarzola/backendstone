defmodule Backendstone.Repo.Migrations.AddUserIdOnAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
