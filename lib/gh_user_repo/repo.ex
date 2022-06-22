defmodule GhUserRepo.Repo do
  use Ecto.Repo,
    otp_app: :gh_user_repo,
    adapter: Ecto.Adapters.Postgres
end
