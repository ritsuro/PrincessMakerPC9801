; "EFECT2.ASM" 1989/10/10 R.H
;              PC-9801UV11 make by R.H 1989
; public subroutine.
;
;
;	SSEFC0			; visual data segment plean 0
;	SSEFC1			; visual data segment plean 1
;	SSEFC2			; visual data segment plean 2
;	SSEFC3			; visual data segment plean 3
;
;	VX1:WORD		; source point x1.
;	VY1:WORD		; source point y1.
;	VX2:WORD		; destination point x3.
;	VY2:WORD		; destination point y3.
;
;
;［削除］ＥＦＥＣＴ０：ＥＣＴＯＰ０はワークに使うので６４２バイトないと
;［削除］困ります
;

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:CODE

	PUBLIC	BOXPAL		; ＢＯＸペイント
	PUBLIC	BOXMSS		; ＢＯＸメッシュ
	PUBLIC	BOXNOT		; ＢＯＸ反転
	PUBLIC	BOXPAI		; ＢＯＸ１プレーンペイント
	PUBLIC	BOXBLK		; ＢＯＸ１プレーンヌキ
	PUBLIC	BOXMSU		; ＢＯＸ１プレーンメッシュ
	PUBLIC	BOXNTS		; ＢＯＸ１プレーン反転
;*NON*;	PUBLIC	CLRCHG		; カラーチェンジ


;	ＢＯＸペイント
;	-i- SSEFC0-3 : efect data segment.
;	    VX1,VY1  : start point.
;	    VX2,VY2  : end point.
;	    CX       : color palet number.

BOXPAL	PROC	NEAR
	TEST	CX,1
	JZ	BOXPAL1
	MOV	DX,SSEFC0	; visual data segment plean 0
	CALL	BOXPAI		; ＢＯＸプレーンペイント
	JMP	BOXPAL11
BOXPAL1:
	MOV	DX,SSEFC0	; visual data segment plean 0
	CALL	BOXBLK		; ＢＯＸ１プレーンヌキ
BOXPAL11:
	TEST	CX,2
	JZ	BOXPAL2
	MOV	DX,SSEFC1	; visual data segment plean 1
	CALL	BOXPAI		; ＢＯＸプレーンペイント
	JMP	BOXPAL22
BOXPAL2:
	MOV	DX,SSEFC1	; visual data segment plean 1
	CALL	BOXBLK		; ＢＯＸ１プレーンヌキ
BOXPAL22:
	TEST	CX,4
	JZ	BOXPAL3
	MOV	DX,SSEFC2	; visual data segment plean 2
	CALL	BOXPAI		; ＢＯＸプレーンペイント
	JMP	BOXPAL33
BOXPAL3:
	MOV	DX,SSEFC2	; visual data segment plean 2
	CALL	BOXBLK		; ＢＯＸ１プレーンヌキ
BOXPAL33:
	TEST	CX,8
	JZ	BOXPAL4
	MOV	DX,SSEFC3	; visual data segment plean 3
	CALL	BOXPAI		; ＢＯＸプレーンペイント
	JMP	BOXPAL44
BOXPAL4:
	MOV	DX,SSEFC3	; visual data segment plean 3
	CALL	BOXBLK		; ＢＯＸ１プレーンヌキ
BOXPAL44:
	RET
BOXPAL	ENDP


;	ＢＯＸメッシュ
;	-i- SSEFC0-3 : efect data segment.
;	    VX1,VY1  : start point.
;	    VX2,VY2  : end point.
;	    CX       : color palet number.

BOXMSS	PROC	NEAR
	MOV	BP,0		; 0=AND
	TEST	CX,1		;
	JZ	BOXMSS1		;
	MOV	BP,1		; 1=OR
BOXMSS1:			;
	MOV	DX,SSEFC0	; visual data segment plean 0
	CALL	BOXMSU		; ＢＯＸ１プレーンメッシュ

	MOV	BP,0		; 0=AND
	TEST	CX,2		;
	JZ	BOXMSS2		;
	MOV	BP,1		; 1=OR
