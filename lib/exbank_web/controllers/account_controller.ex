defmodule ExbankWeb.AccountController do
  use ExbankWeb, :controller

  alias Exbank.Accounts
  alias Exbank.Accounts.Account
  alias ExbankWeb.Auth

  action_fallback ExbankWeb.FallbackController

  def create(conn, account_params) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params) do
      conn
      |> put_status(:created)
      |> render("show.json", account: account)
    else
      {:error, changeset} ->
        conn
        |> put_view(ExbankWeb.ErrorView)
        |> put_status(400)
        |> render("error.json", changeset: changeset)
    end
  end

  def login(conn, params) do
    with %Account{:password => password_hash} <- Accounts.get_account(:cpf, params["cpf"]) do
      case Bcrypt.verify_pass(params["password"], password_hash) do
        true ->
          {:ok, access, _clains} = Auth.generate_access(params["cpf"])
          render(conn, "auth.json", access: access)

        _ ->
          login_error(conn)
      end
    else
      _ ->
        login_error(conn)
    end
  end

  defp login_error(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{error: "Failed to log in."}))
  end
end
