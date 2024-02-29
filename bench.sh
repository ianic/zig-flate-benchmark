#!/bin/bash

# standard libraray version
zig build -Doptimize=ReleaseFast -p zig-out/std

# built with my changes
zig build -Doptimize=ReleaseFast -p zig-out/my --zig-lib-dir ~/zig/zig/lib

for i in {0..4}
do
    hyperfine -n std "zig-out/std/bin/inflate -i $i"  -n my "zig-out/my/bin/inflate -i $i"
done

# hyperfine --parameter-scan i 0 4 "zig-out/std/bin/inflate -i {i}" "zig-out/my/bin/inflate -i {i}"
