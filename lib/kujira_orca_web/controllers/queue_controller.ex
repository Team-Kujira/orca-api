defmodule KujiraOrcaWeb.QueueController do
  use Memoize
  use KujiraOrcaWeb, :controller

  alias Kujira.Orca
  alias KujiraOrca.Node

  action_fallback KujiraOrcaWeb.FallbackController

  def index(conn, _params) do
    with {:ok, queues} <- list_queues() do
      render(conn, "index.json", queues: queues)
    end
  end

  def show(conn, %{"id" => address}) do
    with {:ok, queue} <- Orca.get_queue(Node.channel(), address),
         {:ok, queue} <- Orca.load_queue(Node.channel(), queue) do
      render(conn, "show.json", queue: queue)
    end
  end

  defmemop(list_queues(), do: Orca.list_queues(Node.channel()))
end
