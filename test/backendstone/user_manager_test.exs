defmodule Backendstone.UserManagerTest do
  use Backendstone.DataCase

  alias Backendstone.UserManager

  describe "users" do
    alias Backendstone.UserManager.User

    @valid_attrs %{
      email: "some@email.com",
      password: "some password",
      password_confirmation: "some password",
      username: "someusername"
    }

    @update_attrs %{
      email: "some@updated.email",
      password: "some updated password",
      password_confirmation: "some updated password",
      username: "someupdatedusername"
    }

    @invalid_attrs %{email: nil, password: nil, password_confirmation: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserManager.create_user()
      user = UserManager.get_user!(user.id)
      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserManager.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserManager.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserManager.create_user(@valid_attrs)
      assert {:ok, user} == Argon2.check_pass(user, "some password", hash_key: :password_hash)
      assert user.email == "some@email.com"
      assert user.username == "someusername"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserManager.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = UserManager.update_user(user, @update_attrs)
      assert {:ok, user} == Argon2.check_pass(user, "some updated password", hash_key: :password_hash)
      assert user.email == "some@updated.email"
      assert user.username == "someupdatedusername"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserManager.update_user(user, @invalid_attrs)
      assert user == UserManager.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserManager.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserManager.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserManager.change_user(user)
    end
  end
end
