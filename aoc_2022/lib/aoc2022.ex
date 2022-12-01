defmodule Aoc2022 do
  @moduledoc """
  Documentation for `Aoc2022`.
  """

  @callback handle_input(input :: String.t()) :: term
  @callback handle_part_2_input(input :: String.t()) :: term
  @callback do_part_1(term) :: term
  @callback do_part_2(term) :: term

  @optional_callbacks handle_part_2_input: 1

  defmacro __using__(_opts) do
    quote do
      @behaviour Aoc2022

      def part_1_example() do
        do_part_1(example_input())
      end

      def part_1() do
        do_part_1(input())
      end

      def part_2_example() do
        do_part_2(part_2_example_input())
      end

      def part_2() do
        do_part_2(part_2_input())
      end

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

      defoverridable handle_part_2_input: 1,
                     part_1: 0,
                     part_1_example: 0,
                     part_2: 0,
                     part_2_example: 0
    end
  end
end
