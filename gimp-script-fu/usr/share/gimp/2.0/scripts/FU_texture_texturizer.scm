; FU_texture_texturizer.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; edited for gimp-2.6.1 - 11/27/2008 by Paul Sherman
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
; Texturizer script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; I would appreciate any comments/suggestions that you have about this
; script. I need new texture, how to create it.
;
; End original information ------------------------------------------
;-------------------------------------------------------------------- 

(define (FU-texturizer
			img
			drawable
			pattern
			bg-type
			angle
			elevation
			direction
			invert?
			show?
	)
  (let* (
	 (width (car (gimp-drawable-width drawable)))
	 (height (car (gimp-drawable-height drawable)))
	 (old-fg (car (gimp-context-get-foreground)))
	 (old-pattern (car (gimp-context-get-pattern)))
	 (tmp-image (car (gimp-image-new width height GRAY)))
	 (tmp-layer (car (gimp-layer-new tmp-image width height
                                         2 "Texture" 100 0)))  ; was 'GRAY-Image "Texture" 100 NORMAL'
        )

    (gimp-image-undo-group-start img)
    (gimp-image-undo-disable tmp-image)
    (gimp-drawable-fill tmp-layer WHITE-IMAGE-FILL)
    (gimp-image-insert-layer tmp-image tmp-layer 0 0)

    (cond
      ((eqv? bg-type 0)
         (gimp-context-set-pattern pattern)
         (gimp-edit-bucket-fill tmp-layer PATTERN-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0))
      ((eqv? bg-type 1)
         (plug-in-noisify 1 img tmp-layer FALSE 1.0 1.0 1.0 0)
         (gimp-brightness-contrast tmp-layer 0 63))
      ((eqv? bg-type 2)
         (plug-in-solid-noise 1 img tmp-layer FALSE FALSE (rand 65535) 15 16 16)
; last parameter added by EV (for GIMP 2)
         (plug-in-edge 1 img tmp-layer 4 1 5)
         (gimp-brightness-contrast tmp-layer 0 -63))
      ((eqv? bg-type 3)
         (plug-in-plasma 1 img tmp-layer (rand 65535) 4.0)
         (plug-in-gauss-iir2 1 img tmp-layer 1 1)
         (gimp-brightness-contrast tmp-layer 0 63))
      ) ; end of cond
    (plug-in-bump-map 1 img drawable tmp-layer angle (+ 35 elevation)
                      1 0 0 0 0 TRUE invert? LINEAR)

    (gimp-context-set-foreground old-fg)
    (gimp-context-set-pattern old-pattern)
    (gimp-image-clean-all tmp-image)
    (gimp-image-undo-enable tmp-image)
    (if (eqv? show? TRUE)
        (gimp-display-new tmp-image)
        (gimp-image-delete tmp-image))
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register
	"FU-texturizer"
	"<Image>/Script-Fu/Texture/Texturizer"
	"Creates textured canvas image. Be sure presets are installed into teh gimpressionist/presets folder."
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Oct"
	"RGB* GRAY*"
	SF-IMAGE      "Image"	           0
	SF-DRAWABLE   "Drawable"         0
	SF-PATTERN    "Use Pattern"      "Pine?"
	SF-OPTION     "Texture Type"     '("Pattern" "Sand" "Paper" "Cloud")
	SF-ADJUSTMENT "Angle"            '(135 0 360 1 10 0 0)
	SF-ADJUSTMENT "Depth"            '(0 -5 5 1 1 0 1)
	SF-OPTION     "Stretch Direction" '("None" "Horizontal" "Vertical")
	SF-TOGGLE     "Invert"           FALSE
	SF-TOGGLE     "Show Texture"     FALSE
)
