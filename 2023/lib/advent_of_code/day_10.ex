defmodule AdventOfCode.Day10 do
  def part1(input) do
    {grid, start_index, line_length, _} =
      input
      |> parse()

    path_length(grid, start_index, line_length) |> div(2)
  end

  def part2(input) do
    {grid, start_index, line_length, _} =
      input
      |> parse()

    indexes = path_indexes(grid, start_index, line_length)

    grid
    |> Enum.with_index()
    |> Enum.map(fn {char, index} -> if index in indexes, do: char, else: ?. end)
    |> Enum.chunk_every(line_length)
    |> Enum.map(&x/1)
    |> Enum.sum()
  end

  defp x(list) do
    list
    |> List.to_string()
    # (L-*7|[FS]-*J) replace with 1 pipe
    |> String.replace(~r/(L-*7|[FS]-*J)/, "|") # used for examples
    # |> String.replace(~r/(L-*[7S]|F-*J)/, "|") # used for personal input
    # (L-*J|[FS]-*7) replace with 2 pipes
    |> String.replace(~r/(L-*J|[FS]-*7)/, "||") # used for examples
    # |> String.replace(~r/(L-*J|F-*[7S])/, "||") # used for personal input
    |> String.to_charlist()
    |> y()
  end

  defp y(list, in_path \\ false, count \\ 0)

  defp y([], _, count), do: count

  defp y([?. | tail], false = in_path, count), do: y(tail, in_path, count)
  defp y([?. | tail], true = in_path, count), do: y(tail, in_path, count + 1)

  defp y([?| | tail], in_path, count), do: y(tail, !in_path, count)

  defp path_indexes(grid, line_length, current_index, previous_index \\ nil)

  defp path_indexes(grid, line_length, current_index, previous_index)
       when previous_index != nil do
    current_char = grid |> Enum.at(current_index)

    next_index =
      connected_indexes(current_char, current_index, line_length)
      |> Tuple.to_list()
      |> Enum.find(&(&1 != previous_index))

    cond do
      current_char == ?S ->
        []

      true ->
        [current_index | path_indexes(grid, line_length, next_index, current_index)]
    end
  end

  defp path_indexes(grid, current_index, line_length, nil) do
    # TODO does not work for a generic grid
    {_, next_index} =
      connected_indexes(?F, current_index, line_length)

    [current_index | path_indexes(grid, line_length, next_index, current_index)]
  end

  defp path_length(grid, line_length, current_index, previous_index \\ nil, step \\ 0)

  defp path_length(grid, line_length, current_index, previous_index, step) when step > 0 do
    current_char = grid |> Enum.at(current_index)

    next_index =
      connected_indexes(current_char, current_index, line_length)
      |> Tuple.to_list()
      |> Enum.find(&(&1 != previous_index))

    cond do
      current_char == ?S ->
        step

      true ->
        path_length(grid, line_length, next_index, current_index, step + 1)
    end
  end

  defp path_length(grid, current_index, line_length, nil, 0 = step) do
    # TODO does not work for a generic grid
    {_, next_index} =
      connected_indexes(?F, current_index, line_length)

    path_length(grid, line_length, next_index, current_index, step + 1)
  end

  defp connected_indexes(?|, current_index, line_length) do
    {current_index - line_length, current_index + line_length}
  end

  defp connected_indexes(?-, current_index, _) do
    {current_index - 1, current_index + 1}
  end

  defp connected_indexes(?L, current_index, line_length) do
    {current_index - line_length, current_index + 1}
  end

  defp connected_indexes(?J, current_index, line_length) do
    {current_index - line_length, current_index - 1}
  end

  defp connected_indexes(?7, current_index, line_length) do
    {current_index - 1, current_index + line_length}
  end

  defp connected_indexes(?F, current_index, line_length) do
    {current_index + 1, current_index + line_length}
  end

  defp connected_indexes(?., _, _) do
    {}
  end

  defp connected_indexes(?S, _, _) do
    {}
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

    single_line_input = input |> String.replace("\n", "") |> String.to_charlist()
    start_index = single_line_input |> Enum.find_index(&(&1 == ?S))

    {single_line_input, start_index, line_length, row_count}
  end
end
