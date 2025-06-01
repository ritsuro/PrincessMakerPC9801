; "WIDVAL.ASM" PC-9801UV11 make by R.H 1990/10/13
;
;
;	ＷＩＮＤＯＷＳ／内容表示セット（静的パラメータ系）
;
;
;	WIDVAL_INIT		; WINDOWS/内容表示初期処理
;	WIDVAL			; WINDOWS/内容表示
;	WIDVAL_DP		; WINDOWS/内容表示・ウインドウ外指定
;	WIDVAL_RELOC		; WINDOWS/内容表示位置変更
;	WIDVAL_CAL		; WINDOWS/内容表示位置変更・計算のみ
;	WID_UNIT		; WINDOWS/単位別文字列化
;	WIDVAL_DGET		; WINDOWS/内容表示データＧＥＴ
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
;	WINDOWS/内容表示初期処理
; ****************************************************

FUNC	WWIDVAL_INIT,WIDVAL_INIT
	RET
FEND	WWIDVAL_INIT


; ****************************************************
;	WINDOWS/内容表示
;	-I- WDVNO : 内容表示番号
;	    WDVAL : 内容値（数値か文字列かは内容表示の型によって決まる）
; ****************************************************

FUNC	WWIDVAL,WIDVAL
	MOV	AX,WDVNO			; 内容表示番号
	CMP	AX,WIDMAX_VAL			; 内容表示テーブルレコード数
	JNB	WWIDVAL_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し

	MOVX	ES:[BX][VAL_VALUE_OLD],DSP_VALUE ; 内容表示 前回の内容値
	MOVX	ES:[BX][VAL_VALUE],WDVAL	; 内容値／テーブルへ書き込み

	MOVX	DSP_VALUE_OLD,DSP_VALUE		; 前回の内容値
	MOVX	DSP_VALUE,WDVAL			; 内容値

	CALL	WIDVAL_VAL			; 内容値更新
	CALL	WIDVAL_BRI			; 指定の内容値ブリンク
WWIDVAL_EXIT:					;
	RET
FEND	WWIDVAL


; ****************************************************
;	WINDOWS/内容表示・ウインドウ外指定
;	-I- WDVNO : 内容表示番号
;	    WDXX  : Ｘ座標
;	    WDYY  : Ｙ座標
; ****************************************************

FUNC	WWIDVAL_DP,WIDVAL_DP
	MOVX	PR_DSPXX,WDXX			; 表示Ｘ位置
	MOVX	PR_DSPYY,WDYY			; 表示Ｙ位置

	MOV	AX,WDVNO			; 内容表示番号
	CMP	AX,WIDMAX_VAL			; 内容表示テーブルレコード数
	JNB	WIDVAL_DP_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し
	CALL	WIDVAL_FLAME			; 内容値表示のフレーム

	MOVX	PR_DSPCLR,W_COL1	; パラメータ名文字表示色
	MOVX	PR_DSPCSZ,0		; パラメータ名内容文字表示サイズ

	CALL	WIDSTRSET			; パラメータ名表示

	CMP	DSP_TYPE,TYPE_VALUE		; 内容表示 ＶＡＬＵＥ型
	JE	WIDVAL_DP_VALUE			;
	CMP	DSP_TYPE,TYPE_BLANCE		; 内容表示 ＢＡＬＡＮＣＥ型
	JE	WIDVAL_DP_BLANCE		;
	CMP	DSP_TYPE,TYPE_NAME		; 内容表示 ＮＡＭＥ型
	JE	WIDVAL_DP_NAME			;
	CMP	DSP_TYPE,TYPE_TIME		; 内容表示 ＴＩＭＥ型
	JE	WIDVAL_DP_TIME			;
	CMP	DSP_TYPE,TYPE_GOLD		; 内容表示 ＧＯＬＤ型
	JE	WIDVAL_DP_GOLD			;
	JMP	WIDVAL_DP_EXIT			;

WIDVAL_DP_VALUE:				;
	CALL	WID_DRAW_VALUE			; 内容表示 ＶＡＬＵＥ型
	JMP	WIDVAL_DP_EXIT

WIDVAL_DP_BLANCE:				;
	CALL	WID_DRAW_BLANCE			; 内容表示 ＢＡＬＡＮＣＥ型
	JMP	WIDVAL_DP_EXIT

WIDVAL_DP_NAME:					;
	CALL	WID_DRAW_NAME			; 内容表示 ＮＡＭＥ型
	JMP	WIDVAL_DP_EXIT

WIDVAL_DP_TIME:					;
	CALL	WID_DRAW_TIME			; 内容表示 ＴＩＭＥ型
	JMP	WIDVAL_DP_EXIT

WIDVAL_DP_GOLD:					;
	CALL	WID_DRAW_GOLD			; 内容表示 ＧＯＬＤ型
	JMP	WIDVAL_DP_EXIT

WIDVAL_DP_EXIT:					;
	RET
FEND	WWIDVAL_DP


; ****************************************************
;	WINDOWS/内容表示位置変更
;	-I- AX : 内容表示 開始位置Ｘ
;	    DX : 内容表示 描画開始位置
; ****************************************************

FUNC	WWIDVAL_RELOC,WIDVAL_RELOC
	MOV	WIDVAL_SRTX,AX		; 内容表示 開始位置Ｘ
	MOV	WIDVAL_UP,DX		; 内容表示 描画開始位置

	CALL	WIDVAL_SIDE_FREAM	; 内容表示外側フレーム

	CALL	WIDVAL_FLGSET		; 内容表示フラグの更新
	CALL	WIDVAL_ALL		; 内容表示の全表示

	RET
FEND	WWIDVAL_RELOC


; ****************************************************
;	WINDOWS/内容表示位置変更・計算のみ
;	-I- AX : 内容表示 開始位置Ｘ
;	    DX : 内容表示 描画開始位置
; ****************************************************

FUNC	WWIDVAL_CAL,WIDVAL_CAL
	MOV	WIDVAL_SRTX,AX		; 内容表示 開始位置Ｘ
	MOV	WIDVAL_UP,DX		; 内容表示 描画開始位置
	RET
FEND	WWIDVAL_CAL


; ****************************************************
;	WINDOWS/単位別文字列化
;	-I-   WDP_VAL    : 内容表示値
;	      WDP_UNIT   : 内容表示単位系
;	-I/O- DS:[DI]    : 文字列バッファのアドレス
; ****************************************************

FUNC	WWID_UNIT,WID_UNIT
	CALL	WID_UNITS		; 単位別文字列化
	RET
FEND	WWID_UNIT


; ****************************************************
;	WINDOWS/内容表示データＧＥＴ
;	-I- BX    : 内容表示番号
;	-O- ES:BX : テーブルアドレス
;	    SI    : 内容表示 パラメータ名
;	    AX    : 内容表示 内容の型
;	    CX    : 内容表示 内容の単位系
;	    DX    : 内容表示 内容値
; ****************************************************

FUNC	WWIDVAL_DGET,WIDVAL_DGET
	MOV	WDVNO,BX			; 内容表示番号
	CALL	WIDPAR				; テーブル内容取り出し
	MOV	SI,DSP_TORKN			; 内容表示 パラメータ名
	MOV	AX,DSP_TYPE			; 内容表示 内容の型
	MOV	CX,DSP_UNIT			; 内容表示 内容の単位系
	MOV	DX,DSP_VALUE			; 内容表示 内容値
	RET
FEND	WWIDVAL_DGET



;	内容表示外側フレーム

