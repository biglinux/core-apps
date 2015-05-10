#!/bin/bash


#Corrige o netbios do samba
if [ "$(grep "netbios name =" /etc/samba/smb.conf)" != "" ]; then
  #Altera a linha netbios
  sed -i "s|.*netbios name =.*|netbios name = Kaiana|g" /etc/samba/smb.conf
else
  #Inclui a linha netbios
sed -i "\|\[global\]|{p;s|.*|netbios name = Kaiana|;}" /etc/samba/smb.conf
fi
sed -i 's|Ubuntu|Kaiana|g' /etc/samba/smb.conf



# Executa otimizacoes do prelink
prelink -amR
