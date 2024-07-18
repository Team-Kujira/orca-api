defmodule OrcaApi.Liquidations.Indexer do
  alias OrcaApi.Liquidations

  def scan_events(height, tx_idx, txhash, events) do
    liquidations = scan_events(events)

    for {liquidation, idx} <- Enum.with_index(liquidations) do
      liquidation
      |> Map.merge(%{
        height: height,
        tx_idx: tx_idx,
        idx: idx,
        txhash: txhash,
        timestamp: DateTime.now!("Etc/UTC")
      })
      |> Liquidations.insert_liquidation()
    end
  end

  defp scan_events(attributes, collection \\ [])

  defp scan_events(
         [
           %{
             type: "transfer",
             attributes: [
               %{key: "amount"},
               %{key: "recipient"},
               %{key: "sender", value: market} | _
             ]
           },
           _,
           %{
             type: "wasm",
             attributes: [
               %{key: "_contract_address", value: queue},
               %{key: "action", value: "execute_bid"},
               %{key: "bid_amount"},
               %{key: "collateral_amount", value: collateral_amount},
               %{key: "liquidation_fee", value: liquidation_fee},
               %{key: "repay_amount", value: repay_amount}
             ]
           }
           | rest
         ],
         collection
       ) do
    with {collateral_amount, ""} <- Integer.parse(collateral_amount),
         {liquidation_fee, ""} <- Integer.parse(liquidation_fee),
         {repay_amount, ""} <- Integer.parse(repay_amount) do
      scan_events(rest, [
        %{
          contract: queue,
          market: market,
          repay_amount: repay_amount,
          collateral_amount: collateral_amount,
          fee_amount: liquidation_fee
        }
        | collection
      ])
    else
      _ -> scan_events(rest, collection)
    end
  end

  defp scan_events([_ | rest], collection), do: scan_events(rest, collection)
  defp scan_events([], collection), do: collection
end
