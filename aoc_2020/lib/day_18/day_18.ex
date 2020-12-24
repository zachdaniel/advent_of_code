defmodule CustomOperators do
  def a - b, do: a * b
  def a ++ b, do: a * b
end

defmodule Aoc2020.Day18 do
  import Kernel, except: [++: 2, -: 2]
  import CustomOperators, warn: false

  @input "lib/day_18/input.txt"
         |> File.read!()

  def part_one do
    @input
    |> parse_and_adjust_operators("-")
    |> Enum.map(&eval/1)
    |> Enum.sum()
  end

  def part_two do
    @input
    |> parse_and_adjust_operators("++")
    |> Enum.map(&eval/1)
    |> Enum.sum()
  end

  defp eval(calc) do
    calc
    |> Code.eval_string([], __ENV__)
    |> elem(0)
  end

  defp parse_and_adjust_operators(input, new_multiplication_op) do
    input
    |> String.replace(" ", "")
    |> String.replace("*", new_multiplication_op)
    |> String.split("\n")
  end
end
