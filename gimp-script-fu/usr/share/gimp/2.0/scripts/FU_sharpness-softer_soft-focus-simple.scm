; FU_sharpness-softer_soft-focus-simple.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Soft focus script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/07/22
;     - Initial relase
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-soft-focus-simple
		img
		drawable
		blur
	)
  (let* (
		(layer-copy (car (gimp-layer-copy drawable TRUE)))
		(layer-mask (car (gimp-layer-create-mask layer-copy WHITE-MASK)))
		)

		(gimp-image-undo-group-start img)
		(gimp-image-insert-layer img layer-copy 0 -1)
		(gimp-layer-add-mask layer-copy layer-mask)
		(gimp-edit-copy layer-copy)
		(gimp-floating-sel-anchor (car (gimp-edit-paste layer-mask 0)))
		(gimp-layer-remove-mask layer-copy APPLY)
		(plug-in-gauss-iir2 1 img layer-copy blur blur)
		(gimp-layer-set-opacity layer-copy 80)
		(gimp-layer-set-mode layer-copy SCREEN-MODE)
		(gimp-image-undo-group-end img)
		(gimp-displays-flush)
	)
)

(script-fu-register
	"FU-soft-focus-simple"
	"<Image>/Script-Fu/Sharpness/Softer/Soft Focus Simple"
	"Soft focus effect"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Jul"
	"RGB* GRAYA"
	SF-IMAGE      "Image"		0
	SF-DRAWABLE   "Drawable"	0
	SF-ADJUSTMENT _"Blur Amount"  '(10 1 100 1 10 0 0)
)
