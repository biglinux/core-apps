; FU_stroked_text.scm
; version 2.8 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/15/2014 on GIMP-2.8.10
;
; 10/01/2008
; Modified to remove deprecated procedures as listed:
;     gimp-text-fontname  ==>  gimp-text-fontname-fontname
;
; Updated to Gimp2.4 (11-2007) http://gimpscripts.com
;
; Updated again to not throw error - 11/30/2007
;
; 10/15/2010 - added routine to change non-RGB to RGB image
;              	text is basically worthless if not color, and throws an 
;			error if not... so what the hell. Also changed some default values
;			for better looking text.
; 02/15/2014 - accommodate indexed images, cleaned code, relabeled to "Outlined text"
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
; NOT AVAILABLE
;==============================================================
;

(define (FU-stroked-text 
		theImage 
		theDraw 
		text 
		font 
		font-size 
		stroke 
		text-colour 
		stroke-colour
	)

  (let*
      (
		(text-layer 0)
		(textheight 0)
		(textheight2 0)
		(textwidth 0)
		(textwidth2 0)
		(stroke-layer 0)
       ))
	   
	(gimp-image-undo-group-start theImage)
    (if (not (= RGB (car (gimp-image-base-type theImage))))
			 (gimp-image-convert-rgb theImage))

	(gimp-context-set-foreground text-colour)
	(set! text-layer (gimp-text-fontname theImage -1 0 0 text 0 TRUE font-size PIXELS font))
	(set! textheight (car (gimp-drawable-height (car text-layer))))
	(set! textwidth (car (gimp-drawable-width (car text-layer))))
	(gimp-layer-resize (car text-layer) (+ textwidth (* 2 stroke)) (+ textheight (* 2 stroke)) stroke stroke)
	(gimp-layer-translate (car text-layer) stroke stroke)
	(gimp-image-select-item theImage CHANNEL-OP-REPLACE  (car text-layer))
	(gimp-selection-grow theImage stroke)
	(gimp-context-set-foreground stroke-colour)
	(set! textheight2 (car (gimp-drawable-height (car text-layer))))
	(set! textwidth2 (car (gimp-drawable-width (car text-layer))))

	(set! stroke-layer (gimp-layer-new theImage textwidth2 textheight2 1 "inset" 100 0) )
	(gimp-drawable-fill (car stroke-layer) 3)
	(gimp-image-insert-layer theImage (car stroke-layer) 0 -1)
	(gimp-edit-bucket-fill (car stroke-layer) 0 NORMAL 100 0 0 0 0 )
	(gimp-image-lower-item theImage (car stroke-layer))
	(gimp-selection-none theImage)
	(gimp-image-merge-down theImage (car text-layer) 0 )

	(gimp-image-undo-group-end theImage)
	(gimp-displays-flush)
)
(script-fu-register "FU-stroked-text"
	"<Image>/Script-Fu/Outlined text"
	"Creates outlined (stroked) text on image."
	"Karl Ward"
	"Karl Ward"
	"Feb 2006"
	"*"
	SF-IMAGE      	"SF-IMAGE" 			0
	SF-DRAWABLE   	"SF-DRAWABLE" 		0
	SF-STRING     	"Text" 				"Stroked"
	SF-FONT	      	"Font" 				"Sans"
	SF-ADJUSTMENT	"Font-size" 		'(80 1 300 1 10 0 1)
	SF-ADJUSTMENT   "Stroke"    		'(3 1 20 1 1 1 0)
	SF-COLOR		"Text colour" 		'(70 180 243)
	SF-COLOR		"Stroke colour" 	'(0 0 0)
)
				
