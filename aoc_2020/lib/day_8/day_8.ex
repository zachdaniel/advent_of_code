defmodule Aoc2020.Day8 do
  @input "lib/day_8/input.txt"
         |> File.read!()
         |> String.split("\n")

  def part_one() do
    {:infinite, acc} = execute(0)
    acc
  end

  def part_two() do
    {:finite, acc} = execute(0, true)
    acc
  end

  defp execute(i, find_glitch? \\ false, acc \\ 0, run \\ []) do
    if i in run do
      {:infinite, acc}
    else
      case Enum.at(@input, i) do
        "nop " <> dest ->
          result = execute(i + 1, find_glitch?, acc, [i | run])

          if find_glitch? do
            case result do
              {:infinite, _acc} ->
                execute(i + int(dest), false, acc, [i | run])

              {:finite, acc} ->
                {:finite, acc}
            end
          else
            result
          end

        "jmp " <> dest ->
          result = execute(i + int(dest), find_glitch?, acc, [i | run])

          if find_glitch? do
            case result do
              {:infinite, _acc} ->
                execute(i + 1, false, acc, [i | run])

              {:finite, acc} ->
                {:finite, acc}
            end
          else
            result
          end

        "acc " <> acc_change ->
          execute(i + 1, find_glitch?, acc + int(acc_change), [i | run])

        nil ->
          {:finite, acc}
      end
    end
  end

  defp int("-" <> value) do
    -String.to_integer(value)
  end

  defp int("+" <> value) do
    String.to_integer(value)
  end
end
