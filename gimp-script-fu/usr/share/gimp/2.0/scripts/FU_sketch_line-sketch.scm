; FU_sketch_line-sketch.scm
; version 2.8 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/04/2014 on GIMP-2.8.10
;
; 11/22/2007 - modified by Paul Sherman for GIMP 2.4
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
; along with this program; if not, you can view the GNU General Public
; License version 3 at the web site http://www.gnu.org/licenses/gpl-3.0.html
; Alternatively you can write to the Free Software Foundation, Inc., 675 Mass
; Ave, Cambridge, MA 02139, USA.
;
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
;	
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
; Line Sketch script by kward1979uk
;==============================================================


(define (set-pt a index x y)
  (begin
      (aset a (* index 2) x)
      (aset a (+ (* index 2) 1) y)
   )
)
  
(define (spline-sketch)
  (let*
	((a (make-vector 18 'byte)))
	(set-pt a 0 0 0)
	(set-pt a 1 190 0)
	(set-pt a 2 191 1)
	(set-pt a 3 210 210)
	(set-pt a 4 220 220)
	(set-pt a 5 230 230)
	(set-pt a 6 240 240)
	(set-pt a 7 250 250)
	(set-pt a 8 255 255)
	
a))


(define (FU-line-sketch inimage indraw bg-colour)
	(define theImage inimage)
	(define theDraw indraw)
	(gimp-image-undo-group-start theImage)
	
	(define height (car (gimp-drawable-height theDraw)))
	(define width (car (gimp-drawable-width theDraw)))
	(plug-in-edge 1 theImage theDraw 2 1 0)
	(gimp-equalize theDraw 0)
	(gimp-desaturate theDraw)
	(define highpass (car (gimp-layer-copy theDraw 1)))
	(gimp-image-insert-layer theImage highpass 0 1)
	(gimp-curves-spline highpass 0 18 (spline-sketch))
	(gimp-invert theDraw)
	(gimp-layer-add-alpha theDraw)
	(define imagemask (car (gimp-layer-create-mask theDraw 0)))
	(gimp-layer-add-mask theDraw imagemask)
	(gimp-edit-copy highpass)
	(define copy-paste (car (gimp-edit-paste imagemask 0)))
	(gimp-floating-sel-anchor copy-paste)
	(gimp-context-set-background bg-colour)
	(define background (car (gimp-layer-new theImage width height 1 "background" 100 0)))
	(gimp-drawable-fill background 1)
	(gimp-image-insert-layer theImage background 0 0)
	(gimp-image-remove-layer theImage highpass)
	(gimp-image-lower-item theImage background)

	(gimp-image-undo-group-end theImage)
	(gimp-displays-flush)
)

(script-fu-register "FU-line-sketch"
	"<Image>/Script-Fu/Sketch/Line Sketch"
	"Turns a image into a sketch.\n\nIf the image is a alpha layer it will be flattened first, background color is selectable."
	"Karl Ward"
	"Karl Ward"
	"Feb 2006"
	"RGB*"
	SF-IMAGE      	"SF-IMAGE" 0
	SF-DRAWABLE   	"SF-DRAWABLE" 0
	SF-COLOR		"Background Colour" '(255 255 255)		
)
