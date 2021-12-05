defmodule Aoc2021 do
  @callback handle_input(input :: String.t()) :: term

  defmacro __using__(_opts) do
    quote do
      @behaviour Aoc2021

      def example_input() do
        __ENV__.file
        |> Path.dirname()
        |> Path.join("example_input.txt")
        |> File.read!()
        |> handle_input()
      end

      def input() do
        __ENV__.file
        |> Path.dirname()
        |> Path.join("input.txt")
        |> File.read!()
        |> handle_input()
      end
    end
  end
end
