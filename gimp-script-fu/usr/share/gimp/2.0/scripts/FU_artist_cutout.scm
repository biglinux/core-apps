; FU_artist_cutout.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Cutout image script  for GIMP 2.2
; Copyright (C) 2007 Eddy Verlinden <eddy_verlinden@hotmail.com>
; 
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-cutout
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
         (blur (* width  smoothness 0.001 ))
	 (layer-type (car (gimp-drawable-type drawable)))
	 (layer-temp1 (car (gimp-layer-new img width height layer-type "temp1"  100 NORMAL-MODE)))
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

    (gimp-image-select-item img CHANNEL-OP-REPLACE old-selection)
    (gimp-selection-invert img)
    (if (eqv? (car (gimp-selection-is-empty img)) FALSE) ; both Empty and All are denied
        (begin
        (gimp-edit-clear layer-temp1)
        ))

    (gimp-item-set-name layer-temp1 "Cutout")
    (gimp-image-select-item img CHANNEL-OP-REPLACE old-selection)
    (gimp-image-remove-channel img old-selection)


    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register
	"FU-cutout"
	"<Image>/Script-Fu/Artist/Cutout"
	"Creates a drawing effect of soft-edged, simplified colors."
	"Eddy Verlinden <eddy_verlinden@hotmail.com>"
	"Eddy Verlinden"
	"2007, juli"
	"RGB* GRAY*"
	SF-IMAGE      "Image"	            0
	SF-DRAWABLE   "Drawable"          0
	SF-ADJUSTMENT "Colors"            '(10 4 32 1 10 0 0)
	SF-ADJUSTMENT "Smoothness"        '(8 1 20 1 1 0 0)
)

