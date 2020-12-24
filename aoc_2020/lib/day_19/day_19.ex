defmodule Aoc2020.Day19 do
  @input "lib/day_19/input.txt"
         |> File.read!()

  [rules, messages] = String.split(@input, "\n\n")

  @messages String.split(messages, "\n")

  @rules rules
         |> String.split("\n")
         |> Enum.into(%{}, fn rules ->
           {rule_num, rest} = Integer.parse(rules)
           rest = String.trim_leading(rest, ": ")

           case rest do
             "\"" <> letter ->
               {rule_num, String.trim_trailing(letter, "\"")}

             numbers ->
               parsed_rules =
                 numbers
                 |> String.split(" | ")
                 |> Enum.map(fn rule ->
                   rule
                   |> String.split(" ")
                   |> Enum.reject(&(&1 == ""))
                   |> Enum.map(fn
                     "\"" <> letter ->
                       String.trim_trailing(letter, "\"")

                     rule_num ->
                       String.to_integer(rule_num)
                   end)
                 end)
                 |> case do
                   [rule] ->
                     rule

                   rules ->
                     {:alt, rules}
                 end

               {rule_num, parsed_rules}
           end
         end)

  def part_one do
    Enum.count(@messages, fn message ->
      match_rules?(message, @rules[0])
    end)
  end

  def part_two do
    rules =
      @rules
      |> Map.put(8, {:alt, [[42], [42, 8]]})
      |> Map.put(11, {:alt, [[42, 31], [42, 11, 31]]})

    Enum.count(@messages, fn message ->
      match_rules?(message, rules[0], rules)
    end)
  end

  defp match_rules?(_, _, all_rules \\ @rules)
  defp match_rules?("", [], _), do: true
  defp match_rules?(_, [], _), do: false

  defp match_rules?(message, {:alt, rules}, all_rules) do
    Enum.any?(rules, &match_rules?(message, &1, all_rules))
  end

  defp match_rules?(message, [rule | rest], all_rules) when is_integer(rule) do
    match_rules?(message, List.wrap(all_rules[rule]) ++ rest, all_rules)
  end

  defp match_rules?(message, [{:alt, rules} | rest], all_rules) do
    Enum.any?(rules, &match_rules?(message, List.wrap(&1) ++ rest, all_rules))
  end

  defp match_rules?(message, [rule | rest], all_rules) when is_binary(rule) do
    case String.split_at(message, 1) do
      {^rule, remaining} ->
        match_rules?(remaining, rest, all_rules)

      _ ->
        false
    end
  end
end
