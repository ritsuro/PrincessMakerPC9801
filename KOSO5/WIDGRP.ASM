; "WIDGRP.ASM" PC-9801UV11 make by R.H 1990/10/13
;
;
;	ＷＩＮＤＯＷＳ／グラフセット（動的パラメータ系）
;
;
;	WIDHBR_INIT		; WINDOWS/横グラフ初期処理
;	WIDHBR			; WINDOWS/横グラフ表示
;	WIDHBRN			; WINDOWS/横グラフ表示（ブリンクなし）
;	WIDHBRS			; WINDOWS/横グラフ再表示
;	WIDHBRSN		; WINDOWS/横グラフ再表示（ブリンクなし）
;	WIDHBR_DP		; WINDOWS/横グラフ表示・ウインドウ外指定
;	WIDHBR_MAX		; WINDOWS/横グラフ最大表示
;	WIDHBR_RELOC		; WINDOWS/横グラフ位置変更
;	WIDHBR_CAL		; WINDOWS/横グラフ位置変更・計算のみ
;	WIDHBR_SGET		; WINDOWS/横グラフ位置情報ＧＥＴ
;	WIDHBR_SPUT		; WINDOWS/横グラフ位置情報ＰＵＴ
;	WIDHBR_DGET		; WINDOWS/横グラフデータＧＥＴ
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

;	ＷＩＮＤＯＷセグメントからＣＯＤＥセグメントへ

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

;	ＣＯＤＥセグメントからＷＩＮＤＯＷセグメントへ

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:WINDOW,DS:DATA
L1:
	ENDM



MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

SUBX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	SUB	DEST,AX
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA


; ****************************************************
;	WINDOWS/横グラフ初期処理
; ****************************************************

FUNC	WWIDHBR_INIT,WIDHBR_INIT
	RET
FEND	WWIDHBR_INIT


; ****************************************************
;	WINDOWS/横グラフ表示
;	-I- WDGNO : 横グラフ番号
;	    WDVAL : 表示値
; ****************************************************

FUNC	WWIDHBR,WIDHBR

	MOV	AX,WDGNO			; 横グラフ番号
	CMP	AX,WIDMAX_GRP			; グラフテーブルレコード数
	JNB	WIDHBR_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し

	MOVX	ES:[BX][GRP_VALUE],WDVAL	; 表示値／テーブルへ書き込み

	MOVX	DSP_VALUE,WDVAL			; 表示値

	TEST	DSP_FLAGS,FLAGS_DISP		; フラグ／表示ＯＮ？
	JNZ	WIDHBR_1			;

	CALL	WIDGRP_ON			; 指定の横グラフをＯＮ
	CALL	WIDHBR_BRI			; 指定の横グラフブリンク

	JMP	WIDHBR_EXIT			;
WIDHBR_1:					;
	CALL	WIDGRP_VAL			; 横グラフ表示値更新
	CALL	WIDHBR_BRI			; 指定の横グラフブリンク
WIDHBR_EXIT:					;
	RET
FEND	WWIDHBR


; ****************************************************
;	WINDOWS/横グラフ表示（ブリンクなし）
;	-I- WDGNO : 横グラフ番号
;	    WDVAL : 表示値
; ****************************************************

FUNC	WWIDHBRN,WIDHBRN

	MOV	AX,WDGNO			; 横グラフ番号
	CMP	AX,WIDMAX_GRP			; グラフテーブルレコード数
	JNB	WIDHBRN_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し

	MOVX	ES:[BX][GRP_VALUE],WDVAL	; 表示値／テーブルへ書き込み

	MOVX	DSP_VALUE,WDVAL			; 表示値

	TEST	DSP_FLAGS,FLAGS_DISP		; フラグ／表示ＯＮ？
	JNZ	WIDHBRN_1			;

	CALL	WIDGRP_ON			; 指定の横グラフをＯＮ
	JMP	WIDHBRN_EXIT			;
WIDHBRN_1:					;
	CALL	WIDGRP_VAL			; 横グラフ表示値更新
WIDHBRN_EXIT:					;
	RET
FEND	WWIDHBRN


; ****************************************************
;	WINDOWS/横グラフ再表示
;	-I- WDGNO : 横グラフ番号
; ****************************************************

FUNC	WWIDHBRS,WIDHBRS

	MOV	AX,WDGNO			; 横グラフ番号
	CMP	AX,WIDMAX_GRP			; グラフテーブルレコード数
	JNB	WIDHBRS_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し

	TEST	DSP_FLAGS,FLAGS_DISP		; フラグ／表示ＯＮ？
	JNZ	WIDHBRS_1			;

	CALL	WIDGRP_ON			; 指定の横グラフをＯＮ
	CALL	WIDHBR_BRI			; 指定の横グラフブリンク

	JMP	WIDHBRS_EXIT			;
WIDHBRS_1:					;
	CALL	WIDGRP_VAL			; 横グラフ表示値更新
	CALL	WIDHBR_BRI			; 指定の横グラフブリンク
WIDHBRS_EXIT:					;

	RET
FEND	WWIDHBRS


; ****************************************************
;	WINDOWS/横グラフ再表示（ブリンクなし）
; ****************************************************

FUNC	WWIDHBRSN,WIDHBRSN
	MOV	AX,WDGNO			; 横グラフ番号
	CMP	AX,WIDMAX_GRP			; グラフテーブルレコード数
	JNB	WIDHBRS_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し

	TEST	DSP_FLAGS,FLAGS_DISP		; フラグ／表示ＯＮ？
	JNZ	WIDHBRS_1			;

	CALL	WIDGRP_ON			; 指定の横グラフをＯＮ

	JMP	WIDHBRS_EXIT			;
WIDHBRSN_1:					;
	CALL	WIDGRP_VAL			; 横グラフ表示値更新
WIDHBRSN_EXIT:					;
	RET
FEND	WWIDHBRSN


