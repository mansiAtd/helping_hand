# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :helping_hand,
  ecto_repos: [HelpingHand.Repo]

# Configures the endpoint
config :helping_hand, HelpingHandWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OlF4WHuiTQAKWjLuV0bRZzyu2DGMpAMkxhsM/UozqAELqaAah+meifWquaESjiew",
  render_errors: [view: HelpingHandWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HelpingHand.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []},
    identity: {Ueberauth.Strategy.Identity, [callback_methods: ["POST"]]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  # made up code
  client_id: "472295203794-jqpe8657g9i3f8dof4mnjqn0557vfjr1.apps.googleusercontent.com",
  # m
  client_secret: "Lklx0F4IXLBgIAZjSdydHXhy"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
