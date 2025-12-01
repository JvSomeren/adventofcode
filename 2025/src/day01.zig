const std = @import("std");
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
const ArrayList = std.ArrayList;
const AutoHashMap = std.AutoHashMap;
const TokenIterator = std.mem.TokenIterator;

const input = @embedFile("inputs/day01.txt");
const test_input = @embedFile("test_inputs/day01.txt");

fn part1(it: *TokenIterator(u8, std.mem.DelimiterType.scalar)) !u16 {
    it.reset();

    var zeroes: u16 = 0;
    var dial: i16 = 50;

    while (it.next()) |token| {
        const rotation = try std.fmt.parseInt(i16, token[1..], 10);
        const delta = if (token[0] == 'L') -rotation else rotation;

        dial = @mod((dial + delta), 100);

        if (dial == 0) zeroes += 1;
    }

    return zeroes;
}

fn part2(it: *TokenIterator(u8, std.mem.DelimiterType.scalar)) !i16 {
    it.reset();

    var zeroes: i16 = 0;
    var dial: i16 = 50;

    while (it.next()) |token| {
        const fullRotation = try std.fmt.parseInt(i16, token[1..], 10);

        // full rotations
        zeroes += @divTrunc(fullRotation, 100);

        const rotation = @mod(fullRotation, 100);
        if (rotation == 0) continue;

        const delta = if (token[0] == 'L') -rotation else rotation;
        const d = dial + delta;
        if (dial != 0 and (d <= 0 or d >= 100)) zeroes += 1;
        dial = @mod(d, 100);
    }

    return zeroes;
}

fn parse(buffer: []const u8) TokenIterator(u8, std.mem.DelimiterType.scalar) {
    return std.mem.tokenizeScalar(u8, buffer, '\n');
}

pub fn main() !void {
    std.debug.print("Advent of Code - Day 01\n", .{});

    var it = parse(input);

    std.debug.print("Part 1: {d}\n", .{try part1(&it)});
    std.debug.print("Part 2: {d}\n", .{try part2(&it)}); // too high: 6706 | Goal: 6695 | too low: 6689
}

test "part1" {
    var it = parse(test_input);

    try std.testing.expectEqual(3, try part1(&it));
}

test "part2" {
    var it = parse(test_input);

    try std.testing.expectEqual(6, try part2(&it));
}
