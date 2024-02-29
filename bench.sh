#!/bin/bash -e

cd "$(dirname "$0")"

# standard libraray version
zig build -Doptimize=ReleaseFast -p zig-out/std

# built with my changes
zig build -Doptimize=ReleaseFast -p zig-out/my --zig-lib-dir ~/zig/zig/lib

mkdir -p tmp
rm tmp/*.expected tmp/*.actual

echo "compare inflate output"
for f in src/bench_data/*.flate; do
    echo -e "\t$f"

    expected=tmp/$(basename $f.expected)
    actual=tmp/$(basename $f.actual)

    zig-out/std/bin/inflate $f $expected
    zig-out/my/bin/inflate $f $actual

    cmp $expected $actual
done


for i in {0..4}
do
    echo
    hyperfine -w 1 -n std "zig-out/std/bin/inflate_bench -i $i"  -n my "zig-out/my/bin/inflate_bench -i $i"
done

# hyperfine --parameter-scan i 0 4 "zig-out/std/bin/inflate -i {i}" "zig-out/my/bin/inflate -i {i}"
