defmodule SafeFinance.AccountsTest do
@moduledoc """
  Accounts Tests
"""
  use SafeFinance.DataCase

  alias SafeFinance.Accounts
  alias SafeFinance.Accounts.User
  alias SafeFinance.Repo

  describe "users" do

    @valid_attrs %{
      name: "Rick",
      email: "rick@mail.com",
      password: "123456"
    }
    @invalid_attrs %{
      name: nil,
      email: nil,
      password: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user, _user_finance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

        user
    end

    test "list_users/0 returns all users" do
      user_fixture()
      assert Enum.count(Accounts.list_users()) == 1
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id).name == user.name
    end


    test "get/1 returns the user with given id" do
      user = user_fixture()
        |> Repo.preload(:user_finance)
      assert Accounts.get(user.user_finance.id).id == user.user_finance.id
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user, _user_finance} = Accounts.create_user(@valid_attrs)
      assert user.email == "rick@mail.com"
      assert user.name == "Rick"
      assert user.password == "123456"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "insert_user/1 returns a user changeset" do
      assert %Ecto.Changeset{} = Accounts.insert_user(@valid_attrs)
    end
  end
end
