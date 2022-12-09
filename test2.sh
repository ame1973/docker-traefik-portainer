#!/bin/bash

echo "----------------------------------------"

echo "[INFO] START DEPLOY DOCKER Service"

if [ -z "${1}" ] || [ -z "${2}" ]; then
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
