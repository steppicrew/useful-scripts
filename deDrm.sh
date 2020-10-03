#!/bin/bash

serials="$1"

test -z "$serials" && echo "Usage: $0 [comma separated list of kindle serials] <dir to scan>" && exit

myDir="`realpath "$0"`"
myDir="`dirname "$myDir"`"
toolsDir="$myDir/KindleBooks"

dir="$2"
test "$dir" || dir="."

backupDir="$dir/encrypted"

for file in "$dir/"*.azw "$dir/"*.azw3 "$dir/"*.mobi; do
    test -f "$file" || continue
    file "$file" | grep -q 'encrypt' || continue
    python2 "$toolsDir/lib/k4mobidedrm.py"  -s "$serials" "$file" "$dir" || continue
    test -d "$backupDir" || mkdir -p "$backupDir"
    mv "$file" "$backupDir"
done