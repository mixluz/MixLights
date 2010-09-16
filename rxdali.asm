
; *****************************************************************************
#include	p16f628.inc	; Standard include file
#include	instruct.inc	; Bring in complex instructions
#include	user_mac.inc	; Bring in application specific instructions
; *****************************************************************************


; *****************************************************************************
	EXTERN	DALI_H, DALI_L
	EXTERN	MILLISECONDS
	EXTERN	WREG1
	EXTERN	DelayCyclesT1
	EXTERN	RX_WAIT, RX_START_DELAY_H
	EXTERN	RX_START_DELAY_L, RX_SAMPLE_DELAY_H, RX_SAMPLE_DELAY_L
	EXTERN	RX_DELAY_NEXT_H, RX_DELAY_NEXT_L, RX_DEBUG
; *****************************************************************************


; *****************************************************************************
RX_DALI	CODE
RecvData

	clrf	MILLISECONDS

Lp10	cffbig	MILLISECONDS, RX_WAIT, ReportErr	; Quit after some ms

	brset	CMCON, C1OUT, Lp10		; Wait for a falling edge

	bcf	INTCON, GIE			; Disable Interrupts

;	delay	0xFED3				; Delay 300us
	delayf	RX_START_DELAY_H, RX_START_DELAY_L		
	
	call	RecvBit				; Get start bit
	btfsc	WREG1, 7
	goto	ReportErr
	
	
	call	RecvBit				; Get bit 7
	btfsc	WREG1, 7
	goto	ReportErr
	btfsc	WREG1, 2
	bsf	DALI_L, 7
	btfss	WREG1, 2
	bcf	DALI_L, 7


	call	RecvBit				; Get bit 6
	btfsc	WREG1, 7
	goto	ReportErr
	btfsc	WREG1, 2
	bsf	DALI_L, 6
	btfss	WREG1, 2
	bcf	DALI_L, 6


	call	RecvBit				; Get bit 5
	btfsc	WREG1, 7
	goto	ReportErr
	btfsc	WREG1, 2
	bsf	DALI_L, 5
	btfss	WREG1, 2
	bcf	DALI_L, 5


	call	RecvBit				; Get bit 4
	btfsc	WREG1, 7
	goto	ReportErr
	btfsc	WREG1, 2
	bsf	DALI_L, 4
	btfss	WREG1, 2
	bcf	DALI_L, 4


	call	RecvBit				; Get bit 3
	btfsc	WREG1, 7
	goto	ReportErr
	btfsc	WREG1, 2
	bsf	DALI_L, 3
	btfss	WREG1, 2
	bcf	DALI_L, 3


	call	RecvBit				; Get bit 2
	btfsc	WREG1, 7
	goto	ReportErr
	btfsc	WREG1, 2
	bsf	DALI_L, 2
	btfss	WREG1, 2
	bcf	DALI_L, 2


	call	RecvBit				; Get bit 1
	btfsc	WREG1, 7
	goto	ReportErr
	btfsc	WREG1, 2
	bsf	DALI_L, 1
	btfss	WREG1, 2
	bcf	DALI_L, 1


	call	RecvBit				; Get bit 0
	btfsc	WREG1, 7
	goto	ReportErr
	btfsc	WREG1, 2
	bsf	DALI_L, 0
	btfss	WREG1, 2
	bcf	DALI_L, 0

	bsf	INTCON, GIE			; Enable Interrupts
	retlw	0x00

ReportErr
	clrf	DALI_L
	bsf	INTCON, GIE			; Enable Interrupts
	retlw	0xFE

	GLOBAL	RecvData
; *****************************************************************************

	
; *****************************************************************************
RecvBit
	movlf	0x01, TMR0		; Setup timer for 200us overflow
	bcf	INTCON, T0IF

	brclr	CMCON, C1OUT, LookForHi	; High or Low next
	
LookForLo	
	brclr	CMCON, C1OUT, FinRecv	; If low then finish receive

	brclr	INTCON, T0IF, LookForLo	; Too much time
	goto	RecvError		; Exit with error

LookForHi
	brset	CMCON, C1OUT, FinRecv	; If high then finish receive
	
	brclr	INTCON, T0IF, LookForHi	; Too much time
	goto	RecvError		; Exit with error

FinRecv
;	btfsc	RX_DEBUG, 0
	bsf	PORTB, 7

	delayf	RX_SAMPLE_DELAY_H, RX_SAMPLE_DELAY_L
;	delay	0xFFB0			; Delay 100us

;	btfsc	RX_DEBUG, 0
	bcf	PORTB, 7
	
	clrf	WREG1	
	btfsc	CMCON, C1OUT		
	bsf	WREG1, 2

	btfsc	RX_DEBUG, 1
	bsf	PORTB, 7

	delayf	RX_DELAY_NEXT_H, RX_DELAY_NEXT_L
;	delay	0xFDAF			; Delay 617us
;	delay	0xFDD8

	btfsc	RX_DEBUG, 1
	bcf	PORTB, 7

	return

RecvError
	bsf	WREG1, 7
	return				; Return with error
; *****************************************************************************

	END

