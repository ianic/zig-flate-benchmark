const std = @import("std");
const readArgs = @import("cases.zig").readArgs;

const assert = std.debug.assert;

pub fn main() !void {
    if (readArgs() catch {
        std.process.exit(1);
    }) |opt| {
        const case = opt.case;
        var fbs = std.io.fixedBufferStream(case.data);
        const input = fbs.reader();

        var cw = std.io.countingWriter(std.io.null_writer);
        try std.compress.flate.decompress(input, cw.writer());

        assert(cw.bytes_written == case.bytes);
    }
}
