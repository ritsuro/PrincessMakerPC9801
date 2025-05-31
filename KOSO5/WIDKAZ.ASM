; "WIDKAZ.ASM" PC-9801UV11 make by R.H 1990/10/22
;
;
;	ＷＩＮＤＯＷＳ／ウインドウ飾り
;
;
;	WIDKAZ_INIT		; WINDOWS/ウインドウ飾り初期処理
;	WID_1_FLAME		; WINDOWS/フレーム１
;	WID_2_FLAME		; WINDOWS/フレーム２（ＳＥＬＥＣＴ）
;	WID_3_FLAME		; WINDOWS/フレーム３
;	WID_4_FLAME		; WINDOWS/フレーム４
;	WID_5_FLAME		; WINDOWS/フレーム５（宝石）
;	WID_6_FLAME		; WINDOWS/フレーム６（ミニ）
;	WID_7_FLAME		; WINDOWS/フレーム７（エントリィ）
;	WID_8_FLAME		; WINDOWS/フレーム８（フェイス）
;	WID_9_FLAME		; WINDOWS/フレーム９（オチ）
;	WID_10_FLAME		; WINDOWS/フレーム10（武者修行マップ）
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC

;	ＷＩＮＤＯＷ　から　ＣＯＤＥ　へ　ＣＡＬＬ

CALLC	MACRO	SUB1
	LOCAL	L1,L2
;*;	JMP	L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	EXTRN	SUB1:NEAR
	CALL	SUB1
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:WINDOW,DS:DATA
L1:	CALL	L2
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチン

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS

	ASSUME	CS:WINDOW,DS:DATA

SUBLL	PROC	FAR
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチンの終り

FEND	MACRO	SUBLL
SUBLL	ENDP
	ENDM


MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA

; ****************************************************
;	WINDOWS/ウインドウ飾り初期処理
; ****************************************************

FUNC	WWIDKAZ_INIT,WIDKAZ_INIT
;**;	CALLC	PT_LD_KAZARI		; 飾りＬＯＡＤ
	RET
FEND	WWIDKAZ_INIT


;*NON*;;	WINDOWS/メインウインドウ飾り
;*NON*;
;*NON*;WIDKAZ_MAIN	PROC	NEAR
;*NON*;	MOV	AX,1			; ＰＵＴ　Ｘ座標
;*NON*;	MOV	BX,0			; ＰＵＴ　Ｙ座標
;*NON*;	CALL	PT_K11			; 縁飾り１
;*NON*;	MOV	AX,76			; ＰＵＴ　Ｘ座標
;*NON*;	MOV	BX,0			; ＰＵＴ　Ｙ座標
;*NON*;	CALL	PT_K12			; 縁飾り２
;*NON*;	MOV	AX,76			; ＰＵＴ　Ｘ座標
;*NON*;	MOV	BX,260-4-1		; ＰＵＴ　Ｙ座標
;*NON*;	CALL	PT_K13			; 縁飾り３
;*NON*;	MOV	AX,1			; ＰＵＴ　Ｘ座標
;*NON*;	MOV	BX,260-4		; ＰＵＴ　Ｙ座標
;*NON*;	CALL	PT_K14			; 縁飾り４
;*NON*;	RET
;*NON*;WIDKAZ_MAIN	ENDP



; ****************************************************
;	WINDOWS/フレーム１
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_1_FLAME,WID_1_FLAME
	MOV	AX,WDX1			; 左上Ｘ座標
	MOV	BX,WDY1			; 左上Ｙ座標
	MOV	CX,WDX2			; Ｘサイズ
	MOV	DX,WDY2			; Ｙサイズ
	CALLC	MS_STOP			; マウスカーソル退避

	CALL	BASE_FLAME		; フレーム１

	CALLC	MS_START		; マウスカーソル復帰

	RET
FEND	WWID_1_FLAME


; ****************************************************
;	フレーム１
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

