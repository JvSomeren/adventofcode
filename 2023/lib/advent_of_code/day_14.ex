defmodule AdventOfCode.Day14 do
  @type grid :: [[]]
  @type direction :: :north | :east | :south | :west
  @type state :: {direction(), grid()}

  def part1(input) do
    input
    |> parse()
    |> rotate_ccw()
    |> tilt()
    |> rotate_cw()
    |> calculate_load()
  end

  def part2(input) do
    grid =
      input
      |> parse()
      |> rotate_ccw()

    # cycle grid until we find a duplicate state
    {grid, cycle, length} =
      0..(1_000_000_000 - 1)
      |> Enum.reduce_while({grid, %{}}, fn cycle, {grid, cache} ->
        cache_key = grid |> Enum.join()

        if Map.has_key?(cache, cache_key) do
          {:halt, {grid, cycle, cycle - Map.get(cache, cache_key)}}
        else
          grid =
            grid
            # north
            |> tilt()
            |> rotate_cw()
            # west
            |> tilt()
            |> rotate_cw()
            # south
            |> tilt()
            |> rotate_cw()
            # east
            |> tilt()
            |> rotate_cw()

          cache = Map.put(cache, cache_key, cycle)

          {:cont, {grid, cache}}
        end
      end)

    # cycle grid for the remaining cycles
    0..(rem(1_000_000_000 - cycle, length) - 1)
    |> Enum.reduce(grid, fn _, grid ->
      grid
      |> tilt()
      |> rotate_cw()
      |> tilt()
      |> rotate_cw()
      |> tilt()
      |> rotate_cw()
      |> tilt()
      |> rotate_cw()
    end)
    |> rotate_cw()
    |> calculate_load()
  end

  @spec tilt(grid()) :: grid()
  defp tilt(grid), do: grid |> Enum.map(&tilt_row/1)

  defp reduce_row_fn(?., {acc, stack}), do: {acc ++ [?.], stack}
  defp reduce_row_fn(?O, {acc, stack}), do: {acc, stack ++ [?O]}
  defp reduce_row_fn(?#, {acc, stack}), do: {acc ++ stack ++ [?#], []}

  defp tilt_row(row) do
    row
    |> Enum.reverse()
    |> Enum.reduce({[], []}, &reduce_row_fn/2)
    |> then(fn {acc, stack} -> acc ++ stack end)
    |> Enum.reverse()
  end

  @spec calculate_load(grid()) :: non_neg_integer()
  defp calculate_load(grid) do
    grid
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, &calculate_row_load/2)
  end

  defp calculate_row_load({row, load_per_rock}, total_load) do
    row
    |> Enum.count(&(&1 == ?O))
    |> Kernel.*(load_per_rock)
    |> Kernel.+(total_load)
  end

  @spec rotate_ccw(grid()) :: grid()
  defp rotate_ccw(grid), do: grid |> Enum.map(&Enum.reverse/1) |> transpose()

  @spec rotate_cw(grid()) :: grid()
  defp rotate_cw(grid), do: grid |> transpose() |> Enum.map(&Enum.reverse/1)

  @spec transpose(grid()) :: grid()
  defp transpose(grid), do: grid |> Enum.zip_with(&Function.identity/1)

  @spec parse(binary()) :: grid()
  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end
end
