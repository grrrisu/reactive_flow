defmodule ReactiveFlowTest do
  use ExUnit.Case
  doctest ReactiveFlow

  test "greets the world" do
    assert ReactiveFlow.hello() == :world
  end
end
