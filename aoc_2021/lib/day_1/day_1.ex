defmodule Aoc2021.Day1 do
  use Aoc2021

  def handle_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def part_1_example() do
    do_part_1(example_input())
  end

  def part_1() do
    do_part_1(input())
  end

  def part_2_example() do
    do_part_1(example_input(), 3)
  end

  def part_2() do
    do_part_1(input(), 3)
  end

  defp do_part_1(input, window_size \\ 1) do
    input
    |> Enum.reduce(
      %{previous: nil, increases: 0, windows: []},
      fn current_number, %{previous: previous, increases: increases, windows: windows} = state ->
        [first_window | new_windows] =
          shifted_windows =
          Enum.map(windows, &Enum.take([current_number | &1], window_size)) ++ [[current_number]]

        if Enum.count(first_window) == window_size do
          closing_window_sum = Enum.sum(first_window)

          if previous do
            if closing_window_sum > previous do
              %{
                state
                | previous: closing_window_sum,
                  increases: increases + 1,
                  windows: new_windows
              }
            else
              %{state | windows: new_windows, previous: closing_window_sum}
            end
          else
            %{state | windows: shifted_windows, previous: closing_window_sum}
          end
        else
          %{state | windows: shifted_windows}
        end
      end
    )
    |> Map.get(:increases)
  end
end
