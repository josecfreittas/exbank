defmodule ExbankWeb.TransactionController do
  use ExbankWeb, :controller

  alias Exbank.Transactions
  alias Exbank.Transactions.Transaction

  action_fallback ExbankWeb.FallbackController

  def index(conn, _params) do
    transactions = Transactions.list_account_transactions(:account_cpf, conn.assigns.account_cpf)
    render(conn, "index.json", transactions: transactions, account_cpf: conn.assigns.account_cpf)
  end

  def create(conn, transaction_params) do
    params = Map.put(transaction_params, "sender_cpf", conn.assigns.account_cpf)

    with {:ok, %Transaction{} = transaction} <- Transactions.create_transaction(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction, account_cpf: conn.assigns.account_cpf)
    else
      {:error, message} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: message}))
    end
  end

  def show(conn, %{"id" => id}) do
    account_cpf = conn.assigns.account_cpf
    transaction = Transactions.get_transaction!(id)

    cond do
      transaction.sender_cpf === account_cpf || transaction.recipient_cpf === account_cpf ->
        render(conn, "show.json", transaction: transaction, account_cpf: conn.assigns.account_cpf)

      true ->
        send_resp(conn, 401, "Unauthorized")
    end
  end
end
