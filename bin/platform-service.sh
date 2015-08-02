#!/usr/bin/env bash

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
#trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1

if [ $# -eq 0 ]; then
    echo "Usage $0 instance-id [start|stop|status|restart]" >&2
    exit 1
fi

. _platform-functions.sh

id=$1
cmd=${2:-status}


function search_id() {
    for i in "${instance_ids[@]}"
    do
        if [ "$i" == "$1" ] ; then
            echo "$i"
        fi
    done
    echo ""
}

found=$(search_id $id)
if [ -z "$found" ]; then
    echo "instance-id $id not recognized" >&2
    exit 1
fi


case $cmd in
    start)
        start ${id}
        ;;
    stop)
        stop ${id}
        ;;
    restart)
        stop ${id}
        start ${id}
        ;;
    status)
        ret=$(status ${id})
        pidfile=$RUNROOT/$id.pid
        case "$ret" in
        "0")
            pid=$(<"$pidfile")
            echo "$id is running (pid=$pid)"
            ;;
        "1")
            pid=$(<"$pidfile")
            echo "[error] $id is not running (pid=$pid)"
            ;;
        "2")
            echo "$id is stopped"
            ;;
        esac
        ;;

    *)
        echo "Command '$cmd' not recognized" >&2
        exit 1
        ;;
esac


