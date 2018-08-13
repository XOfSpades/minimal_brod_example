defmodule MinimalBrodExampleTest do
  use ExUnit.Case
  doctest MinimalBrodExample

  test "greets the world" do
    assert MinimalBrodExample.hello() == :world
  end
end
