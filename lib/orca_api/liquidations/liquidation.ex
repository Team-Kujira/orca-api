defmodule OrcaApi.Liquidations.Liquidation do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  A normalized Liquidation event. Primary key is on the (height, tx_idx, idx) tuple
  """

  @primary_key false
  schema "liquidations" do
    field :height, :integer, primary_key: true
    field :tx_idx, :integer, primary_key: true
    field :idx, :integer, primary_key: true

    field :contract, :string
    field :txhash, :string
    field :market, :string
    field :repay_amount, :decimal
    field :collateral_amount, :decimal
    field :fee_amount, :decimal
    field :timestamp, :naive_datetime_usec
    timestamps(type: :utc_datetime_usec)
  end

  def changeset(trade, params) do
    trade
    |> cast(params, [
      :height,
      :tx_idx,
      :idx,
      :contract,
      :txhash,
      :market,
      :repay_amount,
      :collateral_amount,
      :fee_amount,
      :timestamp
    ])
    |> validate_required([
      :height,
      :tx_idx,
      :idx,
      :contract,
      :txhash,
      :market,
      :repay_amount,
      :collateral_amount,
      :fee_amount,
      :timestamp
    ])
    |> unique_constraint([:height, :tx_idx, :idx], name: "liquidations_pkey")
  end
end
