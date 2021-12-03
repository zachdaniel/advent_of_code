defmodule Aoc2021.Day2 do
  use Aoc2021

  def handle_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      [instruction, amount] = String.split(line, " ")
      %{instruction: instruction, amount: String.to_integer(amount)}
    end)
  end

  def part_1() do
    do_part_1(input())
  end

  def part_1_example() do
    do_part_1(example_input())
  end

  def part_2() do
    do_part_2(input())
  end

  def part_2_example() do
    do_part_2(example_input())
  end

  def do_part_1(input) do
    input
    |> Enum.reduce(
      %{depth: 0, horizontal: 0},
      &follow_part_1_instruction/2
    )
    |> multiply_position()
  end

  def do_part_2(input) do
    input
    |> Enum.reduce(
      %{depth: 0, horizontal: 0, aim: 0},
      &follow_part_2_instruction/2
    )
    |> multiply_position()
  end

  defp follow_part_2_instruction(
         %{instruction: "forward", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal,
           aim: aim
         }
       ) do
    %{depth: depth + aim * amount, horizontal: horizontal + amount, aim: aim}
  end

  defp follow_part_2_instruction(
         %{instruction: "up", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal,
           aim: aim
         }
       ) do
    %{depth: depth, horizontal: horizontal, aim: aim - amount}
  end

  defp follow_part_2_instruction(
         %{instruction: "down", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal,
           aim: aim
         }
       ) do
    %{depth: depth, horizontal: horizontal, aim: aim + amount}
  end

  defp multiply_position(%{depth: depth, horizontal: horizontal}), do: depth * horizontal

  defp follow_part_1_instruction(
         %{instruction: "forward", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal
         }
       ) do
    %{depth: depth, horizontal: horizontal + amount}
  end

  defp follow_part_1_instruction(
         %{instruction: "up", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal
         }
       ) do
    %{depth: depth - amount, horizontal: horizontal}
  end

  defp follow_part_1_instruction(
         %{instruction: "down", amount: amount},
         %{
           depth: depth,
           horizontal: horizontal
         }
       ) do
    %{depth: depth + amount, horizontal: horizontal}
  end
end
