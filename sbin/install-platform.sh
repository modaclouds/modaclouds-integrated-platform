#!/usr/bin/env bash

set -e -E -u -o pipefail +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

HOSTNAME=$(</etc/HOSTNAME)
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <hostname>"
    echo "  e.g. $0 $HOSTNAME"
    exit 1
fi

if [ $# -gt 0 ]; then
    HOSTNAME=$1
    echo "$HOSTNAME" > /etc/HOSTNAME
    hostname -F /etc/HOSTNAME
fi

[ -x /sbin/SuSEfirewall2 ] && /sbin/SuSEfirewall2 off

NODE_PUBLIC_IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}')
echo -e "$NODE_PUBLIC_IP\t$HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# 
# Add mOS repositories
#
bash <(curl -Ls http://ftp.info.uvt.ro/mos/tools/fixes/opensuse-13.1/add_mos_repo.sh)

zypper refresh

zypper --non-interactive --no-refresh --no-gpg-checks --gpg-auto-import-keys install \
    bind-utils
    modaclouds-platform-core \
    modaclouds-platform-services \
    modaclouds-platform-tools

##
## Some needed packages
##
#zypper --non-interactive --no-refresh --no-gpg-checks --gpg-auto-import-keys install \
#    mosaic-components-rabbitmq \
#    mosaic-rt-jre-7 \
#    fetchmsttfonts
#
##
## Mysql
##
#zypper --non-interactive install mysql mysql-community-server-client mysql-community-server
#
##
## MODAClouds packages
##
#zypper --non-interactive --no-refresh --no-gpg-checks --gpg-auto-import-keys install \
#    modaclouds-services-metric-explorer \
#    modaclouds-services-load-balancer-controller \
#    mosaic-object-store \
#    modaclouds-services-monitoring-sda-matlab \
#    modaclouds-services-monitoring-sda-weka \
#    modaclouds-services-fuseki \
#    modaclouds-services-models-at-runtime \
#    modaclouds-services-load-balancer-reasoner \
#    modaclouds-tools-mdload \
#    modaclouds-services-sla-core \
#    modaclouds-services-fg-local-db \
#    modaclouds-services-fg-analyzer \
#    modaclouds-services-tower4clouds-rdf-history-db \
#    modaclouds-services-tower4clouds-data-analyzer \
#    modaclouds-services-tower4clouds-manager
#

#
# Initialize Mysql databases
#
/sbin/chkconfig mysql on
service mysql start
mysql < /opt/modaclouds-services-sla-core-*/lib/distribution/share/database.sql

# NOT NEEDED ANYMORE metric-importer
# PENDING artifact-repository
