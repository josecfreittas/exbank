defmodule Exbank.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :cpf, :string, primary_key: true
      add :name, :string
      add :balance, :integer, default: 500
      add :password, :string

      timestamps()
    end

    create constraint(:accounts, :balance_must_be_positive, check: "balance >= 0")
  end
end