; ****************************************************
;	WINDOWS/横グラフ表示・ウインドウ外指定
;	-I- WDGNO : 横グラフ番号
;	    WDXX  : Ｘ座標
;	    WDYY  : Ｙ座標
; ****************************************************

FUNC	WWIDHBR_DP,WIDHBR_DP
	MOVX	WIDGRP_SRTX,WDXX		; 横グラフ開始位置Ｘ
	MOVX	GR_DSPXX,WDXX			; 表示Ｘ位置
	MOVX	GR_DSPYY,WDYY			; 表示Ｙ位置

	SUBX	WIDGRP_SRTX,W_CLM0		; 横グラフ開始位置Ｘ
	SUBX	GR_DSPXX,W_CLM0			; 表示Ｘ位置

	MOV	AX,WDGNO			; 横グラフ番号
	CMP	AX,WIDMAX_GRP			; グラフテーブルレコード数
	JNB	WIDHBR_DP_EXIT			;

	ADDX	GR_DSPXX,W_CLM3			; カラム・グラフ

	MOV	AX,GR_DSPXX			; グラフ表示Ｘ位置
	MOV	BX,GR_DSPYY			; グラフ表示Ｙ位置
	CALLC	PT_PUT_GRAPH			; グラフＰＵＴ

	CALL	WIDPAR				; テーブル内容取り出し

	MOV	GR_DSPWD,5			; グラフ表示太さ
	MOV	GR_DSPCOL,0			; グラフ表示色
	MOVX	GR_DSPVAL,440			;
	CALL	WIDGRP_HBER			; 横グラフ描画

	MOV	GR_DSPWD,5			; グラフ表示太さ
	MOVX	GR_DSPCOL,G_COL3		; 最大値グラフカラー
	MOVX	GR_DSPVAL,DSP_VALMAX		; グラフ最大
	CALL	WIDGRP_HBER			; 横グラフ描画

	MOV	GR_DSPWD,5			; グラフ表示太さ
	MOVX	GR_DSPCOL,G_COL1		; グラフ表示色
	MOVX	GR_DSPCL2,W_COL1		; グラフ文字表示色
	MOV	GR_DSPCSZ,0			; グラフ文字表示サイズ
	MOVX	GR_DSPVAL,DSP_VALUE		; グラフ表示値
	MOVX	GR_DSPVALMAX,DSP_VALMAX		; グラフ表示最大値

	CALL	WIDSTRSET			; グラフ名表示
	CALL	WIDVALDSP			; 表示値表示
	CALL	WIDGRP_HBER			; 横グラフ描画

WIDHBR_DP_EXIT:					;
	RET
FEND	WWIDHBR_DP


; ****************************************************
;	WINDOWS/横グラフ最大表示
;	-I- WDGNO : 横グラフ番号
;	    WDVAL : 表示値
; ****************************************************

FUNC	WWIDHBR_MAX,WIDHBR_MAX

	MOV	AX,WDGNO			; 横グラフ番号
	CMP	AX,WIDMAX_GRP			; グラフテーブルレコード数
	JNB	WIDHBR_MAX_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し

	MOVX	ES:[BX][GRP_VALMAX],WDVAL	; グラフ最大／テーブルへ書込み

	MOVX	DSP_VALMAX,WDVAL		; グラフ最大

	TEST	DSP_FLAGS,FLAGS_DISP		; フラグ／表示ＯＮ？
	JNZ	WIDHBR_MAX_1			;

	CALL	WIDGRP_ON			; 指定の横グラフをＯＮ
	CALL	WIDHBR_BRI			; 指定の横グラフブリンク

	JMP	WIDHBR_MAX_EXIT			;
WIDHBR_MAX_1:					;
	CALL	WIDGRP_VAL			; 横グラフ表示値更新
	CALL	WIDHBR_BRI			; 指定の横グラフブリンク
WIDHBR_MAX_EXIT:				;
	RET
FEND	WWIDHBR_MAX


; ****************************************************
;	WINDOWS/横グラフ位置変更
;	-I- AX : 横グラフ描画Ｘ位置
;	    DX : 横グラフ描画開始位置
;	    CX : 横グラフ描画本数
; ****************************************************

FUNC	WWIDHBR_RELOC,WIDHBR_RELOC

	MOV	WIDGRP_SRTX,AX		; 横グラフ開始位置Ｘ
	MOV	WIDGRP_UP,DX		; 横グラフ描画開始位置
	MOV	WIDGRP_CNT,CX		; 横グラフ描画本数
	CALL	WIDGRP_LOC		; ロケーション計算

	CALL	WIDGRP_SIDE_FREAM	; 横グラフ外側フレーム

	CALL	WIDGRP_FLGSET		; 全グラフフラグの更新
	CALL	WIDGRP_ALL		; 横グラフの全表示

	RET
FEND	WWIDHBR_RELOC


; ****************************************************
;	WINDOWS/横グラフ位置変更・計算のみ
;	-I- AX : 横グラフ描画Ｘ位置
;	    DX : 横グラフ描画開始位置
;	    CX : 横グラフ描画本数
; ****************************************************

FUNC	WWIDHBR_CAL,WIDHBR_CAL
	MOV	WIDGRP_SRTX,AX		; 横グラフ開始位置Ｘ
	MOV	WIDGRP_UP,DX		; 横グラフ描画開始位置
	MOV	WIDGRP_CNT,CX		; 横グラフ描画本数
	CALL	WIDGRP_LOC		; ロケーション計算

	CALL	WIDGRP_FLGSET		; 全グラフフラグの更新
	RET
FEND	WWIDHBR_CAL


; ****************************************************
;	WINDOWS/横グラフ位置情報ＧＥＴ
;	-O- BX : 横グラフ描画開始番号
; ****************************************************

FUNC	WWIDHBR_SGET,WIDHBR_SGET
	MOV	BX,WIDGRP_START		; 横グラフ描画開始番号
	RET
