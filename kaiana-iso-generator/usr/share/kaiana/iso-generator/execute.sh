#!/bin/bash


./chroot-on.sh


# Roda o execute-in-chroot.sh
 cp -f execute-in-chroot.sh remaster/chroot/execute-in-chroot.sh
 chroot remaster/chroot /execute-in-chroot.sh
 rm -f remaster/chroot/execute-in-chroot.sh

# Roda o chroot-off.sh
./chroot-off.sh