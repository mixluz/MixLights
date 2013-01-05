; *****************************************************************************
; This file contains all defined registers for the main task to run.


; *** Constants ***************************************************************

; *****************************************************************************


; *** Externals ***************************************************************
	EXTERN	TimeCounter

	EXTERN	ResetBridge, ReportStatus, CommEcho	; Bridge commands
	EXTERN	SequenceDATA1, SequenceDATA2	; Sequence storage commands
	EXTERN 	SequenceDATA3
	EXTERN	SingleSend, DoubleSend, SendSequence		; DALI bus send commands
	EXTERN	SendReceive                 ; DALI bus send&receive
	EXTERN	SingleSendAck, DoubleSendAck, SendSequenceAck ; DALI bus send commands with acknowledge
	EXTERN	SendReceiveSB               ; DALI bus send&receive with single byte answer (or no answer on error)
	EXTERN	ChngTXEdgeDelay, ChngTXStopDelay
	EXTERN	ChngTXRegDelay, ChngRXWait, ChngRXStartDelay
	EXTERN	ChngRXSampleDelay, ChngRXDelayNext, ChngRXDebug
	EXTERN	ChngDblSendDelay, ChngSequenceDelay
	EXTERN	ChngBaudRate
	EXTERN	QueryTXEdge_H, QueryTXEdge_L, QueryTXStop_H, QueryTXStop_L
	EXTERN	QueryTXReg_H, QueryTXReg_L, QueryRXWait
	EXTERN	QueryRXStart_H, QueryRXStart_L, QueryRXSample_H, QueryRXSample_L
	EXTERN	QueryRXNext_H, QueryRXNext_L, QueryRXDebug
	EXTERN	QueryDblSendDel, QuerySeqDel
	EXTERN	LoadReset
;	EXTERN	SendData
; *****************************************************************************


; *** Variables ***************************************************************
MAIN_DATA	udata	0x20
; *****************************************************************************
TX_EDGE_DELAY_H		res	1
TX_EDGE_DELAY_L		res	1
TX_STOP_DELAY_H		res	1
TX_STOP_DELAY_L		res	1
TX_REG_DELAY_H		res	1
TX_REG_DELAY_L		res	1
RX_WAIT			res	1
RX_START_DELAY_H	res	1
RX_START_DELAY_L	res	1
RX_SAMPLE_DELAY_H	res	1
RX_SAMPLE_DELAY_L	res	1
RX_DELAY_NEXT_H		res	1
RX_DELAY_NEXT_L		res	1
RX_DEBUG		res	1
DOUBLE_SEND_DELAY	res	1
SEQUENCE_DELAY		res	1
BAUD_RATE		res	1

	GLOBAL	TX_EDGE_DELAY_H, TX_EDGE_DELAY_L, TX_STOP_DELAY_H, TX_STOP_DELAY_L
	GLOBAL	TX_REG_DELAY_H, TX_REG_DELAY_L, RX_WAIT, RX_START_DELAY_H
	GLOBAL	RX_START_DELAY_L, RX_SAMPLE_DELAY_H, RX_SAMPLE_DELAY_L
	GLOBAL	RX_DELAY_NEXT_H, RX_DELAY_NEXT_L, DOUBLE_SEND_DELAY, SEQUENCE_DELAY
	GLOBAL	RX_DEBUG, BAUD_RATE

COMMAND		res	1
DALI_H		res	1
DALI_L		res	1
BRIDGE_STATUS	res	1

DALI_H_BAK1	res	1
DALI_L_BAK1	res	1
DALI_H_BAK2	res	1
DALI_L_BAK2	res	1
DALI_H_BAK3	res	1
DALI_L_BAK3	res	1

	GLOBAL	DALI_H, DALI_L, BRIDGE_STATUS
	GLOBAL	DALI_H_BAK1, DALI_L_BAK1
	GLOBAL	DALI_H_BAK2, DALI_L_BAK2
	GLOBAL	DALI_H_BAK3, DALI_L_BAK3

MILLISECONDS	res	1		; This is an 8-bit 1ms timer
OVER_LOAD_CNT	res	1
COUNTER_L	res	1
	GLOBAL	MILLISECONDS, OVER_LOAD_CNT, COUNTER_L


SEARCH_H	res	1
SEARCH_M	res	1
SEARCH_L	res	1
	GLOBAL	SEARCH_H, SEARCH_M, SEARCH_L


WITH_ACK    res 1
    GLOBAL  WITH_ACK

; *****************************************************************************


; *** Variables ***************************************************************
ACCESS1		udata_shr
; *****************************************************************************
W_COPY		res	1
STATUS_COPY	res	1
PORTB_COPY	res	1
WREG1		res	1
WREG2		res	1
WREG3		res	1
WREG4		res	1
WREG5		res	1
WREG6		res	1
	GLOBAL	W_COPY, STATUS_COPY, WREG1
	GLOBAL	WREG2, WREG3, WREG4, WREG5, WREG6
	GLOBAL	PORTB_COPY
; *****************************************************************************
