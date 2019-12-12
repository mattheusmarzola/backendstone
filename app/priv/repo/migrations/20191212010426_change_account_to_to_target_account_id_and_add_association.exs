defmodule Backendstone.Repo.Migrations.ChangeAccountToToTargetAccountIdAndAddAssociation do
  use Ecto.Migration

  def change do
    rename table(:transactions), :account_to, to: :target_account_id

    alter table(:transactions) do
      modify :target_account_id, references(:accounts)
    end
  end
end
