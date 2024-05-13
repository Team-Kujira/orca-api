defmodule OrcaApiWeb.HealthView do
  use OrcaApiWeb, :view
  alias OrcaApiWeb.HealthView

  def render("index.json", %{markets: markets}) do
    %{data: render_many(markets, HealthView, "queue.json")}
  end

  def render("show.json", %{queue: queue}) do
    %{data: render_one(queue, HealthView, "queue.json")}
  end

  def render("queue.json", %{health: {contract, list}}) do
    %{
      queue: contract,
      markets: list
    }
  end
end
