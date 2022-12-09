#!/bin/bash

echo "----------------------------------------"
echo "[INFO] Running mount_disk.sh"

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

if test -b /dev/nvme1n1; then
    echo "[INFO] Has nvme1n1"
else
    echo "[ERROR] not nvme1n1"
    exit 1
fi

if grep -qs '/home/ubuntu/project ' /proc/mounts; then
    echo "[INFO] /dev/nvme1n1 It's mounted."
    lsblk | grep nvme1n1
    exit 1
else
    echo "[INFO] /dev/nvme1n1 It's not mounted."
fi


sudo mkfs -t xfs /dev/nvme1n1

sudo mkdir /home/ubuntu/project

sudo mount /dev/nvme1n1 /home/ubuntu/project

sudo cp /etc/fstab /etc/fstab.old

DISK=$(lsblk -o NAME,FSTYPE,UUID| grep xfs | awk '{print $1}')
FSTYPE=$(lsblk -o NAME,FSTYPE,UUID| grep xfs | awk '{print $2}')
UUID=$(lsblk -o NAME,FSTYPE,UUID| grep xfs | awk '{print $3}')

sudo echo "UUID=$UUID	/home/ubuntu/project	$FSTYPE	defaults,nofail	0	2" >> /etc/fstab

sudo chown ubuntu /home/ubuntu/project
sudo chgrp ubuntu /home/ubuntu/project

echo "[INFO] Mount Disk DONE"