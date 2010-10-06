; *************************************************************************** ;
; The RS232 to DALI interface by Ross Fosler				      ;
; v1.00	1/29/01   ... created ... 					      ;
;								              ;
; This is the main program to direct command execution and data reception.    ;
;            								      ;
; *************************************************************************** ;

; original from AN for 16F628 non-A
; __CONFIG _CP_OFF & _WDT_ON & _BODEN_OFF & _INTRC_OSC_CLKOUT & _MCLRE_ON & _LVP_OFF

; original from 16F628A template for MPASM suite
; __CONFIG _CP_OFF & _DATA_CP_OFF & _LVP_OFF & _BOREN_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT

 __CONFIG _CP_OFF & _DATA_CP_OFF & _LVP_OFF & _BOREN_OFF & _MCLRE_ON & _WDT_ON & _PWRTE_ON & _INTOSC_OSC_CLKOUT


#include    common.inc		; include stuff that is common to all files

; *** Extra *******************************************************************
#include	main.inc
; *****************************************************************************


; *** Vectors *****************************************************************
	ORG     0x000             ; processor reset vector
	goto 	Setup

	ORG     0x004             ; interrupt vector location
	movwf	W_COPY			; Save data
	swapf	STATUS, W
	movwf	STATUS_COPY

	brset	INTCON, T0IF, TimeCounter

; spurios interrupt - reset
	goto	Setup
; *****************************************************************************


; *****************************************************************************
Setup

	banksel	PORTA			; ** Select bank 0 **

	clrf	TMR0			; Reset TIMER0

	movlw	0x90			; Setup serial port receive
	movwf	RCSTA

	movlf	0x36, CMCON		; Setup comparators

	movlf	0x00, PIR1		; Clear int flags
	movlf	0x00, INTCON		; Setup interrupts

	clrf	PORTA			; Clear the ports
	clrf	PORTB

	movlf	0x02, OVER_LOAD_CNT	; Init overload counter


	banksel	TXSTA			; ** Select bank 1 **

	movlw	0x20			; Setup serial port send, low speed
;	movlw	0x24			; Setup serial port send, high speed (4x lowspeed)
	movwf	TXSTA
	movlw	0x19			; Setup baud rate, 0x19=2400/9600 bps, 0x0C=xxx/19200
	movwf	SPBRG

	movlf	0x02, TRISB		; RB1 = Rx from PC - Setup PORT directions
	movlf	0x27, TRISA		; RA0..2 = analog in, RA5 = reset in

;	movlf	0x80, OPTION_REG	; WDT and INT related bits
	movlf	0x8F, OPTION_REG	; WDT and INT related bits (No weak pullup on PortB)

	bsf	PCON, OSCF		; Set 4MHz

	banksel PORTA			; ** Select bank 0 **

	bsf		PORTB,7			; luz: signal startup of program


	call	LoadReset		; Load the reset values

	movf	BAUD_RATE, W		; Load the baud rate
	banksel	SPBRG
	movwf	SPBRG
	banksel	PORTA


	bsf	INTCON, T0IE		; Enable TIMER0 interrupt

	bsf	INTCON, GIE		; Enable interrupts

	clrf	BRIDGE_STATUS		; Init the status register

	clrf	MILLISECONDS

Lp1	cflbig	MILLISECONDS, 0xFA, Main

	brclr	CMCON, C1OUT, Lp1	; Wait 250ms for circuit stabilization

	goto		Main
; *****************************************************************************


; *** Main Decision Branch ****************************************************
MAIN_PROG	CODE
; *****************************************************************************
Main
	banksel	PORTA
	bcf	RCSTA, CREN			; Reset Communications
	movlf	0x90, RCSTA

	movf	BAUD_RATE, W			; Load the baud rate
	banksel	TXSTA				; ** Select bank 1 **
	movwf	SPBRG
	movlf	0x20, TXSTA			; Setup serial port send
	banksel	PORTA				; ** Select bank 0 **

	bcf	RCSTA, CREN			; Reset Communications
	bsf	RCSTA, CREN

	movf	RCREG, W			; Clear FIFO
	movf	RCREG, W

	bcf		PORTB,7					; luz: init Rx activity signal bit


MainLoop
	clrwdt

	brclr	PIR1, RCIF, MainLoop		; Receive command byte

	bsf		PORTB,7					; luz: signal reception of command byte

	brset	RCSTA, FERR, Main		; Check for communication error
	brset	RCSTA, OERR, Main
	movff	RCREG, COMMAND


	clrf	MILLISECONDS			; Wait 100ms before giving up
