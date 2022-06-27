# Misc

### Initializing docker service:

    mkdir -p /etc/systemd/system/docker.service.d

    nano /etc/systemd/system/docker.service.d/http-proxy.conf


or if installed using snap (DONT EVER USE SNAP DOCKER, IT IS UTTERLY BROKEN)

    mkdir -p /etc/systemd/system/snap.docker.dockerd.service.d
    nano /etc/systemd/system/snap.docker.dockerd.service.d/http-proxy.conf


Add the following line:

    [Service]
    Environment="http://IP:PORT/"

Then

    systemctl daemon-reload
    systemctl restart docker

### Create the network

    docker network create proxy-net

### Certbot
Create geoserver-infra/certbot folder with chmod -R 755

Use geoserver.conf.template.certbot and run

    certbot certonly --webroot --webroot-path /home/avoin/geoserver-infra/certbot --debug-challenges -d gis.avoin.org

### Bi-daily certbot renewal crontab

    0 */12 * * * certbot renew --post-hook "bash --login -c 'docker-compose -f /home/avoin/geoserver-infra/docker-compose.yml restart'"
