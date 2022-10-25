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


### Mount an S3 bucket

    sudo apt-get install s3fs

    echo ACCESS_KEY_ID:SECRET_ACCESS_KEY > ${HOME}/.passwd-s3fs
    chmod 600 ${HOME}/.passwd-s3fs

    s3fs mybucket /path/to/mountpoint -o passwd_file=${HOME}/.passwd-s3fs -o allow_other -o umask=0000

You can also mount on boot by entering the following line to /etc/fstab:

    mybucket /path/to/mountpoint fuse.s3fs _netdev,allow_other,umask=0000,errors=remount 0 0


To unmount a bucket

    umount -l path