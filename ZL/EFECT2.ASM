; "EFECT2.ASM" 1989/10/10 R.H
;              PC-9801UV11 make by R.H 1989
; public subroutine.
;
;	efect routine set.	カラーチェンジ
;
;	VX1:WORD		; source point x1.
;	VY1:WORD		; source point y1.
;	VX2:WORD		; destination point x3.
;	VY2:WORD		; destination point y3.
;
;
;	ＥＦＥＣＴ０：ＥＣＴＯＰ０はワークに使うので６４２バイトないと
;	困ります
;

VRAM_SEG_G0		EQU	0A800H
VRAM_SEG_G1		EQU	0B000H
VRAM_SEG_G2		EQU	0B800H
VRAM_SEG_G3		EQU	0E000H


CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA


	PUBLIC	BOXPAL		; ＢＯＸペイント
	PUBLIC	BOXMSS		; ＢＯＸメッシュ
	PUBLIC	BOXMSU		; ＢＯＸ１プレーンメッシュ
	PUBLIC	BOXPAI		; ＢＯＸ１プレーンペイント
	PUBLIC	BOXBLK		; ＢＯＸ１プレーンヌキ
	PUBLIC	CLRCHG		; カラーチェンジ


;	ＢＯＸペイント
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    CX      : color palet number.

BOXPAL	PROC	NEAR
	TEST	CX,1
	JZ	BOXPAL1
	MOV	DX,VRAM_SEG_G0
	CALL	BOXPAI		; ＢＯＸプレーンペイント
	JMP	BOXPAL11
BOXPAL1:
	MOV	DX,VRAM_SEG_G0
	CALL	BOXBLK		; ＢＯＸ１プレーンヌキ
BOXPAL11:
	TEST	CX,2
	JZ	BOXPAL2
	MOV	DX,VRAM_SEG_G1
	CALL	BOXPAI		; ＢＯＸプレーンペイント
	JMP	BOXPAL22
BOXPAL2:
	MOV	DX,VRAM_SEG_G1
	CALL	BOXBLK		; ＢＯＸ１プレーンヌキ
BOXPAL22:
	TEST	CX,4
	JZ	BOXPAL3
	MOV	DX,VRAM_SEG_G2
	CALL	BOXPAI		; ＢＯＸプレーンペイント
	JMP	BOXPAL33
BOXPAL3:
	MOV	DX,VRAM_SEG_G2
	CALL	BOXBLK		; ＢＯＸ１プレーンヌキ
BOXPAL33:
	TEST	CX,8
	JZ	BOXPAL4
	MOV	DX,VRAM_SEG_G3
	CALL	BOXPAI		; ＢＯＸプレーンペイント
	JMP	BOXPAL44
BOXPAL4:
	MOV	DX,VRAM_SEG_G3
	CALL	BOXBLK		; ＢＯＸ１プレーンヌキ
BOXPAL44:
	RET
BOXPAL	ENDP


;	ＢＯＸメッシュ
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    CX      : color palet number.

BOXMSS	PROC	NEAR
	TEST	CX,1
	JNZ	BOXMSS1
	MOV	DX,VRAM_SEG_G0
	CALL	BOXMSU		; ＢＯＸ１プレーンメッシュ
BOXMSS1:
	TEST	CX,2
	JNZ	BOXMSS2
	MOV	DX,VRAM_SEG_G1
	CALL	BOXMSU		; ＢＯＸ１プレーンメッシュ
BOXMSS2:
	TEST	CX,4
	JNZ	BOXMSS3
	MOV	DX,VRAM_SEG_G2
	CALL	BOXMSU		; ＢＯＸ１プレーンメッシュ
BOXMSS3:
	TEST	CX,8
	JNZ	BOXMSS4
	MOV	DX,VRAM_SEG_G3
	CALL	BOXMSU		; ＢＯＸ１プレーンメッシュ
BOXMSS4:
	RET
BOXMSS	ENDP


;	ＢＯＸ１プレーンメッシュ
;	-i- VX1,VY1 : start point.
;	    VX2,VY2 : end point.
;	    DX      : SEGMENT

