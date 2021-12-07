defmodule Aoc2021.Day5 do
  use Aoc2021

  def handle_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn line ->
      [first, last] = String.split(line, " -> ")

      {to_coordinates(first), to_coordinates(last)}
    end)
  end

  def part_1_example() do
    do_part_1(example_input())
  end

  def part_1() do
    do_part_1(input())
  end

  def part_2_example() do
    do_part_2(example_input())
  end

  def part_2() do
    do_part_2(input())
  end

  defp do_part_1(input) do
    horizontal_and_vertical_lines =
      Enum.filter(input, fn {{x1, y1}, {x2, y2}} ->
        x1 == x2 || y1 == y2
      end)

    dangerous_points(horizontal_and_vertical_lines)
  end

  defp do_part_2(lines) do
    dangerous_points(lines)
  end

  defp dangerous_points(lines) do
    {max_x, max_y} = grid_size(lines)

    0..max_x
    |> Enum.map(fn x_coordinate ->
      Enum.count(0..max_y, fn y_coordinate ->
        Enum.count_until(
          lines,
          &intersects?(&1, x_coordinate, y_coordinate),
          2
        ) == 2
      end)
    end)
    |> Enum.sum()
  end

  def intersects?({{x1, y1}, {x2, y2}}, x, y) when x1 == x2 or y1 == y2 do
    min(x1, x2) <= x && x <= max(x1, x2) && min(y1, y2) <= y && y <= max(y1, y2)
  end

  def intersects?({{x1, y1}, {x2, y2}}, x, y) do
    slope = div(y2 - y1, x2 - x1)
    b = y1 - slope * x1

    if y == slope * x + b do
      min(x1, x2) <= x && x <= max(x1, x2) && min(y1, y2) <= y && y <= max(y1, y2)
    end
  end

  defp grid_size(lines) do
    max_x =
      lines
      |> Enum.map(fn {{x1, _}, {x2, _}} ->
        max(x1, x2)
      end)
      |> Enum.max()

    max_y =
      lines
      |> Enum.map(fn {{_, y1}, {_, y2}} ->
        max(y1, y2)
      end)
      |> Enum.max()

    {max_x, max_y}
  end

  defp to_coordinates(string) do
    [x, y] = String.split(string, ",")
    {String.to_integer(x), String.to_integer(y)}
  end
end