BASE_FLAME	PROC	NEAR
	MOVX	VX1,WDX1		; 表示位置Ｘ
	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VX2,WDX1		; 表示位置Ｘ
	MOVX	VY2,WDY1		; 表示位置Ｙ
	ADDX	VX2,WDX2		; 大きさＸ
	ADDX	VY2,WDY2		; 大きさＹ
	DEC	VX2			;
	DEC	VY2			;

	MOV	CX,W_COL3		; カラー・暗い灰
	CALLC	BOXPAL			; ＢＯＸペイント
	MOV	CX,W_COL4		; カラー・黒
	CALLC	BOXMSS			; ＢＯＸメッシュ

	CALL	WID_GAWA		; フレームの側

	RET
BASE_FLAME	ENDP


;*;; ****************************************************
;*;;	フレーム２
;*;;	-I- WDX1 : 表示位置Ｘ
;*;;	    WDY1 : 表示位置Ｙ
;*;;	    WDX2 : 大きさＸ
;*;;	    WDY2 : 大きさＹ
;*;; ****************************************************
;*;
;*;BASE_FLAM2	PROC	NEAR
;*;	MOVX	VX1,WDX1		; 表示位置Ｘ
;*;	MOVX	VY1,WDY1		; 表示位置Ｙ
;*;	MOVX	VX2,WDX1		; 表示位置Ｘ
;*;	MOVX	VY2,WDY1		; 表示位置Ｙ
;*;	ADDX	VX2,WDX2		; 大きさＸ
;*;	ADDX	VY2,WDY2		; 大きさＹ
;*;	DEC	VX2			;
;*;	DEC	VY2			;
;*;
;*;	MOV	CX,4			; 暗い赤
;*;	CALLC	BOXPAL			; ＢＯＸペイント
;*;	MOV	CX,W_COL4		; カラー・黒
;*;	CALLC	BOXMSS			; ＢＯＸメッシュ
;*;
;*;	CALL	WID_GAWA		; フレームの側
;*;
;*;	RET
;*;BASE_FLAM2	ENDP


; ****************************************************
;	フレームの側
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

WID_GAWA	PROC	NEAR
	MOV	AX,WDX1			; 表示位置Ｘ
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX1,AX			; ヘッダー表示Ｘ位置
	MOV	AX,WDX1			; 表示位置Ｘ
	ADD	AX,WDX2			; 大きさＸ
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX2,AX			; ヘッダー表示Ｘ位置

	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL2		; カラー・明るい灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	ADDX	VY1,WDY2		; 大きさＹ
	SUB	VY1,6+1			;

	MOVX	VCOL,W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL2		; カラー・明るい灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画


	MOVX	VY1,WDY1		; 表示位置Ｙ

	MOV	AX,WDY1			; 表示位置Ｙ
	ADD	AX,WDY2			; 大きさＹ
	DEC	AX			;
	MOV	VY2,AX			;


	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	INC	VY1			;
	DEC	VY2			;
	MOVX	VCOL,W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	INC	VY1			;
	DEC	VY2			;
	MOVX	VCOL,W_COL2		; カラー・明るい灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	INC	VY1			;
	DEC	VY2			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画


	MOVX	VX1,VX2			;
	SUB	VX1,4			;

	MOVX	VCOL,W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	DEC	VY1			;
	INC	VY2			;
	MOVX	VCOL,W_COL2		; カラー・明るい灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	DEC	VY1			;
	INC	VY2			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	DEC	VY1			;
	INC	VY2			;
	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	RET
WID_GAWA	ENDP


; ****************************************************
;	フレームの側（ＧＯＬＤ）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

