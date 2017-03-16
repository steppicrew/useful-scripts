#!/bin/bash

# This script is for hanging plasma desktops
# It simply finds the current running kwin process, kills it and starts it again with same parameters
# It gets the user name as parameter or tries to find kwin for the current user

user="$1"

test -z "$user" && user=`whoami`

pid=`pgrep -u "$user" kwin_x11`

test "$pid" || (echo "Could not get PID of kwin_x11 for user $user"; exit)

cat "/proc/$pid/cmdline" | perl -e '
    $_=<STDIN>;
    my @cmd= split /\000/;
    exit unless @cmd;
    kill "KILL", '$pid';
    exec @cmd;
#    print join ":", @cmd;
' &
