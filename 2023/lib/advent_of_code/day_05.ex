defmodule AdventOfCode.Day05 do
  def part1(input) do
    {seeds, order, maps} =
      input
      |> parse()

    seeds
    |> Enum.map(fn index ->
      order
      |> Enum.reduce(index, fn key, value ->
        maps[key]
        |> Enum.reduce_while(value, fn {source, dest}, x ->
          cond do
            x in source -> {:halt, x - source.first + dest.first}
            true -> {:cont, x}
          end
        end)
      end)
    end)
    |> Enum.min()
  end

  def part2(_input) do
  end

  defp parse(input) do
    [seeds | maps] =
      input
      |> String.split("\n\n", trim: true)

    {
      parse_seeds(seeds),
      parse_order(maps),
      parse_maps(maps)
    }
  end

  defp parse_seeds(line) do
    line
    |> String.split()
    |> tl()
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_order(maps) do
    maps
    |> Enum.map(&(String.split(&1, "-") |> hd()))
  end

  defp parse_maps(maps) do
    maps
    |> Enum.reduce(%{}, &parse_map/2)
  end

  defp parse_map(map, acc) do
    [name | mappings] = String.split(map, "\n", trim: true)

    [from, _, _to] =
      name
      |> String.replace(" map:", "")
      |> String.split("-")

    mappings =
      mappings
      |> Enum.map(&parse_mapping/1)

    acc
    |> put_in([from], mappings)
  end

  defp parse_mapping(line) do
    [destination_start, source_start, length] =
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    {
      source_start..(source_start + length - 1),
      destination_start..(destination_start + length - 1)
    }
  end
end
