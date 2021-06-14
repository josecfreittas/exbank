defmodule ExbankWeb.Router do
  use ExbankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExbankWeb do
    pipe_through :api
  end
end
