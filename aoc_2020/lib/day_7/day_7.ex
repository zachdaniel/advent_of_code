defmodule Aoc2020.Day7 do
  @input "lib/day_7/input.txt"
         |> File.read!()
         |> String.split("\n")
         |> Enum.map(fn rule ->
           [bag_name, contains] = String.split(rule, " bags contain ", parts: 2)
           {bag_name, contains}
         end)
         |> Enum.into(%{}, fn {bag_name, contains} ->
           new_contains =
             contains
             |> String.split(~r/(\,\s|\.$)/)
             |> Enum.map(&String.trim_trailing(&1, "bags"))
             |> Enum.map(&String.trim_trailing(&1, "bag"))
             |> Enum.map(&String.trim/1)
             |> Enum.reject(&(&1 in ["", "no other"]))
             |> Enum.into(%{}, fn can_contain ->
               {int, bag_name} = Integer.parse(can_contain)

               {String.trim(bag_name), int}
             end)

           {bag_name, new_contains}
         end)

  def part_one() do
    Enum.count(@input, &can_contain?(&1, "shiny gold"))
  end

  def part_two() do
    count_bags_inside(@input["shiny gold"])
  end

  def count_bags_inside(rules) do
    rules
    |> Enum.map(fn {bag_name, count} ->
      if count == 0 do
        0
      else
        count + count * count_bags_inside(@input[bag_name])
      end
    end)
    |> Enum.sum()
  end

  defp can_contain?({_bag_name, contains}, _target) when contains == %{}, do: false

  defp can_contain?({_bag_name, contains}, target) do
    case Map.fetch(contains, target) do
      {:ok, count} when is_integer(count) ->
        count >= 1

      _ ->
        Enum.any?(contains, fn {bag, _count} ->
          can_contain?({bag, Map.get(@input, bag)}, target)
        end)
    end
  end
end
