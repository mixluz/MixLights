; *************************************************************************** ;
; The RS232 to DALI interface by Ross Fosler				      ;
; v1.00	1/29/01   ... created ... 					      ;
;								              ;
; This is the main program to direct command execution and data reception.    ;
;            								      ;
; *************************************************************************** ;

 __CONFIG _CP_OFF & _WDT_ON & _BODEN_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _LVP_OFF


; *** Extra *******************************************************************
#include	p16f628.inc	; Standard include file
#include	instruct.inc	; Bring in complex instructions
#include	user_mac.inc	; Bring in application specific instructions	
#include	main.inc
; *****************************************************************************

 
; *** Vectors *****************************************************************
STARTUP	CODE
	goto 	Setup
	
INTVCT	CODE				; Handle interrupts 
	movwf	W_COPY			; Save data
	swapf	STATUS, W
	movwf	STATUS_COPY
	
	brset	INTCON, T0IF, TimeCounter

	goto	Setup
; *****************************************************************************


; **** Setup Everything *******************************************************
MAIN_SETUP	CODE			; Init all necessary 
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
		
	movlw	0x20			; Setup serial port send
	movwf	TXSTA
	movlw	0x18			; Setup baud rate, 2400 bps
	movwf	SPBRG

	movlf	0x02, TRISB		; Setup PORT directions
	movlf	0x27, TRISA		

;	movlf	0x80, OPTION_REG	; WDT and INT related bits
	movlf	0x8F, OPTION_REG	; WDT and INT related bits

	bsf	PCON, OSCF		; Set 4MHz

	banksel PORTA			; ** Select bank 0 **

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
	
MainLoop
	clrwdt

	brclr	PIR1, RCIF, MainLoop		; Receive command byte
	brset	RCSTA, FERR, Main		; Check for communication error
	brset	RCSTA, OERR, Main
	movff	RCREG, COMMAND		
	
	clrf	MILLISECONDS			; Wait 100ms before giving up
Lp2	cflbig	MILLISECONDS, 0x64, Main
	brclr	PIR1, RCIF, Lp2			; Receive high byte for DALI
	brset	RCSTA, FERR, Main		; Check for communication error
	brset	RCSTA, OERR, Main
	movff	RCREG, DALI_H

	clrf	MILLISECONDS			; Wait 100ms before giving up
Lp3	cflbig	MILLISECONDS, 0x64, Main
	brclr	PIR1, RCIF, Lp3			; Receive low byte for DALI
	brset	RCSTA, FERR, Main		; Check for communication error
	brset	RCSTA, OERR, Main
	movff	RCREG, DALI_L


	cflbie	COMMAND, 0x00, ResetBridge	; Bridge commands
	cflbie	COMMAND, 0x01, ReportStatus

	cflbie	COMMAND, 0x08, SequenceDATA1	; Storage
	cflbie	COMMAND, 0x09, SequenceDATA2
	cflbie	COMMAND, 0x0A, SequenceDATA3

	cflbie	COMMAND, 0x10, SingleSend	; DALI bus related commands
	cflbie	COMMAND, 0x11, DoubleSend
	cflbie	COMMAND, 0x12, SendReceive
	cflbie	COMMAND, 0x13, SendSequence

;	cflbie	COMMAND, 0x20, AutoFind
;	cflbie	COMMAND, 0x21, QuerySearch_H
;	cflbie	COMMAND, 0x22, QuerySearch_M
;	cflbie	COMMAND, 0x23, QuerySearch_L

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
	de	0x18, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	de	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	de 	0xFF, 0xFF, 0xFF
; *****************************************************************************


	END

