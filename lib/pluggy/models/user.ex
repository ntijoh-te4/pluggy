defmodule Pluggy.User do
  defstruct(id: nil, username: "")

  alias Pluggy.User

  def get(id) do
    Postgrex.query!(DB, "SELECT id, username FROM users WHERE id = $1 LIMIT 1", [id]).rows
    |> to_struct
  end

  def to_struct([[id, username]]) do
    %User{id: id, username: username}
  end

  # no user with that id (e.g. session cookie left over after "mix seed")
  def to_struct([]), do: nil
end
