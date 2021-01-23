defmodule SafeFinanceWeb.UserFinancesView do
  use SafeFinanceWeb, :view
  alias SafeFinanceWeb.UserFinancesView

  def render("index.json", %{user_finances: user_finances}) do
    %{data: render_many(user_finances, UserFinancesView, "user_finances.json")}
  end

  def render("show.json", %{user_finances: user_finances}) do
    %{data: render_one(user_finances, UserFinancesView, "user_finances.json")}
  end

  def render("user_finances.json", %{user_finances: user_finances}) do
    %{id: user_finances.id,
      balance: user_finances.balance,
      currency: user_finances.currency,
      user_id: user_finances.user_id}
  end
end
