; FU_effects_crosslight.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Cross light script  for GIMP 2
; based on Cross light script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/07/22
;     - Initial relase
; version 0.2  by Iccii 2001/08/09
;     - Add the Start Angle and the Number of Lighting options
; version 0.2a adapted for GIMP2  by EV
; --------------------------------------------------------------------
; 
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-cross-light
			img
			drawable
			length
			angle	
			number
			threshold
	)
  (let* (
	 (modulo fmod)			;; in R4RS way
	 (count 1)
	 (tmp-layer (car (gimp-layer-copy drawable TRUE)))
	 (target-layer (car (gimp-layer-copy drawable TRUE)))
	 (layer-mask (car (gimp-layer-create-mask target-layer WHITE-MASK)))
	 (marged-layer (car (gimp-layer-copy drawable TRUE)))
   (currentselection (car(gimp-selection-save img)))
        )

    (gimp-image-undo-group-start img)

;    (set! currentselection (car(gimp-selection-save img)))
    (gimp-selection-none img)

; these tree line were moved up by EV
    (gimp-image-insert-layer img target-layer 0 -1)
    (gimp-layer-add-mask target-layer layer-mask)
    (gimp-image-insert-layer img tmp-layer 0 -1)

    (gimp-desaturate tmp-layer)
    (gimp-threshold tmp-layer threshold 255)
   (gimp-edit-copy tmp-layer)

    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-mask 0)))
    (gimp-layer-remove-mask target-layer APPLY)

    (gimp-drawable-fill tmp-layer TRANS-IMAGE-FILL)

    (gimp-image-set-active-layer img target-layer)
    (while (<= count number)
      (let* (
             (layer-copy (car (gimp-layer-copy target-layer TRUE)))
             (degree (modulo (+ (* count (/ 360 number)) angle) 360))
            )
        (gimp-image-insert-layer img layer-copy 0 -1)  
        (if (= count 1) (gimp-image-raise-item img layer-copy)) 
        (plug-in-mblur 1 img layer-copy 0 length degree 0 0); two argyuments added for GIMP2  by EV       

        (set! marged-layer (car (gimp-image-merge-down img layer-copy 0 )))
        (gimp-item-set-name marged-layer "cross-light") ; this line was added by EV
        (set! count (+ count 1))
      ) ; end of let*
    ) ; end of while

    (gimp-image-remove-layer img target-layer)

    (gimp-layer-set-opacity marged-layer 80)
    (gimp-layer-set-mode marged-layer SCREEN-MODE)

    (gimp-image-select-item img CHANNEL-OP-REPLACE currentselection) ; these five lines are new in version 0.6a
    (if (equal? (car (gimp-selection-is-empty img)) FALSE) 
        (begin
        (gimp-selection-invert img)
        (if (equal? (car (gimp-selection-is-empty img)) FALSE) (gimp-edit-fill marged-layer 3))
        (gimp-selection-invert img)
        ))
    (gimp-image-remove-channel img currentselection)

    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register
	"FU-cross-light"
	"<Image>/Script-Fu/Effects/Cross Light"
	"Cross light effect - sort of a random criss-cross of speculars."
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Aug"
	"RGB*"
	SF-IMAGE      "Image"			0
	SF-DRAWABLE   "Drawable"		0
	SF-ADJUSTMENT _"Light Length"		'(40 1 255 1 10 0 0)
	SF-ADJUSTMENT _"Start Angle"		'(30 0 360 1 10 0 0)
	SF-ADJUSTMENT "Number of Lights"	'(4 1 16 1 2 0 1)
	SF-ADJUSTMENT _"Threshold (Bigger 1<-->255 Smaller)"  '(223 1 255 1 10 0 0)
)
