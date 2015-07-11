#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


#Translation
export TEXTDOMAINDIR="/usr/share/locale-langpack"
export TEXTDOMAIN=kaiana-iso-generator



#Corrige o netbios do samba
if [ "$(grep "netbios name =" "$1/remaster/chroot/etc/samba/smb.conf")" != "" ]; then
  #Altera a linha netbios
  sed -i "s|.*netbios name =.*|netbios name = Kaiana|g" "$1/remaster/chroot/etc/samba/smb.conf"
else
  #Inclui a linha netbios
sed -i "\|\[global\]|{p;s|.*|netbios name = Kaiana|;}" "$1/remaster/chroot/etc/samba/smb.conf"
fi
sed -i 's|Ubuntu|Kaiana|g' "$1/remaster/chroot/etc/samba/smb.conf"




