defmodule Aoc2021.Day9 do
  use Aoc2021

  def handle_input(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {height, x}, acc ->
        height = String.to_integer(height)
        Map.put(acc, {x, y}, height)
      end)
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
    basins =
      input
      |> Enum.reject(fn {_, value} ->
        value == 9
      end)
      |> Map.new()
      |> find_basins()

    basins
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(1, &Kernel.*/2)
  end

  defp find_basins(input, acc \\ [])

  defp find_basins(input, acc) when input == %{} do
    acc
  end

  defp find_basins(input, acc) do
    {remaining_input, basin} = find_one_basin(input)
    find_basins(remaining_input, [basin | acc])
  end

  defp find_one_basin(heights) do
    {{x, y}, _} = Enum.random(heights)

    find_size_of_and_remove_basin(x, y, Map.delete(heights, {x, y}))
  end

  defp find_size_of_and_remove_basin(x, y, heights, basin_size \\ 1) do
    present_neighboring_points =
      x
      |> neighboring_points(y)
      |> Enum.filter(&Map.has_key?(heights, &1))

    if Enum.empty?(present_neighboring_points) do
      {heights, basin_size}
    else
      continue_finding_size_of_basin(present_neighboring_points, heights, basin_size)
    end
  end

  defp continue_finding_size_of_basin([], heights, basin_size) do
    {heights, basin_size}
  end

  defp continue_finding_size_of_basin([{x, y} = point | remaining_points], heights, basin_size) do
    if Map.has_key?(heights, point) do
      {new_heights, new_basin_size} =
        find_size_of_and_remove_basin(x, y, Map.delete(heights, {x, y}), basin_size + 1)

      continue_finding_size_of_basin(remaining_points, new_heights, new_basin_size)
    else
      continue_finding_size_of_basin(remaining_points, heights, basin_size)
    end
  end

  defp do_part_1(input) do
    input
    |> Enum.reduce(0, fn {{x, y}, height}, total_risk ->
      if low_point?(x, y, height, input) do
        total_risk + 1 + height
      else
        total_risk
      end
    end)
  end

  defp low_point?(x, y, height, points) do
    x
    |> neighboring_points(y)
    |> Enum.all?(fn {x, y} ->
      neighboring_height = points[{x, y}]

      if neighboring_height do
        neighboring_height > height
      else
        true
      end
    end)
  end

  defp neighboring_points(x, y) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end
end
