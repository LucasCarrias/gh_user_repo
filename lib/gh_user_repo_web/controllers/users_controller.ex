defmodule GhUserRepoWeb.UsersController do
  use GhUserRepoWeb, :controller

  alias GhUserRepoWeb.Auth.Guardian

  def login(conn, %{"id" => _id, "password" => _password} = params) do
    case GhUserRepoWeb.Auth.Guardian.authenticate(params) do
      {:ok, token} -> conn |> render("login.json", token: token)
    end
  end
end
