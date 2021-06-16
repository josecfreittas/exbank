defmodule ExbankWeb.TransactionView do
  use ExbankWeb, :view
  alias ExbankWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    id_string =
      try do
        Ecto.UUID.load!(transaction.id)
      rescue
        _ -> transaction.id
      end

    %{
      id: id_string,
      amount: transaction.amount
    }
  end
end
