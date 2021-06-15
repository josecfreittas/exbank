defmodule ExbankWeb.AccountControllerTest do
  use ExbankWeb.ConnCase

  @create_attrs %{
    cpf: "some cpf",
    name: "some name",
    password: "somepassword"
  }
  @invalid_attrs %{cpf: nil, name: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), @create_attrs)
      assert %{"cpf" => cpf} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end
  end
end
