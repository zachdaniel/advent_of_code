defmodule Aoc2020.Day5 do
  @input "lib/day_5/input.txt"
         |> File.read!()
         |> String.split("\n")
         |> Enum.map(fn <<row::binary-size(7)>> <> <<column::binary-size(3)>> ->
           %{row: row, column: column}
         end)

  def part_one() do
    parse_seats()
    |> Enum.max_by(& &1.id)
    |> Map.get(:id)
  end

  def part_two() do
    ids = MapSet.new(parse_seats(), & &1.id)

    ids
    |> Enum.reject(fn id ->
      MapSet.member?(ids, id + 1) && MapSet.member?(ids, id - 1)
    end)
    |> Enum.sort()
    |> Enum.at(1)
    |> Kernel.+(1)
  end

  defp parse_seats(input \\ @input) do
    input
    |> Enum.map(fn %{row: row, column: column} = seat ->
      %{seat | row: binary_search(row, "F", "B", 127), column: binary_search(column, "L", "R", 7)}
    end)
    |> Enum.map(fn %{column: column, row: row} = seat ->
      Map.put(seat, :id, row * 8 + column)
    end)
  end

  defp binary_search(string, lower, upper, range) do
    string
    |> String.graphemes()
    |> Enum.reduce(
      {0, range},
      fn
        ^lower, {low, high} ->
          {low, high - div(high - low + 1, 2)}

        ^upper, {low, high} ->
          {low + div(high - low + 1, 2), high}
      end
    )
    |> elem(0)
  end
end
