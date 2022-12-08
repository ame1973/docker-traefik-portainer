#!/bin/bash

apt update && apt upgrade -y

apt install sudo git curl -y

git clone https://github.com/ame1973/docker-traefik-portainer.git

git clone https://github.com/ame1973/docker-laravel-base-env.git


# Install Docker

cd docker-traefik-portainer

/bin/bash mount_disk.sh -s Y

/bin/bash setup_docker.sh

/bin/bash test.sh