FEND	WWIDHBR_SGET


; ****************************************************
;	WINDOWS/横グラフ位置情報ＰＵＴ
;	-I- BX : 横グラフ描画開始番号
; ****************************************************

FUNC	WWIDHBR_SPUT,WIDHBR_SPUT
	MOV	WIDGRP_START,BX		; 横グラフ描画開始番号
	RET
FEND	WWIDHBR_SPUT


; ****************************************************
;	WINDOWS/横グラフデータＧＥＴ
;	-I- BX    : 横グラフ番号
;	-O- ES:BX : テーブルアドレス
;	    SI    : グラフ名前
;	    DX    : グラフ数値
; ****************************************************

FUNC	WWIDHBR_DGET,WIDHBR_DGET
	MOV	WDGNO,BX			; 横グラフ番号
	CALL	WIDPAR				; テーブル内容取り出し
	MOV	SI,DSP_NAME			; グラフ名前
	MOV	DX,DSP_VALUE			; グラフ数値
	RET
FEND	WWIDHBR_DGET


;	横グラフ外側フレーム

WIDGRP_SIDE_FREAM	PROC	NEAR
	MOVX	WDGNO,WIDGRP_START		; 横グラフ描画開始番号
	CALL	WIDGRP_LOCATE			; 横グラフ表示位置

	MOVX	WDX1,W_CLM0			; カラム・先頭
	ADDX	WDX1,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	MOVX	WDY1,GR_DSPYY			; グラフ表示Ｙ位置

	MOVX	WDX2,LINE_WIDTH			; 内容表示１本の長さ

	MOV	AX,LINE_HIGHT			; 横グラフ１本の高さ
	MOV	BX,WIDGRP_CNT			; 横グラフ描画本数
	MUL	BX				;
	MOV	WDY2,AX				; 高さ

	SUB	WDX1,1				; Ｘ
	SUB	WDY1,8				; Ｙ
	ADD	WDX2,2				; 長さ
	ADD	WDY2,8*2			; 高さ

	CALLC	WID_4_FLAME			; WINDOWS/フレーム４


	MOVX	WDGNO,WIDGRP_START		; 横グラフ描画開始番号
	MOV	CX,WIDGRP_CNT			; 横グラフ描画本数
WIDGRP_SIDE_FREAM_LOOP:
	PUSH	CX				;
	CALL	WIDGRP_LOCATE			; 横グラフ表示位置
	MOV	AX,GR_DSPXX			; グラフ表示Ｘ位置
	MOV	BX,GR_DSPYY			; グラフ表示Ｙ位置
	CALLC	PT_PUT_GRAPH			; グラフＰＵＴ
	INC	WDGNO				; 横グラフ番号
	POP	CX				;
	LOOP	WIDGRP_SIDE_FREAM_LOOP		;

	RET
WIDGRP_SIDE_FREAM	ENDP



;	指定の横グラフをＯＮ
;	-I- WDGNO : 横グラフ番号

WIDGRP_ON	PROC	NEAR
	PUSH	ES
	PUSH	BX

	CALL	WIDGRP_SHOW		; 指定の横グラフを表示エリアへ
	CALL	WIDGRP_ALL		; 横グラフの全表示

	POP	BX
	POP	ES
	RET
WIDGRP_ON	ENDP


;	横グラフ表示値更新
;	-I- WDGNO : 横グラフ番号
;	    ES:BX : テーブルアドレス
;	    DSP_NAME  : グラフ名前
;	    DSP_VALUE : グラフ数値
;	    DSP_ATR   : グラフ属性
;	    DSP_HELP  : グラフ説明
;	    DSP_FLAGS : グラフフラグ
;	    DSP_VALMAX: グラフ最大

WIDGRP_VAL	PROC	NEAR
	PUSH	ES
	PUSH	BX

	CALL	WIDGRP_REDRAW			; 横グラフの更新表示

	POP	BX
	POP	ES
	RET
WIDGRP_VAL	ENDP


;	指定の横グラフブリンク
;	-I- WDGNO : 横グラフ番号

WIDHBR_BRI	PROC	NEAR
	PUSH	ES
	PUSH	BX

	CALL	WIDGRP_LOCATE			; 横グラフ表示位置
	CALL	WIDGRP_BK			; 横グラフブリンク

	POP	BX
	POP	ES
	RET
WIDHBR_BRI	ENDP


;	横グラフの全表示
;	-I- WIDGRP_START : 横グラフ描画開始番号
;	    WIDGRP_END   : 横グラフ描画終了番号

WIDGRP_ALL	PROC	NEAR
	PUSH	WDGNO				;

	MOVX	WDGNO,WIDGRP_START		; 横グラフ描画開始番号
WIDGRP_ALL_LOOP:
	MOV	AX,WDGNO			; 横グラフ番号
	CMP	AX,WIDMAX_GRP			; グラフテーブルレコード数
	JNB	WIDGRP_ALL_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し
	CALL	WIDGRP_DRAW			; 横グラフの表示

	MOV	AX,WDGNO			; 横グラフ番号
	CMP	AX,WIDGRP_END			; 横グラフ描画終了番号
	JE	WIDGRP_ALL_EXIT			;

	INC	WDGNO				; 横グラフ番号
	JMP	WIDGRP_ALL_LOOP

WIDGRP_ALL_EXIT:
	POP	WDGNO				;
	RET
WIDGRP_ALL	ENDP




;	テーブル内容取り出し
;	-I- WDGNO : 横グラフ番号
;	-O- ES:BX : テーブルアドレス
;	    DSP_NAME  : グラフ名前
;	    DSP_VALUE : グラフ数値
;	    DSP_VALMAX: グラフ最大
;	    DSP_ATR   : グラフ属性
;	    DSP_HELP  : グラフ説明
;	    DSP_FLAGS : グラフフラグ

