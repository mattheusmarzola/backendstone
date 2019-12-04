defmodule Backendstone.UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Argon2
  alias Backendstone.Accounts.Account

  schema "users" do
    field :email, :string
    field :password, :string
    field :username, :string

    has_one :account, Account
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email])
    |> validate_required([:username, :password, :email])
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

end
