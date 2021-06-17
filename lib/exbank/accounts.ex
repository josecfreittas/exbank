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

  def get_account(cpf) do
    Repo.get_by(Account, cpf: cpf)
  end

  def create_account(attrs) do
    case Account.changeset(%Account{}, attrs) do
      %{:valid? => true} ->
        %{:password_hash => password_hash} = Bcrypt.add_hash(attrs["password"])
        attrs = %{attrs | "password" => password_hash}

        %Account{}
        |> Account.changeset(attrs)
        |> Repo.insert()

      changeset ->
        {:error, changeset}
    end
  end
end
