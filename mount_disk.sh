#!/bin/bash

echo "----------------------------------------"
echo "[INFO] Running mount_disk.sh"


LOCATION="/home/ubuntu"
DISK_NAME="nvme1n1"

while getopts ":ld" argv
do
   case $argv in
       l)
           LOCATION=$OPTARG
           ;;
       d)
           LOCATION=$OPTARG
           ;;
       ?)
           echo "Unknown argument(s). Usage: $0 [-l install path (/home/ubuntu)] [-d disk name (nvme1n1)]"
           exit
           ;;
   esac
done

shift $((OPTIND-1))

DEFAULT="n"
if [ "${1}" != "y" ] && [ "${1}" != "Y" ]; then
    read -p "THIS Script ONLY FOR AWS Ubuntu OS!! SURE? [y/N]: " confirm
    confirm="${confirm:-${DEFAULT}}"
    if [ "${confirm}" != "y" ] && [ "${confirm}" != "Y" ]; then
        echo "[INFO] End script"
        exit 0;
    fi
fi


if [[ $EUID > 0 ]]; then # we can compare directly with this syntax.
  echo "Please run as root/sudo"
  exit 1
fi

if test -b /dev/${DISK_NAME}; then
    echo "[INFO] Has ${DISK_NAME}"
else
    echo "[ERROR] not ${DISK_NAME}"
    exit 1
fi

if grep -qs "${LOCATION}/project" /proc/mounts; then
    echo "[INFO] /dev/${DISK_NAME} It's mounted."
    lsblk | grep ${DISK_NAME}
    exit 1
else
    echo "[INFO] /dev/${DISK_NAME} It's not mounted."
fi


sudo mkfs -t xfs /dev/${DISK_NAME}

sudo mkdir ${LOCATION}/project

sudo mount /dev/${DISK_NAME} ${LOCATION}/project

sudo cp /etc/fstab /etc/fstab.old

DISK=$(lsblk -o NAME,FSTYPE,UUID| grep xfs | awk '{print $1}')
FSTYPE=$(lsblk -o NAME,FSTYPE,UUID| grep xfs | awk '{print $2}')
UUID=$(lsblk -o NAME,FSTYPE,UUID| grep xfs | awk '{print $3}')

sudo echo "UUID=$UUID	${LOCATION}/project	$FSTYPE	defaults,nofail	0	2" >> /etc/fstab

sudo chown ubuntu ${LOCATION}/project
sudo chgrp ubuntu ${LOCATION}/project

cp ${LOCATION}/docker-traefik-portainer/shell/up_all.sh ${LOCATION}/project/up_all.sh
cp ${LOCATION}/docker-traefik-portainer/shell/down_all.sh ${LOCATION}/project/down_all.sh

echo "[INFO] Mount Disk DONE"