defmodule Exbank.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Exbank.Repo

  alias Exbank.Accounts.Account

  def list_accounts do
    Repo.all(Account)
  end

  def get_account(:cpf, cpf) do
    Repo.get_by(Account, cpf: cpf)
  end

  def create_account(attrs \\ %{}) do
    attrs = for {key, val} <- attrs, into: %{}, do: {to_string(key), val}

    %{:password_hash => password_hash} = Bcrypt.add_hash(attrs["password"])
    attrs = %{attrs | "password" => password_hash}

    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
