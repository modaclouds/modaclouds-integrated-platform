#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 serviceid" >&2
    exit 1
fi

pidfile="$HOME/var/run/$1.pid"
if [ ! -e "$pidfile" ]; then
    echo "Aborting: $pidfile does not exist." >&2
    exit 1
fi

kill $(<"$pidfile") 
ret=$?
if [ $ret -eq 0 ]; then
    echo "$1 killed"
else
    echo "$1 not running" >&2
fi

rm "$pidfile"

exit $ret
