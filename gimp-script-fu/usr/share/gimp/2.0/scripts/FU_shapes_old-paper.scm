; FU_shapes_old-paper.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; 12/15/2008 - fixed old function call to fontname-fontname
; Modified 10/01/2008 to remove deprecated procedures
; modified by Paul Sherman 11/22/2007
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; script by kward1979uk
;
;--------------------------------------------------------------------

(define (add-text t-colour theImage text font-size font) 
	(gimp-context-set-foreground t-colour)
	(let*(
	(selection-bounds (gimp-selection-bounds theImage))
	(sx1 (cadr selection-bounds))
	(sy1 (caddr selection-bounds))
	(sx2 (cadr (cddr selection-bounds)))
	(sy2 (caddr (cddr selection-bounds)))
	(text-layer (car (gimp-text-fontname theImage -1 0 0 text 0 TRUE font-size PIXELS font)))
	(swidth  (- sx2 sx1))
	(sheight (- sy2 sy1))
	(hdiff (/ (- sheight (car (gimp-drawable-height text-layer))) 2 ))
	(wdiff (/ (- swidth (car (gimp-drawable-width text-layer))) 2 ))
	)
	(gimp-layer-translate  text-layer (+ sx1 wdiff) (+ sy1 hdiff) )
	)
)

(define (FU-old-paper inImage inlayer distress p-colour shadow text-req text font font-size t-colour)
	(gimp-image-undo-group-start inImage)
	(let*(
		(OldFG (car (gimp-context-get-foreground)))
		(OldBG (car (gimp-context-get-background)))
		(theImage inImage)
		(theHeight (car (gimp-image-height theImage)))
		(theWidth (car (gimp-image-width theImage)))
		)
		(if 
		(= 1 (car (gimp-selection-is-empty theImage)))  
		(gimp-selection-all theImage)
		)

		(let*(
			(paper-layer (car (gimp-layer-new theImage theWidth theHeight
 				RGBA-IMAGE "paper" 100 NORMAL-MODE)))
			(rust-layer (car (gimp-layer-new theImage theWidth theHeight
 				RGBA-IMAGE "rust" 100 OVERLAY-MODE)))
			(spots-layer (car (gimp-layer-new theImage theWidth theHeight
 				RGBA-IMAGE "spots" 100 OVERLAY-MODE)))
			(noise-layer (car (gimp-layer-new theImage theWidth theHeight
 				RGBA-IMAGE "noise" 100 OVERLAY-MODE)))
			)

			(gimp-image-insert-layer theImage paper-layer 0 0)
			(gimp-drawable-fill paper-layer 3)
			(gimp-image-insert-layer theImage rust-layer 0 0)
			(gimp-drawable-fill rust-layer 3)
			(gimp-image-insert-layer theImage spots-layer 0 0)
			(gimp-drawable-fill spots-layer 3)
			(gimp-image-insert-layer theImage noise-layer 0 0)
			(gimp-drawable-fill noise-layer 3)
			(if (= distress TRUE) (script-fu-distress-selection theImage paper-layer 127 8 4 2 TRUE TRUE))

			(gimp-context-set-foreground p-colour)
			(gimp-edit-bucket-fill paper-layer 0 0 100 0 0 0 0)

			(gimp-context-set-pattern "Slate")
			(gimp-edit-bucket-fill rust-layer 2 0 100 0 0 0 0)


			(gimp-context-set-brush "Circle Fuzzy (13)")
			(gimp-context-set-foreground '(0 0 0))
			(gimp-edit-stroke spots-layer)

			(plug-in-plasma 1 theImage noise-layer 1369051446 1)
			(gimp-desaturate noise-layer)
			(if (= shadow TRUE) (script-fu-drop-shadow theImage noise-layer 8 8 15 '(0 0 0) 80 1))
			(if (= text-req TRUE) (add-text t-colour theImage text font-size font))
			(gimp-displays-flush) 
	))
	(gimp-image-undo-group-end inImage)
)

(script-fu-register "FU-old-paper"
	"<Image>/Script-Fu/Shapes/Old Paper"
	"Take a users selection and turns it into a old paper effect with the option of text.\n\nIf no selection is made then entire image is used."
	"Karl Ward"
	"Karl Ward"
	"Oct 2005"
	"RGB*"
	SF-IMAGE      "SF-IMAGE" 0
	SF-DRAWABLE   "SF-DRAWABLE" 0
	SF-TOGGLE     "Distress selection" TRUE
	SF-COLOR      "Paper Colour" '(207 194 162)
	SF-TOGGLE     "Apply drop-shadow" TRUE
	SF-TOGGLE     "Text Required" FALSE
	SF-STRING     "Text (IF NO TEXT LEAVE BLANK)" ""
	SF-FONT       "Font" ""
	SF-ADJUSTMENT "Font-size" '(15 10 300 1 10 0 1)
	SF-COLOR      "TEXT Colour" '(0 0 0)
)
