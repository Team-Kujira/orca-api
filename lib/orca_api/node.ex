defmodule OrcaApi.Node do
  use Kujira.Node,
    otp_app: :orca_api,
    pubsub: OrcaApi.PubSub,
    subscriptions: ["message.action='/cosmwasm.wasm.v1.MsgExecuteContract'"]
end
