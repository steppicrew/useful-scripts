#!/bin/bash

current=`qdbus org.kde.ActivityManager /ActivityManager/Activities CurrentActivity`

switchAcitivity=""
abort=""
for activity in `qdbus org.kde.ActivityManager /ActivityManager/Activities ListActivities`; do
    if [ "$abort" ]; then
        switchActivity="$activity"
        break
    fi
    test "$switchActivity" || switchActivity="$activity"
    test "$current" = "$activity" && abort="1"
done

qdbus org.kde.ActivityManager /ActivityManager/Activities SetCurrentActivity "$switchActivity"
