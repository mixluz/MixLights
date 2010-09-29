#include    common.inc		; include stuff that is common to all files



; *****************************************************************************
	EXTERN	SendData
	EXTERN	RecvData

	EXTERN	Main
	EXTERN	DelayCyclesT1

	EXTERN 	WREG1, DALI_H, DALI_L
	EXTERN	MILLISECONDS
	EXTERN	BRIDGE_STATUS

	EXTERN	DALI_H_BAK1, DALI_L_BAK1
	EXTERN	DALI_H_BAK2, DALI_L_BAK2
	EXTERN	DALI_H_BAK3, DALI_L_BAK3

	EXTERN	DOUBLE_SEND_DELAY
	EXTERN	SEQUENCE_DELAY
; *****************************************************************************



; *****************************************************************************
SEQUENCE_DATA	CODE
; *****************************************************************************
SingleSend

	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	Main

	txdali	DALI_H, DALI_L

	goto	Main

	GLOBAL	SingleSend
; *****************************************************************************


; *****************************************************************************
DoubleSend

	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	Main


	txdali	DALI_H, DALI_L			; Transmit data on DALI bus

	clrf	MILLISECONDS			; Wait at least 10ms
Lp1	cffbis	MILLISECONDS, DOUBLE_SEND_DELAY, Lp1 
	
	txdali	DALI_H, DALI_L			; Transmit again
	
	goto	Main

	GLOBAL	DoubleSend
; *****************************************************************************


; *****************************************************************************
SendReceive

	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	Main


	bcf	BRIDGE_STATUS, 1		; Clear error flag

	txdali	DALI_H, DALI_L			; Transmit data on DALI bus
	
	rxdali					; Receive data from DALI bus
			
	movwf	WREG1				; Check for receive error
	movf	WREG1, F
	brz	Jp1	

	bsf	BRIDGE_STATUS, 1		; Set receive error flag

	clrf	WREG1
	tx	WREG1				; Transmit 'no recv code'
	goto	Main

Jp1	movlf	0xFF, WREG1
	tx	WREG1				; Transmit 'recv code'	

	delay	0x3CAF				; Wait for 100ms
	delay	0x3CAF	

	tx	DALI_L				; Send via RS232
	goto	Main

	GLOBAL	SendReceive
; *****************************************************************************


; *****************************************************************************
SendSequence

	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	Main

	txdali	DALI_H_BAK1, DALI_L_BAK1	; Transmit data on DALI bus

	movf	MILLISECONDS, W			; Wait 10ms
	addwf	SEQUENCE_DELAY, W
	movwf	WREG1
Lp2	cffbin	WREG1, MILLISECONDS, Lp2
 	
	txdali	DALI_H_BAK2, DALI_H_BAK2	; Transmit next word in sequence

	movf	MILLISECONDS, W			; Wait 10ms
	addwf	SEQUENCE_DELAY, W
	movwf	WREG1
Lp3	cffbin	WREG1, MILLISECONDS, Lp3
	
	txdali	DALI_H_BAK3, DALI_H_BAK3	; Transmit last word in sequence

	goto	Main

	GLOBAL	SendSequence
; *****************************************************************************

	END
