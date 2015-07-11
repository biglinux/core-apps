#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


# Resolve bug ao remasterizar o Ubuntu no chroot
if [ "$(dpkg-divert --list /sbin/initctl)" = "" ]
then
    dpkg-divert --local --rename --add /sbin/initctl
    ln -s /bin/true sbin/initctl
fi