BOXMSS2:			;
	MOV	DX,SSEFC1	; visual data segment plean 1
	CALL	BOXMSU		; ＢＯＸ１プレーンメッシュ

	MOV	BP,0		; 0=AND
	TEST	CX,4		;
	JZ	BOXMSS3		;
	MOV	BP,1		; 1=OR
BOXMSS3:			;
	MOV	DX,SSEFC2	; visual data segment plean 2
	CALL	BOXMSU		; ＢＯＸ１プレーンメッシュ

	MOV	BP,0		; 0=AND
	TEST	CX,8		;
	JZ	BOXMSS4		;
	MOV	BP,1		; 1=OR
BOXMSS4:			;
	MOV	DX,SSEFC3	; visual data segment plean 3
	CALL	BOXMSU		; ＢＯＸ１プレーンメッシュ

	RET
BOXMSS	ENDP



;	ＢＯＸ反転
;	-i- SSEFC0-3 : efect data segment.
;	    VX1,VY1  : start point.
;	    VX2,VY2  : end point.
;	    CX       : color palet number.

BOXNOT	PROC	NEAR
	TEST	CX,1
	JZ	BOXNOT1
	MOV	DX,SSEFC0	; visual data segment plean 0
	CALL	BOXNTS		; ＢＯＸ１プレーン反転
;*NON*;	JMP	BOXNOT11
BOXNOT1:
BOXNOT11:
	TEST	CX,2
	JZ	BOXNOT2
	MOV	DX,SSEFC1	; visual data segment plean 1
	CALL	BOXNTS		; ＢＯＸ１プレーン反転
;*NON*;	JMP	BOXNOT22
BOXNOT2:
BOXNOT22:
	TEST	CX,4
	JZ	BOXNOT3
	MOV	DX,SSEFC2	; visual data segment plean 2
	CALL	BOXNTS		; ＢＯＸ１プレーン反転
;*NON*;	JMP	BOXNOT33
BOXNOT3:
BOXNOT33:
	TEST	CX,8
	JZ	BOXNOT4
	MOV	DX,SSEFC3	; visual data segment plean 3
	CALL	BOXNTS		; ＢＯＸ１プレーン反転
;*NON*;	JMP	BOXNOT44
BOXNOT4:
BOXNOT44:
	RET
BOXNOT	ENDP



;	ＢＯＸ１プレーンメッシュ
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    DX      : SEGMENT
;	    BP      : 0=AND,1=OR

BOXMSU	PROC	NEAR
	PUSH	DX
	PUSH	BP
	PUSH	CX

	MOV	ES,DX

	MOV	DI,VY1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	AX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,AX			; di = Vy1 * 80

	ADD	DI,VX1			; di = di + Vx1
	MOV	DX,DI			; dx = di

	MOV	CX,VY2			;
	SUB	CX,VY1			;
	INC	CX			; cx = Vy2 - Vy1 + 1

	MOV	BX,VX2			;
	SUB	BX,VX1			;
	INC	BX			; bx  = Vx2 - Vx1 + 1

	CMP	BP,1			; 0=AND,1=OR
	JE	BOXMSU_OR		;

BOXMSU_AND:
	MOV	AL,10101010B		; bit pattan.
	MOV	SI,CX			; loop counter.
BOXMSU1:
	MOV	DI,DX
	MOV	CX,BX
	ROR	AL,1
BOXMSU2:AND	ES:[DI],AL
	INC	DI
	LOOP	BOXMSU2

	ADD	DX,80
	DEC	SI
	JNZ	BOXMSU1

	JMP	BOXMSU9

BOXMSU_OR:
	MOV	AL,10101010B		; bit pattan.
	MOV	SI,CX			; loop counter.
BOXMSU3:
	MOV	DI,DX
	MOV	CX,BX
BOXMSU4:OR	ES:[DI],AL
	INC	DI
	LOOP	BOXMSU4

	ROR	AL,1
	ADD	DX,80
	DEC	SI
	JNZ	BOXMSU3

