LOGROOT=$HOME/var/log
RUNROOT=$HOME/var/run

instance_ids=(
    rabbitmq
    object-store
    fuseki-t4c
    fuseki-fg
    t4c-dda
    t4c-manager
    t4c-db
    mrt
    sla
    sda-matlab
)

NODE_PUBLIC_IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}')
NODE_IP=127.0.0.1
FQDN=node.localdomain


###
#
# Set ips and ports where each service can find other services
#

#
# MYSQL
#
export MODACLOUDS_MYSQL_ENDPOINT_IP=127.0.0.1
export MODACLOUDS_MYSQL_ENDPOINT_PORT=3306

#
# RABBITMQ
#
export MODACLOUDS_RABBITMQ_ENDPOINT_IP=0.0.0.0
export MODACLOUDS_RABBITMQ_ENDPOINT_PORT=21688

#
# FUSEKI T4C
#
export MODACLOUDS_FUSEKI_T4C_ENDPOINT_IP=0.0.0.0
export MODACLOUDS_FUSEKI_T4C_ENDPOINT_PORT=3030

#
# FUSEKI FG
#
export MODACLOUDS_FUSEKI_FG_ENDPOINT_IP=0.0.0.0
export MODACLOUDS_FUSEKI_FG_ENDPOINT_PORT=3040

#
# OBJECT STORE
#
export MOSAIC_OBJECT_STORE_ENDPOINT_IP=0.0.0.0
export MOSAIC_OBJECT_STORE_ENDPOINT_PORT=20622

#
# TOWER4CLOUDS
#
export MODACLOUDS_TOWER4CLOUDS_DATA_ANALYZER_PUBLIC_ENDPOINT_IP=${NODE_PUBLIC_IP}
export MODACLOUDS_TOWER4CLOUDS_DATA_ANALYZER_PUBLIC_ENDPOINT_PORT=8175

export MODACLOUDS_TOWER4CLOUDS_MANAGER_ENDPOINT_IP=${NODE_PUBLIC_IP}
export MODACLOUDS_TOWER4CLOUDS_MANAGER_ENDPOINT_PORT=8170
export MODACLOUDS_TOWER4CLOUDS_MANAGER_PUBLIC_ENDPOINT_IP=${NODE_PUBLIC_IP}
export MODACLOUDS_TOWER4CLOUDS_MANAGER_PUBLIC_ENDPOINT_PORT=8170

export MODACLOUDS_TOWER4CLOUDS_RDF_HISTORY_DB_ENDPOINT_IP=0.0.0.0
export MODACLOUDS_TOWER4CLOUDS_RDF_HISTORY_DB_ENDPOINT_PORT=9100

#
# LOAD BALANCER CONTROLLER
#
export MODACLOUDS_LOAD_BALANCER_CONTROLLER_ENDPOINT_IP=0.0.0.0
export MODACLOUDS_LOAD_BALANCER_CONTROLLER_ENDPOINT_PORT=8088

#
# LOAD BALANCER REASONER
#

#
# MODELS@RUNTIME
#
export MODACLOUDS_MODELS_AT_RUNTIME_ENDPOINT_IP=0.0.0.0
export MODACLOUDS_MODELS_AT_RUNTIME_ENDPOINT_PORT=9000

#
# SLA
#
export MODACLOUDS_SLACORE_ENDPOINT_IP=0.0.0.0
export MODACLOUDS_SLACORE_ENDPOINT_PORT=9040

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
