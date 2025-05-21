; "ADVPLT.ASM" 1989/3/21 R.H  PC-9801UV11 make by R.H 1989
;       modify 1989/12/08 R.H
;       modify 1990/10/27 R.H
;
; public subroutine.

;*;INCLUDE	TSTSET.INC

EXTRN	IN_7220_GDC_PORT:FAR	; (far) in  port 7220 GDC.
EXTRN	OUT_7220_GDC_PORT:FAR	; (far) out port 7220 GDC.

IN_GDC	MACRO	AA,NUM
;same;	IN	AL,NUM
	PUSH	DX
	MOV	DX,NUM			;
	CALL	IN_7220_GDC_PORT	; (far) in  port 7220 GDC.
	POP	DX
	ENDM

OUTGDC	MACRO	NUM,AA
;same;	OUT	NUM,AL
	PUSH	DX
	MOV	DX,NUM			;
	CALL	OUT_7220_GDC_PORT	; (far) out port 7220 GDC.
	POP	DX
	ENDM


CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	SETCLR		; color set.
	PUBLIC	CLRSET		; color register set.

; color set.
; -i- CLRCDE : color code.
;     CLRVEW : color.
;     CLRCNS : contrast.
;     CLRBRI : brightness.

SETCLR	PROC	NEAR
;*DBG*;	PRV	"CLRCDE=",CLRCDE
;*DBG*;	PRV	"CLRVEW=",CLRVEW
;*DBG*;	PRV	"CLRCNS=",CLRCNS
;*DBG*;	PRV	"CLRBRI=",CLRBRI
;*DBG*;

	MOV	AX,CLRBRI	; MEIDO
	SHL	AX,1		;
	SHL	AX,1		;
	SHL	AX,1		;
	SHL	AX,1		; AX = CLRBRI * 16
	MOV	UPPER,AX	;

	MOV	AX,CLRCNS	; SAIDO
	MOV	BX,UPPER	;
	CWD			;
	MUL	BX		; AX = UPPER * BL
	DIV	DIV100		; AX = AX / 100

	MOV	BX,UPPER	;
	SUB	BX,AX		; UNDER = UPPER - AX
	MOV	UNDER,BX	;

	MOV	AX,UPPER	;
	SUB	AX,UNDER	; WIDE = UPPER - UNDER
	MOV	WIDE,AX		;

	CMP	WORD PTR CLRVEW,60
	JGE	SETCLR1
	JMP	SETCLRLV1
SETCLR1:
	CMP	WORD PTR CLRVEW,120
	JGE	SETCLR2
	JMP	SETCLRLV2
SETCLR2:
	CMP	WORD PTR CLRVEW,180
	JGE	SETCLR3
	JMP	SETCLRLV3
SETCLR3:
	CMP	WORD PTR CLRVEW,240
	JGE	SETCLR4
	JMP	SETCLRLV4
SETCLR4:
	CMP	WORD PTR CLRVEW,300
	JGE	SETCLR5
	JMP	SETCLRLV5
SETCLR5:
	JMP	SETCLRLV6

SETCLRLV1:
	MOV	AX,CLRVEW		; CLRVEW
	MOV	BX,WIDE			;
	MUL	BX			; CGREEN = CLRVEW * WIDE / 60
	DIV	DIV60			;         + UNDER
	ADD	AX,UNDER		;
	MOV	CGREEN,AX		;

	MOV	AX,UPPER		; CRED = UPPER
	MOV	CRED,AX			;
	MOV	AX,UNDER		; CBLUE = UNDER
	MOV	CBLUE,AX		;

	JMP	SETCLR_SET		;

SETCLRLV2:
	MOV	BX,CLRVEW		;
	SUB	BX,60			;
	MOV	AX,60			;
	SUB	AX,BX			; AX = 60 - ( CLRVEW - 60 )

	MOV	BX,WIDE			;
	MUL	BX			; CRED = AX * WIDE / 60
	DIV	DIV60			;         + UNDER
	ADD	AX,UNDER		;
	MOV	CRED,AX			;

	MOV	AX,UPPER		; CGREEN = UPPER
	MOV	CGREEN,AX		;
	MOV	AX,UNDER		; CBLUE = UNDER
	MOV	CBLUE,AX		;

	JMP	SETCLR_SET		;

SETCLRLV3:
	MOV	AX,CLRVEW		;
	SUB	AX,120			; CLRVEW
	MOV	BX,WIDE			;
	MUL	BX			; CBLUE = AX * WIDE / 60
	DIV	DIV60			;         + UNDER
	ADD	AX,UNDER		;
	MOV	CBLUE,AX		;

	MOV	AX,UPPER		; CGREEN = UPPER
	MOV	CGREEN,AX		;
	MOV	AX,UNDER		; CRED   = UNDER
	MOV	CRED,AX			;

	JMP	SETCLR_SET		;

