#!/bin/bash

./chroot-on.sh

cd remaster/chroot

#synaptic -o RootDir=. --dist-upgrade-mode --set-selections < /tmp/install.txt
konsole --nofork -e chroot .

cd ../..

./chroot-off.sh