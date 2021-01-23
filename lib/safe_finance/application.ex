defmodule SafeFinance.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SafeFinance.Repo,
      # Start the Telemetry supervisor
      SafeFinanceWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SafeFinance.PubSub},
      # Start the Endpoint (http/https)
      SafeFinanceWeb.Endpoint
      # Start a worker by calling: SafeFinance.Worker.start_link(arg)
      # {SafeFinance.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SafeFinance.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SafeFinanceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
