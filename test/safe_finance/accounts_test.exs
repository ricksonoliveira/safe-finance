defmodule SafeFinance.AccountsTest do
@moduledoc """
  Accounts Tests
"""
  use SafeFinance.DataCase

  alias SafeFinance.Accounts

  describe "users" do
    alias SafeFinance.Accounts.User
    alias SafeFinance.Repo

    @valid_attrs %{email: "some-email@mail.com", name: "some name", password: "some password"}
    @invalid_attrs %{email: nil, name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    @doc """
    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end


    test "get!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get!(user.id) == user.id
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some-email@mail.com"
      assert user.name == "some name"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
    """
  end
end
