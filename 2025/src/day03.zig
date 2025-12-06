const std = @import("std");
const print = std.debug.print;
const TokenIterator = std.mem.TokenIterator;
const DelimiterType = std.mem.DelimiterType;
const parseUnsigned = std.fmt.parseUnsigned;

const day = "03";
const input = @embedFile("inputs/day" ++ day ++ ".txt");
const test_input = @embedFile("test_inputs/day" ++ day ++ ".txt");

fn solver(
    it: *TokenIterator(u8, DelimiterType.scalar),
    bat_size: comptime_int,
) !usize {
    it.reset();

    var sum: usize = 0;

    while (it.next()) |row| {
        var batteries = [_]u8{0} ** bat_size;
        const len = row.len;

        for (row[0..], 0..) |value, index| {
            const rem = len - index;
            const start = bat_size -| rem;

            for (start..bat_size) |i| {
                if (value > batteries[i]) {
                    batteries[i] = value;

                    for (i + 1..bat_size) |j| {
                        batteries[j] = 48;
                    }

                    break;
                }
            }
        }

        const number = try parseUnsigned(usize, &batteries, 10);
        sum += number;
    }

    return sum;
}

fn part1(it: *TokenIterator(u8, DelimiterType.scalar)) !usize {
    return solver(it, 2);
}

fn part2(it: *TokenIterator(u8, DelimiterType.scalar)) !usize {
    return solver(it, 12);
}

fn parse(buffer: []const u8) TokenIterator(u8, DelimiterType.scalar) {
    return std.mem.tokenizeScalar(u8, buffer, '\n');
}

pub fn main() !void {
    print("Advent of Code - Day {s}\n", .{day});

    var it = parse(input);

    print("Part 1: {d}\n", .{try part1(&it)});
    print("Part 2: {d}\n", .{try part2(&it)});
}

test part1 {
    var it = parse(test_input);

    try std.testing.expectEqual(357, try part1(&it));
}

test part2 {
    var it = parse(test_input);

    try std.testing.expectEqual(3121910778619, try part2(&it));
}
