#!/bin/bash

# This script is for hanging plasma desktops
# It simply finds the current running kwin process, kills it and starts it again with same parameters
# It gets the user name as parameter or tries to find kwin for the current user

user="$1"
currentUser="`whoami`"

test -z "$user" && user="$currentUser"

pid="`pgrep -u "$user" kwin_x11`"

if test -z "$pid" ; then
    echo "Could not get PID of kwin_x11 for user $user"
    exit
fi

cat "/proc/$pid/cmdline" | perl -e '
    $_=<STDIN>;
    my @cmd= split /\000/;
    exit unless @cmd;
    unshift @cmd, "su", "-", "'"$user"'" unless "'"$user"'" eq "'"$currentUser"'";
    kill "KILL", '"$pid"';
    exec @cmd;
#    print join ":", @cmd;
' &
