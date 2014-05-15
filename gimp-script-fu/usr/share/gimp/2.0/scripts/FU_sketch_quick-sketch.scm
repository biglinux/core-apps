; FU_sketch_quick-sketch.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
;  Version 1.0a - 10/14/2008
;		  Modified by Paul Sherman 
;		  in accordence with post by char101 on
;		  http://registry.gimp.org/node/5921
;		  Also changed menu location.
; 10/15/2010 - bumped INDEXED* to prevent errors
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Quick sketch is a script for The GIMP
; Quick sketch turns a photo into what looks like a artists sketch
; The script is located in "<Image> / Script-Fu / Artistic / Quick sketch..."
; Last changed: 14 June 2008
; Copyright (C) 2007 Harry Phillips <script-fu@tux.com.au>
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3 of the License, or
; (at your option) any later version.  
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, you can view the GNU General Public
; License version 3 at the web site http://www.gnu.org/licenses/gpl-3.0.html
; Alternatively you can write to the Free Software Foundation, Inc., 675 Mass
; Ave, Cambridge, MA 02139, USA.
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-quick-sketch 	theImage
					theLayer
					blurAmount
					)

    ;Initiate some variables
	(let* (
	(layerCopy 0)
	(layerGrey (car (gimp-drawable-is-gray theLayer)))
	)

	;Start an undo group so the process can be undone with one undo
	(gimp-image-undo-group-start theImage)

	;Rename the layer
	(gimp-item-set-name theLayer "Original")

	;Select none
	(gimp-selection-none theImage)

	;Change the layer Greyscale if it isn't already
	(if (= layerGrey 0) (gimp-desaturate theLayer))

	(set! layerCopy (car (gimp-layer-copy theLayer 1)))

	;Copy the layer
	(gimp-image-insert-layer theImage layerCopy 0 0)

	;Rename the layer
	(gimp-item-set-name layerCopy "Dodge layer")

	;Invert the layer
	(gimp-invert layerCopy)

	;Change the layers mode
	(gimp-layer-set-mode layerCopy 16)

	;Blur the dodge layer
	(plug-in-gauss 1 theImage layerCopy blurAmount blurAmount 0)

	;Finish the undo group for the process
	(gimp-image-undo-group-end theImage)

	;Ensure the updated image is displayed now
	(gimp-displays-flush)

    
    )
)

(script-fu-register "FU-quick-sketch"
	"Quick sketch"
	"Create a sketch from a photo"
	"Harry Phillips"
	"Harry Phillips"
	"Sep. 9 2007"
	"RGB* GRAY*"
	SF-IMAGE		"Image"     0
	SF-DRAWABLE		"Drawable"  0
	SF-ADJUSTMENT	"Blur factor"      '(30 5 200 1 1 0 1)
)

(script-fu-menu-register "FU-quick-sketch" "<Image>/Script-Fu/Sketch/")
