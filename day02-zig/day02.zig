const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var buffer: [1024]u8 = undefined;
    const len = try stdin.readAll(&buffer);
    const input = buffer[0..len];

    const answer1 = try sumInvalidIDs(input, false);
    try stdout.print("Day 02 part 1: {d}\n", .{answer1}); // 41294979841

    const answer2 = try sumInvalidIDs(input, true);
    try stdout.print("Day 02 part 2: {d}\n", .{answer2}); // 66500947346
}

fn sumInvalidIDs(input: []const u8, check_multiple_reps: bool) !u64 {
    var sum: u64 = 0;

    // For each comma-separated substring.
    var iter = std.mem.splitScalar(u8, std.mem.trimRight(u8, input, "\n"), ',');
    while (iter.next()) |substring| {
        // Parse the substring on the format "123-234".
        var hyphen_iter = std.mem.splitScalar(u8, substring, '-');
        const from_str = hyphen_iter.next() orelse return error.InvalidFormat;
        const to_str = hyphen_iter.next() orelse return error.InvalidFormat;
        const from = try std.fmt.parseInt(u64, from_str, 10);
        const to = try std.fmt.parseInt(u64, to_str, 10);

        // For each value in the range, add it to the sum if it has a repeating pattern.
        for (from..to + 1) |id| {
            var buffer: [20]u8 = undefined;
            const id_str = std.fmt.bufPrint(&buffer, "{d}", .{id}) catch unreachable;
            if (hasRepeatingPattern(id_str, check_multiple_reps)) sum += id;
        }
    }

    return sum;
}

fn hasRepeatingPattern(id: []const u8, check_multiple_reps: bool) bool {
    const max_reps = if (check_multiple_reps) id.len else 2;

    outer: for (2..max_reps + 1) |reps| {
        if (id.len % reps != 0) continue;
        const pattern_len = id.len / reps;

        // Compare each subsequent chunk with the first chunk.
        const first_chunk = id[0..pattern_len];
        for (1..reps) |rep| {
            const chunk = id[rep * pattern_len .. (rep + 1) * pattern_len];
            if (!std.mem.eql(u8, first_chunk, chunk)) continue :outer;
        }
        return true;
    }

    return false;
}
