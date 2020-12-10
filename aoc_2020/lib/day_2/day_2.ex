defmodule Aoc2020.Day2 do
  @input "lib/day_2/input.txt"
         |> File.read!()
         |> String.split("\n")
         |> Enum.map(fn policy_and_password ->
           [policy, password] = String.split(policy_and_password, ": ", parts: 2)
           [min_max, letter] = String.split(policy, " ", parts: 2)
           [min, max] = String.split(min_max, "-", parts: 2)

           %{
             min: String.to_integer(min),
             max: String.to_integer(max),
             letter: letter,
             password: password
           }
         end)

  def part_one() do
    Enum.count(@input, &old_valid?/1)
  end

  def part_two() do
    Enum.count(@input, &new_valid?/1)
  end

  def old_valid?(%{min: min, max: max, letter: letter, password: password}) do
    count =
      password
      |> String.graphemes()
      |> Enum.count(&(&1 == letter))

    count >= min && count <= max
  end

  def new_valid?(%{min: min, max: max, letter: letter, password: password}) do
    graphemes = String.graphemes(password)

    matches_min? = Enum.at(graphemes, min - 1) == letter
    matches_max? = Enum.at(graphemes, max - 1) == letter

    (matches_min? and not matches_max?) or (matches_max? and not matches_min?)
  end
end
