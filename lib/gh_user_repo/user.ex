defmodule GhUserRepo.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  @required_fields ~w{password}a

  @derive {Jason.Encoder, only: @required_fields ++ [:id]}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
