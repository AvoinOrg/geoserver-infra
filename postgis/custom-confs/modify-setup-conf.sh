#!/usr/bin/env bash
set -e
source /scripts/env-data.sh

SCRIPT_FILE="/scripts/setup-conf.sh"
BLOCK_START='cat > "${ROOT_CONF}"/postgis.conf <<EOF'
BLOCK_END='EOF'

# 1. Check the postgis.conf block exists
if ! grep -q "$BLOCK_START" "$SCRIPT_FILE"; then
    echo "Error: Could not find the postgis.conf block in $SCRIPT_FILE. The file might have been updated. Check modify-setup-confs.sh to ensure your custom postgis.conf changes are still being applied."
    exit 1
fi

# 2. Insert "max_connections = 1000" right after the "shared_buffers" line
sed -i '/shared_buffers/a max_connections = 1000' "$SCRIPT_FILE"

echo "Successfully inserted settings in $SCRIPT_FILE."
