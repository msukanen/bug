defmodule CleanseTest do
  use ExUnit.Case
  doctest Bug.Base64.Cleanse

  test "cleanse" do
    assert Bug.Base64.Cleanse.cleanse("this has spaces=") == "thishasspaces="
  end
end
