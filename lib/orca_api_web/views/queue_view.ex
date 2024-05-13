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
      collateral_token: %{
        denom: queue.collateral_token.denom,
        decimals: queue.collateral_token.decimals
      },
      bid_token: %{denom: queue.bid_token.denom, decimals: queue.bid_token.decimals},
      bid_pools:
        Enum.map(queue.bid_pools, &%{epoch: &1.epoch, premium: &1.premium, total: &1.total}),
      activation_threshold: queue.activation_threshold,
      activation_delay: queue.activation_delay,
      liquidation_fee: queue.liquidation_fee,
      withdrawal_fee: queue.withdrawal_fee
    }
  end
end
