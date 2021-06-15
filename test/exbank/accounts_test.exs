defmodule Exbank.AccountsTest do
  use Exbank.DataCase

  alias Exbank.Accounts

  describe "accounts" do
    alias Exbank.Accounts.Account

    import Exbank.AccountsFixtures

    @invalid_attrs %{balance: nil, cpf: nil, name: nil, password: nil}

    test "get_account!/1 returns the account with given cpf" do
      fixture = account_fixture()
      account = Accounts.get_account!(:cpf, fixture.cpf)
      assert account.balance == fixture.balance
      assert account.cpf == fixture.cpf
      assert account.name == fixture.name
    end

    test "create_account/1 with valid data creates a account" do
      valid_attrs = %{cpf: "some cpf", name: "some name", password: "somepassword"}

      assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)
      assert account.balance == 0
      assert account.cpf == "some cpf"
      assert account.name == "some name"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end
  end
end
