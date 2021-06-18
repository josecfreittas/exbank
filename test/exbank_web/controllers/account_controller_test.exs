defmodule ExbankWeb.AccountControllerTest do
  use ExbankWeb.ConnCase

  @create_attrs %{
    "cpf" => "some cpf",
    "name" => "some name",
    "password" => "somepassword"
  }
  @invalid_attrs %{"cpf" => 10, "name" => 5, "password" => true}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), @create_attrs)
      assert %{"cpf" => _cpf} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "login" do
    test "try to make login with correct credentials ", %{conn: conn} do
      attrs = %{
        "cpf" => "659.856.080-26",
        "name" => "Generic Name",
        "password" => "genericpassword"
      }

      post(conn, Routes.account_path(conn, :create), attrs)
      conn = post(conn, Routes.account_path(conn, :login), attrs)
      assert json_response(conn, 200)["assigns"]["access"] != %{}
    end
    test "try to make login with incorrect credentials ", %{conn: conn} do
      attrs = %{
        "cpf" => "390.438.880-01",
        "password" => "genericpassword"
      }
      conn = post(conn, Routes.account_path(conn, :login), attrs)
      assert json_response(conn, 400)["error"] != %{}
    end
  end
end
