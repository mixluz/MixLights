

; *****************************************************************************
txdali	macro	MYREGH, MYREGL
	movff	MYREGH, DALI_H
	movff	MYREGL, DALI_L
	call	SendData
	endm
; *****************************************************************************


; *****************************************************************************
rxdali	macro
	call	RecvData
	endm
; *****************************************************************************


; *****************************************************************************
tx	macro	MYREG
	movff	MYREG, TXREG
	endm
; *****************************************************************************


; *****************************************************************************
delay	macro	MYLIT
	movlf	high MYLIT, TMR1H
	movlf	low MYLIT, TMR1L
	call	DelayCyclesT1
	endm
; *****************************************************************************


; *****************************************************************************
delayf	macro	MYFILE_H, MYFILE_L
	movff	MYFILE_H, TMR1H
	movff	MYFILE_L, TMR1L
	call	DelayCyclesT1
	endm
; *****************************************************************************


; *** Set DALI Bus High *******************************************************
outhi	macro
	bcf	PORTB, 3		; Turn off clamp  (luz: originally RB4, but ruined by VPP so using RB3 now)
	goto	$ + 1
	bsf	PORTB, 5		; Turn on output
;	goto	$ + 1
;	goto	$ + 1
	endm
; *****************************************************************************


; *** Set DALI Bus Low ********************************************************
outlo	macro
	bcf	PORTB, 5		; Turn off output driver
	goto 	$ + 1			; Wait a little for gate discharge
	bsf	PORTB, 3		; Turn on clamp  (luz: originally RB4, but ruined by VPP so using RB3 now)
;	goto	$ + 1
	endm
; *****************************************************************************



; *****************************************************************************
wrtee	macro	MYREG
	banksel	EEADR
	movwf	EEDATA				; Init the first values
	movlw	TX_EDGE_DELAY_H
	sublw	MYREG
	movwf	EEADR
	call	WriteEEData
	endm
; *****************************************************************************


