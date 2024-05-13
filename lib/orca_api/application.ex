defmodule OrcaApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # No need for a cache repo yet
      # OrcaApi.Repo,
      # Start the Telemetry supervisor
      OrcaApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: OrcaApi.PubSub},
      # Start the Endpoint (http/https)
      OrcaApiWeb.Endpoint,
      # Start a worker by calling: OrcaApi.Worker.start_link(arg)
      # {OrcaApi.Worker, arg}
      OrcaApi.Node
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OrcaApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OrcaApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
