; FU_sharpness-sharper_softfocus.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; Modified 12/18/2007 by Paul Sherman
; made compatible with GIMP-2.4
; (define(s), flatten at end and undo setup)
;
; Wed Oct 1 2008 by Paul S.
;     Modified deprecated to gimp-levels-stretch
;
; Tue Oct 14 2008 by Paul S.
;     Modified to remove passing of image parameter to gimp-layer-add-mask
;     (which only requires the layer and the mask) tested OK on GIMP-2.6
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; copyright 2006, Y.Morikaku
; August 15, 2006
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-soft-focus image drawable imgcopy edge mode opacity)

	(gimp-image-flatten image)
	
    (define addString (cond     ((= mode 0) "_super-softfocus_h.jpg" )
                                ((= mode 1) "_super-softfocus_a.jpg" )
                                ((= mode 2) "_super-softfocus_s.jpg" )
                                ((= mode 3) "_super-softfocus_dv.jpg" )
                                ('else "_super-softfocus_ds.jpg" ) ))
    
    (if (= imgcopy TRUE )
        (begin
            (define theImage (car (gimp-image-duplicate image)))
            (define theLayer (car (gimp-image-get-active-layer theImage)))
            (define theFilename (car(gimp-image-get-filename image)))
            (define newFilename (string-append 
                                    (substring theFilename 0 (- (string-length theFilename) 4))
                                    addString
                                ))
            (gimp-image-set-filename theImage newFilename)
 
        )
        (begin
	    (gimp-image-undo-group-start image)
            (define theImage image)
            (define theLayer (car (gimp-image-get-active-layer theImage)))
        )

    )
    
    (define theLayer2 (car(gimp-layer-copy theLayer 1)))
    (gimp-image-insert-layer theImage theLayer2 0 0)
    (plug-in-gauss-iir2 1 theImage theLayer2 10 10)

    (define theLayer3 (car(gimp-layer-copy theLayer2 1)))
    (gimp-image-insert-layer theImage theLayer3 0 0)
    (define mask (car (gimp-layer-create-mask theLayer3 ADD-COPY-MASK)))
    (gimp-layer-add-mask theLayer3 mask)

    (define theLayer4 (car(gimp-layer-copy theLayer3 1)))
    (gimp-image-insert-layer theImage theLayer4 0 0)

    (gimp-layer-set-mode theLayer2 SCREEN)
    (gimp-layer-set-mode theLayer3 MULTIPLY)
    (gimp-layer-set-mode theLayer4 OVERLAY)

    (define theLayer5 (car(gimp-layer-copy theLayer 1)))
    (gimp-image-insert-layer theImage theLayer5 0 0)
    (define mask5 (car (gimp-layer-create-mask theLayer5 ADD-COPY-MASK)))
    (gimp-layer-add-mask theLayer5 mask5)
    (plug-in-edge 1 theImage mask5 1 1 0)
    (plug-in-blur 1 theImage mask5)
    (gimp-levels-stretch mask5)
    (gimp-layer-set-opacity theLayer5 edge)
    (gimp-edit-copy-visible theImage)
    (define theLayer6 (car (gimp-edit-paste theLayer FALSE)))

    (define pastedLayer (car (gimp-image-get-active-layer theImage)))
    (define pastedLayerMode (cond ((= mode 0) HARDLIGHT-MODE )
                                ((= mode 1) ADDITION )
                                ((= mode 2) SCREEN )
                                ((= mode 3) DIVIDE )
                                ('else NORMAL ) ))
    (gimp-layer-set-mode pastedLayer pastedLayerMode )
    (if (>= mode 4)
        (begin 
            (gimp-desaturate pastedLayer)
            (define maskPasted (car (gimp-layer-create-mask pastedLayer ADD-COPY-MASK)))
            (gimp-layer-add-mask pastedLayer maskPasted )
        );end of begin
    );end of if 
    (gimp-layer-set-opacity pastedLayer opacity )    
    
                
    (if (= imgcopy TRUE )
       (begin
         (gimp-display-new theImage)  
         (gimp-displays-flush)
    )
    (begin
       (gimp-image-undo-group-end theImage)
	   (gimp-displays-flush)
    ))
    
     
);end of define

(script-fu-register "FU-soft-focus"
    "<Image>/Script-Fu/Sharpness/Softer/Soft Focus"
    "Super Softfocus 1.1 / Layer mode select version.\n\nFlattens image if needed before doing its work."
    "Y Morikaku"
    "copyright 2006, Y.Morikaku"
    "August 15, 2006"
    "RGB*, GRAY*"
    SF-IMAGE      "Image"     0
    SF-DRAWABLE   "Drawable"  0
    SF-TOGGLE     "Copy Image" TRUE
    SF-ADJUSTMENT "Edge Strength"   '(50 0 100 1 10 0 0)
    SF-OPTION     "Top Layer Mode" '( "HARDLIGHT-MODE" "ADDITION" "SCREEN" "DIVIDE" "Desaturation" )
    SF-ADJUSTMENT "Top Layer Opacity"   '(30 0 100 1 10 0 0)
)
