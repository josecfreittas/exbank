defmodule Exbank.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :integer
      add :sender_cpf, references(:accounts, on_delete: :nothing, type: :string, column: :cpf)
      add :recipient_cpf, references(:accounts, on_delete: :nothing, type: :string, column: :cpf)

      timestamps()
    end

    create index(:transactions, [:sender_cpf])
    create index(:transactions, [:recipient_cpf])
    create constraint(:transactions, :amount_must_be_positive, check: "amount >= 0")
  end
end
