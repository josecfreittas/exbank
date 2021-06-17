defmodule Exbank.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :amount, :integer
    field :sender_cpf, :string
    field :recipient_cpf, :string
    field :chargebacked, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :sender_cpf, :recipient_cpf, :chargebacked])
    |> validate_required([:amount, :recipient_cpf])
    |> check_constraint(:amount, name: :balance_must_be_positive)
  end
end
