defmodule SafeFinance.Repo do
  use Ecto.Repo,
    otp_app: :safe_finance,
    adapter: Ecto.Adapters.Postgres
end
