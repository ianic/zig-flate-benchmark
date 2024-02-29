const std = @import("std");
const readArgs = @import("cases.zig").readArgs;
const deflate = @import("v1/deflate.zig");

const assert = std.debug.assert;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    if (readArgs() catch {
        std.process.exit(1);
    }) |opt| {
        const case = opt.case;
        var fbs = std.io.fixedBufferStream(case.data);
        const input = fbs.reader();

        var dcp = try deflate.decompressor(allocator, input, null);
        defer dcp.deinit();

        var n: usize = 0;
        const buffer_len = 1024 * 64;
        var buf: [buffer_len]u8 = undefined;
        while (true) {
            const i = dcp.read(&buf) catch 0;
            if (i == 0) break;
            n += i;
        }
        assert(n == case.bytes);
    }
}