WIDVAL_SIDE_FREAM	PROC	NEAR
	MOVX	WDVNO,WIDVAL_START		; 内容表示 描画開始番号
	CALL	WIDVAL_LOCATE			; 表示位置

	MOVX	WDX1,PR_DSPXX			; Ｘ
	MOVX	WDY1,PR_DSPYY			; Ｙ
	MOVX	WDX2,PR_DSPXX			; 長さ
	MOVX	WDY2,PR_DSPYY			; 高さ

WIDVAL_SIDE_FREAM_LOOP:				;
	MOV	AX,WDVNO			; 内容表示番号
	CMP	AX,WIDMAX_VAL			; 内容表示テーブルレコード数
	JNB	WIDVAL_SIDE_FREAM_LP_E		;

	CALL	WIDVAL_LOCATE			; 表示位置

	CMPX	WDX1,PR_DSPXX			; 表示Ｘ位置
	JBE	WIDVAL_SIDE_FREAM_21		;
	MOVX	WDX1,PR_DSPXX			; 表示Ｘ位置
WIDVAL_SIDE_FREAM_21:				;

	CMPX	WDY1,PR_DSPYY			; 表示Ｙ位置
	JBE	WIDVAL_SIDE_FREAM_22		;
	MOVX	WDY1,PR_DSPYY			; 表示Ｙ位置
WIDVAL_SIDE_FREAM_22:				;

	ADDX	PR_DSPXX,LINE_WIDTH		; ＋内容表示１本の長さ
	ADDX	PR_DSPYY,LINE_HIGHT		; ＋内容表示１本の高さ

	CMPX	WDX2,PR_DSPXX			;
	JNB	WIDVAL_SIDE_FREAM_23		;
	MOVX	WDX2,PR_DSPXX			;
WIDVAL_SIDE_FREAM_23:				;

	CMPX	WDY2,PR_DSPYY			;
	JNB	WIDVAL_SIDE_FREAM_24		;
	MOVX	WDY2,PR_DSPYY			;
WIDVAL_SIDE_FREAM_24:				;

	INC	WDVNO				; 内容表示番号
	JMP	WIDVAL_SIDE_FREAM_LOOP		;
WIDVAL_SIDE_FREAM_LP_E:				;

	SUBX	WDX2,WDX1			;
	SUBX	WDY2,WDY1			;

	SUB	WDX1,1				; Ｘ
	SUB	WDY1,8				; Ｙ
;*;	SUB	WDX2,1				; 長さ
	ADD	WDY2,8*2			; 高さ

	CALLC	WID_4_FLAME			; WINDOWS/フレーム４

	RET
WIDVAL_SIDE_FREAM	ENDP


;	指定の内容値ブリンク
;	-I- WDVNO : 内容表示番号

WIDVAL_BRI	PROC	NEAR
	PUSH	ES
	PUSH	BX

	CALL	WIDVAL_LOCATE			; 表示位置

	CALL	WIDVAL_BK			; 指定の内容値ブリンク

	POP	BX
	POP	ES
	RET
WIDVAL_BRI	ENDP


;	内容表示の全表示
;	-I- WIDVAL_START : 内容表示 描画開始番号
;	    WIDVAL_END   : 内容表示 描画終了番号

WIDVAL_ALL	PROC	NEAR
	PUSH	WDVNO				;

	MOVX	WDVNO,WIDVAL_START		; 内容表示 描画開始番号
WIDVAL_ALL_LOOP:				;
	MOV	AX,WDVNO			; 内容表示番号
	CMP	AX,WIDMAX_VAL			; 内容表示テーブルレコード数
	JNB	WIDVAL_ALL_EXIT			;

	CALL	WIDPAR				; テーブル内容取り出し
	CALL	WIDVAL_DRAW			; 内容値表示

	MOV	AX,WDVNO			; 内容表示番号
	CMP	AX,WIDVAL_END			; 内容表示 描画終了番号
	JE	WIDVAL_ALL_EXIT			;

	INC	WDVNO				; 内容表示番号
	JMP	WIDVAL_ALL_LOOP

WIDVAL_ALL_EXIT:
	POP	WDVNO				;
	RET
WIDVAL_ALL	ENDP



;	内容表示フラグの更新
;	-I- WIDVAL_START : 内容表示 描画開始番号
;	    WIDVAL_END   : 内容表示 描画終了番号

WIDVAL_FLGSET	PROC	NEAR
	MOV	AX,0				; 描画開始番号
	CALL	WIDADR				; テーブルアドレス

	MOV	CX,WIDMAX_VAL			; 内容表示テーブルレコード数
WIDVAL_FLGSET_LOOP:				;
	AND	WORD PTR ES:[BX][VAL_FLAGS],NOT FLAGS_DISP ; フラグ／表示ＯＦＦ
	ADD	BX,VAL_NEXT			; 次の内容表示
	LOOP	WIDVAL_FLGSET_LOOP		;

	MOV	AX,WIDVAL_START			; 内容表示 描画開始番号
	CALL	WIDADR				; テーブルアドレス

	MOV	AX,WIDVAL_START			; 内容表示 描画開始番号
WIDVAL_FLGSET_LOOP2:				;
	OR	WORD PTR ES:[BX][VAL_FLAGS],FLAGS_DISP ; フラグ／表示ＯＮ
	ADD	BX,VAL_NEXT			; 次の内容表示
	INC	AX				;
	CMP	AX,WIDVAL_END			; 内容表示 描画終了番号
	JBE	WIDVAL_FLGSET_LOOP2		;

WIDVAL_FLGSET_EXIT:				;
	RET
WIDVAL_FLGSET	ENDP



;	内容値更新
;	-I- WDVNO : 内容表示番号
;	    ES:BX : テーブルアドレス
;	    DSP_TORKN : 内容表示 パラメータ名
;	    DSP_TYPE  : 内容表示 内容の型
;	    DSP_VALUE : 内容表示 内容値
;	    DSP_VALUE_OLD : 内容表示 前回の内容値
;	    DSP_HELP  : 内容表示 内容説明
;	    DSP_FLAGS : 内容表示 フラグ

WIDVAL_VAL	PROC	NEAR
	PUSH	ES
	PUSH	BX

	CALL	WIDVAL_DRAW			; 内容値表示

	POP	BX
	POP	ES
	RET
WIDVAL_VAL	ENDP



;	内容値表示
;	-I- WDVNO : 内容表示番号
;	    ES:BX : テーブルアドレス
;	    DSP_TORKN : 内容表示 パラメータ名
;	    DSP_TYPE  : 内容表示 内容の型
;	    DSP_VALUE : 内容表示 内容値
;	    DSP_VALUE_OLD : 内容表示 前回の内容値
;	    DSP_HELP  : 内容表示 内容説明
;	    DSP_FLAGS : 内容表示 フラグ

WIDVAL_DRAW	PROC	NEAR
	CALL	WIDVAL_LOCATE			; 表示位置

	CALL	WIDVAL_FLAME			; 内容値表示のフレーム

	MOVX	PR_DSPCLR,W_COL1	; パラメータ名文字表示色
	MOVX	PR_DSPCSZ,0		; パラメータ名内容文字表示サイズ

	CALL	WIDSTRSET			; パラメータ名表示

	CMP	DSP_TYPE,TYPE_VALUE		; 内容表示 ＶＡＬＵＥ型
	JE	WIDVAL_DRAW_VALUE		;
	CMP	DSP_TYPE,TYPE_BLANCE		; 内容表示 ＢＡＬＡＮＣＥ型
	JE	WIDVAL_DRAW_BLANCE		;
	CMP	DSP_TYPE,TYPE_NAME		; 内容表示 ＮＡＭＥ型
	JE	WIDVAL_DRAW_NAME		;
	CMP	DSP_TYPE,TYPE_TIME		; 内容表示 ＴＩＭＥ型
	JE	WIDVAL_DRAW_TIME		;
	CMP	DSP_TYPE,TYPE_GOLD		; 内容表示 ＧＯＬＤ型
	JE	WIDVAL_DRAW_GOLD		;
	JMP	WIDVAL_DRAW_EXIT		;

