#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apache2-utils

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


sudo apt-get update && sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo service docker start

sudo gpasswd -a $USER docker
newgrp docker
sudo usermod -aG docker $USER

sudo apt update && sudo apt -y install docker–compose

docker -v

docker–compose –version

docker network create traefik-proxy
