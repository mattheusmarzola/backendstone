use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :backendstone, BackendstoneWeb.Endpoint,
  load_from_system_env: true,
  http: [port: {:system, "PORT"}], # Needed for Phoenix 1.2 and 1.4. Doesn't hurt for 1.3.
  server: true, # Without this line, your app will not start the web server!
  secret_key_base: "${SECRET_KEY_BASE}",
  url: [host: "${APP_NAME}.gigalixirapp.com", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  debug_errors: true


config :backendstone, Backendstone.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: "${DATABASE_URL}",
  database: "",
  ssl: true,
  pool_size: 2 # Free tier db only allows 4 connections. Rolling deploys need pool_size*(n+1) connections where n is the number of app replicas.


# Do not print debug messages in production
config :logger, level: :info