WIDVAL_DRAW_VALUE:				;
	CALL	WID_DRAW_VALUE			; 内容表示 ＶＡＬＵＥ型
	JMP	WIDVAL_DRAW_EXIT

WIDVAL_DRAW_BLANCE:				;
	CALL	WID_DRAW_BLANCE			; 内容表示 ＢＡＬＡＮＣＥ型
	JMP	WIDVAL_DRAW_EXIT

WIDVAL_DRAW_NAME:				;
	CALL	WID_DRAW_NAME			; 内容表示 ＮＡＭＥ型
	JMP	WIDVAL_DRAW_EXIT

WIDVAL_DRAW_TIME:				;
	CALL	WID_DRAW_TIME			; 内容表示 ＴＩＭＥ型
	JMP	WIDVAL_DRAW_EXIT

WIDVAL_DRAW_GOLD:				;
	CALL	WID_DRAW_GOLD			; 内容表示 ＧＯＬＤ型
	JMP	WIDVAL_DRAW_EXIT

WIDVAL_DRAW_EXIT:
	RET
WIDVAL_DRAW	ENDP



;	内容表示 ＶＡＬＵＥ型
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置
;	    DSP_VALUE : 内容表示 内容値
;	    DSP_VALUE_OLD : 内容表示 前回の内容値
;	    DSP_UNIT : 内容表示 内容の単位系

WID_DRAW_VALUE	PROC	NEAR
	MOVX	PR_DSPUNIT,DSP_UNIT	; 内容表示 内容の単位系
	MOVX	PR_DSPCLR3,W_COL1	; 数値表示色
	MOV	PR_DSPCSZ3,0		; 数値文字表示サイズ
	MOVX	PR_DSPCOL,G_COL1	; グラフカラー
	MOV	PR_DSPWD,4		; メータ表示太さ

	CALL	WIDVAL_MT_CLR		; メータエリアクリア

	MOV	AX,DSP_UNIT		; 内容表示 内容の単位系
	CMP	AX,UNIT_CM		; 単位系 ｃｍ
	JE	WID_DRAW_VALUE_5	;
	CMP	AX,UNIT_KG		; 単位系 ｋｇ
	JE	WID_DRAW_VALUE_5	;

	MOV	AX,DSP_VALUE		; 内容表示 内容値
	CALL	HBER_VALUE_SCALE	; ＶＡＬＵＥ型のスケール
	MOV	PR_DSPVAL,AX		; 内容表示値
	JMP	WID_DRAW_VALUE_6	;
WID_DRAW_VALUE_5:
	MOV	AX,DSP_VALUE		; 内容表示 内容値
	CALL	HBER_VALUE_P_SCALE	; ＶＡＬＵＥ型の固定小数点スケール
	MOV	PR_DSPVAL,AX		; 内容表示値
WID_DRAW_VALUE_6:

	CALL	WIDVAL_SCALA		; スカラーメータ描画

	MOVX	PR_DSPVAL,DSP_VALUE	; 内容表示値
	CALL	WIDVALDSP		; 表示値表示
	RET
WID_DRAW_VALUE	ENDP



;	内容表示 ＢＡＬＡＮＣＥ型
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置
;	    DSP_VALUE : 内容表示 内容値
;	    DSP_VALUE_OLD : 内容表示 前回の内容値
;	    DSP_UNIT : 内容表示 内容の単位系

WID_DRAW_BLANCE	PROC	NEAR
	MOVX	PR_DSPVAL,DSP_VALUE	; 内容表示値
	MOVX	PR_DSPUNIT,DSP_UNIT	; 内容表示 内容の単位系
	MOVX	PR_DSPCLR3,W_COL1	; 数値表示色
	MOV	PR_DSPCSZ3,0		; 数値文字表示サイズ
	MOVX	PR_DSPCOL,G_COL1	; グラフカラー
	MOV	PR_DSPWD,4		; メータ表示太さ

	CALL	WIDVAL_MT_CLR		; メータエリアクリア
	CALL	WIDVALDSP		; 表示値表示

	MOV	AX,DSP_VALUE		; 内容表示 内容値
	CALL	HBER_VALUE_BLANCE	; ＢＡＬＡＮＣＥ型のスケール
	MOV	PR_DSPVAL,AX		; 内容表示値
	CALL	WIDVAL_BALANCE		; バランスメータ描画
	RET
WID_DRAW_BLANCE	ENDP



;	内容表示 ＮＡＭＥ型
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置
;	    DSP_VALUE : 内容表示 内容値
;	    DSP_VALUE_OLD : 内容表示 前回の内容値

WID_DRAW_NAME	PROC	NEAR
	CALL	WIDVAL_PR_CLR		; 文字型エリアクリア

	MOVX	PR_DSPCLR2,W_COL1	; 内容文字表示色
	MOV	PR_DSPCSZ2,0		; 内容文字表示サイズ

	MOVX	PR_DSPVAL,DSP_VALUE	; 内容表示値

	CALL	WIDVAL_STRINGS		; 文字列の表示

	RET
WID_DRAW_NAME	ENDP



;	内容表示 ＴＩＭＥ型
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置
;	    DSP_VALUE : 内容表示 内容値
;	    DSP_VALUE_OLD : 内容表示 前回の内容値

WID_DRAW_TIME	PROC	NEAR
	CALL	WIDVAL_PR_CLR		; 文字型エリアクリア

	MOVX	PR_DSPCLR2,W_COL1	; 内容文字表示色
	MOV	PR_DSPCSZ2,0		; 内容文字表示サイズ

	MOVX	PR_DSPVAL,DSP_VALUE	; 内容表示値

	CALL	WIDVAL_TIME		; 時の表示
	RET
WID_DRAW_TIME	ENDP



;	内容表示 ＧＯＬＤ型
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置
;	    DSP_VALUE : 内容表示 内容値
;	    DSP_VALUE_OLD : 内容表示 前回の内容値

WID_DRAW_GOLD	PROC	NEAR
	MOVX	PR_DSPVAL,DSP_VALUE	; 内容表示値
	MOVX	PR_DSPUNIT,DSP_UNIT	; 内容表示 内容の単位系
	MOVX	PR_DSPCLR3,W_COL1	; 数値表示色
	MOV	PR_DSPCSZ3,0		; 数値文字表示サイズ
	MOVX	PR_DSPCOL,G_COL1	; グラフカラー
	MOV	PR_DSPWD,4		; メータ表示太さ

	CALL	WIDVAL_MT_CLR		; メータエリアクリア

	MOV	AX,DSP_VALUE		; 内容表示 内容値
	CALL	HBER_VALUE_GOLD		; ＧＯＬＤ型のスケール
	MOV	PR_DSPVAL,AX		; 内容表示値
	CALL	WIDVAL_SCALA		; スカラーメータ描画

	MOVX	PR_DSPVAL,DSP_VALUE	; 内容表示値

	CALL	WIDVALDSP		; 表示値表示
;**;	CALL	WIDVAL_WIDE		; 表示値ワイド表示
	RET
WID_DRAW_GOLD	ENDP



;	テーブル内容取り出し
;	-I- WDVNO : 内容表示番号
;	-O- ES:BX : テーブルアドレス
;	    DSP_TORKN : 内容表示 パラメータ名
;	    DSP_TYPE  : 内容表示 内容の型
;	    DSP_VALUE : 内容表示 内容値
;	    DSP_VALUE_OLD : 内容表示 前回の内容値
;	    DSP_HELP  : 内容表示 内容説明
;	    DSP_FLAGS : 内容表示 フラグ

