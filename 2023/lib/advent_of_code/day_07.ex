defmodule AdventOfCode.Day07 do
  alias AdventOfCode.Day07.Hand

  def part1(input) do
    input
    |> parse()
    |> Enum.sort_by(&elem(&1, 0), {:desc, Hand})
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse(true)
    |> Enum.sort_by(&elem(&1, 0), {:desc, Hand})
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, bid}, rank} -> bid * rank end)
    |> Enum.sum()
  end

  defp parse(input, uses_jokers \\ false) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line(&1, uses_jokers))
  end

  defp parse_line(line, uses_jokers) do
    [hand, bid] =
      line
      |> String.split()

    {
      Hand.new(hand, uses_jokers),
      String.to_integer(bid)
    }
  end
end

defmodule AdventOfCode.Day07.Hand do
  @enforce_keys [:cards, :type, :uses_jokers]
  defstruct cards: nil, type: nil, uses_jokers: nil

  @type hand_type ::
          :five_of_a_kind
          | :four_of_a_kind
          | :full_house
          | :three_of_a_kind
          | :two_pair
          | :one_pair
          | :high_card
  @type t :: %__MODULE__{cards: charlist, type: hand_type, uses_jokers: boolean}
  @type t(cards) :: %__MODULE__{cards: cards, type: hand_type, uses_jokers: boolean}

  @hand_types [
    :five_of_a_kind,
    :four_of_a_kind,
    :full_house,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card
  ]

  @ranks_default ~c"AKQJT98765432"
  @ranks_jokers ~c"AKQT98765432J"

  @spec new(bitstring, boolean) :: t
  def new(cards, uses_jokers \\ false) when is_bitstring(cards) and byte_size(cards) == 5 do
    cards = String.to_charlist(cards)
    type = cards_to_hand_type(cards, uses_jokers)

    %AdventOfCode.Day07.Hand{cards: cards, type: type, uses_jokers: uses_jokers}
  end

  defp cards_to_hand_type(hand, false) do
    hand
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> freq_to_hand_type()
  end

  defp cards_to_hand_type(hand, true) do
    hand
    |> Enum.frequencies()
    |> card_frequencies_to_hand_type()
  end

  defp card_frequencies_to_hand_type(%{?J => 5}), do: :five_of_a_kind
  defp card_frequencies_to_hand_type(%{?J => 4}), do: :five_of_a_kind

  defp card_frequencies_to_hand_type(%{?J => joker_count} = frequencies) when joker_count > 0 do
    frequencies
    |> Map.split([?J])
    |> elem(1)
    |> Map.values()
    |> Enum.sort(:desc)
    |> then(&freq_with_jokers_to_hand_type(joker_count, &1))
  end

  defp card_frequencies_to_hand_type(frequencies) do
    frequencies
    |> Map.values()
    |> Enum.sort(:desc)
    |> freq_to_hand_type()
  end

  defp freq_with_jokers_to_hand_type(3, [2]), do: :five_of_a_kind
  defp freq_with_jokers_to_hand_type(3, [1, 1]), do: :four_of_a_kind

  defp freq_with_jokers_to_hand_type(2, [3]), do: :five_of_a_kind
  defp freq_with_jokers_to_hand_type(2, [2, 1]), do: :four_of_a_kind
  defp freq_with_jokers_to_hand_type(2, [1, 1, 1]), do: :three_of_a_kind

  defp freq_with_jokers_to_hand_type(1, [4]), do: :five_of_a_kind
  defp freq_with_jokers_to_hand_type(1, [3, 1]), do: :four_of_a_kind
  defp freq_with_jokers_to_hand_type(1, [2, 2]), do: :full_house
  defp freq_with_jokers_to_hand_type(1, [2, 1, 1]), do: :three_of_a_kind
  defp freq_with_jokers_to_hand_type(1, [1, 1, 1, 1]), do: :one_pair

  defp freq_to_hand_type([5]), do: :five_of_a_kind
  defp freq_to_hand_type([4, 1]), do: :four_of_a_kind
  defp freq_to_hand_type([3, 2]), do: :full_house
  defp freq_to_hand_type([3 | _]), do: :three_of_a_kind
  defp freq_to_hand_type([2, 2, _]), do: :two_pair
  defp freq_to_hand_type([2 | _]), do: :one_pair
  defp freq_to_hand_type(_), do: :high_card

  # exactly the same
  @spec compare(t, t) :: :lt | :eq | :gt
  def compare(%{cards: cards1}, %{cards: cards2})
      when cards1 === cards2 do
    :eq
  end

  # same hand type, different cards
  def compare(%{cards: cards1, type: type1, uses_jokers: uses_jokers}, %{
        cards: cards2,
        type: type2
      })
      when type1 === type2 do
    Enum.zip(cards1, cards2)
    |> Enum.reduce_while(:eq, fn {card1, card2}, acc ->
      [card1, card2]
      |> Enum.map(fn card ->
        ranks = if uses_jokers, do: @ranks_jokers, else: @ranks_default

        ranks
        |> Enum.find_index(&(&1 === card))
      end)
      |> then(fn [card1, card2] ->
        cond do
          card1 === card2 -> {:cont, acc}
          card1 < card2 -> {:halt, :lt}
          true -> {:halt, :gt}
        end
      end)
    end)
  end

  # different hand types
  def compare(%{type: type1}, %{type: type2}) do
    compare_hand_type(type1, type2)
  end

  @spec compare(hand_type(), hand_type()) :: :lt | :eq | :gt
  defp compare_hand_type(type1, type2) when type1 === type2, do: :eq

  defp compare_hand_type(type1, type2) do
    [type1, type2]
    |> Enum.map(fn type ->
      @hand_types
      |> Enum.find_index(&(&1 === type))
    end)
    |> then(fn [type1, type2] ->
      if type1 < type2, do: :lt, else: :gt
    end)
  end
end
