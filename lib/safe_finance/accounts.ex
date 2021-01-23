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
    Repo.all(User)
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
    Cria um usuário no banco
  """
  def create_user(attrs \\ %{}) do
    case insert_user(attrs) do
      {:ok, user} ->
        {:ok, account} = user
        |> Ecto.build_assoc(:user_finances)
        |> UserFinances.changeset()
        |> Repo.insert()
        {:ok, account |> Repo.preload(:user)}
        {:error, changeset} -> {:error, changeset}
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
    |> Repo.insert()
  end

  def get_users(), do: Repo.all(User) |> Repo.preload(:user_finances)
end
