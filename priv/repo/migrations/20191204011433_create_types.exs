defmodule Backendstone.Repo.Migrations.CreateTypes do
  use Ecto.Migration

  def change do
    create table(:types) do
      add :name, :string

      timestamps()
    end

  end
end
