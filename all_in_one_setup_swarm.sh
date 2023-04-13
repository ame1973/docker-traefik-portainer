#!/bin/bash

echo "----------------------------------------"
echo "# "
echo "# ALL IN ONE SETUP SCRIPT [SWARM MODE] v1.0.1"
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

if [ "${3}" == "" ] ; then
  read -sp 'Server Panel Username: ' serverUsername
else
  serverUsername=${3}
fi

if [ "${4}" == "" ] ; then
  read -sp 'Server Panel Email: ' serverEmail
else
  serverEmail=${4}
fi

if [ $( . /etc/os-release ; echo $NAME) == "Ubuntu" ] ; then
  if [ $( . /etc/os-release ; echo $VERSION_ID) == "22.04" ] ; then
    echo "[INFO] IS UBUNTU 22.04 VERSION"
    echo "[INFO] FIX BUG: https://stackoverflow.com/questions/73397110/how-to-stop-ubuntu-pop-up-daemons-using-outdated-libraries-when-using-apt-to-i"
    sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
  fi
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

/bin/bash setup_docker_swarm.sh

/bin/bash depoly_swarm.sh $serverDomain $serverPassword $serverUsername $serverEmail

echo "[INFO] Setup done"

cd /home/ubuntu/docker-laravel-base-env

/bin/bash start_swarm.sh

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
