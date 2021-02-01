defmodule SafeFinance.OperationsTest do
  use SafeFinance.DataCase

  alias SafeFinance.Operations

  describe "operations" do
    alias SafeFinance.Operations.Operation
    alias SafeFinance.Accounts

    @from_attrs %{
      name: "Rick",
      email: "rick@email.com",
      password: "123456"
    }
    @to_attrs %{
      name: "Ana",
      email: "ana@email.com",
      password: "123456"
    }

    def from_acc_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@from_attrs)
        |> Accounts.create_user()

      user
    end

    def to_acc_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@to_attrs)
        |> Accounts.create_user()

      user
    end

    def from_acc_id_fixture do
      Accounts.get!(from_acc_fixture().id)
    end

    def to_acc_id_fixture do
      Accounts.get!(to_acc_fixture().id)
    end

    @from_acc_id from_acc_fixture()
    @to_acc_id to_acc_fixture()
    @value "20.00"

    test "transaction/0 can transfer with valid params" do
      catch_exit(Operation.transaction(@from_acc_id, @to_acc_id, @value))
    end

    test "perform_update/0 can update from account and destiny account balances" do
      assert Operation.perform_update(@from_acc_id, @to_acc_id, @value) ==
      {:ok, "Transaction was sucessfull! From: #{@from_acc_id} To: #{@to_acc_id} Value: #{@value}"}
    end

    test "perform_operation/0 can sub value from account" do
      catch_exit(Operation.perform_operation(@from_acc_id, @value, :sub))
    end

    test "perform_operation/1 can sum value from account" do
      catch_exit(Operation.perform_operation(@to_acc_id, @value, :sum))
    end
  end
end
