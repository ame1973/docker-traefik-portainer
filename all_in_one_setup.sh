#!/bin/bash

if [ "${1}" == "" ] ; then
  read -p 'Server Domain: ' serverDomain
else
  export serverDomain=${1}
fi

if [ "${2}" == "" ] ; then
  read -sp 'Server Password: ' serverPassword
else
  export serverPassword=${2}
fi


apt update && apt upgrade -y

apt install sudo git curl -y

git clone https://github.com/ame1973/docker-traefik-portainer.git

git clone https://github.com/ame1973/docker-laravel-base-env.git


# Install Docker

cd docker-traefik-portainer

/bin/bash mount_disk.sh Y

/bin/bash setup_docker.sh

/bin/bash depoly.sh "$serverDomain" "$serverPassword"

/bin/bash test.sh "$serverDomain"

if [ dpkg --print-architecture == "amd64" ]; then
    echo "amd64"
else
    echo dpkg --print-architecture
fi