WID_GAWA_G	PROC	NEAR
	MOV	AX,WDX1			; 表示位置Ｘ
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX1,AX			; ヘッダー表示Ｘ位置
	MOV	AX,WDX1			; 表示位置Ｘ
	ADD	AX,WDX2			; 大きさＸ
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX2,AX			; ヘッダー表示Ｘ位置

	MOVX	VY1,WDY1		; 表示位置Ｙ
	SUB	VY1,3			;****
	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,14;W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	ADD	VY1,4			;****
	ADDX	VY1,WDY2		; 大きさＹ
	SUB	VY1,6+1			;
	ADD	VY1,4			;****

;*;	MOVX	VCOL,14;W_COL1		; カラー・ハイライト
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画


	MOVX	VY1,WDY1		; 表示位置Ｙ

	MOV	AX,WDY1			; 表示位置Ｙ
	ADD	AX,WDY2			; 大きさＹ
	DEC	AX			;
	MOV	VY2,AX			;

	SUB	VX1,3			;****

	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	INC	VY1			;
	DEC	VY2			;
	MOVX	VCOL,14;W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	INC	VY1			;
	DEC	VY2			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画


	MOVX	VX1,VX2			;
	SUB	VX1,4			;
	ADD	VX1,4			;****

;*;	MOVX	VCOL,14;W_COL1		; カラー・ハイライト
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	DEC	VY1			;
	INC	VY2			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	DEC	VY1			;
	INC	VY2			;
	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	RET
WID_GAWA_G	ENDP


; ****************************************************
;	フレームの側（テーパ）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

WID_GAWA_TP	PROC	NEAR
	PUSH	WDX1
	PUSH	WDY1
	PUSH	WDX2
	PUSH	WDY2

	SHL	WDX1,1			; 表示位置Ｘ
	SHL	WDX1,1			; * 8
	SHL	WDX1,1			;

	SHL	WDX2,1			; 大きさＸ
	SHL	WDX2,1			; * 8
	SHL	WDX2,1			;


	ADD	WDX1,6			; 表示位置Ｘ
	ADD	WDY1,6			; 表示位置Ｙ
	SUB	WDX2,13			; 大きさＸ
	SUB	WDY2,10+3		; 大きさＹ


	MOVX	VX1,WDX1		; 表示位置Ｘ
	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VX2,WDX1		; 表示位置Ｘ
	ADDX	VX2,WDX2		; 大きさＸ

	MOV	VCOL,2			; カラー・影
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	ADDX	VY1,WDY2		; 大きさＹ
	DEC	VY2			;
	MOV	VCOL,2			; カラー・赤２
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	MOVX	VX1,WDX1		; 表示位置Ｘ
	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VY2,WDY1		; 表示位置Ｙ
	ADDX	VY2,WDY2		; 大きさＹ

	MOV	VCOL,2			; カラー・影
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	ADDX	VX1,WDX2		; 大きさＸ
	MOV	VCOL,2			; カラー・赤２
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	POP	WDY2
	POP	WDX2
	POP	WDY1
	POP	WDX1
	RET
WID_GAWA_TP	ENDP


; ****************************************************
;	WINDOWS/フレーム２（ＳＥＬＥＣＴ）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_2_FLAME,WID_2_FLAME
	MOV	AX,WDX1			; 左上Ｘ座標
	MOV	BX,WDY1			; 左上Ｙ座標
	MOV	CX,WDX2			; Ｘサイズ
	MOV	DX,WDY2			; Ｙサイズ
	CALLC	MS_STOP			; マウスカーソル退避

	CALL	BASE_FLAME		; フレーム１

	CALL	WID_KZ_KA		; 縁飾りＡ１

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWID_2_FLAME



