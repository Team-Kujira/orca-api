defmodule OrcaApiWeb.PositionsView do
  use OrcaApiWeb, :view

  def render("index.json", %{positions: positions}) do
    %{data: render_many(positions, __MODULE__, "position.json")}
  end

  def render("position.json", x) do
    x
  end
end
