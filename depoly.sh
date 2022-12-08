#!/bin/bash

if [ "${1}" == "" ] ; then
    read -p 'Portainer Panel Domain: ' portainerDomain
    read -p 'Traefik Panel Domain: ' traefikDomain
    read -p 'Traefik SSH Email: ' traefikEmail
    read -p 'Traefik login Username: ' traefikUsername
    read -p 'Traefik login Password: ' traefikPassword
else
    portainerDomain=p.${1}
    traefikDomain=t.${1}
    traefikEmail=${1}@nft-investment.io
    traefikUsername=nftiv.admin
    traefikPassword=${2}
fi

echo "START DEPLOY DOCKER Service"

cd core
cp docker-compose.example docker-compose.yml
sed -i "s/TRAEFIK_DOMAIN/$traefikDomain/g" docker-compose.yml
sed -i "s/PORTAINER_DOMAIN/$portainerDomain/g" docker-compose.yml

cd ../volumes/traefik
cp traefik.example traefik.yml
sed -i "s/SSH_EMAIL_ADDRESS/$traefikEmail/g" traefik.yml

sudo chmod 600 acme.json

cd configurations
cp dynamic.example dynamic.yml
htpasswd -b -c password $traefikUsername $traefikPassword
password=$(head -n 1 password)
sed -i "s/NEW_AUTH_STRING/$password/g" dynamic.yml
rm password

echo "Done!"

