defmodule Backendstone.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Backendstone.Repo

  alias Backendstone.Accounts.Account

  @doc """
  Receives a account and the value of debit and update the account balance.

  ## Examples

      iex> debit_amount(account, %{amount: "100.00"})
      {:ok, %Account{}}

      iex> debit_amount(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def debit_amount(account, %{amount: amount}) do
    Decimal.new(account.balance)
     |> Decimal.sub(amount)
     |> (&(Map.put(%{}, :balance, &1))).()
     |> (&(update_account(account, &1))).()
  end

  @doc """
  Receives a account and the value of credit and update the account balance.

  ## Examples

      iex> credit_amount(account, %{amount: "100.00"})
      {:ok, %Account{}}

      iex> credit_amount(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def credit_amount(account, %{amount: amount}) do
    Decimal.new(account.balance)
     |> Decimal.add(amount)
     |> (&(Map.put(%{}, :balance, &1))).()
     |> (&(update_account(account, &1))).()
  end


  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Gets a single account by user_id.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account_by_user_id!(123)
      %Account{}

      iex> get_account_by_user_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account_by_user_id!(id), do: Repo.get_by!(Account, user_id: id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end
end
