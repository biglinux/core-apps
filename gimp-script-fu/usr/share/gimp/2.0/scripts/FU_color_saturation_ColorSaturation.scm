; FU_color-saturation_ColorSaturation.scm
; version 3.1 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; Modified by Paul Sherman (2nd time) 11/15/2007
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Color Saturation, V2.02
;
; Martin Egger (martin.egger@gmx.net)
; (C) 2005, Bern, Switzerland
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

(define (FU-ColorSaturation InImage InLayer InIntensity InFlatten)
	(gimp-image-undo-group-start InImage)
	(let*	(
		(factor (* InIntensity .025))
		(plus (+ 1 (* 2 factor)))
		(minus (* -1 factor))
		(ColorLayer (car (gimp-layer-copy InLayer TRUE)))
		)
		(gimp-image-insert-layer InImage ColorLayer 0 -1)
;
; Apply new color mappings to image
;
		(plug-in-colors-channel-mixer TRUE InImage ColorLayer FALSE plus minus minus minus plus minus minus minus plus)
;
; Flatten the image, if we need to
;
		(cond
			((= InFlatten TRUE) (gimp-image-merge-down InImage ColorLayer CLIP-TO-IMAGE))
			((= InFlatten FALSE) (gimp-item-set-name ColorLayer "Saturated"))
		)
	)
;
; Finish work
;
	(gimp-image-undo-group-end InImage)
	(gimp-displays-flush)
;
)
;
; Register the function with the GIMP
;
(script-fu-register
	"FU-ColorSaturation"
	"<Image>/Script-Fu/Color/Saturation/Color Saturation"
	"Saturate or desaturate color images"
	"Martin Egger (martin.egger@gmx.net)"
	"2005, Martin Egger, Bern, Switzerland"
	"15.05.2005"
	"RGB*"
	SF-IMAGE	"The Image"	0
	SF-DRAWABLE	"The Layer"	0
	SF-ADJUSTMENT	"Intensity"	'(1 -7 7 0.5 0 2 0)
	SF-TOGGLE	"Flatten Image"	FALSE
)
