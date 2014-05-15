; FU_artist_pastel.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Pastel image script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; This script is based on pastel-windows100.scm
; version 0.1  by Iccii 2001/10/19 <iccii@hotmail.com>
;     - Initial relase
; 
; Reference Book: Windows100% Magazine October, 2001
; Tamagorou's Photograph touching up class No.29
; theme 1 -- Create the Pastel image
; --------------------------------------------------------------------
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-artist-pastel
			img		
			drawable	
            Dbord           
			detail		
			length		
			amount		
			angle		
			canvas?	
			flatten	
	)

  (gimp-image-undo-group-start img)

  (let* (
	 (Dbordx  (cond ((= Dbord 0) 4) ((= Dbord 1) 0) ((= Dbord 2) 1) ((= Dbord 3) 2) ((= Dbord 4) 3) ((= Dbord 5) 5)  ))
	 (old-selection (car (gimp-selection-save img)))
	 (layer-copy0 (car (gimp-layer-copy drawable TRUE)))
	 (dummy (if (< 0 (car (gimp-layer-get-mask layer-copy0)))
                  (gimp-layer-remove-mask layer-copy0 DISCARD)))
	 (layer-copy1 (car (gimp-layer-copy layer-copy0 TRUE)))
	 (length (if (= length 1) 0 length))
	 (layer-copy2 (car (gimp-layer-copy layer-copy0 TRUE)))
	 (merged-layer (car (gimp-layer-copy drawable TRUE)))
	 (final-layer  (car (gimp-layer-copy drawable TRUE)))
	)

    (gimp-image-insert-layer img layer-copy0 0 -1)
    (gimp-image-insert-layer img layer-copy2 0 -1)
    (gimp-image-insert-layer img layer-copy1 0 -1)

    (plug-in-mblur TRUE img layer-copy0 0 length angle TRUE TRUE);
    (plug-in-mblur TRUE img layer-copy0 0 length (+ angle 180) TRUE TRUE)

    (plug-in-gauss-iir TRUE img layer-copy1 (- 16 detail) TRUE TRUE)
    (plug-in-edge TRUE img layer-copy1 6.0 0 Dbord)  
    (gimp-layer-set-mode layer-copy1 DIVIDE-MODE)
    (set! merged-layer (car (gimp-image-merge-down img layer-copy1 EXPAND-AS-NECESSARY)))
    (gimp-layer-set-mode merged-layer VALUE-MODE)
	
    (if (equal? canvas? TRUE)
        (plug-in-apply-canvas TRUE img merged-layer 0 5))
    (plug-in-unsharp-mask TRUE img layer-copy0 (+ 1 (/ length 5)) amount 0)
    (set! final-layer (car (gimp-image-merge-down img merged-layer EXPAND-AS-NECESSARY)))

    (gimp-image-select-item img CHANNEL-OP-REPLACE old-selection)
    (gimp-edit-copy final-layer)
	(gimp-item-set-name final-layer "Pastel Layer")

    (gimp-image-select-item img CHANNEL-OP-REPLACE old-selection)
    (gimp-image-remove-channel img old-selection)

	(if (= flatten TRUE)(gimp-image-flatten img))
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register "FU-artist-pastel"
	"<Image>/Script-Fu/Artist/Pastel"
	"Create the Pastel image"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Oct"
	"RGB*"
	SF-IMAGE      "Image"	         					0
	SF-DRAWABLE   "Drawable"       						0
	SF-OPTION     "Edge detection" 						'("Differential" "Sobel" "Prewitt" "Gradient" "Roberts" "Laplace")
	SF-ADJUSTMENT "Detail Level"   						'(12.0 0 15.0 0.1 0.5 1 1)
	SF-ADJUSTMENT "Sketch Length" 						'(5 0 32 1 1 0 1)
	SF-ADJUSTMENT "Sketch Amount" 						'(2.0 0 5.0 0.1 0.5 1 1)
	SF-ADJUSTMENT "Angle"          						'(45 0 180 1 15 0 0)
	SF-TOGGLE     "Add a canvas texture" 				FALSE
	SF-TOGGLE     "Flatten Image when complete" 		TRUE
 )
