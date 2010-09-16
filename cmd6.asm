; *****************************************************************************
#include	p16f628.inc	; Standard include file
#include	instruct.inc	; Bring in complex instructions
#include	user_mac.inc	; Bring in application specific instructions
; *****************************************************************************


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
QUERY_SETTINGS	CODE
; *****************************************************************************
QueryTXEdge_H
	
	tx	TX_EDGE_DELAY_H

	goto	Main

	GLOBAL	QueryTXEdge_H
; *****************************************************************************


; *****************************************************************************
QueryTXEdge_L

	tx	TX_EDGE_DELAY_L

	goto	Main

	GLOBAL	QueryTXEdge_L
; *****************************************************************************


; *****************************************************************************
QueryTXStop_H

	tx	TX_STOP_DELAY_H

	goto	Main

	GLOBAL	QueryTXStop_H
; *****************************************************************************


; *****************************************************************************
QueryTXStop_L

	tx	TX_STOP_DELAY_L

	goto	Main

	GLOBAL	QueryTXStop_L
; *****************************************************************************


; *****************************************************************************
QueryTXReg_H

	tx	TX_REG_DELAY_H

	goto	Main

	GLOBAL	QueryTXReg_H
; *****************************************************************************


; *****************************************************************************
QueryTXReg_L

	tx	TX_REG_DELAY_L

	goto	Main

	GLOBAL	QueryTXReg_L
; *****************************************************************************


; *****************************************************************************
QueryRXWait

	tx	RX_WAIT

	goto	Main

	GLOBAL	QueryRXWait
; *****************************************************************************


; *****************************************************************************
QueryRXStart_H
	
	tx	RX_START_DELAY_H
	
	goto	Main

	GLOBAL	QueryRXStart_H
; *****************************************************************************


; *****************************************************************************
QueryRXStart_L
	
	tx	RX_START_DELAY_L
	
	goto	Main

	GLOBAL	QueryRXStart_L
; *****************************************************************************


; *****************************************************************************
QueryRXSample_H

	tx 	RX_SAMPLE_DELAY_H

	goto	Main

	GLOBAL	QueryRXSample_H
; *****************************************************************************


; *****************************************************************************
QueryRXSample_L

	tx 	RX_SAMPLE_DELAY_L

	goto	Main

	GLOBAL	QueryRXSample_L
; *****************************************************************************


; *****************************************************************************
QueryRXNext_H

	tx 	RX_DELAY_NEXT_H

	goto	Main

	GLOBAL	QueryRXNext_H
; *****************************************************************************


; *****************************************************************************
QueryRXNext_L

	tx 	RX_DELAY_NEXT_L

	goto	Main

	GLOBAL	QueryRXNext_L
; *****************************************************************************


; *****************************************************************************
QueryRXDebug

	tx 	RX_DEBUG

	goto	Main

	GLOBAL	QueryRXDebug
; *****************************************************************************


; *****************************************************************************
QueryDblSendDel

	tx 	DOUBLE_SEND_DELAY

	goto	Main

	GLOBAL	QueryDblSendDel
; *****************************************************************************


; *****************************************************************************
QuerySeqDel

	tx 	SEQUENCE_DELAY

	goto	Main

	GLOBAL	QuerySeqDel
; *****************************************************************************

	END
