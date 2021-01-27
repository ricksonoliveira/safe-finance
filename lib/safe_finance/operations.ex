defmodule SafeFinance.Operations do
  @moduledoc """
    Operations context.
  """

  alias SafeFinance.Accounts
  alias SafeFinance.Accounts.UserFinance
  alias SafeFinance.Repo

  def transaction(from_acc_id, to_acc_id, value) do
    from_acc = Accounts.get!(from_acc_id)
    value = Decimal.new(value)

    # Validate is limit negative
    case is_negative?(from_acc.balance, value) do
      true  -> {:error, "Unable to process transaction, value above your limit!"}
      false -> perform_update(from_acc, to_acc_id, value)
    end

    # Validade are accounts ids the same
    case from_acc_id === to_acc_id do
      true -> {:error, "Transaction Error: Cannot trasnfer to yourself."}
      false -> perform_update(from_acc, to_acc_id, value)
    end
  end

  defp is_negative?(from_acc_balance, value) do
    Decimal.sub(from_acc_balance, value)
    |> Decimal.negative?()
  end

  def perform_update(from_acc, to_acc_id, value) do
    {:ok, from_acc} = perform_operation(from_acc, value, :sub)
    {:ok, to_acc} = Accounts.get!(to_acc_id)
    |> perform_operation(value, :sum)
    {:ok, "Transaction was sucessfull! From: #{from_acc.id} To: #{to_acc.id} Value: #{value}"}

  end

  def perform_operation(from_acc, value, :sub) do
    from_acc
    |> update_account(%{balance: Decimal.sub(from_acc.balance, value)})
  end

  def perform_operation(to_acc, value, :sum) do
    to_acc
    |> update_account(%{balance: Decimal.add(to_acc.balance, value)})
  end

  def update_account(%UserFinance{} = from_acc, attrs) do
    UserFinance.changeset(from_acc, attrs)
    |> Repo.update()
  end
end
