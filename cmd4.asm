; *****************************************************************************
#include	p16f628.inc	; Standard include file
#include	instruct.inc	; Bring in complex instructions
#include	user_mac.inc	; Bring in application specific instructions
; *****************************************************************************


; *****************************************************************************
	EXTERN	SendData
	EXTERN	RecvData
	EXTERN	DelayCyclesT1

	EXTERN	Main
	EXTERN 	WREG1, DALI_H, DALI_L
	EXTERN	MILLISECONDS
	EXTERN	BRIDGE_STATUS

	EXTERN	WREG2, WREG3, WREG4, WREG5, WREG6
	EXTERN	SEARCH_H, SEARCH_M, SEARCH_L
; *****************************************************************************


; *****************************************************************************
SETUP_DALI	CODE
; *****************************************************************************
AutoFind
	btfsc	BRIDGE_STATUS, 2		; Prevent transmission if overload
	goto	Main

	movlf	0x80, SEARCH_H
	clrf 	SEARCH_M
	clrf 	SEARCH_L

	clrf	WREG5
	clrf	WREG4
	clrf	WREG3

Lp1	movlf	b'10110001', DALI_H		; Transmit search address
	iorff	WREG5, SEARCH_H, W
	movwf	DALI_L
;	txdali	DALI_H, DALI_L
;	delay	0xD8EF	
			
	movlf	b'10110011', DALI_H
	iorff	WREG4, SEARCH_M, W
	movwf	DALI_L
;	txdali	DALI_H, DALI_L
;	delay	0xD8EF

	movlf	b'10110111', DALI_H
	iorff	WREG3, SEARCH_L, W
	movwf	DALI_L
;	txdali	DALI_H, DALI_L
;	delay	0xD8EF

	movlf	b'10101001', DALI_H		; Compare search with random
	clrf	DALI_L
;	txdali	DALI_H, DALI_L
	
;	rxdali					; Receive data from DALI bus
			
	movf	DALI_L, W
	brnz	Jp3				; Jump if Search => Rand

	bcf	STATUS, C			; if Search < Rand
	rlf	SEARCH_L, F
	rlf	SEARCH_M, F
	rlf	SEARCH_H, F

	goto	Lp1

Jp3	bcf	STATUS, C			; If Search => Rand
	rrf	SEARCH_H, F
	rrf	SEARCH_M, F
	rrf	SEARCH_L, F
	
	iorff	WREG5, SEARCH_H, F
	iorff	WREG4, SEARCH_M, F
	iorff	WREG3, SEARCH_L, F
	
	clrf	SEARCH_H
	clrf	SEARCH_M
	movlf	0x01, SEARCH_L

	goto	Lp1
	
Jp4	movff	WREG5, SEARCH_H
	movff	WREG4, SEARCH_M
	movff	WREG3, SEARCH_L

	return
; *****************************************************************************


	END
	
