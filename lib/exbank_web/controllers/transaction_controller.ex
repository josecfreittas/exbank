defmodule ExbankWeb.TransactionController do
  use ExbankWeb, :controller

  alias Exbank.Transactions
  alias Exbank.Transactions.Transaction

  action_fallback ExbankWeb.FallbackController

  def index(conn, params) do
    transactions = Transactions.list_account_transactions(conn.assigns.account_cpf, params)
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
        |> put_view(ExbankWeb.ErrorView)
        |> put_status(400)
        |> render("error.json", message: message)
    end
  end

  def show(conn, %{"id" => id}) do
    account_cpf = conn.assigns.account_cpf
    transaction = Transactions.get_transaction!(id)

    cond do
      !has_access(transaction, account_cpf) ->
        conn
        |> put_view(ExbankWeb.ErrorView)
        |> put_status(401)
        |> render("error.json", message: "Unauthorized")

      true ->
        render(conn, "show.json", transaction: transaction, account_cpf: conn.assigns.account_cpf)
    end
  end

  def chargeback(conn, %{"id" => id}) do
    account_cpf = conn.assigns.account_cpf
    transaction = Transactions.get_transaction!(id)

    cond do
      !has_access(transaction, account_cpf) ->
        conn
        |> put_view(ExbankWeb.ErrorView)
        |> put_status(401)
        |> render("error.json", message: "Unauthorized")

      transaction.recipient_cpf !== account_cpf ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: "Only the recipient can make a chargeback."}))

      transaction.chargebacked ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: "Changeback already made."}))

      true ->
        Transactions.chargeback(transaction)
        send_resp(conn, 200, "Success.")
    end
  end

  defp has_access(%{sender_cpf: sender_cpf, recipient_cpf: recipient_cpf}, account_cpf),
    do: account_cpf in [sender_cpf, recipient_cpf]
end
