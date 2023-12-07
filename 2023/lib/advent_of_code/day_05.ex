defmodule AdventOfCode.Day05 do
  def part1(input) do
    {seeds, order, maps} =
      input
      |> parse()

    seeds
    |> Enum.map(fn seed ->
      order
      |> Enum.reduce(seed, fn key, value ->
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

  def part2(input) do
    {seeds, order, maps} =
      input
      |> parse()

    # convert individual seeds to ranges
    seeds =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [first, last] -> first..(first + last - 1) end)

    seeds
    # map all seed ranges
    |> Enum.flat_map(fn seed_range ->
      order
      # reduce for each key in order
      |> Enum.reduce([seed_range], fn key, value ->
        maps[key]
        # map each range according to the mappings of the current order item
        |> Enum.reduce({value, []}, fn mapping, {unmapped_ranges, mapped_ranges} = ranges ->
          unmapped_ranges
          |> Enum.map(&map_range(&1, mapping))
          |> Enum.unzip()
          |> then(fn x ->
            {
              elem(x, 0) |> List.flatten(),
              elem(x, 1) |> List.flatten() |> Enum.concat(mapped_ranges)
            }
          end)
        end)
        |> Tuple.to_list()
        |> List.flatten()
      end)
    end)
    |> Enum.map(& &1.first)
    |> Enum.min()
  end

  defguardp is_disjointed(r1, r2)
            when r2.last < r1.first or r1.last < r2.first

  defguardp is_fully_inside(r1, r2)
            when r1.first >= r2.first and r1.last <= r2.last

  # disjointed
  @spec map_range(Range.t(), {Range.t(), Range.t()}) :: {list(Range.t()), list(Range.t())}
  defp map_range(input_range, {source_range, _}) when is_disjointed(input_range, source_range) do
    {[input_range], []}
  end

  # input_range fully inside source_range
  @spec map_range(Range.t(), {Range.t(), Range.t()}) :: {list(Range.t()), list(Range.t())}
  defp map_range(input_range, {source_range, destination_range})
       when is_fully_inside(input_range, source_range) do
    start_offset = input_range.first - source_range.first
    end_offset = input_range.last - source_range.last

    {
      [],
      [
        (destination_range.first + start_offset)..(destination_range.last + end_offset)
      ]
    }
  end

  # input_range extends on both sides of source_range
  @spec map_range(Range.t(), {Range.t(), Range.t()}) :: {list(Range.t()), list(Range.t())}
  defp map_range(input_range, {source_range, destination_range})
       when input_range.first < source_range.first and source_range.last < input_range.last do
    {
      [
        # before source
        input_range.first..(source_range.first - 1),

        # after source
        (source_range.last + 1)..input_range.last
      ],
      [
        # source
        destination_range
      ]
    }
  end

  # input_range extends on left of source_range
  @spec map_range(Range.t(), {Range.t(), Range.t()}) :: {list(Range.t()), list(Range.t())}
  defp map_range(input_range, {source_range, destination_range})
       when input_range.first < source_range.first and input_range.last <= source_range.last do
    end_offset = input_range.last - source_range.last

    {
      [
        # before source
        input_range.first..(source_range.first - 1)
      ],
      [
        # source
        destination_range.first..(destination_range.last + end_offset)
      ]
    }
  end

  # input_range extends on right of source_range
  @spec map_range(Range.t(), {Range.t(), Range.t()}) :: {list(Range.t()), list(Range.t())}
  defp map_range(input_range, {source_range, destination_range})
       when input_range.first >= source_range.first and input_range.last > source_range.last do
    start_offset = input_range.first - source_range.first

    {
      [
        # after source
        (source_range.last + 1)..input_range.last
      ],
      [
        # source
        (destination_range.first + start_offset)..destination_range.last
      ]
    }
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
