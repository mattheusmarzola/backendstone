# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :backendstone,
  ecto_repos: [Backendstone.Repo]

# Configures the endpoint
config :backendstone, BackendstoneWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "31bOojPtNviWZbjelh8uJBetSW/zN9ZH4gHTF2eKeHEdIOE81Q1A4ifCj7Fy0irc",
  render_errors: [view: BackendstoneWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Backendstone.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Guardian config
config :backendstone, Backendstone.UserManager.Guardian,
       issuer: "backendstone",
       secret_key: "qPLj1A3qCXqHNYG264W4KXyyjfuCCCgM5bfQ2NgdbHbZd7dmzuEwbmFF/ggzcDFx"

# Bamboo config
config :backendstone, Backendstone.Email.Mailer,
  adapter: Bamboo.TestAdapter
