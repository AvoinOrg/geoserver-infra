#!/usr/bin/env bash
set -e
source /scripts/env-data.sh

SCRIPT_FILE="/scripts/setup-pg_hba.sh"
BLOCK_START='if \[\[ -z "\$REPLICATE_FROM" \]\]; then'
BLOCK_END='fi'

# 1. Check the block exists
if ! grep -q "$BLOCK_START" "$SCRIPT_FILE"; then
    echo "Error: REPLICATE_FROM block not found in the $SCRIPT_FILE. The file seems to have been updated. Check modify_pg_hba.sh to ensure your custom pg_hba.conf changes are still being applied."
    exit 1
fi

# Add lines to execute to the scripts
INSERT_LINES="source /scripts/custom/pg_hba-additions.sh"

# 3. Append after the replicate_from block’s closing 'fi'
#    The /fi/ a ... means “after the line that matches fi inside that block”
sed -i "/$BLOCK_START/,/$BLOCK_END/ { /$BLOCK_END/ a $INSERT_LINES
}" "$SCRIPT_FILE"

echo "Successfully customized the $SCRIPT_FILE to include the custom setup-pg_hba.sh script."
