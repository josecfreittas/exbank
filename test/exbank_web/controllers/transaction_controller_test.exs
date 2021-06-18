defmodule ExbankWeb.TransactionControllerTest do
  use ExbankWeb.ConnCase

  @create_attrs %{"amount" => 42, "recipient_cpf" => "811.752.130-04"}
  @invalid_attrs %{"amount" => "cem", "recipient_cpf" => 1234}

  @sender_attrs %{
    "cpf" => "828.960.350-95",
    "name" => "Generic Name",
    "password" => "genericpassword"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      post(conn, Routes.account_path(conn, :create), @sender_attrs)
      %{assigns: %{access: access}} = post(conn, Routes.account_path(conn, :login), @sender_attrs)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{access}")
        |> get(Routes.transaction_path(conn, :index))

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      %{"recipient_cpf" => recipient_cpf} = @create_attrs

      post(conn, Routes.account_path(conn, :create), @sender_attrs)

      post(conn, Routes.account_path(conn, :create), %{@sender_attrs | "cpf" => recipient_cpf})

      %{assigns: %{access: access}} = post(conn, Routes.account_path(conn, :login), @sender_attrs)

      transaction =
        conn
        |> put_req_header("authorization", "Bearer #{access}")
        |> post(Routes.transaction_path(conn, :create), @create_attrs)

      assert %{"id" => id} = json_response(transaction, 201)["data"]

      transaction =
        conn
        |> put_req_header("authorization", "Bearer #{access}")
        |> get(Routes.transaction_path(conn, :show, id))

      assert %{"id" => ^id, "amount" => 42} = json_response(transaction, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      post(conn, Routes.account_path(conn, :create), @sender_attrs)
      %{assigns: %{access: access}} = post(conn, Routes.account_path(conn, :login), @sender_attrs)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{access}")
        |> post(Routes.transaction_path(conn, :create), @invalid_attrs)

      assert json_response(conn, 400)["errors"] != %{}
    end
  end
end
