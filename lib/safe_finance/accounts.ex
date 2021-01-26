defmodule SafeFinance.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias SafeFinance.Repo
  alias SafeFinance.Accounts.{UserFinances, User}

  @doc """
    Cria um usuário no banco com transações segura de banco de dados
  """
  def create_user(attrs \\ %{}) do
    transaction =
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user, insert_user(attrs))
    |> Ecto.Multi.insert(:account, fn %{user: user} ->
      user
       |> Ecto.build_assoc(:user_finances)
       |> UserFinances.changeset()
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
    Get all users
  """
  def list_users(), do: Repo.all(User) |> Repo.preload(:user_finances)

  @doc """
  Gets a single user.
  """
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(:user_finances)
end
