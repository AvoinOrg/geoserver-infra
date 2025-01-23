#!/usr/bin/env bash
set -e
source /scripts/env-data.sh

source /scripts/custom/modify-setup-conf.sh
source /scripts/custom/modify-setup-pga_hba.sh

source /scripts/docker-entrypoint.sh
