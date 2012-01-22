#include    common.inc		; include stuff that is common to all files


; *****************************************************************************
	EXTERN	SendData
	EXTERN	RecvData

	EXTERN	WriteEEData

	EXTERN	Main
	EXTERN	DelayCyclesT1

	EXTERN 	WREG1, DALI_H, DALI_L
	EXTERN	MILLISECONDS
	EXTERN	BRIDGE_STATUS

	EXTERN	DALI_H_BAK1, DALI_L_BAK1
	EXTERN	DALI_H_BAK2, DALI_L_BAK2
	EXTERN	DALI_H_BAK3, DALI_L_BAK3

	EXTERN	TX_EDGE_DELAY_H, TX_EDGE_DELAY_L, TX_STOP_DELAY_H, TX_STOP_DELAY_L
	EXTERN	TX_REG_DELAY_H, TX_REG_DELAY_L, RX_WAIT, RX_START_DELAY_H
	EXTERN	RX_START_DELAY_L, RX_SAMPLE_DELAY_H, RX_SAMPLE_DELAY_L
	EXTERN	RX_DELAY_NEXT_H, RX_DELAY_NEXT_L, DOUBLE_SEND_DELAY, SEQUENCE_DELAY
	EXTERN	RX_DEBUG, BAUD_RATE
; *****************************************************************************


; *****************************************************************************
CHANGE_SETTINGS	CODE
; *****************************************************************************
ChngTXEdgeDelay
	
	movff	DALI_H, TX_EDGE_DELAY_H
	wrtee	TX_EDGE_DELAY_H

	movff	DALI_L, TX_EDGE_DELAY_L
	wrtee	TX_EDGE_DELAY_L

	goto	Main

	GLOBAL	ChngTXEdgeDelay
; *****************************************************************************


; *****************************************************************************
ChngTXStopDelay

	movff	DALI_H, TX_STOP_DELAY_H
	wrtee	TX_STOP_DELAY_H

	movff	DALI_L, TX_STOP_DELAY_L
	wrtee	TX_STOP_DELAY_L

	goto	Main


	GLOBAL	ChngTXStopDelay
; *****************************************************************************


; *****************************************************************************
ChngTXRegDelay

	movff	DALI_H, TX_REG_DELAY_H
	wrtee	TX_REG_DELAY_H

	movff	DALI_L, TX_REG_DELAY_L
	wrtee	TX_REG_DELAY_L

	goto	Main

	GLOBAL	ChngTXRegDelay
; *****************************************************************************


; *****************************************************************************
ChngRXWait

	movff	DALI_L, RX_WAIT
	wrtee	RX_WAIT

	goto	Main

	GLOBAL	ChngRXWait
; *****************************************************************************


; *****************************************************************************
ChngRXStartDelay

	movff	DALI_H, RX_START_DELAY_H
	wrtee	RX_START_DELAY_H

	movff	DALI_L, RX_START_DELAY_L
	wrtee	RX_START_DELAY_L

	goto	Main

	GLOBAL	ChngRXStartDelay
; *****************************************************************************


; *****************************************************************************
ChngRXSampleDelay

	movff	DALI_H, RX_SAMPLE_DELAY_H
	wrtee	RX_SAMPLE_DELAY_H

	movff	DALI_L, RX_SAMPLE_DELAY_L
	wrtee	RX_SAMPLE_DELAY_L

	goto	Main

	GLOBAL	ChngRXSampleDelay
; *****************************************************************************


; *****************************************************************************
ChngRXDelayNext

	movff	DALI_H, RX_DELAY_NEXT_H
	wrtee	RX_DELAY_NEXT_H

	movff	DALI_L, RX_DELAY_NEXT_L
	wrtee RX_DELAY_NEXT_L

	goto	Main

	GLOBAL	ChngRXDelayNext
; *****************************************************************************


; *****************************************************************************
ChngRXDebug
	
	banksel TRISB
	bcf	TRISB, 7
	banksel PORTB
	movff	DALI_L, RX_DEBUG
;	wrtee	RX_DEBUG

	GLOBAL	ChngRXDebug
; *****************************************************************************


; *****************************************************************************
ChngDblSendDelay

	movff	DALI_L, DOUBLE_SEND_DELAY
	wrtee	DOUBLE_SEND_DELAY

	goto	Main

	GLOBAL	ChngDblSendDelay
; *****************************************************************************


; *****************************************************************************
ChngSequenceDelay

	movff	DALI_L, SEQUENCE_DELAY
	wrtee	SEQUENCE_DELAY

	goto	Main

	GLOBAL	ChngSequenceDelay
; *****************************************************************************


; *****************************************************************************
ChngBaudRate

	movff	DALI_L, BAUD_RATE
	wrtee	BAUD_RATE

	goto	Main

	GLOBAL	ChngBaudRate
; *****************************************************************************




	END