WIDPAR	PROC	NEAR
	MOV	AX,WDGNO			; 横グラフ番号
	CALL	WIDADR				; テーブルアドレス

	MOVX	DSP_NAME, ES:[BX][GRP_NAME]	; グラフ名前
	MOVX	DSP_VALUE,ES:[BX][GRP_VALUE]	; グラフ数値
	MOVX	DSP_VALMAX,ES:[BX][GRP_VALMAX]	; グラフ最大
	MOVX	DSP_ATR,  ES:[BX][GRP_ATR]	; グラフ属性
	MOVX	DSP_HELP, ES:[BX][GRP_HELP]	; グラフ説明
	MOVX	DSP_FLAGS,ES:[BX][GRP_FLAGS]	; グラフフラグ

	RET
WIDPAR	ENDP


;	テーブルアドレス
;	-I- AX    : 横グラフ番号
;	-O- ES:BX : テーブルアドレス

WIDADR	PROC	NEAR
	MOV	BX,GRP_NEXT		; 次のグラフ
	MUL	BL			; AX=AX*BL
	MOV	BX,AX			;
	ADD	BX,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	RET
WIDADR	ENDP



;	横グラフの表示
;	-I- WDGNO : 横グラフ番号
;	    DSP_NAME  : グラフ名前
;	    DSP_VALUE : グラフ数値
;	    DSP_ATR   : グラフ属性
;	    DSP_HELP  : グラフ説明
;	    DSP_FLAGS : グラフフラグ
;	    DSP_VALMAX : グラフ最大

WIDGRP_DRAW	PROC	NEAR
	CALL	WIDGRP_LOCATE			; 横グラフ表示位置

	MOV	GR_DSPWD,5			; グラフ表示太さ
	MOV	GR_DSPCOL,0			; グラフ表示色
	MOVX	GR_DSPVAL,440			;
	CALL	WIDGRP_HBER			; 横グラフ描画

;*;	MOV	GR_DSPWD,5			; グラフ表示太さ
;*;	MOVX	GR_DSPCOL,G_COL3		; 最大値グラフカラー
;*;	MOVX	GR_DSPVAL,DSP_VALMAX		; グラフ最大
;*;	CALL	WIDGRP_HBER			; 横グラフ描画
;*;
	MOV	GR_DSPWD,5			; グラフ表示太さ
	MOVX	GR_DSPCOL,G_COL1		; グラフ表示色
	MOVX	GR_DSPCL2,W_COL1		; グラフ文字表示色
	MOV	GR_DSPCSZ,0			; グラフ文字表示サイズ
	MOVX	GR_DSPVAL,DSP_VALUE		; グラフ表示値
	MOVX	GR_DSPVALMAX,DSP_VALMAX		; グラフ表示最大値

	CALL	WIDSTRSET			; グラフ名表示
	CALL	WIDVALDSP			; 表示値表示
	CALL	WIDGRP_HBER			; 横グラフ描画
	RET
WIDGRP_DRAW	ENDP



;	横グラフの更新表示
;	-I- WDGNO : 横グラフ番号
;	    DSP_NAME  : グラフ名前
;	    DSP_VALUE : グラフ数値
;	    DSP_ATR   : グラフ属性
;	    DSP_HELP  : グラフ説明
;	    DSP_FLAGS : グラフフラグ
;	    DSP_VALMAX: グラフ最大

WIDGRP_REDRAW	PROC	NEAR
	CALL	WIDGRP_LOCATE			; 横グラフ表示位置

	MOV	GR_DSPWD,5			; グラフ表示太さ
	MOV	GR_DSPCOL,0			; グラフ表示色
	MOVX	GR_DSPVAL,440			;
	CALL	WIDGRP_HBER			; 横グラフ描画

	MOV	GR_DSPWD,5			; グラフ表示太さ
	MOVX	GR_DSPCOL,G_COL3		; 最大値グラフカラー
	MOVX	GR_DSPVAL,DSP_VALMAX		; グラフ最大
	CALL	WIDGRP_HBER			; 横グラフ描画

	MOV	GR_DSPWD,5			; グラフ表示太さ
	MOVX	GR_DSPCOL,G_COL1		; グラフ表示色
	MOVX	GR_DSPCL2,W_COL1		; グラフ文字表示色
	MOV	GR_DSPCSZ,0			; グラフ文字表示サイズ
	MOVX	GR_DSPVAL,DSP_VALUE		; グラフ表示値
	MOVX	GR_DSPVALMAX,DSP_VALMAX		; グラフ表示最大値

	CALL	WIDVALDSP			; 表示値表示
	CALL	WIDGRP_HBER			; 横グラフ描画
	RET
WIDGRP_REDRAW	ENDP




;	横グラフ表示位置
;	-I- WDGNO : 横グラフ番号
;	-O- GR_DSPXX : グラフ表示Ｘ位置
;	    GR_DSPYY : グラフ表示Ｙ位置

WIDGRP_LOCATE	PROC	NEAR
	MOVX	GR_DSPXX,W_CLM3			; カラム・グラフ
	ADDX	GR_DSPXX,WIDGRP_SRTX		; 横グラフ開始位置Ｘ

	MOV	AX,WIDGRP_UP			; 横グラフ描画開始位置
	MOV	CX,LOCATE_HIGHT			; 表示ライン１本の高さ
	MUL	CL				;
	MOV	GR_DSPYY,AX			; グラフ表示Ｙ位置

	MOV	AX,WDGNO			; 横グラフ番号
	SUB	AX,WIDGRP_START			; 横グラフ描画開始番号
	MOV	CX,LINE_HIGHT			; 横グラフ１本の高さ
	MUL	CL				;
	ADD	GR_DSPYY,AX			; グラフ表示Ｙ位置

	RET
WIDGRP_LOCATE	ENDP



