ARG POSTGRES_VERSION
FROM kartoza/postgis:${POSTGRES_VERSION}

# Install raster2pgsql (included in the postgis package)
RUN apt-get update && \
    apt-get install -y --no-install-recommends postgis && \
    rm -rf /var/lib/apt/lists/*

# Ensure raster2pgsql is on the default PATH
RUN RASTER2PGSQL_PATH=$(find /usr/lib/postgresql -name raster2pgsql 2>/dev/null | head -n1) && \
    if [ -n "$RASTER2PGSQL_PATH" ] && [ ! -f /usr/local/bin/raster2pgsql ]; then \
        ln -s "$RASTER2PGSQL_PATH" /usr/local/bin/raster2pgsql; \
    fi
