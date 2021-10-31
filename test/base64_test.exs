defmodule BugBase64Test do
  use ExUnit.Case
  doctest Bug.Base64

  test "encode" do
    assert Bug.Base64.encode("This is a brown fox. What does the fox say? Bip-blibi-bibi-blibibi-bli!") == "VGhpcyBpcyBhIGJyb3duIGZveC4gV2hhdCBkb2VzIHRoZSBmb3ggc2F5PyBCaXAtYmxpYmktYmliaS1ibGliaWJpLWJsaSE="
    assert Bug.Base64.encode("This is a string") == "VGhpcyBpcyBhIHN0cmluZw=="
  end

  test "decode" do
    assert Bug.Base64.decode!("VGhpcyBpcyBhIGJyb3duIGZveC4gV2hhdCBkb2VzIHRoZSBmb3ggc2F5PyBCaXAtYmxpYmktYmliaS1ibGliaWJpLWJsaSE=") == "This is a brown fox. What does the fox say? Bip-blibi-bibi-blibibi-bli!"
    assert Bug.Base64.decode!("VGhpcyBpcyBhIHN0cmluZw==") == "This is a string"
  end

  test "decode with dirty data" do
    assert Bug.Base64.decode!("VGhpcyBpcyBhIGJyb3duIGZ\nveC4gV2hhdCBkb2VzIHRoZSBmb3\nggc2F5PyBCaXAtYmxpYmktYmliaS1ibGliaWJpLWJsaSE=") == "This is a brown fox. What does the fox say? Bip-blibi-bibi-blibibi-bli!"
    assert Bug.Base64.decode!("VGhpcyBpcy\n\tBhIHN0cmluZw==") == "This is a string"
  end
end
