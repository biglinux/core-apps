; FU_sharpness-softer_wonderful.scm
; version 2.9 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/15/2014 on GIMP-2.8.10
;
; 10/24/2007 - tweaked to work with gimp-2.4.x by Paul Sherman 
; 12/15/2008 - Menu items in English, RGB RGBA -> RGB*
; 02/15/2014  - accommodate indexed images
;==============================================================
;
; Installation:
; This script should be placed in the user or system-wide script folder.
;
;	Windows Vista/7/8)
;	C:\Program Files\GIMP 2\share\gimp\2.0\scripts
;	or
;	C:\Users\YOUR-NAME\.gimp-2.8\scripts
;	
;	Windows XP
;	C:\Program Files\GIMP 2\share\gimp\2.0\scripts
;	or
;	C:\Documents and Settings\yourname\.gimp-2.8\scripts   
;    
;	Linux
;	/home/yourname/.gimp-2.8/scripts  
;	or
;	Linux system-wide
;	/usr/share/gimp/2.0/scripts
;
;==============================================================
;
; LICENSE
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;==============================================================
; Original information 
; 
; Copyright (C) 2000 Ingo Ruhnke <grumbel@gmx.de>
;==============================================================


(define (FU-wonderful 
		inImage 
		inDrawable 
		blurfactor 
		brightness 
		contrast 
		flatten
	)
	
  (gimp-image-undo-group-start inImage) 
  (if (not (= RGB (car (gimp-image-base-type inImage))))
			 (gimp-image-convert-rgb inImage))  
  
  (let ((new-layer (car (gimp-layer-copy inDrawable 1))))
		(gimp-image-insert-layer inImage  new-layer 0 0)
		(plug-in-gauss-iir 1 inImage new-layer blurfactor 1 1)
		(gimp-brightness-contrast new-layer brightness contrast)

		(let ((layer-mask (car (gimp-layer-create-mask inDrawable WHITE-MASK))))
		  (gimp-layer-add-mask new-layer layer-mask)
		  (gimp-edit-copy new-layer)
		  (gimp-floating-sel-anchor (car (gimp-edit-paste layer-mask 0)))
		  (gimp-layer-set-mode new-layer ADDITION)
		)
	)

  (if (= flatten TRUE)(gimp-image-flatten inImage))
  (gimp-displays-flush)
  (gimp-image-undo-group-end inImage))

(script-fu-register "FU-wonderful"
	"<Image>/Script-Fu/Sharpness/Softer/Make wonderful"
	"Creates a new tuxracer level. Version de abcdugimp.free.fr"
	"Ingo Ruhnke"
	"1999, Ingo Ruhnke"
	"2000"
	"*"
	SF-IMAGE 		"Image" 		0
	SF-DRAWABLE 	"Drawable" 		0
	SF-ADJUSTMENT 	"Blur" 			'(35 0 5600 1 100 0 1)
	SF-ADJUSTMENT 	"Luminosity" 	'(0 -127 127 1 10 0 1)
	SF-ADJUSTMENT 	"Contrast" 		'(0 -127 127 1 10 0 1)
	SF-TOGGLE 		"Flatten Image" FALSE
)
