defmodule SafeFinanceWeb.UserFinancesController do
  @moduledoc """
    Controller responsavel pelas configurações de financeiro do usuário
  """
  use SafeFinanceWeb, :controller

  alias SafeFinance.Accounts
  alias SafeFinance.Accounts.UserFinances

  action_fallback SafeFinanceWeb.FallbackController

  def index(conn, _params) do
    user_finances = Accounts.list_user_finances()
    render(conn, "index.json", user_finances: user_finances)
  end

  def create(conn, %{"user_finances" => user_finances_params}) do
    with {:ok, %UserFinances{} = user_finances} <- Accounts.create_user_finances(user_finances_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_finances_path(conn, :show, user_finances))
      |> render("show.json", user_finances: user_finances)
    end
  end

  def show(conn, %{"id" => id}) do
    user_finances = Accounts.get_user_finances!(id)
    render(conn, "show.json", user_finances: user_finances)
  end

  def update(conn, %{"id" => id, "user_finances" => user_finances_params}) do
    user_finances = Accounts.get_user_finances!(id)

    with {:ok, %UserFinances{} = user_finances} <- Accounts.update_user_finances(user_finances, user_finances_params) do
      render(conn, "show.json", user_finances: user_finances)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_finances = Accounts.get_user_finances!(id)

    with {:ok, %UserFinances{}} <- Accounts.delete_user_finances(user_finances) do
      send_resp(conn, :no_content, "")
    end
  end
end
