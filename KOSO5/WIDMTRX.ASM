; "WIDMTRX.ASM" PC-9801UV11 make by R.H 1990/11/12
;
;
;	ＷＩＮＤＯＷＳ／マトリックス
;
;
;	WIDMTRX_INIT		; WINDOWS/マトリックス初期処理
;	WIDMTRX_FORMAT		; WINDOWS/マトリックステーブルフォーマット
;	WIDMTRX_ASSIGN		; WINDOWS/マトリックステーブルアサイン
;	WIDMTRX_OPEN		; WINDOWS/マトリックスＯＰＥＮ
;	WIDMTRX_CLOSE		; WINDOWS/マトリックスＣＬＯＳＥ
;	WIDMTRX_SET		; WINDOWS/マトリックスセット
;	WIDMTRX_GET		; WINDOWS/マトリックスＧＥＴ
;	WIDMTRX_ROLL		; WINDOWS/マトリックスＲＯＬＬ
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\WINDOW.INC

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

;
;	背景退避用パーツバンク番号は、＃０です。
;
;

S_MTRX_NOP	EQU	0	; 何もない
S_MTRX_STR	EQU	1	; 文字列
S_MTRX_VAL	EQU	2	; 数値
S_MTRX_GOLD	EQU	3	; 通貨
S_MTRX_DATE	EQU	4	; 日付
S_MTRX_IDSTR	EQU	5	; ＩＤ文字列

WIDMOFSX	EQU	1	; ウインドウ文字オフセット位置Ｘ
WIDMOFSY	EQU	10+16	; ウインドウ文字オフセット位置Ｙ
WIDHDOFX	EQU	1	; ウインドウ項目オフセット位置Ｘ
WIDHDOFY	EQU	6	; ウインドウ項目オフセット位置Ｙ
WIDMKOFX	EQU	1	; ウインドウ罫線オフセット位置Ｘ
WIDMKOFY	EQU	8+16	; ウインドウ罫線オフセット位置Ｙ
WIDMMGEX	EQU	1	; ウインドウ右端マージンＸ
WIDMMGEY	EQU	10	; ウインドウ下端マージンＹ

KEI_WIDTH	EQU	1	; 罫スキップ幅
OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味
EOS		EQU	0	; end of string.


;	ＷＩＮＤＯＷ　から　ＣＯＤＥ　へ　ＣＡＬＬ

CALLC	MACRO	SUB1
	LOCAL	L1,L2
	JMP	L1
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
	MOV	AX,WORD PTR SOUR
	MOV	WORD PTR DEST,AX
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
;	WINDOWS/マトリックス初期処理
; ****************************************************

FUNC	WWIDMTRX_INIT,WIDMTRX_INIT
	RET
FEND	WWIDMTRX_INIT


; ****************************************************
;	WINDOWS/マトリックステーブルフォーマット
;	-I- DX : 表示フォーマットアドレス
;	    BX : 表示フォーマット・タイプアドレス
;	    SI : 項目
;	    WDPCLM : マトリックス横数
;	    WDPLIN : マトリックス行数
; ****************************************************

FUNC	WWIDMTRX_FORMAT,WIDMTRX_FORMAT
	MOV	WID_FORM_ADRS,DX	; 表示フォーマットアドレス
	MOV	WID_FORM_TYPE,BX	; 表示フォーマット・タイプアドレス
	MOV	KOUMOKU_MSG,SI		; 項目
	MOVX	WID_CNT_CLM,WDPCLM	; マトリックス横数
	MOVX	WID_CNT_LINE,WDPLIN	; マトリックス行数
	RET
FEND	WWIDMTRX_FORMAT


; ****************************************************
;	WINDOWS/マトリックステーブルアサイン
;	-I- DX : データテーブルセグメント
;	    BX : データテーブルアドレス
; ****************************************************

FUNC	WWIDMTRX_ASSIGN,WIDMTRX_ASSIGN
	MOV	DAT_TABLE_SEG,DX	; データテーブルセグメント
	MOV	DAT_TABLE_ADRS,BX	; データテーブルアドレス
	RET
FEND	WWIDMTRX_ASSIGN


; ****************************************************
;	WINDOWS/マトリックスＯＰＥＮ
; ****************************************************

FUNC	WWIDMTRX_OPEN,WIDMTRX_OPEN
	MOV	WID_OPEN_FLAG,1		; オープンフラグ1=オープン

	CALL	WIDLOCATE		; ウインドウロケーション計算

	MOVX	WDX1,WIDSLCXP		; ウインドウエリア左上座標Ｘ
	MOVX	WDY1,WIDSLCYP		; ウインドウエリア左上座標Ｙ
	MOVX	WDX2,WIDSLCXL		; ウインドウエリアサイズＸ
	MOVX	WDY2,WIDSLCYL		; ウインドウエリアサイズＹ
	CALLC	WIDDSP_SV_H		; WINDOWS/画面範囲退避

