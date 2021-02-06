defmodule SafeFinance.Operations do
  @moduledoc """
    Operations context.
  """

  alias SafeFinance.Accounts
  alias SafeFinance.Accounts.UserFinance
  alias SafeFinance.Repo

  @doc """
    Responsible for performing a transaction between two accounts
  """
  def transaction(from_acc_id, to_acc_id, value) do
    from_acc = Accounts.get(from_acc_id)
    dec_value = Decimal.new(value)
    to_acc = Accounts.get(to_acc_id)

    account_does_not_exists(from_acc, to_acc, dec_value)
  end

  def case_operation(from_acc, to_acc_id, value) do
    case is_negative?(from_acc.balance, value) do
      true -> {:error, "Transaction Error: Value above your limit!"}
      false ->  case is_transfer_self?(from_acc.id, to_acc_id) do
        true -> {:error, "Transaction Error: Cannot transfer to the same account."}
        false -> perform_update(from_acc, to_acc_id, value)
      end
    end
  end

  def account_does_not_exists(from_acc, to_acc, dec_value) do
     cond do
       !from_acc ->
         {:error, "Transaction Error: Origin account does not exists!"}
       !to_acc ->
         {:error, "Transaction Error: Destiny account does not exists!"}
        true -> case_operation(from_acc, to_acc.id, dec_value)
     end
  end

  # Validates if has balance
  defp is_negative?(from_acc_balance, value) do
    Decimal.sub(from_acc_balance, value)
    |> Decimal.negative?()
  end

  # Checks if the transfer is to the same account
  defp is_transfer_self?(from_acc_id, to_acc_id) do
    from_acc_id === to_acc_id
  end

  @doc """
    Performs an update to the accounts being transfered using transaction concept
  """
  def perform_update(from_acc, to_acc_id, value) do
    to_acc = Accounts.get(to_acc_id)

    transaction = Ecto.Multi.new()
    |> Ecto.Multi.update(:from_account, perform_operation(from_acc, value, :sub))
    |> Ecto.Multi.update(:to_account, perform_operation(to_acc, value, :sum))
    |> Repo.transaction()

    case transaction do
      {:ok, _} ->
        {:ok, "Transaction was sucessfull! From: #{from_acc.id} To: #{to_acc.id} Value: #{value}"}
      {:error, :from_account, changeset, _} -> {:error, changeset}
      {:error, :to_account, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
    Add balance amount to account
  """
  def perform_account_update(acc, value) do
    transaction = Ecto.Multi.new()
    |> Ecto.Multi.update(:account, perform_operation(acc, value, :sum))
    |> Repo.transaction()

    case transaction do
      {:ok, _} ->
        {:ok, "Transaction was sucessfull! Added value of: #{value} To Account: #{acc.id}"}
      {:error, :acc_account, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
    Performs the operation to subtract the amount to transfer
  """
  def perform_operation(from_acc, value, :sub) do
    from_acc
    |> update_account(%{balance: Decimal.sub(from_acc.balance, value)})
  end

  @doc """
    Performs the operation to add the quantity tranfered to account
  """
  def perform_operation(to_acc, value, :sum) do
    to_acc
    |> update_account(%{balance: Decimal.add(to_acc.balance, value)})
  end

  @doc """
    Updates the UserFinance changeset attributes
  """
  def update_account(%UserFinance{} = acc, attrs) do
    UserFinance.changeset(acc, attrs)
  end
end
