

; *****************************************************************************
#include	p16f628.inc	; Standard include file
#include	instruct.inc	; Bring in complex instructions
#include	user_mac.inc	; Bring in application specific instructions
; *****************************************************************************



; *****************************************************************************
	EXTERN	Main
	EXTERN	DALI_H, DALI_L, BRIDGE_STATUS
	EXTERN	DALI_H_BAK1, DALI_L_BAK1
	EXTERN	DALI_H_BAK2, DALI_L_BAK2
	EXTERN	DALI_H_BAK3, DALI_L_BAK3
; *****************************************************************************



; *****************************************************************************
SEQUENCE_DATA	CODE
; *****************************************************************************
SequenceDATA1

	movff	DALI_H, DALI_H_BAK1
	movff	DALI_L, DALI_L_BAK1

	goto	Main

	GLOBAL	SequenceDATA1
; *****************************************************************************


; *****************************************************************************
SequenceDATA2

	movff	DALI_H, DALI_H_BAK2
	movff	DALI_L, DALI_L_BAK2

	
	goto	Main

	GLOBAL	SequenceDATA2
; *****************************************************************************


; *****************************************************************************
SequenceDATA3

	movff	DALI_H, DALI_H_BAK3
	movff	DALI_L, DALI_L_BAK3
	
	goto	Main

	GLOBAL	SequenceDATA3
; *****************************************************************************

	END

