defmodule OrcaApiWeb.QueueView do
  use OrcaApiWeb, :view
  alias OrcaApiWeb.QueueView

  def render("index.json", %{queues: queues}) do
    %{data: render_many(queues, QueueView, "queue.json")}
  end

  def render("show.json", %{queue: queue}) do
    %{data: render_one(queue, QueueView, "queue.json")}
  end

  def render("queue.json", %{queue: queue}) do
    %{
      address: queue.address,
      owner: queue.owner,
      collateral_token: queue.collateral_token,
      bid_token: queue.bid_token,
      bid_pools:
        Enum.map(queue.bid_pools, &%{epoch: &1.epoch, premium: &1.premium, total: &1.total}),
      activation_threshold: queue.activation_threshold,
      activation_delay: queue.activation_delay,
      liquidation_fee: queue.liquidation_fee,
      withdrawal_fee: queue.withdrawal_fee
    }
  end
end
