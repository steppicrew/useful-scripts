#!/bin/bash

rotdir="$1"
file="$2"

test ! "$rotdir" -o ! -r "$file" && echo "Usage: $0 [1|-1] [file]" && exit

test "$rotdir" = "-1" && rotdir=2

dir="`dirname "$file"`"
bname="`basename "$file"`"
extension="${bname##*.}"
bname="`basename "$file" ".$extension"`"

ffmpeg -i "$file" -vf "transpose=$rotdir" "$dir/$bname-$rotdir.$extension"
