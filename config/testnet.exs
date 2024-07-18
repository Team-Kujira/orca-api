import Config

config :kujira, Kujira.Fin, pair_code_ids: [31, 2229, 3328, 3566]
config :kujira, Kujira.Bow, pool_code_ids: [1925, 2362, 3330], leverage_code_ids: [2666]
config :kujira, Kujira.Ghost, vault_code_ids: [2348], market_code_ids: [2172]
config :kujira, Kujira.Orca, code_ids: [1952, 2923]

config :kujira, Kujira.Usk,
  controller_code_id: 53,
  market_code_ids: [66, 136],
  margin_code_ids: [87]