;	指定の横グラフを表示エリアへ
;	-I-   WDGNO        : 横グラフ番号
;	-I/O- WIDGRP_START : 横グラフ描画開始番号
;	      WIDGRP_END   : 横グラフ描画終了番号
;	      WIDGRP_UP    : 横グラフ描画開始位置
;	      WIDGRP_CNT   : 横グラフ描画本数

WIDGRP_SHOW	PROC	NEAR
	MOV	AX,WDGNO			; 横グラフ番号
	CMP	AX,WIDGRP_START			; 横グラフ描画開始番号
	JB	WIDGRP_SHOW_UPPER		;
	CMP	AX,WIDGRP_END			; 横グラフ描画終了番号
	JNBE	WIDGRP_SHOW_UNDER		;

	CALL	WIDGRP_FLGSET			; 全グラフフラグの更新
	JMP	WIDGRP_SHOW_EXIT		;


WIDGRP_SHOW_UPPER:				;
	MOV	AX,WDGNO			; 横グラフ番号
	MOV	WIDGRP_START,AX			; 横グラフ描画開始番号

	JMP	WIDGRP_SHOW_CALC		;


WIDGRP_SHOW_UNDER:				;
	MOV	AX,WDGNO			; 横グラフ番号
	SUB	AX,WIDGRP_CNT			; 横グラフ描画本数
	INC	AX				;
	MOV	WIDGRP_START,AX			; 横グラフ描画開始番号

WIDGRP_SHOW_CALC:				;
	CALL	WIDGRP_LOC			; ロケーション計算
	CALL	WIDGRP_FLGSET			; 全グラフフラグの更新

WIDGRP_SHOW_EXIT:
	RET
WIDGRP_SHOW	ENDP



;	ロケーション計算
;	-I/O- WIDGRP_START : 横グラフ描画開始番号
;	      WIDGRP_UP    : 横グラフ描画開始位置
;	      WIDGRP_CNT   : 横グラフ描画本数
;	-O-   WIDGRP_END   : 横グラフ描画終了番号

WIDGRP_LOC	PROC	NEAR

WIDGRP_LOC_START:
	MOV	AX,WIDVIEW_MIN			; グラフ表示エリア下限
	CMP	WIDGRP_UP,AX			; 横グラフ描画開始位置
	JGE	WIDGRP_LOC_2			;
	MOV	WIDGRP_UP,AX			;
WIDGRP_LOC_2:

	MOV	AX,WIDVIEW_MAX			; グラフ表示エリア上限
	CMP	WIDGRP_UP,AX			; 横グラフ描画開始位置
	JLE	WIDGRP_LOC_3			;
	MOV	WIDGRP_UP,AX			; 表示エリア上限
WIDGRP_LOC_3:

	MOV	AX,WIDVIEW_MAX			; グラフ表示エリア上限
	SUB	AX,WIDGRP_UP			; 横グラフ描画開始位置
	INC	AX				; これが最大表示本数
	CMP	WIDGRP_CNT,AX			; 横グラフ描画本数
	JLE	WIDGRP_LOC_4			;
	MOV	WIDGRP_CNT,AX			; 横グラフ描画本数
WIDGRP_LOC_4:					;

	CMP	WIDGRP_CNT,1			; 横グラフ描画本数
	JGE	WIDGRP_LOC_5			;
	MOV	WIDGRP_CNT,1			;
WIDGRP_LOC_5:

	MOV	AX,WIDGRP_START			; 横グラフ描画開始番号
	ADD	AX,WIDGRP_CNT			; 横グラフ描画本数
	DEC	AX				;
	MOV	WIDGRP_END,AX			; 横グラフ描画終了番号



	MOV	AX,WIDGRP_END			; 横グラフ描画終了番号
	CMP	AX,WIDMAX_GRP			; グラフテーブルレコード数
	JL	WIDGRP_LOC_EXIT			;

	MOV	AX,WIDGRP_END			; 横グラフ描画終了番号
	INC	AX				;
	SUB	AX,WIDMAX_GRP			; グラフテーブルレコード数
	SUB	WIDGRP_START,AX			; 横グラフ描画開始番号
	CMP	WIDGRP_START,0			;
	JGE	WIDGRP_LOC_8			;
	MOV	WIDGRP_START,0			;
WIDGRP_LOC_8:
	JMP	WIDGRP_LOC_START		;

WIDGRP_LOC_EXIT:
	RET
WIDGRP_LOC	ENDP



;	全グラフフラグの更新
;	-I- WIDGRP_START : 横グラフ描画開始番号
;	    WIDGRP_END   : 横グラフ描画終了番号

WIDGRP_FLGSET	PROC	NEAR
	MOV	AX,0				; 横グラフ番号
	CALL	WIDADR				; テーブルアドレス

	MOV	CX,WIDMAX_GRP			; グラフテーブルレコード数
WIDGRP_FLGSET_LOOP:				;
	AND	WORD PTR ES:[BX][GRP_FLAGS],NOT FLAGS_DISP ; フラグ／表示ＯＦＦ
	ADD	BX,GRP_NEXT			; 次のグラフ
	LOOP	WIDGRP_FLGSET_LOOP		;

	MOV	AX,WIDGRP_START			; 横グラフ描画開始番号
	CALL	WIDADR				; テーブルアドレス

	MOV	AX,WIDGRP_START			; 横グラフ描画開始番号
WIDGRP_FLGSET_LOOP2:				;
	OR	WORD PTR ES:[BX][GRP_FLAGS],FLAGS_DISP ; フラグ／表示ＯＮ
	ADD	BX,GRP_NEXT			; 次のグラフ
	INC	AX				;
	CMP	AX,WIDGRP_END			; 横グラフ描画終了番号
	JBE	WIDGRP_FLGSET_LOOP2		;

WIDGRP_FLGSET_EXIT:				;
	RET
WIDGRP_FLGSET	ENDP




;	横グラフ描画
;	-I- GR_DSPVAL : グラフ表示値
;	    GR_DSPXX  : グラフ表示Ｘ位置
;	    GR_DSPYY  : グラフ表示Ｙ位置
;	    GR_DSPWD  : グラフ表示太さ
;	    GR_DSPCOL : グラフ表示色

