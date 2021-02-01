defmodule SafeFinance.Accounts do
  @moduledoc """
    The Accounts context.
  """

  import Ecto.Query, warn: false

  alias SafeFinance.Repo
  alias SafeFinance.Accounts.{UserFinance, User}

  @doc """
    Creates an user into database using trasaction concept.
  """
  def create_user(attrs \\ %{}) do
    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user, insert_user(attrs))
      |> Ecto.Multi.insert(:account, fn %{user: user} ->
        user
        |> Ecto.build_assoc(:user_finance)
        |> UserFinance.changeset(%{"account" => user.user_finance})
      end)
      |> Repo.transaction()

    case transaction do
      {:ok, operations} -> {:ok, operations.user, operations.account}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
    Insert a user.
  """
  def insert_user(attrs) do
    %User{}
    |> User.changeset(attrs)
  end

  @doc """
    Get all users.
  """
  def list_users(), do: Repo.all(User) |> Repo.preload(:user_finance)

  @doc """
    Returns Account by id.
  """
  def get(id), do: Repo.get(UserFinance, id)

  @doc """
    Gets a single user by id.
  """
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(:user_finance)
end
