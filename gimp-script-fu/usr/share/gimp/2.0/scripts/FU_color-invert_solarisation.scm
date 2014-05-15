; FU_color-invert_solarisation.scm
; version 2.7 [gimphelp.org]
; last modified/tested by Paul Sherman
; 05/05/2012 on GIMP-2.8
;
; ------------------------------------------------------------------
; Original information ---------------------------------------------
;
; Solarization script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/12/08
;     - Initial relase
; version 0.1a by Iccii 2001/12/09
;     - Added Threshold adjuster
;
; End original information ------------------------------------------
;-------------------------------------------------------------------- 

(define (FU-solarisation
			img
			drawable
			threshold
			target-channel
			invert?
			value-change?
	)

  (define (apply-solarization channel)
    (let* ((point-num 256)
           (control_pts (cons-array point-num 'byte))
           (start-value (if (< threshold 128) (- 255 (* threshold 2)) 0))
           (end-value   (if (< threshold 128) 0 (* (- threshold 128) 2)))
           (grad (if (< threshold 128)
                     (/ (- 127 start-value) 127)
                     (/ (- end-value 127)   127)))
           (count 0))
      (while (< count point-num)
        (let* ((value1 (if (< threshold 128)
                           (if (< count 128)
                               (+ start-value (* grad count))
                               (- 255 count))
                           (if (< count 128)
                               count
                               (+ 127 (* grad (- count 128))))))
               (value2 (if (equal? value-change? TRUE) (+ value1 127) value1))
               (value  (if (equal? invert? TRUE) (- 255 value2) value2)))
          (aset control_pts count value)
          (set! count (+ count 1))))
      (gimp-curves-explicit drawable channel point-num control_pts)))


  (let* (
         (image-type (car (gimp-image-base-type img)))
         (has-alpha? (car (gimp-drawable-has-alpha drawable)))
        ) ; end variable definition

    (gimp-image-undo-group-start img)

    (if (or (= target-channel 0) (equal? image-type GRAY))
        (apply-solarization VALUE-LUT)
        (cond ((= target-channel 1)
                (apply-solarization RED-LUT))
              ((= target-channel 2)
                (apply-solarization GREEN-LUT))
              ((= target-channel 3)
                (apply-solarization BLUE-LUT))
              ((= target-channel 4)
                (if (equal? has-alpha? TRUE)
                    (apply-solarization ALPHA-LUT)
                    (gimp-message "Drawable doesn't have an alpha channel! Abort."))) ))

    (gimp-image-undo-group-end img)
    (gimp-displays-flush)
))

(script-fu-register
	"FU-solarisation"
	"<Image>/Script-Fu/Color/Invert/Solarisation"
	"Apply solarization effect, basically a tone reversal. This version has several parameters that can be tweaked."
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Dec"
	"RGB* GRAY*"
	SF-IMAGE      _"Image"          0
	SF-DRAWABLE   _"Drawable"       0
	SF-ADJUSTMENT _"Threshold"      '(127 0 255 1 1 0 0)
	SF-OPTION     _"Target Channel" '("RGB (Value)" "Red" "Green" "Blue" "Alpha")
	SF-TOGGLE     _"Invert"         FALSE
	SF-TOGGLE     _"Value Change"   FALSE
)
