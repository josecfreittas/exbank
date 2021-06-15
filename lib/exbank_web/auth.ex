defmodule ExbankWeb.Auth do
  use Joken.Config

  @one_day (60 * 60 * 24)

  def token_config, do: default_claims(default_exp: @one_day)

  def generate_access(account_cpf) do
      extra_clains = %{"account_cpf" => account_cpf}
      generate_and_sign(extra_clains)
  end
end
