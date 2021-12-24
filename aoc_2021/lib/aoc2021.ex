defmodule Aoc2021 do
  @callback handle_input(input :: String.t()) :: term
  @callback handle_part_2_input(input :: String.t()) :: term

  @optional_callbacks handle_part_2_input: 1

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

      def part_2_example_input() do
        part_2_file =
          __ENV__.file
          |> Path.dirname()
          |> Path.join("part_2_example_input.txt")

        file =
          if File.exists?(part_2_file) do
            "part_2_example_input.txt"
          else
            "input.txt"
          end

        __ENV__.file
        |> Path.dirname()
        |> Path.join(file)
        |> File.read!()
        |> handle_part_2_input()
      end

      def part_2_input() do
        part_2_file =
          __ENV__.file
          |> Path.dirname()
          |> Path.join("part_2_input.txt")

        file =
          if File.exists?(part_2_file) do
            "part_2_input.txt"
          else
            "input.txt"
          end

        __ENV__.file
        |> Path.dirname()
        |> Path.join(file)
        |> File.read!()
        |> handle_part_2_input()
      end

      def handle_part_2_input(input) do
        handle_input(input)
      end

      defoverridable handle_part_2_input: 1
    end
  end
end
