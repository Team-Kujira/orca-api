defmodule KujiraOrca.Repo do
  use Ecto.Repo,
    otp_app: :kujira_orca,
    adapter: Ecto.Adapters.SQLite3
end