WIDPAR	PROC	NEAR
	MOV	AX,WDVNO			; 内容表示番号
	CALL	WIDADR				; テーブルアドレス

	MOVX	DSP_TORKN, ES:[BX][VAL_TORKN]	; 内容表示 パラメータ名
	MOVX	DSP_TYPE , ES:[BX][VAL_TYPE]	; 内容表示 内容の型
	MOVX	DSP_UNIT , ES:[BX][VAL_UNIT]	; 内容表示 内容の単位系
	MOVX	DSP_VALUE, ES:[BX][VAL_VALUE]	; 内容表示 内容値
	MOVX	DSP_VALUE_OLD,ES:[BX][VAL_VALUE_OLD] ; 内容表示 前回の内容値
	MOVX	DSP_HELP,  ES:[BX][VAL_HELP]	; 内容表示 内容説明
	MOVX	DSP_FLAGS, ES:[BX][VAL_FLAGS]	; 内容表示 フラグ

	RET
WIDPAR	ENDP


;	テーブルアドレス
;	-I- AX    : 横グラフ番号
;	-O- ES:BX : テーブルアドレス

WIDADR	PROC	NEAR
	MOV	BX,VAL_NEXT		; 次の内容表示
	MUL	BL			; AX=AX*BL
	MOV	BX,AX			;
	ADD	BX,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	RET
WIDADR	ENDP


;	表示位置
;	-I- WDVNO : 内容表示番号
;	-O- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置

WIDVAL_LOCATE	PROC	NEAR
	MOV	AX,WDVNO		; 内容表示番号
	CWD				;
	MOV	BX,WIDVAL_CNTX		; 内容表示 Ｘ並び数
	DIV	BX			; DX=Ｘ位置,AX=Ｙ位置

	PUSH	AX			;

	MOV	AX,DX			; DX=Ｘ位置
	MOV	BX,LINE_WIDTH		; 内容表示１本の長さ
	MUL	BX			;
	ADD	AX,W_CLM0		; カラム・先頭
	MOV	PR_DSPXX,AX		; 表示Ｘ位置

	MOV	AX,WIDVAL_UP		; 内容表示 描画開始位置
	MOV	CX,LOCATE_HIGHT		; 表示ライン１本の高さ
	MUL	CL			;
	MOV	PR_DSPYY,AX		; 表示Ｙ位置

	POP	AX			;

					; AX=Ｙ位置
	MOV	BX,LINE_HIGHT		; 内容表示１本の高さ
	MUL	BX			;
	ADD	PR_DSPYY,AX		; 表示Ｙ位置

	ADDX	PR_DSPXX,WIDVAL_SRTX	; 内容表示 開始位置Ｘ
	ADDX	PR_DSPYY,WIDVAL_SRTY	; 内容表示 開始位置Ｙ
	RET
WIDVAL_LOCATE	ENDP



;	内容値表示のフレーム
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置

WIDVAL_FLAME	PROC	NEAR
	CALL	WIDVAL_CLR		; 表示エリアクリア

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	VX1,AX			;
	ADD	AX,LINE_WIDTH		; 内容表示１本の長さ
	DEC	AX			;
	SUB	AX,2			; －２
	MOV	VX2,AX			;

	MOV	AX,PR_DSPYY		; 表示Ｙ位置
	MOV	VY1,AX			;
	ADD	AX,LINE_HIGHT		; 内容表示１本の高さ
	DEC	AX			;
	MOV	VY2,AX			;
	MOV	CX,W_COL5		; WINDOWS/カラー・暗い色
	CALLC	BOXPAL			; ＢＯＸペイント
	MOV	CX,1			;
	CALLC	BOXMSS			; ＢＯＸメッシュ

	MOV	AX,VY1			;
	MOV	VY2,AX			;
	MOV	CX,0			;
	CALLC	BOXPAL			; ＢＯＸペイント
	RET
WIDVAL_FLAME	ENDP



;	パラメータ名表示
;	-I- WDVNO     : 内容表示番号
;	    DSP_TORKN : 内容表示 パラメータ名
;	    PR_DSPXX  : 内容表示Ｘ位置
;	    PR_DSPYY  : 内容表示Ｙ位置
;	    PR_DSPCLR : パラメータ名文字表示色
;	    PR_DSPCSZ : パラメータ名内容文字表示サイズ

WIDSTRSET	PROC	NEAR
	CALLC	STRCLEAR		; 文字列バッファクリア

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ

;*NON*;	MOV	DX,WDVNO		; 内容表示番号
;*NON*;	CALLC	DECSTR			; dec -> string.
;*NON*;	MOV	AX,DS:[SI][3]		;
;*NON*;	MOV	DS:[DI],AX		;
;*NON*;
;*NON*;	ADD	DI,3			;

	MOV	SI,DSP_TORKN		; 内容表示 パラメータ名
	MOV	CX,WIDNAMELEN		; グラフ名前最大長さ
	CALLC	STRSET			; 文字列バッファセット

	ADD	DI,WIDPRNMLEN		; 内容表示パラメータ名最大長さ
	ADD	DI,1			;
	MOV	DS:[DI],WORD PTR 0	;

	MOV	AX,PR_DSPCSZ		; パラメータ名内容文字表示サイズ
	CALLC	VTXSIZ			; character size set.

	MOV	AX,PR_DSPCLR		; パラメータ名文字表示色
	CALLC	VTXCOL			; character color set.

	MOV	AX,PR_DSPXX		; 内容表示Ｘ位置
	MOV	BX,PR_DSPYY		; 内容表示Ｙ位置
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	VTXPOR			; vram text print OR.

	RET
WIDSTRSET	ENDP



;	表示値表示
;	-I- PR_DSPVAL : 内容表示値
;	    PR_DSPXX  : 表示Ｘ位置
;	    PR_DSPYY  : 表示Ｙ位置
;	    PR_DSPCLR3: 数値表示色
;	    PR_DSPCSZ3: 数値文字表示サイズ
;	    PR_DSPUNIT: 内容表示 内容の単位系

WIDVALDSP	PROC	NEAR
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ

	CALL	WIDVAL_UNIT		; 単位別文字列化

	MOVX	ES,DS			;
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRLENSPZ		; 文字列長さスペースまで
	MOV	VLEN,CX			; 文字長さ

;*NON*;	MOV	AX,PR_DSPCSZ3		; 数値文字表示サイズ
;*NON*;	CALLC	VTXSIZ			; character size set.
;*NON*;
;*NON*;	MOV	AX,PR_DSPCLR3		; 数値表示色
;*NON*;	CALLC	VTXCOL			; character color set.

	MOV	AX,PR_DSPCLR3		; 内容文字表示色
	CALLC	MITCOL			; mini string color.

	MOV	AX,PR_DSPUNIT		; 内容表示 単位系
	CMP	AX,UNIT_ARGE		; 単位系 年齢
	JE	WIDVALDSP_ZEN		;


WIDVALDSP_HAN:
	CMP	VLEN,6			; 文字長さ
	JNB	WIDVALDSP_HAN6KETA	;
	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,W_CLM1		; カラム・表示値
	JMP	WIDVALDSP_HANPRN	;
WIDVALDSP_HAN6KETA:
	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,W_CLM1		; カラム・表示値
	DEC	AX			; -1
WIDVALDSP_HANPRN:
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	MDTPRN			; MID string. (null=end of string)
	JMP	WIDVALDSP_EXIT		;
WIDVALDSP_ZEN:
	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,W_CLM1		; カラム・表示値
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	MBTPRN			; BIG string. (null=end of string)
	JMP	WIDVALDSP_EXIT		;
WIDVALDSP_EXIT:
	RET
