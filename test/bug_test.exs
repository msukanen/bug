defmodule BugTest do
  use ExUnit.Case
  doctest Bug

  test "greets the world" do
    assert Bug.hello() == :world
  end
end
