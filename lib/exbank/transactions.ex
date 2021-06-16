defmodule Exbank.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Exbank.Repo

  alias Exbank.Transactions.Transaction
  alias Exbank.Accounts.Account

  def list_account_transactions(:account_cpf, account_cpf) do
    query =
      from(
        transaction in "transactions",
        where:
          transaction.sender_cpf == ^account_cpf or transaction.recipient_cpf == ^account_cpf,
        select: [:id, :amount, :sender_cpf, :recipient_cpf, :inserted_at, :updated_at]
      )

    Repo.all(query)
  end

  def get_transaction!(id), do: Repo.get!(Transaction, id)

  def create_transaction(%{"sender_cpf" => sender, "recipient_cpf" => sender}),
    do: {:error, "It is not possible to make a transaction to yourself."}

  def create_transaction(attrs) do
    case Transaction.changeset(%Transaction{}, attrs) do
      %{:valid? => true} ->
        try do
          {:ok, result} =
            Repo.transaction(fn ->
              from(account in Account,
                update: [inc: [balance: ^(-attrs["amount"])]],
                where: account.cpf == ^attrs["sender_cpf"]
              )
              |> Repo.update_all([])

              from(account in Account,
                update: [inc: [balance: ^attrs["amount"]]],
                where: account.cpf == ^attrs["recipient_cpf"]
              )
              |> Repo.update_all([])

              %Transaction{}
              |> Transaction.changeset(attrs)
              |> Repo.insert()
            end)

          result
        rescue
          _ ->
            {:error, "The transaction failed."}
        end

      %{:valid? => false} ->
        {:error, "Invalid transaction."}
    end
  end

  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
