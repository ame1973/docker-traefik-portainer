#!/bin/bash

DEFAULT="n"
read -p "THIS Script ONLY FOR AWS Ubuntu OS!! SURE? [y/N]: " confirm
confirm="${confirm:-${DEFAULT}}"
if [ "${confirm}" != "y" ] && [ "${confirm}" != "Y" ]; then
    echo "[INFO] End script"
    exit 0;
fi

sudo mkfs -t xfs /dev/nvme1n1

sudo mkdir /home/ubuntu/project
sudo mount /dev/nvme1n1 /home/ubuntu/project

sudo cp /etc/fstab /etc/fstab.old

DISK=$(lsblk -o NAME,FSTYPE,UUID| grep xfs | awk '{print $1}')
FSTYPE=$(lsblk -o NAME,FSTYPE,UUID| grep xfs | awk '{print $2}')
UUID=$(lsblk -o NAME,FSTYPE,UUID| grep xfs | awk '{print $3}')

sudo echo "UUID={$UUID}	/home/ubuntu/project	{$FSTYPE}	defaults,nofail	0	2" >> /etc/fstab

echo "[INFO] DONE!"