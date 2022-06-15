#!/usr/bin/env sh
set -eu

envsubst '${DATA_URL}' < /etc/nginx/templates/geoserver.conf.template > /etc/nginx/conf.d/geoserver.conf

exec "$@"