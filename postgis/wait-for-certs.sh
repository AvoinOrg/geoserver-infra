#!/usr/bin/env bash
set -e

CERT_FILES=(
  "/letsencrypt-certs/${DOMAIN}/certificate.crt"
  "/letsencrypt-certs/${DOMAIN}/privatekey.key"
)

echo "Checking for cert files..."
for file in "${CERT_FILES[@]}"; do
  until [ -f "$file" ]; do
    echo "Waiting for $file to exist..."
    sleep 3
  done
  echo "$file found!"
done

# Optionally verify non-zero length, correct permissions, etc.

echo "All cert files present. Starting Postgres..."
exec docker-entrypoint.sh "$@"   # or the image's original entrypoint