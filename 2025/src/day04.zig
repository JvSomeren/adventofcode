const std = @import("std");
const print = std.debug.print;

const day = "04";
const input = @embedFile("inputs/day" ++ day ++ ".txt");
const test_input = @embedFile("test_inputs/day" ++ day ++ ".txt");

const Grid = struct {
    col_count: usize,
    row_count: usize,
    inner: []u8,

    fn isWithin(self: Grid, x: isize, y: isize) bool {
        return x >= 0 and x < self.col_count and
            y >= 0 and y < self.row_count;
    }

    fn offsetFor(self: Grid, x: isize, y: isize) usize {
        const _x: usize = @intCast(x);
        const _y: usize = @intCast(y);

        return _x + _y * self.col_count;
    }

    fn get(self: Grid, x: isize, y: isize) u8 {
        return self.inner[self.offsetFor(x, y)];
    }

    fn set(self: *Grid, x: isize, y: isize, value: u8) void {
        self.inner[self.offsetFor(x, y)] = value;
    }
};

fn walkGrid(
    grid: *Grid,
    context: anytype,
    onAccessibleCell: *const fn (ctx: @TypeOf(context), x: isize, y: isize) void,
) !void {
    var y: isize = 0;
    while (y < grid.row_count) : (y += 1) {
        var x: isize = 0;
        check_cell: while (x < grid.col_count) : (x += 1) {
            if (grid.get(x, y) != '@') continue;

            var roll_count: usize = 0;

            var dy: isize = -1;
            while (dy <= 1) : (dy += 1) {
                var dx: isize = -1;
                while (dx <= 1) : (dx += 1) {
                    if (dx == 0 and dy == 0) continue;

                    const _y = y + dy;
                    const _x = x + dx;
                    if (grid.isWithin(_x, _y) and grid.get(_x, _y) != '.') {
                        roll_count += 1;

                        if (roll_count >= 4) continue :check_cell;
                    }
                }
            }

            onAccessibleCell(context, x, y);
        }
    }
}

fn part1(grid: *Grid) !usize {
    var accessible_roll_count: usize = 0;

    const addOne = struct {
        fn func(count: *usize, _: isize, _: isize) void {
            count.* += 1;
        }
    }.func;

    try walkGrid(grid, &accessible_roll_count, addOne);

    return accessible_roll_count;
}

fn part2(grid: *Grid) !usize {
    const State = struct {
        accessible_roll_count: usize,
        grid: *Grid,

        const Self = @This();

        fn addOne(self: *Self, x: isize, y: isize) void {
            self.accessible_roll_count += 1;

            self.grid.set(x, y, 'x');
        }
    };

    var total: usize = 0;
    while (true) {
        var state = State{
            .accessible_roll_count = 0,
            .grid = grid,
        };
        try walkGrid(grid, &state, State.addOne);

        if (state.accessible_roll_count == 0) break;

        total += state.accessible_roll_count;

        var y: isize = 0;
        while (y < grid.row_count) : (y += 1) {
            var x: isize = 0;
            while (x < grid.col_count) : (x += 1) {
                if (grid.get(x, y) == 'x') {
                    grid.set(x, y, '.');
                }
            }
        }
    }

    return total;
}

fn parse(comptime buffer: []const u8, allocator: std.mem.Allocator) !Grid {
    var row_it = std.mem.tokenizeScalar(u8, buffer, '\n');

    const col_count = row_it.peek().?.len;
    const row_count = buffer.len / (col_count + 1);

    const inner = try allocator.alloc(u8, col_count * row_count);

    var row_index: usize = 0;
    while (row_it.next()) |row| : (row_index += 1) {
        for (row, 0..) |char, col_index| {
            inner[row_index * col_count + col_index] = char;
        }
    }

    return .{
        .col_count = col_count,
        .row_count = row_count,
        .inner = inner,
    };
}

pub fn main() !void {
    print("Advent of Code - Day {s}\n", .{day});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var grid = try parse(input, allocator);
    defer allocator.free(grid.inner);

    print("Part 1: {d}\n", .{try part1(&grid)});
    print("Part 2: {d}\n", .{try part2(&grid)});
}

test part1 {
    var grid = try parse(test_input, std.testing.allocator);
    defer std.testing.allocator.free(grid.inner);

    try std.testing.expectEqual(13, try part1(&grid));
}

test part2 {
    var grid = try parse(test_input, std.testing.allocator);
    defer std.testing.allocator.free(grid.inner);

    try std.testing.expectEqual(43, try part2(&grid));
}
