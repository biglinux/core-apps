; FU_sharpness-sharper_high-pass-sharpen.scm
; version 2.9 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/15/2014 on GIMP-2.8.10
;
; edit for gimp-2.4 by paul on 1/27/2008
; "peeled" from photoeffects.scm - an scm containing several scripts
; separated to more easily update and to place more easily in menus.
;
; 02/15/2014 - accomodate ibndexed images
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
; Highpass Filter Sharpening, V2.0 for GIMP 2.4
; Original author: Martin Egger (martin.egger@gmx.net)
; (C) 2005, Bern, Switzerland
;
; You can find more about Highpass Filter Sharpening at
; http://www.gimp.org/tutorials/Sketch_Effect/ and at
; http://www.retouchpro.com/forums/showthread.php?s=&threadid=3844&highlight=high+pass
;==============================================================

(define (FU-HighPassSharpen 
		InImage 
		InLayer 
		InBlur 
		InFlatten
	)
	; Save history			
	(gimp-image-undo-group-start InImage)
	(define indexed (car (gimp-drawable-is-indexed InLayer)))
	(if (= indexed TRUE)(gimp-image-convert-rgb InImage))
	
	(let*	(
		(Temp1Layer (car (gimp-layer-copy InLayer TRUE)))
		(Temp2Layer (car (gimp-layer-copy InLayer TRUE)))
		)

		(gimp-image-insert-layer InImage Temp1Layer 0 -1)
		(gimp-image-insert-layer InImage Temp2Layer 0 -1)

		(plug-in-gauss TRUE InImage Temp2Layer InBlur InBlur 0)
		(gimp-invert Temp2Layer)
		(gimp-layer-set-opacity Temp2Layer 50)

		(let*	(
			(SharpenLayer (car (gimp-image-merge-down InImage Temp2Layer CLIP-TO-IMAGE)))
			(InOpacity (+ 25 (* InBlur 2.5)))
			)

			(gimp-levels SharpenLayer HISTOGRAM-VALUE 100 150 1.0 0 255)
			(gimp-layer-set-mode SharpenLayer OVERLAY-MODE)
			(gimp-layer-set-opacity SharpenLayer InOpacity)

			; Flatten the image, if we need to
			(cond
				((= InFlatten TRUE) (gimp-image-merge-down InImage SharpenLayer CLIP-TO-IMAGE))
				((= InFlatten FALSE) (gimp-item-set-name SharpenLayer "Sharpened"))
			)
		)
	)

	; Finish work
	(gimp-image-undo-group-end InImage)
	(gimp-displays-flush)
)

(script-fu-register 
	"FU-HighPassSharpen"
	"High-Pass Sharpen"
	"Highpass Filter Sharpening - works on highlights/speculars, sort of like a 'blind' smart sharpening. Adjustable value from 1 to 20."
	"Martin Egger (martin.egger@gmx.net)"
	"2005, Martin Egger, Bern, Switzerland"
	"13.05.2005"
	"*"
	SF-IMAGE		"The Image"				0
	SF-DRAWABLE		"The Layer"				0
	SF-ADJUSTMENT	"Sharpening Strength"	'(3.0 1.0 20.0 1.0 0 2 0)
	SF-TOGGLE		"Flatten Image"			FALSE
)
(script-fu-menu-register "FU-HighPassSharpen" "<Image>/Script-Fu/Sharpness/Sharper/")
