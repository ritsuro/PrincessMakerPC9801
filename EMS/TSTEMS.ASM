; "TSTEMS.ASM" PC-9801UV11 make by R.H 1990/12/29
;
;	DRVEMS test.
;
; public subroutine.

INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'
CODE	ENDS

EXTRN	EMMCHK:FAR			; EMM check.
EXTRN	EMM_G_S:FAR			; EMM Get Status.
EXTRN	EMM_G_P_FA:FAR			; EMM Get Page Frame Address.
EXTRN	EMM_G_U_PC:FAR			; EMM Get Unallocated Page Count.
EXTRN	EMM_A_P:FAR			; EMM Allocate Pages.
EXTRN	EMM_MU_H_P:FAR			; EMM Map/Unmap Handle Pages.
EXTRN	EMM_D_P:FAR			; EMM Deallocate Pages.

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

START:
	PUSH	DS			; save DS.

	MOV	AX,SEG DATA		; DS = DATA segment.
	MOV	DS,AX			;

	MOV	AX,SS			; stack segment.
	MOV	SAVE_SS,AX		;
	MOV	SAVE_SP,SP		; stack pointer.

	MOV	AX,SEG STACK		; stack segment.
	MOV	SS,AX			;
	MOV	SP,OFFSET TOP_OF_STACK	; stack pointer.

	CALL	MAIN			; main proc.

	MOV	AX,SAVE_SS		;
	MOV	SS,AX			; stack segment.
	MOV	SP,SAVE_SP		; stack pointer.

	POP	DS			;
FINALE:	MOV	AH,4CH			; return to DOS.
	MOV	AL,0			;
	INT	21H			; end.
MUGEN:					;
	JMP	MUGEN			;


; ****************************************************
;	ÉÅÉCÉìèàóù
; ****************************************************

MAIN	PROC	NEAR
	CALL	EMMCHK			; EMM check.
	PRV	"EMMCHK     -O- AX : 0=none,1=EMMset =",AX
	CMP	AX,0
	JNE	MAIN_START
	JMP	MAIN_EXIT
MAIN_START:

	CALL	EMM_G_S			; EMM Get Status.
	PRVH	"EMM_G_S    -O- AX : EMM status      =",AX

	CALL	EMM_G_P_FA		; EMM Get Page Frame Address.
	MOV	EMM_FRAME_ADRS,BX	; EMM page fream segment.
	PRVH	"EMM_G_P_FA -O- AX : EMM status             =",AX
	PRVH	"EMM_G_P_FA     BX : EMM page fream segment =",BX

	CALL	EMM_G_U_PC		; EMM Get Unallocated Page Count.
	PRVH	"EMM_G_U_PC -O- AX : EMM status                 =",AX
	PRV	"EMM_G_U_PC     BX : EMM unallocated page count.=",BX
	PRV	"EMM_G_U_PC     DX : EMM all page count.        =",DX

	CALL	EMM_A_P			; EMM Allocate Pages.
	PRVH	"EMM_A_P    -O- AX : EMM status             =",AX
	PRV	"EMM_A_P        DX : EMM handle             =",DX

	MOV	BX,0			; logical page number.
	CALL	EMM_MU_H_P		; EMM Map/Unmap Handle Pages.
	PRVH	"EMM_MU_H_P -O- AX : EMM status             =",AX

	PUSH	DS			;
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET BUFF1		;
	MOV	AX,EMM_FRAME_ADRS	; EMM page fream segment.
	MOV	DS,AX			;
	MOV	SI,0			;
	MOV	CX,8			;
	REP	MOVSB			;
	POP	DS			;
	PRS	"-I- print EMM frame=",BUFF1

	MOV	ES,EMM_FRAME_ADRS	; EMM page fream segment.
	MOV	DI,0			;
	MOV	CX,8			;
	MOV	SI,OFFSET BUFF2		;
	REP	MOVSB			;

	PUSH	DS			;
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET BUFF1		;
	MOV	AX,EMM_FRAME_ADRS	; EMM page fream segment.
	MOV	DS,AX			;
	MOV	SI,0			;
	MOV	CX,8			;
	REP	MOVSB			;
	POP	DS			;
	PRS	"-O- print EMM frame=",BUFF1

	CALL	EMM_D_P			; EMM Deallocate Pages.
	PRVH	"EMM_D_P    -O- AX : EMM status             =",AX

MAIN_EXIT:
	RET
MAIN	ENDP



CODE	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

SAVE_SS		DW	0	; stack segment.
SAVE_SP		DW	0	; stack pointer.

EMM_FRAME_ADRS	DW	0	; EMM page fream segment.

BUFF1	DB	"1234567",0
BUFF2	DB	"ABCDEFG",0
DATA	ENDS

STACK	SEGMENT	STACK
	EVEN
	DW	1000 DUP (?)
TOP_OF_STACK	LABEL	WORD
STACK	ENDS

	END	START
;
;	end of "TSTEMS.ASM"
;
