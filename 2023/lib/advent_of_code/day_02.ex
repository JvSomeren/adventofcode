defmodule AdventOfCode.Day02 do
  def part1(input) do
    input
    |> parse()
    |> Enum.filter(&filter_game_part1?/1)
    |> Enum.map(fn {game_id, _sets} -> game_id end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&minimal_bag_contents/1)
    |> Enum.map(fn bag -> Map.values(bag) |> Enum.product end)
    |> Enum.sum()
  end

  @empty_bag %{red: 0, green: 0, blue: 0}
  @full_bag %{red: 12, green: 13, blue: 14}

  defp filter_game_part1?({_game_id, sets}) do
    Enum.all?(sets, fn %{red: red, green: green, blue: blue} ->
      red <= @full_bag.red and green <= @full_bag.green and blue <= @full_bag.blue
    end)
  end

  defp minimal_bag_contents({_game_id, sets}) do
    sets
    |> Enum.reduce(@empty_bag, fn set, acc ->
      Map.merge(acc, set, fn _color, acc_value, set_value ->
        max(acc_value, set_value)
      end)
    end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_game/1)
  end

  defp parse_game(game) do
    ["Game " <> game_id, sets] = String.split(game, ": ")

    game_id = String.to_integer(game_id)

    sets =
      sets
      |> String.split("; ")
      |> Enum.map(&parse_sets/1)

    {game_id, sets}
  end

  defp parse_sets(set) do
    sets =
      set
      |> String.split(", ")
      |> Enum.map(fn x ->
        x
        |> String.split(" ")
        |> then(fn [count, color] ->
          {String.to_existing_atom(color), String.to_integer(count)}
        end)
      end)
      |> Map.new()

    Map.merge(@empty_bag, sets)
  end
end