SETCLRLV4:
	MOV	BX,CLRVEW		;
	SUB	BX,180			;
	MOV	AX,60			;
	SUB	AX,BX			; AX = 60 - ( CLRVEW - 60 )

	MOV	BX,WIDE			;
	MUL	BX			; CGREEN = AX * WIDE / 60
	DIV	DIV60			;         + UNDER
	ADD	AX,UNDER		;
	MOV	CGREEN,AX		;

	MOV	AX,UPPER		; CBLUE = UPPER
	MOV	CBLUE,AX		;
	MOV	AX,UNDER		; CRED  = UNDER
	MOV	CRED,AX			;

	JMP	SETCLR_SET		;

SETCLRLV5:
	MOV	AX,CLRVEW		;
	SUB	AX,240			; CLRVEW
	MOV	BX,WIDE			;
	MUL	BX			; CRED = HI1 * WIDE / 60
	DIV	DIV60			;         + UNDER
	ADD	AX,UNDER		;
	MOV	CRED,AX			;

	MOV	AX,UPPER		; CBLUE = UPPER
	MOV	CBLUE,AX		;
	MOV	AX,UNDER		; CGREEN = UNDER
	MOV	CGREEN,AX		;

	JMP	SETCLR_SET		;

SETCLRLV6:
	MOV	BX,CLRVEW		;
	SUB	BX,300			;
	MOV	AX,60			;
	SUB	AX,BX			; AX = 60 - ( CLRVEW - 60 )

	MOV	BX,WIDE			;
	MUL	BX			; CBLUE = AX * WIDE / 60
	DIV	DIV60			;         + UNDER
	ADD	AX,UNDER		;
	MOV	CBLUE,AX		;

	MOV	AX,UPPER		; CRED = UPPER
	MOV	CRED,AX			;
	MOV	AX,UNDER		; CGREEN = UNDER
	MOV	CGREEN,AX		;

	JMP	SETCLR_SET		;

SETCLR_SET:
	MOV	AX,CBLUE		;
	CWD				;
	DIV	DIV100			; AX = AX / 100
	MOV	CBLUE,AX		;

	MOV	AX,CRED			;
	CWD				;
	DIV	DIV100			; AX = AX / 100
	MOV	CRED,AX			;

	MOV	AX,CGREEN		;
	CWD				;
	DIV	DIV100			; AX = AX / 100
	MOV	CGREEN,AX		;

	MOV	AX,CLRCDE		;
	MOV	CRNUM,AX		; CRNUM = CLRCDE



	CMP	SW_ANALOG,0		; 0=normal analog
	JE	SETCLR_ANALOG		;
	CMP	SW_ANALOG,1		; 1=386LSX(15color)
	JE	SETCLR_386LSX		;
	CMP	SW_ANALOG,2		; 2=full DIGITAL
	JE	SETCLR_FULL_DIGITAL	;
	CMP	SW_ANALOG,3		; 3=B/W.
	JE	SETCLR_BW		;

SETCLR_ANALOG:
	CALL	CLRSET			; color register set.
	JMP	SETCLR_EXIT		;

SETCLR_386LSX:
	CALL	CLRSET_386LSX		; color register set for PC-386LSX
	JMP	SETCLR_EXIT		;

SETCLR_FULL_DIGITAL:
	CALL	CLRSET_FULL_DIGITAL	; color register set for full DIGITAL.
	JMP	SETCLR_EXIT		;

SETCLR_BW:				;
	CALL	CLRSET_BW		; color register set for B/W.
	JMP	SETCLR_EXIT		;

SETCLR_EXIT:
	RET
SETCLR	ENDP


; color register set.
; -i- CRNUM  : color code.
;     CBLUE  : blue  value (0-15)
;     CRED   : red   value (0-15)
;     CGREEN : green value (0-15)

CLRSET	PROC	NEAR
;*DBG*;	PR	"NO,B,R,G="
;*DBG*;	MOV	DX,CRNUM	; color code.
;*DBG*;	CALL	DECSTR
;*DBG*;	CALL	PRINT
;*DBG*;	PR	","
;*DBG*;	MOV	DX,CBLUE	; blue  value (0-15)
;*DBG*;	CALL	DECSTR
;*DBG*;	CALL	PRINT
;*DBG*;	PR	","
;*DBG*;	MOV	DX,CRED		; red   value (0-15)
;*DBG*;	CALL	DECSTR
;*DBG*;	CALL	PRINT
;*DBG*;	PR	","
;*DBG*;	MOV	DX,CGREEN	; green value (0-15)
;*DBG*;	CALL	DECSTR
;*DBG*;	CALL	PRINT
;*DBG*;	LF
;*DBG*;
	MOV	AX,CRNUM	;
	OUTGDC	0A8H,AL		; AD REG

	MOV	AX,CGREEN	;
	CMP	AX,16		;
	JB	CLRSET1		;
	MOV	AX,15		;
