#!/bin/bash

#Translation
export TEXTDOMAINDIR="/usr/share/locale-langpack"
export TEXTDOMAIN=kaiana-iso-generator



#Confere o primeiro parametro informado com as opções a seguir, exemplo de uso: ./script start
case "$1" in

    --list-repositories)
	for i  in  $(ls repositories/$2); do
	    echo "$i"
	done
	exit
    ;;

    --list-version)
	for i  in  $(ls repositories); do
	    echo "$i"
	done
	exit
    ;;

    *)
	echo $"--list-version            for list all versions"
	echo $"--list-repositories       for list all repositories in this version, example: --list-repositories trusty"
	exit
    ;;

esac






# apt-get update
# 
# 
# #Adiciona configuração para evitar falhas na instalação de pacotes
# echo 'Acquire::http::timeout "10";
# APT::Immediate-Configure "false";
# DPkg::StopOnError "false"; 
# T::Cache-Limit 2200000000;
# APT { Get { Fix-Broken "true"; }; };
# DPkg { Options {"--force-all";}; };
# DPkg { Options {"--abort-after=9999999";}; };
# DPkg::Post-Invoke {"dpkg --abort-after=9999999 --configure -a";}' > /etc/apt/apt.conf.d/18bigtweaks