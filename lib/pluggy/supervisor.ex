defmodule Pluggy.Supervisor do
  use Supervisor

  def start_link(_init_args) do
    IO.puts("Starting THE supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    # order matters: the database connection must exist before the web server accepts requests
    children = [
      {Postgrex, Keyword.put(Application.get_env(:pluggy, :db), :name, DB)},
      {Bandit, plug: Pluggy.Router, scheme: :http, port: 3000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
