defmodule CleanseTest do
  use ExUnit.Case
  doctest Cleanse

  test "cleanse" do
    assert Cleanse.cleanse("this has spaces=") == "thishasspaces="
  end
end
