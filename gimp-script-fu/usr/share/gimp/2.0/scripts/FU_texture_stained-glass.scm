; FU_texture_stained-glass.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; edited for gimp-2.6.1 - 11/27/2008 by Paul Sherman
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Stained glass script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; You'll find that this script isn't "real" staind glass effect
; Plese tell me how to create if you know more realistic effect
; This script is only applying the mosac plugin ;-(
; --> Eddy Verlinden : tile spacing bigger and light-direction set to 270 + added copy-layer3 in screenmode
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/07/21
;     - Initial relase
; this version 9 april 2006
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-stained-glass
			img
			drawable
			tile-size
	)
  (gimp-image-undo-group-start img)
  (plug-in-mosaic 1 img drawable tile-size 0 2.5 0.65 0 270.0 0.25 TRUE TRUE 1 0 0)
  (let* (
	 (copy-layer1 (car (gimp-layer-copy drawable 1)))
	 (copy-layer2 (car (gimp-layer-copy drawable 1)))
	 (copy-layer3 (car (gimp-layer-copy drawable 1)))
        )

    (gimp-image-insert-layer img copy-layer1 0 -1)
    (gimp-image-insert-layer img copy-layer2 0 -1)
    (gimp-layer-set-mode copy-layer1 OVERLAY-MODE)
    (gimp-layer-set-mode copy-layer2 OVERLAY-MODE)
    (gimp-layer-set-opacity copy-layer1 100)
    (gimp-layer-set-opacity copy-layer2 100)
    (gimp-image-merge-down img
      (car (gimp-image-merge-down img copy-layer2 EXPAND-AS-NECESSARY))
                               EXPAND-AS-NECESSARY)
 ; )

    (gimp-image-insert-layer img copy-layer3 0 -1)
    (gimp-layer-set-mode copy-layer3 SCREEN-MODE)
    (gimp-layer-set-opacity copy-layer3 100)
    (gimp-image-merge-down img copy-layer3 EXPAND-AS-NECESSARY)
     )

  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
)

(script-fu-register "FU-stained-glass"
	"<Image>/Script-Fu/Texture/Stained Glass"
	"Create stained glass image"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Jul"
	"RGB*"
	SF-IMAGE      "Image"		0
	SF-DRAWABLE   "Drawable"	0
	SF-ADJUSTMENT "Cell Size (pixels)"   '(18 5 100 1 10 0 1)
)
