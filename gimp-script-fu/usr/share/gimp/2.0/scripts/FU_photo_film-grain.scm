; FU_photo_film-grain.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; No editing except for menu entry involved - 
; this was a sorely needed replacement for older film-grain script.
; which was very ineffective.
;
; edited 10/15/2010 to eliminate errors from non-RGB images
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
; http://www.gnu.org/licenses/gpl-3.0.html
;
; Copyright (C) 2008 Samuel Albrecht <samuel_albrecht@web.de>
;
; Version 0.1 - Adding Film Grain after: http://www.gimpguru.org/Tutorials/FilmGrain/
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-film-grain aimg adraw holdness grainsize strength)
  (let* ((img (car (gimp-item-get-image adraw)))
         (owidth (car (gimp-image-width img)))
         (oheight (car (gimp-image-height img)))
         (grainlayer (car (gimp-layer-new img
                                          owidth 
                                          oheight
                                          1
                                          "Grain" 
                                          100 
                                          OVERLAY-MODE)))
         (grainlayermask (car (gimp-layer-create-mask grainlayer ADD-WHITE-MASK)))
         (floatingsel 0)
         )
  		   
    ; init
    (define (set-pt a index x y)
      (begin
        (aset a (* index 2) x)
        (aset a (+ (* index 2) 1) y)
        )
      )
    (define (splineValue)
      (let* ((a (cons-array 6 'byte)))
        (set-pt a 0 0 0)
        (set-pt a 1 128 strength)
        (set-pt a 2 255 0)
        a
        )
      )
    
    (gimp-context-push)
    (gimp-image-undo-group-start img)
    (if (= (car (gimp-drawable-is-gray adraw )) TRUE)
        (gimp-image-convert-rgb img)
        )
    (gimp-context-set-foreground '(0 0 0))
    (gimp-context-set-background '(255 255 255))
    
    ;fill new layer with neutral gray
    (gimp-image-insert-layer img grainlayer 0 -1)
    (gimp-drawable-fill grainlayer TRANSPARENT-FILL)
    (gimp-context-set-foreground '(128 128 128))
    (gimp-selection-all img)
    (gimp-edit-bucket-fill grainlayer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    (gimp-selection-none img)
    
    ;add grain and blur it
    (plug-in-scatter-hsv 1 img grainlayer holdness 0 0 grainsize)
    (plug-in-gauss 1 img grainlayer 1 1 1)
    (gimp-layer-add-mask grainlayer grainlayermask)
    
    ;select the original image, copy and paste it as a layer mask into the grain layer
    (gimp-selection-all img)
    (gimp-edit-copy adraw)
    (set! floatingsel (car (gimp-edit-paste grainlayermask TRUE)))
    (gimp-floating-sel-anchor floatingsel)
    
    ;set color curves of layer mask, so that only gray areas become grainy
    (gimp-curves-spline grainlayermask  HISTOGRAM-VALUE  6 (splineValue))
    
    ; tidy up
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
    (gimp-context-pop)
    )
  )

(script-fu-register "FU-film-grain"
	"<Image>/Script-Fu/Photo/Film Grain"
	"Simulating Film Grain.\nby Samuel Albrecht\n\nNewest version can be downloaded from http://registry.gimp.org/node/8108"
	"Samuel Albrecht <samuel_albrecht@web.de>"
	"Samuel Albrecht"
	"13/08/08"
	"RGB*"
	SF-IMAGE       "Input image"          0
	SF-DRAWABLE    "Input drawable"       0
	SF-ADJUSTMENT _"Holdness" '(2 1 8 1 2 0 0)
	SF-ADJUSTMENT _"Value" '(100 0 255 1 10 0 0)
	SF-ADJUSTMENT _"Strength" '(128 0 255 1 10 0 0)
)
