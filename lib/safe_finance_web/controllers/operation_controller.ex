defmodule SafeFinanceWeb.OperationController do
  @moduledoc """
    Controller responsible for the financial transacions.
  """
  use SafeFinanceWeb, :controller

  alias SafeFinance.Operations

  action_fallback SafeFinanceWeb.FallbackController

  @doc """
    Performs a financial transaction on the system.
  """
  def transaction(
    conn,
    %{
      "from_account_id" => from_account_id,
      "to_account_id" => to_account_id,
      "value" => value
    }
  ) do
    with {:ok, message} <- Operations.transaction(from_account_id, to_account_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end
end
