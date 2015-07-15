#!/usr/bin/env bash

for pidfile in $HOME/var/run/*.pid; do
    if [ -e $pidfile ]; then
        filename=$(basename $pidfile)
        id=${filename%.pid}
        pid=$(<"$pidfile")
        ps $pid >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "$id is running"
        else
            echo "$id is NOT running"
        fi
    fi 
done

