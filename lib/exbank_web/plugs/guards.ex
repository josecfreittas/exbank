defmodule ExbankWeb.Plugs.Guards do
  import Plug.Conn
  import Phoenix.Controller, only: [put_view: 2, render: 3]

  def auth(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case ExbankWeb.Auth.verify(token) do
          {:ok, %{"account_cpf" => account_cpf}} ->
            conn
            |> assign(:account_cpf, account_cpf)

          {:error, _} ->
            conn
            |> put_view(ExbankWeb.ErrorView)
            |> put_status(403)
            |> render("error.json", message: "Forbidden")
            |> halt()
        end

      _ ->
        conn
        |> put_view(ExbankWeb.ErrorView)
        |> put_status(401)
        |> render("error.json", message: "Unauthorized")
        |> halt()
    end
  end
end
