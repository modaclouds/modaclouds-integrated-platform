VERSION=2.2
PACKAGE=0.7.0.18
LOGROOT=$HOME/var/log
RUNROOT=$HOME/var/run
ENV=$HOME/.modaclouds/env.sh
CNF=$HOME/.modaclouds/config.sh

[ -e "$CNF" ] && . "$CNF"

function get_public_address() {
    # http://unix.stackexchange.com/questions/22615/how-can-i-get-my-external-ip-address-in-bash
    dig +short myip.opendns.com @resolver1.opendns.com
}

function get_internal_address() {
    /sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'
}

function get_addr() {
    # 
    # get_addr <instanceid>
    #
    # Get address of an instance id
    #
    for node in "${!addresses[@]}"; do
        local address=${addresses["$node"]}
        local arr=${node}_instances[@]
        for id in "${!arr}"; do
            if [ "$id" = "$1" ]; then
                echo "$address"
                return
            fi
        done
    done
    echo "Warning: $1 not found" >&2
    exit 1
}


function get_line_etc_hosts() {
    local line=$(getent hosts $1)
    echo "$line"
}

function get_fqdn() {
# Get fqdn of of parameter (i.e., second field of /etc/hosts file)
    local addr=$(get_internal_address)
    local hostline=$(get_line_etc_hosts "$addr")

    if [ -z "$hostline" ]; then
        hostline=$(get_line_etc_hosts 127.0.0.1)
    fi

    echo "$hostline" | awk '{print $2}'
}

