
; luz: we should be aware of which bank we are in - so suppress the bank warning message
	errorlevel  -302              ; suppress message 302 from list file


; *****************************************************************************
#define	skifz		btfss	STATUS, Z	; Skip if zero
#define skifnz		btfsc	STATUS, Z	; Skip if not zero
; *****************************************************************************

; *** Branch if Zero **********************************************************
brz	macro	WHERE
	skifnz
	goto	WHERE
	endm
; *****************************************************************************

; *** Branch if Not Zero ******************************************************
brnz	macro	WHERE
	skifz
	goto	WHERE
	endm
; *****************************************************************************

; *** Wait Until Set **********************************************************
wus	macro	WHO, BIT
	btfss	WHO, BIT
	goto	$ - 1
	endm
; *****************************************************************************

; *** Wait Until Clear ********************************************************
wuc	macro	WHO, BIT
	btfsc	WHO, BIT
	goto	$ - 1
	endm
; *****************************************************************************

; *** Branch if Bit is Set ****************************************************
brset	macro	WHO, BIT, WHERE	
	btfsc	WHO, BIT
	goto	WHERE
	endm
; *****************************************************************************

; *** Branch if Bit is Clear **************************************************
brclr	macro	WHO, BIT, WHERE
	btfss	WHO, BIT
	goto	WHERE
	endm	
; *****************************************************************************

; *** Branch if Negative ******************************************************
brn	macro	WHERE
	btfss	STATUS, C
	goto	WHERE
	endm
; *****************************************************************************

; *** If FILE1 > FILE2 then Branch ********************************************
cffbig	macro	FILE1, FILE2, WHERE
	movf	FILE1, W
	subwf	FILE2, W
	btfss	STATUS, C
	goto	WHERE
	endm
; *****************************************************************************

; *** If FILE1 < FILE2 then Branch ********************************************
cffbis	macro	FILE1, FILE2, WHERE
	movf	FILE2, W
	subwf	FILE1, W
	btfss	STATUS, C
	goto	WHERE
	endm
; *****************************************************************************

; *** If FILE1 = FILE2 then Branch ********************************************
cffbie	macro	FILE1, FILE2, WHERE
	movf	FILE2, W
	subwf	FILE1, W
	btfsc	STATUS, Z
	goto	WHERE
	endm
; *****************************************************************************

; *** If FILE1 != FILE2 then Branch *******************************************
cffbin	macro	FILE1, FILE2, WHERE
	movf	FILE2, W
	subwf	FILE1, W
	btfss	STATUS, Z
	goto	WHERE
	endm
; *****************************************************************************

; *** If FILE1 > LIT1 then Branch *********************************************
cflbig	macro	FILE1, LIT1, WHERE
	movf	FILE1, W
	sublw	LIT1
	btfss	STATUS, C
	goto	WHERE
	endm
; *****************************************************************************

; *** If FILE1 < LIT1 then Branch *********************************************
cflbis	macro	FILE1, LIT1, WHERE
	movlw	LIT1
	subwf	FILE1, W
	btfss	STATUS, C
	goto	WHERE
	endm
; *****************************************************************************

; *** If FILE1 = LIT1 then Branch *********************************************
cflbie	macro	FILE1, LIT1, WHERE
	movf	FILE1, W
	sublw	LIT1
	btfsc	STATUS, Z
	goto	WHERE
	endm
; *****************************************************************************

; *** If FILE1 != LIT1 then Branch ********************************************
cflbin	macro	FILE1, LIT1, WHERE
	movf	FILE1, W
	sublw	LIT1
	btfss	STATUS, Z
	goto	WHERE
	endm
; *****************************************************************************

; *** If FILE1 > FILE2 then Branch ********************************************
cffcig	macro	FILE1, FILE2, WHERE
	movf	FILE1, W
	subwf	FILE2, W
	btfss	STATUS, C
	call	WHERE
	endm
; *****************************************************************************

; *** If FILE1 < FILE2 then Branch ********************************************
cffcis	macro	FILE1, FILE2, WHERE
	movf	FILE2, W
	subwf	FILE1, W
	btfss	STATUS, C
	call	WHERE
	endm
; *****************************************************************************

; *** If FILE1 = FILE2 then Branch ********************************************
cffcie	macro	FILE1, FILE2, WHERE
	movf	FILE2, W
	subwf	FILE1, W
	btfsc	STATUS, Z
	call	WHERE
	endm
; *****************************************************************************

; *** If FILE1 != FILE2 then Branch *******************************************
cffcin	macro	FILE1, FILE2, WHERE
	movf	FILE2, W
	subwf	FILE1, W
	btfss	STATUS, Z
	call	WHERE
	endm
; *****************************************************************************

; *** If FILE1 > LIT1 then Branch *********************************************
cflcig	macro	FILE1, LIT1, WHERE
	movf	FILE1, W
	sublw	LIT1
	btfss	STATUS, C
	call	WHERE
	endm
; *****************************************************************************

; *** If FILE1 < LIT1 then Branch *********************************************
cflcis	macro	FILE1, LIT1, WHERE
	movlw	LIT1
	subwf	FILE1, W
	btfss	STATUS, C
	call	WHERE
	endm
; *****************************************************************************

; *** If FILE1 = LIT1 then Branch *********************************************
cflcie	macro	FILE1, LIT1, WHERE
	movf	FILE1, W
	sublw	LIT1
	btfsc	STATUS, Z
	call	WHERE
	endm
; *****************************************************************************

; *** If FILE1 != LIT1 then Branch ********************************************
cflcin	macro	FILE1, LIT1, WHERE
	movf	FILE1, W
	sublw	LIT1
	btfss	STATUS, Z
	call	WHERE
	endm
; *****************************************************************************

; *****************************************************************************
movff	macro	HERE, THERE
	movf	HERE, W
	movwf	THERE
	endm
; *****************************************************************************

; *****************************************************************************
movlf	macro	DAT, THERE
	movlw	DAT
	movwf	THERE
	endm
; *****************************************************************************

; *** Add Literal to File *****************************************************
addlf	macro	LIT1, FILE1, DIR
	movlw	LIT1
	addwf	FILE1, DIR
	endm 	
; *****************************************************************************

; *** Subtract Literal from File **********************************************
sublf	macro	LIT1, FILE1, DIR
	movlw	LIT1
	subwf	FILE1, DIR
	endm 	
; *****************************************************************************

; *** Branch if Carry *********************************************************
brc	macro	WHERE
	btfsc	STATUS, C
	goto	WHERE
	endm
; *****************************************************************************

; *** Branch if No Carry ******************************************************
brnc	macro	WHERE
	btfss	STATUS, C
	goto	WHERE
	endm
; *****************************************************************************

; *** OR file w/ file *********************************************************
iorff	macro	FILE1, FILE2, DIR
	movf	FILE2, W
	iorwf	FILE1, DIR
	endm
; *****************************************************************************


