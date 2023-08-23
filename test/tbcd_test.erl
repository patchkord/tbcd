-module(tbcd_test).

-include_lib("eunit/include/eunit.hrl").

encode_test_() ->
  [
    ?_assertEqual(<<2:4, 1:4>>, tbcd:encode(12)),
    ?_assertEqual(<<2#1111:4, 3:4, 2:4, 1:4>>, tbcd:encode(123))
  ].

encode_native_test_() ->
  [
    ?_assertEqual(<<2:4, 1:4>>, tbcd:encode(12, true)),
    ?_assertEqual(<<2#1111:4, 3:4, 2:4, 1:4>>, tbcd:encode(123, true))
  ].


decode_test_() ->
  [
    ?_assertEqual("12", tbcd:decode(<<2:4, 1:4>>)),
    ?_assertEqual("123", tbcd:decode(<<2#1111:4, 3:4, 2:4, 1:4>>))
  ].

decode_native_test_() ->
  [
    ?_assertEqual("12", tbcd:decode(<<2:4, 1:4>>, true)),
    ?_assertEqual("123", tbcd:decode(<<2#1111:4, 3:4, 2:4, 1:4>>, true))
  ].
