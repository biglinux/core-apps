; FU_color_funky-color.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Funky color script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/12/03
;     - Initial relase
; version 0.1a by Iccii 2001/12/08
;     - Now only affects to selection area
;
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (apply-easy-glowing-effect
			img
			img-layer
			blur)

  (let* (
         (img-width (car (gimp-drawable-width img-layer)))
         (img-height (car (gimp-drawable-height img-layer)))
         (layer (car (gimp-layer-new img img-width img-height RGBA-IMAGE
                                           "Base Layer" 100 NORMAL-MODE)))
    	 (layer-copy (car (gimp-layer-copy layer TRUE)))
        )

    (gimp-image-resize img img-width img-height 0 0)
    (if (equal? (car (gimp-drawable-has-alpha img-layer)) FALSE)
        (gimp-layer-add-alpha img-layer))
    (gimp-image-insert-layer img layer 0 -1)
    (gimp-image-lower-item img layer)
    (gimp-drawable-fill layer WHITE-IMAGE-FILL)
    (set! layer (car (gimp-image-merge-down img img-layer EXPAND-AS-NECESSARY)))
    (set! layer-copy (car (gimp-layer-copy layer TRUE)))
    (gimp-image-insert-layer img layer-copy 0 -1)
    (gimp-layer-set-mode layer-copy OVERLAY-MODE)
    (plug-in-gauss-iir2 1 img layer blur blur)
    (plug-in-gauss-iir2 1 img layer-copy (+ (/ blur 2) 1) (+ (/ blur 2) 1))
    (let* ((point-num 3)
           (control_pts (cons-array (* point-num 2) 'byte)))
       (aset control_pts 0 0)
       (aset control_pts 1 0)
       (aset control_pts 2 127)
       (aset control_pts 3 255)
       (aset control_pts 4 255)
       (aset control_pts 5 0)
       (gimp-curves-spline layer VALUE-LUT (* point-num 2) control_pts)
       (gimp-curves-spline layer-copy VALUE-LUT (* point-num 2) control_pts))
    (plug-in-gauss-iir2 1 img layer (+ (* blur 2) 1) (+ (* blur 2) 1))
    (let* ((point-num 4)
           (control_pts (cons-array (* point-num 2) 'byte)))
       (aset control_pts 0 0)
       (aset control_pts 1 0)
       (aset control_pts 2 63)
       (aset control_pts 3 255)
       (aset control_pts 4 191)
       (aset control_pts 5 0)
       (aset control_pts 6 255)
       (aset control_pts 7 255)
       (gimp-curves-spline layer VALUE-LUT (* point-num 2) control_pts)
       (gimp-curves-spline layer-copy VALUE-LUT (* point-num 2) control_pts))

    (list layer layer-copy)
  )
)

(define (FU-funky-color
		img
		layer
		blur
	)

  (gimp-image-undo-group-start img)
  (let* (
	 (old-fg (car (gimp-context-get-foreground)))
	 (old-bg (car (gimp-context-get-background)))
         (old-layer-name (car (gimp-item-get-name layer)))
         (layer-list (apply-easy-glowing-effect img layer blur))
	)

    (gimp-item-set-name (car layer-list) old-layer-name)
    (gimp-item-set-name (cadr layer-list) "Change layer mode")
    (if (equal? (car (gimp-selection-is-empty img)) FALSE)
        (begin
          (gimp-selection-invert img)
          (gimp-edit-clear (cadr layer-list))
          (gimp-selection-invert img)))
    (gimp-context-set-foreground old-fg)
    (gimp-context-set-background old-bg)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)))

(script-fu-register
	"FU-funky-color"
	"<Image>/Script-Fu/Color/Funky Color"
	"Create funky color logo image"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Dec"
	"RGB*"
	SF-IMAGE     "Image"		0
	SF-DRAWABLE  "Drawable"	0
	SF-ADJUSTMENT _"Blur Amount"	'(10 1 100 1 1 0 1)
)
