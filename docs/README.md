# Misc

### Initializing docker service:

    mkdir -p /etc/systemd/system/docker.service.d

    nano /etc/systemd/system/docker.service.d/http-proxy.conf


or if installed using snap:

    mkdir -p /etc/systemd/system/snap.docker.dockerd.service.d
    nano /etc/systemd/system/snap.docker.dockerd.service.d/http-proxy.conf


Add the following line:

    [Service]
    Environment="http://IP:PORT/"

Then

    systemctl daemon-reload
    systemctl restart docker

### Bi-daily cronjob for cert renewal

    0 */12 * * * certbot renew --post-hook "runuser -l avoin -c 'docker-compose -f /home/avoin/geoserver-infra/docker-compose.yml restart'"
