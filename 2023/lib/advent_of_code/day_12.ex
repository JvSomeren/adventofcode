defmodule AdventOfCode.Day12 do
  use Agent

  def start_link(item, initial_cache \\ %{}) do
    Agent.start_link(fn -> initial_cache end, name: __MODULE__)
    item
  end

  def stop(item) do
    Agent.stop(__MODULE__)
    item
  end

  def part1(input) do
    input
    |> parse()
    |> start_link()
    |> Enum.map(&count_possible_arrangements/1)
    |> stop()
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&unfold_record(&1, 5))
    |> start_link()
    |> Enum.map(&count_possible_arrangements/1)
    |> stop()
    |> Enum.sum()
  end

  defp count_possible_arrangements(record)

  defp count_possible_arrangements({"", []}), do: 1
  defp count_possible_arrangements({"", _}), do: 0

  defp count_possible_arrangements({springs, []}) do
    if springs |> String.contains?("#"),
      do: 0,
      else: 1
  end

  defp count_possible_arrangements({<<??, rest::binary>>, contiguous}) do
    count_possible_arrangements({"#" <> rest, contiguous}) +
      count_possible_arrangements({"." <> rest, contiguous})
  end

  defp count_possible_arrangements({<<?., rest::binary>>, contiguous}),
    do: count_possible_arrangements({rest, contiguous})

  defp count_possible_arrangements({<<?#, _::binary>> = springs, contiguous_list} = record) do
    cached = Agent.get(__MODULE__, &(Map.get(&1, record)))

    if cached do
      cached
    else
      [contiguous | remaining] = contiguous_list
      contiguous_slice = springs |> String.slice(0..(contiguous - 1))
      rest = springs |> String.slice((contiguous + 1)..-1)

      cached = cond do
        String.length(springs) < Enum.sum(contiguous_list) + Enum.count(contiguous_list) - 1 -> 0
        contiguous_slice |> String.contains?(".") -> 0
        String.at(springs, contiguous) == "#" -> 0
        true -> count_possible_arrangements({rest, remaining})
      end

      Agent.update(__MODULE__, &(Map.put(&1, record, cached)))

      cached
    end
  end

  defp unfold_record({springs, contiguous}, copies) do
    springs = springs |> List.duplicate(5) |> Enum.join("?")
    contiguous = contiguous |> List.duplicate(copies) |> List.flatten()

    {springs, contiguous}
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(line) do
    [springs, grouped_springs] =
      line
      |> String.split()

    grouped_springs =
      grouped_springs
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {springs, grouped_springs}
  end
end
