defmodule Aoc2021.Day12 do
  use Aoc2021

  def handle_input(input) do
    input
    |> String.split("\n")
    |> Enum.reduce(%{}, fn points, map ->
      [start, finish] = String.split(points, "-", trim: true)

      map
      |> Map.update(start, MapSet.new([finish]), &MapSet.put(&1, finish))
      |> Map.update(finish, MapSet.new([start]), &MapSet.put(&1, start))
    end)
  end

  defmodule EndpointReachCounter do
    use Agent

    def start_link() do
      Agent.start_link(
        fn ->
          %{
            endpoint_reaching_tasks: 0
          }
        end,
        name: __MODULE__
      )
    end

    def stop() do
      Agent.stop(__MODULE__)
    end

    def reached_endpoint() do
      Agent.update(
        __MODULE__,
        fn state ->
          %{
            state
            | endpoint_reaching_tasks: state.endpoint_reaching_tasks + 1
          }
        end,
        :infinity
      )
    end

    def get_count() do
      Agent.get(__MODULE__, fn state -> state.endpoint_reaching_tasks end)
    end
  end

  def part_1() do
    count_unique_paths(input())
  end

  def part_1_example() do
    count_unique_paths(example_input())
  end

  def part_2() do
    count_unique_paths(input(), true)
  end

  def part_2_example() do
    count_unique_paths(example_input(), true)
  end

  defp count_unique_paths(map, allow_one_small_cave_revisit? \\ false) do
    EndpointReachCounter.start_link()

    count_paths_to_end(
      "start",
      map,
      %{
        trail: [],
        one_small_cave_revisited?: !allow_one_small_cave_revisit?
      }
    )

    EndpointReachCounter.get_count()
  after
    EndpointReachCounter.stop()
  end

  defp count_paths_to_end("end", _map, _history) do
    EndpointReachCounter.reached_endpoint()
    :ok
  end

  defp count_paths_to_end(location, map, history) do
    revisiting_small_cave? = String.downcase(location) == location && location in history.trail

    if revisiting_small_cave? && (history.one_small_cave_revisited? || location == "start") do
      :ok
    else
      new_history = %{
        history
        | trail: [location | history.trail],
          one_small_cave_revisited?: revisiting_small_cave? || history.one_small_cave_revisited?
      }

      map
      |> Map.get(location, [])
      |> Enum.each(fn next_location ->
        count_paths_to_end(next_location, map, new_history)
      end)
    end
  end

  # defp trail_to_string(%{trail: trail, one_small_cave_revisited?: revisited?}) do
  #   trail
  #   |> Enum.reverse()
  #   |> Enum.join(",")
  #   |> Kernel.<>(": #{revisited?}")
  # end
end
