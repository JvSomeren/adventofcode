defmodule AdventOfCode.Day04 do
  def part1(input) do
    input
    |> parse()
    |> Enum.map(fn card ->
      card
      |> matching_numbers()
      |> Enum.count()
      |> calculate_card_value()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    cards =
      input
      |> parse()

    card_counts = List.duplicate(1, Enum.count(cards))

    cards
    |> Enum.map(&(&1 |> matching_numbers() |> Enum.count()))
    |> Stream.with_index()
    |> Enum.reduce(card_counts, &determine_copies/2)
    |> Enum.sum()
  end

  defp determine_copies({matching_numbers_count, _index}, acc) when matching_numbers_count == 0 do
    acc
  end

  defp determine_copies({matching_numbers_count, index}, acc) do
    card_copy_count = Enum.at(acc, index)

    range = Range.new(index + 1, index + matching_numbers_count)

    Enum.reduce(range, acc, &List.update_at(&2, &1, fn count -> count + card_copy_count end))
  end

  defp calculate_card_value(number_count) when number_count == 0 do
    0
  end

  defp calculate_card_value(number_count) do
    2 ** (number_count - 1)
  end

  defp matching_numbers(card) do
    MapSet.intersection(
      Map.get(card, :winning_numbers),
      Map.get(card, :personal_numbers)
    )
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_card/1)
  end

  defp parse_card(line) do
    ["Card " <> game_id, numbers] = String.split(line, ":", trim: true)

    [winning_numbers, personal_numbers] =
      String.split(numbers, "|", trim: true)
      |> Enum.map(&parse_numbers/1)

    %{
      game_id: game_id |> String.trim() |> String.to_integer(),
      winning_numbers: winning_numbers,
      personal_numbers: personal_numbers
    }
  end

  defp parse_numbers(numbers_string) do
    numbers_string
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new()
  end
end
