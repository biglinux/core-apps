; FU_effects_fog.scm
; version 1.0a [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; fog script-fu,
; original by ~kward1979uk (on Deviantart, see url below:)
; http://kward1979uk.deviantart.com/art/fog-script-fu-42504446?q=boost%3Apopular%20in%3Aresources%2Fapplications%2Fgimpactions&qo=72
; 
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (fog inImage inLayer color turb opac inFlatten)
	(gimp-image-undo-group-start inImage)
	(define flat (car (gimp-image-flatten inImage)))
	(gimp-context-set-background color)
	(define width (car (gimp-drawable-width flat)))
	(define height (car (gimp-drawable-height flat)))
	(define white-layer (car (gimp-layer-new inImage width height 1 "white" opac 0)))
	(gimp-drawable-fill white-layer 1)
	(gimp-image-add-layer inImage white-layer -1)

	(define mask (car (gimp-layer-create-mask white-layer 0)))
	(gimp-layer-add-mask white-layer mask)
	(plug-in-plasma 1 inImage mask (rand 4294967295) turb)

	(if (= inFlatten TRUE)(gimp-image-flatten inImage))
	(gimp-image-undo-group-end inImage)
	(gimp-displays-flush)

); end DEFINE

(script-fu-register "fog"
	"<Image>/Script-Fu/Effects/Fog"
	"Applies a fog of chosen colour over image"
	"Karl Ward"
	"Karl Ward"
	"Nov 2006"
	"RGB*"
	SF-IMAGE      "SF-IMAGE" 0
	SF-DRAWABLE   "SF-DRAWABLE" 0
	SF-COLOR     "Fog Colour" '(255 255 255)
	SF-ADJUSTMENT "Turbulance" '(1.0 0 10 0.1 1 1 0)
	SF-ADJUSTMENT "Opacity" '(100 0 100 1 5 1 0)
	SF-TOGGLE     _"Flatten image" FALSE
)
				