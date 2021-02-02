defmodule SafeFinanceWeb.OperationView do
  use SafeFinanceWeb, :view

  def render("success.json", %{message: message}) do
    %{
      message: message
    }
  end

  def render("account_value.json", %{account_id: account_id, value: value}) do
    %{
      message: "Account amount updated!",
      account_id: account_id,
      value: value
    }
  end
end
