defmodule Exbank.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:cpf, :string, autogenerate: false}
  @foreign_key_type :string
  schema "accounts" do
    field :name, :string
    field :balance, :integer, default: 0
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:cpf, :name, :password])
    |> validate_required([:cpf, :name, :password])
    |> unique_constraint(:cpf, name: :accounts_pkey)
    |> check_constraint(:balance, name: :balance_must_be_positive)
  end
end
