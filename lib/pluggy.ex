defmodule Pluggy do
  use Application

  def start(_type, _args) do
    IO.puts("Starting the application...")
    Pluggy.Supervisor.start_link({})
  end
end
