defmodule Aoc2022.Day1 do
  use Aoc2022

  def handle_input(contents) do
    contents
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(fn elf ->
      Enum.map(elf, &String.to_integer/1)
    end)
  end

  def do_part_1(elves) do
    elves
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def do_part_2(elves) do
    elves
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
  end
end
