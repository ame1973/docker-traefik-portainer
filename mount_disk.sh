#!/bin/bash

echo "----------------------------------------"
echo "[INFO] Running mount_disk.sh v1.0.0"
echo "----------------------------------------"


LOCATION="/home/ubuntu"
MOUNT_DISK_NAME="nvme1n1"


while getopts ":l:m:" argv
do
   case $argv in
       l)
           LOCATION=$OPTARG
           ;;
       m)
           MOUNT_DISK_NAME=$OPTARG
           ;;
       ?)
           echo "Unknown argument(s). Usage: $0 [-l install path (/home/ubuntu)] [-d disk name (nvme1n1)]"
           exit
           ;;
   esac
done

shift $((OPTIND-1))

echo "[INFO] LOCATION: ${LOCATION}"
echo "[INFO] DISK_NAME: ${MOUNT_DISK_NAME}"

if [[ $EUID > 0 ]]; then # we can compare directly with this syntax.
  echo "Please run as root/sudo"
  exit 1
fi

if test -b /dev/${MOUNT_DISK_NAME}; then
  echo "[INFO] Has ${MOUNT_DISK_NAME}"
else
  echo "[ERROR] not ${MOUNT_DISK_NAME}"
  exit 1
fi

if grep -qs "${LOCATION}/project" /proc/mounts; then
  echo "[INFO] /dev/${MOUNT_DISK_NAME} It's mounted."
  lsblk | grep ${MOUNT_DISK_NAME}
  exit 1
else
  echo "[INFO] /dev/${MOUNT_DISK_NAME} It's not mounted."
fi


driveCount=$(ls -l /dev/vdb* | wc -l)

if [ "$backupCount" -eq 1 ]; then
  echo "[INFO] /dev/${MOUNT_DISK_NAME} is not partitioned."
  parted /dev/${MOUNT_DISK_NAME} mklabel gpt --script
  parted /dev/${MOUNT_DISK_NAME} mkpart primary 0% 100%
else
  echo "[INFO] /dev/${MOUNT_DISK_NAME} is partitioned."
  exit 1
fi


sudo mkfs -t xfs /dev/${MOUNT_DISK_NAME}

sudo mkdir ${LOCATION}/project

sudo mount /dev/${MOUNT_DISK_NAME} ${LOCATION}/project

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