#!/bin/bash

echo "[INFO] Running setup_docker"

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

sudo gpasswd -a $USER docker

/usr/bin/newgrp dokcer <<EONG
echo "newgrp docker"
id
EONG

sudo usermod -aG docker $USER

docker -v

docker compose version

docker network create traefik-proxy

echo "[INFO] Setup Docker DONE"