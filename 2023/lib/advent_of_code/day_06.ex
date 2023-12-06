defmodule AdventOfCode.Day06 do
  def part1(input) do
    input
    |> parse()
    |> Enum.zip()
    |> Enum.map(&calculate_distances/1)
    |> Enum.map(&filter_winning_distances/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.product()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer/1)
    |> then(fn [time, distance] -> {time, distance} end)
    |> calculate_distances()
    |> filter_winning_distances()
    |> Enum.count()
  end

  defp calculate_distances({time, distance}) do
    1..time
    |> Enum.map(fn speed ->
      speed * (time - speed)
    end)
    |> then(&{&1, time, distance})
  end

  defp filter_winning_distances({distances, _, distance}) do
    distances
    |> Enum.filter(fn d -> d > distance end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> tl()
    |> Enum.map(&String.to_integer/1)
  end
end
