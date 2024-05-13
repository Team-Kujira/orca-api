defmodule OrcaApiWeb.BidView do
  use OrcaApiWeb, :view
  alias OrcaApiWeb.BidView

  def render("index.json", %{bids: bids}) do
    %{data: render_many(bids, BidView, "bid.json")}
  end

  def render("show.json", %{bid: bid}) do
    %{data: render_one(bid, BidView, "bid.json")}
  end

  def render("bid.json", %{bid: %Kujira.Orca.Bid{} = bid}) do
    %{
      id: bid.id,
      bidder: bid.bidder,
      bid_amount: bid.bid_amount,
      filled_amount: bid.filled_amount,
      premium: bid.premium,
      activation_time: bid.activation_time
    }
  end
end
