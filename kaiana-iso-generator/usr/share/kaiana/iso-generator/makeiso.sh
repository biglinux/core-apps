#!/bin/bash

cd remaster/image/
find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt

rm -f ../kaiana.iso

mkisofs -D -r -V "Kaiana" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../kaiana.iso .

cd ../../