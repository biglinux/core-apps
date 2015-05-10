#!/bin/bash

# Exemplo: ./chroot-on.sh

#Confere se existe o que ser utilizado no chroot


if ! [ -e "remaster/chroot/boot" ]
then
    exit
fi

#Restaura a cache
if [ -e "cache" ]
then
    rm -Rf remaster/chroot/var/cache/apt/archives
    mv cache remaster/chroot/var/cache/apt/archives
fi


# Efetua configuracao inicial
if [ "$(grep remaster/chroot/dev /proc/mounts)" = "" ]; then
    mount --bind /dev remaster/chroot/dev
fi

cp -f /etc/hosts remaster/chroot/etc/hosts
cp -f /etc/resolv.conf remaster/chroot/etc/resolv.conf

# Configuracao para o chroot funcionar
if [ "$(grep remaster/chroot/proc /proc/mounts)" = "" ]; then
    chroot remaster/chroot mount none -t proc /proc
fi

if [ "$(grep remaster/chroot/sys /proc/mounts)" = "" ]; then
    chroot remaster/chroot mount none -t sysfs /sys
fi

if [ "$(grep remaster/chroot/dev/pts /proc/mounts)" = "" ]; then
    chroot remaster/chroot mount none -t devpts /dev/pts
fi




# Configuracao basica do dbus
chroot remaster/chroot dbus-uuidgen | tee remaster/chroot/var/lib/dbus/machine-id

# Roda o fix_initctl.sh
cp -f fix_initctl.sh remaster/chroot/fix_initctl.sh
chroot remaster/chroot /fix_initctl.sh
rm -f remaster/chroot/fix_initctl.sh

