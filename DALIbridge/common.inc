; common include file for all source files

; device specific includes

	list      p=16f628A           ; list directive to define processor
	#include <p16F628A.inc>       ; processor specific variable definitions

	errorlevel  -302              ; suppress message 302 from list file

; project specific includes

#include	instruct.inc	; Bring in complex instructions
#include	user_mac.inc	; Bring in application specific instructions

; end of common.inc
