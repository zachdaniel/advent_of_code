defmodule Aoc2020.Day13 do
  @input "lib/day_13/input.txt"
         |> File.read!()
         |> String.split("\n")

  @earliest_departure @input |> Enum.at(0) |> String.to_integer()
  @in_service_busses @input
                     |> Enum.at(1)
                     |> String.split(",")
                     |> Enum.reject(&(&1 == "x"))
                     |> Enum.map(&String.to_integer/1)

  @all_busses @input
              |> Enum.at(1)
              |> String.split(",")
              |> Enum.with_index()
              |> Enum.reject(fn {elem, _} -> elem == "x" end)
              |> Enum.map(fn {elem, i} ->
                {String.to_integer(elem), i}
              end)
              |> Enum.sort_by(&elem(&1, 0))

  def part_one() do
    {id, minutes} =
      @in_service_busses
      |> Enum.map(&{&1, earliest_departure_time(&1)})
      |> Enum.min_by(&elem(&1, 1))

    id * (minutes - @earliest_departure)
  end

  def part_two() do
    search(@all_busses, 1, 1)
  end

  defp search([], tick, _), do: tick

  defp search(input, tick, factor) do
    match =
      Enum.find_index(input, fn {elem, i} ->
        rem(tick + i, elem) == 0
      end)

    case match do
      nil ->
        search(input, tick + factor, factor)

      match ->
        {bus, _i} = Enum.at(input, match)

        search(List.delete_at(input, match), tick, factor * bus)
    end
  end

  defp earliest_departure_time(bus, init \\ nil) do
    if bus >= @earliest_departure do
      bus
    else
      init = init || bus
      earliest_departure_time(bus + init, init)
    end
  end
end
