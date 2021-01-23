defmodule SafeFinanceWeb.UserFinancesControllerTest do
  use SafeFinanceWeb.ConnCase

  alias SafeFinance.Accounts
  alias SafeFinance.Accounts.UserFinances

  @create_attrs %{
    balance: "120.5",
    currency: "some currency",
    user_id: 42
  }
  @update_attrs %{
    balance: "456.7",
    currency: "some updated currency",
    user_id: 43
  }
  @invalid_attrs %{balance: nil, currency: nil, user_id: nil}

  def fixture(:user_finances) do
    {:ok, user_finances} = Accounts.create_user_finances(@create_attrs)
    user_finances
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_finances", %{conn: conn} do
      conn = get(conn, Routes.user_finances_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_finances" do
    test "renders user_finances when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_finances_path(conn, :create), user_finances: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_finances_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance" => "120.5",
               "currency" => "some currency",
               "user_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_finances_path(conn, :create), user_finances: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_finances" do
    setup [:create_user_finances]

    test "renders user_finances when data is valid", %{conn: conn, user_finances: %UserFinances{id: id} = user_finances} do
      conn = put(conn, Routes.user_finances_path(conn, :update, user_finances), user_finances: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_finances_path(conn, :show, id))

      assert %{
               "id" => id,
               "balance" => "456.7",
               "currency" => "some updated currency",
               "user_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_finances: user_finances} do
      conn = put(conn, Routes.user_finances_path(conn, :update, user_finances), user_finances: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_finances" do
    setup [:create_user_finances]

    test "deletes chosen user_finances", %{conn: conn, user_finances: user_finances} do
      conn = delete(conn, Routes.user_finances_path(conn, :delete, user_finances))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_finances_path(conn, :show, user_finances))
      end
    end
  end

  defp create_user_finances(_) do
    user_finances = fixture(:user_finances)
    %{user_finances: user_finances}
  end
end
