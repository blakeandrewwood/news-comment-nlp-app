defmodule Server.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Server.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ServerWeb.Endpoint, []),
      # Setup discussion nlp
      supervisor(Task.Supervisor, [[name: Server.DiscussionNLP.init, restart: :temporary]]),
      # Run update to process any existing content
      worker(Task, [&Server.DiscussionNLP.update/0], restart: :temporary),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Server.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
