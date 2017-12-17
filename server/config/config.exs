# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :server,
  ecto_repos: [Server.Repo]

# Configures the endpoint
config :server, ServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AUOhJOplfR8ddGASyK7bXYGjl+HA0zblI9CrP4schvNO9Z0hHUK8Lres/qQzdpvJ",
  render_errors: [view: ServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Server.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :server, ServerWeb.Guardian,
       issuer: "server",
       ttl: { 30, :days},
       verify_issuer: true,
       secret_key: "cL/YYw8L4lrqWVp2DHFmV7rBnDqjjg0Or2iyhmEhvF7j4o2ZWsTMzCps31Izi+zj",
       serializer: Server.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
