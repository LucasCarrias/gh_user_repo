defmodule GhUserRepo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      GhUserRepo.Repo,
      # Start the Telemetry supervisor
      GhUserRepoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GhUserRepo.PubSub},
      # Start the Endpoint (http/https)
      GhUserRepoWeb.Endpoint
      # Start a worker by calling: GhUserRepo.Worker.start_link(arg)
      # {GhUserRepo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GhUserRepo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GhUserRepoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
