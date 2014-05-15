; FU_effects_cartoon2.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; first edit for gimp-2.4 by paul on 1/27/2008
; "peeled" from photoeffects.scm - an scm containing several scripts
; separated to more easily update and to place more easily in menus.
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Cartoon-2 script  for GIMP 2.2
; Copyright (C) 2007 Eddy Verlinden <eddy_verlinden@hotmail.com>
; 
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-cartoon2
			img
			drawable
			colors
			smoothness
	)

  (gimp-image-undo-group-start img)

  (let* (
	 (width (car (gimp-drawable-width drawable)))
	 (height (car (gimp-drawable-height drawable)))
	 (old-selection (car (gimp-selection-save img)))
	 (image-type (car (gimp-image-base-type img)))
         (blur (* width  smoothness 0.002 ))
	 (layer-type (car (gimp-drawable-type drawable)))
	 (layer-temp1 (car (gimp-layer-new img width height layer-type "temp1"  100 NORMAL-MODE)))
 	 (layer-temp3 (car (gimp-layer-new img width height layer-type "temp3"  100 NORMAL-MODE)))
	 (layer-temp4 (car (gimp-layer-new img width height layer-type "temp4"  100 NORMAL-MODE)))
    	 (img2 (car (gimp-image-new width height image-type)))
	 (layer-temp2 (car (gimp-layer-new img2 width height layer-type "temp2"  100 NORMAL-MODE)))
       ) 

    (if (eqv? (car (gimp-selection-is-empty img)) TRUE)
        (gimp-drawable-fill old-selection WHITE-IMAGE-FILL)) ; so Empty and All are the same.
    (gimp-selection-none img)
    (gimp-drawable-fill layer-temp1 TRANS-IMAGE-FILL)
    (gimp-image-insert-layer img layer-temp1 0 -1)
    (gimp-edit-copy drawable)
    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-temp1 0)))

    (plug-in-gauss 1 img layer-temp1 blur blur 0)
    (gimp-edit-copy layer-temp1)


    (gimp-image-insert-layer img2 layer-temp2 0 -1)
    (gimp-drawable-fill layer-temp2 TRANS-IMAGE-FILL)
    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-temp2 0)))
    (gimp-image-convert-indexed img2 0 0 colors 0 0 "0")
    (gimp-edit-copy layer-temp2)
    (gimp-image-delete img2)


    (gimp-layer-add-alpha layer-temp1)
    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-temp1 0)))
;------------------------------------------------
    (gimp-image-insert-layer img layer-temp3 0 -1)
    (gimp-image-insert-layer img layer-temp4 0 -1)
    (gimp-edit-copy drawable)
    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-temp3 0)))

    (gimp-desaturate layer-temp3)
    (gimp-edit-copy layer-temp3)
    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-temp4 0)))
    (gimp-invert layer-temp4)
    (plug-in-gauss 1 img layer-temp4 4 4 0)
    (gimp-layer-set-mode layer-temp4 16)
    (gimp-image-merge-down img layer-temp4 0)
    (set! layer-temp3 (car (gimp-image-get-active-layer img)))
    (gimp-levels layer-temp3 0 215 235 1.0 0 255) 
    (gimp-layer-set-mode layer-temp3 3)    
;------------------------------------------------
    (gimp-image-merge-down img layer-temp3 0)
    (set! layer-temp1 (car (gimp-image-get-active-layer img)))


    (gimp-image-select-item img CHANNEL-OP-REPLACE old-selection)
    (gimp-selection-invert img)
    (if (eqv? (car (gimp-selection-is-empty img)) FALSE) ; both Empty and All are denied
        (begin
        (gimp-edit-clear layer-temp1)
        ))

    (gimp-item-set-name layer-temp1 "Toon")
    (gimp-image-select-item img CHANNEL-OP-REPLACE old-selection)
    (gimp-image-remove-channel img old-selection)


    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register "FU-cartoon2"
	"Cartoon 2"
	"Creates a drawing effect"
	"Eddy Verlinden <eddy_verlinden@hotmail.com>"
	"Eddy Verlinden"
	"2007, juli"
	"RGB*"
	SF-IMAGE      "Image"	            0
	SF-DRAWABLE   "Drawable"          0
	SF-ADJUSTMENT "Colors"            '(16 4 32 1 10 0 0)
	SF-ADJUSTMENT "Smoothness"        '(8 1 20 1 1 0 0)
)

(script-fu-menu-register "FU-cartoon2" "<Image>/Script-Fu/Effects/")

