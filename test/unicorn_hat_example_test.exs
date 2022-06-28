defmodule UnicornHatExampleTest do
  use ExUnit.Case
  doctest UnicornHatExample

  test "greets the world" do
    assert UnicornHatExample.hello() == :world
  end
end
