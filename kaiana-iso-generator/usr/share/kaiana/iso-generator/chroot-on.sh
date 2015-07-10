#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


# Exemplo: ./chroot-on.sh /home/usuario/remaster1

#Confere se existe o que ser utilizado no chroot


if ! [ -e "$1/remaster/chroot/boot" ]
then
    exit
fi

#Restaura a cache
if [ -e "$1/cache" ]
then
    rm -Rf "$1/remaster/chroot/var/cache/apt/archives"
    mv "$1/cache" "$1/remaster/chroot/var/cache/apt/archives"
fi


# Efetua configuracao inicial
if [ "$(grep "$1/remaster/chroot/dev" /proc/mounts)" = "" ]; then
    mount --bind "/dev" "$1/remaster/chroot/dev"
fi

cp -f /etc/hosts "$1/remaster/chroot/etc/hosts"
cp -f /etc/resolv.conf "$1/remaster/chroot/etc/resolv.conf"

# Configuracao para o chroot funcionar
if [ "$(grep "$1/remaster/chroot/proc" /proc/mounts)" = "" ]; then
    chroot "$1/remaster/chroot" mount none -t proc /proc
fi

if [ "$(grep "$1/remaster/chroot/sys" /proc/mounts)" = "" ]; then
    chroot "$1/remaster/chroot" mount none -t sysfs /sys
fi

if [ "$(grep "$1/remaster/chroot/dev/pts" /proc/mounts)" = "" ]; then
    chroot "$1/remaster/chroot" mount none -t devpts /dev/pts
fi




# Configuracao basica do dbus
chroot "$1/remaster/chroot" dbus-uuidgen | tee "$1/remaster/chroot/var/lib/dbus/machine-id"

# Roda o fix_initctl.sh
cp -f "/usr/share/kaiana/iso-generator/fix_initctl.sh" "$1/remaster/chroot/fix_initctl.sh"
chroot "$1/remaster/chroot" /fix_initctl.sh
rm -f "$1/remaster/chroot/fix_initctl.sh"

