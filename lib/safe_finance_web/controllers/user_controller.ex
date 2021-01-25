defmodule SafeFinanceWeb.UserController do
  @moduledoc """
    Controller responsavel pelas ações do usuário
  """
  use SafeFinanceWeb, :controller

  alias SafeFinance.Accounts

  action_fallback SafeFinanceWeb.FallbackController

  @doc """
    Lista todos os usuários no banco de dados
  """
  def index(conn, _) do
    conn
    |> render("index.json", users: Accounts.list_users())
  end

  @doc """
    Cria um usuário no banco de dados
  """
  def signup(conn, %{"user" => user}) do
    with {:ok, user, user_finances} <- Accounts.create_user(user) do
      conn
      |> put_status(:created)
      |> render("account.json", %{user: user, account: user_finances})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end
end
