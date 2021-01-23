# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :safe_finance,
  ecto_repos: [SafeFinance.Repo]

# Configures the endpoint
config :safe_finance, SafeFinanceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rdslUvW3Z50YB3qZreEcrI5BWptSjhPoDi97+/wgNpa65BZdCWsGWp7lnNVfBe6S",
  render_errors: [view: SafeFinanceWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: SafeFinance.PubSub,
  live_view: [signing_salt: "2e785utH"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
