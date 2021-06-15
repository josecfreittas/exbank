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

  def get_account!(:cpf, cpf) do
    query =
      from(
        account in "accounts",
        where: account.cpf == ^cpf,
        select: [:balance, :cpf, :name, :password]
      )

    Repo.one!(query)
  end

  def create_account(attrs \\ %{}) do
    attrs =
      case attrs do
        %{:password => password} when not is_nil(password) ->
          %{:password_hash => password_hash} = Bcrypt.add_hash(password)
          %{attrs | :password => password_hash}

        %{"password" => password} when not is_nil(password) ->
          %{:password_hash => password_hash} = Bcrypt.add_hash(password)
          %{attrs | "password" => password_hash}

        _ ->
          attrs
      end

    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
