defmodule GhUserRepo.Github.ClientTest do
  use ExUnit.Case, async: true

  alias Plug.Conn
  alias GhUserRepo.Github.Client

  describe "get_user_repos/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when a valid user is given, gets user repos", %{bypass: bypass} do
      username = "LucasCarrias"

      body = ~s([{
        "description": "Test Repo",
        "html_url": "https://github.com/LucasCarrias/test",
        "id": 12345,
        "name": "test",
        "stargazers_count": 0
      }])

      Bypass.expect_once(bypass, "GET", "/#{username}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_user_repos(endpoint_url(bypass.port), username)

      expected_response =
        {:ok,
         [
           %{
             "description" => "Test Repo",
             "html_url" => "https://github.com/LucasCarrias/test",
             "id" => 12345,
             "name" => "test",
             "stargazers_count" => 0
           }
         ]}

      assert response == expected_response
    end

    test "when user is not found, returns error", %{bypass: bypass} do
      username = "LucasCarrias"

      body = ~s({
        "message": "Not Found"
      })

      Bypass.expect_once(bypass, "GET", "/#{username}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(404, body)
      end)

      response = Client.get_user_repos(endpoint_url(bypass.port), username)

      expected_response = {:error, %{"message" => "Not Found"}}

      assert response == expected_response
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/"
end
