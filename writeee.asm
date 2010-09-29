; *************************************************************************** ;
; The default loader program by Ross Fosler				      ;
; v1.00	 10/26/00   ... created ...				      	      ;
;								              ;
; This routine writes the data in EEDATA to the EEPROM address stored in      ;
; the EEADR register.  BANK1 should be selected before calling.  The 	      ;
; function will return to BANK0 before exiting.  Interrupting should 	      ;
; be disabled before calling.						      ;
;						                              ;
; *************************************************************************** ;


; *****************************************************************************
#include	p16f628a.inc	; Standard include file
#include	instruct.inc	; Bring in complex instructions
#include	user_mac.inc	; Bring in application specific instructions
; *****************************************************************************


; *****************************************************************************
;	EXTERN	
; *****************************************************************************


; *****************************************************************************
WRITE_EE_DATA	CODE	
; *****************************************************************************
WriteEEData
	bcf	INTCON, GIE
	bsf	EECON1, WREN			; Write data to EE Data Memory
	movlf	0x55, EECON2
	movlf	0xAA, EECON2
	bsf	EECON1, WR
	bsf	INTCON, GIE

Lp1	brset	EECON1, WR, Lp1	
	bcf	EECON1, WREN			; Disable EE Data Write

	banksel PIR1				; Back to bank 0
	return

	GLOBAL	WriteEEData
; *****************************************************************************

	END
