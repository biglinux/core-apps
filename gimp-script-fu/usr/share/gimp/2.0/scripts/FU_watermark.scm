; FU_watermark.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; 10/01/2008 - by Paul Sherman
; Modified to remove deprecated procedures
;
; 12/15/2008 - by Paul Sherman
; modified to merge watermark layer rather than flatten image
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
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Write a watermark in a corner of the image
; script by Doug Reynolds
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-watermark image drawable text font pixsize location opacity)

	(gimp-image-undo-group-start image)

	(let*
	;Save the foreground color
    ((old-fg (car (gimp-context-get-foreground))))

	;Set the foreground color to white
     (gimp-context-set-foreground '(255 255 255))

  (let*
  	
	;Set the X and Y locations offset by 10 pixels from the chosen corner
     ((imagewid (car (gimp-image-width image)))
    	  (imagehgt (car (gimp-image-height image)))
    	  (ytext
        	 (cond ((<= location 1) (- (- imagehgt pixsize) 10))
            	   ((>= location 2) 0)))
    	  (textwid (car (gimp-text-get-extents-fontname text pixsize 0 font)))
    	  (xtext
        	 (cond ((= (fmod location 2) 0) 10)
            	   ((= (fmod location 2) 1) (- (- imagewid textwid) 10))))

		;Create a layer with the watermark text
    	(tlayer (car (gimp-text-fontname image -1 xtext ytext text -1 TRUE pixsize 0 font)))
	)

	;Bump map the watermark layer
    (plug-in-bump-map 1 image tlayer tlayer 135 45 3 0 0 0 0 1 0 0)
	
	;Set the opacity of the watermark layer
    (gimp-layer-set-opacity tlayer opacity)
	
	; Merge watermark layer with bottom layer
	  (gimp-image-merge-down image tlayer 2)
    )

	;Restore the old foreground color
    (gimp-context-set-foreground old-fg)
  )

	;Finish the undo group for the process
    (gimp-image-undo-group-end image) 
    
	;Update the display
	(gimp-displays-flush)
)

(script-fu-register "FU-watermark"
	"<Image>/Script-Fu/Watermark"
	"Watermark on corner of your choice.\nNice transparent emboss effect.\n\nAlso allows choice of font, size and opacity."
	"Doug Reynolds"
	"Doug Reynolds"
	"2001/04/12"
	"RGB*, GRAY*"
	SF-IMAGE "Input Image" 0
	SF-DRAWABLE "Input Drawable" 0
	SF-STRING "Text String" "DSR"
	SF-FONT "Font" "-itc-bookman-demi-r-normal-*-*-*-*-*-p-*-iso8859-1"
	SF-ADJUSTMENT "Size (pixels)" '(30 0 1000 5 10 0 1)
	SF-OPTION "Location" '("Lower left" "Lower right" "Upper left" "Upper right")
	SF-ADJUSTMENT "Opacity" '(20 0 100 5 10 0 1)
)
