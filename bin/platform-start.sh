#!/usr/bin/env bash

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1

. _platform-functions.sh

for _id in "${instance_ids[@]}" ; do
    start_${_id}
done


