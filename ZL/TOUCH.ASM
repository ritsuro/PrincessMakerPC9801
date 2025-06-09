; "TOUCH.ASM" PC-9801UV11 make by R.H 1989/12/24
;
;
;	タッチ属性
;	縦横８ドット単位座標系
;	属性のマトリックスは４０ｘ２５
;
; public subroutine.


TOUCH	SEGMENT	PUBLIC	'TOUCH'
TOUCH	ENDS

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	TCHGET			; タッチ属性ＧＥＴ
PUBLIC	TCHPUT			; タッチ属性ＰＵＴ

TOUCH_SIZE	EQU	40*25	; タッチ属性バッファサイズ


;	タッチ属性ＧＥＴ
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
	MOV	AL,ES:[DI]		; タッチ属性

	POP	ES
	POP	DI
	RET
TCHGET	ENDP



;	タッチ属性ＰＵＴ
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

	MOV	ES:[DI],AL		; タッチ属性

	POP	ES
	POP	DI
	POP	BX
	RET
TCHPUT	ENDP



CODE	ENDS



;	タッチ属性バッファサイズ

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