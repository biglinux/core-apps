; FU_sharpness-softer_wonderful.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; 10/24/2007 - tweaked to work with gimp-2.4.x by Paul Sherman 
; 
; 12/15/2008 - Menu items in English, RGB RGBA -> RGB*
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Copyright (C) 2000 Ingo Ruhnke <grumbel@gmx.de>
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
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
;
; Version de abcdugimp.free.fr
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-wonderful inImage inDrawable blurfactor brightness contrast flatten)
  (gimp-image-undo-group-start inImage) ;; début d'historique d'annulation
  
  (let ((new-layer (car (gimp-layer-copy inDrawable 1))))
    (gimp-image-insert-layer inImage  new-layer 0 0)
    (plug-in-gauss-iir 1 inImage new-layer blurfactor 1 1)
;; Replace this with some level stuff
    (gimp-brightness-contrast new-layer brightness contrast)

    (let ((layer-mask (car (gimp-layer-create-mask inDrawable WHITE-MASK))))
      (gimp-layer-add-mask new-layer layer-mask)
      (gimp-edit-copy new-layer)
      (gimp-floating-sel-anchor (car (gimp-edit-paste layer-mask 0)))
      (gimp-layer-set-mode new-layer ADDITION)))

  (if (= flatten TRUE)(gimp-image-flatten inImage))
  (gimp-displays-flush)
  (gimp-image-undo-group-end inImage))

(script-fu-register "FU-wonderful"
	"<Image>/Script-Fu/Sharpness/Softer/Make wonderful"
	"Creates a new tuxracer level. Version de abcdugimp.free.fr"
	"Ingo Ruhnke"
	"1999, Ingo Ruhnke"
	"2000"
	"RGB*"
	SF-IMAGE "Image" 0
	SF-DRAWABLE "Drawable" 0
	SF-ADJUSTMENT "Blur" '(35 0 5600 1 100 0 1)
	SF-ADJUSTMENT "Luminosity" '(0 -127 127 1 10 0 1)
	SF-ADJUSTMENT "Contrast" '(0 -127 127 1 10 0 1)
	SF-TOGGLE "Flatten Image" FALSE
)
