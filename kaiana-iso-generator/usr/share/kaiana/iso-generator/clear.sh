#!/bin/bash

rm /var/lib/dbus/machine-id

# Resolve bug ao remasterizar o Ubuntu no chroot
if [ "$(dpkg-divert --list /sbin/initctl)" != "" ]
then
    rm /sbin/initctl
    dpkg-divert --rename --remove /sbin/initctl
fi


# Remove versoes antigas do kernel
ls /boot/vmlinuz-3.**.**-**-generic > list.txt
sum=$(cat list.txt | grep '[^ ]' | wc -l)

if [ $sum -gt 1 ]; then
    dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge
fi

rm list.txt


# Limpa o sistema
apt-get clean
rm -rf /tmp/*
rm /etc/resolv.conf

# Desmonta o sistema
umount /proc
umount /sys
umount /dev/pts
