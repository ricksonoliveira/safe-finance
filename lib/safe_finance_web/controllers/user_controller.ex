defmodule SafeFinanceWeb.UserController do
  use SafeFinanceWeb, :controller

  alias SafeFinance.Accounts
  alias SafeFinance.Accounts.User

  action_fallback SafeFinanceWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def signup(conn, %{"user" => user}) do
    with {:ok, %User{} = user, account} <- Accounts.create_user(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user.id))
      |> render("account.json", %{user: user, account: account})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end
end
