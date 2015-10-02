#
# Set the values of each of the nodes before running platform-config.sh:
#
# export NODE_A_IP=...
# export NODE_B_IP=...
#
declare -A addresses=( 
	["node1"]=$NODE_A_IP
	["node2"]=$NODE_B_IP
)

node1_instances=(
t4c-dda
t4c-manager
t4c-db
mrt
sla
rabbitmq
object-store
fuseki
)

node2_instances=(
sda-matlab
fg-analyzer
fg-local-db
lb-controller
lb-reasoner
metric-explorer
)

