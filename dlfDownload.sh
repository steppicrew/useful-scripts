#!/bin/sh

pageUrl="$1"

if [ -z "$pageUrl" ]; then
    echo "Die Seite des dlf als Parameter angeben!"
    exit
fi

# get master file
masterFile=`wget -O - -q "$pageUrl" | perl -ne 'print $1 if /<meta name="twitter:player:stream" content="([^"]+)">/'`

# get playlist
m3uUrl=`wget -O - -q "$masterFile" | perl -ne 'print $1 if /^(http.+)\s*$/'`

baseUrl=`dirname "$m3uUrl"`
outFile=`basename "$baseUrl"`

m3uFile="$outFile.m3u"
wget -O "$m3uFile" "$m3uUrl" || exit

test -f "$outFile.m2t" && rm "$outFile.m2t"

while read line; do
    start="${line:0:1}"
    test "$start" = '#' && continue
    wget -O "$outFile.tmp" "$line"
    cat "$outFile.tmp" >> "$outFile.m2t"
done < "$m3uFile"

ffmpeg -i "$outFile.m2t" -codec copy "$outFile" && rm "$outFile.m2t"

test -f "$m3uFile" && rm "$m3uFile"
test -f "$outFile.tmp" && rm "$outFile.tmp"
