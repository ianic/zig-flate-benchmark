#!/bin/bash -e

cd "$(dirname "$0")"

zig_lib_dir=${1:-~/zig/zig/lib}

# standard libraray version
zig build -Doptimize=ReleaseFast -p zig-out/std

# built with my changes
echo using std lib from $zig_lib_dir
zig build -Doptimize=ReleaseFast -p zig-out/my --zig-lib-dir $zig_lib_dir

# mkdir -p tmp
# rm tmp/*.expected tmp/*.actual

# echo "compare inflate output"
# for f in src/bench_data/*.flate; do
#     echo -e "\t$f"

#     expected=tmp/$(basename $f.expected)
#     actual=tmp/$(basename $f.actual)

#     zig-out/std/bin/inflate $f $expected
#     zig-out/my/bin/inflate $f $actual

#     cmp $expected $actual
# done


for i in {0..5}
do
    echo
    hyperfine -w 1 \
       -n std "zig-out/std/bin/zlib_bench -i $i" \
       -n my "zig-out/my/bin/zlib_bench -i $i" #\
       #-n v1 "zig-out/std/bin/inflate_bench_v1 -i $i" \
done
