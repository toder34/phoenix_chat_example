defmodule Chat do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Chat.Endpoint, []),
      # Start the Ecto repository
      worker(Chat.Repo, []),
      # Start the Telly supervisor
      supervisor(Telly.Supervisor, [Chat.Endpoint, [name: Telly]]),

    ]

    opts = [strategy: :one_for_one, name: Chat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Chat.Endpoint.config_change(changed, removed)
    :ok
  end
end
