defmodule ExbankWeb.TransactionView do
  use ExbankWeb, :view
  alias ExbankWeb.TransactionView

  def render("index.json", %{transactions: transactions, account_cpf: account_cpf}) do
    %{
      data:
        render_many(transactions, TransactionView, "transaction.json", account_cpf: account_cpf)
    }
  end

  def render("show.json", %{transaction: transaction, account_cpf: account_cpf}) do
    %{
      data: render_one(transaction, TransactionView, "transaction.json", account_cpf: account_cpf)
    }
  end

  def render("transaction.json", %{transaction: transaction, account_cpf: account_cpf}) do
    id_string =
      try do
        Ecto.UUID.load!(transaction.id)
      rescue
        _ -> transaction.id
      end

    operation =
      cond do
        account_cpf === transaction.sender_cpf -> "sent"
        account_cpf === transaction.recipient_cpf -> "received"
        true -> "unknown"
      end

    %{
      id: id_string,
      amount: transaction.amount,
      sender_cpf: transaction.sender_cpf,
      recipient_cpf: transaction.recipient_cpf,
      operation: operation
    }
  end
end
