defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run "app.start"
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    Postgrex.query!(DB, "DROP TABLE IF EXISTS fruits", [], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [], pool: DBConnection.Poolboy)
  end

  defp create_tables() do
    Postgrex.query!(DB, "Create TABLE fruits (id SERIAL, name VARCHAR(255) NOT NULL, rating INTEGER NOT NULL)", [], pool: DBConnection.Poolboy)
  end

  defp seed_data() do
    Postgrex.query!(DB, "INSERT INTO fruits(name, rating) VALUES($1, $2)", ["Apple", 5], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO fruits(name, rating) VALUES($1, $2)", ["Pear", 4], pool: DBConnection.Poolboy)
    Postgrex.query!(DB, "INSERT INTO fruits(name, rating) VALUES($1, $2)", ["Banana", 7], pool: DBConnection.Poolboy)
  end

end
