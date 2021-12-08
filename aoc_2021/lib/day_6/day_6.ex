defmodule Aoc2021.Day6 do
  use Aoc2021

  def handle_input(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn number, acc ->
      Map.update(acc, number, 1, &(&1 + 1))
    end)
  end

  def part_1() do
    input()
    |> simulate(80)
    |> count_fish()
  end

  def part_1_example() do
    example_input()
    |> simulate(80)
    |> count_fish()
  end

  def part_2_example() do
    example_input()
    |> simulate(256)
    |> count_fish()
  end

  def part_2() do
    input()
    |> simulate(256)
    |> count_fish()
  end

  defp count_fish(input) do
    input
    |> Map.values()
    |> Enum.sum()
  end

  defp simulate(input, 0), do: input

  defp simulate(input, days_left) do
    input
    |> Enum.reduce(%{}, fn
      {0, number_of_fish}, acc ->
        acc
        |> Map.update(8, number_of_fish, &(&1 + number_of_fish))
        |> Map.update(6, number_of_fish, &(&1 + number_of_fish))

      {days_left, number_of_fish}, acc ->
        Map.update(acc, days_left - 1, number_of_fish, &(&1 + number_of_fish))
    end)
    |> simulate(days_left - 1)
  end
end
