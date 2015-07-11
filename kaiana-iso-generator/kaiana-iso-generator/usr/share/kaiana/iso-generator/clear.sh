#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


rm /var/lib/dbus/machine-id

# Resolve bug ao remasterizar o Ubuntu no chroot
if [ "$(dpkg-divert --list /sbin/initctl)" != "" ]
then
    rm /sbin/initctl
    dpkg-divert --rename --remove /sbin/initctl
fi


# Limpa o sistema
apt-get clean
rm -rf /tmp/*
rm /etc/resolv.conf

# Desmonta o sistema
umount /proc
umount /sys
umount /dev/pts
