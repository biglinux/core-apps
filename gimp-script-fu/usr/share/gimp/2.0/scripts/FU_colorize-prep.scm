; FU_colorize-prep.scm
; version 2.9 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/15/2014 on GIMP-2.8.10

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
; Creates layer over original to use for 
; colorization, both layers in MULTIPLY-MODE.
; Will flatten any layers prior to starting...
; After script is run, choose your color and brush
; and start painting. Just a handy shortcut, 
; especially useful when colorizing line art.
;
; (c)2008-2014 by Paul Sherman
; distributed by gimphelp.org
;==============================================================

;

(define (FU-colorize-prep 
		image 
		layer
	)
	(gimp-image-undo-group-start image)
	(if (not (= RGB (car (gimp-image-base-type image))))
		    	 (gimp-image-convert-rgb image))
	
	(gimp-selection-all image)
	(gimp-layer-flatten layer)
	; now ready to go...
	(gimp-layer-add-alpha layer)
	(define new-layer (car (gimp-layer-copy layer TRUE)))
	(gimp-image-insert-layer image new-layer 0 0)
	(gimp-item-set-name new-layer "Color-Me")
	(gimp-drawable-fill new-layer TRANSPARENT-FILL)

	(gimp-selection-all image)
	(gimp-image-set-active-layer image new-layer)

	(gimp-layer-set-mode layer MULTIPLY-MODE)
	(gimp-layer-set-mode new-layer MULTIPLY-MODE)
	(gimp-displays-flush)
	(gimp-image-undo-group-end image))


(script-fu-register "FU-colorize-prep"
	"<Image>/Script-Fu/Prepare for Colorize"
    "Creates layer to paint over original, both layers set to multiply-mode. Top layer is transparent and you can use brush to paint without destroying edges of artwork on the original layer underneath.\n\nby Paul Sherman\ngimphelp.org" 
    "Paul Sherman"
    "(C) 2008, Paul Sherman <psherman2001@gmail.com>"
    "01/07/2008"
	"*"
	SF-IMAGE "The image" 0
	SF-DRAWABLE "The Layer" 0
)
	






