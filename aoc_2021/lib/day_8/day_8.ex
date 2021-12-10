defmodule Aoc2021.Day8 do
  use Aoc2021

  def handle_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      [all_combinations, output] = String.split(line, " | ")

      %{
        all_combinations: split_and_sort(all_combinations),
        output: split_and_sort(output)
      }
    end)
  end

  defp split_and_sort(string) do
    string
    |> String.split(" ")
    |> Enum.map(fn digit ->
      digit |> String.split("") |> Enum.sort() |> Enum.join()
    end)
  end

  def part_2_example() do
    do_part_2(example_input())
  end

  def part_2() do
    do_part_2(input())
  end

  def part_1_example() do
    do_part_1(example_input())
  end

  def part_1() do
    do_part_1(input())
  end

  defp do_part_2(input) do
    input
    |> Enum.map(fn %{all_combinations: all_combinations, output: output} ->
      {one, remaining_combinations} =
        find_combination(all_combinations, &(String.length(&1) == 2))

      {four, remaining_combinations} =
        find_combination(remaining_combinations, &(String.length(&1) == 4))

      {seven, remaining_combinations} =
        find_combination(remaining_combinations, &(String.length(&1) == 3))

      {eight, remaining_combinations} =
        find_combination(remaining_combinations, &(String.length(&1) == 7))

      {six, remaining_combinations} =
        find_combination(remaining_combinations, fn combination ->
          String.length(combination) == 6 &&
            not (one |> String.graphemes() |> Enum.all?(&String.contains?(combination, &1)))
        end)

      {nine, remaining_combinations} =
        find_combination(remaining_combinations, fn combination ->
          String.length(combination) == 6 &&
            four |> String.graphemes() |> Enum.all?(&String.contains?(combination, &1))
        end)

      {zero, remaining_combinations} =
        find_combination(remaining_combinations, &(String.length(&1) == 6))

      {three, remaining_combinations} =
        find_combination(remaining_combinations, fn combination ->
          String.length(combination) == 5 &&
            one |> String.graphemes() |> Enum.all?(&String.contains?(combination, &1))
        end)

      top_right_segment = one |> String.graphemes() |> Enum.find(&(!String.contains?(six, &1)))

      {two, [five]} =
        find_combination(remaining_combinations, fn combination ->
          String.contains?(combination, top_right_segment)
        end)

      output
      |> Enum.map(fn
        ^zero ->
          0

        ^one ->
          1

        ^two ->
          2

        ^three ->
          3

        ^four ->
          4

        ^five ->
          5

        ^six ->
          6

        ^seven ->
          7

        ^eight ->
          8

        ^nine ->
          9
      end)
      |> Enum.join()
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  defp find_combination(all_combinations, func) do
    {[digit_string], remaining_combinations} = Enum.split_with(all_combinations, func)

    {digit_string, remaining_combinations}
  end

  defp do_part_1(input) do
    input
    |> Enum.map(fn %{output: output} ->
      Enum.count(output, fn digit_string ->
        String.length(digit_string) in [2, 4, 3, 7]
      end)
    end)
    |> Enum.sum()
  end
end
