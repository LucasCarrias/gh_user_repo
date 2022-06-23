defmodule GhUserRepo.User.Create do
  alias GhUserRepo.{Repo, User}

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end
end
