defmodule Aoc2020.Day6 do
  @input "lib/day_6/input.txt"
         |> File.read!()
         |> String.split("\n\n")

  def part_one() do
    @input
    |> Enum.map(fn group ->
      group
      |> String.graphemes()
      |> Enum.reject(&(&1 == "\n"))
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def part_two() do
    @input
    |> Enum.map(fn group ->
      group
      |> String.split("\n")
      |> Enum.reduce(nil, fn row, intersection ->
        map_set = MapSet.new(String.graphemes(row))

        if intersection do
          MapSet.intersection(intersection, map_set)
        else
          map_set
        end
      end)
      |> MapSet.size()
    end)
    |> Enum.sum()
  end
end
