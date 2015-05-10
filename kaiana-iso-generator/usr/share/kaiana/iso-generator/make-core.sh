#!/bin/bash

# remaster.sh arquitetura versao
# Exemplo: ./remaster.sh amd64 raring
# Exemplo: ./remaster.sh i386 raring

# Cria as pastas e adiciona os arquivos basicos

rm -Rf remaster/chroot
mkdir -p remaster/chroot/var/cache/apt
mv cache remaster/chroot/var/cache/apt/archives


mkdir -p remaster/chroot
cd remaster
debootstrap --arch=$1 $2 chroot
cd ..


mkdir -p remaster/image/.disk

echo "#define DISKNAME  Kaiana
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  $1
#define ARCH$1  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1" > remaster/image/README.diskdefines



# Efetua configuracao inicial
./chroot-on.sh

# Adiciona o sources.list indicado
mkdir -p remaster/chroot/etc/apt/
cp -f "/usr/share/kaiana/iso-generator/sources.list.$2" "remaster/chroot/etc/apt/sources.list"


# Adiciona a chave do repositorio Ubuntu e instala o dbus
chroot remaster/chroot apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 12345678
chroot remaster/chroot apt-get update
chroot remaster/chroot apt-get install --yes --force-yes dbus software-properties-common


# Configuracao basica do dbus
chroot remaster/chroot dbus-uuidgen | tee remaster/chroot/var/lib/dbus/machine-id

# Roda o fix_initctl.sh
cp -f fix_initctl.sh remaster/chroot/fix_initctl.sh
chroot remaster/chroot /fix_initctl.sh
rm -f remaster/chroot/fix_initctl.sh

	
if ! [ -e "remaster/chroot/etc/lib/modules" ]
then
    # Roda o install_kernel.sh
    cp -f install_kernel.sh remaster/chroot/install_kernel.sh
    chroot remaster/chroot /install_kernel.sh
    rm -f remaster/chroot/install_kernel.sh
fi

# Adiciona repositorios complementares
cp -f repositories.sh.$2 remaster/chroot/repositories.sh
chroot remaster/chroot /repositories.sh
rm -f remaster/chroot/repositories.sh


# Roda o chroot-off.sh
./chroot-off.sh