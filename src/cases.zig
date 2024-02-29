const std = @import("std");
const print = std.debug.print;

const Case = struct {
    data: []const u8,
    bytes: usize,
};

pub const cases = [_]Case{
    .{
        .data = @embedFile("bench_data/ziglang.tar.flate"),
        .bytes = 177244160,
    },
    .{
        .data = @embedFile("bench_data/war_and_peace.txt.flate"),
        .bytes = 3359630,
    },
    .{
        .data = @embedFile("bench_data/large.tar.flate"),
        .bytes = 11162624,
    },
    .{
        .data = @embedFile("bench_data/cantrbry.tar.flate"),
        .bytes = 2821120,
    },
    .{
        .data = @embedFile("bench_data/empty.flate"),
        .bytes = 1073741824,
    },
    .{
        .data = @embedFile("bench_data/images.tar.flate"),
        .bytes = 16711680,
    },
};

const Options = struct {
    input_index: u8 = 0,
    case: Case = undefined,
};

pub fn readArgs() !?Options {
    var args = std.process.args();
    const prog_name = args.next().?;

    var opt: Options = .{};
    while (args.next()) |a| {
        if (std.mem.eql(u8, a, "-i")) {
            if (args.next()) |i| {
                opt.input_index = std.fmt.parseInt(u8, i, 10) catch {
                    print("Unable to parse {s} as integer!", .{i});
                    return error.InvalidArgs;
                };
                if (opt.input_index >= cases.len) {
                    print("Input data index must be in range 0-{d}!\n", .{cases.len - 1});
                    return error.InvalidArgs;
                }
                opt.case = cases[opt.input_index];
            } else {
                print("Missing input case no -i option!\n", .{});
                return error.InvalidArgs;
            }
            continue;
        }

        if (std.mem.eql(u8, a, "--help") or std.mem.eql(u8, a, "-h")) {
            usage(prog_name);
            return null;
        }
        //        if (a[0] == '-') {
        print("Unknown argument {s}!\n", .{a});
        return error.InvalidArgs;
    }
    return opt;
}

fn usage(prog_name: []const u8) void {
    std.debug.print(
        \\{s} [options]
        \\
        \\Options:
        \\  -i [0-5]     use one of the test cases, default 0
        \\  -h           show this help
        \\
    , .{prog_name});
}
