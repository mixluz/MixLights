; *************************************************************************** ;
; Event Timer by Ross Fosler						      ;
; v1.00	02/13/01   ... created ... 					      ;
;								 	      ;
; *************************************************************************** ;


; *****************************************************************************
	subtitle	"Event Timer ..."
; *****************************************************************************


; *****************************************************************************
#include	p16f628a.inc	; Standard include file
#include	instruct.inc	; Bring in complex instructions
#include	user_mac.inc	; Bring in application specific instructions
; *****************************************************************************


; *****************************************************************************
	EXTERN	MILLISECONDS, OVER_LOAD_CNT, COUNTER_L, BRIDGE_STATUS
	EXTERN	STATUS_COPY, W_COPY
; *****************************************************************************


; *****************************************************************************
TIME_COUNT	CODE	
; *****************************************************************************
TimeCounter
	banksel	PORTA				; *** Select Bank 0 ***
	
	sublf	0xC6, TMR0, F			; Prime for 200us overflow (4MHz clock)
	
	incf	COUNTER_L, F			; Count up to 1ms
	cflbis	COUNTER_L, 0x05, Jp1	
	clrf	COUNTER_L			; Reset counter

	incf	MILLISECONDS, F			; Update the event timer

	brset	BRIDGE_STATUS, 2, Jp1		; Skip if in overload shutdown

	btfss	CMCON, C1OUT			; Overload counter
	incf	OVER_LOAD_CNT, F	 
	btfsc	CMCON, C1OUT
	decf	OVER_LOAD_CNT, F

	movf	OVER_LOAD_CNT, W		; Hold above 0
	btfsc	STATUS, Z
	bsf	OVER_LOAD_CNT, 0

	comf	OVER_LOAD_CNT, W		; Determine if OL for more than 255ms
	btfsc	STATUS, Z
	goto	OverLoad

Jp1	bcf	INTCON, T0IF			; Clear the int flag

	swapf	STATUS_COPY, W			; Restore data
	movwf	STATUS		
	swapf	W_COPY, F
	swapf	W_COPY, W

	retfie					; End of ISR

OverLoad
	bsf	BRIDGE_STATUS, 2

	movlf	0x37, CMCON			; Release the regulator
	bcf	PORTA, 4

	bcf	INTCON, T0IF			; Clear the int flag

	swapf	STATUS_COPY, W			; Restore data
	movwf	STATUS		
	swapf	W_COPY, F
	swapf	W_COPY, W

	retfie

	GLOBAL	TimeCounter
; *****************************************************************************

	END
