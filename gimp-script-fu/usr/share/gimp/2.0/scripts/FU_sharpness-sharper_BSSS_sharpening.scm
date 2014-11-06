; FU_sharpness-sharper_BSSS_sharpening.scm
; version 2.8 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/15/2014 on GIMP-2.8.10
;
; tweaked for GIMP-2.4.x by Paul Sherman 10/24/2007
; later moved menu location
;
; 02/15/2014 - accomodate indexed images
;==============================================================
;
; Installation:
; This script should be placed in the user or system-wide script folder.
;
;	Windows Vista/7/8)
;	C:\Program Files\GIMP 2\share\gimp\2.0\scripts
;	or
;	C:\Users\YOUR-NAME\.gimp-2.8\scripts
;	
;	Windows XP
;	C:\Program Files\GIMP 2\share\gimp\2.0\scripts
;	or
;	C:\Documents and Settings\yourname\.gimp-2.8\scripts   
;    
;	Linux
;	/home/yourname/.gimp-2.8/scripts  
;	or
;	Linux system-wide
;	/usr/share/gimp/2.0/scripts
;
;==============================================================
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
;==============================================================
; Original information 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                 lyle's BSSS                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A GIMP script-fu to perform the sharpening
; technique created by lylejk of dpreview.com

; Creates a layer set to screen mode and
; another layer above it set to subtract mode.
; The subtract layer is then blurred
; and merged down with the screen layer, the
; result of which is merged down with the original
; layer (if so selected).
; 
; Only tested on 2.2.8
; 3/25/2006
;
; Revised 4/5/2006 to add option not to merge the screen layer
; down with the original drawable.  This allows the user to
; duplicate the screen layer, as desired, to provide further
; incremental sharpening.
;==============================================================


(define (FU-BSSS
		img 
		drawable 
		blur-rad 
		merge-flag
	)
 
	; Start an undo group.  Everything between the start and the end
	; will be carried out if an undo command is issued.
	(gimp-image-undo-group-start img)

	(define indexed (car (gimp-drawable-is-indexed drawable)))
	(if (= indexed TRUE)(gimp-image-convert-rgb img))

	;; RENAME THE LAYER TO BE SHARPENED
	(gimp-item-set-name drawable "BSSS Sharpened")

	;; CREATE THE SCREEN LAYER ;;
	(define screen-layer (car (gimp-layer-copy drawable 0)))

	; Give it a name
	(gimp-item-set-name screen-layer "Screen")

	; Add the new layer to the image
	(gimp-image-insert-layer img screen-layer 0 0)

	; Set opacity to 100%
	(gimp-layer-set-opacity screen-layer 100)

	;; CREATE THE SUBTRACT LAYER ;;
	(define subtract-layer (car (gimp-layer-copy drawable 0)))

	; Name the subtract layer
	(gimp-item-set-name subtract-layer "Subtract")

	; Add the new layer to the image
	(gimp-image-insert-layer img subtract-layer 0 0)

	; Set opacity to 100%
	(gimp-layer-set-opacity subtract-layer 100)

	; Set the layer mode to subtract
	(gimp-layer-set-mode subtract-layer 8)

	; Blur the subtract layer
	(plug-in-gauss-iir 1 img subtract-layer blur-rad 1 1 )
   
	;; NOW MERGE EVERYTHING BACK DOWN TO THE ORIGINAL LAYER ;;
	; Merge down with screen layer and set the layer mode to Screen
	(define first-merge (car(gimp-image-merge-down img subtract-layer 1)) )
	(gimp-layer-set-mode first-merge 4)

	; Merge down with the drawable, if selection box was checked.
	(if (equal? merge-flag TRUE)
      (gimp-image-merge-down img first-merge 1 )
      ()
   )
   ; Complete the undo group
   (gimp-image-undo-group-end img)
   ; Flush the display 
   (gimp-displays-flush)   
)
 
(script-fu-register "FU-BSSS"
      "<Image>/Script-Fu/Sharpness/Sharper/BSSS-Sharpen"
      "Image sharpen that lightly blurs non-edges, visually packs a bit more punch than plain sharpen -- without the distortion of higher values."
      "script-fu by Mark Lowry"
      "technique by lylejk of dpreview.com"
      "2006"
      "*"
      SF-IMAGE "Image" 					0
      SF-DRAWABLE "Current Layer" 		0
      SF-VALUE "Gaussian Blur Radius"  	"5"
      SF-TOGGLE "Merge Layers?"  		TRUE
 )

