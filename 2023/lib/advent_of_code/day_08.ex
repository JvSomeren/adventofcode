defmodule AdventOfCode.Day08 do
  @start_node "AAA"
  @end_node "ZZZ"

  def part1(input) do
    {instructions, node_map} =
      input
      |> parse()

    instructions
    |> Stream.cycle()
    |> Enum.reduce_while({0, @start_node}, fn instruction, {step_count, node} ->
      next_node_index = if instruction === ?L, do: 0, else: 1

      cond do
        node === @end_node -> {:halt, step_count}
        true -> {:cont, {step_count + 1, node_map[node] |> elem(next_node_index)}}
      end
    end)
  end

  def part2(input) do
    {instructions, node_map} =
      input
      |> parse()

    node_map
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    # find step_count to end node for each starting node
    |> Enum.map(fn node ->
      instructions
      |> Stream.cycle()
      |> Enum.reduce_while({0, node}, fn instruction, {step_count, node} ->
        next_node_index = if instruction === ?L, do: 0, else: 1

        cond do
          String.ends_with?(node, "Z") -> {:halt, step_count}
          true -> {:cont, {step_count + 1, node_map[node] |> elem(next_node_index)}}
        end
      end)
    end)
    |> Enum.reduce(1, &lcm(&1, &2))
  end

  defp lcm(a, b), do: (a * b) |> div(Integer.gcd(a, b))

  defp parse(input) do
    [instructions, nodes] =
      input
      |> String.split("\n\n", trim: true)

    nodes =
      nodes
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn line, acc ->
        [node, references] =
          line
          |> String.split(" = ")

        references =
          references
          |> String.trim("(")
          |> String.trim(")")
          |> String.split(", ")
          |> List.to_tuple()

        put_in(acc, [node], references)
      end)

    {String.to_charlist(instructions), nodes}
  end
end
