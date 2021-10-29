defmodule BugTest do
  use ExUnit.Case
  doctest Bug

  test "encode" do
    assert Bug.encode("This is a brown fox. What does the fox say? Bip-blibi-bibi-blibibi-bli!") == "VGhpcyBpcyBhIGJyb3duIGZveC4gV2hhdCBkb2VzIHRoZSBmb3ggc2F5PyBCaXAtYmxpYmktYmliaS1ibGliaWJpLWJsaSE="
    assert Bug.encode("This is a string") == "VGhpcyBpcyBhIHN0cmluZw=="
  end

  test "decode" do
    assert Bug.decode("VGhpcyBpcyBhIGJyb3duIGZveC4gV2hhdCBkb2VzIHRoZSBmb3ggc2F5PyBCaXAtYmxpYmktYmliaS1ibGliaWJpLWJsaSE=") == "This is a brown fox. What does the fox say? Bip-blibi-bibi-blibibi-bli!"
    assert Bug.decode("VGhpcyBpcyBhIHN0cmluZw==") == "This is a string"
  end
end
