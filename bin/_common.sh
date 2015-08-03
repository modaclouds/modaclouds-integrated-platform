LOGROOT=$HOME/var/log
RUNROOT=$HOME/var/run

function get_public_address() {
    echo $(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}')
}

function get_line_etc_hosts() {
    local line=$(getent hosts $1)
    echo "$line"
}

function get_fqdn() {
# Get fqdn of of parameter (i.e., second field of /etc/hosts file)
    local addr=$(get_public_address)
    local hostline=$(get_line_etc_hosts "$addr")

    echo "$hostline" | awk '{print $2}'
}

