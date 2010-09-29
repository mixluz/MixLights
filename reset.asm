; *************************************************************************** ;
; The reset loader program by Ross Fosler				      ;
; v1.00	 11/04/00   ... created ...				      	      ;
;								              ;
; This is the reset function.  All stored data in EE Data Mem is loaded into  ;
; adjacent registers in RAM.			                              ;
;  									      ;
; *************************************************************************** ;


; *****************************************************************************
	#include	p16f628a.inc
	#include	instruct.inc
; *****************************************************************************


; *****************************************************************************
	EXTERN	TX_EDGE_DELAY_H, SEQUENCE_DELAY, BAUD_RATE
; *****************************************************************************


; *****************************************************************************
RESET_LOAD	CODE	
; *****************************************************************************
LoadReset
	banksel	EEADR			; Init the first values  
	movlf	TX_EDGE_DELAY_H, FSR
	clrf	EEADR
	
Lp1	bsf	EECON1, RD		; Read the reset data
	movff	EEDATA, INDF
	incf 	FSR, F
	incf	EEADR, F

	cflbis	FSR, BAUD_RATE + 1, Lp1 

	banksel SEQUENCE_DELAY		; Go back to bank 0

	return

	GLOBAL	LoadReset
; *****************************************************************************

	END