Lp2	cflbig	MILLISECONDS, 0x64, Main
	brclr	PIR1, RCIF, Lp2			; Receive high byte for DALI
	bcf		PORTB,7					; luz: pulse down to signal reception of second byte
	brset	RCSTA, FERR, Main		; Check for communication error
	brset	RCSTA, OERR, Main
	movff	RCREG, DALI_H
	bsf		PORTB,7					; luz: high again as we still receive a command



	clrf	MILLISECONDS			; Wait 100ms before giving up
Lp3	cflbig	MILLISECONDS, 0x64, Main
	brclr	PIR1, RCIF, Lp3			; Receive low byte for DALI
	bcf		PORTB,7					; luz: pulse down to signal reception of third byte
	brset	RCSTA, FERR, Main		; Check for communication error
	brset	RCSTA, OERR, Main
	movff	RCREG, DALI_L

	bsf		PORTB,7					; luz: high again as we still receive a command


	cflbie	COMMAND, 0x00, ResetBridge	; Bridge commands
	cflbie	COMMAND, 0x01, ReportStatus

	cflbie	COMMAND, 0x45, CommEcho  ; luz: Echoes DALI_H


	cflbie	COMMAND, 0x08, SequenceDATA1	; Storage
	cflbie	COMMAND, 0x09, SequenceDATA2
	cflbie	COMMAND, 0x0A, SequenceDATA3

	cflbie	COMMAND, 0x10, SingleSend	; DALI bus related commands
	cflbie	COMMAND, 0x11, DoubleSend
	cflbie	COMMAND, 0x12, SendReceive
	cflbie	COMMAND, 0x13, SendSequence

	cflbie	COMMAND, 0x30, SingleSendAck	; DALI bus sending commands with single byte ack when complete
	cflbie	COMMAND, 0x31, DoubleSendAck
	cflbie	COMMAND, 0x32, SendReceiveSB    ; DALI send with single byte receive (or nothing)
	cflbie	COMMAND, 0x33, SendSequenceAck



;	cflbie	COMMAND, 0x20, AutoFind
;	cflbie	COMMAND, 0x21, QuerySearch_H
;	cflbie	COMMAND, 0x22, QuerySearch_M
;	cflbie	COMMAND, 0x23, QuerySearch_L




; %%% disabled cmds below to prevent accidental param (BAUD!) changes in the bridge
    goto Main;

	cflbie	COMMAND, 0xC0, ChngTXEdgeDelay
	cflbie	COMMAND, 0xC1, ChngTXStopDelay
	cflbie	COMMAND, 0xC2, ChngTXRegDelay
	cflbie	COMMAND, 0xC3, ChngRXWait
	cflbie	COMMAND, 0xC4, ChngRXStartDelay
	cflbie	COMMAND, 0xC5, ChngRXSampleDelay
	cflbie	COMMAND, 0xC6, ChngRXDelayNext
	cflbie	COMMAND, 0xC7, ChngRXDebug
	cflbie	COMMAND, 0xC8, ChngDblSendDelay
	cflbie	COMMAND, 0xC9, ChngSequenceDelay
	cflbie	COMMAND, 0xCA, ChngBaudRate

	cflbie	COMMAND, 0xD0, QueryTXEdge_H
	cflbie	COMMAND, 0xD1, QueryTXEdge_L
	cflbie	COMMAND, 0xD2, QueryTXStop_H
	cflbie	COMMAND, 0xD3, QueryTXStop_L
	cflbie	COMMAND, 0xD4, QueryTXReg_H
	cflbie	COMMAND, 0xD5, QueryTXReg_L
	cflbie	COMMAND, 0xD6, QueryRXWait
	cflbie	COMMAND, 0xD7, QueryRXStart_H
	cflbie	COMMAND, 0xD8, QueryRXStart_L
	cflbie	COMMAND, 0xD9, QueryRXSample_H
	cflbie	COMMAND, 0xDA, QueryRXSample_L
	cflbie	COMMAND, 0xDB, QueryRXNext_H
	cflbie	COMMAND, 0xDC, QueryRXNext_L
	cflbie	COMMAND, 0xDD, QueryRXDebug
	cflbie	COMMAND, 0xDE, QueryDblSendDel
	cflbie	COMMAND, 0xDF, QuerySeqDel




	goto	Main


	GLOBAL	Main


; *****************************************************************************



; *** EEDATA Memory ***********************************************************
EE_DATA	CODE	0x2100
; *****************************************************************************
	de	0xFE, 0x80, 0xFA, 0xFF, 0xFE, 0x7C, 0x0A, 0xFE
	de	0xD3, 0xFF, 0xB0, 0xFD, 0xD8, 0x00, 0x0B, 0x0B
	de	0x19, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF ; first is baud: 0x19=2400/9600 bps, 0x0C=xxx/19200 (9600bd is max for opto couplers)
	de	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	de 	0xFF, 0xFF, 0xFF
; *****************************************************************************


	END

