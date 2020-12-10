defmodule Aoc2020.Day3 do
  @input "lib/day_3/input.txt"
         |> File.read!()
         |> String.split("\n")
         |> Enum.map(&String.graphemes/1)

  @part_two_slopes [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

  def part_one() do
    solve(3, 1)
  end

  def part_two() do
    @part_two_slopes
    |> Enum.map(fn {right, down} -> solve(right, down) end)
    |> Enum.reduce(&Kernel.*/2)
  end

  def solve(right \\ 3, down \\ 1, input \\ @input, trail \\ 0, count \\ 0)

  def solve(_, _, [], _trail, count), do: count

  def solve(right, 2, [row, _ | rest], trail, count) do
    solve(right, 2, rest, trail + right, count + check_row(row, trail))
  end

  def solve(right, down, [row | rest], trail, count) do
    solve(right, down, rest, trail + right, count + check_row(row, trail))
  end

  defp check_row(row, trail) do
    row
    |> Stream.cycle()
    |> Stream.drop(trail)
    |> Enum.take(1)
    |> case do
      ["#"] -> 1
      ["."] -> 0
      [] -> 0
    end
  end
end
