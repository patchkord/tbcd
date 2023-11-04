defmodule Tbcd.Test do
  @moduledoc false
  use ExUnit.Case

  alias :tbcd, as: Tbcd

  @aligned_binary   <<2::4, 1::4>>
  @unaligned_binary <<0b1111::4, 3::4, 2::4, 1::4>>

  @aligned_value '12'
  @unaligned_value '123'

  describe "encode" do
    test "when value is integer" do
      assert(@aligned_binary = Tbcd.encode(String.to_integer(to_string(@aligned_value))))
    end

    test "NIF" do
      assert(@aligned_binary = Tbcd.encode(@aligned_value))
      assert(@unaligned_binary == Tbcd.encode(@unaligned_value))
    end

    test "compat" do
      assert(@aligned_binary = Tbcd.encode(@aligned_value, false))
      assert(@unaligned_binary = Tbcd.encode(@unaligned_value, false))
    end
  end

  describe "decode" do
    test "NIF" do
      assert(@aligned_value = Tbcd.decode(@aligned_binary))
      assert(@unaligned_value = Tbcd.decode(@unaligned_binary))
    end

    test "compat" do
     assert(@aligned_value, Tbcd.decode(@aligned_binary, false))
     assert(@unaligned_value, Tbcd.decode(@unaligned_binary, false))
    end
  end
end
