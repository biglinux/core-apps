; FU_texture_patchwork.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; edited for gimp-2.6.1 - 11/27/2008 by Paul Sherman
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Patchwork effect script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-patchwork
			img
			drawable
			type
			size
			depth
			angle
			level
	)

  (gimp-image-undo-group-start img)

  (let* (
	 (width (car (gimp-drawable-width drawable)))
	 (height (car (gimp-drawable-height drawable)))
	 (old-fg (car (gimp-context-get-foreground)))
	 (old-selection (car (gimp-selection-save img)))
	 (tmp-layer1 (car (gimp-layer-copy drawable TRUE)))
	 (tmp-layer2 (car (gimp-layer-copy drawable TRUE)))
 	 (final-layer (car (gimp-layer-copy drawable TRUE)))
	 (depth-color (list depth depth depth))
	 (radius (- (/ size 2) 1))
	 (blur   (cond ((= type 0) 1) ((= type 1) 0) ((= type 2) 0) ((= type 3) 0)))
	 (hwidth (cond ((= type 0) 1) ((= type 1) 0) ((= type 2) 2) ((= type 3) 1)))
	 (vwidth (cond ((= type 0) 1) ((= type 1) 2) ((= type 2) 0) ((= type 3) 1)))
	) ; end variable definition

   (gimp-image-insert-layer img tmp-layer1 0 -1)
   (gimp-image-insert-layer img tmp-layer2 0 -1)
   (gimp-desaturate tmp-layer2)
    (if (eqv? (car (gimp-selection-is-empty img)) FALSE)
        (begin
          (gimp-selection-invert img)
          (gimp-edit-clear tmp-layer2)
          (gimp-selection-invert img)))

    (plug-in-noisify 1 img tmp-layer2 FALSE 1.0 1.0 1.0 0)
    (plug-in-pixelize 1 img tmp-layer1 size)
    (plug-in-pixelize 1 img tmp-layer2 size)
    (gimp-levels tmp-layer2 VALUE-LUT (+ 32 (* level 2)) (- 223 (* level 2)) 1.0 0 255)
    (plug-in-grid 1 img tmp-layer2 hwidth size 0 depth-color 255
	                           vwidth size 0 depth-color 255
                                   0      0    0 '(0 0 0)    255)

    (if (= type 3)
        (let* ((selection-channel (car (gimp-selection-save img))))
          (gimp-context-set-foreground depth-color)
          (gimp-by-color-select tmp-layer2 depth-color 0 REPLACE FALSE 0 0 FALSE)
          (gimp-selection-grow img radius)
          (gimp-selection-shrink img radius)
          (gimp-edit-fill tmp-layer2 FG-IMAGE-FILL)
		  (gimp-image-select-item img CHANNEL-OP-REPLACE selection-channel)
          (gimp-image-remove-channel img selection-channel)
          (gimp-image-set-active-layer img tmp-layer2)	;; why do I need this line?
          (gimp-context-set-foreground old-fg)))
    (plug-in-gauss-iir2 1 img tmp-layer2 (+ blur hwidth) (+ blur vwidth))
    (plug-in-bump-map 1 img tmp-layer2 tmp-layer2 angle
                      30 (+ 4 level) 0 0 0 0 TRUE FALSE LINEAR)


    (gimp-layer-set-mode tmp-layer2 OVERLAY-MODE)
    (gimp-layer-set-opacity tmp-layer2 (+ level 84))
    (set! final-layer (car (gimp-image-merge-down img tmp-layer2 EXPAND-AS-NECESSARY)))
    (if (eqv? (car (gimp-drawable-has-alpha drawable)) TRUE)
        (gimp-image-select-item img CHANNEL-OP-REPLACE drawable))
;    (if (eqv? (car (gimp-selection-is-empty img)) FALSE)
;        (begin
;          (gimp-selection-invert img)
;          (gimp-edit-clear final-layer)))
    (gimp-image-select-item img CHANNEL-OP-REPLACE old-selection)
    (gimp-edit-copy final-layer)
    (gimp-image-remove-layer img final-layer)
    (gimp-floating-sel-anchor (car (gimp-edit-paste drawable 0)))
    (gimp-image-select-item img CHANNEL-OP-REPLACE old-selection)
    (gimp-image-remove-channel img old-selection)

    (gimp-context-set-foreground old-fg)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  ) ; end of let*
)

(script-fu-register "FU-patchwork"
	"<Image>/Script-Fu/Texture/Patchwork"
	"Creates patchwork image, which simulates Photoshop's Patchwork filter"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Oct"
	"RGB*"
	SF-IMAGE       "Image"	0
	SF-DRAWABLE    "Drawable"	0
	SF-OPTION      "Tile Type"    '("Normal" "Horizontal" "Vertical" "Round")
	SF-ADJUSTMENT  _"Block Size"	'(10 2 127 1 10 0 1)
	SF-ADJUSTMENT  _"Depth"	'(127 0 255 1 10 0 1)
	SF-ADJUSTMENT  _"Angle"	'(135 0 360 1 10 0 0)
	SF-ADJUSTMENT  _"Level"	'(8 0 16 1 2 0 0)
)
