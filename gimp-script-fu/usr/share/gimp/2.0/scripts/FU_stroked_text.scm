; FU_stroked_text.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; 10/01/2008
; Modified to remove deprecated procedures as listed:
;     gimp-text-fontname  ==>  gimp-text-fontname-fontname
;
; Updated to Gimp2.4 (11-2007) http://gimpscripts.com
;
; Updated again to not throw error (needed to define theImage and theDraw)
; 11/30/2007 by Paul Sherman
;
; 10/15/2010 - added routine to change non-RGB to RGB image
;              text is basically worthless if not color, and throws an 
;			   error if not... so what the hell. Also changed some default values
;			   for better looking text.
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
; Unknown
; End original information ------------------------------------------
;--------------------------------------------------------------------
; ========================================================================
;
; LICENSE
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
; ========================================================================
;
(define (text-layer))
(define (textheight))
(define (textheight2))
(define (textwidth))
(define (textwidth2))
(define (stroke-layer))

(define (FU-stoked-text inimage indraw text font font-size stroke text-colour stroke-colour)

	(define theImage inimage)
	(define theDraw indraw)

	(gimp-image-undo-group-start theImage)

	(if (not (= RGB (car (gimp-image-base-type inimage))))
		    	 (gimp-image-convert-rgb inimage))

	(gimp-context-set-foreground text-colour)
	(set! text-layer (gimp-text-fontname theImage -1 0 0 text 0 TRUE font-size PIXELS
					    	 font))
	(set! textheight (car (gimp-drawable-height (car text-layer))))
	(set! textwidth (car (gimp-drawable-width (car text-layer))))
	(gimp-layer-resize (car text-layer) (+ textwidth (* 2 stroke)) (+ textheight (* 2 stroke))
					  stroke stroke)
	(gimp-layer-translate (car text-layer) stroke stroke)
	(gimp-image-select-item theImage CHANNEL-OP-REPLACE  (car text-layer))
	(gimp-selection-grow theImage stroke)
	(gimp-context-set-foreground stroke-colour)
	(set! textheight2 (car (gimp-drawable-height (car text-layer))))
	(set! textwidth2 (car (gimp-drawable-width (car text-layer))))

	(set! stroke-layer (gimp-layer-new theImage textwidth2 textheight2 1 "inset" 100 0) )
	(gimp-drawable-fill (car stroke-layer) 3)
	(gimp-image-insert-layer theImage (car stroke-layer) 0 -1)
	(gimp-edit-bucket-fill (car stroke-layer) 0 NORMAL 100 0 0 0 0 )
	(gimp-image-lower-item theImage (car stroke-layer))
	(gimp-selection-none theImage)
	(gimp-image-merge-down theImage (car text-layer) 0 )

	(gimp-image-undo-group-end theImage)
	(gimp-displays-flush)


)
(script-fu-register "FU-stoked-text"
	"<Image>/Script-Fu/Stoked text"
	"Creates outlined (stroked) text on image."
	"Karl Ward"
	"Karl Ward"
	"Feb 2006"
	"RGB* GRAY*"
	SF-IMAGE      	"SF-IMAGE" 0
	SF-DRAWABLE   	"SF-DRAWABLE" 0
	SF-STRING     	"Text" "Stroked"
	SF-FONT	      	"Font" "Sans"
	SF-ADJUSTMENT	"Font-size" '(80 1 300 1 10 0 1)
	SF-ADJUSTMENT   "Stroke"    '(3 1 20 1 1 1 0)
	SF-COLOR	"Text colour" '(70 180 243)
	SF-COLOR	"Stroke colour" '(0 0 0)
)
				