;*;	CALLC	MSCSTP			; カーソルストップ

	CALL	WID_FREAM		; ウインドウフレーム
	CALL	WIDMTRX_ALL		; WINDOWS/マトリックス全表示

;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDMTRX_OPEN


; ****************************************************
;	WINDOWS/マトリックスＣＬＯＳＥ
; ****************************************************

FUNC	WWIDMTRX_CLOSE,WIDMTRX_CLOSE

	MOVX	WDX1,WIDSLCXP		; ウインドウエリア左上座標Ｘ
	MOVX	WDY1,WIDSLCYP		; ウインドウエリア左上座標Ｙ
	MOVX	WDX2,WIDSLCXL		; ウインドウエリアサイズＸ
	MOVX	WDY2,WIDSLCYL		; ウインドウエリアサイズＹ
	CALLC	WIDDSP_LD_H		; WINDOWS/画面範囲復元
	MOV	WID_OPEN_FLAG,0		; オープンフラグ0=クローズ時

	RET
FEND	WWIDMTRX_CLOSE


; ****************************************************
;	WINDOWS/マトリックスセット
;	-I- WDPCLM : 順序
;	    WDPLIN : 行
;	    WDVAL  : 表示値
; ****************************************************

FUNC	WWIDMTRX_SET,WIDMTRX_SET
	MOVX	PNT_CLM,WDPCLM		; 順序
	MOVX	PNT_LIN,WDPLIN		; 行
	CALL	MTRX_LOC		; マトリックス・ロケーション
	CALL	MTRX_SET		; マトリックス・セット

	CMP	WID_OPEN_FLAG,1		; オープンフラグ1=オープン
	JNE	WWIDMTRX_SET_EXIT	;
;*;	CALLC	MSCSTP			; カーソルストップ
	CALL	VAL_PRN			; 内容表示
;*;	CALLC	MSCSRT			; カーソルスタート
WWIDMTRX_SET_EXIT:
	RET
FEND	WWIDMTRX_SET


; ****************************************************
;	WINDOWS/マトリックスＧＥＴ
;	-I- WDPCLM : 順序
;	    WDPLIN : 行
;	-O- WDVAL  : 表示値（日付の場合はアドレスをセットしておいて-I/O-）
; ****************************************************

FUNC	WWIDMTRX_GET,WIDMTRX_GET
	MOVX	PNT_CLM,WDPCLM		; 順序
	MOVX	PNT_LIN,WDPLIN		; 行
	CALL	MTRX_LOC		; マトリックス・ロケーション
	CALL	MTRX_GET		; マトリックス・ＧＥＴ
	RET
FEND	WWIDMTRX_GET


; ****************************************************
;	WINDOWS/マトリックスＲＯＬＬ
; ****************************************************

FUNC	WWIDMTRX_ROLL,WIDMTRX_ROLL
;*;	CALLC	MSCSTP			; カーソルストップ

	CALL	MTRX_ROLL		; マトリックス・ＲＯＬＬ
	CALL	WIDMTRX_ALL		; WINDOWS/マトリックス全表示

;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDMTRX_ROLL



;	WINDOWS/マトリックス全表示
;	-I- WDPCLM : 順序
;	    WDPLIN : 行
;	    WDVAL  : 表示値

WIDMTRX_ALL	PROC	NEAR
	MOV	WDPLIN,0		; 行
	MOV	CX,WID_CNT_LINE		; マトリックス行数
WIDMTRX_ALL_LOOP:
	PUSH	CX
	MOV	WDPCLM,0		; 順序
	MOV	CX,WID_CNT_CLM		; マトリックス横数
WIDMTRX_ALL_LOOP2:
	PUSH	CX			;
	MOVX	PNT_CLM,WDPCLM		; 順序
	MOVX	PNT_LIN,WDPLIN		; 行
	CALL	MTRX_LOC		; マトリックス・ロケーション
	CALL	VAL_PRN			; 内容表示
	INC	WDPCLM			; 順序
	POP	CX
	LOOP	WIDMTRX_ALL_LOOP2	;
	INC	WDPLIN			; 行
	POP	CX
	LOOP	WIDMTRX_ALL_LOOP	;

	RET
WIDMTRX_ALL	ENDP



;	ウインドウロケーション計算
;	-I/O- WID1X   : ウインドウ発生位置左上座標Ｘ
;	      WID1Y   : ウインドウ発生位置左上座標Ｙ
;	-O-   WIDSLCXP: ウインドウエリア左上座標Ｘ
;	      WIDSLCYP: ウインドウエリア左上座標Ｙ
;	      WIDSLCXL: ウインドウエリアサイズＸ
;	      WIDSLCYL: ウインドウエリアサイズＹ

