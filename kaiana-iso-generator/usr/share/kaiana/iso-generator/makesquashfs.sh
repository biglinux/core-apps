#!/bin/bash

# Kernel e initrd para o livecd
mkdir -p remaster/image/casper
rm -f remaster/chroot/boot/*old-dkms*
cp -f remaster/chroot/boot/vmlinuz-3.**.**-** remaster/image/casper/vmlinuz
cp -f remaster/chroot/boot/initrd.img-3.**.**-** remaster/image/casper/initrd.lz

# Gera o manifest
chroot remaster/chroot dpkg-query -W --showformat='${Package} ${Version}\n' | sudo tee remaster/image/casper/filesystem.manifest
cp -v remaster/image/casper/filesystem.manifest remaster/image/casper/filesystem.manifest-desktop
REMOVE='ubiquity kaiana-install-desktop-icon ubiquity-frontend-gtk ubiquity-frontend-kde casper lupin-casper live-initramfs user-setup discover1 xresprobe os-prober libdebian-installer4'
for i in $REMOVE 
do
        sed -i "/${i}/d" remaster/image/casper/filesystem.manifest-desktop
done

# Gera o squashfs
rm -f remaster/image/casper/filesystem.squashfs
#mksquashfs remaster/chroot remaster/image/casper/filesystem.squashfs

#XZ
mksquashfs remaster/chroot remaster/image/casper/filesystem.squashfs -comp xz -Xbcj x86 -no-xattrs -always-use-fragments -b 32768  -Xdict-size 100%


printf $(du -sx --block-size=1 remaster/chroot | cut -f1) > remaster/image/casper/filesystem.size


touch remaster/image/ubuntu
mkdir remaster/image/.disk
cd remaster/image/.disk
touch base_installable
echo "full_cd/single" > cd_type
echo "Kaiana 14.04 - i586 (20141223)" > info
echo "http//www.uniaolivre.com" > release_notes_url
cd ..
cd ../../