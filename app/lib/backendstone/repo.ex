defmodule Backendstone.Repo do
  use Ecto.Repo,
    otp_app: :backendstone,
    adapter: Ecto.Adapters.Postgres
end
