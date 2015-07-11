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

# confere se é 64 ou 32 bits
if [ "$(chroot . getconf LONG_BIT)" = "32" ]; then
    synaptic -o RootDir=. -o Dir::Bin::Methods=/usr/lib/apt/methods-kaiana/ --non-interactive --hide-main-window --update-at-startup
    synaptic -o RootDir=. -o Install-Recommends=0 -o APT::Install-Recommends=false -o APT::Architecture=i386 -o Dir::Bin::Methods=/usr/lib/apt/methods-kaiana/ --dist-upgrade-mode --set-selections < /tmp/kaiana-iso-generator-install.txt
else
    synaptic -o RootDir=. -o Dir::Bin::Methods=/usr/lib/apt/methods-kaiana/ --non-interactive --hide-main-window --update-at-startup
    synaptic -o RootDir=. -o Install-Recommends=0 -o APT::Install-Recommends=false -o Dir::Bin::Methods=/usr/lib/apt/methods-kaiana/ --dist-upgrade-mode --set-selections < /tmp/kaiana-iso-generator-install.txt
fi




#Remove a gambiarra para evitar conflito de gerar iso 32 bits em sistema de 64 bits
rm -f usr/lib/apt/methods-kaiana



cd ../..

/usr/share/kaiana/iso-generator/chroot-off.sh "$1"