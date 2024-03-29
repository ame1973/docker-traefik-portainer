#!/bin/bash
echo "----------------------------------------"
echo "[INFO] Running setup_docker"

LOCATION="/home/ubuntu"

while getopts ":l:" argv
do
   case $argv in
       l)
           LOCATION=$OPTARG
           ;;
       ?)
           echo "Unknown argument(s). Usage: $0 [-l install path (/home/ubuntu)]"
           exit
           ;;
   esac
done

shift $((OPTIND-1))

sudo apt update && sudo apt upgrade -y

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apache2-utils

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


sudo apt-get update && sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

#sudo apt update && sudo apt -y install docker–compose

sudo service docker start

sudo gpasswd -a ubuntu docker

/usr/bin/newgrp docker <<EONG
echo "newgrp docker"
id
EONG

sudo usermod -aG docker ubuntu

docker -v

docker compose version

echo "[INFO] Setup Docker Swarm mode"

docker swarm init

docker network create --driver overlay --attachable --scope swarm traefik_swarm

echo "alias docker-compose='docker compose'" >> ${LOCATION}/.bashrc

echo "[INFO] Setup Docker DONE"