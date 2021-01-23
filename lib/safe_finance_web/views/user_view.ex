defmodule SafeFinanceWeb.UserView do
  use SafeFinanceWeb, :view
  alias SafeFinanceWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "account.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      balance: account.balance,
      currency: account.currency,
      user: %{
        id: account.user.id,
        name: account.user.name,
        email: account.user.email,
        password: account.user.password,
      }
    }
  end
end
