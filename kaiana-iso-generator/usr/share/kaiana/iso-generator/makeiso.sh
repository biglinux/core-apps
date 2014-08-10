#!/bin/bash


# Kernel e initrd para o livecd
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
mksquashfs remaster/chroot remaster/image/casper/filesystem.squashfs
printf $(du -sx --block-size=1 remaster/chroot | cut -f1) > remaster/image/casper/filesystem.size


touch remaster/image/ubuntu
mkdir remaster/image/.disk
cd remaster/image/.disk
touch base_installable
echo "full_cd/single" > cd_type
echo "Kaiana" > info
echo "http//www.uniaolivre.com" > release_notes_url
cd ..


find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt

rm -f ../kaiana.iso

mkisofs -r -V "Kaiana" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o ../kaiana.iso .

cd ../../