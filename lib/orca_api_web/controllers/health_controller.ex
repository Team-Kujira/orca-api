defmodule OrcaApiWeb.HealthController do
  alias Kujira.Usk
  use OrcaApiWeb, :controller

  alias Kujira.Bow
  alias Kujira.Ghost
  alias OrcaApi.Node

  action_fallback OrcaApiWeb.FallbackController

  def index(conn, _params) do
    with {:ok, usk} <- Usk.list_markets(Node.channel()),
         {:ok, ghost} <- Ghost.list_markets(Node.channel()),
         {:ok, bow} <- Bow.list_leverage(Node.channel()) do
      data =
        %{}
        |> reduce(usk, fn x, agg ->
          Node.channel()
          |> Usk.load_orca_market(x, 3)
          |> insert(agg)
        end)
        |> reduce(ghost, fn x, agg ->
          Node.channel()
          |> Ghost.load_orca_market(x, 3)
          |> insert(agg)
        end)
        |> reduce(bow, fn x, agg ->
          Node.channel()
          |> Bow.load_orca_markets(x, 3)
          |> insert(agg)
        end)

      render(conn, "index.json", markets: data)
    end
  end

  # defp compile(usk, ghost, bow) do
  #   %{}
  #   |> reduce(IO.inspect(usk), &insert/2)
  #   |> IO.inspect()
  #   |> reduce(ghost, &insert/2)
  #   |> reduce(
  #     bow,
  #     fn
  #       {:ok, {a, b}}, agg -> agg |> insert(a) |> insert(b)
  #       _, agg -> agg
  #     end
  #   )
  # end

  defp reduce(init, enum, f) do
    Enum.reduce(enum, init, f)
  end

  defp insert({:ok, {a, b}}, agg) do
    insert(a, insert(b, agg))
  end

  defp insert({:ok, m}, agg) do
    insert(m, agg)
  end

  defp insert(
         %Kujira.Orca.Market{address: {type, address}, queue: {_, queue}, health: health},
         agg
       ) do
    v = %{protocol: type, address: address, health: health}
    Map.update(agg, queue, [v], &[v | &1])
  end

  defp insert({:error, _}, agg) do
    agg
  end
end
