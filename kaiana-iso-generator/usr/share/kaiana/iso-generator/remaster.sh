#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015

# remaster.sh arquitetura versao pasta de trabalho
# Exemplo: /usr/share/kaiana/iso-generator/remaster.sh amd64 trusty "/home/user/remaster"
# Exemplo: /usr/share/kaiana/iso-generator/remaster.sh i386 trusty "/home/user/remaster"

# Cria as pastas e adiciona os arquivos basicos

cd "/usr/share/kaiana/iso-generator/"

rm -Rf "$3/remaster/chroot"
mkdir -p "$3/remaster/chroot"
cp -Rf "/usr/share/kaiana/iso-generator/image" "$3/image"
mkdir -p "$3/remaster/chroot/var/cache/apt"
mv "$3/cache" "$3/remaster/chroot/var/cache/apt/archives"


#Adiciona configuração para evitar falhas na instalação de pacotes
mkdir -p "$3/remaster/chroot/etc/apt/apt.conf.d/"
echo 'Acquire::http::timeout "10";
APT::Immediate-Configure "false";
DPkg::StopOnError "false"; 
T::Cache-Limit 2200000000;
APT { Get { Fix-Broken "true"; }; };
DPkg { Options {"--force-all";}; };
DPkg { Options {"--abort-after=9999999";}; };
DPkg::Post-Invoke {"dpkg --abort-after=9999999 --configure -a";}' > "$3/remaster/chroot/etc/apt/apt.conf.d/18bigtweaks"


debootstrap --arch=$1 $2 "$3/remaster/chroot"


mkdir -p "$3/image/.disk"

echo "#define DISKNAME  Kaiana
#define TYPE  binary
#define TYPEbinary  1
#define ARCH  $1
#define ARCH$1  1
#define DISKNUM  1
#define DISKNUM1  1
#define TOTALNUM  0
#define TOTALNUM0  1" > "$3/image/README.diskdefines"



# Efetua configuracao inicial
/usr/share/kaiana/iso-generator/chroot-on.sh "$3"

# Adiciona o sources.list indicado
mkdir -p "$3/remaster/chroot/etc/apt/"
cp -f "/usr/share/kaiana/iso-generator/sources.list.$2" "$3/remaster/chroot/etc/apt/sources.list"
cp -f "/usr/share/kaiana/iso-generator/install-apps.txt.$2" "$3/install-apps.txt"
cp -f "/usr/share/kaiana/iso-generator/install-drivers.txt.$2" "$3/install-drivers.txt"


# Adiciona a chave do repositorio Ubuntu e instala o dbus
chroot "$3/remaster/chroot" apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 12345678
chroot "$3/remaster/chroot" apt-get update
chroot "$3/remaster/chroot" apt-get install --yes --force-yes dbus software-properties-common wget


# Configuracao basica do dbus
chroot "$3/remaster/chroot" dbus-uuidgen | tee $3/chroot/var/lib/dbus/machine-id

# Roda o fix_initctl.sh
cp -f "/usr/share/kaiana/iso-generator/fix_initctl.sh" "$3/remaster/chroot/fix_initctl.sh"
chroot "$3/remaster/chroot" /fix_initctl.sh
rm -f "$3/remaster/chroot/fix_initctl.sh"

	
if ! [ -e "$3/remaster/chroot/etc/lib/modules" ]
then
    # Roda o install_kernel.sh
    cp -f "/usr/share/kaiana/iso-generator/install_kernel.sh" "$3/remaster/chroot/install_kernel.sh"
    chroot "$3/remaster/chroot" /install_kernel.sh
    rm -f "$3/remaster/chroot/install_kernel.sh"
fi


# Corrige alguns erros comuns
mkdir -p "$3/remaster/chroot/etc/init.d/modemmanager"
> "$3/remaster/chroot/etc/init.d/modemmanager"
> "$3/remaster/chroot/etc/init.d/systemd-logind"



# Roda o chroot-off.sh
/usr/share/kaiana/iso-generator/chroot-off.sh "$3"