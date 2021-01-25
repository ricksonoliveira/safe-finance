defmodule SafeFinanceWeb.UserView do
  use SafeFinanceWeb, :view
  alias SafeFinanceWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("account.json", %{user: user, account: account}) do
    %{
      balance: account.balance,
      currency: account.currency,
      user: %{
        id: user.id,
        name: user.name,
        email: user.email,
        password_hash: user.password_hash,
      }
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      password_hash: user.password_hash,
      account: %{
        id: user.user_finances.id,
        balance: user.user_finances.balance,
        currency: user.user_finances.currency
      }
    }
  end
end
