defmodule AdventOfCode.Day09 do
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&sequence_to_diff_sequences/1)
    |> Enum.map(&determine_next_value_in_sequence/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&sequence_to_diff_sequences/1)
    |> Enum.map(&determine_previous_value_in_sequence/1)
    |> Enum.sum()
  end

  @spec determine_previous_value_in_sequence([[non_neg_integer()]]) :: non_neg_integer()
  defp determine_previous_value_in_sequence(sequences) do
    sequences
    |> Enum.map(&List.first/1)
    |> Enum.reverse()
    |> extrapolate_backwards()
  end

  defp extrapolate_backwards([result]), do: result

  defp extrapolate_backwards([a, b | tail]) do
    extrapolate_backwards([b - a | tail])
  end

  @spec determine_next_value_in_sequence([[non_neg_integer()]]) :: non_neg_integer()
  defp determine_next_value_in_sequence(sequences) do
    sequences
    |> Enum.map(&List.last/1)
    |> Enum.sum()
  end

  @spec sequence_to_diff_sequences([non_neg_integer()]) :: [[non_neg_integer()]]
  defp sequence_to_diff_sequences(sequence, acc \\ []) do
    acc = Enum.concat(acc, [sequence])
    sequence_diff = sequence_diff(sequence)

    is_finished = sequence_diff |> Enum.all?(&(&1 == 0))

    if is_finished,
      do: Enum.concat(acc, [sequence_diff]),
      else: sequence_to_diff_sequences(sequence_diff, acc)
  end

  defp sequence_diff([_]), do: []

  defp sequence_diff([a, b | tail]) do
    [b - a | sequence_diff([b | tail])]
  end

  @spec parse(String.t()) :: [[non_neg_integer()]]
  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line), do: line |> String.split() |> Enum.map(&String.to_integer/1)
end
