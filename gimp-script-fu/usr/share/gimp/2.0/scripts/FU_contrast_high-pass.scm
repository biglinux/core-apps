; FU_contrast_high-pass.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; High pass image script  for GIMP 1.2
; Copyright (C) 2002 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
; version 0.1  by Iccii 2002/04/24 <iccii@hotmail.com>
;     - Initial relase
;
; --------------------------------------------------------------------
; 
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-highpass-image
			img
			drawable
			radius
	)

  (gimp-image-undo-group-start img)

  (let* (
	 (width (car (gimp-drawable-width drawable)))
	 (height (car (gimp-drawable-height drawable)))
	 (old-selection (car (gimp-selection-save img)))
	 (image-type (if (eqv? (car (gimp-drawable-is-gray drawable)) TRUE)
                         GRAYA-IMAGE
                         RGBA-IMAGE))
   (layer-color (car (gimp-layer-new img width height image-type "Color Invert"  50 NORMAL-MODE)))

   (currentselection (car(gimp-selection-save img)))
   (selection-flag TRUE)
        ) ; end variable definition

    (set! currentselection (car(gimp-selection-save img))) 
    (gimp-selection-none img)

    (if (eqv? (car (gimp-selection-is-empty img)) TRUE)
        (begin
          (gimp-drawable-fill old-selection WHITE-IMAGE-FILL)
          (set! selection-flag TRUE)))
    (gimp-selection-none img)
    (gimp-drawable-fill layer-color TRANS-IMAGE-FILL)
    (gimp-image-insert-layer img layer-color 0 -1)
    (gimp-edit-copy drawable)
    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-color 0)))
    (gimp-invert layer-color)
    (plug-in-gauss-iir 1 img layer-color radius TRUE TRUE)

    (gimp-image-select-item img CHANNEL-OP-REPLACE currentselection)
    (if (equal? (car (gimp-selection-is-empty img)) FALSE) 
        (begin
        (gimp-selection-invert img)
        (if (equal? (car (gimp-selection-is-empty img)) FALSE) (gimp-edit-fill layer-color 3))
        (gimp-selection-invert img)
        ))
    (gimp-image-remove-channel img currentselection)
    (gimp-image-remove-channel img old-selection)
    (gimp-image-merge-down img layer-color 0)


    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register
	"FU-highpass-image"
	"<Image>/Script-Fu/Contrast/High Pass"
	"Cuts off low-end noise"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2002, Apr"
	"RGB* GRAY*"
	SF-IMAGE      "Image"	            0
	SF-DRAWABLE   "Drawable"          0
	SF-ADJUSTMENT "Radius"            '(5 1 128 1 10 0 0)
)

