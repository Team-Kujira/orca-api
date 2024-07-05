defmodule OrcaApiWeb.PositionsController do
  alias OrcaApi.Positions
  use OrcaApiWeb, :controller

  alias OrcaApi.Node

  action_fallback OrcaApiWeb.FallbackController

  def index(conn, _params) do
    channel = Node.channel()

    with {:ok, data} <- Positions.all(channel) do
      json(conn, positions: data)
    end
  end
end