BOXMSU9:
	POP	CX
	POP	BP
	POP	DX
	RET
BOXMSU	ENDP



;	ＢＯＸ１プレーンペイント
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    DX      : SEGMENT

BOXPAI	PROC	NEAR
	PUSH	DX
	PUSH	BP
	PUSH	CX

	MOV	ES,DX

	MOV	DI,VY1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	AX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,AX			; di = Vy1 * 80

	ADD	DI,VX1			; di = di + Vx1
	MOV	DX,DI			; dx = di

	MOV	CX,VY2			;
	SUB	CX,VY1			;
	INC	CX			; cx = Vy2 - Vy1 + 1

	MOV	BX,VX2			;
	SUB	BX,VX1			;
	INC	BX			; bx  = Vx2 - Vx1 + 1

	MOV	SI,CX			; si : loop counter.
	MOV	AL,0FFH			; pattan.
BOXPAI1:
	MOV	DI,DX	; start point.
	MOV	CX,BX	; x length.
	REP	STOSB	;

	ADD	DX,80
	DEC	SI			; loop counter.
	JNZ	BOXPAI1

	POP	CX
	POP	BP
	POP	DX
	RET
BOXPAI	ENDP



;	ＢＯＸ１プレーンヌキ
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    DX      : SEGMENT

BOXBLK	PROC	NEAR
	PUSH	DX
	PUSH	BP
	PUSH	CX

	MOV	ES,DX

	MOV	DI,VY1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	AX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,AX			; di = Vy1 * 80

	ADD	DI,VX1			; di = di + Vx1
	MOV	DX,DI			; dx = di

	MOV	CX,VY2			;
	SUB	CX,VY1			;
	INC	CX			; cx = Vy2 - Vy1 + 1

	MOV	BX,VX2			;
	SUB	BX,VX1			;
	INC	BX			; bx  = Vx2 - Vx1 + 1

	MOV	SI,CX			; si : loop counter.
	MOV	AL,0			; pattan.
BOXBLK1:
	MOV	DI,DX	; start point.
	MOV	CX,BX	; x length.
	REP	STOSB	;

	ADD	DX,80
	DEC	SI			; loop counter.
	JNZ	BOXBLK1

	POP	CX
	POP	BP
	POP	DX
	RET
BOXBLK	ENDP



;	ＢＯＸ１プレーン反転
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    DX      : SEGMENT

BOXNTS	PROC	NEAR
	PUSH	DX
	PUSH	CX
	MOV	ES,DX

	MOV	DI,VY1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	AX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,AX			; di = Vy1 * 80

	ADD	DI,VX1			; di = di + Vx1
	MOV	DX,DI			; dx = di

	MOV	CX,VY2			;
	SUB	CX,VY1			;
	INC	CX			; cx = Vy2 - Vy1 + 1

	MOV	BX,VX2			;
	SUB	BX,VX1			;
	INC	BX			; bx  = Vx2 - Vx1 + 1

	MOV	SI,CX			; si : loop counter.
BOXNTS1:
	MOV	DI,DX
	MOV	CX,BX
BOXNTS2:NOT	BYTE PTR ES:[DI]
	INC	DI
	LOOP	BOXNTS2

	ADD	DX,80
	DEC	SI
	JNZ	BOXNTS1

BOXNTS9:
	POP	CX
	POP	DX
	RET
BOXNTS	ENDP


; ****************************************************
;	DATA
; ****************************************************
	EVEN

EXTRN	SSEFCT:WORD		; visual data segment plean.
EXTRN	SSEFC0:WORD		; visual data segment plean 0
EXTRN	SSEFC1:WORD		; visual data segment plean 1
EXTRN	SSEFC2:WORD		; visual data segment plean 2
EXTRN	SSEFC3:WORD		; visual data segment plean 3

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.

CODE	ENDS

	END
;
;	end of "EFECT2.ASM"
;
