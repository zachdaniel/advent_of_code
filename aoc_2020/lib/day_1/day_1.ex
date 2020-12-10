defmodule Aoc2020.Day1 do
  @input "lib/day_1/input.txt"
         |> File.read!()
         |> String.split("\n")
         |> Enum.map(&String.to_integer/1)

  def part_one() do
    Enum.find_value(@input, fn number ->
      Enum.find_value(@input, fn other_number ->
        if number + other_number == 2020 do
          number * other_number
        end
      end)
    end)
  end

  def part_two() do
    Enum.find_value(@input, fn number ->
      Enum.find_value(@input, fn other_number ->
        Enum.find_value(@input, fn third_number ->
          if number + other_number + third_number == 2020 do
            number * other_number * third_number
          end
        end)
      end)
    end)
  end
end
