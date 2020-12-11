defmodule Aoc2020.Day10 do
  @input "lib/day_10/input.txt"
         |> File.read!()
         |> String.split("\n")
         |> Enum.map(&String.to_integer/1)
         |> Enum.sort()

  def part_one() do
    @input
    |> Enum.reduce({%{1 => 0, 2 => 0, 3 => 1}, 0}, fn item, {acc, last} ->
      {Map.update!(acc, item - last, &(&1 + 1)), item}
    end)
    |> elem(0)
    |> Map.take([1, 3])
    |> Map.values()
    |> Enum.reduce(&Kernel.*/2)
  end

  def part_two() do
    [0 | @input]
    |> count_possibilities()
  end

  defp count_possibilities([_]), do: 1

  defp count_possibilities([first | rest]) do
    # Many possibilities don't appear in the puzzle input, so I've removed them from
    # the case statement for clarity
    case Enum.count(Enum.take_while(rest, &(&1 - first <= 3))) do
      1 ->
        count_possibilities(rest)

      2 ->
        count_possibilities(Enum.drop(rest, 1)) * 2

      3 ->
        case Enum.at(rest, 3) do
          val when val == first + 4 ->
            count_possibilities(Enum.drop(rest, 2)) * 7

          val when val == first + 6 ->
            count_possibilities(Enum.drop(rest, 2)) * 4
        end
    end
  end
end
