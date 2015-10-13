
defmodule TimeTest do
  use ExUnit.Case
  alias ChaosSpawn.Time

  test "between? returns false for times lower than the bottom bound" do
    time = {12, 0, 0}
    result = time |> Time.between?({13, 0, 0}, {15, 0, 0})
    assert result == false
  end

  test "between? returns true for times between the bounds" do
    time = {14, 30, 0}
    result = time |> Time.between?({13, 0, 0}, {15, 0, 0})
    assert result == true
  end

  test "between? returns false for times greater than the top bound" do
    time = {15, 30, 0}
    result = time |> Time.between?({13, 0, 0}, {15, 0, 0})
    assert result == false
  end

  test "between? accepts inputs from timex" do
    time = Timex.Date.from({{2015, 6, 24}, {14, 50, 34}})
    result = time |> Time.between?({13, 0, 0}, {15, 0, 0})
    assert result == true
  end


end
