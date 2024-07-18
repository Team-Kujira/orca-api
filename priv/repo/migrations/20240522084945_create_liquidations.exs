defmodule OrcaApi.Repo.Migrations.CreateLiquidations do
  use Ecto.Migration

  def change do
    create table(:liquidations, primary_key: false) do
      add(:height, :integer, primary_key: true)
      add(:tx_idx, :integer, primary_key: true)
      add(:idx, :integer, primary_key: true)

      add(:contract, :text, null: false)
      add(:txhash, :string, null: false)
      add(:market, :string, null: false)
      add(:repay_amount, :numeric, null: false)
      add(:collateral_amount, :numeric, null: false)
      add(:fee_amount, :numeric, null: false)
      add(:timestamp, :naive_datetime_usec, null: false)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:liquidations, [:market])
    create index(:liquidations, [:contract])
    create index(:liquidations, [:timestamp])
    create index(:liquidations, [:txhash])
  end
end
