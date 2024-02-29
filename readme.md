Zig flate implementation benchmarks. 


`src/bench_data` dir contains test cases:

 0. zig github repository
 1. war and peace book from gutenberg project
 2. large file from [The Canterbury Corpus](https://corpus.canterbury.ac.nz)
 3. cantrbry file from The Canterbury Corpus
 4. 1GB empty file
 5. some uncompressed images with a small palette
 
 
Files are deflate compressed, without gzip or zlib header. Gzip and zlib adds
header and footer around deflate stream. During decompression hash is
calculated to check the one provided in footer. To be sure that we are not
measuring hashing here we use just raw flate.

To produce new test case there is `deflate` tool in output folder after build.

This compares your local changes with current standard library and previous v1
standard library. Assumes that you have zig repository with some possible changes.

Then run bench script with path to your zig repository lib folder: 

```sh
./bench.sh [path to your zig/lib folder]
```

In the bench output
  - std - current standard library implementation
  - v1  - previous v1 standard library implementation
  - my  - your version
  
  
