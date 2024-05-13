defmodule KujiraOrca.Node do
  use Kujira.Node,
    otp_app: :kujira_orca,
    pubsub: KujiraOrca.PubSub,
    subscriptions: []
end
