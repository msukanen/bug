defmodule BugTest do
  use ExUnit.Case
  doctest Bug

  test "greets the world" do
    assert Bug.hello() == :world
  end

  test "hillibillies" do
    assert Bug.encode("This is a brown fox. What does the fox say? Bip-blibi-bibi-blibibi-bli!") == "VGhpcyBpcyBhIGJyb3duIGZveC4gV2hhdCBkb2VzIHRoZSBmb3ggc2F5PyBCaXAtYmxpYmktYmliaS1ibGliaWJpLWJsaSE="
  end
end
