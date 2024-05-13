defmodule OrcaApi.Repo do
  use Ecto.Repo,
    otp_app: :orca_api,
    adapter: Ecto.Adapters.SQLite3
end
