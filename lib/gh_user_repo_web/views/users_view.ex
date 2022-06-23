defmodule GhUserRepoWeb.UsersView do
  use GhUserRepoWeb, :view

  def render("login.json", %{token: token}), do: %{token: token}
end
