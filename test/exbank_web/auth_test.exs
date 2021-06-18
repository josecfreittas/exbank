defmodule ExbankWeb.AuthTest do
  use ExUnit.Case
  alias ExbankWeb.Auth

  describe "create jwt access token" do
    test "create a valid token" do
      cpf1 = "103.630.400-05"
      assert {:ok, _token, _clains} = Auth.generate_access(cpf1)
    end

    test "validate a access token" do
      cpf1 = "103.630.400-05"
      {:ok, token, _clains} = Auth.generate_access(cpf1)
      assert {:ok, %{"account_cpf" => account_cpf}} = Auth.verify(token)
      assert account_cpf == cpf1
    end
  end
end