BOXMSU	PROC	NEAR
	PUSH	DX
	PUSH	BP
	PUSH	CX
	MOV	BP,DX

	MOV	DI,VY1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	AX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,AX			; di = Vy1 * 80

	MOV	AX,VX1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			; ax = Vx1 / 8

	ADD	DI,AX			; di = di + ax
	MOV	DX,DI			; dx = di

	MOV	CX,VY2			;
	SUB	CX,VY1			;
	INC	CX			; cx = Vy2 - Vy1 + 1

	MOV	BX,VX2			;
;;	SHR	BX,1			;
;;	SHR	BX,1			;
;;	SHR	BX,1			;
	MOV	AX,VX1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			;
	SUB	BX,AX			;
	INC	BX			; bx  = Vx2/8 - Vx1/8 + 1
	MOV	SI,1010101010101010B
BOXMSU1:PUSH	CX
	MOV	DI,DX
	MOV	AX,BP	; セグメント
	MOV	ES,AX
	MOV	CX,BX
	ROR	SI,1
	MOV	AX,SI		; ビットパターン
BOXMSU2:AND	ES:[DI],AL
	INC	DI
	LOOP	BOXMSU2

	ADD	DX,80
	POP	CX
	LOOP	BOXMSU1

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
	MOV	BP,DX

	MOV	DI,VY1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	AX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,AX			; di = Vy1 * 80

	MOV	AX,VX1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			; ax = Vx1 / 8

	ADD	DI,AX			; di = di + ax
	MOV	DX,DI			; dx = di

	MOV	CX,VY2			;
	SUB	CX,VY1			;
	INC	CX			; cx = Vy2 - Vy1 + 1

	MOV	BX,VX2			;
;;	SHR	BX,1			;
;;	SHR	BX,1			;
;;	SHR	BX,1			;
	MOV	AX,VX1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			;
	SUB	BX,AX			;
	INC	BX			; bx  = Vx2/8 - Vx1/8 + 1
BOXPAI1:PUSH	CX
	MOV	DI,DX
	MOV	AX,BP	; セグメント
	MOV	ES,AX
	MOV	CX,BX
	MOV	AL,0FFH
	REP	STOSB

	ADD	DX,80
	POP	CX
	LOOP	BOXPAI1

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
	MOV	BP,DX

	MOV	DI,VY1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	SHL	DI,1			;
	MOV	AX,DI			;
	SHL	DI,1			;
	SHL	DI,1			;
	ADD	DI,AX			; di = Vy1 * 80

	MOV	AX,VX1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			; ax = Vx1 / 8

	ADD	DI,AX			; di = di + ax
	MOV	DX,DI			; dx = di

	MOV	CX,VY2			;
	SUB	CX,VY1			;
	INC	CX			; cx = Vy2 - Vy1 + 1

	MOV	BX,VX2			;
;;	SHR	BX,1			;
;;	SHR	BX,1			;
;;	SHR	BX,1			;
	MOV	AX,VX1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			;
;;	SHR	AX,1			;
	SUB	BX,AX			;
	INC	BX			; bx  = Vx2/8 - Vx1/8 + 1
BOXBLK1:PUSH	CX
	MOV	DI,DX
	MOV	AX,BP	; セグメント
	MOV	ES,AX
	MOV	CX,BX
	MOV	AL,0
	REP	STOSB

	ADD	DX,80
	POP	CX
	LOOP	BOXBLK1

	POP	CX
	POP	BP
	POP	DX
	RET
BOXBLK	ENDP



;	カラーチェンジ
;	-i-
;	VX1,VY1 : 開始座標
;	VX2,VY2 : 終了座標
;	CLRSOU	; 変更カラーパレット
;	CLRDES	; 変更後カラーパレット