; ****************************************************
;	WINDOWS/フレーム３
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_3_FLAME,WID_3_FLAME
	MOV	AX,WDX1			; 左上Ｘ座標
	MOV	BX,WDY1			; 左上Ｙ座標
	MOV	CX,WDX2			; Ｘサイズ
	MOV	DX,WDY2			; Ｙサイズ
	CALLC	MS_STOP			; マウスカーソル退避

	MOVX	VX1,WDX1		; 表示位置Ｘ
	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VX2,WDX1		; 表示位置Ｘ
	MOVX	VY2,WDY1		; 表示位置Ｙ
	ADDX	VX2,WDX2		; 大きさＸ
	ADDX	VY2,WDY2		; 大きさＹ
	MOV	CX,4			;
	CALLC	BOXPAL			; ＢＯＸペイント

	CALL	WID_GAWA		; フレームの側

	CALL	WID_KZ_KA		; 縁飾りＡ１

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWID_3_FLAME


; ****************************************************
;	WINDOWS/フレーム４
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_4_FLAME,WID_4_FLAME
	MOV	AX,WDX1			; 左上Ｘ座標
	MOV	BX,WDY1			; 左上Ｙ座標
	MOV	CX,WDX2			; Ｘサイズ
	MOV	DX,WDY2			; Ｙサイズ
	CALLC	MS_STOP			; マウスカーソル退避

	MOVX	VX1,WDX1		; 表示位置Ｘ
	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VX2,WDX1		; 表示位置Ｘ
	MOVX	VY2,WDY1		; 表示位置Ｙ
	ADDX	VX2,WDX2		; 大きさＸ
	ADDX	VY2,WDY2		; 大きさＹ
	DEC	VX2			;
	DEC	VY2			;
	MOV	CX,4			;
	CALLC	BOXPAL			; ＢＯＸペイント

	CALL	WID_GAWA		; フレームの側

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWID_4_FLAME


; ****************************************************
;	WINDOWS/フレーム５（宝石）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_5_FLAME,WID_5_FLAME

	MOV	AX,WDX1			; 左上Ｘ座標
	MOV	BX,WDY1			; 左上Ｙ座標
	MOV	CX,WDX2			; Ｘサイズ
	MOV	DX,WDY2			; Ｙサイズ
	CALLC	MS_STOP			; マウスカーソル退避


	CALL	BASE_FLAME		; フレーム１
	CALL	WID_GAWA_G		; フレームの側（ＧＯＬＤ）
	CALL	WID_KZ_KAH		; 縁飾り宝石

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWID_5_FLAME


; ****************************************************
;	WINDOWS/フレーム６（ミニ）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_6_FLAME,WID_6_FLAME
	MOV	AX,WDX1			; 左上Ｘ座標
	MOV	BX,WDY1			; 左上Ｙ座標
	MOV	CX,WDX2			; Ｘサイズ
	MOV	DX,WDY2			; Ｙサイズ
	CALLC	MS_STOP			; マウスカーソル退避

	CALL	BASE_FLAME		; フレーム１

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWID_6_FLAME


; ****************************************************
;	WINDOWS/フレーム７（エントリィ）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_7_FLAME,WID_7_FLAME
	MOV	AX,WDX1			; 左上Ｘ座標
	MOV	BX,WDY1			; 左上Ｙ座標
	MOV	CX,WDX2			; Ｘサイズ
	MOV	DX,WDY2			; Ｙサイズ
	CALLC	MS_STOP			; マウスカーソル退避

	CALL	BASE_FLAME		; フレーム１

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWID_7_FLAME


; ****************************************************
;	WINDOWS/フレーム８（フェイス）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_8_FLAME,WID_8_FLAME
	MOV	AX,WDX1			; 左上Ｘ座標
	MOV	BX,WDY1			; 左上Ｙ座標
	MOV	CX,WDX2			; Ｘサイズ
	MOV	DX,WDY2			; Ｙサイズ
	CALLC	MS_STOP			; マウスカーソル退避

	CALL	BASE_FLAME		; フレーム１
	CALL	WID_GAWA_G		; フレームの側（ＧＯＬＤ）
	CALL	WID_KZ_KAH		; 縁飾り宝石

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWID_8_FLAME


