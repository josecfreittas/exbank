defmodule ExbankWeb.Router do
  use ExbankWeb, :router
  import ExbankWeb.Plugs.Guards

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExbankWeb do
    pipe_through :api

    post "/accounts", AccountController, :create
    post "/accounts/login", AccountController, :login

    pipe_through [:auth]

    get "/transactions", TransactionController, :index
    post "/transactions", TransactionController, :create
    get "/transactions/:id", TransactionController, :show
  end
end
