; FU_effects_blackboard-effect.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Copyright (c) 2007 Pucelo for www.gimp.org.es
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions
; are met:
; 1. Redistributions of source code must retain the above copyright
;    notice, this list of conditions and the following disclaimer.
; 2. Redistributions in binary form must reproduce the above copyright
;    notice, this list of conditions and the following disclaimer in the
;    documentation and/or other materials provided with the distribution.
; 3. Neither the name of copyright holders nor the names of its
;    contributors may be used to endorse or promote products derived
;    from this software without specific prior written permission.
; *
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
; ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
; TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
; PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL COPYRIGHT HOLDERS OR CONTRIBUTORS
; BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
; POSSIBILITY OF SUCH DAMAGE.
;
; End original information ------------------------------------------
;--------------------------------------------------------------------

(define (FU-blackboard img drawable copy aplanar)
  (define image (if
    (= copy TRUE)
    (car (gimp-image-duplicate img))
    img
  ))
  (gimp-image-undo-group-start image)
  (set! drawable (car (gimp-image-flatten image)))
  (define shadow-layer (car (gimp-layer-copy drawable 1)))
  (gimp-image-insert-layer image shadow-layer 0 -1)
  (gimp-item-set-name shadow-layer "Sat")
  (gimp-layer-set-mode shadow-layer 12)
  ; Create new layer and add to the image
  (define shadow-layer2 (car (gimp-layer-copy drawable 1)))
  (gimp-image-insert-layer image shadow-layer2 0 -1)
  (gimp-item-set-name shadow-layer2 "Hue / Tono")
  (gimp-layer-set-mode shadow-layer2 11)
  (plug-in-sobel 1 image drawable 1 1 0)
  (gimp-equalize drawable 0)
  (if 
    (= aplanar TRUE)
    (set! drawable (car (gimp-image-flatten image)))
    ()
  )
  (gimp-image-set-active-layer image drawable)
  (if
    (= copy TRUE)
    (gimp-display-new image)
    ()
  )
  (gimp-image-undo-group-end image)
  (gimp-displays-flush)
)

(script-fu-register "FU-blackboard"
   "<Image>/Script-Fu/Effects/Blackboard Effect"
   "Simulates drawn on a blackboard with chalk colors. Works best on simple colors."
   "Is based in this script http://gimp.org/docs/scheme_plugin/scheme-sample.html by Simon Budig <simon@gimp.org> / Esta basado en ese guion de Simon Budig."
   "Pucelo (based on a Simon Budig sample script) for www.gimp.org.es"
   "2007/4/21"
   "RGB*"
   SF-IMAGE "Image" 0
   SF-DRAWABLE "Drawable" 0
   SF-TOGGLE "Work on copy" TRUE
   SF-TOGGLE "Flatten image at finish" TRUE
)
