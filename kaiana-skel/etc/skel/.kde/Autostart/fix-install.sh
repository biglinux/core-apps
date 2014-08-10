#!/bin/bash

sed -i 's|NotShowIn=KDE;||g' ~/Desktop/ubiquity.desktop
rm -f ~/Desktop/ubiquity-kdeui.desktop 
rm -f ~/.kde/Autostart/fix-install.sh