WIDVALDSP	ENDP




;	時の表示
;	-I- ES:BX : テーブルアドレス
;	    PR_DSPVAL : 内容表示値（文字列のアドレス）
;	    PR_DSPXX  : 表示Ｘ位置
;	    PR_DSPYY  : 表示Ｙ位置
;	    PR_DSPCLR2: 内容文字表示色
;	    PR_DSPCSZ2: 内容文字表示サイズ

WIDVAL_TIME	PROC	NEAR
	PUSH	ES			;
	PUSH	BX			;

	CALLC	STRCLEAR		; 文字列バッファクリア

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ

	MOV	SI,PR_DSPVAL		; 内容表示値（文字列のアドレス）
	MOV	CX,WIDTYP_NM_LEN	; 内容表示ＮＡＭＥ型最大長さ
	CALLC	STRSET			; 文字列バッファセット

	ADD	DI,WIDTYP_NM_LEN	; 内容表示ＮＡＭＥ型最大長さ
	ADD	DI,1			;
	MOV	DS:[DI],WORD PTR 0	;

;*;	MOV	AX,PR_DSPCSZ2		; 内容文字表示サイズ
;*;	CALLC	VTXSIZ			; character size set.
;*;
;*;	MOV	AX,PR_DSPCLR2		; 内容文字表示色
;*;	CALLC	VTXCOL			; character color set.

	MOV	AX,PR_DSPCLR2		; 内容文字表示色
	CALLC	MITCOL			; mini string color.

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,W_CLM1		; カラム・表示値
	INC	AX			;
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	MDTPRN			; MID string. (null=end of string)
;*NON*;	CALLC	VTXPOR			; vram text print OR.

	POP	BX			;
	POP	ES			;
	RET
WIDVAL_TIME	ENDP



;*NON*;;	表示値ワイド表示
;*NON*;;	-I- PR_DSPVAL : 内容表示値
;*NON*;;	    PR_DSPXX  : 表示Ｘ位置
;*NON*;;	    PR_DSPYY  : 表示Ｙ位置
;*NON*;
;*NON*;WIDVAL_WIDE	PROC	NEAR
;*NON*;	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*NON*;
;*NON*;	MOV	DX,PR_DSPVAL		; 内容表示値
;*NON*;	CALLC	DECSTR			; dec -> string.
;*NON*;	MOV	AX,DS:[SI]		;
;*NON*;	MOV	BX,DS:[SI][2]		;
;*NON*;	MOV	CL,DS:[SI][4]		;
;*NON*;	MOV	DS:[DI],AX		;
;*NON*;	MOV	DS:[DI][2],BX		;
;*NON*;	MOV	DS:[DI][4],CL		;
;*NON*;	MOV	DS:[DI][5],BYTE PTR 0	; 5ｹﾀ
;*NON*;
;*NON*;	MOV	AX,PR_DSPXX		; 表示Ｘ位置
;*NON*;	ADD	AX,9			; ｶﾗﾑ9
;*NON*;	MOV	BX,PR_DSPYY		; 表示Ｙ位置
;*NON*;	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*NON*;	CALLC	MWTPRN			; WIDE string.
;*NON*;	RET
;*NON*;WIDVAL_WIDE	ENDP



;	文字列の表示
;	-I- PR_DSPVAL : 内容表示値（文字列のアドレス）
;	    PR_DSPXX  : 表示Ｘ位置
;	    PR_DSPYY  : 表示Ｙ位置
;	    PR_DSPCLR2: 内容文字表示色
;	    PR_DSPCSZ2: 内容文字表示サイズ

WIDVAL_STRINGS	PROC	NEAR
	PUSH	ES			;
	PUSH	BX			;

	CALLC	STRCLEAR		; 文字列バッファクリア

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ

	MOV	SI,PR_DSPVAL		; 内容表示値（文字列のアドレス）
	MOV	CX,WIDTYP_NM_LEN	; 内容表示ＮＡＭＥ型最大長さ
	CALLC	STRSET			; 文字列バッファセット

	ADD	DI,WIDTYP_NM_LEN	; 内容表示ＮＡＭＥ型最大長さ
	ADD	DI,1			;
	MOV	DS:[DI],WORD PTR 0	;

	MOV	AX,PR_DSPCSZ2		; 内容文字表示サイズ
	CALLC	VTXSIZ			; character size set.

	MOV	AX,PR_DSPCLR2		; 内容文字表示色
	CALLC	VTXCOL			; character color set.

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,W_CLM1		; カラム・表示値
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	VTXPOR			; vram text print OR.

	POP	BX			;
	POP	ES			;
	RET
WIDVAL_STRINGS	ENDP



;	スカラーメータ描画
;	-I- PR_DSPVAL : 内容表示値
;	    PR_DSPXX  : 表示Ｘ位置
;	    PR_DSPYY  : 表示Ｙ位置
;	    PR_DSPCOL : メータ表示色
;	    PR_DSPWD  : メータ表示太さ

WIDVAL_SCALA	PROC	NEAR
	PUSH	ES			;
	PUSH	BX			;

	CALL	FRM_SCL_VALUE		; フレーム・数値スケール

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX1,AX			; 表示Ｘ位置

	CALL	WIDVAL_U_SC		; 単位別表示スカラー値変換
	ADD	AX,VX1			; 表示Ｘ位置
	MOV	VX2,AX			;

	MOV	AX,PR_DSPYY		; 表示Ｙ位置
	ADD	AX,6			;
	MOV	VY1,AX			;

	MOV	CX,PR_DSPWD		; メータ表示太さ

	MOV	AX,PR_DSPCOL		; メータ表示色
	MOV	VCOL,AX			;

	MOV	AX,W_CLM2		; カラム・グラフ
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	ADD	VX1,AX			;
	ADD	VX2,AX			;

	CALLC	DLINEH			; 水平ライン描画
	MOVX	VCOL,G_COL4		; グラフ影カラー
	MOV	CX,1			;
	CALLC	DLINEH			; 水平ライン描画

	MOV	AX,VX2
	SUB	AX,VX1
	CMP	AX,5
	JLE	WIDVAL_SCALA_6
	MOV	VX2,5
	ADDX	VX2,VX1
WIDVAL_SCALA_6:
	MOV	CX,PR_DSPWD		; メータ表示太さ
	MOVX	VCOL,G_COL4		; グラフ影カラー
	CALLC	DLINEH			; 水平ライン描画

	POP	BX			;
	POP	ES			;
	RET
WIDVAL_SCALA	ENDP


;	バランスメータ描画
;	-I- PR_DSPVAL : 内容表示値
;	    PR_DSPXX  : 表示Ｘ位置
;	    PR_DSPYY  : 表示Ｙ位置
;	    PR_DSPCOL : メータ表示色
;	    PR_DSPWD  : メータ表示太さ

WIDVAL_BALANCE	PROC	NEAR
	PUSH	ES			;
	PUSH	BX			;

	CALL	FRM_SCL_BALANCE		; フレーム・バランススケール



	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX1,AX			; 表示Ｘ位置

	MOV	AX,PR_DSPVAL		; 内容表示値
	ADD	AX,VX1			; 表示Ｘ位置
	MOV	VX2,AX			;

	MOV	AX,PR_DSPYY		; 表示Ｙ位置
	ADD	AX,6			;
	MOV	VY1,AX			;

	MOV	CX,PR_DSPWD		; メータ表示太さ

	MOV	AX,PR_DSPCOL		; メータ表示色
	MOV	VCOL,AX			;

	MOV	AX,W_CLM2		; カラム・グラフ
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	ADD	VX1,AX			;
	ADD	VX2,AX			;

	CALLC	DLINEH			; 水平ライン描画


	; 影・中央

	PUSH	VX1
	PUSH	VY1
	PUSH	VX2
	PUSH	VY2

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,W_CLM3		; カラム・バランス
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	CMP	AX,VX2			;
	JB	WIDVAL_BALANCE_3	;
	JMP	WIDVAL_BALANCE_5	;
