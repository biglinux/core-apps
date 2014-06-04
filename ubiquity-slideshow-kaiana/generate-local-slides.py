#!/usr/bin/python

import os, sys, glob, subprocess
import json

if len(sys.argv) > 1:
	distro = sys.argv[1]
else:
	print("Usage: %s <distro>" % sys.argv[0]);
	sys.exit(-1)

if not subprocess.call(["which", "po4a-translate"],
                       stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0:
	print("Error: po4a is not available.")
	sys.exit(1)

source_dir = '.'
po_dir = os.path.join(source_dir, 'po', distro)

build_dir = 'build'
build_slides = os.path.join(build_dir, distro, 'slides')

template_slides = glob.glob(os.path.join(build_slides, '*.html'))
template_slides.remove(os.path.join(build_slides, 'index.html'))

directory = {}

for locale_file in glob.glob( os.path.join(po_dir, '*.po') ):
	locale_name = os.path.basename(locale_file).rstrip('.po')
	locale_slides = os.path.join(build_slides, 'l10n', locale_name)
	
	print("Working on locale %s" % locale_name)
	
	directory[locale_name] = {
		'slides' : [],
		'media' : []
	}
	
	for template_slide in template_slides:
		slide_name = os.path.basename(template_slide)
		output_slide = os.path.join(locale_slides, slide_name)
		
		try:
			os.makedirs(locale_slides)
		except OSError:
			# Directory already exists
			pass
		
		if os.path.exists(output_slide):
			os.remove(output_slide)
		
		# -k 1 -> if there are any translations at all, keep it.
		subprocess.call(['po4a-translate',
			             '-M', 'UTF-8',
			             '-f', 'xhtml',
			             '-m',  template_slide,
			             '-p', locale_file,
			             '-l', output_slide,
			             '-k', '1',
			             '-o', 'attributes="data-translate"'])
		
		if os.path.exists(output_slide):
			directory[locale_name]['slides'].append(slide_name)
		else:
			#print("\t%s was not translated for locale %s" \
			#	  % (slide_name, locale_name))
			try:
				os.rmdir(locale_slides)
			except OSError:
				# Directory is not empty
				pass
	
	directory_file = open(os.path.join(build_slides, 'directory.jsonp'), 'w')
	content = json.dumps(directory)
	directory_file.write('ubiquitySlideshowDirectoryCb(%s);' % content)
	directory_file.close()

