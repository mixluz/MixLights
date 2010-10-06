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

	EXTERN  WITH_ACK
; *****************************************************************************



; *****************************************************************************
SEQUENCE_DATA	CODE
; *****************************************************************************
SingleSendAck
    bsf     WITH_ACK,0
    goto    doSingleSend

SingleSend
    bcf     WITH_ACK,0

doSingleSend
	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	EndSend

	txdali	DALI_H, DALI_L

	goto	EndSend

	GLOBAL	SingleSend
	GLOBAL	SingleSendAck
; *****************************************************************************


; *****************************************************************************
DoubleSendAck
    bsf     WITH_ACK,0
    goto    doDoubleSend

DoubleSend
    bcf     WITH_ACK,0

doDoubleSend
	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	EndSend


	txdali	DALI_H, DALI_L			; Transmit data on DALI bus

	clrf	MILLISECONDS			; Wait at least 10ms
Lp1	cffbis	MILLISECONDS, DOUBLE_SEND_DELAY, Lp1

	txdali	DALI_H, DALI_L			; Transmit again

	goto	EndSend

	GLOBAL	DoubleSend
	GLOBAL	DoubleSendAck
; *****************************************************************************


; *****************************************************************************
SendSequenceAck
    bsf     WITH_ACK,0
    goto    doSendSequence

SendSequence
    bcf     WITH_ACK,0

doSendSequence


	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	EndSend

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

	goto	EndSend

	GLOBAL	SendSequence
	GLOBAL	SendSequenceAck
; *****************************************************************************


; end of sending - check for ack
EndSend
    btfss   WITH_ACK,0  ; want ack for command?
    goto    Main ; no

    tx      BRIDGE_STATUS   ; wants ack when complete, send bridge status
    goto    Main ; sent ack, done now


; *****************************************************************************
; returns either 0x00 = receive failed
;         or     0xFF 0xXX = XX received successfully
SendReceive

	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	Main


	bcf	BRIDGE_STATUS, 1		; Clear error flag

	txdali	DALI_H, DALI_L			; Transmit data on DALI bus

	rxdali					; Receive data from DALI bus

	movwf	WREG1				; Check for receive error (W!=0 means rxdali error)
	movf	WREG1, F
	brz	Jp1

; failed receive
	bsf	BRIDGE_STATUS, 1		; Set receive error flag

	clrf	WREG1
	tx	WREG1				; Transmit 'no recv code'
	goto	Main

; successful receive
Jp1	movlf	0xFF, WREG1
	tx	WREG1				; Transmit 'recv code'

	delay	0x3CAF				; Wait for 100ms
	delay	0x3CAF

	tx	DALI_L				; Send via RS232
	goto	Main

	GLOBAL	SendReceive
; *****************************************************************************



; *****************************************************************************
; Variant that just returns single byte (or nothing if receive fails)
SendReceiveSB

	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	Main


	bcf	BRIDGE_STATUS, 1		; Clear error flag

	txdali	DALI_H, DALI_L			; Transmit data on DALI bus

	rxdali					; Receive data from DALI bus

	movwf	WREG1				; Check for receive error (W!=0 means rxdali error)
	movf	WREG1, F
	brz	Jp2

; failed receive
	bsf	BRIDGE_STATUS, 1		; Set receive error flag
	goto	Main

; successful receive
Jp2	tx	DALI_L				; Send via RS232
	goto	Main

	GLOBAL	SendReceiveSB
; *****************************************************************************



	END