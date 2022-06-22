defmodule GhUserRepo.Github.Client do
  use Tesla

  @behaviour GhUserRepo.Github.Behaviour

  @base_url "https://api.github.com/users/"
  @parser_keys ~w{id name description html_url stargazers_count}

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [{"user-agent", "Tesla"}]

  def get_user_repos(url \\ @base_url, username) do
    "#{url}#{username}/repos"
    |> get()
    |> handle_response()
  end

  defp handle_response({:ok, %{body: body, status: 200}}) do
    repos = Enum.map(body, &(Map.take(&1, @parser_keys)))

    {:ok, repos}
  end

  defp handle_response({:ok, %{body: body, status: _}}) do
    {:error, body}
  end

  defp handle_response({:error, _response} = result), do: result
end
