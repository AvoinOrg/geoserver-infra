#!/usr/bin/env bash
set -e
source /scripts/env-data.sh

if [ -z "$ALLOWED_HOSTS" ]; then
    echo "ALLOWED_HOSTS environment variable not set, pg_conf rules will not be updated."
    exit 1
fi

IFS=' ' read -ra hosts <<< "$ALLOWED_HOSTS"
for host in "${hosts[@]}"; do
    line="host    all    all    ${host}    md5"
    echo "${line}" >>"${ROOT_CONF}"/pg_hba.conf
    echo "Added line to pg_hba.conf: ${line}"
done

echo "Successfully updated pg_hba.conf with custom rules."
