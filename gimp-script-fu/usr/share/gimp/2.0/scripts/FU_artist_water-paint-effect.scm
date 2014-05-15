; FU_artist_water-paint-effect.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
;
; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Water paint effect script  for GIMP 2.4
; Original author: Iccii <iccii@hotmail.com>
;
; Author statement:
;
;   - Changelog -
; version 0.1  2001/04/15 iccii <iccii@hotmail.com>
;     - Initial relased
; version 0.1a 2001/07/20 iccii <iccii@hotmail.com>
;     - more simple
; Receved as completely broken, doing just gausian blur. Fixed to 
; do something that may have been the authors intent.
;
; --------------------------------------------------------------------
; 
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-water-paint-effect
			inImage
			inDrawable
			inEffect
			flatten)
			
	(define theNewlayer) 
	(define origlayer)
	(define nlayer)
  	(gimp-image-undo-group-start inImage)
	
    (set! theNewlayer (car (gimp-layer-copy inDrawable 1)))
	(set! origlayer (car (gimp-layer-copy inDrawable 1)))
	
  	(plug-in-gauss-iir2 1 inImage inDrawable inEffect inEffect)
  	(gimp-image-insert-layer inImage theNewlayer 0 -1)
  	(plug-in-laplace 1 inImage theNewlayer)
  	(gimp-layer-set-mode theNewlayer SUBTRACT-MODE)
  	(gimp-image-merge-down inImage theNewlayer EXPAND-AS-NECESSARY)
	
	(if (= flatten FALSE)
		(begin
			(set! nlayer (car (gimp-image-get-active-layer inImage)))
			(gimp-image-insert-layer inImage origlayer 0 -1)
			(gimp-image-lower-item-to-bottom inImage origlayer)
			(gimp-image-set-active-layer inImage nlayer)
			(gimp-item-set-name nlayer "Watercolor Layer")))
  
  	(gimp-image-undo-group-end inImage)
  	(gimp-displays-flush)
)

(script-fu-register "FU-water-paint-effect"
	"<Image>/Script-Fu/Artist/WaterColor"
	"draw with water paint effect"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"Jul, 2001"
	"RGB*, GRAY*"
	SF-IMAGE	"Image"		0
	SF-DRAWABLE	"Drawable"	0
	SF-ADJUSTMENT	"Effect Size (pixels)"	'(5 0 32 1 10 0 0)
	SF-TOGGLE     "Flatten Image when complete" 		TRUE
)
