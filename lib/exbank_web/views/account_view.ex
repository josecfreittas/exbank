defmodule ExbankWeb.AccountView do
  use ExbankWeb, :view
  alias ExbankWeb.AccountView

  def render("show.json", %{account: account}) do
    %{data: render_one(account, AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{
      cpf: account.cpf,
      name: account.name,
      balance: account.balance
    }
  end

  def render("auth.json", %{access: access}) do
    %{access: access}
  end
end
