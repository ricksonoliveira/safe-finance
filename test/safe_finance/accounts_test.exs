defmodule SafeFinance.AccountsTest do
  use SafeFinance.DataCase

  alias SafeFinance.Accounts

  describe "users" do
    alias SafeFinance.Accounts.User

    @valid_attrs %{email: "some email", name: "some name", password: "some password"}
    @update_attrs %{email: "some updated email", name: "some updated name", password: "some updated password"}
    @invalid_attrs %{email: nil, name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "user_finances" do
    alias SafeFinance.Accounts.UserFinances

    @valid_attrs %{balance: "120.5", currency: "some currency", user_id: 42}
    @update_attrs %{balance: "456.7", currency: "some updated currency", user_id: 43}
    @invalid_attrs %{balance: nil, currency: nil, user_id: nil}

    def user_finances_fixture(attrs \\ %{}) do
      {:ok, user_finances} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_finances()

      user_finances
    end

    test "list_user_finances/0 returns all user_finances" do
      user_finances = user_finances_fixture()
      assert Accounts.list_user_finances() == [user_finances]
    end

    test "get_user_finances!/1 returns the user_finances with given id" do
      user_finances = user_finances_fixture()
      assert Accounts.get_user_finances!(user_finances.id) == user_finances
    end

    test "create_user_finances/1 with valid data creates a user_finances" do
      assert {:ok, %UserFinances{} = user_finances} = Accounts.create_user_finances(@valid_attrs)
      assert user_finances.balance == Decimal.new("120.5")
      assert user_finances.currency == "some currency"
      assert user_finances.user_id == 42
    end

    test "create_user_finances/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_finances(@invalid_attrs)
    end

    test "update_user_finances/2 with valid data updates the user_finances" do
      user_finances = user_finances_fixture()
      assert {:ok, %UserFinances{} = user_finances} = Accounts.update_user_finances(user_finances, @update_attrs)
      assert user_finances.balance == Decimal.new("456.7")
      assert user_finances.currency == "some updated currency"
      assert user_finances.user_id == 43
    end

    test "update_user_finances/2 with invalid data returns error changeset" do
      user_finances = user_finances_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_finances(user_finances, @invalid_attrs)
      assert user_finances == Accounts.get_user_finances!(user_finances.id)
    end

    test "delete_user_finances/1 deletes the user_finances" do
      user_finances = user_finances_fixture()
      assert {:ok, %UserFinances{}} = Accounts.delete_user_finances(user_finances)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_finances!(user_finances.id) end
    end

    test "change_user_finances/1 returns a user_finances changeset" do
      user_finances = user_finances_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_finances(user_finances)
    end
  end
end
