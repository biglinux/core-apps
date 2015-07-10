#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


# Exemplo: ./chroot-off.sh /home/usuario/remaster1

#Confere se existe o que ser utilizado no chroot
if ! [ -e "$1/remaster/chroot/boot" ]
then
    exit
fi

# Roda o clear.sh
if ! [ -e "$1/cache" ]
then
    mv "$1/remaster/chroot/var/cache/apt/archives" "$1/cache"
fi

mkdir -p "$1/remaster/chroot/var/cache/apt/archives"
cp -f "/usr/share/kaiana/iso-generator/clear.sh" "$1/remaster/chroot/clear.sh"
chroot "$1/remaster/chroot" /clear.sh
rm -f "$1/remaster/chroot/clear.sh"
rm -f "$1/remaster/chroot/etc/hosts"
rm -f "$1/remaster/chroot/etc/resolv.conf"

# Termina de desmontar o remaster
umount -l "$1/remaster/chroot/dev"
umount -l "$1/remaster/chroot/proc"
