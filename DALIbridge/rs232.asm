#include    common.inc		; include stuff that is common to all files

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

