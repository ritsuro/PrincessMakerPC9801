; "TXTATR.ASM" PC-9801UV11 make by R.H 1989/12/22
;
;
;	�e�L�X�g�����Z�b�g
;
;
; public subroutine.


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	TXTBOX			; �e�L�X�g�����a�n�w�Z�b�g


TEXT_ATR	EQU	0A200H	; �e�L�X�g�����Z�O�����g


;	�e�L�X�g�����a�n�w�Z�b�g
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    DX      : attribute.
;
;	�A�g���r���[�g�\���i�c�w�j
;	7   6   5   4     3     2     1    0____
;	�f�@�q�@�a�@�a�f�@�t�k�@�q�u�@�a�k�@�r�s
;	�@�@�@�@�@�@�u�k

TXTBOX	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	DI
	PUSH	SI

	MOV	DI,VY1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	AX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,AX			; di = vy1 * 80 * 2
	SHL	DI,1			;

	MOV	AX,VX1			;
	SHL	AX,1			;
	ADD	DI,AX			; di = di + ( vx1 * 2 )
	MOV	SI,DI			; si = di

	MOV	CX,VY2			;
	SUB	CX,VY1			;
	INC	CX			; cx = Vy2 - Vy1 + 1

	MOV	BX,VX2			;
	SUB	BX,VX1			;
	INC	BX			; bx  = Vx2 - Vx1 + 1
	MOV	AH,0			;
	MOV	AL,DL			; �������Z�b�g
TXTBOX1:PUSH	CX
	MOV	DI,SI			; si = di
	MOV	DX,TEXT_ATR		; �e�L�X�g�����Z�O�����g
	MOV	ES,DX
	MOV	CX,BX
	REP	STOSW			; GDC word address.

	ADD	SI,160			; GDC word address.
	POP	CX
	LOOP	TXTBOX1

	POP	SI
	POP	DI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
TXTBOX	ENDP

CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.

DATA	ENDS

	END
;
;	end of "TXTATR.ASM"
;
