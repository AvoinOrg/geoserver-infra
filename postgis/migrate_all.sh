#!/bin/bash
set -e

# Check arguments
if [ "$#" -ne 6 ]; then
    echo "Usage: $0 <user> <password> <source-host> <source-port> <target-host> <target-port>"
    exit 1
fi

PGUSER=$1
PGPASSWORD=$2
SOURCE_HOST=$3
SOURCE_PORT=$4
TARGET_HOST=$5
TARGET_PORT=$6
DUMP_DIR="/mnt/postgis-data-backup/pg_migration"
LOG_FILE="/mnt/postgis-data-backup/migration.log"
DATE=$(date +%Y%m%d_%H%M%S)

# Create dump directory
mkdir -p "$DUMP_DIR"

echo "Starting migration at $(date)" | tee -a "$LOG_FILE"

# 1. Dump global objects (roles, tablespaces)
echo "Dumping global objects..." | tee -a "$LOG_FILE"
PGPASSWORD=$PGPASSWORD pg_dumpall -w --host=$SOURCE_HOST --port=$SOURCE_PORT -l postgres --username=$PGUSER -g >"$DUMP_DIR/globals_$DATE.sql"

# 2. Get list of databases
databases=$(PGPASSWORD=$PGPASSWORD psql -w -h $SOURCE_HOST -p $SOURCE_PORT -U $PGUSER -d postgres -t -c "SELECT datname FROM pg_database WHERE datname NOT IN ('template0', 'template1', 'postgres')" | grep -v '^$')

# 3. Restore globals
echo "Restoring global objects..." | tee -a "$LOG_FILE"
PGPASSWORD=$PGPASSWORD psql -w -h $TARGET_HOST -p $TARGET_PORT -U $PGUSER -d postgres -f "$DUMP_DIR/globals_$DATE.sql"

# 4. Dump and restore each database
for db in $databases; do
    echo "Processing database: $db" | tee -a "$LOG_FILE"

    # Dump
    echo "Dumping $db..." | tee -a "$LOG_FILE"
    PGPASSWORD=$PGPASSWORD pg_dump -w -Fc --host=$SOURCE_HOST --port=$SOURCE_PORT --username=$PGUSER -d "$db" >"$DUMP_DIR/${db}_$DATE.dump"

    # Create database
    PGPASSWORD=$PGPASSWORD psql -w -h $TARGET_HOST -p $TARGET_PORT -U $PGUSER -d postgres -c "CREATE DATABASE \"$db\"" 2>/dev/null || true
    # Restore
    echo "Restoring $db..." | tee -a "$LOG_FILE"
    PGPASSWORD=$PGPASSWORD pg_restore -w --host=$TARGET_HOST --port=$TARGET_PORT --username=$PGUSER -d "$db" "$DUMP_DIR/${db}_$DATE.dump" || true
done

echo "Migration completed at $(date)" | tee -a "$LOG_FILE"

# Cleanup
rm -rf "$DUMP_DIR"