WIDGRP_HBER	PROC	NEAR
	PUSH	ES			;
	PUSH	BX			;

	MOV	AX,GR_DSPXX		; グラフ表示Ｘ位置
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX1,AX			; グラフ表示Ｘ位置

	MOV	AX,GR_DSPVAL		; グラフ表示値
	MOV	DX,0			;
	DIV	GR_SCALE		; グラフスケール １／ｎ
	MOV	VX2,AX			;
	ADDX	VX2,VX1			;

	MOV	AX,VX1			;
	ADD	AX,GR_LENGTH		; グラフ限界長さ
	CMP	VX2,AX			;
	JBE	WIDGRP_HBER_5		;
	MOV	VX2,AX			;
WIDGRP_HBER_5:

	MOV	AX,GR_DSPYY		; グラフ表示Ｙ位置
	ADD	AX,4+1			;
	MOV	VY1,AX			;

	MOV	CX,GR_DSPWD		; グラフ表示太さ
	MOVX	VCOL,GR_DSPCOL		; グラフ表示色
	CALLC	DLINEH			; 水平ライン描画

	CMP	GR_DSPCOL,0		; グラフ表示色
	JE	WIDGRP_HBER_EXIT	;

	CMPX	GR_DSPCOL,G_COL3	; 最大値グラフカラー
	JE	WIDGRP_HBER_56		;
WIDGRP_HBER_55:
	MOVX	VCOL,G_COL4		; グラフ影カラー
	JMP	WIDGRP_HBER_57		;
WIDGRP_HBER_56:
	MOVX	VCOL,G_COL5		; 最大値グラフ影カラー
WIDGRP_HBER_57:
	MOV	CX,1			;
	CALLC	DLINEH			; 水平ライン描画

	MOV	AX,VX2
	SUB	AX,VX1
	CMP	AX,5
	JLE	WIDGRP_HBER_6
	MOV	VX2,5
	ADDX	VX2,VX1
WIDGRP_HBER_6:
	CMPX	GR_DSPCOL,G_COL3	; 最大値グラフカラー
	JE	WIDGRP_HBER_6_R		;

	MOV	CX,GR_DSPWD		; グラフ表示太さ
	MOVX	VCOL,G_COL4		; グラフ影カラー
	CALLC	DLINEH			; 水平ライン描画
	JMP	WIDGRP_HBER_EXIT	;
WIDGRP_HBER_6_R:
	MOV	CX,GR_DSPWD		; グラフ表示太さ
	MOVX	VCOL,G_COL5		; 最大値グラフ影カラー
	CALLC	DLINEH			; 水平ライン描画
WIDGRP_HBER_EXIT:
	POP	BX			;
	POP	ES			;
	RET
WIDGRP_HBER	ENDP


;	表示値表示
;	もし表示値＝表示最大値ならば１段表示
;	違うならば表示値／表示最大値の２段表示
;
;	-I- GR_DSPVAL    : グラフ表示値
;	    GR_DSPVALMAX : グラフ表示最大値
;	    GR_DSPYY     : グラフ表示Ｙ位置

WIDVALDSP	PROC	NEAR

;*;	CMPX	GR_DSPVAL,GR_DSPVALMAX	; グラフ表示値／グラフ表示最大値
;*;	JE	WIDVALDSP_2		;
;*;	CALL	WIDVALDSP_MAX		; 表示最大値表示
;*;	JMP	WIDVALDSP_EXIT		;
;*;WIDVALDSP_2:

	MOV	AX,0			; 0=ノーマル,1=中線付き
	CALL	WIDGVAL_FLAME		; グラフ数値のフレーム

	MOV	DX,GR_DSPVAL		; グラフ表示値
	CALL	WIDVALDSP_USING		; 表示値編集

;*NON*;	MOV	AX,0			; グラフ文字表示サイズ
;*NON*;	CALLC	VTXSIZ			; character size set.
;*NON*;
;*NON*;	MOV	AX,W_COL1		; グラフ文字表示色
;*NON*;	CALLC	VTXCOL			; character color set.

	MOV	AX,W_COL1		; グラフ文字表示色
	CALLC	MITCOL			; mini string color.

	MOV	AX,W_CLM2		; カラム・数値
	ADD	AX,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	MOV	BX,GR_DSPYY		; グラフ表示Ｙ位置
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	DEC	AX			; －１
	CALLC	MDTPRN			; MID string. (null=end of string)
;*NON*;	CALLC	VTXPOR			; vram text print OR.

WIDVALDSP_EXIT:
	RET
WIDVALDSP	ENDP


;*;;	表示最大値表示
;*;;	-I- GR_DSPVAL    : グラフ表示値
;*;;	    GR_DSPVALMAX : グラフ表示最大値
;*;;	    GR_DSPYY     : グラフ表示Ｙ位置
;*;
;*;WIDVALDSP_MAX	PROC	NEAR
;*;
;*;	MOV	AX,1			; 0=ノーマル,1=中線付き
;*;	CALL	WIDGVAL_FLAME		; グラフ数値のフレーム
;*;
;*;	MOV	AX,W_COL1		; グラフ文字表示色
;*;	CALLC	MITCOL			; mini string color.
;*;
;*;	MOV	DX,GR_DSPVAL		; グラフ表示値
;*;	CALL	WIDVALDSP_USING		; 表示値編集
;*;
;*;	MOV	AX,W_CLM2		; カラム・数値
;*;	ADD	AX,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
;*;	MOV	BX,GR_DSPYY		; グラフ表示Ｙ位置
;*;	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;	DEC	AX			; －１
;*;	CALLC	MITPRN			; mini string. (null=end of string)
;*;
;*;
;*;	MOV	AX,W_COL1		; グラフ文字表示色
;*;	MOV	AX,G_COL3		; 最大値グラフカラー
;*;	CALLC	MITCOL			; mini string color.
;*;
;*;	MOV	DX,GR_DSPVALMAX		; グラフ表示最大値
;*;	CALL	WIDVALDSP_USING		; 表示値編集
;*;
;*;	MOV	AX,W_CLM2M		; カラム・最大数値
;*;	ADD	AX,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
;*;	MOV	BX,GR_DSPYY		; グラフ表示Ｙ位置
;*;	ADD	BX,8			; ＋８（２段目）
;*;	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;	DEC	AX			; －１
;*;	CALLC	MITPRN			; mini string. (null=end of string)
;*;
;*;	MOV	AX,W_COL1		; グラフ文字表示色
;*;	CALLC	MITCOL			; mini string color.
;*;
;*;	RET
;*;WIDVALDSP_MAX	ENDP