CLRCHG	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	BP
	PUSH	ES
	PUSH	DI
	PUSH	DS
	PUSH	SI

	MOV	AX,SEG EFECT0	; ｴﾌｪｸﾄﾊﾞｯﾌｧセグメント
	MOV	ES,AX		;
	MOV	DI,OFFSET ECTOP0; ｴﾌｪｸﾄﾊﾞｯﾌｧオフセット
	MOV	CX,640/2	;
	MOV	AX,0		;
	REP	STOSW		;

	MOV	DI,OFFSET ECTOP0	; ｴﾌｪｸﾄﾊﾞｯﾌｧオフセット
	MOV	AL,BYTE PTR CLRSOU	; 変更カラーパレット
	MOV	ES:[DI][640],AL		;
	MOV	AL,BYTE PTR CLRDES	; 変更後カラーパレット
	MOV	ES:[DI][641],AL		;


	MOV	DX,VY1		;
	SHL	DX,1		;
	SHL	DX,1		;  point address.
	SHL	DX,1		;
	SHL	DX,1		;  DX = VY1 * 80 + VX1
	MOV	AX,DX		;
	SHL	DX,1		;
	SHL	DX,1		;
	ADD	DX,AX		;
	ADD	DX,VX2		;
	MOV	CX,DX		; Ｘエンド=CX

	MOV	DX,VY2		;
	SHL	DX,1		;
	SHL	DX,1		;  point address.
	SHL	DX,1		;
	SHL	DX,1		;  DX = VY2 * 80 + VX2
	MOV	AX,DX		;
	SHL	DX,1		;
	SHL	DX,1		;
	ADD	DX,AX		;
	ADD	DX,VX2		;
	MOV	BP,DX		; Ｙエンド=BP

	MOV	DX,VY1		;
	SHL	DX,1		;
	SHL	DX,1		;  point address.
	SHL	DX,1		;
	SHL	DX,1		;  DX = VRY * 80 + VRX
	MOV	AX,DX		;
	SHL	DX,1		;
	SHL	DX,1		;
	ADD	DX,AX		;
	ADD	DX,VX1		;
	MOV	SI,DX		; VRAM address pointer.=SI=DX

	;	Ｘエンド=CX
	;	Ｙエンド=BP
	;	VRAM address pointer.=SI=DX
	;	ｴﾌｪｸﾄﾊﾞｯﾌｧセグメント=ES
	;	ｴﾌｪｸﾄﾊﾞｯﾌｧオフセット=DI
CLRCHG_LOOP_START:
	MOV	AX,SEG EFECT0	; ｴﾌｪｸﾄﾊﾞｯﾌｧセグメント
	MOV	ES,AX		;
	MOV	DI,OFFSET ECTOP0; ｴﾌｪｸﾄﾊﾞｯﾌｧオフセット=DI

	PUSH	DX
