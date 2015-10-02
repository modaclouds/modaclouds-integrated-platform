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
    env \
        mosaic_node_fqdn=$FQDN \
        mosaic_node_ip=$NODE_PUBLIC_IP \
        SERVICE_ADDRESS=$MODACLOUDS_RABBITMQ_ENDPOINT_PORT \
        service-run.sh mosaic-components-rabbitmq rabbitmq
}

function start_fuseki() {
    env \
        SERVICE_ADDRESS=$MODACLOUDS_FUSEKI_ENDPOINT_PORT \
        service-run.sh modaclouds-services-fuseki fuseki
}

function start_object-store() {
    env \
        SERVICE_ADDRESS=$MOSAIC_OBJECT_STORE_ENDPOINT_PORT \
        service-run.sh mosaic-object-store object-store
}

function start_t4c-dda() {
    env \
        SERVICE_ADDRESS=$MODACLOUDS_TOWER4CLOUDS_DATA_ANALYZER_ENDPOINT_PORT \
        service-run.sh modaclouds-services-monitoring-dda t4c-dda
}

function start_t4c-manager() {
    env \
        MODACLOUDS_TOWER4CLOUDS_MANAGER_PUBLIC_ENDPOINT_IP=$MODACLOUDS_TOWER4CLOUDS_MANAGER_ENDPOINT_IP_PUBLIC \
        MODACLOUDS_TOWER4CLOUDS_DATA_ANALYZER_PUBLIC_ENDPOINT_IP=$MODACLOUDS_TOWER4CLOUDS_DATA_ANALYZER_ENDPOINT_IP_PUBLIC \
        SERVICE_ADDRESS=$MODACLOUDS_TOWER4CLOUDS_MANAGER_ENDPOINT_PORT \
        service-run.sh modaclouds-services-monitoring-manager t4c-manager
}

function start_t4c-db() {
    env \
        MODACLOUDS_FUSEKI_ENDPOINT_IP=$MODACLOUDS_FUSEKI_ENDPOINT_IP_HACK \
        MODACLOUDS_FUSEKI_ENDPOINT_PORT=$MODACLOUDS_FUSEKI_ENDPOINT_PORT \
        MODACLOUDS_RABBITMQ_ENDPOINT_IP=$MODACLOUDS_RABBITMQ_ENDPOINT_IP_HACK \
        SERVICE_ADDRESS=$MODACLOUDS_TOWER4CLOUDS_RDF_HISTORY_DB_ENDPOINT_PORT \
        service-run.sh modaclouds-services-monitoring-history-db t4c-db
}

function start_lb-controller() {
    env \
        SERVICE_ADDRESS=$MODACLOUDS_LOAD_BALANCER_CONTROLLER_ENDPOINT_PORT \
        service-run.sh modaclouds-services-load-balancer-controller lb-controller
}

function start_lb-reasoner() {
    env \
        service-run.sh modaclouds-services-load-balancer-reasoner lb-reasoner
}

function start_mrt() {
    env \
        SERVICE_ADDRESS=$MODACLOUDS_MODELS_AT_RUNTIME_ENDPOINT_PORT \
        service-run.sh modaclouds-services-models-at-runtime mrt
}

function start_sla() {
    env \
        SERVICE_ADDRESS=$MODACLOUDS_SLACORE_ENDPOINT_PORT \
        service-run.sh modaclouds-services-sla-core sla
}

function start_sda-matlab() {
    env \
        SERVICE_ADDRESS=$MODACLOUDS_MONITORING_SDA_MATLAB_ENDPOINT_PORT \
        service-run.sh modaclouds-services-monitoring-sda-matlab sda-matlab
}

function start_sda-weka() {
    env \
        SERVICE_ADDRESS=$MODACLOUDS_MONITORING_SDA_WEKA_ENDPOINT_PORT \
        service-run.sh modaclouds-services-monitoring-sda-weka sda-weka
}

function start_fg-local-db() {
    env \
        MODACLOUDS_FUSEKI_ENDPOINT_IP=$MODACLOUDS_FUSEKI_ENDPOINT_IP_HACK \
        service-run.sh modaclouds-services-fg-local-db fg-local-db
}

function start_fg-analyzer() {
    env \
        service-run.sh modaclouds-services-fg-analyzer fg-analyzer
}

function start_metric-explorer() {
    env \
        SERVICE_ADDRESS=$MODACLOUDS_METRIC_EXPLORER_DASHBOARD_ENDPOINT_PORT \
        service-run.sh modaclouds-services-metric-explorer metric-explorer
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

