#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


/usr/share/kaiana/iso-generator/chroot-on.sh "$1"

cd "$1/remaster/chroot"

#konsole --nofork -e chroot .

chroot .

cd ../..

/usr/share/kaiana/iso-generator/chroot-off.sh "$1"