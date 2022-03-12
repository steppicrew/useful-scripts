#!/bin/bash

movie="$1"
shift

test ! -f "$movie" && echo "Missing movie file as first parameter" && exit 1

origDate=`stat -c "%y" "$movie"`

for image in "$@"; do
    skip=`exiftool -Comment "$image" | perl -ne 'print $1 if /^Comment\s*:\s*((?:(?:\d+:)?\d+:)?\d+(?:\.\d+)?)\s+/'`

    echo "$image - $skip"

    test ! "$skip" && echo "Could not read skip time for '$image'" && continue
    timeDiff="`echo "$skip" | perl -ne 'print((($1||0) * 60 + ($2||0)) * 60 + ($3||0)) if /^(?:(?:(\d+):)?(\d+):)?(\d+(?:\.\d+)?)\s*$/;'`"
    touch --date="$origDate + $timeDiff seconds" "$image"

done
