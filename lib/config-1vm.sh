declare -A addresses=( 
	["node1"]="0.0.0.0"
)

node1_instances=(
    rabbitmq
    object-store
    fuseki
    t4c-dda
    t4c-manager
    t4c-db
    mrt
    sla
    sda-matlab
    fg-analyzer
    fg-local-db
    lb-controller
    lb-reasoner
    metric-explorer
)

