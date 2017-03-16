#!/bin/bash

# This script is for hanging plasma desktops
# It simply finds the current running kwin process, kills it and starts it again with same parameters

user="`whoami`"

pid="`pgrep -u "$user" kwin_x11`"

if test -z "$pid" ; then
    echo "Could not get PID of kwin_x11 for user $user"
    exit
fi

cat "/proc/$pid/cmdline" | perl -e '
    $_=<STDIN>;
    my @cmd= split /\000/;
    exit unless @cmd;
    kill "KILL", '"$pid"';
    exec @cmd;
#    print join ":", @cmd;
' &
