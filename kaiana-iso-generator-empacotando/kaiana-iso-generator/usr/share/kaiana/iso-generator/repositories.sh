#!/bin/bash

######################
# Kaiana Iso Generator
# by Bruno Gonçalves Araujo <bigbruno@gmail.com>
# licensed under GPLv2 or greater.
# released in 07/10/2015


#Translation
export TEXTDOMAINDIR="/usr/share/locale-langpack"
export TEXTDOMAIN=kaiana-iso-generator



#Confere o primeiro parametro informado com as opções a seguir, exemplo de uso: ./script start
case "$1" in

    --list-repositories)
	for i  in  $(ls "/usr/share/kaiana/iso-generator/repositories/$2"); do
	    echo "$i"
	done
	exit
    ;;

    --list-version)
	for i  in  $(ls "/usr/share/kaiana/iso-generator/repositories"); do
	    echo "$i"
	done
	exit
    ;;


    --description)
	    "/usr/share/kaiana/iso-generator/repositories/$2/$3" --description
	exit
    ;;

    --description-all)
	for i  in  $(ls "/usr/share/kaiana/iso-generator/repositories/$2"); do
	    echo "$i"
	    "/usr/share/kaiana/iso-generator/repositories/$2/$i" --description
	    echo ""
	done
	exit
    ;;
    

    --add)
	  cp -f "/usr/share/kaiana/iso-generator/repositories/$2/$3" "$4/remaster/chroot/$3"
	  /usr/share/kaiana/iso-generator/chroot-on.sh "$4/remaster/chroot/"
	  chroot "$4/remaster/chroot/" /$3 --add
	  /usr/share/kaiana/iso-generator/chroot-off.sh "$4/remaster/chroot/"
	  rm -f "$4/remaster/chroot/$3"
	exit
    ;;


    --add-all)
	  /usr/share/kaiana/iso-generator/chroot-on.sh "$3/remaster/chroot/"

	  for i  in  $(ls "/usr/share/kaiana/iso-generator/repositories/$2"); do
	      cp -f "/usr/share/kaiana/iso-generator/repositories/$2/$i" "$3/remaster/chroot/$i"
	      chroot "$3/remaster/chroot/" /$i --add
	      rm -f "$3/remaster/chroot/$i"
	  done

	  /usr/share/kaiana/iso-generator/chroot-off.sh "$3/remaster/chroot/"
	exit
    ;;


    *)
	echo $"--list-version            for list all versions"
	echo $"--list-repositories       for list all repositories in this version, example: --list-repositories trusty"
	echo $"--description             for view repository description, example: --description trusty uniaolivre"
	echo $"--description-all         for view all repositories description, example: --description trusty"
	echo $"--add     		 for add repository in remaster, example: --add trusty uniaolivre /home/user/remaster"
	echo $"--add-all     		 for add repository in remaster, example: --add trusty /home/user/remaster"

	
	
	exit
    ;;

esac


