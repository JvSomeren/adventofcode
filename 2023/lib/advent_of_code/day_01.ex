defmodule AdventOfCode.Day01 do
  def part1(input) do
    Regex.replace(~r/[a-z]/, input, "", global: true)
    |> String.split("\n")
    |> Enum.filter(fn str -> String.length(str) > 0 end)
    |> Enum.map(fn str -> String.first(str) <> String.last(str) end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp string_number_to_digit(_, str) do
    case str do
      "one" -> "1"
      "two" -> "2"
      "three" -> "3"
      "four" -> "4"
      "five" -> "5"
      "six" -> "6"
      "seven" -> "7"
      "eight" -> "8"
      "nine" -> "9"
      _ -> str
    end
  end

  defp remove_alpha(input), do: Regex.replace(~r/[a-z]/, input, "", global: true)

  def part2(input) do
    Regex.replace(
      ~r/(?=(one|two|three|four|five|six|seven|eight|nine))/,
      input,
      &string_number_to_digit/2,
      global: true
    )
    |> remove_alpha()
    |> String.split("\n")
    |> Enum.filter(fn str -> String.length(str) > 0 end)
    |> Enum.map(fn str -> String.first(str) <> String.last(str) end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
