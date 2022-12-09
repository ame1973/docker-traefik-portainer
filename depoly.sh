#!/bin/bash

echo "----------------------------------------"

echo "[INFO] START DEPLOY DOCKER Service"

if ["${serverDomain}" == ""] || ["${serverPassword}" == ""]; then
  read -p 'Portainer Panel Domain: ' portainerDomain
  read -p 'Traefik Panel Domain: ' traefikDomain
  read -p 'Traefik SSH Email: ' traefikEmail
  read -p 'Traefik login Username: ' traefikUsername
  read -p 'Traefik login Password: ' traefikPassword
else
  echo "[INFO] Using arguments"
  portainerDomain=p.${1}
  traefikDomain=t.${1}
  traefikEmail=${1}@nft-investment.io
  traefikUsername=nftiv.admin
  traefikPassword=${2}
fi

echo "Portainer Domain: ${portainerDomain}"
echo "Traefik Domain: ${traefikDomain}"
echo "Traefik SSH Email: ${traefikEmail}"
echo "Traefik login Username: ${traefikUsername}"
echo "Traefik login Password: ${traefikPassword}"

echo "----------------------------------------"

echo "[INFO] updating traefik portainer docker-compose.yml config..."
cd core
cp docker-compose.example docker-compose.yml
sed -i "s/TRAEFIK_DOMAIN/${traefikDomain}/g" docker-compose.yml
sed -i "s/PORTAINER_DOMAIN/${portainerDomain}/g" docker-compose.yml

echo "[INFO] updating traefik.yml config..."
cd ../volumes/traefik
cp traefik.example traefik.yml
sed -i "s/SSH_EMAIL_ADDRESS/${traefikEmail}/g" traefik.yml

sudo chmod 600 acme.json

echo "[INFO] updating dynamic.yml config..."
cd configurations
cp dynamic.example dynamic.yml
htpasswd -b -c password $traefikUsername $traefikPassword
password=$(head -n 1 password)
sed -i "s/NEW_AUTH_STRING/${password}/g" dynamic.yml
rm password

echo "[INFO] DEPLOY DOCKER Service DONE"

echo "[INFO] Booting up docker service..."
cd ../../../core
docker compose up -d
