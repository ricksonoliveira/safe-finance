defmodule SafeFinanceWeb.OperationView do
  use SafeFinanceWeb, :view

  def render("success.json", %{message: message}) do
    %{
      message: message
    }
  end
end
