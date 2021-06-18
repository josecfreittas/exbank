defmodule Exbank.TransactionsTest do
  use Exbank.DataCase

  alias Exbank.Transactions

  describe "transactions" do
    alias Exbank.Transactions.Transaction
    alias Exbank.Accounts

    @invalid_attrs %{"amount" => "1000", "sender_cpf" => 10, "recipient_cpf" => 5}

    test "create_transaction/1 with valid data creates a transaction" do
      sender_cpf = "103.630.400-05"
      recipient_cpf = "643.745.870-47"

      Accounts.create_account(%{
        "cpf" => sender_cpf,
        "name" => "some name",
        "password" => "somepassword"
      })

      Accounts.create_account(%{
        "cpf" => recipient_cpf,
        "name" => "some name",
        "password" => "somepassword"
      })

      valid_attrs = %{
        "amount" => 50,
        "recipient_cpf" => recipient_cpf,
        "sender_cpf" => sender_cpf
      }

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.amount == valid_attrs["amount"]
      assert transaction.recipient_cpf == recipient_cpf
      assert transaction.sender_cpf == sender_cpf
    end

    test "create_transaction/1 with invalid data returns message error" do
      assert {:error, _message} = Transactions.create_transaction(@invalid_attrs)
    end
  end
end
