#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


sed 's|$| install|g' "$1/install-drivers.txt" > /tmp/kaiana-iso-generator-install.txt
echo "
" >> /tmp/kaiana-iso-generator-install.txt
sed 's|$| install|g' "$1/install-apps.txt" >> /tmp/kaiana-iso-generator-install.txt

/usr/share/kaiana/iso-generator/chroot-on.sh "$1"

cd "$1/remaster/chroot"

#Resolve conflitos gerais de pacotes
    #Confere se o arquivo não existe
    if [ ! -e "etc/init.d" ]; then
	mkdir -p etc/init.d/
	> etc/init.d/modemmanager
    fi


#Resolve conflito ao gerar iso de 32 bits em sistema de 64 bits
ln -s /usr/lib/apt/methods usr/lib/apt/methods-kaiana

synaptic -o RootDir=. -o Install-Recommends=0 -o APT::Install-Recommends=false -o APT::Architecture=i386 -o Dir::Bin::Methods=/usr/lib/apt/methods-kaiana/ --dist-upgrade-mode --set-selections < /tmp/kaiana-iso-generator-install.txt

#Remove a gambiarra para evitar conflito de gerar iso 32 bits em sistema de 64 bits
rm -f usr/lib/apt/methods-kaiana



cd ../..

/usr/share/kaiana/iso-generator/chroot-off.sh "$1"