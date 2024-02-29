const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const binaries = [_]Binary{
        .{ .name = "inflate_bench", .src = "src/inflate_bench.zig" },
        .{ .name = "inflate_bench_v1", .src = "src/inflate_bench_v1.zig" },
        .{ .name = "gzip", .src = "src/gzip.zig" },
        .{ .name = "gunzip", .src = "src/gunzip.zig" },
        .{ .name = "inflate", .src = "src/inflate.zig" },
        .{ .name = "deflate", .src = "src/deflate.zig" },
    };
    for (binaries) |i| {
        const bin = b.addExecutable(.{
            .name = i.name,
            .root_source_file = .{ .path = i.src },
            .target = target,
            .optimize = optimize,
        });
        b.installArtifact(bin);
    }
}

const Binary = struct {
    name: []const u8,
    src: []const u8,
};