WIDVAL_BALANCE_3:			;

	MOV	VX1,AX
	MOV	AX,VX2
	SUB	AX,VX1
	CMP	AX,5+2
	JLE	WIDVAL_BALANCE_4
	MOV	VX2,5+2
	ADDX	VX2,VX1
WIDVAL_BALANCE_4:
	MOV	CX,PR_DSPWD		; メータ表示太さ
	MOVX	VCOL,G_COL4		; グラフ影カラー
	CALLC	DLINEH			; 水平ライン描画

WIDVAL_BALANCE_5:

	POP	VY2
	POP	VX2
	POP	VY1
	POP	VX1

	; 影・左端

	MOVX	VCOL,G_COL4		; グラフ影カラー
	MOV	CX,1			;
	CALLC	DLINEH			; 水平ライン描画

	MOV	AX,VX2
	SUB	AX,VX1
	CMP	AX,5
	JLE	WIDVAL_BALANCE_6
	MOV	VX2,5
	ADDX	VX2,VX1
WIDVAL_BALANCE_6:
	MOV	CX,PR_DSPWD		; メータ表示太さ
	MOVX	VCOL,G_COL4		; グラフ影カラー
	CALLC	DLINEH			; 水平ライン描画


	; 中央柱

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,W_CLM3		; カラム・バランス
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX1,AX			; 表示Ｘ位置
	MOV	AX,PR_DSPYY		; 表示Ｙ位置
	MOV	VY1,AX			; 表示Ｙ位置
	ADD	AX,LINE_HIGHT		; 内容表示１本の高さ
	DEC	AX			;
	DEC	AX			;
	MOV	VY2,AX			; end line point y2.

	MOVX	VCOL,W_COL3		; WINDOWS/カラー・暗い灰
	MOV	CX,1			; line width.
	CALLC	DLINEV			; 垂直ライン描画
	INC	VX1			; 表示Ｘ位置
	MOVX	VCOL,W_COL2		; WINDOWS/カラー・明るい灰
	MOV	CX,1			; line width.
	CALLC	DLINEV			; 垂直ライン描画
	INC	VX1			; 表示Ｘ位置
	MOVX	VCOL,W_COL3		; WINDOWS/カラー・暗い灰
	MOV	CX,1			; line width.
	CALLC	DLINEV			; 垂直ライン描画

	POP	BX			;
	POP	ES			;
	RET
WIDVAL_BALANCE	ENDP


;	フレーム・数値スケール
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置

FRM_SCL_VALUE	PROC	NEAR
	MOV	AX,PR_DSPXX			; 表示Ｘ位置
	ADD	AX,W_CLM2			; カラム・グラフ
	MOV	BX,PR_DSPYY			; 表示Ｙ位置
	CALLC	PT_PUT_VALUE			; 数値表示ＰＵＴ
	RET
FRM_SCL_VALUE	ENDP


;	フレーム・バランススケール
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置

FRM_SCL_BALANCE		PROC	NEAR
	MOV	AX,PR_DSPXX			; 表示Ｘ位置
	ADD	AX,W_CLM2			; カラム・グラフ
	MOV	BX,PR_DSPYY			; 表示Ｙ位置
	CALLC	PT_PUT_VALBALANCE		; 数値バランス表示ＰＵＴ
	RET
FRM_SCL_BALANCE		ENDP



;	表示エリアクリア
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置

WIDVAL_CLR	PROC	NEAR
	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	VX1,AX			;
	ADD	AX,LINE_WIDTH		; 内容表示１本の長さ
	DEC	AX			;
	SUB	AX,2			; －２
	MOV	VX2,AX			;

	MOV	AX,PR_DSPYY		; 表示Ｙ位置
	MOV	VY1,AX			;
	ADD	AX,LINE_HIGHT		; 内容表示１本の高さ
	DEC	AX			;
	MOV	VY2,AX			;
	MOV	CX,0000B		;
	CALLC	BOXPAL			; ＢＯＸペイント

	RET
WIDVAL_CLR	ENDP


;	文字型エリアクリア
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置

WIDVAL_PR_CLR	PROC	NEAR
	PUSH	ES
	PUSH	BX

	MOVX	VX1,PR_DSPXX		; 表示Ｘ位置
	ADDX	VX1,W_CLM1		; カラム・表示値

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,LINE_WIDTH		; 内容表示１本の長さ
	DEC	AX			;
	SUB	AX,2			; －２
	MOV	VX2,AX			;

	MOV	AX,PR_DSPYY		; 表示Ｙ位置
	MOV	VY1,AX			;
	ADD	AX,LINE_HIGHT		; 内容表示１本の高さ
	DEC	AX			;
	MOV	VY2,AX			;

	MOV	CX,W_COL5		; WINDOWS/カラー・暗い色
	CALLC	BOXPAL			; ＢＯＸペイント

	MOV	CX,0			;
	CALLC	BOXMSS			; ＢＯＸメッシュ

	MOV	AX,VY1			;
	MOV	VY2,AX			;
	MOV	CX,0			;
	CALLC	BOXPAL			; ＢＯＸペイント

	POP	BX
	POP	ES
	RET
WIDVAL_PR_CLR	ENDP


;	メータエリアクリア
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置

WIDVAL_MT_CLR	PROC	NEAR
	PUSH	ES
	PUSH	BX

	MOV	AX,PR_DSPYY		; 表示Ｙ位置
	MOV	VY1,AX			;
	ADD	AX,LINE_HIGHT		; 内容表示１本の高さ
	DEC	AX			;
	MOV	VY2,AX			;

	MOVX	VX1,PR_DSPXX		; 表示Ｘ位置
	ADDX	VX1,W_CLM1		; カラム・表示値

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,LINE_WIDTH		; 内容表示１本の長さ
	DEC	AX			;
	SUB	AX,2			; －２
	MOV	VX2,AX			;

	MOV	CX,W_COL5		; WINDOWS/カラー・暗い色
	CALLC	BOXPAL			; ＢＯＸペイント

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	VX1,AX			;
	MOV	VX2,AX			;

	ADDX	VX1,W_CLM1		; カラム・表示値
	ADDX	VX2,W_CLM2		; カラム・グラフ
	DEC	VX2			;

	MOV	CX,0			;
	CALLC	BOXPAL			; ＢＯＸペイント


	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	VX1,AX			;
	ADDX	VX1,W_CLM2		; カラム・グラフ

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	ADD	AX,LINE_WIDTH		; 内容表示１本の長さ
	DEC	AX			;
	SUB	AX,2			; －２
	MOV	VX2,AX			;

	MOV	CX,0			;
	CALLC	BOXMSS			; ＢＯＸメッシュ

	MOV	AX,VY1			;
	MOV	VY2,AX			;
	MOV	CX,0			;
	CALLC	BOXPAL			; ＢＯＸペイント

	POP	BX
	POP	ES
	RET
WIDVAL_MT_CLR	ENDP


;	ＶＡＬＵＥ型の固定小数点スケール
;	-I/O- AX : 内容表示値

HBER_VALUE_P_SCALE	PROC	NEAR
	MOV	DX,0		;
	MOV	BX,20		; AX = AX / 20
	DIV	BX		;
	RET
HBER_VALUE_P_SCALE	ENDP


;	ＶＡＬＵＥ型のスケール
;	-I/O- AX : 内容表示値

