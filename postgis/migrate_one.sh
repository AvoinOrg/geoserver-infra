#!/bin/bash
set -e

# Check arguments
if [ "$#" -ne 7 ]; then
    echo "Usage: $0 <user> <password> <source-host> <source-port> <target-host> <target-port> <database>"
    exit 1
fi

PGUSER=$1
PGPASSWORD=$2
SOURCE_HOST=$3
SOURCE_PORT=$4
TARGET_HOST=$5
TARGET_PORT=$6
DATABASE=$7
DUMP_DIR="/mnt/postgis-data-backup/pg_migration"
LOG_FILE="/mnt/postgis-data-backup/migration.log"
DATE=$(date +%Y%m%d_%H%M%S)

# Create dump directory
mkdir -p "$DUMP_DIR"

# Dump and restore a database
echo "Processing database: $DATABASE" | tee -a "$LOG_FILE"

# Dump
echo "Dumping $DATABASE..." | tee -a "$LOG_FILE"
PGPASSWORD=$PGPASSWORD pg_dump -w -Fc --host=$SOURCE_HOST --port=$SOURCE_PORT --username=$PGUSER -d "$DATABASE" >"$DUMP_DIR/${DATABASE}_$DATE.dump"

# Create database
PGPASSWORD=$PGPASSWORD psql -w -h $TARGET_HOST -p $TARGET_PORT -U $PGUSER -d postgres -c "CREATE DATABASE \"$DATABASE\"" 2>/dev/null || true
# Restore
echo "Restoring $DATABASE..." | tee -a "$LOG_FILE"
PGPASSWORD=$PGPASSWORD pg_restore -w --host=$TARGET_HOST --port=$TARGET_PORT --username=$PGUSER -d "$DATABASE" --no-owner --no-privileges "$DUMP_DIR/${DATABASE}_$DATE.dump" || true

echo "Migration completed at $(date)" | tee -a "$LOG_FILE"

# Cleanup
rm -rf "$DUMP_DIR"
