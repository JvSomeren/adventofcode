defmodule AdventOfCode.Day03 do
  # alternative, arguably better solution would be to to iterate over
  # all the symbols and try to match them to numbers
  # instead of the other way around
  def part1(input) do
    line_length =
      input
      |> String.split("\n", trim: true)
      |> List.first()
      |> String.length()

    row_count =
      input
      |> String.split("\n", trim: true)
      |> Enum.count()

    single_line_input = input |> String.replace("\n", "")

    number_indexes =
      ~r/\d+/
      |> Regex.scan(single_line_input, return: :index)
      |> List.flatten()

    symbol_indexes =
      ~r/[^\d\s.]/
      |> Regex.scan(single_line_input, return: :index)
      |> List.flatten()

    number_indexes
    |> Enum.filter(fn i -> filter_part1?(i, symbol_indexes, line_length, row_count) end)
    |> Enum.map(fn number_index ->
      single_line_input
      |> String.slice(elem(number_index, 0), elem(number_index, 1))
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    line_length =
      input
      |> String.split("\n", trim: true)
      |> List.first()
      |> String.length()

    row_count =
      input
      |> String.split("\n", trim: true)
      |> Enum.count()

    single_line_input = input |> String.replace("\n", "")

    number_indexes =
      ~r/\d+/
      |> Regex.scan(single_line_input, return: :index)
      |> List.flatten()

    number_ranges =
      number_indexes
      |> Enum.map(fn i -> Range.new(elem(i, 0), elem(i, 0) + elem(i, 1) - 1) end)

    potential_gear_indexes =
      ~r/\*/
      |> Regex.scan(single_line_input, return: :index)
      |> List.flatten()

    potential_gear_indexes
    |> Enum.map(fn i -> map_to_number_ranges(i, number_ranges, line_length, row_count) end)
    |> Enum.filter(fn i -> Enum.count(i) == 2 end)
    |> Enum.map(fn gear_numbers ->
      gear_numbers
      |> Enum.map(fn number_range ->
        single_line_input
        |> String.slice(number_range)
        |> String.to_integer()
      end)
      |> Enum.product()
    end)
    |> Enum.sum()
  end

  defp filter_part1?(number_index, symbol_indexes, line_length, row_count) do
    row_index = number_index |> elem(0) |> div(row_count)
    column_index = number_index |> elem(0) |> Kernel.-(row_index * row_count)

    start_index =
      column_index
      |> Kernel.-(1)
      |> max(0)
      |> Kernel.+(row_index * row_count)

    end_index =
      number_index
      |> elem(1)
      |> Kernel.+(column_index)
      |> min(line_length)
      |> Kernel.+(row_index * row_count)

    range = Range.new(start_index, end_index)

    ranges = [
      Range.shift(range, -line_length),
      range,
      Range.shift(range, line_length)
    ]

    symbol_indexes
    |> Enum.any?(fn symbol_index ->
      Enum.any?(ranges, fn r ->
        elem(symbol_index, 0) in r
      end)
    end)
  end

  defp map_to_number_ranges(gear_index, number_ranges, line_length, row_count) do
    row_index = gear_index |> elem(0) |> div(row_count)
    column_index = gear_index |> elem(0) |> Kernel.-(row_index * row_count)

    start_index =
      column_index
      |> Kernel.-(1)
      |> max(0)
      |> Kernel.+(row_index * row_count)

    end_index =
      gear_index
      |> elem(1)
      |> Kernel.+(column_index)
      |> min(line_length)
      |> Kernel.+(row_index * row_count)

    range = Range.new(start_index, end_index)

    ranges = [
      Range.shift(range, -line_length),
      range,
      Range.shift(range, line_length)
    ]

    number_ranges
    |> Enum.filter(fn number_range ->
      Enum.any?(ranges, fn r ->
        !Range.disjoint?(r, number_range)
      end)
    end)
  end
end
