; FU_sketch_pen-sketch.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; adapted to GIMP-2.4 by Paul Sherman 11/23/2007
; 
; Updated again for v2.6, needed another define...
; 10/02/2008
;
; 12/15/2008 - accepts RGB* only, to prevent errors
;
; --------------------------------------------------------------------
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
; --------------------------------------------------------------------
; Original information -----------------------------------------------
;
; script by Karl Ward
;
; End original information -------------------------------------------
;---------------------------------------------------------------------

(define (FU-pen inimage indraw blur)
	(define theImage inimage)
	(define theDraw indraw)
	(gimp-image-undo-group-start theImage)
	(define flush (car(gimp-image-flatten theImage)))
	(define flush-copy (car(gimp-layer-copy flush 1)))
	(gimp-image-insert-layer theImage flush-copy 0 -1)
	(define second-copy (car(gimp-layer-copy flush 1)))
	(gimp-image-insert-layer theImage second-copy 0 -1)
	(gimp-layer-set-mode second-copy 20)
	(plug-in-gauss 1 theImage second-copy blur blur 0)
	(define width (car (gimp-drawable-width flush)))
	(define height (car (gimp-drawable-height flush)))
	(define white-layer (car (gimp-layer-new theImage width height 1 "white" 100 13)))
	(gimp-drawable-fill white-layer 2)
	(gimp-image-insert-layer theImage white-layer 0 -1)
	(gimp-item-set-visible flush 0)
	(define flat-grey (car(gimp-image-merge-visible-layers theImage 0)))
	(define (plug-in-color-map 1 theImage flat-grey '(0 0 0) '(128 128 128) '(00 00 00) '(256 256 256) 0))
	(define outline-copy (car(gimp-layer-copy flat-grey 1)))
	(gimp-image-insert-layer theImage outline-copy 0 -1)
	(plug-in-colortoalpha 1 theImage outline-copy '(256 256 256))
	(gimp-layer-set-mode outline-copy 17)
	(define final-outline (car(gimp-image-merge-visible-layers theImage 0)))
	(define copy-count 1)
	(while (<= copy-count 4 )
	(define copy (car(gimp-layer-copy final-outline 1)))
	(gimp-image-insert-layer theImage copy 0 -1)
	(gimp-layer-set-mode copy 17)
	(set! copy-count (+ copy-count 1)))
	(gimp-layer-set-mode final-outline 17)

	(gimp-item-set-visible flush 1)
	(gimp-layer-add-alpha flush)
	(gimp-layer-set-opacity flush 70)
	(set! white-layer (car (gimp-layer-new theImage width height 1 "white" 100 0)))
	(gimp-drawable-fill white-layer 2)
	(gimp-image-insert-layer theImage white-layer 0 -1)
	(gimp-image-lower-item-to-bottom theImage white-layer)
	(gimp-image-flatten theImage)
	(gimp-image-undo-group-end theImage)
	(gimp-displays-flush)
)
(script-fu-register "FU-pen"
	"<Image>/Script-Fu/Sketch/Pen Drawn"
	"This filter changes any image into a image that appears to have been drawn woth ink"
	"Karl Ward"
	"Karl Ward"
	"OCT 2006"
	"RGB*"
	SF-IMAGE      "SF-IMAGE" 0
	SF-DRAWABLE   "SF-DRAWABLE" 0
	SF-ADJUSTMENT "Line thickess" '(25 1 100 1 5 0 0)
)
				
