; "TXTATR.ASM" PC-9801UV11 make by R.H 1989/12/22
;
;
;	テキスト属性セット
;
;
; public subroutine.


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	TXTBOX			; テキスト属性ＢＯＸセット
PUBLIC	TXTCBX			; テキスト文字ＢＯＸセット



;	テキスト属性ＢＯＸセット
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    DX      : attribute.
;
;	アトリビュート表現（ＤＸ）
;
;
;	　　　　　　縦　　下線　反転　明滅　消す
;	7   6   5   4     3     2     1    0____
;	Ｇ　Ｒ　Ｂ　ＢＧ　ＵＬ　ＲＶ　ＢＬ　ＳＴ
;	　　　　　　ＶＬ

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
	MOV	AL,DL			; 属性をセット
TXTBOX1:
	PUSH	CX
	MOV	DI,SI			; si = di
	MOV	DX,TEXT_ATR		; テキスト属性セグメント
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


;	テキスト文字ＢＯＸセット
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    DX      : character.

TXTCBX	PROC	NEAR
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
	MOV	AX,DX			; 文字をセット
TXTCBX1:
	PUSH	CX
	MOV	DI,SI			; si = di
	MOV	DX,TEXT_CHR		; テキスト文字セグメント
	MOV	ES,DX
	MOV	CX,BX
	REP	STOSW			; GDC word address.

	ADD	SI,160			; GDC word address.
	POP	CX
	LOOP	TXTCBX1

	POP	SI
	POP	DI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
TXTCBX	ENDP

CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.

TEXT_CHR	DW	0A000H	; テキスト文字セグメント
TEXT_ATR	DW	0A200H	; テキスト属性セグメント

DATA	ENDS

	END
;
;	end of "TXTATR.ASM"
;