WIDLOCATE	PROC	NEAR
	CALL	WID_WIDTH		; ウインドウ幅

	MOVX	WIDSLCXP,WID1X		; ウインドウエリア左上座標Ｘ
	MOVX	WIDSLCYP,WID1Y		; ウインドウエリア左上座標Ｙ
	SUBX	WIDSLCXP,WIDMOFSX	; ウインドウ文字オフセット位置Ｘ
	SUBX	WIDSLCYP,WIDMOFSY	; ウインドウ文字オフセット位置Ｙ

	MOVX	WIDSLCXL,LINE_WIDTH	; ウインドウエリアサイズＸ

	MOV	AX,WORD_HIGHT		; １単語表示高さ
	MOV	BX,WID_CNT_LINE		; マトリックス行数
	MUL	BX			;
	MOV	WIDSLCYL,AX		; ウインドウエリアサイズＹ

	ADD	WIDSLCXL,WIDMOFSX	; ウインドウ文字オフセット位置Ｘ
	ADD	WIDSLCYL,WIDMOFSY	; ウインドウ文字オフセット位置Ｙ
	ADD	WIDSLCXL,WIDMMGEX	; ウインドウ右端マージンＸ
	ADD	WIDSLCYL,WIDMMGEY	; ウインドウ下端マージンＹ

	MOV	BX,0			; word pointer.
	MOV	AX,0			; 位置
	MOV	CX,WID_CNT_CLM		; マトリックス横数
	INC	CX			;
WIDLOCATE_LOOP:
	MOV	DS:WID_FORM_LOC[BX],AX	; 表示フォーマット・位置
	MOV	SI,WID_FORM_ADRS	; 表示フォーマットアドレス
	ADD	AX,DS:[SI][BX]		; 表示フォーマット・長さ
	CMP	DS:[SI][BX],WORD PTR 0	;
	JE	WIDLOCATE_SKIP		;
	ADD	AX,KEI_WIDTH		; 罫スキップ幅
WIDLOCATE_SKIP:
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	WIDLOCATE_LOOP		;

	RET
WIDLOCATE	ENDP


;	ウインドウ幅
;	-O- LINE_WIDTH : １ラインの幅

WID_WIDTH	PROC	NEAR
	MOV	LINE_WIDTH,0		; １ラインの幅
	MOV	BX,WID_FORM_ADRS	; 表示フォーマット
	MOV	CX,WID_CNT_CLM		; マトリックス横数
WID_WIDTH_LOOP:
	MOV	AX,DS:[BX]		;
	CMP	AX,0			;
	JE	WID_WIDTH_SKIP		;
	ADD	AX,KEI_WIDTH		; 罫スキップ幅
	ADD	LINE_WIDTH,AX		; １ラインの幅
WID_WIDTH_SKIP:				;
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	WID_WIDTH_LOOP		;

	RET
WID_WIDTH	ENDP



;	内容表示
;	-I- NOW_TYPE    : 検索したタイプ
;	    NOW_LOC_X   : 検索したＸ座標
;	    NOW_LOC_Y   : 検索したＹ座標
;	    NOW_TBL_PNT : 検索したテーブルポインタ
;	    NOW_LEN     : 検索した表示長さ

VAL_PRN	PROC	NEAR
	MOVX	PR_DSPXX,NOW_LOC_X		; 表示Ｘ位置
	MOVX	PR_DSPYY,NOW_LOC_Y		; 表示Ｙ位置
	ADDX	PR_DSPXX,WIDSLCXP		; ウインドウエリア左上座標Ｘ
	ADDX	PR_DSPYY,WIDSLCYP		; ウインドウエリア左上座標Ｙ
	ADD	PR_DSPXX,WIDMOFSX		; 文字オフセット位置Ｘ
	ADD	PR_DSPYY,WIDMOFSY		; 文字オフセット位置Ｙ
	MOVX	XX1,PR_DSPXX			; 表示Ｘ位置
	MOVX	YY1,PR_DSPYY			; 表示Ｙ位置

	MOV	BX,NOW_TBL_PNT			; 検索したテーブルポインタ
	ADD	BX,DAT_TABLE_ADRS		; データテーブルアドレス
	MOV	ES,DAT_TABLE_SEG		; データテーブルセグメント
	MOVX	PR_DSPVAL,ES:[BX]		; 内容表示値
	MOV	PR_DSPSEG,ES			; 内容表示セグメント

	MOV	AX,XX1				; 表示Ｘ位置
	MOV	BX,YY1				; 表示Ｙ位置
	MOV	CX,NOW_LEN			; 検索した表示長さ
	MOV	DX,PR_DSPCSZ2			; 文字表示サイズ
	MOV	DI,W_COL3			; WINDOWS/カラー・暗い灰
	MOV	SI,W_COL4			; WINDOWS/カラー・黒
	CALLC	DSPSTR_CLR			; 文字列表示クリア

	CMP	NOW_LEN,0			; 検索した表示長さ
	JMPEQ	VAL_PRN_PAR_EXIT		;

	MOV	AX,NOW_TYPE			; 検索したタイプ

	CMP	AX,S_MTRX_NOP			; 何もない
	JE	VAL_PRN_PAR_NONE		;
	CMP	AX,S_MTRX_STR			; 文字列
	JE	VAL_PRN_PAR_STR			;
	CMP	AX,S_MTRX_VAL			; 数値
	JE	VAL_PRN_PAR_VAL			;
	CMP	AX,S_MTRX_GOLD			; 通貨
	JE	VAL_PRN_PAR_GOLD		;
	CMP	AX,S_MTRX_DATE			; 日付
	JE	VAL_PRN_PAR_DATE		;
	CMP	AX,S_MTRX_IDSTR			; ＩＤ文字列
	JMPEQ	VAL_PRN_PAR_IDSTR		;

	JMP	VAL_PRN_PAR_EXIT		;

