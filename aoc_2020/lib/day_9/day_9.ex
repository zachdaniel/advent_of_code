defmodule Aoc2020.Day9 do
  @all_input "lib/day_9/input.txt"
             |> File.read!()
             |> String.split("\n")
             |> Enum.map(&String.to_integer/1)

  @input @all_input |> Enum.split(25)

  def part_one() do
    find_mismatch(@input)
  end

  def part_two() do
    @input
    |> find_mismatch()
    |> find_contiguous_members_that_sum_to(@all_input)
  end

  defp find_contiguous_members_that_sum_to(
         target,
         [next | rest] = input,
         acc \\ 0,
         trail \\ []
       ) do
    case acc + next do
      val when val > target ->
        input_prefix = Enum.drop(Enum.reverse(trail), 1)
        find_contiguous_members_that_sum_to(target, input_prefix ++ input, 0, [])

      val when val == target ->
        range_to_consider = [next | trail]
        Enum.min(range_to_consider) + Enum.max(range_to_consider)

      val when val < target ->
        find_contiguous_members_that_sum_to(target, rest, val, [next | trail])
    end
  end

  defp find_mismatch({[_ | rest_preamble] = preamble, [check | rest_check]}) do
    preamble
    |> Enum.any?(fn a ->
      Enum.any?(preamble, &(a + &1 == check))
    end)
    |> case do
      false ->
        check

      true ->
        find_mismatch({rest_preamble ++ [check], rest_check})
    end
  end
end
