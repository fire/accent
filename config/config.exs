use Mix.Config

defmodule Utilities do
  def string_to_boolean("true"), do: true
  def string_to_boolean("1"), do: true
  def string_to_boolean(_), do: false
end

# Used to extract schema json with the absinthe’s mix task
config :absinthe, :schema, Accent.GraphQL.Schema

# Configures the endpoint
config :accent, Accent.Endpoint,
  root: Path.expand("..", __DIR__),
  http: [port: "${PORT}"],
  url: [host: "${CANONICAL_HOST}"],
  secret_key_base: "${SECRET_KEY_BASE}",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Accent.PubSub, adapter: Phoenix.PubSub.PG2]

# Configure your database
config :accent, :ecto_repos, [Accent.Repo]

config :accent, Accent.Repo,
  adapter: Ecto.Adapters.Postgres,
  timeout: 30000,
  url: "${DATABASE_URL}"

config :accent,
  force_ssl: Utilities.string_to_boolean("${FORCE_SSL}"),
  hook_broadcaster: Accent.Hook.Broadcaster,
  dummy_provider_enabled: true,
  restricted_domain: "${RESTRICTED_DOMAIN}"

# Configures canary custom handlers and repo
config :canary,
  repo: Accent.Repo,
  unauthorized_handler: {Accent.ErrorController, :handle_unauthorized},
  not_found_handler: {Accent.ErrorController, :handle_not_found}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Phoenix
config :phoenix, Accent.Router, host: "${CANONICAL_HOST}"

config :phoenix, :generators,
  migration: true,
  binary_id: false

# Configures sentry to report errors
config :sentry,
  dsn: "${SENTRY_DSN}",
  included_environments: [:prod],
  environment_name: Mix.env(),
  root_source_code_path: File.cwd!()

# Configure mailer
import_config "mailer.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
