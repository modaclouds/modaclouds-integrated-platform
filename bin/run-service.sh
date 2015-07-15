#!/usr/bin/env bash

set -e -E -u -o pipefail +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1

. platform-env.sh

if [ $# -lt 2 ]; then
    echo "Usage: $0 service id [version]" >&2
    echo "  version defaults to last available version" >&2
    echo "  E.g.: $0 modaclouds-services-tower4clouds-manager t4c-manager" >&2
    exit 1
fi

function get_last_version() {
    service=$1
    last=""
    for pkg in /opt/$service*; do
        version=${pkg#/opt/$service-}
        if test "$version" \> "$last" ; then
            last="$version"
        fi
    done
    if [ -z "$last" ]; then
        echo "Error getting version for $1" >&2
        exit 1
    fi
    echo "$last"
}

service=$1
id=$2
last_version=$(get_last_version $1)
version=${3:-$last_version}

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

echo "Running $id [$service-$version] "
echo "  output is in $outfile"
echo "  pid is in $pidfile"

