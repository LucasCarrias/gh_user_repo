defmodule GhUserRepo.Github.Behaviour do

  @typep body :: list(map())

  @callback get_user_repos(String.t()) :: {:ok, body} | {:error, body}
end
