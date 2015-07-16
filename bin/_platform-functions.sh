. _platform-env.sh

function start() {
    instance_id=$1
    start_${instance_id}
}

function stop() {
    pidfile="$RUNROOT/$1.pid"
    if [ ! -e "$pidfile" ]; then
        echo "Aborting: $pidfile does not exist." >&2
        return 1
    fi

    kill $(<"$pidfile") 
    ret=$?
    if [ $ret -eq 0 ]; then
        echo "$1 killed" >&2
    else
        echo "$1 not running" >&2
    fi

    rm "$pidfile"

    return $ret
}

function status() {
    
    id=$1
    pidfile=$RUNROOT/$id.pid
    if [ -e $pidfile ]; then
        pid=$(<"$pidfile")
        ps $pid >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "0"
        else
            echo "1"
        fi
    else
        echo "2"
    fi
}
