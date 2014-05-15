; FU_distorts_wrap-effect.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
;
; Wrap paint effect Script  for GIMP 1.2
; 
; --------------------------------------------------------------------
;   - Changelog -
; version 0.1  by Iccii 2001/04/15 <iccii@hotmail.com>
;     - Initial relase
; version 0.2  by Iccii 2001/10/01 <iccii@hotmail.com>
;     - Changed menu path because this script attempts to PS's filter
;     - Added some code (if selection exists...)
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-wrap-effect
                		inImage
				inDrawable
				inRadius
				inGamma1
				inGamma2
				inSmooth
	)

	(gimp-image-undo-group-start inImage)

  (let* (
	(theOld-bg (car (gimp-context-get-background)))
	(theNewlayer (car (gimp-layer-copy inDrawable 1)))
	(old-selection (car (gimp-selection-save inImage)))
	(theLayermask (car (gimp-layer-create-mask theNewlayer BLACK-MASK)))
	)

	(gimp-item-set-name theNewlayer "Wrap effect")
	(gimp-layer-set-mode theNewlayer NORMAL-MODE)
	(gimp-image-insert-layer inImage theNewlayer 0 -1)

	(gimp-desaturate theNewlayer)
	(plug-in-gauss-iir2 1 inImage theNewlayer inRadius inRadius)
	(plug-in-edge 1 inImage theNewlayer 6.0 0 4)
	(gimp-invert theNewlayer)


	(if (eqv? inSmooth TRUE)
	    (plug-in-gauss-iir2 0 inImage theNewlayer 5 5))
	(gimp-edit-copy theNewlayer)

	(if (< 0 (car (gimp-layer-get-mask theNewlayer)))
	    (gimp-layer-remove-mask theNewlayer APPLY))
;	(set! theLayermask (car (gimp-layer-create-mask theNewlayer BLACK-MASK)))
	(gimp-layer-add-mask theNewlayer theLayermask)
	(gimp-floating-sel-anchor (car (gimp-edit-paste theLayermask 0)))

	(gimp-levels theNewlayer 0 0 255 (/ inGamma1 10) 0 255)
	(gimp-levels theNewlayer 0 0 255 (/ inGamma1 10) 0 255)
	(gimp-levels theLayermask 0 0 255 (/ inGamma2 10) 0 255)
	(gimp-levels theLayermask 0 0 255 (/ inGamma2 10) 0 255)

	(gimp-layer-remove-mask theNewlayer APPLY)
	(gimp-image-select-item inImage CHANNEL-OP-REPLACE old-selection)
	(gimp-edit-copy theNewlayer)
	(gimp-image-remove-layer inImage theNewlayer)
	(gimp-floating-sel-anchor (car (gimp-edit-paste inDrawable 0)))
	(gimp-image-select-item inImage CHANNEL-OP-REPLACE old-selection)
	(gimp-image-remove-channel inImage old-selection)

	(gimp-context-set-background theOld-bg)
	;(gimp-image-set-active-layer inImage inDrawable)
	(gimp-image-undo-group-end inImage)
	(gimp-displays-flush)
   )
)

(script-fu-register
	"FU-wrap-effect"
	"<Image>/Script-Fu/Distorts/Wrap Effect"
	"Draws with wrap effect, which simulates Photoshop's Wrap filter"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"Oct, 2001"
	"RGB*"
	SF-IMAGE	"Image"			0
	SF-DRAWABLE	"Drawable"		0
	SF-ADJUSTMENT	"Randomness"		'(10 0 32 1 10 0 0)
	SF-ADJUSTMENT	"Highlight Balance"	'(3.0 1.0 10 0.5 0.1 1 0)
	SF-ADJUSTMENT	"Edge Amount"		'(3.0 1.0 10 0.5 0.1 1 0)
	SF-TOGGLE	"Smooth"		FALSE
)


