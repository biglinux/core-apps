; FU_color-saturation_lighten_saturate.scm
; version 3.3 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/15/2014 on GIMP-2.8.10
;
; Modified again 11/15/2007
;
; Revised on 10/27/2007 to fix unbound variables 
; (required for v.2.4.0) by Paul Sherman
; 02/15/2014 - convert to RGB if needed
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
; EZ Improver script  for GIMP 2.4
; Original author: Mark Lowry
; Created on 5/22/2006 for v.2.2.8
;
; Author statement:
; A GIMP script-fu to perform a quick improvement
; to dingy, slightly underexposed images.
;
; Creates a top layer set to Saturation mode and
; a second layer set to Screen mode.
;
; If you leave the "Merge Layers" box unchecked,
; the two layers will remain on the stack and you can
; adjust the opacity of the Screen layer to suit,
; then merge down if desired.
;
; With the "Merge Layers" box checked, the layers will
; automatically merge down, and the resulting layer name
; will be "lighten_saturate layer".  If you have several
; similar images to adjust, you may wish to determine the
; desired opacity manually on the first image, then check
; the "Merge Layers" box to speed things up on the rest of
; the layers.  The script-fu input parameters are retained
; from one run to the next, so you won't have to change the
; opacity slider once you get it set the way you want it.
;==============================================================

(define (FU-lighten_saturate  
		img 
		drawable 
		merge-flag
	)

   (let* (
	     (screen-layer 0)
	     (sat-layer 0)
         (second-merge 0)
         )

	(gimp-image-undo-group-start img)
	(if (not (= RGB (car (gimp-image-base-type img))))
			 (gimp-image-convert-rgb img))

   ; CREATE THE SCREEN LAYER
   (set! screen-layer (car (gimp-layer-copy drawable 0)))
  
   ; Give it a name
   (gimp-item-set-name screen-layer "Adjust opacity, then merge this layer down first")
  
   ; Add the new layer to the image
   (gimp-image-insert-layer img screen-layer 0 0)

   ; Set opacity to 100%
   (gimp-layer-set-opacity screen-layer 100)

   ; Set the layer mode to Screen
   (gimp-layer-set-mode screen-layer SCREEN-MODE )

   ; CREATE THE SATURATION LAYER
   (set! sat-layer (car (gimp-layer-copy drawable 0)))
  
   ; Give it a name
   (gimp-item-set-name sat-layer "Merge this layer down second")
  
   ; Add the new layer to the image
   (gimp-image-insert-layer img sat-layer 0 0)

   ; Set opacity to 100%
   (gimp-layer-set-opacity sat-layer 100 )

   ; Set the layer mode to Saturation
   (gimp-layer-set-mode sat-layer SATURATION-MODE )

   ; NOW MERGE EVERYTHING DOWN IF DESIRED
   (if (equal? merge-flag TRUE)
      (gimp-image-merge-down img screen-layer 1 )
      ()
   )

   (if (equal? merge-flag TRUE)
       (set! second-merge (car(gimp-image-merge-down img sat-layer 1 )))
       ()
   )

   (if (equal? merge-flag TRUE)
       (gimp-item-set-name second-merge "Fixed with lighten_saturate layer")
 
       ()
   )
   
   (gimp-image-undo-group-end img)
   (gimp-displays-flush)
   )   
)
 
(script-fu-register "FU-lighten_saturate"
      "<Image>/Script-Fu/Color/Saturation/Lighten-Saturate"
      "Add screen layer and a saturation layer.  Works best on photos described as 'dingy' or 'dull'."
      "Script by Mark Lowry"
      "Script by Mark Lowry"
      "2007"
      "*"
      SF-IMAGE "Image" 				0
      SF-DRAWABLE "Current Layer" 	0
      SF-TOGGLE "Merge Layers?"  	FALSE
 )
