# Geoserver Infra
Configuration files, scripts, and documentation for Geoserver.

## Docker

Launch Nginx server with

    docker-compose up --build

Docker-compose uses the following env variables:
    
    # required, the directory for saving nginx logs
    AVOIN_LOGS_PATH

    # required, the root directory for serving files
    AVOIN_DATA_PATH

    # optional, the port used by a running climate-map-backend service
    GEOSERVER_PORT

    # URL to Postgis server
    POSTGIS_URL


These can be set in an .env file in the root folder.
