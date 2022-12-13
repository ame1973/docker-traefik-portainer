#!/bin/bash

echo "----------------------------------------"
echo "# "
echo "# ALL IN ONE SETUP SCRIPT"
echo "# "
echo "----------------------------------------"

if [[ $EUID > 0 ]]; then # we can compare directly with this syntax.
  echo "Please run as root/sudo"
  exit 1
fi

if [ "${1}" == "" ] ; then
  read -p 'Server Domain: ' serverDomain
else
  serverDomain=${1}
fi

if [ "${2}" == "" ] ; then
  read -sp 'Server Password: ' serverPassword
else
  serverPassword=${2}
fi

cd /home/ubuntu

apt update && apt upgrade -y

apt install sudo git curl -y

git clone https://github.com/ame1973/docker-traefik-portainer.git

git clone https://github.com/ame1973/docker-laravel-base-env.git

echo "[INFO] Clone done"

# Install Docker

cd /home/ubuntu/docker-traefik-portainer

/bin/bash mount_disk.sh Y

/bin/bash setup_docker.sh

/bin/bash depoly.sh $serverDomain $serverPassword

echo "[INFO] Setup done"

cd /home/ubuntu/docker-laravel-base-env

/bin/bash start.sh

#if [ $(dpkg --print-architecture) == "amd64" ]; then
#    echo "amd64"
#else
#    dpkg --print-architecture
#fi

echo "----------------------------------------"
echo "# "
echo "# ALL IN ONE SETUP SCRIPT DONE"
echo "# "
echo "----------------------------------------"
