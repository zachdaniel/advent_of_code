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

  defmodule TaskManager do
    use Agent

    def start_link(ref) do
      Agent.start_link(
        fn ->
          %{
            tasks: [ref],
            endpoint_reaching_tasks: 0
          }
        end,
        name: __MODULE__
      )
    end

    def stop() do
      Agent.stop(__MODULE__)
    end

    def register_task(ref) do
      Agent.update(
        __MODULE__,
        fn state ->
          count = Enum.count(state.tasks) + 1

          if rem(count, 1000) == 0 do
            IO.inspect(count)
          end

          %{state | tasks: [ref | state.tasks]}
        end,
        :infinity
      )
    end

    def deregister_task(ref, reached_endpoint?) do
      Agent.update(
        __MODULE__,
        fn state ->
          new_endpoint_reaching_tasks =
            if reached_endpoint? do
              state.endpoint_reaching_tasks + 1
            else
              state.endpoint_reaching_tasks
            end

          count = Enum.count(state.tasks) - 1

          if rem(count, 1000) == 0 do
            IO.inspect(count)
          end

          %{
            state
            | tasks: state.tasks -- [ref],
              endpoint_reaching_tasks: new_endpoint_reaching_tasks
          }
        end,
        :infinity
      )
    end

    def wait_for_all_tasks() do
      {remaining_tasks?, endpoint_reaching_tasks} =
        Agent.get(
          __MODULE__,
          fn state ->
            {!Enum.empty?(state.tasks), state.endpoint_reaching_tasks}
          end,
          :infinity
        )

      if remaining_tasks? do
        :timer.sleep(10)
        wait_for_all_tasks()
      else
        endpoint_reaching_tasks
      end
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
    ref = make_ref()
    TaskManager.start_link(ref)

    count_paths_to_end(
      "start",
      map,
      ref,
      %{
        trail: [],
        one_small_cave_revisited?: !allow_one_small_cave_revisit?
      }
    )

    TaskManager.wait_for_all_tasks()
  after
    TaskManager.stop()
  end

  defp count_paths_to_end("end", _map, ref, _history) do
    # IO.inspect("#{trail_to_string(%{history | trail: history.trail ++ ["end"]})} reached the end")
    TaskManager.deregister_task(ref, true)
  end

  defp count_paths_to_end(location, map, ref, history) do
    revisiting_small_cave? = String.downcase(location) == location && location in history.trail

    if revisiting_small_cave? && (history.one_small_cave_revisited? || location == "start") do
      # IO.inspect("#{trail_to_string(history)} reached a duplicate cave #{location}")

      TaskManager.deregister_task(ref, false)
    else
      new_history = %{
        history
        | trail: [location | history.trail],
          one_small_cave_revisited?: revisiting_small_cave? || history.one_small_cave_revisited?
      }

      map
      |> Map.get(location, [])
      |> Enum.each(fn next_location ->
        ref = make_ref()
        TaskManager.register_task(ref)

        spawn(fn ->
          count_paths_to_end(next_location, map, ref, new_history)
        end)
      end)

      TaskManager.deregister_task(ref, false)
    end
  end

  # defp trail_to_string(%{trail: trail, one_small_cave_revisited?: revisited?}) do
  #   trail
  #   |> Enum.reverse()
  #   |> Enum.join(",")
  #   |> Kernel.<>(": #{revisited?}")
  # end
end
