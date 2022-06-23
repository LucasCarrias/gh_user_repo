defmodule GhUserRepoWeb.Auth.Guardian do
  use Guardian, otp_app: :gh_user_repo

  alias GhUserRepo.{Error, User}
  alias GhUserRepo.User.Get, as: UserGet

  def subject_for_token(%{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(%{"sub" => _id} = claims) do
    claims
    |> Map.get("sub")
    |> UserGet.by_id()
  end

  def authenticate(%{"id" => user_id, "password" => password}) do
    IO.inspect("AAAAA", label: "HERE")
    with {:ok, %User{password_hash: hash} = user} <- UserGet.by_id(user_id),
         true <- Pbkdf2.verify_pass(password, hash),
         {:ok, token, _claims} <- encode_and_sign(user) do
      {:ok, token}
    else
      false -> {:error, Error.build(:unauthorized, "Invalid credentials")}
      error -> error
    end
  end

  def authenticate(_), do: {:error, Error.build(:bad_request, "Invalid or missing params")}
end
