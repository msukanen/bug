defmodule Bug do
  defmodule Base64 do
    @moduledoc """
    Documentation for `Base64`.
    """
    defmodule Cleanse do
      @moduledoc """
      Documentation for `Cleanse`.
      """
      @cps Enum.to_list(?a..?z) ++ Enum.to_list(?A..?Z) ++ Enum.to_list(?0..?9) ++ [?=,?+,?/]
    
      @doc """
      Clean non-Base64 junk from string.
    
      ## Example
          iex> Bug.Base64.Cleanse.cleanse("this contains spaces and !!! ??? <><> junk")
          "thiscontainsspacesandjunk"
    
      """
      def cleanse(<<>>), do: <<>>
      def cleanse(<<c::utf8, r::binary>>) when c in @cps, do: <<c::utf8>> <> cleanse(r)
      def cleanse(<<_::utf8, r::binary>>), do: cleanse r
    end

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

        iex> Bug.Base64.encode("This is a string")
        "VGhpcyBpcyBhIHN0cmluZw=="

    """
    def encode(s) when is_atom(s) do encode Atom.to_string(s) end
    def encode(s) do
      [pad, s] = case (rem(byte_size(s), 3)) do
          1-> ["==", s <> <<0,0>>]
          2-> ["=", s <> <<0>>]
          _-> ["", s]
      end
      ((split(3, s)
        |> Enum.map(fn <<a,b,c>> ->
            n = ((0xff &&& a)<<<16) + ((0xff &&& b) <<<8) + (0xff &&& c)
            e = fn (v,bits) -> Enum.at(base64_set(), (0x3f &&& (v >>> bits))) end
            <<e.(n,18), e.(n,12), e.(n,6), e.(n,0)>>
          end) |> Enum.join )
        |> String.slice(0..-(String.length(pad)+1))
      ) <> pad
    end

    @doc """
    Decode base64 encoded chunk.

    ## Examples

        iex> Bug.Base64.decode!("VGhpcyBpcyBhIHN0cmluZw==")
        "This is a string"

        iex> Bug.Base64.decode!("VGhpcyBpcyBhIHN0cmluZw==", &Bug.Base64.Cleanse.cleanse/1)
        "This is a string"

    """
    def decode!(s), do: decode!(s, &Cleanse.cleanse/1)
    def decode!(s, cfn) do
      s = cfn.(s)
      if (rem( String.length(s), 4) !== 0)
        do raise {:error, "Data { s } does not comply with BASE64 encoding spec"}
      end
      s = (fn
        c,_,s when c == "==" -> String.slice(s, 0..-3) <> "AA"
        _,c,s when c == "="  -> String.slice(s, 0..-2) <> "A"
        _,_,s -> s
      end).(String.slice(s, -2..-1), String.slice(s, -1..-1), s)
      [h|t] = split(4,s)
        |> Enum.map(fn <<a,b,c,d>> ->
            id = fn x -> {r,_} = :binary.match(base64_str(), List.to_string([x])); r end
            n = (id.(a) <<< 18) + (id.(b) <<< 12) + (id.(c) <<<  6) +  id.(d)
            <<0xff &&& (n >>> 16), 0xff &&& (n >>>  8), 0xff &&&  n>>
          end)
        |> Enum.reverse
      ((Enum.reverse t) |> Enum.join)
        <> (fn <<x,y,_>> when y == 0 -> <<x>>
              <<x,y,z>> when z == 0 -> <<x,y>>
              <<x,y,z>> -> <<x,y,z>> end).(h)
    end
  end
end
