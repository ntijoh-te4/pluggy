defmodule PluggyTest do
  use ExUnit.Case
  doctest Pluggy

  test "greets the world" do
    assert Pluggy.hello() == :world
  end
end
