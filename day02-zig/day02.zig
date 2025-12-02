const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, 1024);
    defer allocator.free(input);

    const result1 = try part1(input);
    try stdout.print("Day 02 part 1: {d}\n", .{result1}); // 41294979841

    // const result2 = try part2(input);
    // try stdout.print("Day 02 part 2: {d}\n", .{result2});
}

fn part1(input: []const u8) !u64 {
    var sum: u64 = 0;

    // For each comma-separated substring.
    var iter = std.mem.splitScalar(u8, std.mem.trimRight(u8, input, "\n"), ',');
    while (iter.next()) |substring| {
        // Parse the substring on the format "123-234"
        var hyphen_iter = std.mem.splitScalar(u8, substring, '-');
        const from_str = hyphen_iter.next() orelse return error.InvalidFormat;
        const to_str = hyphen_iter.next() orelse return error.InvalidFormat;
        const from = try std.fmt.parseInt(u64, from_str, 10);
        const to = try std.fmt.parseInt(u64, to_str, 10);
        sum += sumInvalid(from, to);
    }

    return sum;
}

fn sumInvalid(from: u64, to: u64) u64 {
    const log10_from = std.math.log10_int(from);
    var half_num: u64 = if (log10_from % 2 == 1)
        from / std.math.pow(u64, 10, (log10_from + 1) / 2)
    else
        std.math.pow(u64, 10, log10_from / 2);

    var sum: u64 = 0;
    while (true) {
        const full_num = half_num + half_num * std.math.pow(u64, 10, std.math.log10_int(half_num) + 1);
        if (full_num > to) return sum;
        if (full_num >= from) sum += full_num;
        half_num += 1;
    }
}
