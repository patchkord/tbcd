-module(tbcd).

-export([
    encode/1,
    encode/2,
    decode/1,
    decode/2
]).

-type tbcd() :: binary().
-type tbcd_opts() :: boolean().

-spec encode(number() | string()) -> tbcd().
encode(Number) when is_integer(Number) ->
  encode(integer_to_list(Number), false);
encode(NumberList) when is_list(NumberList) ->
  encode(NumberList, false).

-spec encode(string(), tbcd_opts()) -> tbcd().
encode(Number, Opt) when is_integer(Number) ->
  encode(integer_to_list(Number), Opt);
encode(Bin, true) when is_list(Bin) ->
    tbcd_native:encode(Bin);
encode(NumberList, false) when is_list(NumberList) ->
  Binary = << <<X:4>> || X <- lists:reverse(NumberList) >>,
  case bit_size(Binary) rem 8 of
    0 -> Binary;
    _ -> << <<2#1111:4>>/bitstring, Binary/bitstring >>
  end.

-spec decode(tbcd()) -> binary().
decode(Bin) ->
    decode(Bin, true).

-spec decode(tbcd(), tbcd_opts()) -> string().
decode(Bin, true) ->
    tbcd_native:decode(Bin);
decode(Bin, false) ->
    lists:reverse([N + $0 || <<N:4>> <= Bin, N =/= 2#1111]).
