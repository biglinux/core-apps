; FU_photo_halftone.scm
; version 1.0a [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
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

; This script adds a halftone pixel effect to an image based on the steps
; found in this tutorial: http://photoshop-tutorials.deviantart.com/art/Halftone-Pixel-Look-R-31752808
; Works only on RGB and Indexed images (with and without alpha channels)
; Added new functionality and coding techniques based on suggestions 
; of saulgoode and Photocomix at gimptalk.com
; 
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU_photo_halftone image layer useVisible dither mode opacity invertHalftone mask invertMask)
	(let* (
		(isMask nil)
		(newImage nil)
		(width nil)
		(height nil)
		(indexed nil)
		(originalLayer nil)
		(theSelection nil)
		(halftoneLayer nil)
		(halftoneLayerHolder)
		(floatingSelection nil)
		(dither-lut '#(3 0 1 2))
		(mode-lut '#( 19 0 1 3 15 4 5 16 17 18 20 21 6 7 8 9 10 11 12 13 14))   
		(maskCopy nil)   
		)
	(gimp-context-push)
	(gimp-image-undo-group-start image)

	(set! indexed (car (gimp-drawable-is-indexed layer)))

	(if (= indexed TRUE)
	  (begin
	   (gimp-image-convert-rgb image)
	  )
	)

	(set! theSelection (car (gimp-selection-save image)))
	(gimp-selection-none image)

	(set! isMask (car (gimp-layer-get-mask layer)))
	(if (<> isMask -1)
	(gimp-layer-remove-mask layer MASK-APPLY)
	)


	(if (= useVisible TRUE)
		(set! originalLayer (car (gimp-edit-copy-visible image)))
		(set! originalLayer (car (gimp-edit-copy layer)))
	)

	(set! newImage (car (gimp-edit-paste-as-new)))
	(set! originalLayer (car (gimp-image-get-active-layer newImage)))
	(gimp-layer-add-alpha originalLayer)
	(gimp-image-convert-indexed newImage (vector-ref dither-lut dither) MONO-PALETTE 0 FALSE TRUE "nil")
	(gimp-image-convert-rgb newImage)
	(set! halftoneLayer (car (gimp-edit-copy originalLayer)))
	(gimp-image-set-active-layer image layer)
	(set! halftoneLayerHolder (car (gimp-layer-copy layer TRUE)))
	(gimp-drawable-fill halftoneLayerHolder TRANSPARENT-FILL)	
	(gimp-image-add-layer image halftoneLayerHolder -1)
	(gimp-drawable-set-name halftoneLayerHolder "Halftone Layer")
	(set! floatingSelection (car (gimp-edit-paste halftoneLayerHolder TRUE))) 	
	(gimp-floating-sel-anchor floatingSelection)
	(gimp-image-set-active-layer image layer)

	(if (= mask TRUE)
	  (begin
	   (set! maskCopy (car (gimp-layer-create-mask layer ADD-COPY-MASK)))
	   (gimp-layer-create-mask halftoneLayerHolder ADD-COPY-MASK)
	   (gimp-layer-add-mask halftoneLayerHolder maskCopy)
		(if (= invertMask TRUE)
		(gimp-invert maskCopy)
		)  
	)
	)

	(if (= invertHalftone TRUE)
		(gimp-invert halftoneLayerHolder)
	)

	(gimp-layer-set-mode halftoneLayerHolder (vector-ref mode-lut mode))
	(gimp-layer-set-opacity halftoneLayerHolder opacity)
	(gimp-selection-load theSelection)
	(gimp-image-delete newImage)
	(gimp-image-remove-channel image theSelection)
	(gimp-image-undo-group-end image)
	(gimp-context-pop)
	(gimp-displays-flush)

	) ; end LET
) ; end DEFINE

(script-fu-register "FU_photo_halftone"
	"<Image>/Script-Fu/Photo/Halftone"
	"Add a halftone pixel effect to an image."
	"Fencepost"
	"Fencepost"
	"March 23, 2009"
	"RGB* INDEXED*"
	SF-IMAGE "Image" 0
	SF-DRAWABLE "Drawable" 0
	SF-TOGGLE "Use Visible Layers?" FALSE      
	SF-OPTION "Dithering Option" '("Positioned" "None" "Floyd-Steinberg (Normal)" "Floyd Steinberg (Reduced Color Bleeding)")     
	SF-OPTION "Blend Mode" 
		'( "Softlight Mode" ; 19
		   "Normal"  		; 0
		   "Dissolve"   	; 1
		   "Multiply"   	; 3
		   "Divide"     	; 15
		   "Screen"     	; 4
		   "Overlay"    	; 5
		   "Dodge"      	; 16
		   "Burn"       	; 17
		   "Hard light" 	; 18
		   "Grain extract" 	; 20
		   "Grain merge" 	; 21
		   "Difference" 	; 6
		   "Addition"   	; 7
		   "Substract"  	; 8
		   "Darken only" 	; 9
		   "Lighten only" 	; 10
		   "Hue" 			; 11
		   "Saturation" 	; 12
		   "Color" 			; 13
		   "Value" 			; 14
		   )     
	SF-ADJUSTMENT "Opacity of Blend Layer?" '(100.0 0.0 100.0 10 10 1 0)
	SF-TOGGLE "Invert Halftone Layer?" FALSE
	SF-TOGGLE "Create Mask From Original Layer?" FALSE
	SF-TOGGLE "Invert Layer Mask?" FALSE
)
