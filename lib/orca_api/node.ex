defmodule OrcaApi.Node do
  use Kujira.Node,
    otp_app: :orca_api,
    pubsub: OrcaApi.PubSub,
    subscriptions: ["wasm._contract_address EXISTS"]
end
