defmodule Backendstone.UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Argon2
  alias Backendstone.Accounts.Account

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :username, :string

    # Virtual fields:
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_one :account, Account
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :password_confirmation])
    |> validate_required([:username, :email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

end
