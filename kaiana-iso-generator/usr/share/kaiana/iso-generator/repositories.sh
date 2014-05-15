#!/bin/bash


# Adiciona o repositorio do java da oracle infelizmente o java livre nao funciona muito bem com 64 bits
sudo add-apt-repository ppa:webupd8team/java -y

# Adiciona repositorio de drivers de video atualizados
#sudo add-apt-repository ppa:xorg-edgers/ppa -y

# Adiciona repositorio do google
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

# Adiciona repositorio do netflix
sudo apt-add-repository ppa:ehoover/compholio -y

 
# Adiciona repositorio União Livre
echo 'deb http://repo.uniaolivre.com/packages trusty main' > /etc/apt/sources.list.d/kaiana.list
wget http://repo.uniaolivre.com/uniaolivre.key -O- | sudo apt-key add -
 
# Adiciona o repositorio do SMPlayer
#sudo add-apt-repository ppa:rvm/smplayer -y
 
# Adiciona o repositorio do JDownloader
#sudo add-apt-repository ppa:jd-team/jdownloader -y

# Adiciona o repositorio do Firefox KDE
sudo add-apt-repository ppa:blue-shell/firefox-kde -y
sudo sed -i 's|trusty|saucy|g' /etc/apt/sources.list.d/blue-shell-firefox-kde-trusty.list

# Adiciona o repositorio do Menu Homerun Kicker
sudo add-apt-repository ppa:blue-shell/homerun -y
 
apt-get update


#Adiciona configuração para evitar falhas na instalação de pacotes
echo 'Acquire::http::timeout "10";
APT::Immediate-Configure "false";
DPkg::StopOnError "false"; 
T::Cache-Limit 2200000000;
APT { Get { Fix-Broken "true"; }; };
DPkg { Options {"--force-all";}; };
DPkg { Options {"--abort-after=9999999";}; };
DPkg::Post-Invoke {"dpkg --abort-after=9999999 --configure -a";}' > /etc/apt/apt.conf.d/18bigtweaks