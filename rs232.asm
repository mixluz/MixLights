#include	p16f628a.inc	; Standard include file

; *****************************************************************************
TX_RS232	CODE	
; *****************************************************************************
_XMIT_RS232
	movwf	TXREG

	
;	banksel	TXSTA
;	btfss	TXSTA, TRMT
;	goto	$ - 1


;	banksel	TXREG
	return

	GLOBAL	_XMIT_RS232
; *****************************************************************************




	END