HBER_VALUE_SCALE	PROC	NEAR
	MOV	DX,0		;
	MOV	BX,2		; AX = AX / 2
	DIV	BX		;
	RET
HBER_VALUE_SCALE	ENDP


;	ＢＡＬＡＮＣＥ型のスケール
;	１００を中点とする ０から２００
;
;	-I/O- AX : 内容表示値

HBER_VALUE_BLANCE	PROC	NEAR
	SHR	AX,1		; AX = AX / 2
	SUB	AX,10		; AX = AX - 10
	RET
HBER_VALUE_BLANCE	ENDP


;	ＧＯＬＤ型のスケール
;	-I/O- AX : 内容表示値

HBER_VALUE_GOLD	PROC	NEAR
	CMP	AX,1000			; 内容表示値
	JNB	HBER_VALUE_GOLD_1000	; 1000以上

	MOV	DX,0			;
	MOV	BX,25			; AX = AX / 25
	DIV	BX			;
	JMP	HBER_VALUE_GOLD_EE	; メータ４０まで

HBER_VALUE_GOLD_1000:			;
	MOV	DX,0			;
	MOV	BX,200			; AX = AX / 100
	DIV	BX			;
	ADD	AX,40-10		; メータ４０から８０まで
HBER_VALUE_GOLD_EE:
	CMP	AX,GR_LENGTH		; グラフ限界長さ
	JB	HBER_VALUE_GOLD_EXIT	;
	MOV	AX,GR_LENGTH		; グラフ限界長さ
HBER_VALUE_GOLD_EXIT:
	RET
HBER_VALUE_GOLD	ENDP



;	横グラフブリンク
;	タイマ１使用
;	-I- PR_DSPXX : 表示Ｘ位置
;	    PR_DSPYY : 表示Ｙ位置

WIDVAL_BK	PROC	NEAR
	PUSH	ES			;
	PUSH	BX			;

	MOV	CX,4			;
WIDVAL_BK_LOOP:				;
	PUSH	CX			;
	MOV	AX,5			; wait timer count.
	CALLC	TMVSET			; V-SYNC timer set.
	MOVX	VX1,PR_DSPXX		; 表示Ｘ位置
	MOVX	VX2,PR_DSPXX		; 表示Ｘ位置
	ADDX	VX2,LINE_WIDTH		; 内容表示１本の長さ
	SUB	VX2,3			;
	MOV	AX,PR_DSPYY		; 表示Ｙ位置
	INC	AX			;
	MOV	VY1,AX			;
	ADD	AX,LINE_HIGHT		; 内容表示１本の高さ
	DEC	AX			;
	DEC	AX			;
	MOV	VY2,AX			;
	MOV	CX,1111B		;
	CALLC	BOXNOT			; ＢＯＸ反転
	CALLC	TMVEWT			; V-SYNC timer end wait.
	POP	CX			;
	LOOP	WIDVAL_BK_LOOP		;

	POP	BX			;
	POP	ES			;
	RET
WIDVAL_BK	ENDP


;	単位別文字列化
;	-I-   PR_DSPVAL  : 内容表示値
;	      PR_DSPUNIT : 内容表示 単位系
;	-I/O- DS:[DI]    : 文字列バッファのアドレス

WIDVAL_UNIT	PROC	NEAR
	MOVX	WDP_VAL,PR_DSPVAL	; 内容表示値
	MOVX	WDP_UNIT,PR_DSPUNIT	; 内容表示 単位系
	CALL	WID_UNITS		; 単位別文字列化
	RET
WIDVAL_UNIT	ENDP


;	WINDOWS/単位別文字列化
;	-I-   WDP_VAL    : 内容表示値
;	      WDP_UNIT   : 内容表示単位系
;	-I/O- DS:[DI]    : 文字列バッファのアドレス

WID_UNITS	PROC	NEAR
	MOV	DX,WDP_VAL		; 内容表示値
	CALLC	DECSTR			; dec -> string.
	MOV	AX,DS:[SI]		;
	MOV	BX,DS:[SI][2]		;
	MOV	CL,DS:[SI][4]		;
	MOV	DS:[DI],AX		;
	MOV	DS:[DI][2],BX		;
	MOV	DS:[DI][4],CL		;
	MOV	DS:[DI][5],BYTE PTR 0	; 5ｹﾀ

	MOV	AX,WDP_UNIT		; 内容表示単位系

	CMP	AX,UNIT_NONE		; 単位系 無し
	JE	WID_UNIT_NONE		;

	CMP	AX,UNIT_ARGE		; 単位系 年齢
	JE	WID_UNIT_ARGE		;

	CMP	AX,UNIT_CM		; 単位系 ｃｍ
	JE	WID_UNIT_CM		;

	CMP	AX,UNIT_KG		; 単位系 ｋｇ
	JMPEQ	WID_UNIT_KG		;

	CMP	AX,UNIT_PAR		; 単位系 ％
	JMPEQ	WID_UNIT_PAR		;

	CMP	AX,UNIT_GOLD		; 単位系 通貨
	JMPEQ	WID_UNIT_GOLD		;

	JMP	WID_UNIT_EXIT		;

WID_UNIT_NONE:				; 単位系 無し
	MOV	DX,WDP_VAL		; 内容表示値
	CALLC	SIGSTR			; signed val DX to dec string.
	MOV	AX,DS:[SI]		;
	MOV	BX,DS:[SI][2]		;
	MOV	CX,DS:[SI][4]		;
	MOV	DS:[DI],AX		;
	MOV	DS:[DI][2],BX		;
	MOV	DS:[DI][4],CX		;
	MOV	DS:[DI][6],BYTE PTR 0	; 6ｹﾀ
	JMP	WID_UNIT_EXIT		;
WID_UNIT_ARGE:				; 単位系 年齢
	CMP	PR_DSPVAL,100		; 内容表示値
	JNB	WID_UNIT_ARGE2		;

	MOV	AX,DS:[DI][3]		;
	MOV	DS:[DI],AX		;
	MOV	DS:[DI][2],BYTE PTR 0	; 2ｹﾀ
	MOV	SI,DI			;
	CALLC	STRZTS			; zero to space.
	JMP	WID_UNIT_EXIT		;

WID_UNIT_ARGE2:				; 単位系 年齢１００以上
	MOV	AX,DS:[DI][2]		;
	MOV	BL,DS:[DI][4]		;
	MOV	DS:[DI],AX		;
	MOV	DS:[DI][2],BL		;
	MOV	DS:[DI][3],BYTE PTR 0	; 2ｹﾀ
	MOV	SI,DI			;
	CALLC	STRZTS			; zero to space.
	JMP	WID_UNIT_EXIT		;

WID_UNIT_CM:				; 単位系 ｃｍ
	MOV	AX,DS:[DI][1]		;
	MOV	BH,DS:[DI][3]		;
	MOV	BL,DS:[DI][4]		;
	MOV	DS:[DI],AX		;
	MOV	DS:[DI][2],BH		;
	MOV	DS:[DI][3],BYTE PTR '.'	;
	MOV	DS:[DI][4],BL		;
	MOV	DS:[DI][5],BYTE PTR 0	;
;*;	MOV	DS:[DI][5],BYTE PTR 'c'	; 1234567
;*;	MOV	DS:[DI][6],BYTE PTR 'm'	; 999.9cm
;*;	MOV	DS:[DI][7],BYTE PTR 0	;
	MOV	SI,DI			;
	CALLC	STRZTS			; zero to space.
	JMP	WID_UNIT_EXIT		;
WID_UNIT_KG:				; 単位系 ｋｇ
	MOV	AX,DS:[DI][1]		;
	MOV	BH,DS:[DI][3]		;
	MOV	BL,DS:[DI][4]		;
	MOV	DS:[DI],AX		;
	MOV	DS:[DI][2],BH		;
	MOV	DS:[DI][3],BYTE PTR '.'	;
	MOV	DS:[DI][4],BL		;
	MOV	DS:[DI][5],BYTE PTR 0	;
