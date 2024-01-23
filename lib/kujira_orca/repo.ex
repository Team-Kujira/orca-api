defmodule KujiraOrca.Repo do
  use Ecto.Repo,
    otp_app: :kujira_orca,
    adapter: Ecto.Adapters.Postgres
end
