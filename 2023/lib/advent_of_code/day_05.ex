defmodule AdventOfCode.Day05 do
  def part1(input) do
    map =
      input
      |> parse()

    map_fn = fn f, {index, key} ->
      %{map: m, to: to} = map[key]

      new_index =
        Enum.find_value(m, index, fn x ->
          if index in x[:source], do: index + x[:diff]
        end)

      if to == :location do
        new_index
      else
        f.(f, {new_index, to})
      end
    end

    map[:seeds][:map]
    |> List.flatten()
    |> Enum.map(&{&1, :seed})
    |> Enum.map(&map_fn.(map_fn, &1))
    |> Enum.min()
  end

  def part2(_input) do
  end

  defp parse(input) do
    # group | content
    #   1   | from || seeds
    #   2   | to?
    #   3   | values
    ~r/(\w+)(?:-to-(\w+) map)?:([0-9 \-\n]+)/
    |> Regex.scan(input)
    |> Enum.reduce(%{}, fn match, acc ->
      case match do
        [_, seeds, to, values] when to == "" ->
          # use "seed" for `to` value
          Map.put(acc, String.to_atom(seeds), parse_map("seed", values))

        [_, from, to, values] ->
          Map.put(acc, String.to_atom(from), parse_map(to, values))
      end
    end)
  end

  defp parse_map(to, values) do
    values
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn x ->
      if to == "seed" do
        x
      else
        [dest_start, source_start, range_length] = x

        %{
          dest: dest_start..(dest_start + range_length - 1),
          source: source_start..(source_start + range_length - 1),
          diff: dest_start - source_start
        }
      end
    end)
    |> then(&%{to: String.to_atom(to), map: &1})
  end
end