CLRCHG_LOOP:
	MOV	AX,VRAM_SEG_G0
	MOV	DS,AX
	MOV	DL,DS:[SI]

	MOV	AX,VRAM_SEG_G1
	MOV	DS,AX
	MOV	DH,DS:[SI]

	MOV	AX,VRAM_SEG_G2
	MOV	DS,AX
	MOV	BL,DS:[SI]

	MOV	AX,VRAM_SEG_G3
	MOV	DS,AX
	MOV	BH,DS:[SI]
	;			ＶＲＡＭ１バイトは８ドットというわけ
	MOV	AL,0
	SHL	BH,1		; ＢＨの左端１ビットキャリーへ(VRAM3)
	RCL	AL,1		;	キャリーをＤＬの右端へセット
	SHL	BL,1		; ＢＬの左端１ビットキャリーへ(VRAM2)
	RCL	AL,1		;
	SHL	DH,1		; ＤＨの左端１ビットキャリーへ(VRAM1)
	RCL	AL,1		;
	SHL	DL,1		; ＤＬの左端１ビットキャリーへ(VRAM0)
	RCL	AL,1		;
	STOSB			; ＡＬをバッファへセット（１ドットの値）

	MOV	AL,0
	SHL	BH,1		; ＢＨの左端１ビットキャリーへ(VRAM3)
	RCL	AL,1		;	キャリーをＤＬの右端へセット
	SHL	BL,1		; ＢＬの左端１ビットキャリーへ(VRAM2)
	RCL	AL,1		;
	SHL	DH,1		; ＤＨの左端１ビットキャリーへ(VRAM1)
	RCL	AL,1		;
	SHL	DL,1		; ＤＬの左端１ビットキャリーへ(VRAM0)
	RCL	AL,1		;
	STOSB			; ＡＬをバッファへセット（１ドットの値）
	MOV	AL,0
	SHL	BH,1		; ＢＨの左端１ビットキャリーへ(VRAM3)
	RCL	AL,1		;	キャリーをＤＬの右端へセット
	SHL	BL,1		; ＢＬの左端１ビットキャリーへ(VRAM2)
	RCL	AL,1		;
	SHL	DH,1		; ＤＨの左端１ビットキャリーへ(VRAM1)
	RCL	AL,1		;
	SHL	DL,1		; ＤＬの左端１ビットキャリーへ(VRAM0)
	RCL	AL,1		;
	STOSB			; ＡＬをバッファへセット（１ドットの値）
	MOV	AL,0
	SHL	BH,1		; ＢＨの左端１ビットキャリーへ(VRAM3)
	RCL	AL,1		;	キャリーをＤＬの右端へセット
	SHL	BL,1		; ＢＬの左端１ビットキャリーへ(VRAM2)
	RCL	AL,1		;
	SHL	DH,1		; ＤＨの左端１ビットキャリーへ(VRAM1)
	RCL	AL,1		;
	SHL	DL,1		; ＤＬの左端１ビットキャリーへ(VRAM0)
	RCL	AL,1		;
	STOSB			; ＡＬをバッファへセット（１ドットの値）
	MOV	AL,0
	SHL	BH,1		; ＢＨの左端１ビットキャリーへ(VRAM3)
	RCL	AL,1		;	キャリーをＤＬの右端へセット
	SHL	BL,1		; ＢＬの左端１ビットキャリーへ(VRAM2)
	RCL	AL,1		;
	SHL	DH,1		; ＤＨの左端１ビットキャリーへ(VRAM1)
	RCL	AL,1		;
	SHL	DL,1		; ＤＬの左端１ビットキャリーへ(VRAM0)
	RCL	AL,1		;
	STOSB			; ＡＬをバッファへセット（１ドットの値）
	MOV	AL,0
	SHL	BH,1		; ＢＨの左端１ビットキャリーへ(VRAM3)
	RCL	AL,1		;	キャリーをＤＬの右端へセット
	SHL	BL,1		; ＢＬの左端１ビットキャリーへ(VRAM2)
	RCL	AL,1		;
	SHL	DH,1		; ＤＨの左端１ビットキャリーへ(VRAM1)
	RCL	AL,1		;
	SHL	DL,1		; ＤＬの左端１ビットキャリーへ(VRAM0)
	RCL	AL,1		;
	STOSB			; ＡＬをバッファへセット（１ドットの値）
	MOV	AL,0
	SHL	BH,1		; ＢＨの左端１ビットキャリーへ(VRAM3)
	RCL	AL,1		;	キャリーをＤＬの右端へセット
	SHL	BL,1		; ＢＬの左端１ビットキャリーへ(VRAM2)
	RCL	AL,1		;
	SHL	DH,1		; ＤＨの左端１ビットキャリーへ(VRAM1)
	RCL	AL,1		;
	SHL	DL,1		; ＤＬの左端１ビットキャリーへ(VRAM0)
	RCL	AL,1		;
	STOSB			; ＡＬをバッファへセット（１ドットの値）
	MOV	AL,0
	SHL	BH,1		; ＢＨの左端１ビットキャリーへ(VRAM3)
	RCL	AL,1		;	キャリーをＤＬの右端へセット
	SHL	BL,1		; ＢＬの左端１ビットキャリーへ(VRAM2)
	RCL	AL,1		;
	SHL	DH,1		; ＤＨの左端１ビットキャリーへ(VRAM1)
	RCL	AL,1		;
	SHL	DL,1		; ＤＬの左端１ビットキャリーへ(VRAM0)
	RCL	AL,1		;
	STOSB			; ＡＬをバッファへセット（１ドットの値）

	INC	SI		; ＶＲＡＭアドレスは１バイトずらす
	CMP	SI,CX		; Ｘエンド=CX
	JNBE	CLRCHG_NEXT	; if SI > CX then NEXT １ライン取ったら処理
	JMP	CLRCHG_LOOP	;
