. _common.sh
ENV="$HOME/.modaclouds/env.sh"
if [ ! -e "$ENV" ]; then
    echo "ERROR: $ENV file does not exist. Run platform-config program."
    exit 1
fi

. "$ENV"

###
#
# Define service start functions. 
# Each service overrides listening addresses and define any non 
# "standard" (and not defined above) needed variables
#

function start_rabbitmq() {
    #local FQDN=$(get_fqdn)
    #local NODE_PUBLIC_IP=$(get_public_address)
    env \
        mosaic_node_fqdn=$FQDN \
        mosaic_node_ip=$NODE_PUBLIC_IP \
        service-run.sh mosaic-components-rabbitmq rabbitmq
}

function start_fuseki-t4c() {
    env \
        MODACLOUDS_FUSEKI_ENDPOINT_PORT=$MODACLOUDS_FUSEKI_T4C_ENDPOINT_PORT \
        service-run.sh modaclouds-services-fuseki fuseki-t4c
}

function start_fuseki-fg() {
    env \
        MODACLOUDS_FUSEKI_ENDPOINT_PORT=$MODACLOUDS_FUSEKI_FG_ENDPOINT_PORT \
        service-run.sh modaclouds-services-fuseki fuseki-fg
}

function start_object-store() {
    env \
        service-run.sh mosaic-object-store object-store
}

function start_t4c-dda() {
    env \
        service-run.sh modaclouds-services-tower4clouds-data-analyzer t4c-dda
}

function start_t4c-manager() {
    env \
        MODACLOUDS_TOWER4CLOUDS_MANAGER_PUBLIC_ENDPOINT_IP=$MODACLOUDS_TOWER4CLOUDS_MANAGER_ENDPOINT_IP_PUBLIC \
        MODACLOUDS_TOWER4CLOUDS_DATA_ANALYZER_PUBLIC_ENDPOINT_IP=$MODACLOUDS_TOWER4CLOUDS_DATA_ANALYZER_ENDPOINT_IP_PUBLIC \
        service-run.sh modaclouds-services-tower4clouds-manager t4c-manager
}

function start_t4c-db() {
    env \
        MODACLOUDS_FUSEKI_ENDPOINT_IP=$MODACLOUDS_FUSEKI_T4C_ENDPOINT_IP \
        MODACLOUDS_FUSEKI_ENDPOINT_PORT=$MODACLOUDS_FUSEKI_T4C_ENDPOINT_PORT \
        service-run.sh modaclouds-services-tower4clouds-rdf-history-db t4c-db
}

function start_lb-controller() {
    env \
        service-run.sh modaclouds-services-load-balancer-controller lb-controller
}

function start_mrt() {
    env \
        service-run.sh modaclouds-services-models-at-runtime mrt
}

function start_sla() {
    env \
        service-run.sh modaclouds-services-sla-core sla
}

function start_sda-matlab() {
    env \
        service-run.sh modaclouds-services-monitoring-sda-matlab sda-matlab
}

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

