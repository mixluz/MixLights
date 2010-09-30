

#include    common.inc		; include stuff that is common to all files


; *****************************************************************************
	EXTERN	DALI_H, DALI_L
	EXTERN	DelayCyclesT1
	EXTERN	TX_EDGE_DELAY_H, TX_EDGE_DELAY_L, TX_STOP_DELAY_H, TX_STOP_DELAY_L
	EXTERN	TX_REG_DELAY_H, TX_REG_DELAY_L
; *****************************************************************************


; *****************************************************************************
TX_DALI	CODE
SendData
	btfss	CMCON, C1OUT		; Don't transmit if overload
	retlw	0x01

	bcf	INTCON, GIE		; Disable Interrupts

	movlf	0x37, CMCON		; Release the regulator
	bcf	PORTA, 4

	call	XmitOne			; Send Start Bit

	btfsc	DALI_H, 7
	call	XmitOne
	btfss	DALI_H, 7
	call	XmitZero
	btfsc	DALI_H, 6
	call	XmitOne
	btfss	DALI_H, 6
	call	XmitZero
	btfsc	DALI_H, 5
	call	XmitOne
	btfss	DALI_H, 5
	call	XmitZero
	btfsc	DALI_H, 4
	call	XmitOne
	btfss	DALI_H, 4
	call	XmitZero
	btfsc	DALI_H, 3
	call	XmitOne
	btfss	DALI_H, 3
	call	XmitZero
	btfsc	DALI_H, 2
	call	XmitOne
	btfss	DALI_H, 2
	call	XmitZero
	btfsc	DALI_H, 1
	call	XmitOne
	btfss	DALI_H, 1
	call	XmitZero
	btfsc	DALI_H, 0
	call	XmitOne
	btfss	DALI_H, 0
	call	XmitZero

	btfsc	DALI_L, 7
	call	XmitOne
	btfss	DALI_L, 7
	call	XmitZero
	btfsc	DALI_L, 6
	call	XmitOne
	btfss	DALI_L, 6
	call	XmitZero
	btfsc	DALI_L, 5
	call	XmitOne
	btfss	DALI_L, 5
	call	XmitZero
	btfsc	DALI_L, 4
	call	XmitOne
	btfss	DALI_L, 4
	call	XmitZero
	btfsc	DALI_L, 3
	call	XmitOne
	btfss	DALI_L, 3
	call	XmitZero
	btfsc	DALI_L, 2
	call	XmitOne
	btfss	DALI_L, 2
	call	XmitZero
	btfsc	DALI_L, 1
	call	XmitOne
	btfss	DALI_L, 1
	call	XmitZero
	btfsc	DALI_L, 0
	call	XmitOne
	btfss	DALI_L, 0
	call	XmitZero

	outhi				; Send stop bits
	delayf	TX_STOP_DELAY_H, TX_STOP_DELAY_L
;	delay	0xF9E3			; idle for 4 * 416us - 100us

	bsf	PORTA, 4		; Engage the regulator
	movlf	0x36, CMCON

	delayf	TX_REG_DELAY_H, TX_REG_DELAY_L
;	delay	0xFF9B			; Wait for regulator to come up, 100us

	bcf	PORTB, 3		; Disable driving output (luz: originally RB4, but ruined by VPP so using RB3 now)
	bcf	PORTB, 5

	bsf	INTCON, GIE		; Enable interrupts

	retlw	0x00

	GLOBAL	SendData
; *****************************************************************************


; *****************************************************************************
XmitOne
	outlo
;	delay	0xFE76
	delayf	TX_EDGE_DELAY_H, TX_EDGE_DELAY_L
	outhi
;	delay	0xFE76
	delayf	TX_EDGE_DELAY_H, TX_EDGE_DELAY_L
	return
; *****************************************************************************


; *****************************************************************************
XmitZero
	outhi
	delayf	TX_EDGE_DELAY_H, TX_EDGE_DELAY_L
;	delay	0xFE76
	outlo
	delayf	TX_EDGE_DELAY_H, TX_EDGE_DELAY_L
;	delay	0xFE76
	return
; *****************************************************************************


	END