VAL_PRN_PAR_NONE:
	JMP	VAL_PRN_PAR_EXIT		;
VAL_PRN_PAR_STR:
	CALL	DISP_STR			; 文字列を表示する
	JMP	VAL_PRN_PAR_EXIT		;
VAL_PRN_PAR_VAL:
	MOVX	WDP_VAL,PR_DSPVAL		; 内容表示値
	MOVX	WDP_UNIT,UNIT_NONE		; 単位系 無し
	MOV	DI,OFFSET STR_BUFF		; 文字列バッファのアドレス
	CALLC	WID_UNIT			; 単位別文字列化
	MOV	SI,OFFSET STR_BUFF		; 文字列バッファのアドレス
	CALL	PR_STRING			; 文字列表示
	JMP	VAL_PRN_PAR_EXIT		;
VAL_PRN_PAR_GOLD:
	CMP	PR_DSPVAL,0			; 内容表示値
	JMPEQ	VAL_PRN_PAR_EXIT		;
	MOVX	WDP_VAL,PR_DSPVAL		; 内容表示値
	MOVX	WDP_UNIT,UNIT_GOLD		; 単位系 通貨
	MOV	DI,OFFSET STR_BUFF		; 文字列バッファのアドレス
	CALLC	WID_UNIT			; 単位別文字列化
	MOV	SI,OFFSET STR_BUFF		; 文字列バッファのアドレス
;*;	CALL	PR_STRING			; 文字列表示
	CALL	PR_STRING_S			; 文字列表示２
	JMP	VAL_PRN_PAR_EXIT		;
VAL_PRN_PAR_DATE:				;
	MOV	ES,SEGWID			;
	MOV	SI,PR_DSPVAL			; 内容表示値
	MOV	DI,OFFSET STR_BUFF		; 文字列バッファのアドレス
	MOV	AX,ES:[SI][5]			;
	MOV	DS:[DI][0],AX			;
	MOV	AX,ES:[SI][7]			;
	MOV	DS:[DI][2],AX			;
	MOV	AL,ES:[SI][9]			;
	MOV	DS:[DI][4],AL			;
	MOV	DS:[DI][5],BYTE PTR 0		;

	MOV	SI,OFFSET STR_BUFF		; 文字列バッファのアドレス
	CALL	PR_STRING			; 文字列表示
	JMP	VAL_PRN_PAR_EXIT		;
VAL_PRN_PAR_IDSTR:				;
	CALL	ID_DISP_STR			; ＩＤ文字列を表示する
	JMP	VAL_PRN_PAR_EXIT		;
VAL_PRN_PAR_EXIT:
	RET
VAL_PRN	ENDP


;	ＩＤ文字列を表示する
;	-I- PR_DSPXX    : 表示Ｘ位置
;	    PR_DSPYY    : 表示Ｙ位置
;	    PR_DSPVAL   : 内容表示値（ＩＤ文字列）

ID_DISP_STR	PROC	NEAR
	PUSH	PR_DSPVAL		;

	MOV	ES,SEGWID		;
	MOV	DI,WIDOFS_ENVIR		; 環境テーブル
	MOV	BX,ES:[DI]		;
	MOV	AX,PR_DSPVAL		;
	SHL	AX,1			; word pointer.
	ADD	BX,AX			;
	MOVX	PR_DSPVAL,ES:[BX]	;

	MOVX	PR_DSPSEG,SEGWID	; 内容表示セグメント

	CALL	DISP_STR		; 文字列を表示する

	POP	PR_DSPVAL		;
	RET
ID_DISP_STR	ENDP



;	文字列を表示する
;	-I- PR_DSPXX    : 表示Ｘ位置
;	    PR_DSPYY    : 表示Ｙ位置
;	    PR_DSPVAL   : 内容表示値（アドレス）
;	    PR_DSPSEG   : 内容表示セグメント

