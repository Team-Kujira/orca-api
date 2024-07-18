defmodule OrcaApi.Positions do
  alias Kujira.Bow
  alias Kujira.Ghost
  alias Kujira.Usk

  def all(channel) do
    with {:ok, usk} <- Usk.list_markets(channel),
         data =
           Enum.reduce(usk, %{}, fn market, agg ->
             Usk.list_positions(channel, market)
             |> Enum.reduce(agg, &insert_usk(&1, &2, market))
           end),
         {:ok, margin} <- Usk.list_margins(channel),
         data =
           Enum.reduce(margin, data, fn %{market: market}, agg ->
             Usk.list_positions(channel, market)
             |> Enum.reduce(agg, &insert_usk(&1, &2, market))
           end),
         {:ok, ghost} <- Ghost.list_markets(channel),
         data =
           Enum.reduce(ghost, data, fn market, agg ->
             {:ok, vault} = Kujira.Contract.get(channel, market.vault)
             {:ok, vault} = Ghost.load_vault(channel, vault)

             Ghost.list_positions(channel, market, vault)
             |> Enum.reduce(agg, &insert_ghost(&1, &2, market, vault))
           end),
         {:ok, bow} <- Bow.list_leverage(channel),
         data =
           Enum.reduce(bow, data, fn market, agg ->
             Bow.list_all_positions(channel, market)
             |> Enum.reduce(agg, &insert_bow(&1, &2, market))
           end) do
      {:ok, data}
    end
  end

  defp insert_usk(p, agg, market) do
    price = Usk.Position.liquidation_price(p, market)
    key = market.collateral_oracle_denom

    case Decimal.compare(price, Decimal.from_float(0.0)) do
      :eq ->
        agg

      _ ->
        Map.update(
          agg,
          key,
          [%{position: p, liquidation_price: price}],
          &[%{position: p, liquidation_price: price} | &1]
        )
    end
  end

  defp insert_ghost(p, agg, market, vault) do
    price = Ghost.Position.liquidation_price(p, market, vault)

    key =
      case vault.oracle_denom do
        {:live, live} -> "#{market.collateral_oracle_denom}_#{live}"
        {:static, _} -> market.collateral_oracle_denom
      end

    case Decimal.compare(price, Decimal.from_float(0.0)) do
      :eq ->
        agg

      _ ->
        Map.update(
          agg,
          key,
          [%{position: p, liquidation_price: price}],
          &[%{position: p, liquidation_price: price} | &1]
        )
    end
  end

  defp insert_bow(p, agg, leverage) do
    price = Bow.Leverage.Position.liquidation_price(leverage, p)

    key = "#{leverage.oracle_base}_#{leverage.oracle_quote}"

    case Decimal.compare(price, Decimal.from_float(0.0)) do
      :eq ->
        agg

      _ ->
        Map.update(
          agg,
          key,
          [%{position: p, liquidation_price: price}],
          &[%{position: p, liquidation_price: price} | &1]
        )
    end
  end
end
