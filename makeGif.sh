#!/bin/bash

inFile="$1"
bname="`basename "$inFile" ".mp4"`"
bname="`basename "$bname" ".mkv"`"
outFile="./$bname"
skip="$2" # in seconds
to="$3"
crop="$4"
scale="$5"

rotate=""
#rotate="rotate=.29,"

#speed=2
test "$speed" || speed=1
speed=`echo "$speed" | perl -ne 'print 1/$_'`

fps=10

test "$crop" || crop="990:540:0:0"
test "$scale" || scale="990x540"

i=1
while true; do
    test -f "$outFile-$i.gif" || break
    i=$(( i + 1 ))
done
outFile="$outFile-$i.gif"

#scale="990x540"

#crop="495:540:0:0"
#crop="650:340:100:100"

params=()
test "$skip" && params=( "${params[@]}" "-ss" "$skip" )
test "$to" && params=( "${params[@]}" "-to" "$to" )
params=( "${params[@]}" "-i" "`realpath "$inFile"`" )
params=( "${params[@]}" "-vf" "${rotate}scale=$scale,crop=$crop,setpts=$speed*PTS,fps=fps=$fps" )

echo ffmpeg "${params[@]}" "$outFile"
ffmpeg "${params[@]}" "$outFile"
exiftool -TagsFromFile "$inFile" -All:All "$outFile"

shift
comment=`printf "$*\n${params[*]}"`
exiftool -overwrite_original_in_place -Comment="$comment" "$outFile"

dir=`dirname "$0"`
dir=`realpath "$dir"`
"$dir/fixGifDate.sh" "$inFile" "$outFile"

