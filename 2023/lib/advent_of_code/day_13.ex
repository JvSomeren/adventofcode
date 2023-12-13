defmodule AdventOfCode.Day13 do
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&determine_pattern_value/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&determine_pattern_value(&1, 1))
    |> Enum.sum()
  end

  defp determine_pattern_value(pattern, expected_diff \\ 0)

  defp determine_pattern_value({rows, columns}, expected_diff) do
    row_reflection = expected_diff |> find_reflection(rows)
    column_reflection = expected_diff |> find_reflection(columns)

    row_reflection * 100 + column_reflection
  end

  defp find_reflection(expected_diff, lines, previous_lines \\ [], offset \\ 1)

  defp find_reflection(_, [_], _, _), do: 0

  defp find_reflection(expected_diff, [a, b | tail], previous_lines, offset) do
    case differences_for_lines([a | previous_lines], [b | tail]) do
      ^expected_diff -> offset
      _ -> find_reflection(expected_diff, [b | tail], [a | previous_lines], offset + 1)
    end
  end

  defp differences_for_lines(previous_lines, next_lines)

  defp differences_for_lines([], _), do: 0
  defp differences_for_lines(_, []), do: 0

  defp differences_for_lines([a | tail_prev], [b | tail_next]) do
    string_diff(a, b) + differences_for_lines(tail_prev, tail_next)
  end

  defp string_diff(a, b)
       when byte_size(a) == 0 or byte_size(b) == 0,
       do: (byte_size(a) - byte_size(b)) |> abs()

  defp string_diff(<<a::utf8, rest_a::binary>>, <<b::utf8, rest_b::binary>>) when a == b,
    do: string_diff(rest_a, rest_b)

  defp string_diff(<<a::utf8, rest_a::binary>>, <<b::utf8, rest_b::binary>>) when a != b,
    do: 1 + string_diff(rest_a, rest_b)

  defp parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_pattern/1)
  end

  defp parse_pattern(pattern_string) do
    rows = pattern_string |> String.split("\n", trim: true)

    columns =
      rows
      |> Enum.map(&String.to_charlist/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&List.to_string/1)

    {rows, columns}
  end
end
