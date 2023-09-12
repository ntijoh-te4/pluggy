defmodule Pluggy.Supervisor do
  use Supervisor
  alias Plug

  def start_link(_init_args) do
    IO.puts("Starting THE supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Pluggy.Router, options: [port: 3000]),
      {Postgrex, Keyword.put(Application.get_env(:pluggy, :db), :name, DB)}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
