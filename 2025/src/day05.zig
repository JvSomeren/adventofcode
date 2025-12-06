const std = @import("std");
const print = std.debug.print;
const parseUnsigned = std.fmt.parseUnsigned;

const day = "05";
const input = @embedFile("inputs/day" ++ day ++ ".txt");
const test_input = @embedFile("test_inputs/day" ++ day ++ ".txt");

const Range = struct {
    lower: usize,
    upper: usize,

    fn inRange(self: Range, value: usize) bool {
        return self.lower <= value and value <= self.upper;
    }

    fn size(self: Range) usize {
        return self.upper - self.lower + 1;
    }

    fn overlapsOrAdjacent(self: Range, other: Range) bool {
        return !(self.upper + 1 < other.lower or other.upper + 1 < self.lower);
    }

    fn merge(self: Range, other: Range) Range {
        return Range{
            .lower = @min(self.lower, other.lower),
            .upper = @max(self.upper, other.upper),
        };
    }

    fn lessThan(_: void, a: Range, b: Range) bool {
        return a.lower < b.lower;
    }
};

const State = struct {
    ranges: []const Range,
    ingredients: []const usize,
    fn inAnyRange(self: State, value: usize) bool {
        return for (self.ranges) |range| {
            if (range.inRange(value)) break true;
        } else false;
    }
};

fn part1(state: State) !usize {
    var count: usize = 0;
    for (state.ingredients) |ingredient| {
        if (state.inAnyRange(ingredient)) count += 1;
    }

    return count;
}

fn part2(allocator: std.mem.Allocator, state: State) !usize {
    const ranges = try allocator.dupe(Range, state.ranges);
    defer allocator.free(ranges);

    std.mem.sort(Range, ranges, {}, Range.lessThan);

    var merged = try std.ArrayList(Range).initCapacity(
        allocator,
        state.ranges.len,
    );
    defer merged.deinit(allocator);

    try merged.append(allocator, ranges[0]);

    for (ranges[1..]) |range| {
        var last = &merged.items[merged.items.len - 1];

        if (last.overlapsOrAdjacent(range)) {
            last.* = last.merge(range);
        } else {
            try merged.append(allocator, range);
        }
    }

    var count: usize = 0;
    for (merged.items) |range| {
        count += range.size();
    }

    return count;
}

fn parse(allocator: std.mem.Allocator, buffer: []const u8) !State {
    var split_it = std.mem.splitSequence(u8, buffer, "\n\n");
    const rs, const is = .{ split_it.next().?, split_it.next().? };

    var ranges_list = try std.ArrayList(Range).initCapacity(allocator, 50);
    var range_it = std.mem.tokenizeScalar(u8, rs, '\n');
    while (range_it.next()) |range| {
        var split = std.mem.splitScalar(u8, range, '-');
        const r = Range{
            .lower = try parseUnsigned(usize, split.next().?, 10),
            .upper = try parseUnsigned(usize, split.next().?, 10),
        };
        try ranges_list.append(allocator, r);
    }

    var ingredients_list = try std.ArrayList(usize).initCapacity(
        allocator,
        100,
    );
    var ingredient_it = std.mem.tokenizeScalar(u8, is, '\n');
    while (ingredient_it.next()) |ingredient| {
        try ingredients_list.append(
            allocator,
            try parseUnsigned(usize, ingredient, 10),
        );
    }

    return State{
        .ranges = try ranges_list.toOwnedSlice(allocator),
        .ingredients = try ingredients_list.toOwnedSlice(allocator),
    };
}

pub fn main() !void {
    print("Advent of Code - Day {s}\n", .{day});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const state = try parse(allocator, input);
    defer allocator.free(state.ranges);
    defer allocator.free(state.ingredients);

    print("Part 1: {d}\n", .{try part1(state)});
    print("Part 2: {d}\n", .{try part2(allocator, state)});
}

test part1 {
    const state = try parse(std.testing.allocator, test_input);
    defer std.testing.allocator.free(state.ranges);
    defer std.testing.allocator.free(state.ingredients);

    try std.testing.expectEqual(3, try part1(state));
}

test part2 {
    const state = try parse(std.testing.allocator, test_input);
    defer std.testing.allocator.free(state.ranges);
    defer std.testing.allocator.free(state.ingredients);

    try std.testing.expectEqual(
        14,
        try part2(std.testing.allocator, state),
    );
}

test Range {
    const range = Range{
        .lower = 5,
        .upper = 10,
    };

    try std.testing.expect(range.inRange(5));
    try std.testing.expect(range.inRange(10));
    try std.testing.expectEqual(false, range.inRange(11));

    try std.testing.expectEqual(6, range.size());

    try std.testing.expect(range.overlapsOrAdjacent(Range{ .lower = 9, .upper = 13 }));
    try std.testing.expect(range.overlapsOrAdjacent(Range{ .lower = 10, .upper = 13 }));
    try std.testing.expect(range.overlapsOrAdjacent(Range{ .lower = 11, .upper = 13 }));
    try std.testing.expectEqual(false, range.overlapsOrAdjacent(Range{
        .lower = 12,
        .upper = 13,
    }));

    try std.testing.expectEqual(Range{
        .lower = 5,
        .upper = 13,
    }, range.merge(Range{
        .lower = 9,
        .upper = 13,
    }));
}

test State {
    const state = State{
        .ranges = &[_]Range{
            Range{
                .lower = 5,
                .upper = 10,
            },
            Range{
                .lower = 2,
                .upper = 3,
            },
        },
        .ingredients = &[_]usize{ 2, 5, 10, 12 },
    };

    var count: usize = 0;
    for (state.ingredients) |ingredient| {
        if (state.inAnyRange(ingredient)) count += 1;
    }

    try std.testing.expectEqual(3, count);
}