DISP_STR	PROC	NEAR
	CALLC	STRCLEAR		; 文字列バッファクリア

	MOV	ES,PR_DSPSEG		; 内容表示セグメント
	MOV	SI,PR_DSPVAL		; 内容表示値（アドレス）
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,100			; アイテム文字最大長さ
	CALLC	STRSETZ			; 文字列バッファセット

	MOVX	XX1,PR_DSPXX		; Ｘ座標
	MOVX	YY1,PR_DSPYY		; Ｙ座標
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALL	PR_STRING		; 文字列表示

	RET
DISP_STR	ENDP


;	文字列表示
;	-I- SI  : 文字列バッファ
;	    XX1 : Ｘ座標
;	    YY1 : Ｙ座標

PR_STRING	PROC	NEAR
	PUSH	SI

	MOV	AX,PR_DSPCSZ2		; 文字表示サイズ
	CALLC	VTXSIZ			; character size set.

	MOV	AX,PR_DSPCLR2		; 文字表示色
	CALLC	VTXCOL			; character color set.

	POP	SI

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	CALLC	VTXPOR			; vram text print OR.

	RET
PR_STRING	ENDP


;	文字列表示２
;	-I- SI  : 文字列バッファ
;	    XX1 : Ｘ座標
;	    YY1 : Ｙ座標

PR_STRING_S	PROC	NEAR
	PUSH	SI
	MOV	AX,PR_DSPCLR2		; 文字表示色
	CALLC	MITCOL			; mini string color.
	POP	SI

	MOV	AX,XX1			; 表示Ｘ位置
	MOV	BX,YY1			; 表示Ｙ位置
	CALLC	MDTPRN			; MID string. (null=end of string)

	RET
PR_STRING_S	ENDP



;	日付を表示する
;	-I- PR_DSPXX    : 表示Ｘ位置
;	    PR_DSPYY    : 表示Ｙ位置
;	    PR_DSPVAL   : 内容表示値（アドレス）
;	    PR_DSPSEG   : 内容表示セグメント

DISP_DATE	PROC	NEAR
	CALLC	STRCLEAR		; 文字列バッファクリア

	MOV	ES,PR_DSPSEG		; 内容表示セグメント
	MOV	SI,PR_DSPVAL		; 内容表示値（アドレス）
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,100			; アイテム文字最大長さ
	CALLC	STRSETZ			; 文字列バッファセット

	MOV	AX,PR_DSPCLR2		; 文字表示色
	CALLC	MITCOL			; mini string color.

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	MDTPRN			; MID string. (null=end of string)

	RET
DISP_DATE	ENDP



;	マトリックス・ロケーション
;	-I- PNT_CLM     : マトリックス横位置
;	    PNT_LIN     : マトリックス行位置
;	-O- NOW_TYPE    : 検索したタイプ
;	    NOW_LOC_X   : 検索したＸ座標
;	    NOW_LOC_Y   : 検索したＹ座標
;	    NOW_TBL_PNT : 検索したテーブルポインタ
;	    NOW_LEN     : 検索した表示長さ

MTRX_LOC	PROC	NEAR
	CALL	GETADRS			; マトリックスアドレスＧＥＴ
	MOVX	NOW_TBL_PNT,PNT_ADRS	; マトリックスアドレス

	MOV	BX,PNT_CLM		; マトリックス横位置
	SHL	BX,1			; word pointer.
	MOV	SI,WID_FORM_TYPE	; 表示フォーマット・タイプアドレス
	MOVX	NOW_TYPE,DS:[SI][BX]	; 検索したタイプ
	MOV	SI,WID_FORM_ADRS	; 検索した表示長さ
	MOVX	NOW_LEN,DS:[SI][BX]	; 検索した表示長さ
	MOVX	NOW_LOC_X,DS:WID_FORM_LOC[BX]	; 検索したＸ座標

	MOV	AX,PNT_LIN		; マトリックス行位置
	MOV	BX,WORD_HIGHT		; １単語表示高さ
	MUL	BX			;
	MOV	NOW_LOC_Y,AX		; 検索したＹ座標

	RET
MTRX_LOC	ENDP


;	マトリックス・セット
;	-I- NOW_TYPE    : 検索したタイプ
;	    WDVAL       : 表示値
;	    NOW_TBL_PNT : 検索したテーブルポインタ

MTRX_SET	PROC	NEAR
	CMP	NOW_TYPE,S_MTRX_DATE		; 日付
	JE	MTRX_SET_DATE			;

	MOV	BX,NOW_TBL_PNT			; 検索したテーブルポインタ
	ADD	BX,DAT_TABLE_ADRS		; データテーブルアドレス
	MOV	ES,DAT_TABLE_SEG		; データテーブルセグメント
	MOVX	ES:[BX],WDVAL			: 表示値
	JMP	MTRX_SET_EXIT
