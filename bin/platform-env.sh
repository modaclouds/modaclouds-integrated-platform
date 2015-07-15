LOGROOT=$HOME/var/log
RUNROOT=$HOME/var/run

instance_ids=(
    rabbitmq
    fuseki-t4c
    object-store
    t4c-dda
    t4c-manager
    t4c-db
    mrt
    sla
)

MOS_NODE_PUBLIC_IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}')

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
export MODACLOUDS_RABBITMQ_ENDPOINT_IP=127.0.0.1
export MODACLOUDS_RABBITMQ_ENDPOINT_PORT=21688

#
# FUSEKI T4C
#
export MODACLOUDS_FUSEKI_T4C_ENDPOINT_IP=127.0.0.1
export MODACLOUDS_FUSEKI_T4C_ENDPOINT_PORT=3030

#
# OBJECT STORE
#
export MOSAIC_OBJECT_STORE_ENDPOINT_IP=127.0.0.1
export MOSAIC_OBJECT_STORE_ENDPOINT_PORT=20622

#
# TOWER4CLOUDS
#
export MODACLOUDS_TOWER4CLOUDS_DATA_ANALYZER_PUBLIC_ENDPOINT_IP=${MOS_NODE_PUBLIC_IP}
export MODACLOUDS_TOWER4CLOUDS_DATA_ANALYZER_PUBLIC_ENDPOINT_PORT=8175

export MODACLOUDS_TOWER4CLOUDS_MANAGER_ENDPOINT_IP=${MOS_NODE_PUBLIC_IP}
export MODACLOUDS_TOWER4CLOUDS_MANAGER_ENDPOINT_PORT=8170
export MODACLOUDS_TOWER4CLOUDS_MANAGER_PUBLIC_ENDPOINT_IP=${MOS_NODE_PUBLIC_IP}
export MODACLOUDS_TOWER4CLOUDS_MANAGER_PUBLIC_ENDPOINT_PORT=8170

export MODACLOUDS_TOWER4CLOUDS_RDF_HISTORY_DB_ENDPOINT_IP=127.0.0.1
export MODACLOUDS_TOWER4CLOUDS_RDF_HISTORY_DB_ENDPOINT_PORT=9100

#
# LOAD BALANCER CONTROLLER
#
export MODACLOUDS_LOAD_BALANCER_CONTROLLER_ENDPOINT_IP=127.0.0.1
export MODACLOUDS_LOAD_BALANCER_CONTROLLER_ENDPOINT_PORT=8088

#
# LOAD BALANCER REASONER
#

#
# MODELS@RUNTIME
#
export MODACLOUDS_MODELS_AT_RUNTIME_ENDPOINT_IP=127.0.0.1
export MODACLOUDS_MODELS_AT_RUNTIME_ENDPOINT_PORT=9000

#
# SLA
#
export MODACLOUDS_SLACORE_ENDPOINT_IP=127.0.0.1
export MODACLOUDS_SLACORE_ENDPOINT_PORT=9040
export MODACLOUDS_SLACORE_PUBLIC_ENDPOINT_IP=${MOS_NODE_PUBLIC_IP}
export MODACLOUDS_SLACORE_PUBLIC_ENDPOINT_PORT=9040

###
#
# Define service start functions. 
# Each service overrides listening addresses and define any non 
# "standard" (and not defined above) needed variable
#

function start_rabbitmq() {
    env \
        MODACLOUDS_RABBITMQ_ENDPOINT_IP=0.0.0.0 \
        run-service.sh mosaic-components-rabbitmq rabbitmq
}

function start_fuseki-t4c() {
    env \
        MODACLOUDS_FUSEKI_ENDPOINT_IP=0.0.0.0 \
        MODACLOUDS_FUSEKI_ENDPOINT_PORT=$MODACLOUDS_FUSEKI_T4C_ENDPOINT_PORT \
        run-service.sh modaclouds-services-fuseki fuseki-t4c
}

function start_object-store() {
    env \
        MODACLOUDS_OBJECT_STORE_ENDPOINT_IP=0.0.0.0 \
        run-service.sh mosaic-object-store object-store
}

function start_t4c-dda() {
    env \
        run-service.sh modaclouds-services-tower4clouds-data-analyzer t4c-dda
}

function start_t4c-manager() {
    env \
        run-service.sh modaclouds-services-tower4clouds-manager t4c-manager
}

function start_t4c-db() {
    env \
        MODACLOUDS_TOWER4CLOUDS_RDF_HISTORY_DB_ENDPOINT_IP=0.0.0.0 \
        MODACLOUDS_FUSEKI_ENDPOINT_IP=$MODACLOUDS_FUSEKI_T4C_ENDPOINT_IP \
        MODACLOUDS_FUSEKI_ENDPOINT_PORT=$MODACLOUDS_FUSEKI_T4C_ENDPOINT_PORT \
        run-service.sh modaclouds-services-tower4clouds-rdf-history-db t4c-db
}

function start_lb-controller() {
    env \
        MODACLOUDS_LOAD_BALANCER_CONTROLLER_ENDPOINT_IP=0.0.0.0 \
        run-service.sh modaclouds-services-load-balancer-controller lb-controller
}

function start_mrt() {
    env \
        MODACLOUDS_MODELS_AT_RUNTIME_ENDPOINT_IP=0.0.0.0 \
        MODACLOUDS_MONITORING_MANAGER_ENDPOINT_IP=$MODACLOUDS_TOWER4CLOUDS_MANAGER_PUBLIC_ENDPOINT_IP \
        MODACLOUDS_MONITORING_MANAGER_ENDPOINT_PORT=$MODACLOUDS_TOWER4CLOUDS_MANAGER_PUBLIC_ENDPOINT_PORT \
        run-service.sh modaclouds-services-models-at-runtime mrt
}

function start_sla() {
    env \
        MODACLOUDS_SLACORE_ENDPOINT_IP=0.0.0.0 \
        run-service.sh modaclouds-services-sla-core sla
}

