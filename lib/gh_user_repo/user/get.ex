defmodule GhUserRepo.User.Get do
  alias GhUserRepo.{Repo, Error, User}

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.build(:not_found, "User not found")}
      user -> {:ok, user}
    end
  end
end
