; FU_sharpness-softer_sharp-blur.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; Wed Oct 1 2008
; Modified to remove deprecated procedures
; and
; gimp-layer-add-mask params cut to 2 - Paul Sherman
; distributed by gimphelp.org
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Script by Mark Probst
;
;
(define (FU-sharp-blur img drw image-blur-radius edge-blur-radius edge-detect-amount edge-gamma-correction)

  (let* ((drawable-width (car (gimp-drawable-width drw)))
	 (drawable-height (car (gimp-drawable-height drw)))
	 (image (car (gimp-image-new drawable-width drawable-height RGB)))
	 (drawable (car (gimp-layer-new image drawable-width drawable-height RGB-IMAGE "Original" 100 NORMAL-MODE))))

    (gimp-image-undo-disable image)
    (gimp-image-insert-layer image drawable 0 0)

    (gimp-selection-all img)
    (gimp-edit-copy drw)
    (gimp-floating-sel-anchor (car (gimp-edit-paste drawable FALSE)))

    (let* ((overlay-layer (car (gimp-layer-copy drawable TRUE)))
	   (mask-layer (car (gimp-layer-copy drawable TRUE))))

      (gimp-image-insert-layer image overlay-layer 0 0)
      (gimp-image-insert-layer image mask-layer 0 0)

      (if (> edge-blur-radius 0)
	  (plug-in-gauss-iir TRUE img mask-layer edge-blur-radius TRUE TRUE))
      (plug-in-edge 1 img mask-layer edge-detect-amount 1 0)

      (let* ((mask-channel (car (gimp-layer-create-mask overlay-layer 0))))

	(gimp-layer-add-mask overlay-layer mask-channel)

	(gimp-edit-copy mask-layer)
	(gimp-floating-sel-anchor (car (gimp-edit-paste mask-channel FALSE)))

	(gimp-image-remove-layer image mask-layer)

	(plug-in-gauss-iir TRUE image drawable image-blur-radius TRUE TRUE)
	(gimp-levels mask-channel 0 0 255 edge-gamma-correction 0 255)
	
	(gimp-image-undo-enable image)
	(gimp-display-new image)
	(gimp-displays-flush)))))

(script-fu-register
 "FU-sharp-blur"
 "<Image>/Script-Fu/Sharpness/Softer/Sharp Blur"
 "Blur image but retain edges."
 "Mark Probst (schani@complang.tuwien.ac.at)"
 "Mark Probst"
 "2004/08/24"
 "RGB RGBA GRAY GRAYA"
 SF-IMAGE "Image" 0
 SF-DRAWABLE "Drawable" 0
 SF-ADJUSTMENT "Image blur radius" '(8 0 100 1 10 0 1)
 SF-ADJUSTMENT "Edge blur radius" '(4 0 100 1 10 0 1)
 SF-ADJUSTMENT "Edge detect amount" '(4 0 50 1 5 0 1)
 SF-ADJUSTMENT "Edge gamma correction" '(2 0 10 1 2 0 1))
