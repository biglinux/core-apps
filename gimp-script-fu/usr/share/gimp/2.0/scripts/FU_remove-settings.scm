; FU_remove-settings.scm
; version 2.0 [gimphelp.org]
; last modified/tested by Paul Sherman
; 02/04/2014 on GIMP-2.8.10
;
; Speeds loading of the color tools that keep track of old settings.
; 
; ========================================================================
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
; by Paul Sherman, gimphelp.org
;==============================================================

(define (FU-remove-settings s_bright? s_balance? s_colorize? s_curves? s_hue? s_levels?)

	(define path_brightness-contrast)
	(define path_color-balance)
	(define path_colorize)
	(define path_curves)
	(define path_hue-saturation)
	(define path_levels)

	(if (eqv? s_bright? TRUE)
		(begin
		(let*((path_brightness-contrast (string-append gimp-directory DIR-SEPARATOR "tool-options" DIR-SEPARATOR "gimp-brightness-contrast-tool.settings")))
		(file-delete path_brightness-contrast)
		)
	))

	(if (eqv? s_balance? TRUE)
		(begin
		(let*((path_color-balance (string-append gimp-directory DIR-SEPARATOR "tool-options" DIR-SEPARATOR "gimp-color-balance-tool.settings")))
		(file-delete path_color-balance)
		)
	))

	(if (eqv? s_colorize? TRUE)
		(begin
		(let*((path_colorize (string-append gimp-directory DIR-SEPARATOR "tool-options" DIR-SEPARATOR "gimp-colorize-tool.settings")))
		(file-delete path_colorize)
		)
	))
	
	(if (eqv? s_curves? TRUE)
		(begin
		(let*((path_curves (string-append gimp-directory DIR-SEPARATOR "tool-options" DIR-SEPARATOR "gimp-curves-tool.settings")))
		(file-delete path_curves)
		)
	))
	
	(if (eqv? s_hue? TRUE)
		(begin
		(let*((path_hue-saturation (string-append gimp-directory DIR-SEPARATOR "tool-options" DIR-SEPARATOR "gimp-hue-saturation-tool.settings")))
		(file-delete path_hue-saturation)
		)
	))
	
	(if (eqv? s_levels? TRUE)
		(begin
		(let*((path_levels (string-append gimp-directory DIR-SEPARATOR "tool-options" DIR-SEPARATOR "gimp-levels-tool.settings")))
		(file-delete path_levels)
		)
	))
)

(script-fu-register "FU-remove-settings"
	"<Image>/Script-Fu/Remove Settings"
	"Removes all Color Tool Settings 
 (speeds up loading of tools)"
	"Paul Sherman"
	"Paul Sherman"
	"2012/04/22"
	"*"
	SF-TOGGLE     "Brightnesss-Contrast" TRUE
	SF-TOGGLE     "Color Balance" TRUE
	SF-TOGGLE     "Colorize" TRUE
	SF-TOGGLE     "Curves" TRUE
	SF-TOGGLE     "Hue-Saturation" TRUE
	SF-TOGGLE     "Levels" TRUE
	
)

