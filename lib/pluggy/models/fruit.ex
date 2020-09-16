defmodule Pluggy.Fruit do
  defstruct(id: nil, name: "", tastiness: "")

  alias Pluggy.Fruit

  def all do
    Postgrex.query!(DB, "SELECT * FROM fruits", [], pool: DBConnection.ConnectionPool).rows
    |> to_struct_list
  end

  def get(id) do
    Postgrex.query!(DB, "SELECT * FROM fruits WHERE id = $1 LIMIT 1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    ).rows
    |> to_struct
  end

  def update(id, params) do
    name = params["name"]
    tastiness = String.to_integer(params["tastiness"])
    id = String.to_integer(id)

    Postgrex.query!(
      DB,
      "UPDATE fruits SET name = $1, tastiness = $2 WHERE id = $3",
      [name, tastiness, id],
      pool: DBConnection.ConnectionPool
    )
  end

  def create(params) do
    name = params["name"]
    tastiness = String.to_integer(params["tastiness"])

    Postgrex.query!(DB, "INSERT INTO fruits (name, tastiness) VALUES ($1, $2)", [name, tastiness],
      pool: DBConnection.ConnectionPool
    )
  end

  def delete(id) do
    Postgrex.query!(DB, "DELETE FROM fruits WHERE id = $1", [String.to_integer(id)],
      pool: DBConnection.ConnectionPool
    )
  end

  def to_struct([[id, name, tastiness]]) do
    %Fruit{id: id, name: name, tastiness: tastiness}
  end

  def to_struct_list(rows) do
    for [id, name, tastiness] <- rows, do: %Fruit{id: id, name: name, tastiness: tastiness}
  end
end
