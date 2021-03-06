; *************************************************************************** ;
; Delay generator program by Ross Fosler			      	      ;
; v1.00	02/15/01   ... created ...					      ;
;								              ;
; This routine receives data according to the DALI specifications.	      ;
;									      ;
; *************************************************************************** ;


#include    common.inc		; include stuff that is common to all files


; *****************************************************************************
DELAY_CYCLES_T1	CODE
; *****************************************************************************
DelayCyclesT1
	movlf	b'00000001', T1CON	; Start TIMER1
	bcf	PIR1, TMR1IF
Lp1	brclr	PIR1, TMR1IF, Lp1	; Wait for overflow
	clrf	T1CON			; Stop TIMER1
	return

	GLOBAL	DelayCyclesT1
; *****************************************************************************

	END
