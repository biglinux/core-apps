#!/bin/bash

# Exemplo: ./chroot-off.sh

#Confere se existe o que ser utilizado no chroot
if ! [ -e "remaster/chroot/boot" ]
then
    exit
fi

# Roda o clear.sh
if ! [ -e "cache" ]
then
    mv remaster/chroot/var/cache/apt/archives cache
fi

mkdir -p remaster/chroot/var/cache/apt/archives
cp -f clear.sh remaster/chroot/clear.sh
chroot remaster/chroot /clear.sh
rm -f remaster/chroot/clear.sh
rm -f remaster/chroot/etc/hosts
rm -f remaster/chroot/etc/resolv.conf

# Termina de desmontar o remaster
umount -l remaster/chroot/dev
umount -l remaster/chroot/proc
