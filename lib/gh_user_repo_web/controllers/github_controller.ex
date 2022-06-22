defmodule GhUserRepoWeb.GitHubController do
  use GhUserRepoWeb, :controller

  def repos(conn, %{"username" => username}) do
    case GhUserRepo.Github.Client.get_user_repos(username) do
      {:ok, body} -> conn |> json(body)
      {:error, body} -> conn |> put_status(400) |> json(body)
    end
  end
end
