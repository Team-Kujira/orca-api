defmodule OrcaApiWeb.QueueController do
  use OrcaApiWeb, :controller

  alias Kujira.Orca
  alias OrcaApi.Node

  action_fallback OrcaApiWeb.FallbackController

  def index(conn, _params) do
    with {:ok, queues} <- Orca.list_queues(Node.channel()) do
      render(conn, "index.json", queues: queues)
    end
  end

  def show(conn, %{"id" => address}) do
    with {:ok, queue} <- Orca.get_queue(Node.channel(), address),
         {:ok, queue} <- Orca.load_queue(Node.channel(), queue) do
      render(conn, "show.json", queue: queue)
    end
  end
end
