defmodule AdventOfCode.Day15 do
  def part1(input) do
    input
    |> parse()
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.reduce(%{}, &hashmap/2)
    |> Enum.flat_map(&box_power/1)
    |> Enum.sum()
  end

  defp hashmap(instruction, boxes) do
    instruction
    |> String.split(["=", "-"], trim: true)
    |> do_operation(boxes)
  end

  defp box_power({box_number, lenses}) do
    lenses
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {{_, focal_length}, index} -> (box_number + 1) * index * focal_length end)
  end

  # handles `-` operations
  defp do_operation([label], boxes) do
    target_box = hash(label)

    boxes
    |> Map.get_and_update(target_box, fn
      nil ->
        {nil, []}

      list ->
        {list, Enum.filter(list, fn {l, _} -> l != label end)}
    end)
    |> elem(1)
  end

  # handles `=` operations
  defp do_operation([label, focal_length], boxes) do
    target_box = hash(label)
    focal_length = focal_length |> String.to_integer()
    lens = {label, focal_length}

    boxes
    |> Map.get_and_update(target_box, fn
      nil ->
        {nil, [lens]}

      list ->
        index = list |> Enum.find_index(fn {l, _} -> l == label end)

        case index do
          nil -> {list, [lens | list]}
          _ -> {list, List.replace_at(list, index, lens)}
        end
    end)
    |> elem(1)
  end

  defp hash(string, value \\ 0)

  defp hash("", value), do: value

  defp hash(<<char::utf8, rest::binary>>, value) do
    value
    |> Kernel.+(char)
    |> Kernel.*(17)
    |> rem(256)
    |> then(&hash(rest, &1))
  end

  defp parse(input), do: input |> String.replace("\n", "") |> String.split(",")
end
