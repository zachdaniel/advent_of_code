defmodule Aoc2021.Day11 do
  use Aoc2021

  alias Aoc2021.Day11.Octopus

  def handle_input(input) do
    input
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {octopus_energy_value, x}, acc ->
        Map.put(acc, {x, y}, String.to_integer(octopus_energy_value))
      end)
    end)
  end

  def part_1_example() do
    do_part_1(example_input())
  end

  def part_1() do
    do_part_1(input())
  end

  defp do_part_1(input) do
    run_steps(input, 100)
  end

  def part_2_example() do
    do_part_2(example_input())
  end

  def part_2() do
    do_part_2(input())
  end

  defp do_part_2(input) do
    find_synchronized_step(input, Enum.count(input))
  end

  defp find_synchronized_step(octopuses, input_size, step \\ 0)

  defp find_synchronized_step(octopuses, input_size, step) do
    {new_octopuses, count_of_flashes} =
      octopuses
      |> increase_all()
      |> count_and_reset_flashed_octopuses()

    if count_of_flashes == input_size do
      step + 1
    else
      find_synchronized_step(new_octopuses, input_size, step + 1)
    end
  end

  defp run_steps(octopuses, steps, total_flashes \\ 0)
  defp run_steps(_octopuses, 0, total_flashes), do: total_flashes

  defp run_steps(octopuses, steps, total_flashes) do
    {new_octopuses, count_of_flashes} =
      octopuses
      |> increase_all()
      |> count_and_reset_flashed_octopuses()

    # print_grid(new_octopuses)

    run_steps(new_octopuses, steps - 1, total_flashes + count_of_flashes)
  end

  defp increase_all(octopuses) do
    Enum.reduce(octopuses, octopuses, fn {coordinates, _}, octopuses ->
      increase_octopus(coordinates, octopuses)
    end)
  end

  defp increase_octopus(coordinates, octopuses) do
    current_value = octopuses[coordinates]
    octopuses = Map.put(octopuses, coordinates, current_value + 1)

    if current_value == 9 do
      coordinates
      |> neighbors()
      |> Enum.filter(&Map.has_key?(octopuses, &1))
      |> Enum.reduce(octopuses, &increase_octopus/2)
    else
      octopuses
    end
  end

  defp count_and_reset_flashed_octopuses(octopuses) do
    Enum.reduce(octopuses, {octopuses, 0}, fn {coordinates, value}, {octopuses, count} ->
      if value >= 10 do
        {Map.put(octopuses, coordinates, 0), count + 1}
      else
        {octopuses, count}
      end
    end)
  end

  defp neighbors({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y + 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x + 1, y + 1},
      {x - 1, y - 1},
      {x - 1, y + 1}
    ]
  end

  defp print_grid(board) do
    coordinates = Map.keys(board)
    all_xs = Enum.map(coordinates, &elem(&1, 0))
    all_ys = Enum.map(coordinates, &elem(&1, 1))
    max_y = Enum.max(all_ys)
    max_x = Enum.max(all_xs)

    0..max_y
    |> Enum.map_join("\n", fn y ->
      Enum.map_join(0..max_x, " ", fn x ->
        board[{x, y}]
      end)
    end)
    |> IO.puts()
  end

  # defp do_part_1(input) do
  #   with_octopuses(input, fn octopuses ->
  #     run_steps(octopuses, 100)
  #   end)

  #   count_flashes()
  # end

  # defp with_octopuses(input, func) do
  #   octopuses =
  #     Enum.map(input, fn {coordinates, energy_value} ->
  #       {:ok, pid} = Octopus.start_link(coordinates, energy_value, self())
  #       pid
  #     end)

  #   try do
  #     func.(octopuses)
  #   after
  #     Enum.each(octopuses, &GenServer.stop/1)
  #   end
  # end

  # defp run_steps(octopuses, steps_remaining)
  # defp run_steps(_octopuses, 0), do: :ok

  # defp run_steps(octopuses, steps) do
  #   Enum.each(octopuses, fn pid ->
  #     GenServer.cast(pid, :increase)
  #   end)

  #   wait_for_increase_responses(octopuses)

  #   reset_flashed_octopuses(octopuses)

  #   run_steps(octopuses, steps - 1)
  # end

  # defp count_flashes(flashes \\ 0) do
  #   receive do
  #     :flash ->
  #       count_flashes(flashes + 1)
  #   after
  #     0 ->
  #       flashes
  #   end
  # end

  # defp reset_flashed_octopuses(octopuses) do
  #   Enum.each(octopuses, fn pid ->
  #     GenServer.call(pid, :reset_if_flashed)
  #   end)
  # end

  # defp wait_for_increase_responses([]), do: :ok

  # defp wait_for_increase_responses(octopuses) do
  #   receive do
  #     {:increase_complete, pid} ->
  #       wait_for_increase_responses(octopuses -- [pid])
  #   end
  # end
end
