; FU_create-new_glossy-orb.scm
; version 1.0a [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
;Author: Mike Pippin
;Version: 1.0
;Homepage: Split-visionz.net
;License: Released under the GPL included in the file with the scripts.
; 
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU_glossyorb myradius bgcolor)

	(let* (
		(buffer (+ (* myradius 0.04) 5))
		(image (car (gimp-image-new (+ buffer myradius) (+ buffer myradius) RGB)))
		(shadow-layer (car (gimp-layer-new image myradius myradius RGBA-IMAGE "shadowLayer" 100 NORMAL-MODE)))
		(grad-layer (car (gimp-layer-new image myradius myradius RGBA-IMAGE "gradLayer" 100 NORMAL-MODE)))
		(dark-layer (car (gimp-layer-new image myradius myradius RGBA-IMAGE "darkLayer" 100 NORMAL-MODE)))	
		(hl-layer (car (gimp-layer-new image myradius myradius RGBA-IMAGE "hlLayer" 100 NORMAL-MODE)))
		(shrink-size (* myradius 0.01))
		(hl-width (* myradius 0.7))
		(hl-height (* myradius 0.6))
		(offset (- myradius hl-width))
		(hl-x (/ offset 2));(/ (- myradius hl-width 2)))
		(hl-y 0)
		(quarterheight (/ myradius 4))
		(blur-radius (* myradius 0.1))
	);end variable defines

	;//////////////////////////////////////
	;create layers we'll need
	(gimp-image-add-layer image shadow-layer 0)
	(gimp-edit-clear shadow-layer)

	(gimp-image-add-layer image grad-layer 0)
	(gimp-edit-clear grad-layer)

	(gimp-image-add-layer image dark-layer 0)
	(gimp-edit-clear dark-layer)

	(gimp-image-add-layer image hl-layer 0)
	(gimp-edit-clear hl-layer)

	;//////////////////////////////////////
	;offset layers to sync with later offset of drawn ellipse
	(gimp-layer-set-offsets hl-layer 3 3)
	(gimp-layer-set-offsets dark-layer 3 3)
	(gimp-layer-set-offsets grad-layer 3 3)
	(gimp-layer-set-offsets shadow-layer 3 3)

	;//////////////////////////////////////
	;shadow layer
	(gimp-ellipse-select image 3 3 myradius myradius 0 TRUE FALSE 0)
	(gimp-context-set-foreground '(0 0 0))
	(gimp-context-set-background '(0 0 0))
	(gimp-edit-bucket-fill shadow-layer 0 0 100 0 FALSE 0 0)

	;//////////////////////////////////////
	;gradient layer
	(gimp-context-set-background bgcolor)
	;(gimp-context-set-background '(255 255 255))
	(gimp-image-set-active-layer image grad-layer)
	(gimp-edit-blend grad-layer 0  0 0 100 0 0 FALSE FALSE 0 0 TRUE 0 (- 1(/ myradius 2)) 0 myradius)

	;//////////////////////////////////////
	; highlight layer
	(gimp-image-set-active-layer image hl-layer)
	(gimp-context-set-foreground '(255 255 255))
	(gimp-edit-blend hl-layer 2  0 0 100 0 0 FALSE FALSE 0 0 TRUE 0 0 0 myradius )

	;//////////////////////////////
	;dark layer
	(gimp-image-set-active-layer image dark-layer)
	(gimp-context-set-foreground '(255 255 255))
	(gimp-context-set-background '(255 255 255))
	(gimp-edit-bucket-fill dark-layer 0 0 100 0 FALSE 0 0)
	(gimp-selection-grow image shrink-size )
	(gimp-selection-feather image (/ myradius 4))
	(gimp-edit-cut dark-layer)

	;Shrink highlight layer and move to proper position
	(gimp-image-set-active-layer image hl-layer)
	(gimp-layer-scale hl-layer hl-width hl-height FALSE)
	(gimp-layer-translate hl-layer hl-x hl-y)
	(gimp-layer-set-opacity hl-layer 75)
	(gimp-layer-resize-to-image-size hl-layer)

	;Move and blur shadow layer
	(gimp-image-set-active-layer image shadow-layer)
	(gimp-layer-translate shadow-layer (/ hl-x 7) (/ hl-x 5))
	(gimp-layer-resize-to-image-size shadow-layer)
	(plug-in-gauss-rle 1 image shadow-layer blur-radius 2 2)
	(gimp-layer-set-opacity shadow-layer 70)

	(gimp-display-new image)
	(gimp-displays-flush)
	(gimp-image-clean-all image)
	(gimp-selection-none image)
	(gimp-image-merge-visible-layers image 0)

	); end LET scope
); end function DEFINE


(script-fu-register "FU_glossyorb"
	"<Image>/Script-Fu/Create New/Glossy Orb"
	"Creates a Web2.0 style gloss orb"
	"Mike Pippin"
	"copyright 2007-8, Mike Pippin"
	"Dec 2007"
	""
	SF-ADJUSTMENT _"Orb Radius" '(100 32 2000 1 10 0 1)
	SF-COLOR      "Background Color" '(38 57 200)			
)