CLRSET1:
	OUTGDC	0AAH,AL		; pallet CGREEN

	MOV	AX,CRED		;
	CMP	AX,16		;
	JB	CLRSET2		;
	MOV	AX,15		;
CLRSET2:
	OUTGDC	0ACH,AL		; pallet CRED

	MOV	AX,CBLUE	;
	CMP	AX,16		;
	JB	CLRSET3		;
	MOV	AX,15		;
CLRSET3:
	OUTGDC	0AEH,AL		; pallet CBLUE

	RET
CLRSET	ENDP




; color register set for PC-386LSX
; -i- CRNUM  : color code.
;     CBLUE  : blue  value (0-15)
;     CRED   : red   value (0-15)
;     CGREEN : green value (0-15)

CLRSET_386LSX	PROC	NEAR
	MOV	AX,CRNUM	;
	OUTGDC	0A8H,AL		; AD REG

	MOV	AX,CGREEN	;
	CMP	AX,8		;
	JB	CLRSET51	;
	CMP	AX,12		;
	JB	CLRSET510	;
	MOV	AX,15		;
	JMP	CLRSET511	;
CLRSET51:			;
	MOV	AX,0		;
	JMP	CLRSET511	;
CLRSET510:			;
	MOV	AX,9		;
CLRSET511:			;
	OUTGDC	0AAH,AL		; pallet CGREEN

	MOV	AX,CRED		;
	CMP	AX,8		;
	JB	CLRSET52	;
	CMP	AX,11		;
	JB	CLRSET520	;
	MOV	AX,15		;
	JMP	CLRSET521	;
CLRSET52:			;
	MOV	AX,0		;
	JMP	CLRSET521	;
CLRSET520:			;
	MOV	AX,0		;
CLRSET521:			;
	OUTGDC	0ACH,AL		; pallet CRED

	MOV	AX,CBLUE	;
	CMP	AX,8		;
	JB	CLRSET53	;
	CMP	AX,12		;
	JB	CLRSET530	;
	MOV	AX,15		;
	JMP	CLRSET531	;
CLRSET53:			;
	MOV	AX,0		;
	JMP	CLRSET531	;
CLRSET530:			;
	MOV	AX,0		;
CLRSET531:			;
	OUTGDC	0AEH,AL		; pallet CBLUE

	RET
CLRSET_386LSX	ENDP


; color register set for full DIGITAL.
; -i- CRNUM  : color code.
;     CBLUE  : blue  value (0-15)
;     CRED   : red   value (0-15)
;     CGREEN : green value (0-15)

CLRSET_FULL_DIGITAL	PROC	NEAR
	MOV	AX,CRNUM	;
	OUTGDC	0A8H,AL		; AD REG

	CMP	CRNUM,8		;
	JNE	CLRSET6_GRAY	;

	MOV	AL,9		;
	OUTGDC	0AEH,AL		; pallet CBLUE
	OUTGDC	0ACH,AL		; pallet CRED
	OUTGDC	0AAH,AL		; pallet CGREEN
	RET
CLRSET6_GRAY:

	MOV	CBLUE,0		;
	MOV	CRED,0		;
	MOV	CGREEN,0	;

	MOV	DX,15		; on color.
	TEST	CRNUM,1000B	;
	JNZ	CLRSET60	;
	MOV	DX,15		; harf color.
CLRSET60:


	TEST	CRNUM,0100B	; color code.
	JZ	CLRSET61	;
	MOV	CGREEN,DX	;
CLRSET61:
	MOV	AX,CGREEN	;
	OUTGDC	0AAH,AL		; pallet CGREEN


	TEST	CRNUM,0010B	; color code.
	JZ	CLRSET62	;
	MOV	CRED,DX		;
CLRSET62:
	MOV	AX,CRED		;
	OUTGDC	0ACH,AL		; pallet CRED


	TEST	CRNUM,0001B	; color code.
	JZ	CLRSET63	;
	MOV	CBLUE,DX	;
CLRSET63:
	MOV	AX,CBLUE	;
	OUTGDC	0AEH,AL		; pallet CBLUE

	RET
