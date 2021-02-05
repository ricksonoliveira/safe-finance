defmodule SafeFinance.OperationsTest do
  @moduledoc """
    Tests Operations
  """
  use SafeFinance.DataCase

  alias SafeFinance.Operations
  alias SafeFinance.Accounts.UserFinance
  alias SafeFinance.Repo

  describe "operations" do

    @value "20.00"

    def from_acc_fixture() do
      {:ok, account} = Repo.insert(UserFinance.changeset(%UserFinance{}))
      account
    end

    def to_acc_fixture() do
      {:ok, account} = Repo.insert(UserFinance.changeset(%UserFinance{}))
      account
    end

    test "transaction/3 can transfer with valid params" do
      from_acc = from_acc_fixture()
      to_acc = to_acc_fixture()
      assert from_acc.balance == 1000
      assert to_acc.balance == 1000
      assert Operations.transaction(from_acc.id, to_acc.id, @value) ==
        {:ok, "Transaction was sucessfull! From: #{from_acc.id} To: #{to_acc.id} Value: #{@value}"}
    end

    test "perform_update/3 can update from account and destiny account balances" do
      from_acc = from_acc_fixture()
      to_acc = to_acc_fixture()
      assert Operations.perform_update(from_acc, to_acc.id, @value) ==
      {:ok, "Transaction was sucessfull! From: #{from_acc.id} To: #{to_acc.id} Value: #{@value}"}
    end

    test "update_account/2 can sub value for update" do
      from_acc = from_acc_fixture()
      assert from_acc.balance === 1000
      from_acc
      |> Operations.update_account(%{balance: Decimal.sub(from_acc.balance, @value)})
      assert Decimal.sub(from_acc.balance, @value) == Decimal.new("980.00")
    end

    test "perform_operation/3 can sub value from account" do
      from_acc = from_acc_fixture()
      assert from_acc.balance === 1000
      from_acc
      |> Operations.perform_operation(Decimal.new(@value), :sub)
      assert Decimal.sub(from_acc.balance, @value) == Decimal.new("980.00")
    end

    test "perform_operation/3 can sum value from account" do
      from_acc = from_acc_fixture()
      assert from_acc.balance === 1000
      from_acc
      |> Operations.perform_operation(Decimal.new(@value), :sum)
      assert Decimal.add(from_acc.balance, @value) == Decimal.new("1020.00")
    end

    test "perform_account_update/2 can perform an update on account" do
      account = from_acc_fixture()
      assert account.balance === 1000
      account
      |> Operations.perform_account_update("1000.00")
      assert Decimal.add(account.balance, "1000.00") == Decimal.new("2000.00")
    end

    test "transaction/3 should show error if tris to transfer more than account has" do
      from_acc = from_acc_fixture()
      to_acc = to_acc_fixture()
      assert from_acc.balance == 1000
      assert to_acc.balance == 1000
      negative_transaction = Operations.transaction(from_acc.id, to_acc.id, Decimal.new("1100"))
      assert negative_transaction == {:error, "Transaction Error: Value above your limit!"}
    end


    test "transaction/3 should show error if tries to transfer to the same account" do
      from_acc = from_acc_fixture()
      negative_transaction = Operations.transaction(from_acc.id, from_acc.id, Decimal.new("1000"))
      assert negative_transaction == {:error, "Transaction Error: Cannot transfer to the same account."}
    end
  end
end
