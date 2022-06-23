defmodule GhUserRepoWeb.FallbackController do
  use GhUserRepoWeb, :controller

  alias GhUserRepo.Error
  alias GhUserRepoWeb.ErrorView

  action_fallback FallbackController

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", result: result)
  end
end
