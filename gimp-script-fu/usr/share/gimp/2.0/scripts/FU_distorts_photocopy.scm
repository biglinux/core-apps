; FU_distorts_photocopy.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Stamp image script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/10/01 <iccii@hotmail.com>
;     - Initial relase
; version 0.1a by Iccii 2001/10/02 <iccii@hotmail.com>
;     - Added Balance option
;     - Fixed bug in keeping transparent area
; version 0.1b by Iccii 2001/10/02 <iccii@hotmail.com>
;     - Fixed bug (get error when drawable doesn't have alpha channel)
;
; --------------------------------------------------------------------
; 
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-photocopy
			img
			drawable
			threshold1
			threshold2
			base-color
			bg-color
			balance
			smooth
	)

  (gimp-image-undo-group-start img)

  (let* (
	 (width (car (gimp-drawable-width drawable)))
	 (height (car (gimp-drawable-height drawable)))
	 (old-fg (car (gimp-context-get-foreground)))
	 (old-selection (car (gimp-selection-save img)))
	 (layer-color1 (car (gimp-layer-new img width height RGBA-IMAGE "Color1" 100 NORMAL-MODE)))
	 (layer-color2 (car (gimp-layer-new img width height RGBA-IMAGE "Color2" 100 NORMAL-MODE)))
	 (color-mask2 (car (gimp-layer-create-mask layer-color2 BLACK-MASK)))
	 (channel (car (gimp-channel-new img width height "Color" 50 '(255 0 0))))
	 (tmp 0)
	 (final-layer (car (gimp-layer-new img width height RGBA-IMAGE "Color1" 100 NORMAL-MODE)))
        )

    (gimp-image-insert-layer img layer-color1 0 -1)
    (gimp-image-insert-layer img layer-color2 0 -1)
    (gimp-layer-add-mask layer-color2 color-mask2)
    (gimp-image-insert-channel img channel 0 0)

    (gimp-selection-none img)
    (gimp-edit-copy drawable)
    (gimp-floating-sel-anchor (car (gimp-edit-paste channel 0)))
    (if (> threshold1 threshold2)
        (begin				;; always (threshold1 < threshold2)
          (set! tmp threshold2)
          (set! threshold2 threshold1)
          (set! threshold1 tmp)))
    (if (= threshold1 threshold2)
        (gimp-message "Execution error:\n Threshold1 equals to threshold2!")
        (gimp-threshold channel threshold1 threshold2))
    (gimp-edit-copy channel)

    (gimp-context-set-foreground bg-color)
    (gimp-drawable-fill layer-color1 FG-IMAGE-FILL)
    (gimp-context-set-foreground base-color)
    (gimp-drawable-fill layer-color2 FG-IMAGE-FILL)

	(gimp-image-select-item img CHANNEL-OP-REPLACE channel)
    (if (> balance 0)
      (gimp-selection-grow img balance)
      (begin
        (gimp-selection-invert img)
        (gimp-selection-grow img (abs balance))
        (gimp-selection-invert img)))
    (gimp-selection-feather img smooth)
    (gimp-selection-sharpen img)
    (gimp-edit-fill color-mask2 WHITE-IMAGE-FILL)
    (gimp-selection-none img)

    (set! final-layer (car (gimp-image-merge-down img layer-color2 EXPAND-AS-NECESSARY)))
    (if (eqv? (car (gimp-drawable-has-alpha drawable)) TRUE)
        (gimp-image-select-item img CHANNEL-OP-REPLACE drawable))
    (gimp-context-set-foreground old-fg)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register
	"FU-photocopy"
	"<Image>/Script-Fu/Distorts/Photocopy"
	"Creates photocopy image of just 2 colors (BW)"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Oct"
	"RGB*"
	SF-IMAGE      "Image"	           0
	SF-DRAWABLE   "Drawable"         0
	SF-ADJUSTMENT "Threshold (Bigger 1<-->255 Smaller)" '(127 0 255 1 10 0 0)
	SF-ADJUSTMENT "Threshold (Bigger 1<-->255 Smaller)" '(255 0 255 1 10 0 0)
	SF-COLOR      "Base Color"       '(255 255 255)
	SF-COLOR      "Background Color" '(  0   0   0)
	SF-ADJUSTMENT "Balance"          '(0 -100 100 1 10 0 1)
	SF-ADJUSTMENT "Smooth"           '(5 1 100 1 10 0 1)
)
