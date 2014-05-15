#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Instalacao do kernel e pacotes basicos
apt-get install --yes --force-yes ubuntu-standard casper lupin-casper
apt-get install --yes --force-yes discover laptop-detect os-prober
#Verificar necessidade de assume yes
apt-get install --yes --force-yes linux-generic linux-tools-generic
# Adiciona chave do respositorio de extras do Ubuntu
apt-key adv --keyserver keyserver.ubuntu.com --recv 3E5C1192