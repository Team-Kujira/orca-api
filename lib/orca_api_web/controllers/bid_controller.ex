defmodule OrcaApiWeb.BidController do
  use OrcaApiWeb, :controller

  alias Kujira.Orca
  alias OrcaApi.Node

  action_fallback OrcaApiWeb.FallbackController

  def index(conn, %{"queue_id" => queue_id, "bidder" => bidder}) do
    with {:ok, queue} <- Orca.get_queue(Node.channel(), queue_id),
         {:ok, bids} <- Orca.load_bids(Node.channel(), queue, bidder) do
      render(conn, "index.json", bids: bids)
    end
  end

  def show(conn, %{"queue_id" => queue_id, "id" => idx}) do
    with {:ok, queue} <- Orca.get_queue(Node.channel(), queue_id),
         {:ok, bid} <- Orca.load_bid(Node.channel(), queue, idx) do
      render(conn, "show.json", bid: bid)
    end
  end
end
