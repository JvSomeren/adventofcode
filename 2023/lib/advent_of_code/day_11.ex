defmodule AdventOfCode.Day11 do
  def part1(input) do
    {grid, line_length, row_count} =
      input
      |> parse()

    column_indexes = empty_column_indexes(grid, line_length)
    row_indexes = empty_row_indexes(grid, line_length, row_count)

    galaxy_indexes =
      Regex.scan(~r/#/, grid, return: :index)
      |> List.flatten()
      |> get_in([Access.all(), Access.elem(0)])

    galaxy_indexes
    |> calculate_sum_of_distances(column_indexes, row_indexes, line_length)
  end

  def part2(input, scale \\ 1_000_000) do
    {grid, line_length, row_count} =
      input
      |> parse()

    column_indexes = empty_column_indexes(grid, line_length)
    row_indexes = empty_row_indexes(grid, line_length, row_count)

    galaxy_indexes =
      Regex.scan(~r/#/, grid, return: :index)
      |> List.flatten()
      |> get_in([Access.all(), Access.elem(0)])

    galaxy_indexes
    |> calculate_sum_of_distances(column_indexes, row_indexes, line_length, scale)
  end

  defp calculate_sum_of_distances(
         galaxy_index,
         column_indexes,
         row_indexes,
         line_length,
         scale \\ 2
       )

  defp calculate_sum_of_distances([_], _, _, _, _), do: 0

  defp calculate_sum_of_distances([a | tail], column_indexes, row_indexes, line_length, scale) do
    {a_row_index, a_col_index} = get_position(a, line_length)

    summed_distances =
      tail
      |> Enum.map(fn b ->
        {b_row_index, b_col_index} = get_position(b, line_length)

        row_range =
          b_row_index..a_row_index

        col_range =
          b_col_index..a_col_index

        row_addition =
          column_indexes
          |> Enum.filter(fn i -> i in col_range end)
          |> Enum.count()
          |> Kernel.*(scale - 1)

        column_addition =
          row_indexes
          |> Enum.filter(fn i -> i in row_range end)
          |> Enum.count()
          |> Kernel.*(scale - 1)

        b_row_index - a_row_index + abs(b_col_index - a_col_index) + row_addition +
          column_addition
      end)
      |> Enum.sum()

    summed_distances +
      calculate_sum_of_distances(tail, column_indexes, row_indexes, line_length, scale)
  end

  defp get_position(index, line_length), do: {div(index, line_length), rem(index, line_length)}

  defp empty_column_indexes(grid, line_length) do
    total_length = grid |> String.length()

    0..(line_length - 1)
    |> Enum.filter(fn offset ->
      grid
      |> String.slice(offset..total_length//line_length)
      |> String.contains?("#")
      |> Kernel.not()
    end)
  end

  defp empty_row_indexes(grid, line_length, row_count) do
    0..(row_count - 1)
    |> Enum.filter(fn offset ->
      grid
      |> String.slice((offset * line_length)..((offset + 1) * line_length))
      |> String.contains?("#")
      |> Kernel.not()
    end)
  end

  defp parse(input) do
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

    {single_line_input, line_length, row_count}
  end
end