CLRSET_FULL_DIGITAL	ENDP


; color register set for B/W.
; -i- CLRCDE : color code.
;     CLRVEW : color.
;     CLRCNS : contrast.
;     CLRBRI : brightness.

CLRSET_BW	PROC	NEAR
	MOV	AX,CLRCDE	;
	OUTGDC	0A8H,AL		; AD REG

	MOV	AX,CLRBRI	; brightness.
	SUB	AX,11		;
	JGE	CLRSET_BW01	;
	MOV	AX,0		;
CLRSET_BW01:

	MOV	BX,13		; 0-100 -> 0-15
	MOV	DX,0		;
	DIV	BX		; / 12
	MOV	CX,AX		;

	CMP	CX,7		;
	JLE	CLRSET_BW1	;
	MOV	CX,7		;
CLRSET_BW1:

	CMP	CLRCNS,5		; contrast.
	JG	CLRSET_BW11		;		white.
	CMP	CLRBRI,97		; brightness.
	JL	CLRSET_BW11		;
	MOV	CX,7			;
	JMP	CLRSET_BW5		;
CLRSET_BW11:

	CMP	WORD PTR CLRVEW,50	;
	JL	CLRSET_BW12		; blue.
	CMP	WORD PTR CLRVEW,90	;		yellow.
	JG	CLRSET_BW12		;
	CMP	CLRBRI,80		; brightness.
	JL	CLRSET_BW12		;
	MOV	CX,6			;
	JMP	CLRSET_BW5		;
CLRSET_BW12:


	CMP	CLRCNS,40		; contrast.
	JL	CLRSET_BW_GRAY		;

	CMP	WORD PTR CLRVEW,180	;
	JL	CLRSET_BW2		; blue.
	CMP	WORD PTR CLRVEW,300	;
	JG	CLRSET_BW2		;
	CMP	CX,0			;
	JE	CLRSET_BW13		;
	SHR	CX,1			; /2
	SHR	CX,1			; /2
	ADD	CX,1			;
CLRSET_BW13:				;
	JMP	CLRSET_BW5		;
CLRSET_BW2:				;

	CMP	CX,0			;
	JE	CLRSET_BW44		;
	SHR	CX,1			; /2
;*;	ADD	CX,1			;
CLRSET_BW44:				;

	JMP	CLRSET_BW5		;

CLRSET_BW_GRAY:				;
	CMP	CX,0			;
	JE	CLRSET_BW5		;
	DEC	CX			;
	CMP	CX,1			;
	JGE	CLRSET_BW5		;
	MOV	CX,1			;

CLRSET_BW5:				;

	MOV	AL,0		;
	TEST	CX,0100B	; color code.
	JZ	CLRSET_BW61	;
	MOV	AL,15		;
CLRSET_BW61:			;
	OUTGDC	0AAH,AL		; pallet CGREEN

	MOV	AL,0		;
	TEST	CX,0010B	; color code.
	JZ	CLRSET_BW62	;
	MOV	AL,15		;
CLRSET_BW62:			;
	OUTGDC	0ACH,AL		; pallet CRED

	MOV	AL,0		;
	TEST	CX,0001B	; color code.
	JZ	CLRSET_BW63	;
	MOV	AL,15		;
CLRSET_BW63:			;
	OUTGDC	0AEH,AL		; pallet CBLUE

	RET
CLRSET_BW	ENDP


CODE	ENDS




DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	SW_ANALOG	; analog switch. 0=normal analog,1=386LSX(15color)
			; 2=full DIGITAL,3=B/W

PUBLIC	CLRCDE		; color code.
PUBLIC	CLRVEW		; color view.
PUBLIC	CLRCNS		; contrast.
PUBLIC	CLRBRI		; brightness.

PUBLIC	CRNUM		; color code.       
PUBLIC	CBLUE		; blue  value (0-15)
PUBLIC	CRED		; red   value (0-15)
PUBLIC	CGREEN		; green value (0-15)

	EVEN

SW_ANALOG	DW	-1	; analog switch.
				;

CLRCDE		DW	0	; color code.
CLRVEW		DW	0	; color view.
CLRCNS		DW	0	; contrast.
CLRBRI		DW	0	; brightness.

CRNUM		DW	0	; color code.       
CBLUE		DW	0	; blue  value (0-15)
CRED		DW	0	; red   value (0-15)
CGREEN		DW	0	; green value (0-15)


UPPER		DW	0	;
UNDER		DW	0	;
WIDE		DW	0	;

DIV100		DW	100	;
DIV60		DW	60	;

	EVEN

DATA	ENDS

	END
;
;	end of "ADVPLT.ASM"
;
