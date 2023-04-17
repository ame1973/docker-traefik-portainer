#!/bin/bash

echo "----------------------------------------"
echo "# "
echo "# ALL IN ONE SETUP SCRIPT v1.0.2"
echo "# "
echo "----------------------------------------"

if [[ $EUID > 0 ]]; then # we can compare directly with this syntax.
  echo "Please run as root/sudo"
  exit 1
fi

BASE_SERVICE=false
LOCATION="/home/ubuntu"

while getopts ":d:p:u:e:l:b" argv
do
   case $argv in
       d) # -d
           SERVER_DOMAIN=$OPTARG
           ;;
       p) # -p
           SERVER_PASSWORD=$OPTARG
           ;;
       u) # -u
           SERVER_USERNAME=$OPTARG
           ;;
       e) # -e
           SERVER_EMAIL=$OPTARG
           ;;
       b)
           BASE_SERVICE=true
           ;;
       l)
           LOCATION=$OPTARG
           ;;
       ?)
           echo "Unknown argument(s). Usage: $0 -d SERVER_DOMAIN -p SERVER_PASSWORD -u SERVER_USERNAME -e SERVER_EMAIL [-b install base service]"
           exit
           ;;
   esac
done

shift $((OPTIND-1))

if [ -z ${SERVER_DOMAIN} ]||[ -z ${SERVER_PASSWORD} ]||[ -z ${SERVER_USERNAME} ]||[ -z ${SERVER_EMAIL} ];then
        echo "Missing options,exit"
        echo "Usage: $0 -d SERVER_DOMAIN -p SERVER_PASSWORD -u SERVER_USERNAME -e SERVER_EMAIL [-b BASE_SERVICE]"
        exit 1
fi

if [ $( . /etc/os-release ; echo $NAME) == "Ubuntu" ] ; then
  if [ $( . /etc/os-release ; echo $VERSION_ID) == "22.04" ] ; then
    echo "[INFO] IS UBUNTU 22.04 VERSION"
    echo "[INFO] FIX BUG: https://stackoverflow.com/questions/73397110/how-to-stop-ubuntu-pop-up-daemons-using-outdated-libraries-when-using-apt-to-i"
    sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
  fi
fi

cd ${LOCATION}

apt update && apt upgrade -y

apt install sudo git curl -y

echo "[INFO] Clone traefik and portainer repo"

git clone https://github.com/ame1973/docker-traefik-portainer.git

# Install Docker

cd ${LOCATION}/docker-traefik-portainer

# mount disk
/bin/bash mount_disk.sh Y

# setup docker swarm
/bin/bash setup_docker.sh

/bin/bash depoly.sh $SERVER_DOMAIN $SERVER_PASSWORD $SERVER_USERNAME $SERVER_EMAIL

echo "[INFO] Setup done"

# check BASE_SERVICE is true or false
if [ $BASE_SERVICE == true ]; then
  echo "[INFO] BASE_SERVICE enable"
  git clone https://github.com/ame1973/docker-laravel-base-env.git

  cd ${LOCATION}/docker-laravel-base-env

  /bin/bash start.sh
fi

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
