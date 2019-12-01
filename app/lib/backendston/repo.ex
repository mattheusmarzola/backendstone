defmodule Backendston.Repo do
  use Ecto.Repo,
    otp_app: :backendston,
    adapter: Ecto.Adapters.Postgres
end
