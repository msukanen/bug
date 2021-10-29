defmodule Bug do
  @moduledoc """
  Documentation for `Bug`.
  """
  use Bitwise

  defp base64_set do 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/' end
  defp base64_str do "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" end

  defp split(num, i) when num > 0 do
    case num do
      3 -> for <<x::binary-3 <- i>>, do: x
      _ -> for <<x::binary-4 <- i>>, do: x
    end
  end

  @doc """
  Base64-encode a string or atom.

  ## Examples

      iex> Bug.encode("This is a string")
      "VGhpcyBpcyBhIHN0cmluZw=="

  """
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

  @doc """
  Decode base64 encoded chunk.

  ## Examples

      iex> Bug.decode("VGhpcyBpcyBhIHN0cmluZw==")
      "This is a string"

  """
  def decode(s) do
    if (rem( String.length(s), 4) !== 0) do raise {:error, "Data { s } does not comply with BASE64 encoding spec"} end
    s = (fn
      c,_,s when c == "==" -> String.slice(s, 0..-3) <> "AA"
      _,c,s when c == "=" -> String.slice(s, 0..-2) <> "A"
      _,_,s -> s
    end).(String.slice(s, (-2)..(-1)), String.slice(s, -1..-1), s)
    id = fn x -> {r,_} = :binary.match(base64_str(), List.to_string([x])); r end
    [h|t] = split(4,s) |> Enum.map(fn <<a,b,c,d>> ->
        n = (id.(a) <<< 18) + (id.(b) <<< 12) + (id.(c) <<<  6) +  id.(d)
        <<0xff &&& (n >>> 16), 0xff &&& (n >>>  8), 0xff &&&  n>>
      end) |> Enum.reverse
    chp = fn <<x,y,_>> when y == 0 -> <<x>>
             <<x,y,z>> when z == 0 -> <<x,y>>
             <<x,y,z>> -> <<x,y,z>> end
    ((Enum.reverse t) |> Enum.join) <> chp.(h)
  end
end
