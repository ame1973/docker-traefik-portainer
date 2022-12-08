#!/bin/bash

read -p 'Server Domain: ' serverDomain
read -sp 'Server Password: ' serverPassword

apt update && apt upgrade -y

apt install sudo git curl -y

git clone https://github.com/ame1973/docker-traefik-portainer.git

git clone https://github.com/ame1973/docker-laravel-base-env.git


# Install Docker

cd docker-traefik-portainer

/bin/bash mount_disk.sh Y

/bin/bash setup_docker.sh

/bin/bash depoly.sh $serverDomain $serverPassword

/bin/bash test.sh