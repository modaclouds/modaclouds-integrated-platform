#!/usr/bin/env bash

set -e -E -u -o pipefail -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1

RELEASE=0.7.0.14
LOGROOT=$HOME/var/log
RUNROOT=$HOME/var/run

if [ $# -lt 2 ]; then
    echo "Usage: $0 service id [version]" >&2
    echo "  version defaults to $RELEASE" >&2
    echo "  E.g.: $0 modaclouds-services-towerclouds-manager t4c-manager" >&2
    exit 1
fi

service=$1
id=$2
version=${3:-$RELEASE}

if [[ "$service" = *-services-* ]]; then
    bin="/opt/${service}-${version}/bin/${service}--run-service"
elif [[ "$service" = *-components-* ]]; then
    bin="/opt/${service}-${version}/bin/${service}--run-component"
else
    bin="/opt/${service}-${version}/bin/${service}--run-component"
    if [ ! -x "$bin" ]; then
        echo "Cannot determine type of service $service" >&2
        exit 1
    fi
fi

if [ ! -x "$bin" ]; then
    echo "Cannot run service $service. $bin does not exist or is not executable" >&2
    exit 1
fi


environment=(
    modaclouds_service_identifier="$(date +"%s")$RANDOM" 
)

#for _variable in "${environment[@]}" ; do
#    printf '[ii]       * `%s`;\n' "${_variable}" >&2
#done

outfile=$LOGROOT/$id.out
pidfile=$RUNROOT/$id.pid

#env \
#    "${environment[@]}"
#exit 0

env \
    "${environment[@]}" \
    nohup "$bin" > $outfile 2>&1 &

pid=$!
echo $pid > $pidfile

echo "Running $id. "
echo "  output is in $outfile"
echo "  pid is in $pidfile"

