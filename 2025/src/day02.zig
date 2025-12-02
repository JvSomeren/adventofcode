const std = @import("std");
const print = std.debug.print;
const TokenIterator = std.mem.TokenIterator;
const DelimiterType = std.mem.DelimiterType;
const count = std.mem.count;

const day = "02";
const input = @embedFile("inputs/day" ++ day ++ ".txt");
const test_input = @embedFile("test_inputs/day" ++ day ++ ".txt");

fn walkRanges(
    ranges_it: *TokenIterator(u8, DelimiterType.scalar),
    shouldSum: *const fn (string: []u8) bool,
) !usize {
    ranges_it.reset();

    var sum: usize = 0;

    while (ranges_it.next()) |range| {
        const safe_range = std.mem.trimEnd(u8, range, "\n");

        var it = std.mem.splitScalar(u8, safe_range, '-');
        const lower, const upper = .{
            try std.fmt.parseInt(usize, it.next().?, 10),
            try std.fmt.parseInt(usize, it.next().?, 10),
        };

        var buffer: [20]u8 = undefined;
        for (lower..upper + 1) |value| {
            const string = try std.fmt.bufPrint(&buffer, "{}", .{value});

            if (shouldSum(string)) sum += value;
        }
    }

    return sum;
}

fn part1(it: *TokenIterator(u8, DelimiterType.scalar)) !usize {
    it.reset();

    const shouldSum = struct {
        fn f(string: []u8) bool {
            if (string.len % 2 != 0) return false;

            return std.mem.eql(u8, string[0 .. string.len / 2], string[string.len / 2 ..]);
        }
    }.f;

    return walkRanges(it, shouldSum);
}

fn part2(it: *TokenIterator(u8, DelimiterType.scalar)) !usize {
    it.reset();

    const shouldSum = struct {
        fn f(string: []u8) bool {
            for (1..string.len / 2 + 1) |i| {
                const partial_string = string[0..i];
                if (string.len % partial_string.len != 0) continue;

                const expected_count = string.len / partial_string.len;
                if (count(u8, string, partial_string) == expected_count) return true;
            }

            return false;
        }
    }.f;

    return walkRanges(it, shouldSum);
}

fn parse(buffer: []const u8) TokenIterator(u8, DelimiterType.scalar) {
    return std.mem.tokenizeScalar(u8, buffer, ',');
}

pub fn main() !void {
    print("Advent of Code - Day 02\n", .{});

    var it = parse(input);

    print("Part 1: {d}\n", .{try part1(&it)});
    print("Part 2: {d}\n", .{try part2(&it)});
}

test part1 {
    var it = parse(test_input);

    try std.testing.expectEqual(1227775554, try part1(&it));
}

test part2 {
    var it = parse(test_input);

    try std.testing.expectEqual(4174379265, try part2(&it));
}
