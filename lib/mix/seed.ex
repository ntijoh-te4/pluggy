defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Resets & seeds the DB."
  def run(_) do
    Mix.Task.run("app.start")
    drop_tables()
    create_tables()
    seed_data()
  end

  defp drop_tables() do
    IO.puts("Dropping tables")
    Postgrex.query!(DB, "DROP TABLE IF EXISTS fruits", [])
    Postgrex.query!(DB, "DROP TABLE IF EXISTS users", [])
  end

  defp create_tables() do
    IO.puts("Creating tables")

    Postgrex.query!(
      DB,
      "CREATE TABLE fruits (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL, tastiness INTEGER NOT NULL)",
      []
    )

    Postgrex.query!(
      DB,
      "CREATE TABLE users (id SERIAL PRIMARY KEY, username VARCHAR(255) NOT NULL UNIQUE, password_hash VARCHAR(60) NOT NULL)",
      []
    )
  end

  defp seed_data() do
    IO.puts("Seeding data")

    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Apple", 5])
    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Pear", 4])
    Postgrex.query!(DB, "INSERT INTO fruits(name, tastiness) VALUES($1, $2)", ["Banana", 7])

    Postgrex.query!(
      DB,
      "INSERT INTO users(username, password_hash) VALUES($1, $2)",
      ["a", Bcrypt.hash_pwd_salt("a")]
    )
  end
end
