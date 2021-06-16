defmodule ExbankWeb.Plugs.Guards do
  alias Plug.Conn

  def auth(conn, _opts) do
    case Conn.get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case ExbankWeb.Auth.verify(token) do
          {:ok, %{"account_cpf" => account_cpf}} -> Conn.assign(conn, :account_cpf, account_cpf)
          {:error, _} -> Conn.send_resp(conn, 403, "Forbidden")
        end

      _ ->
        Conn.send_resp(conn, 401, "Unauthorized")
    end
  end
end
