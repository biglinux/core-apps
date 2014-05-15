; FU_sketch_pencil-sketch.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; Modified 10/01/2008 to remove deprecated procedures
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; pencil-sketch.scm
; Jeff Trefftzs <trefftzs@tcsn.net>
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

; Changelog:
; 020113 - Version 1.1.  Added multiple choice for edge detection
; 020113 - Version 1.01. Fixed mask texture bug.
; 020113 - Version 1.0.  Initial Release.
;
; Changed on March 5, 2004 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 2.0pre3
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-pencil-sketch inImage inLayer
				 inWeight
				 inEdges
				 inMaskPat
				 inTextToggle
				 inTexture)
  (let*
      (
       (WhiteLayer (car (gimp-layer-copy inLayer TRUE)))
       (MaskedLayer (car (gimp-layer-copy inLayer TRUE)))
       (EdgeLayer (car (gimp-layer-copy inLayer TRUE)))
       (LayerMask (car (gimp-layer-create-mask MaskedLayer 0)))
       )
    
    (gimp-image-undo-group-start inImage)

    (gimp-image-insert-layer inImage WhiteLayer 0 -1)
    (gimp-image-insert-layer inImage MaskedLayer 0 -1)
    (gimp-image-insert-layer inImage EdgeLayer 0 -1)

    (gimp-item-set-name WhiteLayer "Paper Layer")
    (gimp-item-set-name MaskedLayer "Copy with layer mask")
    (gimp-item-set-name EdgeLayer "Edges from original image")

    ; Real work goes in here
    (gimp-drawable-fill WhiteLayer WHITE-FILL) ; Fill the white layer
    (if (> inTextToggle 0)
	(begin 
	  (gimp-context-set-pattern inTexture)
	  (gimp-edit-bucket-fill WhiteLayer PATTERN-BUCKET-FILL NORMAL-MODE
			    100 0 FALSE 0 0)
	  )
	)
	    
    ; Create the layer mask and put the paper pattern in it.
    (gimp-layer-add-mask MaskedLayer LayerMask)
    (gimp-context-set-pattern inMaskPat)
    (gimp-edit-bucket-fill LayerMask PATTERN-BUCKET-FILL NORMAL-MODE
		      100		; opacity
		      0			; threshold
		      FALSE		; no sample-merged
		      0 0)		; X, Y coords
    (gimp-image-unset-active-channel inImage) ; finished with it
    
    ; Now find the edges
    (gimp-image-set-active-layer inImage EdgeLayer)
    
    (cond ((= inEdges 0)		; Laplacian edges
	   (plug-in-gauss-iir TRUE inImage EdgeLayer inWeight TRUE TRUE)
	   (plug-in-laplace TRUE inImage EdgeLayer))
	  ((= inEdges 1)		; Sobel Edges
	   (plug-in-sobel TRUE inImage EdgeLayer TRUE TRUE TRUE))
	  ((= inEdges 2)		; Synthetic Edges
	   (set! tmplayer (car (gimp-layer-copy EdgeLayer TRUE)))
	   (gimp-image-insert-layer inImage tmplayer 0 -1)
	   (gimp-layer-set-mode tmplayer DIVIDE-MODE)
	   (plug-in-gauss-iir TRUE inImage tmplayer inWeight TRUE TRUE)
	   (set! EdgeLayer 
		 (car (gimp-image-merge-down inImage tmplayer
					     EXPAND-AS-NECESSARY)))
	   (gimp-levels EdgeLayer HISTOGRAM-VALUE
			(- 255 inWeight) ; low input
			255		; high input
			1.0		; gamma
			0 255)
	   )
	  )
    
    (gimp-layer-set-mode EdgeLayer DARKEN-ONLY-MODE) ; in case white bg

    (gimp-image-set-active-layer inImage inLayer)
    (gimp-image-undo-group-end inImage)
    (gimp-displays-flush)
    )
  )

(script-fu-register "FU-pencil-sketch"
	"<Image>/Script-Fu/Sketch/Pencil Sketch"
	"Creates an interesting simulation of a pencil sketch by placing a textured layer mask on the original image, above a white layer, and below a layer containing edges from the original image.\n\nThis script does most of the work, but you may want to adjust the levels of thelayer mask to vary the amount of image texture.  If you have additional edge detector plugins (such as the ipx suite), you may want to use one of them for the edges instead of the built-in laplacian.  I did not include this option, since the ipx tools are still very much beta at this time.\n\nAdditional interesting effects can be obtained by varying the levels of the Paper Layer."
	"Jeff Trefftzs"
	"Copyright 2002, Jeff Trefftzs"
	"January 12, 2002"
	"RGB* GRAY*"
	SF-IMAGE "The Image" 0
	SF-DRAWABLE "The Layer" 0
	SF-ADJUSTMENT "Line Weight (Fine) 1 <----> 128 (Thick)" 
	'(3 1 128 1 8 0 1)
	SF-OPTION "Edge Detector" '("Laplace" "Sobel" "Synthetic")
	SF-PATTERN "Image Texture" "Paper"
	SF-TOGGLE  "Textured Paper" FALSE
	SF-PATTERN "Paper Texture" "Crinkled Paper"
)
