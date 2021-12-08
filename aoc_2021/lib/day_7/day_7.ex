defmodule Aoc2021.Day7 do
  use Aoc2021

  def handle_input(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def part_1_example() do
    find_optimal_horizontal_position(example_input())
  end

  def part_1() do
    find_optimal_horizontal_position(input())
  end

  def part_2_example() do
    find_optimal_horizontal_position(example_input(), true)
  end

  def part_2() do
    find_optimal_horizontal_position(input(), true)
  end

  defp find_optimal_horizontal_position(input, increasing_fuel_cost? \\ false) do
    highest_crab = Enum.max(input)
    lowest_crab = Enum.min(input)

    Enum.reduce(
      lowest_crab..highest_crab,
      nil,
      fn potential_horizontal_position, least_fuel_intensive_position ->
        fuel_expended =
          input
          |> Enum.map(fn crab_position ->
            if increasing_fuel_cost? do
              increasing_fuel_expense(crab_position, potential_horizontal_position)
            else
              abs(crab_position - potential_horizontal_position)
            end
          end)
          |> Enum.sum()

        if least_fuel_intensive_position do
          min(least_fuel_intensive_position, fuel_expended)
        else
          fuel_expended
        end
      end
    )
  end

  def increasing_fuel_expense(start, finish) do
    difference = abs(start - finish) + 1
    div(difference * (difference - 1), 2)
  end
end
