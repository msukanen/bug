defmodule Bug do
  @moduledoc """
  Documentation for `Bug`.
  """
  use Bitwise

  @doc """
  Hello world.

  ## Examples

      iex> Bug.hello()
      :world

  """
  def hello do
    :world
  end

  defp base64_set do 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' end

  defp split(num, i) when num > 0 do
    case num do
      3 -> for <<x::binary-3 <- i>>, do: x
      _ -> for <<x::binary-4 <- i>>, do: x
    end
  end

  def encode(s) when is_atom(s) do encode Atom.to_string(s) end
  def encode(s) do
    [pad, s] = case (rem(byte_size(s), 3)) do
        1-> ["==", s <> <<0,0>>]
        2-> ["=", s <> <<0>>]
        _-> ["", s]
    end
    String.slice((split(3, s) |> Enum.map(fn <<a,b,c>> ->
      n = ((0xff &&& a)<<<16) + ((0xff &&& b) <<<8) + (0xff &&& c)
      <<Enum.at(base64_set(), (0x3f &&& (n >>> 18))),
        Enum.at(base64_set(), (0x3f &&& (n >>> 12))),
        Enum.at(base64_set(), (0x3f &&& (n >>>  6))),
        Enum.at(base64_set(), (0x3f &&&  n))>>
    end) |> Enum.join ), 0..-(String.length(pad)+1)) <> pad
  end
end