;	表示値編集
;	-I- DX           : 数値
;	-O- STR_VAL_BUFF : 表示値文字列バッファ

WIDVALDSP_USING		PROC	NEAR
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	DECSTR			; dec -> string.
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
;*;	CALLC	STRSPL			; space pless. "  123" - > "123  "
	MOV	AX,DS:[SI][0] ;[1]	;
	MOV	BX,DS:[SI][2] ;[3]	;
	MOV	DL,DS:[SI][4] ;[5]	;
	MOV	DS:[DI][0],AX		;
	MOV	DS:[DI][2],BX		;
	MOV	DS:[DI][4],DL		;
	MOV	DS:[DI][5],BYTE PTR 0	;
	RET
WIDVALDSP_USING		ENDP



;	グラフ名表示
;	-I- WDGNO     : 横グラフ番号
;	    DSP_NAME  : グラフ名前
;	    GR_DSPYY  : グラフ表示Ｙ位置
;	    GR_DSPCL2 : グラフ文字表示色
;	    GR_DSPCSZ : グラフ文字表示サイズ

WIDSTRSET	PROC	NEAR
	CALL	WIDGNM_FLAME		; グラフ名のフレーム

	CALLC	STRCLEAR		; 文字列バッファクリア

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ

;*;	MOV	DX,WDGNO		; 横グラフ番号
;*;	CALLC	DECSTR			; dec -> string.
;*;	MOV	AX,DS:[SI][3]		;
;*;	MOV	DS:[DI],AX		;
;*;
;*;	ADD	DI,2			;

	MOV	SI,DSP_NAME		; グラフ表示単語
	MOV	CX,WIDNAMELEN		; グラフ名前最大長さ
	CALLC	STRSET			; 文字列バッファセット

	ADD	DI,WIDNAMELEN		; グラフ名前最大長さ
	ADD	DI,1			;
	MOV	DS:[DI],WORD PTR 0	;

	MOV	AX,GR_DSPCSZ		; グラフ文字表示サイズ
	CALLC	VTXSIZ			; character size set.

	MOV	AX,GR_DSPCL2		; グラフ文字表示色
	CALLC	VTXCOL			; character color set.

	MOV	AX,W_CLM0		; カラム・先頭
	ADD	AX,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	MOV	BX,GR_DSPYY		; グラフ表示Ｙ位置
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	VTXPOR			; vram text print OR.

	RET
WIDSTRSET	ENDP



;	グラフ名のフレーム
;	-I- GR_DSPYY  : グラフ表示Ｙ位置

WIDGNM_FLAME	PROC	NEAR
	MOVX	VX1,W_CLM0		; カラム・先頭
	ADDX	VX1,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	MOVX	VX2,W_CLM2		; カラム・数値
	ADDX	VX2,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	DEC	VX2			;

	MOV	AX,GR_DSPYY		; グラフ表示Ｙ位置
	MOV	VY1,AX			;
	ADD	AX,LINE_HIGHT		; 横グラフ１本の高さ
	DEC	AX			;
	MOV	VY2,AX			;
	MOV	CX,W_COL5		; WINDOWS/カラー・暗い色
	CALLC	BOXPAL			; ＢＯＸペイント
	MOVX	VX1,W_CLM1		; カラム・名前
	ADDX	VX1,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	MOV	CX,G_COL2		; 名前バックカラー
	CALLC	BOXMSS			; ＢＯＸメッシュ

;*;	MOVX	VX1,W_CLM0		; カラム・先頭
;*;	ADDX	VX1,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
;*;	MOVX	VX2,W_CLM1		; カラム・名前
;*;	ADDX	VX2,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
;*;	DEC	VX2			;
;*;	MOV	CX,0			; 名前バックカラー
;*;	CALLC	BOXMSS			; ＢＯＸメッシュ

	MOVX	VX1,W_CLM0		; カラム・先頭
	ADDX	VX1,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	MOVX	VX2,W_CLM2		; カラム・数値
	ADDX	VX2,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	DEC	VX2			;
	MOV	AX,VY1			;
	MOV	VY2,AX			;
	MOV	CX,0			;
	CALLC	BOXPAL			; ＢＯＸペイント
	RET
WIDGNM_FLAME	ENDP


;	グラフ数値のフレーム
;	-I- GR_DSPYY  : グラフ表示Ｙ位置
;	    AX        : 0=ノーマル,1=中線付き

WIDGVAL_FLAME	PROC	NEAR

	PUSH	AX			;

	MOVX	VX1,W_CLM2		; カラム・数値
	ADDX	VX1,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	MOVX	VX2,W_CLM3		; カラム・グラフ
	ADDX	VX2,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	DEC	VX2			;

	MOV	AX,GR_DSPYY		; グラフ表示Ｙ位置
	MOV	VY1,AX			;
	ADD	AX,LINE_HIGHT		; 横グラフ１本の高さ
	DEC	AX			;
	MOV	VY2,AX			;
	MOV	CX,W_COL5		; WINDOWS/カラー・暗い色
	CALLC	BOXPAL			; ＢＯＸペイント
	MOV	CX,0			; ０＝黒
	CALLC	BOXMSS			; ＢＯＸメッシュ

	MOV	AX,VY1			;
	MOV	VY2,AX			;
	MOV	CX,0			;
	CALLC	BOXPAL			; ＢＯＸペイント

	POP	AX			;

	CMP	AX,1			; 0=ノーマル,1=中線付き
	JNE	WIDGVAL_FLAME_5		;

	ADD	VY1,8			;
	MOV	AX,VY1			;
	ADD	AX,6			;
	MOV	VY2,AX			;
	MOV	CX,0			; ０＝黒
	CALLC	BOXPAL			; ＢＯＸペイント
