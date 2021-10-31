defmodule Cleanse do
  @moduledoc """
  Documentation for `Cleanse`.
  """
  @cps Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z) ++ Enum.to_list(?0..?9) ++ [?=,?+,?/]

  @doc """
  Clean non-Base64 junk from string.

  ## Example
      iex> Cleanse.cleanse("this contains spaces and !!! ??? <><> junk")
      "thiscontainsspacesandjunk"

  """
  def cleanse(<<>>), do: <<>>
  def cleanse(<<c::utf8, r::binary>>) when c in @cps, do: <<c::utf8>> <> cleanse(r)
  def cleanse(<<_c::utf8, r::binary>>), do: cleanse r
end
