; FU_crerate-new_text-balloon.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; creates a balloon like in comics
; it sucks a bit ;-)
; (C) Copyright 2000 by Michael Spunt <t0mcat@gmx.de>

;; Version de abcdugimp.free.fr
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (round-balloon img drawable bw bh np orientation revert lw)
	(let* ((x 0))
	(if (= np FALSE) (begin
	(set! x (- (* bw 0.5) (* bw 0.2)))
	(gimp-image-select-ellipse img CHANNEL-OP-REPLACE x (* bh 0.5) (* bw 0.4) (* bh 0.4))
	(set! x (- (* bw 0.5) (* bw 0.2) (* bw orientation -0.1)))
	(gimp-image-select-ellipse img CHANNEL-OP-SUBTRACT x (* bh 0.5) (* bw 0.4) (* bh 0.4))))
	(if (= revert FALSE) (gimp-selection-translate img (* bw orientation 0.3) 0))
	(gimp-image-select-ellipse img CHANNEL-OP-ADD (* bw 0.1) (* bh 0.1) (* bw 0.8) (* bh 0.65))
	(gimp-edit-fill drawable 0)
	(gimp-selection-shrink img lw)
	(gimp-edit-fill drawable 1))
)

(define (round-think-balloon img drawable bw bh np orientation revert lw)
	(let* ((x 0))
	(if (= np FALSE) (begin
	(set! x (+ (* bw 0.5) (* bw -0.025) (* bw orientation 0.3)))
	(gimp-image-select-ellipse img CHANNEL-OP-REPLACE x (* bh 0.85) (* bw 0.05) (* bh 0.05))
	(set! x (+ (* bw 0.5) (* bw -0.05) (* bw orientation 0.2)))
	(gimp-image-select-ellipse img CHANNEL-OP-ADD x (* bh 0.75) (* bw 0.1) (* bh 0.1))))
	(if (= revert TRUE) (gimp-selection-translate img (* orientation bw -0.3) 0))
	(gimp-image-select-ellipse img CHANNEL-OP-ADD (* bw 0.1) (* bh 0.1) (* bw 0.8) (* bh 0.65))
	(gimp-edit-fill drawable 0)
	(gimp-selection-shrink img lw)
	(gimp-edit-fill drawable 1))
)

(define (script-fu-balloon bw bh np think right revert lw)
	(let* (
	(orientation 1)
	(side 1)
	(img (car (gimp-image-new bw bh RGB)))
	(balloon (car (gimp-layer-new img bw bh RGBA-IMAGE "Balloon" 100 NORMAL))))
	(if (= right FALSE) (set! orientation -1))
	(gimp-image-insert-layer img balloon 0 1)
	(gimp-display-new img)
	(gimp-edit-clear balloon)
	(if (= think FALSE) (round-balloon img balloon bw bh np orientation revert lw))
	(if (= think TRUE) (round-think-balloon img balloon bw bh np orientation revert lw))
	(gimp-selection-none img)
	(gimp-displays-flush))
)

(script-fu-register "script-fu-balloon"
  "<Image>/Script-Fu/Create New/Text Balloon"
  "Creates a balloon like used in comics. Version de abcdugimp.free.fr"
  "Michael Spunt"
  "Copyright 2000, Michael Spunt"
  "May 20, 2000"
  ""
  SF-VALUE "Width"		"240"
  SF-VALUE "Height"		"160"
  SF-TOGGLE "No pointer"	FALSE
  SF-TOGGLE "Think"		FALSE
  SF-TOGGLE "Right oriented"	FALSE
  SF-TOGGLE "Change side"	FALSE
  SF-VALUE "Line width"		"2"

)
