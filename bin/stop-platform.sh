#!/usr/bin/env bash

for pidfile in $HOME/var/run/*.pid; do
    if [ -e $pidfile ]; then
        filename=$(basename $pidfile)
        id=${filename%.pid}
        stop-service.sh $id
    fi 
done

