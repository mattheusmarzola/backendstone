use Mix.Config

# Configure your database
config :backendstone, Backendstone.Repo,
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  database: System.get_env("DATABASE_DB") <> "_dev",
  hostname: System.get_env("DATABASE_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :backendstone, BackendstoneWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :backendstone, Guardian,
  issuer: "backendstone",
  secret_key: "JFnQRmiGSFG1Ank9//dRYyUn5yfVrTzPlZtt1ogDhZcl03J38NzDfklyMNFAg5mU",
  serializer: Backendstone.GuardianSerializer