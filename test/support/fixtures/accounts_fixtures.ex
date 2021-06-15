defmodule Exbank.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Exbank.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        cpf: "745.297.360-75",
        name: "some name",
        password: "123password"
      })
      |> Exbank.Accounts.create_account()

    account
  end
end