MTRX_SET_DATE:
	MOV	BX,NOW_TBL_PNT			; 検索したテーブルポインタ
	ADD	BX,DAT_TABLE_ADRS		; データテーブルアドレス
	MOV	ES,DAT_TABLE_SEG		; データテーブルセグメント
	MOV	DI,ES:[BX]			; 日付のアドレス
	MOV	SI,WDVAL			; 表示値（ユーザのアドレス）
	MOV	CX,10				;
	REP	MOVSB
MTRX_SET_EXIT:
	RET
MTRX_SET	ENDP


;	マトリックス・ＧＥＴ
;	-I- NOW_TYPE    : 検索したタイプ
;	    NOW_TBL_PNT : 検索したテーブルポインタ
;	-O- WDVAL  : 表示値（日付の場合はアドレスをセットしておいて-I/O-）

MTRX_GET	PROC	NEAR
	CMP	NOW_TYPE,S_MTRX_DATE		; 日付
	JE	MTRX_GET_DATE			;

	MOV	BX,NOW_TBL_PNT			; 検索したテーブルポインタ
	ADD	BX,DAT_TABLE_ADRS		; データテーブルアドレス
	MOV	ES,DAT_TABLE_SEG		; データテーブルセグメント
	MOVX	WDVAL,ES:[BX]			; 表示値
	JMP	MTRX_GET_EXIT
MTRX_GET_DATE:
	PUSH	DS
	MOV	BX,NOW_TBL_PNT			; 検索したテーブルポインタ
	ADD	BX,DAT_TABLE_ADRS		; データテーブルアドレス
	MOV	ES,DAT_TABLE_SEG		; データテーブルセグメント
	MOV	SI,ES:[BX]			; 日付のアドレス
	MOV	DI,WDVAL			; 表示値（ユーザのアドレス）
	MOV	AX,DS				;
	MOV	ES,AX				;
	MOV	AX,DAT_TABLE_SEG		; データテーブルセグメント
	MOV	DS,AX				;
	MOV	CX,10				;
	REP	MOVSB
	POP	DS
MTRX_GET_EXIT:
	RET
MTRX_GET	ENDP


;	マトリックスアドレスＧＥＴ
;	-I- PNT_CLM  : マトリックス横位置
;	    PNT_LIN  : マトリックス行位置
;	-O- PNT_ADRS : マトリックスアドレス

GETADRS		PROC	NEAR
	MOV	AX,WID_CNT_CLM		; マトリックス横数
	MOV	BX,PNT_LIN		; ＊　マトリックス行位置
	MUL	BX			;
	ADD	AX,PNT_CLM		; マトリックス横位置
	SHL	AX,1			; word pointer.
	MOV	PNT_ADRS,AX		; マトリックスアドレス
	RET
GETADRS		ENDP


;	マトリックス・ＲＯＬＬ

MTRX_ROLL	PROC	NEAR
	CMP	WID_CNT_LINE,1		; マトリックス行数
	JLE	MTRX_ROLL_EXIT		;

	MOV	PNT_CLM,0		; マトリックス横位置
	MOV	PNT_LIN,1		; マトリックス行位置
MTRX_ROLL_LOOP:
	CALL	MTRX_LOC		; マトリックス・ロケーション
	CMP	NOW_TYPE,S_MTRX_DATE	; 日付
	JNE	MTRX_ROLL_4		;

	MOV	WDVAL,OFFSET WRK_DATE	; 日付
	CALL	MTRX_GET		; マトリックス・ＧＥＴ
	DEC	PNT_LIN			; マトリックス行位置
	CALL	MTRX_LOC		; マトリックス・ロケーション
	CALL	MTRX_SET		; マトリックス・セット
	INC	PNT_LIN			; マトリックス行位置

	JMP	MTRX_ROLL_5		;
MTRX_ROLL_4:
	CALL	MTRX_GET		; マトリックス・ＧＥＴ
	DEC	PNT_LIN			; マトリックス行位置
	CALL	MTRX_LOC		; マトリックス・ロケーション
	CALL	MTRX_SET		; マトリックス・セット
	INC	PNT_LIN			; マトリックス行位置

MTRX_ROLL_5:

	INC	PNT_CLM			; マトリックス横位置
	CMPX	PNT_CLM,WID_CNT_CLM	; マトリックス横数
	JL	MTRX_ROLL_8		;
	MOV	PNT_CLM,0		; マトリックス横位置
	INC	PNT_LIN			; マトリックス行位置
	CMPX	PNT_LIN,WID_CNT_LINE	; マトリックス行数
	JL	MTRX_ROLL_8		;
	JMP	MTRX_ROLL_EXIT		;
MTRX_ROLL_8:
	JMP	MTRX_ROLL_LOOP		;

MTRX_ROLL_EXIT:
	RET
MTRX_ROLL	ENDP