;*;	MOV	DS:[DI][5],BYTE PTR 'k'	; 1234567
;*;	MOV	DS:[DI][6],BYTE PTR 'g'	; 999.9kg
;*;	MOV	DS:[DI][7],BYTE PTR 0	;
	MOV	SI,DI			;
	CALLC	STRZTS			; zero to space.
	JMP	WID_UNIT_EXIT		;
WID_UNIT_PAR:				; 単位系 ％
	MOV	AX,DS:[DI][1]		;
	MOV	BX,DS:[DI][3]		;
	MOV	DS:[DI],AX		;
	MOV	DS:[DI][2],BX		;
	MOV	DS:[DI][4],BYTE PTR '%'	; 12345
;*;	MOV	DS:[DI],BYTE PTR ' '	; _999%
	MOV	SI,DI			;
	CALLC	STRZTS			; zero to space.
	JMP	WID_UNIT_EXIT		;
WID_UNIT_GOLD:				; 単位系 通貨
	MOV	AX,DS:[SI]		;
	MOV	BX,DS:[SI][2]		;
	MOV	CL,DS:[SI][4]		;
	MOV	DS:[DI],BYTE PTR '$'	;
	MOV	DS:[DI][1],AX		;
	MOV	DS:[DI][3],BX		;
	MOV	DS:[DI][5],CL		;
	MOV	DS:[DI][6],BYTE PTR 0	; 5ｹﾀ
	MOV	SI,DI			;
	INC	SI			;
	CALLC	STRZTS			; zero to space.
	CALLC	STRSPL			; space pless. "  123" - > "123  "
	JMP	WID_UNIT_EXIT		;
WID_UNIT_EXIT:
	RET
WID_UNITS	ENDP



;	単位別表示スカラー値変換
;	-I-   PR_DSPVAL  : 内容表示値
;	      PR_DSPUNIT : 内容表示 単位系
;	-O-   AX         : 内容表示値

WIDVAL_U_SC	PROC	NEAR
	MOV	AX,PR_DSPUNIT		; 内容表示 単位系

	CMP	AX,UNIT_NONE		; 単位系 無し
	JE	WIDVAL_U_SC_NONE	;

	CMP	AX,UNIT_ARGE		; 単位系 年齢
	JE	WIDVAL_U_SC_ARGE	;

	CMP	AX,UNIT_CM		; 単位系 ｃｍ
	JE	WIDVAL_U_SC_CM		;

	CMP	AX,UNIT_KG		; 単位系 ｋｇ
	JE	WIDVAL_U_SC_KG		;

	CMP	AX,UNIT_PAR		; 単位系 ％
	JE	WIDVAL_U_SC_PAR		;

	CMP	AX,UNIT_GOLD		; 単位系 通貨
	JE	WIDVAL_U_SC_GOLD	;


	MOV	AX,PR_DSPVAL		; 内容表示値
	JMP	WIDVAL_U_SC_EXIT	;
WIDVAL_U_SC_NONE:			; 単位系 無し
	MOV	AX,PR_DSPVAL		; 内容表示値
	JMP	WIDVAL_U_SC_EXIT	;
WIDVAL_U_SC_ARGE:			; 単位系 年齢
	MOV	AX,PR_DSPVAL		; 内容表示値
	SHL	AX,1			; * 2
	JMP	WIDVAL_U_SC_EXIT	;
WIDVAL_U_SC_CM:				; 単位系 ｃｍ
	MOV	AX,PR_DSPVAL		; 内容表示値
	SHR	AX,1			; / 2
	JMP	WIDVAL_U_SC_EXIT	;
WIDVAL_U_SC_KG:				; 単位系 ｋｇ
	MOV	AX,PR_DSPVAL		; 内容表示値
	JMP	WIDVAL_U_SC_EXIT	;
WIDVAL_U_SC_PAR:			; 単位系 ％
	MOV	AX,PR_DSPVAL		; 内容表示値
	JMP	WIDVAL_U_SC_EXIT	;
WIDVAL_U_SC_GOLD:			; 単位系 通貨
	MOV	AX,PR_DSPVAL		; 内容表示値
	JMP	WIDVAL_U_SC_EXIT	;
WIDVAL_U_SC_EXIT:
	CMP	AX,GR_LENGTH		; グラフ限界長さ
	JBE	WIDVAL_U_SC_EEE		;
	MOV	AX,GR_LENGTH		; グラフ限界長さ
WIDVAL_U_SC_EEE:
	RET
WIDVAL_U_SC	ENDP

WINDOW	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	WDX1:WORD		; WINDOWS/ point x1.
EXTRN	WDY1:WORD		; WINDOWS/ point y1.
EXTRN	WDX2:WORD		; WINDOWS/ point x2.
EXTRN	WDY2:WORD		; WINDOWS/ point y2.

WIDVAL_UP	DW	0		; 内容表示 描画開始位置
WIDVAL_CNT	DW	9		; 内容表示 描画本数
WIDVAL_START	DW	0		; 内容表示 描画開始番号
WIDVAL_END	DW	8		; 内容表示 描画終了番号

WIDVAL_SRTX	DW	2 		; 内容表示 開始位置Ｘ
WIDVAL_SRTY	DW	0		; 内容表示 開始位置Ｙ
WIDVAL_CNTX	DW	1		; 内容表示 Ｘ並び数
WIDVAL_CNTY	DW	4*3		; 内容表示 Ｙ並び数

W_CLM0		DW	2		; カラム・先頭
W_CLM1		DW	6		; カラム・表示値
W_CLM2		DW	6+5		; カラム・グラフ
W_CLM3		DW	6+5+5		; カラム・バランス

LOCATE_HIGHT	DW	8		; 表示ライン１本の高さ
LINE_WIDTH	DW	26-4 ;26-3	; 内容表示１本の長さ
LINE_HIGHT	DW	16		; 内容表示１本の高さ

GR_LENGTH	DW	72	;80	; グラフ限界長さ

G_COL1		DW	8		; グラフカラー
G_COL4		DW	1		; グラフ影カラー

VLEN		DW	0		; 文字長さ

DSP_TORKN	DW	0		; 内容表示 パラメータ名
DSP_TYPE	DW	0		; 内容表示 内容の型
DSP_UNIT	DW	0		; 内容表示 内容の単位系
DSP_VALUE	DW	0		; 内容表示 内容値
DSP_VALUE_OLD	DW	0		; 内容表示 前回の内容値
DSP_HELP	DW	0		; 内容表示 内容説明
DSP_FLAGS	DW	0		; 内容表示 フラグ

PR_DSPXX	DW	0		; 内容表示Ｘ位置
PR_DSPYY	DW	0		; 内容表示Ｙ位置
PR_DSPCLR	DW	0		; パラメータ名文字表示色
PR_DSPCSZ	DW	0		; パラメータ名内容文字表示サイズ
PR_DSPCLR2	DW	0		; 内容文字表示色
PR_DSPCSZ2	DW	0		; 内容文字表示サイズ
PR_DSPCLR3	DW	0		; 数値表示色
PR_DSPCSZ3	DW	0		; 数値文字表示サイズ
PR_DSPTYPE	DW	0		; 内容の型
PR_DSPVAL	DW	0		; 内容表示値
PR_DSPUNIT	DW	0		; 内容表示 単位系
PR_DSPWD	DW	0		; メータ表示太さ
PR_DSPCOL	DW	0		; メータ表示色

DATA	ENDS

	END
;
;	end of "WIDVAL.ASM"
;
