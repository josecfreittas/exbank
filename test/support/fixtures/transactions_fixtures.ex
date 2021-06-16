defmodule Exbank.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exbank.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        "amount" => 42,
        "recipient_cpf" => "643.745.870-47",
        "sender_cpf" => "103.630.400-05"
      })
      |> Exbank.Transactions.create_transaction()

    transaction
  end
end
