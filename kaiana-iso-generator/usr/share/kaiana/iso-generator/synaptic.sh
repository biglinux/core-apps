#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


#Translation
export TEXTDOMAINDIR="/usr/share/locale-langpack"
export TEXTDOMAIN=kaiana-iso-generator


/usr/share/kaiana/iso-generator/chroot-on.sh "$1"


echo $"After acess remaster remember this, use exit command for logout terminal, we not recommend you just close window without use exit in remaster shell."

cd "$1/remaster/chroot"


#Resolve conflito ao gerar iso de 32 bits em sistema de 64 bits
ln -s /usr/lib/apt/methods usr/lib/apt/methods-kaiana

# confere se é 64 ou 32 bits
if [ "$(chroot . getconf LONG_BIT)" = "32" ]; then
    synaptic -o RootDir=. -o Install-Recommends=0 -o APT::Install-Recommends=false -o APT::Architecture=i386 -o Dir::Bin::Methods=/usr/lib/apt/methods-kaiana/
else
    synaptic -o RootDir=. -o Install-Recommends=0 -o APT::Install-Recommends=false -o Dir::Bin::Methods=/usr/lib/apt/methods-kaiana/
fi


#Remove a gambiarra para evitar conflito de gerar iso 32 bits em sistema de 64 bits
rm -f usr/lib/apt/methods-kaiana

cd ../..

/usr/share/kaiana/iso-generator/chroot-off.sh "$1"


