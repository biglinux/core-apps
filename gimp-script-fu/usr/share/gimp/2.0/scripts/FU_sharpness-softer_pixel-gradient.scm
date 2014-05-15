; FU_sharpness-softer_pixel-gradient.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; 04/27/2008 - tweaked by Paul Sherman for gimp-2.4+
; 10/15/2010 - eliminated indexed image use to avoid errors
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; pixel-gradient.scm
; Jeff Trefftzs <trefftzs@tcsn.net>
;
; --------------------------------------------------------------------
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-pixelgradient inImage inLayer minsize maxsize nsteps)
  ;; If there isn't already a selection, select the whole thing
 (let* (
        (noselection 0)
       )
  (if (car (gimp-selection-bounds inImage))
      (begin
        (set! noselection FALSE)
      )
      (begin
       (gimp-selection-all inImage)
       (set! noselection TRUE)
      )
   )

  (let* (
     (selchannel (car (gimp-selection-save inImage)))
     (selstuff  (gimp-selection-bounds inImage))
     (width
      (cond ((car selstuff)
         (- (nth 3 selstuff) (nth 1 selstuff)))
        (t (car (gimp-image-width inImage)))))
     (height
      (cond ((car selstuff)
         (- (nth 4 selstuff) (nth 2 selstuff)))
        (t (car (gimp-image-height inImage)))))
     (x0
      (cond ((car selstuff)
         (nth 1 selstuff))
        (t 0)))
     (y0
      (cond ((car selstuff)
         (nth 2 selstuff))
        (t 0)))
     (x1 width)
     (y1 height)
     (stepwidth (/ width nsteps))
     (pixstep (/ (- maxsize minsize) nsteps))
     (startx x0)
     (startsize minsize)
     )

  (gimp-image-undo-group-start inImage)

  ;; Step across the selection (or image), pixelizing as we go

  (while (< startx x1)
     (begin
	   (gimp-image-select-item inImage CHANNEL-OP-REPLACE selchannel)
       (gimp-image-select-rectangle inImage CHANNEL-OP-INTERSECT startx y0 stepwidth height)
       (plug-in-pixelize TRUE inImage inLayer startsize)
       (set! startx (+ startx stepwidth))
       (set! startsize (+ startsize pixstep))
      )
     )

  (if (equal? TRUE noselection)
      (gimp-selection-none inImage)
      (gimp-image-select-item inImage CHANNEL-OP-REPLACE selchannel)
      )
  )
  (gimp-image-set-active-layer inImage inLayer)
  (gimp-image-undo-group-end inImage)
  (gimp-displays-flush)
  )
)

(script-fu-register "FU-pixelgradient"
 	"<Image>/Script-Fu/Sharpness/Softer/Pixel Gradient"
	"Pixelizes a selection (or layer) from left to right with increasing pixel sizes."
	"Jeff Trefftzs"
	"Copyright 2003, Jeff Trefftzs"
	"November 17, 2003"
	"RGB* GRAY*"
	SF-IMAGE "The Image" 0
	SF-DRAWABLE "The Layer" 0
	SF-ADJUSTMENT "Minimum Pixel Size" '(2 1 256 1 5 0 1)
	SF-ADJUSTMENT "Maximum Pixel Size" '(12 1 256 1 5 0 1)
	SF-ADJUSTMENT "Number of Steps"  '(5 1 256 1 5 0 1)
)
