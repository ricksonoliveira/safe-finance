defmodule SafeFinance.OperationsTest do
  use SafeFinance.DataCase

  alias SafeFinance.Operations

  describe "operations" do
    alias SafeFinance.Operations.Operation

    @valid_attrs %{account_from: 42, account_to: 42, value: "120.5"}
    @update_attrs %{account_from: 43, account_to: 43, value: "456.7"}
    @invalid_attrs %{account_from: nil, account_to: nil, value: nil}

    def operation_fixture(attrs \\ %{}) do
      {:ok, operation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Operations.create_operation()

      operation
    end

    test "list_operations/0 returns all operations" do
      operation = operation_fixture()
      assert Operations.list_operations() == [operation]
    end

    test "get_operation!/1 returns the operation with given id" do
      operation = operation_fixture()
      assert Operations.get_operation!(operation.id) == operation
    end

    test "create_operation/1 with valid data creates a operation" do
      assert {:ok, %Operation{} = operation} = Operations.create_operation(@valid_attrs)
      assert operation.account_from == 42
      assert operation.account_to == 42
      assert operation.value == Decimal.new("120.5")
    end

    test "create_operation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operations.create_operation(@invalid_attrs)
    end

    test "update_operation/2 with valid data updates the operation" do
      operation = operation_fixture()

      assert {:ok, %Operation{} = operation} =
               Operations.update_operation(operation, @update_attrs)

      assert operation.account_from == 43
      assert operation.account_to == 43
      assert operation.value == Decimal.new("456.7")
    end

    test "update_operation/2 with invalid data returns error changeset" do
      operation = operation_fixture()
      assert {:error, %Ecto.Changeset{}} = Operations.update_operation(operation, @invalid_attrs)
      assert operation == Operations.get_operation!(operation.id)
    end

    test "delete_operation/1 deletes the operation" do
      operation = operation_fixture()
      assert {:ok, %Operation{}} = Operations.delete_operation(operation)
      assert_raise Ecto.NoResultsError, fn -> Operations.get_operation!(operation.id) end
    end

    test "change_operation/1 returns a operation changeset" do
      operation = operation_fixture()
      assert %Ecto.Changeset{} = Operations.change_operation(operation)
    end
  end
end
