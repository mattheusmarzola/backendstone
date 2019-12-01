use Mix.Config

# Configure your database
config :backendston, Backendston.Repo,
  username: "postgres",
  password: "postgres",
  database: "backendston_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :backendston, BackendstonWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
