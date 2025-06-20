; "TOUCH.ASM" PC-9801UV11 make by R.H 1989/12/24
;
;
;	�^�b�`����
;	�c���W�h�b�g�P�ʍ��W�n
;	�����̃}�g���b�N�X�͂S�O���Q�T
;
; public subroutine.


TOUCH	SEGMENT	PUBLIC	'TOUCH'
TOUCH	ENDS

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	TCHGET			; �^�b�`�����f�d�s
PUBLIC	TCHPUT			; �^�b�`�����o�t�s

TOUCH_SIZE	EQU	40*25	; �^�b�`�����o�b�t�@�T�C�Y


;	�^�b�`�����f�d�s
;	-i- VX1,VY1 : start point.
;	-o- AX      : attribute.
;

TCHGET	PROC	NEAR
	PUSH	DI
	PUSH	ES

	MOV	DI,VY1			;
	SHR	DI,1			; / 2

	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			; * 8
	MOV	AX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,AX			; di = vy1 * 40

	MOV	AX,VX1			;
	SHR	AX,1			; / 2
	ADD	DI,AX			; di = di + ( vx1 / 2 )

	MOV	AX,SEG TOUCH
	MOV	ES,AX

	ADD	DI,OFFSET TOP_OF_TOUCH

	MOV	AH,0			;
	MOV	AL,ES:[DI]		; �^�b�`����

	POP	ES
	POP	DI
	RET
TCHGET	ENDP



;	�^�b�`�����o�t�s
;	-i- VX1,VY1 : start point.
;	    AX      : attribute.
;

TCHPUT	PROC	NEAR
	PUSH	BX
	PUSH	DI
	PUSH	ES

	MOV	DI,VY1			;
	SHR	DI,1			; / 2

	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			; * 8
	MOV	BX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,BX			; di = vy1 * 40

	MOV	BX,VX1			;
	SHR	BX,1			; / 2
	ADD	DI,BX			; di = di + ( vx1 / 2 )

	MOV	BX,SEG TOUCH
	MOV	ES,BX

	ADD	DI,OFFSET TOP_OF_TOUCH

	MOV	ES:[DI],AL		; �^�b�`����

	POP	ES
	POP	DI
	POP	BX
	RET
TCHPUT	ENDP



CODE	ENDS



;	�^�b�`�����o�b�t�@�T�C�Y

TOUCH	SEGMENT	PUBLIC	'TOUCH'
PUBLIC	TOPTCH
TOPTCH		LABEL	BYTE
TOP_OF_TOUCH	LABEL	BYTE
	DB	TOUCH_SIZE DUP (0)
TOUCH	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.

DATA	ENDS

	END
;
;	end of "TOUCH.ASM"
;
