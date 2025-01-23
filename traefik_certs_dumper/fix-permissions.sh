#!/usr/bin/env sh

set -e

echo "Running fix-perms script..."

# Example: Directories get 750
# find /certs-output -type d -exec chmod 777 {} \;

# # Private keys get 600
# find /certs-output -type f -name 'privatekey.key' -exec chmod 777 {} \;

# # Public cert files get 644
chown -R 101:103 /certs-output

# find /certs-output -type d -exec sh -c 'chmod 777 "$1"; ls -la "$1"' sh {} \;
find /certs-output -type f -name 'privatekey.key' -exec sh -c 'chmod 0600 "$1"; ls -la "$1"' sh {} \;
find /certs-output -type f -name 'certificate.crt' -exec sh -c 'chmod 0600 "$1"; ls -la "$1"' sh {} \;


echo "Permissions updated!"