;	ウインドウフレーム
;	-I- WID1X : ウインドウ発生位置左上座標Ｘ
;	    WID1Y : ウインドウ発生位置左上座標Ｙ
;	    WIDSLCXP : ウインドウエリア左上座標Ｘ
;	    WIDSLCYP : ウインドウエリア左上座標Ｙ
;	    WIDSLCXL : ウインドウエリアサイズＸ
;	    WIDSLCYL : ウインドウエリアサイズＹ

WID_FREAM	PROC	NEAR
	MOVX	WDX1,WIDSLCXP		; ウインドウエリア左上座標Ｘ
	MOVX	WDY1,WIDSLCYP		; ウインドウエリア左上座標Ｙ
	MOVX	WDX2,WIDSLCXL		; ウインドウエリアサイズＸ
	MOVX	WDY2,WIDSLCYL		; ウインドウエリアサイズＹ
	CALLC	WID_1_FLAME		; WINDOWS/フレーム１
;*;	CALLC	WID_4_FLAME		; WINDOWS/フレーム４

	; 本表の罫線

	MOVX	XX1,WIDSLCXP		; ウインドウエリア左上座標Ｘ
	MOVX	YY1,WIDSLCYP		; ウインドウエリア左上座標Ｙ
	ADD	XX1,WIDMKOFX		; ウインドウ罫線オフセット位置Ｘ
	ADD	YY1,WIDMKOFY		; ウインドウ罫線オフセット位置Ｙ

	MOV	CX,WID_CNT_LINE		; マトリックス行数
WID_FREAM_LIN:
	PUSH	CX			;
	CALL	KEI_X_LINE		; 罫線・Ｘ
	CALL	WIDFRM_LINE		; １ライン分のフォーマット
	ADDX	YY1,WORD_HIGHT		; １単語表示高さ
	POP	CX			;
	LOOP	WID_FREAM_LIN		;

	CALL	KEI_X_LINE		; 罫線・Ｘ

	; 項目の罫線

	MOVX	XX1,WIDSLCXP		; ウインドウエリア左上座標Ｘ
	MOVX	YY1,WIDSLCYP		; ウインドウエリア左上座標Ｙ
	ADD	XX1,WIDHDOFX		; ウインドウ項目オフセット位置Ｘ
	ADD	YY1,WIDHDOFY		; ウインドウ項目オフセット位置Ｙ
	CALL	KEI_X_LINE		; 罫線・Ｘ
	CALL	WIDFRM_LINE		; １ライン分のフォーマット
	INC	YY1			; ＋１
	MOV	SI,KOUMOKU_MSG		; 項目
	CALL	PR_STRING		; 文字列表示

	RET
WID_FREAM	ENDP


;	１ライン分のフォーマット
;	-I- WID_FORM_LOC  : 検索したＸ座標
;	    XX1           : 左上座標Ｘ
;	    YY1           : 左上座標Ｙ

WIDFRM_LINE	PROC	NEAR
	PUSH	XX1
	PUSH	YY1

	MOV	BX,0			; word pointer.
	MOV	CX,WID_CNT_CLM		; マトリックス横数
	INC	CX			;
WIDFRM_LINE_LOOP:
	PUSH	CX			;
	PUSH	BX			;
	PUSH	XX1			;
	ADDX	XX1,DS:WID_FORM_LOC[BX]	; 検索したＸ座標
	CALL	KEI_Y_LINE		; 罫線・Ｙ
	POP	XX1			;
	POP	BX			;
	INC	BX			;
	INC	BX			; word pointer.
	POP	CX			;
	LOOP	WIDFRM_LINE_LOOP	;

	POP	YY1
	POP	XX1
	RET
WIDFRM_LINE	ENDP



;	罫線・Ｘ
;	-I- XX1 : 左上座標Ｘ
;	    YY1 : 左上座標Ｙ

KEI_X_LINE	PROC	NEAR
	PUSH	XX1
	MOVX	XX2,XX1			; Ｙ座標
	ADDX	XX2,LINE_WIDTH		; １ラインの幅
;*;	DEC	XX2
	SHL	XX1,1
	SHL	XX1,1
	SHL	XX1,1
	SHL	XX2,1
	SHL	XX2,1
	SHL	XX2,1

	MOVX	VX1,XX1			; start dot point x1.
	MOVX	VY1,YY1			; start dot point y1.
	MOVX	VX2,XX2			; end dot point x2.
	MOV	VCOL,8			;
	MOV	CX,1			; line width.
	CALLC	DLINEH			; 水平ライン描画

	POP	XX1
	RET
KEI_X_LINE	ENDP


;	罫線・Ｙ
;	-I- XX1 : 左上座標Ｘ
;	    YY1 : 左上座標Ｙ

