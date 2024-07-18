defmodule OrcaApi.Indexer do
  alias OrcaApi.Liquidations
  alias Phoenix.PubSub
  use GenServer
  require Logger

  @impl true
  def init(opts) do
    PubSub.subscribe(OrcaApi.PubSub, "tendermint/event/Tx")

    {:ok, opts}
  end

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  @impl true

  def handle_info(
        %{TxResult: %{height: height, result: %{events: events}, tx: tx} = res},
        state
      ) do
    txhash = tx |> Base.decode64!() |> Kujira.tx_hash()
    index = Map.get(res, :index, 0)
    Liquidations.Indexer.scan_events(height, index, txhash, events)
    {:noreply, state}
  end
end
