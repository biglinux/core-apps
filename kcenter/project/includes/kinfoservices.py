#!/usr/bin/python
# -*- coding: utf-8 -*-
 
import os, commands, base64
from xdg.DesktopEntry import *
from xdg.IconTheme import *

def getservices(imagesize=32):
	 
	# get list of files and current icon themes
	files = commands.getoutput("grep -l kcmshell4 /usr/share/kde4/services/*.desktop").splitlines()
	current_theme = commands.getoutput("kreadconfig --group 'Icons' --key 'Theme'")

	services = []
	 
	# get informations from files
	for file in files:
	   
		entry = DesktopEntry()
	   
		# parse file
		try:
			entry.parse(file)
		except ParsingError, e:
			continue
		   
		# data from file
		name = entry.getName()
		comment = entry.getComment()
		icon = str(getIconPath(entry.getIcon(), theme=current_theme, size=int(imagesize)))
		filename = os.path.splitext(os.path.basename(file))[0]

		# encode icon
		if icon != "None":
			with open(icon, "rb") as image_file:
				icon = base64.b64encode(image_file.read())
		
		services.append({"filename": filename, "comment": comment, "icon": icon, "name": name})
		
	return services
	
#print getservices()
