defmodule SafeFinance.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias SafeFinance.Repo

  alias SafeFinance.Accounts.{UserFinances, User}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User) |> Repo.preload(:user_finances)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

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
  Insert de um usuário.

  ## Examples

      iex> inser_user(%{field: value})
      {:ok, %User{}}

      iex> inser_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def insert_user(attrs) do
    %User{}
    |> User.changeset(attrs)
  end

  def get_users(), do: Repo.all(User) |> Repo.preload(:user_finances)
end