CLRCHG_NEXT:			;
	POP	DX		; ＤＸはＶＲＡＭアドレス

	MOV	SI,DX		; VRAM address pointer.=SI=DX
	MOV	DI,OFFSET ECTOP0; ｴﾌｪｸﾄﾊﾞｯﾌｧオフセット=DI

	CALL	CHANGE_COLOR	; １ラインカラーチェンジ

	MOV	DI,OFFSET ECTOP0; ｴﾌｪｸﾄﾊﾞｯﾌｧオフセット=DI

	PUSH	DX
	MOV	AX,ES		;
	MOV	DS,AX		; ＤＳをバッファセグメントにする
	XCHG	DI,SI		; ＤＳ：ＳＩはバッファのフルポインタ
CLRCHG_LOOP2:

	LODSB			; ドットの値をＡＬへ取り出す
	SHR	AL,1		;	ＡＬの右端１ビットをキャリーへ
	RCL	DL,1		; キャリーをＤＬの右端１ビットへ(VRAM0)
	SHR	AL,1		;
	RCL	DH,1		; キャリーをＤＨの右端１ビットへ(VRAM1)
	SHR	AL,1		;
	RCL	BL,1		; キャリーをＢＬの右端１ビットへ(VRAM2)
	SHR	AL,1		;
	RCL	BH,1		; キャリーをＢＨの右端１ビットへ(VRAM3)

	LODSB			; ドットの値をＡＬへ取り出す
	SHR	AL,1		;	ＡＬの右端１ビットをキャリーへ
	RCL	DL,1		; キャリーをＤＬの右端１ビットへ(VRAM0)
	SHR	AL,1		;
	RCL	DH,1		; キャリーをＤＨの右端１ビットへ(VRAM1)
	SHR	AL,1		;
	RCL	BL,1		; キャリーをＢＬの右端１ビットへ(VRAM2)
	SHR	AL,1		;
	RCL	BH,1		; キャリーをＢＨの右端１ビットへ(VRAM3)

	LODSB			; ドットの値をＡＬへ取り出す
	SHR	AL,1		;	ＡＬの右端１ビットをキャリーへ
	RCL	DL,1		; キャリーをＤＬの右端１ビットへ(VRAM0)
	SHR	AL,1		;
	RCL	DH,1		; キャリーをＤＨの右端１ビットへ(VRAM1)
	SHR	AL,1		;
	RCL	BL,1		; キャリーをＢＬの右端１ビットへ(VRAM2)
	SHR	AL,1		;
	RCL	BH,1		; キャリーをＢＨの右端１ビットへ(VRAM3)

	LODSB			; ドットの値をＡＬへ取り出す
	SHR	AL,1		;	ＡＬの右端１ビットをキャリーへ
	RCL	DL,1		; キャリーをＤＬの右端１ビットへ(VRAM0)
	SHR	AL,1		;
	RCL	DH,1		; キャリーをＤＨの右端１ビットへ(VRAM1)
	SHR	AL,1		;
	RCL	BL,1		; キャリーをＢＬの右端１ビットへ(VRAM2)
	SHR	AL,1		;
	RCL	BH,1		; キャリーをＢＨの右端１ビットへ(VRAM3)

	LODSB			; ドットの値をＡＬへ取り出す
	SHR	AL,1		;	ＡＬの右端１ビットをキャリーへ
	RCL	DL,1		; キャリーをＤＬの右端１ビットへ(VRAM0)
	SHR	AL,1		;
	RCL	DH,1		; キャリーをＤＨの右端１ビットへ(VRAM1)
	SHR	AL,1		;
	RCL	BL,1		; キャリーをＢＬの右端１ビットへ(VRAM2)
	SHR	AL,1		;
	RCL	BH,1		; キャリーをＢＨの右端１ビットへ(VRAM3)

	LODSB			; ドットの値をＡＬへ取り出す
	SHR	AL,1		;	ＡＬの右端１ビットをキャリーへ
	RCL	DL,1		; キャリーをＤＬの右端１ビットへ(VRAM0)
	SHR	AL,1		;
	RCL	DH,1		; キャリーをＤＨの右端１ビットへ(VRAM1)
	SHR	AL,1		;
	RCL	BL,1		; キャリーをＢＬの右端１ビットへ(VRAM2)
	SHR	AL,1		;
	RCL	BH,1		; キャリーをＢＨの右端１ビットへ(VRAM3)

	LODSB			; ドットの値をＡＬへ取り出す
	SHR	AL,1		;	ＡＬの右端１ビットをキャリーへ
	RCL	DL,1		; キャリーをＤＬの右端１ビットへ(VRAM0)
	SHR	AL,1		;
	RCL	DH,1		; キャリーをＤＨの右端１ビットへ(VRAM1)
	SHR	AL,1		;
	RCL	BL,1		; キャリーをＢＬの右端１ビットへ(VRAM2)
	SHR	AL,1		;
	RCL	BH,1		; キャリーをＢＨの右端１ビットへ(VRAM3)

	LODSB			; ドットの値をＡＬへ取り出す
	SHR	AL,1		;	ＡＬの右端１ビットをキャリーへ
	RCL	DL,1		; キャリーをＤＬの右端１ビットへ(VRAM0)
	SHR	AL,1		;
	RCL	DH,1		; キャリーをＤＨの右端１ビットへ(VRAM1)
	SHR	AL,1		;
	RCL	BL,1		; キャリーをＢＬの右端１ビットへ(VRAM2)
	SHR	AL,1		;
	RCL	BH,1		; キャリーをＢＨの右端１ビットへ(VRAM3)

	MOV	AX,VRAM_SEG_G3
	MOV	ES,AX
	MOV	ES:[DI],BH

	MOV	AX,VRAM_SEG_G2
	MOV	ES,AX
	MOV	ES:[DI],BL

	MOV	AX,VRAM_SEG_G1
	MOV	ES,AX
	MOV	ES:[DI],DH

	MOV	AX,VRAM_SEG_G0
	MOV	ES,AX
	MOV	ES:[DI],DL

	INC	DI		; vram
	CMP	DI,CX		; Ｘエンド=CX
	JNBE	CLRCHG_NEXT2	; if DI > CX then NEXT2
	JMP	CLRCHG_LOOP2	;
