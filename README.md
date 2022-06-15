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


Cerbot create

    certbot certonly --webroot --webroot-path /home/avoin/geoserver-infra/certbot --debug-challenges -d geoserver.avoin.org --post-hook "bash --login -c 'cd /home/avoin/geoserver-infra && docker-compose up --build --force-recreate -d'"

Certbot crontab

    0 */12 * * * certbot renew --post-hook "runuser -l avoin -c 'docker-compose -f /home/avoin/geoserver-infra/docker-compose.yml restart'"

These can be set in an .env file in the root folder.
