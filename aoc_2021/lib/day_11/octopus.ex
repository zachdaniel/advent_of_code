defmodule Aoc2021.Day11.Octopus do
  use GenServer

  require Logger

  def start_link(coordinates, energy_value, runner_pid) do
    GenServer.start_link(
      __MODULE__,
      %{
        energy_value: energy_value,
        coordinates: coordinates,
        runner_pid: runner_pid,
        acknowledge: [],
        waiting_for: []
      },
      name: {:global, coordinates}
    )
  end

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call(:reset_if_flashed, _from, state) do
    log(state, "reset_if_flashed")

    new_energy_value =
      if state.energy_value > 9 do
        0
      else
        state.energy_value
      end

    {:reply, :ok, %{state | energy_value: new_energy_value}}
  end

  def handle_cast({:neighbor_flashed, neighbor_pid}, state) do
    # log(state, "neighbor_flashed")
    new_state = increase(state)

    new_state =
      if Enum.empty?(new_state.waiting_for) do
        GenServer.cast(neighbor_pid, {:acknowledge_flash, self()})
        new_state
      else
        %{new_state | acknowledge: [neighbor_pid | state.acknowledge]}
      end

    {:noreply, new_state}
  end

  def handle_cast({:acknowledge_flash, pid}, state) do
    # log(state, "acknowledging_flash")
    new_state = %{state | waiting_for: state.waiting_for -- [pid]}

    new_state =
      if Enum.empty?(new_state.waiting_for) do
        Enum.each(state.acknowledge, fn pid ->
          GenServer.cast(pid, {:acknowledge_flash, self()})
        end)

        send(state.runner_pid, {:increase_complete, self()})

        %{new_state | acknowledge: []}
      else
        new_state
      end

    {:noreply, new_state}
  end

  def handle_cast(:increase, state) do
    # log(state, "increase")
    new_state = increase(state)

    if Enum.empty?(new_state.waiting_for) do
      send(state.runner_pid, {:increase_complete, self()})
    end

    {:noreply, new_state}
  end

  defp log(state, message) do
    Logger.debug("#{inspect(state.coordinates)}: #{message}")
  end

  defp increase(state) do
    new_energy_value = state.energy_value + 1

    new_waiting_for =
      if state.energy_value == 9 do
        send(state.runner_pid, :flash)

        neighbor_pids =
          state.coordinates
          |> neighbors()
          |> Enum.flat_map(fn neighbor ->
            neighbor
            |> find_neighbor()
            |> List.wrap()
          end)

        Enum.map(neighbor_pids, fn pid ->
          GenServer.cast(pid, {:neighbor_flashed, self()})
          pid
        end)
      else
        []
      end

    # log(state, "new energy value: #{new_energy_value}")

    %{state | energy_value: new_energy_value, waiting_for: new_waiting_for}
  end

  defp find_neighbor(coordinates) do
    case :global.whereis_name(coordinates) do
      :undefined ->
        nil

      pid ->
        pid
    end
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
end
