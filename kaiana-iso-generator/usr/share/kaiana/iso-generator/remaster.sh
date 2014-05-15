#!/bin/bash

# remaster.sh arquitetura versao
# Exemplo: ./remaster.sh amd64 raring
# Exemplo: ./remaster.sh i386 raring

# Cria as pastas e adiciona os arquivos basicos

rm -Rf remaster/chroot
mkdir -p remaster/chroot/var/cache/apt
mv cache remaster/chroot/var/cache/apt/archives


if ! [ -e "remaster/chroot/boot" ]
then
    mkdir -p remaster/chroot
    cd remaster
    debootstrap --arch=$1 $2 chroot
    cd ..
fi

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
mount --bind /dev remaster/chroot/dev
cp /etc/hosts remaster/chroot/etc/hosts
cp /etc/resolv.conf remaster/chroot/etc/resolv.conf

# Configuracao para o chroot funcionar
chroot remaster/chroot mount none -t proc /proc
chroot remaster/chroot mount none -t sysfs /sys
chroot remaster/chroot mount none -t devpts /dev/pts

# Baixa a sources.list do site indicado, temporariamente o site do biglinux
if ! [ -e "remaster/chroot/bin/dbus-uuidgen" ]
then
    cd remaster/chroot/etc/apt/
    rm -f sources.list
    wget http://www.biglinux.com.br/ubuntu/$2/sources.list
    cd ../../../../

    # Adiciona a chave do repositorio Ubuntu e instala o dbus
    chroot remaster/chroot apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 12345678
    chroot remaster/chroot apt-get update
    chroot remaster/chroot apt-get install --yes --force-yes dbus software-properties-common
fi

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
cp -f repositories.sh remaster/chroot/repositories.sh
chroot remaster/chroot /repositories.sh
rm -f remaster/chroot/repositories.sh

# Roda o install_packages.sh
cp -f install.txt remaster/chroot/install.txt
cp -f install_packages.sh remaster/chroot/install_packages.sh
chroot remaster/chroot /install_packages.sh
rm -f remaster/chroot/install_packages.sh
rm -f remaster/chroot/apt_errors2.txt
mv -f remaster/chroot/apt_errors.txt ./apt_errors_packages.txt
mv -f remaster/chroot/apt_errors1.txt ./apt_errors_complete.txt

/apt_errors1.txt

# Roda o execute.sh
cp -f execute.sh remaster/chroot/execute.sh
chroot remaster/chroot /execute.sh
rm -f remaster/chroot/execute.sh

# Roda o clear.sh
rm -Rf cache
mv remaster/chroot/var/cache/apt/archives cache
mkdir -p remaster/chroot/var/cache/apt/archives
cp -f clear.sh remaster/chroot/clear.sh
chroot remaster/chroot /clear.sh
rm -f remaster/chroot/clear.sh

# Termina de desmontar o remaster
umount -l remaster/chroot/dev


if [ "$(cat apt_errors.txt)" != "" ]
then

    echo "#####################################
#
#
#
#
#        ERROS ENCONTRADOS
#     PACOTES NAO ENCONTRADOS
#        LISTADOS A SEGUIR
#
#####################################"


    cat apt_errors.txt
fi