; ****************************************************
;	WINDOWS/フレーム９（オチ）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_9_FLAME,WID_9_FLAME
	MOV	AX,WDX1			; 左上Ｘ座標
	MOV	BX,WDY1			; 左上Ｙ座標
	MOV	CX,WDX2			; Ｘサイズ
	MOV	DX,WDY2			; Ｙサイズ
	CALLC	MS_STOP			; マウスカーソル退避

	CALL	BASE_FLAME		; フレーム１
	CALL	WID_GAWA_TP		; フレームの側（テーパ）
	CALL	WID_GAWA_G		; フレームの側（ＧＯＬＤ）
	CALL	WID_KZ_KAH		; 縁飾り宝石

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWID_9_FLAME


; ****************************************************
;	WINDOWS/フレーム10（武者修行マップ）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

FUNC	WWID_10_FLAME,WID_10_FLAME
;;	CALL	FAR PTR WWID_4_FLAME		; WINDOWS/フレーム４
	RET
FEND	WWID_10_FLAME


; ****************************************************
;	縁飾りＡ１
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

WID_KZ_KA	PROC	NEAR
	MOV	AX,WDX1			; 表示位置Ｘ
	MOV	BX,WDY1			; 表示位置Ｙ
	INC	BX			;
	CALLC	PT_KA1			; 縁飾りＡ１

	MOV	AX,WDX1			; 表示位置Ｘ
	ADD	AX,WDX2			; 大きさＸ
	DEC	AX			; - 1
	DEC	AX			; - 1
	DEC	AX			; - 1
	MOV	BX,WDY1			; 表示位置Ｙ
	INC	BX			;
	CALLC	PT_KA2			; 縁飾りＡ２

	MOV	AX,WDX1			; 表示位置Ｘ
	ADD	AX,WDX2			; 大きさＸ
	DEC	AX			; - 1
	DEC	AX			; - 1
	MOV	BX,WDY1			; 表示位置Ｙ
	ADD	BX,WDY2			; 大きさＹ
	SUB	BX,8*2+1		;
	CALLC	PT_KA3			; 縁飾りＡ３

	MOV	AX,WDX1			; 表示位置Ｘ
	MOV	BX,WDY1			; 表示位置Ｙ
	ADD	BX,WDY2			; 大きさＹ
	SUB	BX,8*2+1		;
	CALLC	PT_KA4			; 縁飾りＡ４

	RET
WID_KZ_KA	ENDP


; ****************************************************
;	縁飾り宝石
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

WID_KZ_KAH	PROC	NEAR
	MOV	AX,WDX1			; 表示位置Ｘ
	MOV	BX,WDY1			; 表示位置Ｙ
	DEC	AX			;
	SUB	BX,8			;
	CALLC	PT_K11			; 縁飾り１

	MOV	AX,WDX1			; 表示位置Ｘ
	ADD	AX,WDX2			; 大きさＸ
	DEC	AX			; - 1
	DEC	AX			; - 1
	MOV	BX,WDY1			; 表示位置Ｙ
	SUB	BX,8			;
	CALLC	PT_K12			; 縁飾り２

	MOV	AX,WDX1			; 表示位置Ｘ
	ADD	AX,WDX2			; 大きさＸ
	DEC	AX			; - 1
	DEC	AX			; - 1
	MOV	BX,WDY1			; 表示位置Ｙ
	ADD	BX,WDY2			; 大きさＹ
	SUB	BX,15			;
	CALLC	PT_K13			; 縁飾り３

	MOV	AX,WDX1			; 表示位置Ｘ
	MOV	BX,WDY1			; 表示位置Ｙ
	ADD	BX,WDY2			; 大きさＹ
	DEC	AX			; －１
	SUB	BX,14			;
	CALLC	PT_K14			; 縁飾り４

	RET
WID_KZ_KAH	ENDP


WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'
DATA	ENDS

	END
;
;	end of "WIDKAZ.ASM"
;