CLRCHG_NEXT2:			;
	POP	DX

	ADD	CX,80		; Ｘエンド=CX
	ADD	DX,80		;
	MOV	SI,DX		; VRAM address pointer.=SI=DX

	CMP	DX,BP		; Ｙエンド=BP
	JNBE	CLRCHG_END	;
	JMP	CLRCHG_LOOP_START
CLRCHG_END:

	POP	SI
	POP	DS
	POP	DI
	POP	ES
	POP	BP
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
CLRCHG	ENDP



;	１ラインカラーチェンジ
;	-I-   CX     : Ｘエンド
;	      SI     : VRAM address pointer.
;	      ES:[DI][640]:カラーを替えるパレット
;	      ES:[DI][641]:変更後のパレット
;	-I/O- ES:[DI]: ｴﾌｪｸﾄﾊﾞｯﾌｧオフセット

CHANGE_COLOR	PROC	NEAR
	PUSH	CX
	SUB	CX,SI		; VRAM address pointer.=SI
	INC	CX
	SHL	CX,1		;
	SHL	CX,1		;
	SHL	CX,1		; * 8
	MOV	BX,DI		;
CHANGE_COLOR1:
	MOV	AL,ES:[BX][640]
	CMP	BYTE PTR ES:[DI],AL
	JNE	CHANGE_COLOR2
	MOV	AL,ES:[BX][641]
	MOV	BYTE PTR ES:[DI],AL
CHANGE_COLOR2:
	INC	DI
	LOOP	CHANGE_COLOR1
	POP	CX
	RET
CHANGE_COLOR	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.

PUBLIC	CLRSOU			; 変更カラーパレット
PUBLIC	CLRDES			; 変更後カラーパレット

CLRSOU	DW	0		; 変更カラーパレット
CLRDES	DW	0		; 変更後カラーパレット

DATA	ENDS


;	エフェクト用バッファ

EFECT0	SEGMENT	PUBLIC	'EFECT0'
	EXTRN	ECTOP0:BYTE
EFECT0	ENDS


	END
;
;	end of "EFECT2.ASM"
;
