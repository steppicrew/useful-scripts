#!/bin/bash

serials="$1"

test -z "$serials" && echo "Usage: $0 [comma separated list of kindle serials] <dir to scan>" && exit

myDir="`realpath "$0"`"
myDir="`dirname "$myDir"`"
toolsDir="$myDir/KindleBooks"

dir="$2"
test "$dir" || dir="."

tempfile="/tmp/$(basename "$0")-$$.sh"

cat - <<EOT > "$tempfile"
echo "Converting..."
for file in "/books/"*.azw "/books/"*.azw3 "/books/"*.mobi; do
    test -f "\$file" || continue
    file "\$file" | grep -q 'encrypt' || continue
    python2 "/src/lib/k4mobidedrm.py"  -s "$serials" "\$file" "/books" || continue
    test -d "/books/encrypted" || mkdir -p "/books/encrypted"
    mv "\$file" "/books/encrypted"
done
chmod -R ugo+rwX "/books/"
EOT

docker run -it --rm --volume="$toolsDir/:/src/" --volume="$dir/:/books/" --volume="$tempfile:/deDrm.sh" python:2.7 bash /deDrm.sh

test -f "$tempfile" && rm "$tempfile"