; FU_contrast_shadow-recovery.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; Shadow Recovery script for GIMP 2.4
; Original author: Martin Egger (martin.egger@gmx.net)
; (C) 2005, Bern, Switzerland
;
;
; Tags: photo, exposure
;
; --------------------------------------------------------------------
;   - Changelog -
; august 2007 - fixed for gimp 2.4
; --------------------------------------------------------------------
; Nov 2008 - no fix, just menu item change to fit with 
; gimphelp.org scripts release
; --------------------------------------------------------------------
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;.
;
(define (FU-ShadowRecovery InImage InLayer InMethod InOpacity InFlatten)
;
; Save history
;
    (gimp-image-undo-group-start InImage)
;
    (let*    (
        (CopyLayer (car (gimp-layer-copy InLayer TRUE)))
        (ShadowLayer (car (gimp-layer-copy InLayer TRUE)))
        )
;
; Create new layer and add it to the image
;
        (gimp-image-insert-layer InImage CopyLayer 0 -1)
        (gimp-layer-set-mode CopyLayer ADDITION-MODE)
        (gimp-layer-set-opacity CopyLayer InOpacity)
        (gimp-image-insert-layer InImage ShadowLayer 0 -1)
;
        (gimp-desaturate ShadowLayer)
        (gimp-invert ShadowLayer)
        (let*    (
            (CopyMask (car (gimp-layer-create-mask CopyLayer ADD-WHITE-MASK)))
            (ShadowMask (car (gimp-layer-create-mask ShadowLayer ADD-WHITE-MASK)))
            )
            (gimp-layer-add-mask CopyLayer CopyMask)
            (gimp-layer-add-mask ShadowLayer ShadowMask)
            (gimp-selection-all InImage)
            (gimp-edit-copy ShadowLayer)
            (gimp-floating-sel-anchor (car (gimp-edit-paste CopyMask TRUE)))
            (gimp-floating-sel-anchor (car (gimp-edit-paste ShadowMask TRUE)))
        )
        (gimp-layer-set-mode ShadowLayer OVERLAY-MODE)
        (gimp-layer-set-opacity ShadowLayer InOpacity)
        (if (= InMethod 0) (gimp-image-remove-layer InImage CopyLayer))
;
; Flatten the image, if we need to
;
        (cond
            ((= InFlatten TRUE)
                (begin
                    (if (= InMethod 1) (gimp-image-merge-down InImage CopyLayer CLIP-TO-IMAGE))
                    (gimp-image-merge-down InImage ShadowLayer CLIP-TO-IMAGE)
                )
            )
            ((= InFlatten FALSE)
                (begin
                    (if (= InMethod 1) (gimp-item-set-name CopyLayer "Shadowfree strong"))
                    (gimp-item-set-name ShadowLayer "Shadowfree normal")
                )
            )
        )
    )
;
; Finish work
;
    (gimp-image-undo-group-end InImage)
    (gimp-displays-flush)
;
)
;
(script-fu-register "FU-ShadowRecovery"
    "Shadow Recovery"
    "Lighten-up Shadows"
    "Martin Egger (martin.egger@gmx.net)"
    "2005, Martin Egger, Bern, Switzerland"
    "2.06.2005"
    "RGB*"
    SF-IMAGE    "The Image"    0
    SF-DRAWABLE    "The Layer"    0
    SF-OPTION     "Shadow Recovery Method"
            '(
                        "Normal"
                        "Strong"
            )
    SF-ADJUSTMENT    "Layer Opacity"    '(60.0 1.0 100.0 1.0 0 2 0)
    SF-TOGGLE    "Flatten Image"    FALSE
)

(script-fu-menu-register "FU-ShadowRecovery" "<Image>/Script-Fu/Contrast/")
