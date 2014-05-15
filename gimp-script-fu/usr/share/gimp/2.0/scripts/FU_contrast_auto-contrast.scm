; FU_contrast_auto-contrast.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Automatically adjusts contrast of the current
; drawable by duplicating the layer, setting the
; new layer to Value blend mode, then running
; Auto Levels on the Value layer.
;
; End original information ------------------------------------------
;--------------------------------------------------------------------
 
(define (FU-auto-contrast img drawable merge-flag )
   (gimp-image-undo-group-start img)
   
   ; Create a new layer
   (define value-layer (car (gimp-layer-copy drawable 0)))
  
   ; Give it a name
   (gimp-item-set-name value-layer "Contrast Adjustment Layer")
  
   ; Add the new layer to the image
   (gimp-image-insert-layer img value-layer 0 0)

   ; Set opacity to 100%
   (gimp-layer-set-opacity value-layer 100)

   ; Set the layer mode to Value
   (gimp-layer-set-mode value-layer 14)

   ; Adjust contrast
   (gimp-levels-stretch value-layer)
   
   ; Merge down, if required
   (if (equal? merge-flag TRUE)
       (gimp-image-merge-down img value-layer 1 )
       ()
   )
   ;
   ; Complete the undo group
   (gimp-image-undo-group-end img)
   ; Flush the display 
   (gimp-displays-flush)   
 
)
 
(script-fu-register "FU-auto-contrast"
      "<Image>/Script-Fu/Contrast/Auto Contrast"
      "Automatically adjust contrast of drawable"
      "Mark Lowry"
      "Mark Lowry"
      "2006"
      "RGB*, GRAY*"
      SF-IMAGE "Image" 0
      SF-DRAWABLE "Current Layer" 0
      SF-TOGGLE "Merge Layers?"  FALSE
 )

