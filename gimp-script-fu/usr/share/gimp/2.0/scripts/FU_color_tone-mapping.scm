; FU_color_tone-mapping.scm
; version 2.8 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/15/2014 on GIMP-2.8.10
;
; 02/15/2014 - convert to RGB if needed, merge option
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
; Tonemapping is a script for The GIMP
;
; Reduce global contrast while increasing local contrast 
; and shadow/highlight detail.
;
; Copyright (C) 2007 Harry Phillips <script-fu@tux.com.au>
;==============================================================


(define (my-duplicate-layer image layer)
	(let* ((dup-layer (car (gimp-layer-copy layer 1))))
              (gimp-image-insert-layer image dup-layer 0 0)
	      dup-layer))

(define (FU-tone-mapping 
		theImage 
		theLayer 
		blurAmount 
		opacityAmount 
		inMerge
	)
    
    ;Start an undo group so the process can be undone with one undo
    (gimp-image-undo-group-start theImage)
	; convert to RGB if neeeded
	(if (not (= RGB (car (gimp-image-base-type theImage))))
			 (gimp-image-convert-rgb theImage))
    (let
    (
	(copy1 (my-duplicate-layer theImage theLayer))
	(copy2 (my-duplicate-layer theImage theLayer))
    )

    ;Apply the desaturate and invert to the top layer
    (gimp-desaturate copy2)
    (gimp-invert copy2)
    
    ;Apply the blur with the supplied blur amount
    (plug-in-gauss 1 theImage copy2 blurAmount blurAmount 0)
    
    ;Set the layers opacity
    (gimp-layer-set-opacity copy2 75)
    
    ;Merge the top layer down and keep track of the newly merged layer
    (let ((merged (car (gimp-image-merge-down theImage copy2 0))))

    ;Change the merged layers mode to SOFT LIGHT (19)
    (gimp-layer-set-mode merged 19)
    
    ;Change the merged layers opacity
    (gimp-layer-set-opacity merged opacityAmount))

	(if (= inMerge TRUE)(gimp-image-merge-visible-layers theImage EXPAND-AS-NECESSARY))
    ;Finish the undo group for the process
    (gimp-image-undo-group-end theImage)
    
    ;Ensure the updated image is displayed now
    (gimp-displays-flush)
    
    )
)

(script-fu-register "FU-tone-mapping"
	"<Image>/Script-Fu/Color/Tone Mapping"
	"Performs a tone mapping operation with a specified blur on the open image"
	"David Meiklejohn, Harry Phillips (Process)"
	"2006, David Meiklejohn, Harry Phillips (Process)"
	"Feb. 02 2006"
	"*"
	SF-IMAGE        "Image"     					0
	SF-DRAWABLE     "Drawable"  					0
	SF-ADJUSTMENT   "Blur:"     					'(100 100 500 10 10 1 0)
	SF-ADJUSTMENT   "Opacity"   					'(90 0 100 1 10 1 0)
	SF-TOGGLE     	"Merge layers when complete?" 	FALSE
)            

