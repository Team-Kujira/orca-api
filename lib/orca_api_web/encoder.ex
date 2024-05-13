require Protocol

Protocol.derive(Jason.Encoder, Kujira.Bow.Leverage,
  only: [
    :__struct__,
    :address,
    :owner,
    :token_base,
    :token_quote,
    :oracle_base,
    :oracle_quote,
    :max_ltv,
    :full_liquidation_threshold,
    :partial_liquidation_target,
    :borrow_fee
  ]
)

defimpl Jason.Encoder, for: Tuple do
  alias Kujira.Ghost.Vault

  def encode({Vault, address}, opts) do
    {:ok, vault} = Kujira.Ghost.get_vault(OrcaApi.Node.channel(), address)
    {:ok, vault} = Kujira.Ghost.load_vault(OrcaApi.Node.channel(), vault)
    Jason.Encode.map(vault, opts)
  end

  def encode({k, v}, opts) do
    Jason.Encode.map(%{k => v}, opts)
  end
end

Protocol.derive(Jason.Encoder, Kujira.Ghost.Vault.Status)

Protocol.derive(Jason.Encoder, Kujira.Ghost.Market,
  only: [
    :__struct__,
    :address,
    :owner,
    :vault,
    :collateral_token,
    :collateral_oracle_denom,
    :max_ltv,
    :full_liquidation_threshold,
    :partial_liquidation_target,
    :borrow_fee
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Usk.Market,
  only: [
    :__struct__,
    :address,
    :owner,
    :stable_token,
    :stable_token_admin,
    :collateral_token,
    :collateral_oracle_denom,
    :max_ltv,
    :full_liquidation_threshold,
    :liquidation_ratio,
    :mint_fee,
    :max_debt,
    :interest_rate
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Orca.Queue,
  only: [
    :address,
    :owner,
    :collateral_token,
    :bid_token,
    :bid_pools,
    :activation_threshold,
    :activation_delay,
    :liquidation_fee,
    :withdrawal_fee
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Token, only: [:denom, :meta, :trace])

Protocol.derive(Jason.Encoder, Kujira.Token.Meta,
  only: [:name, :decimals, :symbol, :coingecko_id, :png, :svg]
)

Protocol.derive(Jason.Encoder, Kujira.Token.Trace, only: [:path, :base_denom])

Protocol.derive(Jason.Encoder, Kujira.Token.Meta.Error, only: [:error])
