defmodule SafeFinanceWeb.UserView do
  @moduledoc """
    User View
  """
  use SafeFinanceWeb, :view

  def render("account.json", %{user: user, account: account}) do
    %{
      balance: account.balance,
      currency: account.currency,
      user: %{
        id: user.id,
        name: user.name,
        email: user.email,
        password_hash: user.password_hash
      }
    }
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  @doc """
    Json resource of how an user should be displayed
  """
  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      password_hash: user.password_hash,
      accounts: %{
        id: user.user_finance.id,
        balance: user.user_finance.balance,
        currency: user.user_finance.currency
      }
    }
  end
end
