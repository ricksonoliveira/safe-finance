defmodule SafeFinanceWeb.UserController do
  @moduledoc """
    Controller responsavel pelas ações do usuário
  """
  use SafeFinanceWeb, :controller

  alias SafeFinance.Accounts

  action_fallback SafeFinanceWeb.FallbackController

  @doc """
    List all users with accounts from database
  """
  def index(conn, _) do
    conn
    |> render("index.json", users: Accounts.list_users())
  end

  @doc """
    Creates a user and his default account
  """
  def signup(conn, %{"user" => user}) do
    with {:ok, user, user_finance} <- Accounts.create_user(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, id: user.id))
      |> render("account.json", %{user: user, account: user_finance})
    end
  end

  @doc """
    Show a single user with account
  """
  def show(conn, %{"id" => id}) do
    conn
    |> render("show.json", user: Accounts.get_user!(id))
  end
end
