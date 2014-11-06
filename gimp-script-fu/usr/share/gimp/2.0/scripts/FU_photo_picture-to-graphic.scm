; FU_photo_picture-to-graphic.scm
; version 2.8 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/14/2014 on GIMP-2.8.10
;
; 02/14/2014 - convert to RGB if needed
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
; Picture to Graphic
; picture_to_graphic.scm
; version 1.2
; Takes a photo or muddy graphic and turns it 
; into a simpler, more 'graphic' image.
;
; (based on Sepoina by Ghigi Giancarlo)
; ---------------------------------------------
;
; By Paul Sherman <psherman2001@gmail.com>
; version 1.0  12/26/2007
;
; version 1.1 09/28/2008
; patched for GIMP >= 2.5 by Floyd L. Davidson 
; <http://www.apaflo.com/floyd_davidson>
; and he also corrected an errant global define.
;
; 9/29/2008 - Paul S. added "REALLY Punch It Up" 
; (extra curves manipulation)
;==============================================================


(define (FU-picture_to_graphic 
		inImage 
		inLayer 
		_presharp 
		_smartblur 
		_engraving 
		_postsharp 
		_canvas 
		_strong 
		_punchit
	)

  (gimp-image-undo-group-start inImage)			; Prepare any undo 
  (if (not (= RGB (car (gimp-image-base-type inImage))))
			 (gimp-image-convert-rgb inImage))  
  (define old-bg (car (gimp-context-get-background)))
  (gimp-context-set-background '(255 255 255))		;set white background

  (gimp-selection-all inImage)				; Select whole image
  (define LayerBase (car(gimp-image-flatten inImage)))	; Set the Layer to whole image flattened on one level
  (gimp-item-set-name LayerBase "Base")		; the name of LayerBase picture is Base
  

  (define LayerSobel 
  	(car (gimp-layer-copy LayerBase TRUE)))		; Copy current layer into "LayerSobel"
  (gimp-image-insert-layer inImage LayerSobel 0 -1)		; New layer at the top of layers
  (gimp-item-set-name LayerSobel "Sobel")		; picture plan's name "Sobel"
  (if (> _presharp 0) 
  	(plug-in-sharpen TRUE inImage LayerSobel _presharp))	; Pre-sharp
  (if (> _smartblur 0) 				
  	(plug-in-sel-gauss 
    TRUE inImage LayerSobel _smartblur 60))	; smartly blur image
  (if (> _engraving 0) 	
  	(plug-in-unsharp-mask 
	TRUE inImage LayerSobel 3.3 _engraving 29))	; adjacent areas blurer
  (if (> _postsharp 0)
   	(plug-in-sharpen 
    	TRUE inImage LayerSobel _postsharp))		; Post-sharp
  (gimp-brightness-contrast LayerSobel 40 32)		; Change Contrast
  (plug-in-laplace FALSE inImage LayerSobel)		; Find contours
  (gimp-invert LayerSobel)				; Invert
  (gimp-desaturate LayerSobel)				; Desature
  (if (> _canvas 0)
  	(plug-in-apply-canvas 
  	TRUE inImage LayerSobel 0 _canvas))		; canvas?
  (gimp-brightness-contrast LayerSobel 0 -20)  		; Uncontrast
  (gimp-brightness-contrast LayerSobel -62 86)  	; Uncontrast

  ; Make scratched levels
  (define LayerSemi 
   (car (gimp-layer-copy LayerBase TRUE)))		; Copy basic layer into New
  (gimp-image-insert-layer inImage LayerSemi 0 0)		; New layer at the top of layers
  (plug-in-sharpen TRUE inImage LayerSemi 82) 		; sharp
  (gimp-brightness-contrast LayerSemi 71 0)		; hyperlight
  (gimp-desaturate LayerSemi)				; Make gray
  (plug-in-normalize TRUE inImage LayerSemi)		; Spread contrast to whole scale
  (define maschera 
   	(car (gimp-layer-create-mask LayerSemi 5)))	; Create a mask based on current layer's gray copy
  (gimp-layer-add-mask LayerSemi maschera)		; Apply trasparency mask to current layer
  (gimp-layer-remove-mask LayerSemi MASK-APPLY)		; load mask into layer
  (gimp-item-set-name LayerSemi "semi")		; new layer's name is "semi"

  (gimp-image-raise-item-to-top inImage LayerSobel)	; Put sobel layer at the top

  (gimp-layer-set-mode       LayerSobel  17)
  (gimp-layer-set-opacity    LayerSobel 100)

  (gimp-layer-set-mode       LayerSemi    0)
  (gimp-item-set-visible LayerSemi    0)

  (gimp-layer-set-mode       LayerBase    0)
  (gimp-layer-set-opacity    LayerBase   51)

  (saturate_it 20 inImage LayerBase) 
    
  (if (= _strong TRUE) 
      (begin
     
          (define LayerToon (car (gimp-layer-copy LayerBase TRUE)))
          (gimp-image-insert-layer inImage LayerToon 0 -1)
          (plug-in-cartoon 1 inImage LayerToon 4.0 0.2)
          (gimp-layer-set-opacity LayerToon 60)
	  (if (= _punchit TRUE) 
               (begin
			(define (spline-punch-it)
			  (let*
			   ((a (cons-array 12 'byte)))
			   (set-pt a 0 0 0)
			   (set-pt a 1 55 27)
			   (set-pt a 2 95 124)
			   (set-pt a 3 148 187)
			   (set-pt a 4 204 229)
			   (set-pt a 5 255 255)
			a))
	          	(gimp-curves-spline LayerToon 0 12 (spline-punch-it))))
	))
	  
		  
  ; finish up
  (gimp-context-set-background old-bg)   ;set white background
  (gimp-image-flatten inImage)
  (gimp-image-undo-group-end inImage)
  (gimp-displays-flush inImage)
)

(define (saturate_it amount_num _image _layer)
  (let* ((amount (/ amount_num 100)))

    (plug-in-colors-channel-mixer TRUE _image _layer FALSE (+ 1 amount amount) (- amount) (- amount) (- amount) (+ 1 amount amount) (- amount) (- amount) (- amount) (+ 1 amount amount))

    (define (spline)
      (let* ((a (cons-array 8 'byte)))
	(set-pt a 0 0 0)
	(set-pt a 1 63 60)
	(set-pt a 2 191 194)
	(set-pt a 3 255 255)
	a))
    (define (set-pt a index x y)
	(prog1
	(aset a (* index 2) x)
	(aset a (+ (* index 2) 1) y)))
    (gimp-curves-spline _layer 0 8 (spline)))
)	

	
(script-fu-register "FU-picture_to_graphic"
	"Picture to graphic"
	"Takes a photo or muddy graphic and turns it into a simpler, more 'graphic' image.\n\nby Paul Sherman\ngimphelp.org"
	"Paul Sherman - psherman2001@gmail,com"
	"Paul Sherman."
	"12/26/2007"
	"*"
	SF-IMAGE      "The Image"     0
	SF-DRAWABLE   "The Layer"     0
	SF-ADJUSTMENT _"Pre-sharp (0=No)"  '(70 0 99 0.05 0.5 2 0)
	SF-ADJUSTMENT _"Smart-blur (0=NO)"  '(1.5 0 30 0.5 1 2 0)
	SF-ADJUSTMENT _"Engraving mask (0=No)"  '(5 0 8 0.05 0.5 2 0)
	SF-ADJUSTMENT _"Post-sharp (0=No)"  '(12 0 99 0.05 0.5 2 0)
	SF-ADJUSTMENT _"Canvasize (0=NO)"  '(0 0 10 1 1 2 0)
	SF-TOGGLE "Strong" FALSE
	SF-TOGGLE "REALLY Punch It Up (use in conjunction with \"Strong\")" FALSE
)
(script-fu-menu-register "FU-picture_to_graphic" "<Image>/Script-Fu/Photo/")