KEI_Y_LINE	PROC	NEAR
	PUSH	XX1
	MOVX	YY2,YY1			; Ｙ座標
	ADDX	YY2,WORD_HIGHT		; １単語表示高さ
	SHL	XX1,1
	SHL	XX1,1
	SHL	XX1,1
	SUB	XX1,3

	MOVX	VX1,XX1			; start dot point x1.
	MOVX	VY1,YY1			; start dot point y1.
	MOVX	VY2,YY2			; end line point y2.
	MOV	VCOL,8			;
	MOV	CX,3			; line width.
	CALLC	DLINEV			; 垂直ライン描画
;*;	BAR_V	XX1,YY1,YY2,3,8
	POP	XX1
	RET
KEI_Y_LINE	ENDP


WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SSDES0:WORD		; visual data segment plean 0
EXTRN	SSDES1:WORD		; visual data segment plean 1
EXTRN	SSDES2:WORD		; visual data segment plean 2
EXTRN	SSDES3:WORD		; visual data segment plean 3

EXTRN	WDX1:WORD		; WINDOWS/ point x1.
EXTRN	WDY1:WORD		; WINDOWS/ point y1.
EXTRN	WDX2:WORD		; WINDOWS/ point x2.
EXTRN	WDY2:WORD		; WINDOWS/ point y2.

EXTRN 	ATMSEG:WORD		; WINDOWS/テキストバッファセグメント
EXTRN	ATMTBL:WORD		; WINDOWS/表示単語アドレス
EXTRN	ATMTLN:WORD		; WINDOWS/表示単語長さ
EXTRN	ATMVAL:WORD		; WINDOWS/表示単語の数値
EXTRN	ATMMAX:WORD		; WINDOWS/表示単語の数
EXTRN	ATMDIM:WORD	 	; WINDOWS/表示単語のテーブルサイズ

EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.

EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

EXTRN	VX1:WORD		; source point x1.
EXTRN	VY1:WORD		; source point y1.
EXTRN	VX2:WORD		; length x2.
EXTRN	VY2:WORD		; length y2.
EXTRN	VX3:WORD		; destination point x3.
EXTRN	VY3:WORD		; destination point y3.

EXTRN	STR_BUFF:BYTE		; 文字列バッファ
EXTRN	STR_VAL_BUFF:BYTE	; 表示値文字列バッファ

WID_OPEN_FLAG	DW	0		; オープンフラグ0=クローズ時,1=オープン

WID_FORM_ADRS	DW	0		; 表示フォーマットアドレス
WID_FORM_TYPE	DW	0		; 表示フォーマット・タイプアドレス

WID_FORM_LOC	DW	10 DUP (0)	; 表示フォーマット・位置

WID_CNT_CLM	DW	6		; マトリックス横数
WID_CNT_LINE	DW	10		; マトリックス行数

WID1X		DW	2		; ウインドウ発生位置左上座標Ｘ
WID1Y		DW	8*40		; ウインドウ発生位置左上座標Ｙ
					; （初期値がはいっています）

PNT_CLM		DW	0		; マトリックス横位置
PNT_LIN		DW	0		; マトリックス行位置
PNT_ADRS	DW	0		; マトリックスアドレス

WIDSLCXP	DW	0		; ウインドウエリア左上座標Ｘ
WIDSLCYP	DW	0		; ウインドウエリア左上座標Ｙ
WIDSLCXL	DW	0		; ウインドウエリアサイズＸ
WIDSLCYL	DW	0		; ウインドウエリアサイズＹ

LINE_WIDTH	DW	0		; １ラインの幅
WORD_HIGHT	DW	18		; １単語表示高さ

NOW_TYPE	DW	0		; 検索したタイプ
NOW_LEN		DW	0		; 検索した表示長さ
NOW_LOC_X	DW	0		; 検索したＸ座標
NOW_LOC_Y	DW	0		; 検索したＹ座標
NOW_TBL_PNT	DW	0		; 検索したテーブルポインタ

DAT_TABLE_SEG	DW	0		; データテーブルセグメント
DAT_TABLE_ADRS	DW	0		; データテーブルアドレス

KOUMOKU_MSG	DW	0		; 項目

PR_DSPXX	DW	0		; 表示Ｘ位置
PR_DSPYY	DW	0		; 表示Ｙ位置
PR_DSPVAL	DW	0		; 内容表示値
PR_DSPSEG	DW	0		; 内容表示セグメント
PR_DSPCLR2	DW	15		; 文字表示色
PR_DSPCSZ2	DW	0		; 文字表示サイズ
PR_DSPCLR3	DW	15		; 数値表示色
PR_DSPCSZ3	DW	0		; 数値文字表示サイズ
PR_DSPUNIT	DW	0		; 内容表示 単位系

XX1		DW	0		; Ｘ座標
YY1		DW	0		; Ｙ座標
XX2		DW	0		; Ｘ座標
YY2		DW	0		; Ｙ座標

WRK_DATE	DB	"1990/10/10",0,0 ; 日付

DATA	ENDS

	END
;
;	end of "WIDMTRX.ASM"
;
