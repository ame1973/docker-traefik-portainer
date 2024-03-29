#!/bin/bash

echo "----------------------------------------"

echo "[INFO] START DEPLOY DOCKER Service"

if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] || [ -z "${4}" ]; then
  read -p 'Portainer Panel Domain: ' portainerDomain
  read -p 'Traefik Panel Domain: ' traefikDomain
  read -p 'Traefik SSH Email: ' traefikEmail
  read -p 'Traefik login Username: ' traefikUsername
  read -p 'Traefik login Password: ' traefikPassword
else
  echo "[INFO] Using arguments"
  portainerDomain=p.${1}
  traefikDomain=t.${1}
  traefikUsername=${3}
  traefikEmail=${4}
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
cp docker-compose.swarm.example docker-compose.yml
sed -i "s/TRAEFIK_DOMAIN/${traefikDomain}/g" docker-compose.yml
sed -i "s/PORTAINER_DOMAIN/${portainerDomain}/g" docker-compose.yml

echo "[INFO] updating traefik.yml config..."
cd ../volumes/traefik
cp traefik_swarm.example traefik.yml
sed -i "s/SSH_EMAIL_ADDRESS/${traefikEmail}/g" traefik.yml

sudo chmod 600 acme.json

echo "[INFO] updating dynamic.yml config..."
cd configurations
cp dynamic.example dynamic.yml
htpasswd -b -c passwordfile $traefikUsername $traefikPassword
passwordString=$(head -n 1 passwordfile)
passwordString=$(printf '%s\n' "$passwordString" | sed -e 's/[]\/$*.^[]/\\&/g');
sed -i "s/NEW_AUTH_STRING/${passwordString}/g" dynamic.yml
rm passwordfile

echo "[INFO] DEPLOY DOCKER Service DONE"

echo "[INFO] Booting up docker service..."
cd ../../../core
docker stack deploy -c ./docker-compose.yml core
