#!/bin/bash

outfile="`basename "$1" .gif`"

infiles=""
i=0
for file in "$@"; do
    test "$infiles" && infiles="$infiles|"
    infiles="$infiles$file"
    i=$(( $i + 1 ))
done

ffmpeg -i "concat:$infiles" "$outfile-concat.gif"