WIDGVAL_FLAME_5:

	RET
WIDGVAL_FLAME	ENDP


;*NON*;;	グラフ最大数値のフレーム
;*NON*;;	-I- GR_DSPYY  : グラフ表示Ｙ位置
;*NON*;
;*NON*;WIDGVALMX_FLAME	PROC	NEAR
;*NON*;	MOVX	VX1,W_CLM2M		; カラム・最大数値
;*NON*;	MOVX	VX2,W_CLM2M		; カラム・グラフ
;*NON*;	ADD	VX2,6			;
;*NON*;
;*NON*;	MOV	AX,GR_DSPYY		; グラフ表示Ｙ位置
;*NON*;	MOV	VY1,AX			;
;*NON*;	ADD	AX,7			; 横グラフ１本の高さ
;*NON*;	DEC	AX			;
;*NON*;	MOV	VY2,AX			;
;*NON*;	MOV	CX,4			; カラー４
;*NON*;	CALLC	BOXPAL			; ＢＯＸペイント
;*NON*;;;	MOV	CX,0			;
;*NON*;;;	CALL	BOXMSS			; ＢＯＸメッシュ
;*NON*;
;*NON*;	RET
;*NON*;WIDGVALMX_FLAME	ENDP


;	横グラフブリンク
;	タイマ１使用
;	-I- GR_DSPYY  : グラフ表示Ｙ位置

WIDGRP_BK	PROC	NEAR
	PUSH	ES			;
	PUSH	BX			;

	MOV	CX,2			;
WIDGRP_BK_LOOP:				;
	PUSH	CX			;
	MOV	AX,5			; wait timer count.
	CALLC	TMVSET			; V-SYNC timer set.
	MOVX	VX1,W_CLM0		; カラム・先頭
	ADDX	VX1,WIDGRP_SRTX		; 横グラフ開始位置Ｘ
	MOVX	VX2,GR_DSPXX		; グラフ表示Ｘ位置
	DEC	VX2			;
	MOV	AX,GR_DSPYY		; グラフ表示Ｙ位置
	INC	AX			;
	MOV	VY1,AX			;
	ADD	AX,LINE_HIGHT		; 横グラフ１本の高さ
	DEC	AX			;
	DEC	AX			;
	MOV	VY2,AX			;
	MOV	CX,1111B		;
	CALLC	BOXNOT			; ＢＯＸ反転
	CALLC	TMVEWT			; V-SYNC timer end wait.
	POP	CX			;
	LOOP	WIDGRP_BK_LOOP		;

	POP	BX			;
	POP	ES			;
	RET
WIDGRP_BK	ENDP


WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	WDX1:WORD		; WINDOWS/ point x1.
EXTRN	WDY1:WORD		; WINDOWS/ point y1.
EXTRN	WDX2:WORD		; WINDOWS/ point x2.
EXTRN	WDY2:WORD		; WINDOWS/ point y2.

WIDGRP_UP	DW	0		; 横グラフ描画開始位置
WIDGRP_CNT	DW	25		; 横グラフ描画本数
WIDGRP_START	DW	0		; 横グラフ描画開始番号
WIDGRP_END	DW	24		; 横グラフ描画終了番号

WIDGRP_SRTX	DW	0		; 横グラフ開始位置Ｘ
;*;WIDGRP_SRTY	DW	0		; 横グラフ開始位置Ｙ

LOCATE_HIGHT	DW	8		; 表示ライン１本の高さ
LINE_WIDTH	DW	28-2		; 内容表示１本の長さ
LINE_HIGHT	DW	16		; 横グラフ１本の高さ

G_COL1		DW	8		; グラフカラー
G_COL2		DW	10		; 名前バックカラー
G_COL3		DW	10		; 最大値グラフカラー
G_COL4		DW	1		; グラフ影カラー
G_COL5		DW	4		; 最大値グラフ影カラー

DSP_NAME	DW	0		; グラフ名前
DSP_VALUE	DW	0		; グラフ数値
DSP_ATR		DW	0		; グラフ属性
DSP_HELP	DW	0		; グラフ説明
DSP_FLAGS	DW	0		; グラフフラグ
DSP_VALMAX	DW	0		; グラフ最大

W_CLM0		DW	2+0		; カラム・先頭
W_CLM1		DW	2+0		; カラム・名前
W_CLM2		DW	2+10-2		; カラム・数値
W_CLM2M		DW	2+10-2		; カラム・最大数値
W_CLM3		DW	2+14-2		; カラム・グラフ

GR_SCALE	DW	4		; グラフスケール １／ｎ
GR_LENGTH	DW	8*13		; グラフ限界長さ

GR_DSPXX	DW	0		; グラフ表示Ｘ位置
GR_DSPYY	DW	0		; グラフ表示Ｙ位置
GR_DSPWD	DW	0		; グラフ表示太さ
GR_DSPCOL	DW	0		; グラフ表示色
GR_DSPCL2	DW	0		; グラフ文字表示色
GR_DSPCSZ	DW	0		; グラフ文字表示サイズ
GR_DSPVAL	DW	0		; グラフ表示値
GR_DSPVALMAX	DW	0		; グラフ表示最大値

DATA	ENDS

	END
;
;	end of "WIDGRP.ASM"
;
