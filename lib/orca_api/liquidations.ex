defmodule OrcaApi.Liquidations do
  @moduledoc """
  Individual liquidations executed on Kujira ORCA
  """
  alias OrcaApi.Repo
  alias OrcaApi.Liquidations.Liquidation
  import Ecto.Query

  @spec all_liquidations(non_neg_integer(), :asc | :desc) :: [Liquidation.t()]
  def all_liquidations(limit \\ 100, sort \\ :desc) do
    Liquidation
    |> sort(sort)
    |> limit(^limit)
    |> Repo.all()
  end

  @spec list_liquidations(String.t(), non_neg_integer(), :asc | :desc) :: [Liquidation.t()]
  def list_liquidations(contract, limit \\ 100, sort \\ :desc) do
    Liquidation
    |> where(contract: ^contract)
    |> sort(sort)
    |> limit(^limit)
    |> Repo.all()
  end

  def insert_liquidation(params) do
    Liquidation.changeset(%Liquidation{}, params)
    |> Repo.insert()
  end

  def sort(query, dir) do
    order_by(query, [x], [
      {^dir, x.height},
      {^dir, x.tx_idx},
      {^dir, x.idx}
    ])
  end
end
