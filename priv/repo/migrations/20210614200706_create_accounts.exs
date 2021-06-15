defmodule Exbank.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :cpf, :string, primary_key: true
      add :name, :string
      add :balance, :integer, default: 0
      add :password, :string

      timestamps()
    end
  end
end
