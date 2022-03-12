#!/bin/bash

movie="$1"
shift

test ! -f "$movie" && echo "Missing movie file as first parameter" && exit 1

fileDate=`stat -c "%y" "$movie"`

createDate=`exiftool -CreateDate "$movie" | perl -ne 'print "$1-$2-$3 $4" if /^Create Date\s*:\s*(\d+):(\d+):(\d+) (\d+:\d+:\d+\w?)\s*$/'`

for image in "$@"; do
    skip=`exiftool -Comment "$image" | perl -ne 'print $1 if /^Comment\s*:\s*((?:(?:\d+:)?\d+:)?\d+(?:\.\d+)?)\s+/'`

    echo "$image - $skip"

    test ! "$skip" && echo "Could not read skip time for '$image'" && continue
    timeDiff="`echo "$skip" | perl -ne 'print((($1||0) * 60 + ($2||0)) * 60 + ($3||0)) if /^(?:(?:(\d+):)?(\d+):)?(\d+(?:\.\d+)?)\s*$/;'`"

    test "$createDate" && exiftool -overwrite_original_in_place -CreateDate="`date --utc --date="$createDate + $timeDiff seconds" '+%Y-%m-%d %H:%M:%SZ'`" "$image"

    touch --date="$fileDate + $timeDiff seconds" "$image"
done
