#!/bin/bash

# Resolve bug ao remasterizar o Ubuntu no chroot
if [ "$(dpkg-divert --list /sbin/initctl)" = "" ]
then
    dpkg-divert --local --rename --add /sbin/initctl
    ln -s /bin/true sbin/initctl
fi