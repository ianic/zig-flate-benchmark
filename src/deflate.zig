const std = @import("std");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const args = try std.process.argsAlloc(arena);
    if (args.len <= 2) {
        usageAndExit(std.io.getStdErr(), args[0], 1);
    }

    var input_file = try std.fs.cwd().openFile(args[1], .{});
    defer input_file.close();

    var output_file = try std.fs.cwd().createFile(args[2], .{ .truncate = true });
    defer output_file.close();

    var br = std.io.bufferedReader(input_file.reader());
    try std.compress.flate.compress(br.reader(), output_file.writer(), .{});
}

fn usageAndExit(file: std.fs.File, arg0: []const u8, code: u8) noreturn {
    file.writer().print(
        \\Usage: {s} [input file path] [output file path]
        \\
    , .{arg0}) catch std.process.exit(1);
    std.process.exit(code);
}
