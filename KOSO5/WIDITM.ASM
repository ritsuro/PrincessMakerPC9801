; "WIDITM.ASM" PC-9801UV11 make by R.H 1990/10/26
;
;
;	ＷＩＮＤＯＷＳ／アイテム系表示（道具,技,仕事）
;
;
;	WIDITM_INIT		; WINDOWS/アイテム系初期処理
;	WIDITM			; WINDOWS/アイテム系表示
;	WIDITMWD		; WINDOWS/アイテム系ワイド表示
;	WIDITM_OPEN		; WINDOWS/アイテム系オープン
;	WIDITM_CLOSE		; WINDOWS/アイテム系クローズ
;	WIDITM_STD		; WINDOWS/アイテムフレーム利用表示
;	WIDITM_SWK		; WINDOWS/アイテムフレーム教育一覧表示
;	WIDITM_PIC		; WINDOWS/アイテム絵表示
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO4\WORDID.INC

PRICE_SHOKYU	EQU	10	; 初級値段
PRICE_CHUKYU	EQU	20	; 中級値段
PRICE_JOHKYU	EQU	40	; 上級値段
PRICE_REIHOU	EQU	10	; 礼法値段

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

WIDITM_NM_LEN	EQU	8*2		; アイテム文字最大長さ


I_ITEM_A_NM	EQU	0		; アイテム種別名
I_ITEM_PRAM	EQU	2		; パラメータ数
I_ITEM_WORDS	EQU	4		; パラメータＷＯＲＤ数
I_ITEM_P_TOP	EQU	6		; パラメータスタイル先頭


S_TYP_NOP	EQU	0		; 0=何もない
S_TYP_NAME	EQU	1		; 1=名前
S_TYP_STR	EQU	2		; 2=文字列
S_TYP_GOLD	EQU	3		; 3=通貨
S_TYP_GRAP	EQU	4		; 4=文字列と数値(ｸﾞﾗﾌ)
S_TYP_VAL	EQU	5		; 5=数値
S_TYP_AGE	EQU	6		; 6=年齢
S_TYP_HELP	EQU	7		; 7=説明



;	WDILIST  スタイルリストオフセット
;
;		［アイテム種別名　　］
;		［パラメータ数　　　］
;		［パラメータＷＯＲＤ数］
;		［パラメータ１タイプ］
;		［パラメータ名　　　］
;		［パラメータ２タイプ］
;		［パラメータ名　　　］
;		［パラメータ３タイプ］
;		［パラメータ名　　　］
;		［　　　　．　　　　］
;		［　　　　．　　　　］


;	WDINO    アイテムオフセット
;
;		［アイテム名　　　　  ］
;		［１アドレスまたは数値］
;		［２アドレスまたは数値］
;		［３アドレスまたは数値］
;		［　　　　．　　　　　］
;		［　　　　．　　　　　］
;		［　　　　．　　　　　］


MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM

MOVXBW	MACRO	DEST,SOUR_BYTE
	MOV	AH,0
	MOV	AL,SOUR_BYTE
	MOV	DEST,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA

; ****************************************************
;	WINDOWS/アイテム系初期処理
; ****************************************************

FUNC	WWIDITM_INIT,WIDITM_INIT
	RET
FEND	WWIDITM_INIT


; ****************************************************
;	WINDOWS/アイテム系表示
;	-I- WDINO   : WINDOWS/アイテムオフセット
;	    WDILIST : WINDOWS/スタイルリストオフセット
; ****************************************************

FUNC	WWIDITM,WIDITM
	CALL	WIDITM_DRAW		; アイテム系表示
	RET
FEND	WWIDITM


; ****************************************************
;	WINDOWS/アイテム系ワイド表示
;	-I- WDINO   : WINDOWS/アイテムオフセット
;	    WDILIST : WINDOWS/スタイルリストオフセット
; ****************************************************

FUNC	WWIDITMWD,WIDITMWD
	PUSH	D_ITM_MAXSET		; パラメータ数制限

	MOV	D_ITM_MAXSET,3		; パラメータ数制限
	CALL	WIDITMWD_DRAW		; アイテム系ワイド表示

	POP	D_ITM_MAXSET		; パラメータ数制限
	RET
FEND	WWIDITMWD


; ****************************************************
;	WINDOWS/アイテム系オープン
; ****************************************************

FUNC	WWIDITM_OPEN,WIDITM_OPEN
	CALL	WIDITM_TBL_CLEAR	; アイテム系ロケートテーブル初期化
	RET
FEND	WWIDITM_OPEN



; ****************************************************
;	アイテム系ウインドウ・クローズ
; ****************************************************

FUNC	WWIDITM_CLOSE,WIDITM_CLOSE
	RET
FEND	WWIDITM_CLOSE


; ****************************************************
;	WINDOWS/アイテムフレーム教育一覧表示
; ****************************************************

FUNC	WWIDITM_SWK,WIDITM_SWK
	CALL	FAR PTR WWIDITM_OPEN		; WINDOWS/アイテム系オープン

	MOV	ADRS_KYOIKU_TBL,OFFSET TBL_BUGEI ; 武芸
	CALL	FAR PTR WWIDITM_STD	; WINDOWS/アイテムフレーム利用表示

	MOV	ADRS_KYOIKU_TBL,OFFSET TBL_GAKUMON	; 学問
	CALL	FAR PTR WWIDITM_STD	; WINDOWS/アイテムフレーム利用表示

	MOV	ADRS_KYOIKU_TBL,OFFSET TBL_REIHO	; 礼法
	CALL	FAR PTR WWIDITM_STD	; WINDOWS/アイテムフレーム利用表示

	MOV	ADRS_KYOIKU_TBL,OFFSET TBL_MUSYA	; 武者修行
	CALL	FAR PTR WWIDITM_STD	; WINDOWS/アイテムフレーム利用表示

	RET
FEND	WWIDITM_SWK


; ****************************************************
;	WINDOWS/アイテム絵表示
;	-I- SI : アイテムオフセット
;	    AX : パラメータ表示Ｘ位置
;	    BX : パラメータ表示Ｙ位置
; ****************************************************

FUNC	WWIDITM_PIC,WIDITM_PIC
	MOV	D_ITM_ADRS,SI		; アイテムオフセット
	MOV	WD_DSP_SXX,AX		; パラメータ表示Ｘ位置
	SUB	BX,16			; １段下げているので１段上げる
	MOV	WD_DSP_SYY,BX		; パラメータ表示Ｙ位置
	CALL	WIDITM_PICTUER		; 絵を表示する
	RET
FEND	WWIDITM_PIC



; ****************************************************
;	WINDOWS/アイテムフレーム利用表示
;	-I- ADRS_KYOIKU_TBL : 教育一覧アドレス
; ****************************************************

FUNC	WWIDITM_STD,WIDITM_STD
	MOV	SI,ADRS_KYOIKU_TBL		; 教育一覧アドレス
	MOVX	PIC_NUMBER,DS:[SI][0]		; アイテム絵番号
	MOVX	WD_DSP_LXX,DS:[SI][2]		; ウインドウＸ長さ
	MOVX	WD_DSP_LYY,DS:[SI][4]		; ウインドウＹ長さ
	MOVX	WD_NAME_ID,DS:[SI][6]		; 名前ＩＤ
	MOVX	WD_STYLE,DS:[SI][8]		; スタイル

	MOV	WD_ITM_LCT_NUM,2	; アイテムウインドウ配置番号
	CALL	WIDITM_LC_TBL_GET	; アイテム系ロケートテーブル検索

	CALL	WIDITM_FLAME			; アイテム表示のフレーム

	MOV	DX,PIC_NUMBER			; アイテム絵番号
	MOV	AX,WD_DSPXX			; パラメータ表示Ｘ位置
	MOV	BX,WD_DSPYY			; パラメータ表示Ｙ位置
	ADD	BX,16				; １段下げる
	CALLC	PT_PUT_ITEM			; アイテムＰＵＴ

	MOVX	CX,WD_NAME_ID			; 名前ＩＤ
	CALL	ID_TO_ADRS			; 文字ＩＤアドレスＧＥＴ
	MOV	PR_DSPVAL,SI			; 表示内容（文字列のアドレス）
	MOVX	PR_DSPXX,WD_DSPXX		; パラメータ表示Ｘ位置
	MOVX	PR_DSPYY,WD_DSPYY		; パラメータ表示Ｙ位置
	CALL	WIDITM_STRINGS			; 文字列の表示

	MOVX	WD_DSP_SXX,WD_DSPXX		; パラメータ表示Ｘ位置
	MOVX	WD_DSP_SYY,WD_DSPYY		; パラメータ表示Ｙ位置
	ADD	WD_DSP_SXX,4			; パラメータ表示Ｘ位置
	ADD	WD_DSP_SYY,16			; パラメータ表示Ｙ位置

	CMP	WD_STYLE,0			; スタイル
	JE	WIDITM_STD_EXIT			;

	CMP	WD_STYLE,1			; スタイル
	JE	WIDITM_STD_1STYL		;

	CMP	WD_STYLE,2			; スタイル
	JE	WIDITM_STD_2STYL		;

	JMP	WIDITM_STD_EXIT			;

WIDITM_STD_1STYL:

	MOV	SI,ADRS_KYOIKU_TBL		; 教育一覧アドレス
	MOVX	GOLD_VAL,DS:[SI][10]		; 値段
	CALL	GOLD_DISP			; お金の表示

	JMP	WIDITM_STD_EXIT			;

WIDITM_STD_2STYL:

	MOV	CX,ID_72			; 初級
	CALL	SWORD_DISP			; ＩＤ文字の表示

	ADD	WD_DSP_SXX,4			; パラメータ表示Ｘ位置
	MOV	SI,ADRS_KYOIKU_TBL		; 教育一覧アドレス
	MOVX	GOLD_VAL,DS:[SI][10]		; 初級試験値段
	CALL	GOLD_DISP			; お金の表示

	SUB	WD_DSP_SXX,4			; パラメータ表示Ｘ位置

	MOV	CX,ID_73			; 中級
	CALL	SWORD_DISP			; ＩＤ文字の表示

	ADD	WD_DSP_SXX,4			; パラメータ表示Ｘ位置
	MOV	SI,ADRS_KYOIKU_TBL		; 教育一覧アドレス
	MOVX	GOLD_VAL,DS:[SI][12]		; 中級試験値段
	CALL	GOLD_DISP			; お金の表示

	SUB	WD_DSP_SXX,4			; パラメータ表示Ｘ位置

	MOV	CX,ID_74			; 上級
	CALL	SWORD_DISP			; ＩＤ文字の表示

	ADD	WD_DSP_SXX,4			; パラメータ表示Ｘ位置
	MOV	SI,ADRS_KYOIKU_TBL		; 教育一覧アドレス
	MOVX	GOLD_VAL,DS:[SI][14]		; 上級試験値段
	CALL	GOLD_DISP			; お金の表示
WIDITM_STD_EXIT:
	RET
FEND	WWIDITM_STD


;	お金の表示
;	-I-   GOLD_VAL   : お金
;	-I/O- WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

GOLD_DISP	PROC	NEAR
	MOV	AX,PR_DSPCSZ2			; 文字表示サイズ
	CALLC	VTXSIZ				; character size set.
	MOV	AX,PR_DSPCLR2			; 文字表示色
	CALLC	VTXCOL				; character color set.
	MOVX	PR_DSPXX,WD_DSP_SXX		; パラメータ表示Ｘ位置
	MOVX	PR_DSPYY,WD_DSP_SYY		; パラメータ表示Ｙ位置
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOVX	PR_DSPVAL,GOLD_VAL		; お金
	MOV	PR_DSPUNIT,UNIT_GOLD		; 単位系 通貨
	CALL	WIDVALDSP			; 表示値表示
	ADD	WD_DSP_SYY,16			; パラメータ表示Ｙ位置
	RET
GOLD_DISP	ENDP


;	ＩＤ文字の表示
;	-I-   CX         : 名前ＩＤ
;	      WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

SWORD_DISP	PROC	NEAR
	CALL	ID_TO_ADRS			; 文字ＩＤアドレスＧＥＴ
	MOV	PR_DSPVAL,SI			; 表示内容（文字列のアドレス）

	MOVX	PR_DSPXX,WD_DSP_SXX		; パラメータ表示Ｘ位置
	MOVX	PR_DSPYY,WD_DSP_SYY		; パラメータ表示Ｙ位置
	CALL	WIDITM_STRINGS			; 文字列の表示
	RET
SWORD_DISP	ENDP



;	アイテム系ロケートテーブル初期化

WIDITM_TBL_CLEAR	PROC	NEAR
	MOV	WD_ITM_LCT_PNT,0		; アイテムオープン番号
	RET
WIDITM_TBL_CLEAR	ENDP


;	アイテム系ロケートテーブル検索
;	-O- WD_DSPXX   : ウインドウＸ位置
;	    WD_DSPYY   : ウインドウＹ位置

WIDITM_LC_TBL_GET	PROC	NEAR
	MOV	DI,WD_ITM_LCT_NUM	; アイテムウインドウ配置番号
	SHL	DI,1			; word pointer.
	CMPX	WD_ITM_LCT_PNT,DS:WD_ITM_LCT_MAX[DI] ; アイテムウインドウ最大数
	JL	WIDITM_LC_TBL_GET_2	;
	MOV	WD_ITM_LCT_PNT,0	; アイテムオープン番号
WIDITM_LC_TBL_GET_2:
	MOV	SI,WD_ITM_LCT_PNT	; アイテムオープン番号
	MOV	DI,WD_ITM_LCT_NUM	; アイテムウインドウ配置番号
	SHL	DI,1			; word pointer.

	MOV	BX,DS:WD_ITM_LCT_XX_TBL[DI]	; ロケーションＸ
	MOVXBW	WD_DSPXX,DS:[BX][SI]		; ロケーションＸ
	MOV	BX,DS:WD_ITM_LCT_YY_TBL[DI]	; ロケーションＹ
	MOVXBW	WD_DSPYY,DS:[BX][SI]		; ロケーションＹ

	ADDX	WD_DSPXX,WD_ITM_LCT_OFX	; ロケーションＸオフセット
	ADDX	WD_DSPYY,WD_ITM_LCT_OFY	; ロケーションＹオフセット

	SHL	WD_DSPYY,1		;
	SHL	WD_DSPYY,1		;
	SHL	WD_DSPYY,1		; * 8

	INC	WD_ITM_LCT_PNT		; アイテムオープン番号
	RET
WIDITM_LC_TBL_GET	ENDP



;	ウインドウロケーション
;	-I- WDINO      : アイテムオフセット
;	    WDILIST    : スタイルリストオフセット
;	-O- WD_DSPXX   : ウインドウＸ位置
;	    WD_DSPYY   : ウインドウＹ位置
;	    WD_DSP_LXX : ウインドウＸ長さ
;	    WD_DSP_LYY : ウインドウＹ長さ

WIDITM_LOCATE	PROC	NEAR
	CALL	WIDITM_LC_TBL_GET	; アイテム系ロケートテーブル検索
	CALL	WIDITM_LCT_XY_CNT	; ウインドウＸＹ方向カウンタ
	RET
WIDITM_LOCATE	ENDP


;	ウインドウＸＹ方向カウンタ
;	-I- WDINO      : アイテムオフセット
;	    WDILIST    : スタイルリストオフセット
;	-O- WD_DSP_LXX : ウインドウＸ長さ
;	    WD_DSP_LYY : ウインドウＹ長さ

WIDITM_LCT_XY_CNT	PROC	NEAR
	MOV	BX,WDILIST		; スタイルリストオフセット
	MOVX	D_ITM_PRAM ,DS:[BX][I_ITEM_PRAM] ; パラメータ数

	ADD	BX,I_ITEM_P_TOP		; パラメータスタイル先頭
	MOV	D_ITM_TOP,BX		;

	MOVX	D_ITM_ADRS,WDINO	; アイテムオフセット

	MOV	MAX_X,0			; 最大Ｘ
	MOV	MAX_Y,0			; 最大Ｙ

	MOV	CX,D_ITM_PRAM		; パラメータ数
	CMP	CX,D_ITM_MAXSET		; パラメータ数制限
	JL	WIDITM_LCT_XY_CNT_2	;
	MOV	CX,D_ITM_MAXSET		; パラメータ数制限
WIDITM_LCT_XY_CNT_2:
WIDITM_LCT_XY_CNT_LOOP:
	MOV	BX,D_ITM_TOP		; パラメータスタイル先頭
	MOV	AX,DS:[BX]		; パラメータタイプ

	CMP	AX,S_TYP_NOP		; 0=何もない
	JE	WIDITM_LCT_XY_CNT_41	;

;*;	CMP	AX,S_TYP_NAME		; 1=名前
;*;	CMP	AX,S_TYP_STR		; 2=文字列
	CMP	AX,S_TYP_GOLD		; 3=通貨
	JE	WIDITM_LCT_XY_CNT_41	;
	CMP	AX,S_TYP_GRAP		; 4=文字列と数値(ｸﾞﾗﾌ)
	JE	WIDITM_LCT_XY_CNT_5	;
;*;	CMP	AX,S_TYP_VAL		; 5=数値
	CMP	AX,S_TYP_AGE		; 6=年齢
	JE	WIDITM_LCT_XY_CNT_42	;
	CMP	AX,S_TYP_HELP		; 7=説明
	JE	WIDITM_LCT_XY_CNT_41	;

	ADD	D_ITM_ADRS,2		; アイテムオフセット
	INC	MAX_Y			; 最大Ｙ
	JMP	WIDITM_LCT_XY_CNT_NEXT	;

WIDITM_LCT_XY_CNT_41:
	ADD	D_ITM_ADRS,2		; アイテムオフセット
	JMP	WIDITM_LCT_XY_CNT_NEXT	;

WIDITM_LCT_XY_CNT_42:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS		; アイテムオフセット
	ADD	D_ITM_ADRS,4		; アイテムオフセット
	MOV	AX,ES:[BX]		; 表示値（年齢）
	CMP	AX,0			; 無効の年齢
	JE	WIDITM_LCT_XY_CNT_NEXT	;

	INC	MAX_Y			; 最大Ｙ

	JMP	WIDITM_LCT_XY_CNT_NEXT	;

WIDITM_LCT_XY_CNT_5:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS		; アイテムオフセット
	ADD	D_ITM_ADRS,4		; アイテムオフセット
	MOV	SI,ES:[BX]		; 表示（文字列のアドレス）
	MOV	AX,ES:[SI]		;
	CMP	AX,WORD PTR WD_NONE_CHR	; WINDOWS/無効キャラクタ
	JE	WIDITM_LCT_XY_CNT_NEXT	;

	INC	MAX_Y			; 最大Ｙ

	JMP	WIDITM_LCT_XY_CNT_NEXT	;

WIDITM_LCT_XY_CNT_NEXT:
	ADD	D_ITM_TOP,4		; パラメータスタイル先頭
	LOOP	WIDITM_LCT_XY_CNT_LOOP	;

	CMP	MAX_Y,2			; 最大Ｙ
	JGE	WIDITM_LCT_XY_CNT_777	;
	MOV	MAX_Y,2			; 最大Ｙ
WIDITM_LCT_XY_CNT_777:

	MOV	AX,MAX_Y		; 最大Ｙ
	MOV	BX,16			;
	MUL	BX			;
	ADD	AX,16			;
	MOV	WD_DSP_LYY,AX		; ウインドウＹ長さ

	MOV	WD_DSP_LXX,10+4+1		; ウインドウＸ長さ
	RET
WIDITM_LCT_XY_CNT	ENDP



;	アイテム系表示
;	-I- WDINO      : アイテムオフセット
;	    WDILIST    : スタイルリストオフセット
;	-O- WD_DSPXX   : ウインドウＸ位置
;	    WD_DSPYY   : ウインドウＹ位置
;	    WD_DSP_SXX : パラメータ表示Ｘ位置
;	    WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_DRAW	PROC	NEAR
	MOV	WD_ITM_LCT_NUM,0	; アイテムウインドウ配置番号
	CALL	WIDITM_LOCATE		; ウインドウロケーション

	CALL	WIDITM_FLAME		; アイテム表示のフレーム

	MOVX	WD_DSP_SXX,WD_DSPXX	; パラメータ表示Ｘ位置
	MOVX	WD_DSP_SYY,WD_DSPYY	; パラメータ表示Ｙ位置

;*NON*;	CALL	WIDITM_TITLE		; アイテム系ウインドウタイトル

	CALL	WIDITM_ALL		; アイテム系ウインドウ・１アイテム表示
	RET
WIDITM_DRAW	ENDP


;	アイテム系ワイド表示
;	-I- WDINO      : アイテムオフセット
;	    WDILIST    : スタイルリストオフセット
;	-O- WD_DSPXX   : ウインドウＸ位置
;	    WD_DSPYY   : ウインドウＹ位置
;	    WD_DSP_SXX : パラメータ表示Ｘ位置
;	    WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITMWD_DRAW	PROC	NEAR
	MOV	WD_ITM_LCT_NUM,1	; アイテムウインドウ配置番号
	CALL	WIDITM_LOCATE		; ウインドウロケーション

	MOV	WD_DSP_LXX,10+2		; ウインドウＸ長さ

	CALL	WIDITM_FLAME		; アイテム表示のフレーム

	MOVX	WD_DSP_SXX,WD_DSPXX	; パラメータ表示Ｘ位置
	MOVX	WD_DSP_SYY,WD_DSPYY	; パラメータ表示Ｙ位置

	CALL	WIDITM_ALL		; アイテム系ウインドウ・１アイテム表示
	RET
WIDITMWD_DRAW	ENDP


;	アイテム系ウインドウ・１アイテム表示
;	-I-   WDINO      : アイテムオフセット
;	      WDILIST    : スタイルリストオフセット
;	      WD_DSPXX   : ウインドウＸ位置
;	      WD_DSPYY   : ウインドウＹ位置
;	-I/O- WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_ALL	PROC	NEAR

	MOV	BX,WDILIST		; スタイルリストオフセット

	MOVX	D_ITM_PRAM ,DS:[BX][I_ITEM_PRAM] ; パラメータ数
	MOVX	D_ITM_WORDS,DS:[BX][I_ITEM_WORDS]; パラメータＷＯＲＤ数

	ADD	BX,I_ITEM_P_TOP		; パラメータスタイル先頭
	MOV	D_ITM_TOP,BX		; パラメータスタイル先頭

	MOVX	D_ITM_ADRS,WDINO	; アイテムオフセット

	MOV	REC_NO,0		; パラメータレコード
WIDITM_ALL_LOOP:			;
	MOV	AX,REC_NO		;
	CMP	AX,D_ITM_PRAM		; パラメータ数
	JE	WIDITM_ALL_LOOP_E	;
	CMP	AX,D_ITM_MAXSET		; パラメータ数制限
	JE	WIDITM_ALL_LOOP_E	;

	CALL	WIDITM_PAR		; パラメータ表示

	INC	REC_NO			; パラメータレコード
	JMP	WIDITM_ALL_LOOP		;
WIDITM_ALL_LOOP_E:			;
	RET
WIDITM_ALL	ENDP


;	絵を表示する
;	-I-   D_ITM_ADRS : アイテムオフセット
;	      WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_PICTUER	PROC	NEAR
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOVX	PR_DSPVAL,ES:[BX]		; 表示（文字列のアドレス）

	MOV	ES,SEGWID		;
	MOV	DI,WIDOFS_ENVIR		; 環境テーブル
	MOV	BX,ES:[DI][0]		; BX=環境文字テーブルの先頭です

	MOV	DX,PR_DSPVAL		; アイテム名が入っています
	MOV	PIC_NUMBER,0		; アイテム絵番号
	MOV	SI,0			; word pointer.
	MOV	CX,38			; アイテム数
WIDITM_PICTUER_LP:
	INC	PIC_NUMBER		; アイテム絵番号
	MOV	DI,DS:PIC_TABLE[SI]	; どのアイテムかを調べます
	INC	SI			;
	INC	SI			;
	SHL	DI,1			; word pointer.
	CMP	DX,ES:[BX][DI]		;
	JE	WIDITM_PICTUER_5	; 一致しました!
	LOOP	WIDITM_PICTUER_LP	;

	MOV	PIC_NUMBER,22		; アイテム絵番号 22無効＝証書
	JMP	WIDITM_PICTUER_5	;無し


WIDITM_PICTUER_5:
	MOV	AX,WD_DSP_SXX		; パラメータ表示Ｘ位置
	MOV	BX,WD_DSP_SYY		; パラメータ表示Ｙ位置
	ADD	BX,16			; １段下げる
	MOV	DX,PIC_NUMBER		; アイテム絵番号
	CALLC	PT_PUT_ITEM		; アイテムＰＵＴ

	RET
WIDITM_PICTUER	ENDP



;	パラメータ表示
;	-I-   REC_NO     : パラメータレコード
;	      WD_DSPXX   : ウインドウＸ位置
;	      WD_DSPYY   : ウインドウＹ位置
;	-I/O- D_ITM_TOP  : パラメータスタイル先頭
;	      D_ITM_ADRS : アイテムオフセット
;	      WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_PAR	PROC	NEAR
	MOV	BX,D_ITM_TOP			; パラメータスタイル先頭
	MOV	AX,DS:[BX]			; パラメータタイプ

	CMP	AX,S_TYP_NOP			; 0=何もない
	JE	WIDITM_PAR_T0			;
	CMP	AX,S_TYP_NAME			; 1=名前
	JE	WIDITM_PAR_T1			;
	CMP	AX,S_TYP_STR			; 2=文字列
	JE	WIDITM_PAR_T2			;
	CMP	AX,S_TYP_GOLD			; 3=通貨
	JE	WIDITM_PAR_T3			;
	CMP	AX,S_TYP_GRAP			; 4=文字列と数値(ｸﾞﾗﾌ)
	JE	WIDITM_PAR_T4			;
	CMP	AX,S_TYP_VAL			; 5=数値
	JE	WIDITM_PAR_T5			;
	CMP	AX,S_TYP_AGE			; 6=年齢
	JE	WIDITM_PAR_T6			;
	CMP	AX,S_TYP_HELP			; 7=説明
	JE	WIDITM_PAR_T0			;none

	JMP	WIDITM_PAR_EXIT			;

WIDITM_PAR_T0:					; 何もない
	ADD	D_ITM_ADRS,2			; アイテムオフセット
	ADD	D_ITM_TOP,4			; パラメータスタイル先頭
	JMP	WIDITM_PAR_EXIT			;

WIDITM_PAR_T1:					;
	CALL	WIDITM_PICTUER			; 絵を表示する
	CALL	WIDITM_NM			; 名前を表示する
	JMP	WIDITM_PAR_EXIT			;
WIDITM_PAR_T2:					;
	CALL	WIDITM_STR			; 文字列を表示する
	JMP	WIDITM_PAR_EXIT			;
WIDITM_PAR_T3:					;
	CALL	WIDITM_GOLD			; 通貨を表示する
	JMP	WIDITM_PAR_EXIT			;
WIDITM_PAR_T4:					;
	CALL	WIDITM_GRPH			; 文字列と数値
	JMP	WIDITM_PAR_EXIT			;
WIDITM_PAR_T5:					;
	CALL	WIDITM_VALUE			; 数値
	JMP	WIDITM_PAR_EXIT			;
WIDITM_PAR_T6:					;
	CALL	WIDITM_AGE			; 年齢
	JMP	WIDITM_PAR_EXIT			;
WIDITM_PAR_EXIT:
	RET
WIDITM_PAR	ENDP



;	名前を表示する
;	-I/O- D_ITM_TOP  : パラメータスタイル先頭
;	      D_ITM_ADRS : アイテムオフセット
;	      WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_NM	PROC	NEAR
	MOVX	PR_DSPXX,WD_DSP_SXX		; パラメータ表示Ｘ位置
	MOVX	PR_DSPYY,WD_DSP_SYY		; パラメータ表示Ｙ位置

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOVX	PR_DSPVAL,ES:[BX]		; 表示（文字列のアドレス）
	CALL	WIDITM_STRINGS			; 文字列の表示

	ADD	WD_DSP_SXX,4			; パラメータ表示Ｙ位置

	ADD	WD_DSP_SYY,16			; パラメータ表示Ｙ位置
	ADD	D_ITM_ADRS,2			; アイテムオフセット
	ADD	D_ITM_TOP,4			; パラメータスタイル先頭
	RET
WIDITM_NM	ENDP


;	文字列を表示する
;	-I/O- D_ITM_TOP  : パラメータスタイル先頭
;	      D_ITM_ADRS : アイテムオフセット
;	      WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_STR	PROC	NEAR
	MOVX	PR_DSPXX,WD_DSP_SXX		; パラメータ表示Ｘ位置
	MOVX	PR_DSPYY,WD_DSP_SYY		; パラメータ表示Ｙ位置

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOV	CX,ES:[BX]			; 表示値
	WD_CMP		ID_00,CX		; 無効か？
	JE	WIDITM_STR_55			;

	MOV	SI,OFFSET MSG_YOU_TEN		; 「要、」
	CALL	STRING_PUT			; 注目文字列ＰＵＴ

	ADD	PR_DSPXX,4			; パラメータ表示Ｘ位置

WIDITM_STR_55:
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOVX	PR_DSPVAL,ES:[BX]		; 表示（文字列のアドレス）
	CALL	WIDITM_STRINGS			; 文字列の表示

	ADD	WD_DSP_SYY,16			; パラメータ表示Ｙ位置
	ADD	D_ITM_ADRS,2			; アイテムオフセット
	ADD	D_ITM_TOP,4			; パラメータスタイル先頭
	RET
WIDITM_STR	ENDP


;	通貨を表示する
;	-I-   WD_DSPXX   : ウインドウＸ位置
;	      WD_DSPYY   : ウインドウＹ位置
;	-I/O- D_ITM_TOP  : パラメータスタイル先頭
;	      D_ITM_ADRS : アイテムオフセット
;	      WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_GOLD	PROC	NEAR
;*NON*;	MOVX	PR_DSPXX,WD_DSPXX		; ウインドウＸ位置
;*NON*;	MOVX	PR_DSPYY,WD_DSPYY		; ウインドウＹ位置

	MOVX	PR_DSPXX,WD_DSP_SXX		; パラメータ表示Ｘ位置
	MOVX	PR_DSPYY,WD_DSP_SYY		; パラメータ表示Ｙ位置

;*NON*;	ADD	PR_DSPXX,4*2			; 表示Ｘ位置

	MOV	AX,PR_DSPCSZ2			; 文字表示サイズ
	CALLC	VTXSIZ				; character size set.
	MOV	AX,PR_DSPCLR2			; 文字表示色
	CALLC	VTXCOL				; character color set.

;*NON*;	MOV	BX,D_ITM_TOP			; パラメータスタイル先頭
;*NON*;	MOV	SI,DS:[BX][2]			; パラメータタイプ
;*NON*;
;*NON*;	MOV	AX,PR_DSPXX			; 表示Ｘ位置 パラメータ名
;*NON*;	MOV	BX,PR_DSPYY			; 表示Ｙ位置
;*NON*;	CALLC	VTXPOR				; vram text print OR.

;*;	MOV	AX,PR_DSPCLR3			; 数値表示色
;*;	CALLC	MITCOL				; mini string color.
;*;	MOV	AX,PR_DSPXX			; 表示Ｘ位置
;*;	MOV	BX,PR_DSPYY			; 表示Ｙ位置
;*;	MOV	SI,OFFSET MSG_PRICE		; "price"
;*;	CALLC	MDTPRN				; MID string.
;*;	ADD	PR_DSPXX,5			; 表示Ｘ位置

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOVX	PR_DSPVAL,ES:[BX]		; 表示値
	MOV	PR_DSPUNIT,UNIT_GOLD		; 単位系 通貨
	CALL	WIDVALDSP			; 表示値表示

	ADD	WD_DSP_SYY,16			; パラメータ表示Ｙ位置
	ADD	D_ITM_ADRS,2			; アイテムオフセット
	ADD	D_ITM_TOP,4			; パラメータスタイル先頭
	RET
WIDITM_GOLD	ENDP


;	文字列と数値
;	-I/O- D_ITM_TOP  : パラメータスタイル先頭
;	      D_ITM_ADRS : アイテムオフセット
;	      WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_GRPH	PROC	NEAR
	MOVX	PR_DSPXX,WD_DSP_SXX		; パラメータ表示Ｘ位置
	MOVX	PR_DSPYY,WD_DSP_SYY		; パラメータ表示Ｙ位置

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOVX	PR_DSPVAL,ES:[BX]		; 表示（文字列のアドレス）

	MOV	SI,ES:[BX]			; 表示（文字列のアドレス）
	MOV	AX,ES:[SI]			;
	CMP	AX,WORD PTR WD_NONE_CHR		; WINDOWS/無効キャラクタ
	JE	WIDITM_GRPH_SKIP		;

	CALL	WIDITM_STRINGS			; 文字列の表示

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOVX	PR_DSPVAL,ES:[BX][2]		; 表示値
	ADD	PR_DSPXX,8			; 表示Ｘ位置
	MOV	PR_DSPUNIT,UNIT_NONE		; 単位系 無し
	CALL	WIDVALDSP			; 表示値表示

	ADD	WD_DSP_SYY,16			; パラメータ表示Ｙ位置
WIDITM_GRPH_SKIP:
	ADD	D_ITM_ADRS,4			; アイテムオフセット
	ADD	D_ITM_TOP,4			; パラメータスタイル先頭
	RET
WIDITM_GRPH	ENDP



;	数値
;	-I/O- D_ITM_TOP  : パラメータスタイル先頭
;	      D_ITM_ADRS : アイテムオフセット
;	      WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_VALUE	PROC	NEAR
	MOVX	PR_DSPXX,WD_DSP_SXX		; パラメータ表示Ｘ位置
	MOVX	PR_DSPYY,WD_DSP_SYY		; パラメータ表示Ｙ位置

	MOV	AX,PR_DSPCSZ2			; 文字表示サイズ
	CALLC	VTXSIZ				; character size set.
	MOV	AX,PR_DSPCLR2			; 文字表示色
	CALLC	VTXCOL				; character color set.

	MOV	BX,D_ITM_TOP			; パラメータスタイル先頭
	MOV	SI,DS:[BX][2]			; パラメータタイプ

	MOV	AX,PR_DSPXX			; 表示Ｘ位置 パラメータ名
	MOV	BX,PR_DSPYY			; 表示Ｙ位置
	CALLC	VTXPOR				; vram text print OR.

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOVX	PR_DSPVAL,ES:[BX]		; 表示値
	ADD	PR_DSPXX,8			; 表示Ｘ位置
	MOV	PR_DSPUNIT,UNIT_NONE		; 単位系 無し
	CALL	WIDVALDSP			; 表示値表示

	ADD	WD_DSP_SYY,16			; パラメータ表示Ｙ位置
	ADD	D_ITM_ADRS,2			; アイテムオフセット
	ADD	D_ITM_TOP,4			; パラメータスタイル先頭
	RET
WIDITM_VALUE	ENDP


;	年齢
;	-I/O- D_ITM_TOP  : パラメータスタイル先頭
;	      D_ITM_ADRS : アイテムオフセット
;	      WD_DSP_SXX : パラメータ表示Ｘ位置
;	      WD_DSP_SYY : パラメータ表示Ｙ位置

WIDITM_AGE	PROC	NEAR
	MOVX	PR_DSPXX,WD_DSP_SXX		; パラメータ表示Ｘ位置
	MOVX	PR_DSPYY,WD_DSP_SYY		; パラメータ表示Ｙ位置

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOV	AX,ES:[BX]			; 表示値（年齢）
	CMP	AX,0				; 無効の年齢
	JE	WIDITM_AGE_SKIP			;

	MOV	AX,PR_DSPCSZ2			; 文字表示サイズ
	CALLC	VTXSIZ				; character size set.
	MOV	AX,PR_DSPCLR2			; 文字表示色
	CALLC	VTXCOL				; character color set.

	MOV	BX,D_ITM_TOP			; パラメータスタイル先頭
	MOV	SI,DS:[BX][2]			; パラメータタイプ

	MOV	AX,PR_DSPXX			; 表示Ｘ位置 パラメータ名
	MOV	BX,PR_DSPYY			; 表示Ｙ位置
	CALLC	VTXPOR				; vram text print OR.

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,D_ITM_ADRS			; アイテムオフセット
	MOVX	PR_DSPVAL,ES:[BX]		; 表示値
	ADD	PR_DSPXX,8			; 表示Ｘ位置
	MOV	PR_DSPUNIT,UNIT_ARGE		; 単位系 年齢
	CALL	WIDVALDSP			; 表示値表示

	ADD	WD_DSP_SYY,16			; パラメータ表示Ｙ位置
WIDITM_AGE_SKIP:				;
	ADD	D_ITM_ADRS,2			; アイテムオフセット
	ADD	D_ITM_TOP,4			; パラメータスタイル先頭
	RET
WIDITM_AGE	ENDP





;*;;	アイテム系ウインドウタイトル
;*;;	-I-   WDINO      : アイテムオフセット
;*;;	      WDILIST    : スタイルリストオフセット
;*;;	      WD_DSPXX   : ウインドウＸ位置
;*;;	      WD_DSPYY   : ウインドウＹ位置
;*;;	-I/O- WD_DSP_SXX : パラメータ表示Ｘ位置
;*;;	      WD_DSP_SYY : パラメータ表示Ｙ位置
;*;
;*;WIDITM_TITLE	PROC	NEAR
;*;	MOVX	PR_DSPXX,WD_DSPXX	; ウインドウＸ位置
;*;	MOVX	PR_DSPYY,WD_DSPYY	; ウインドウＹ位置
;*;
;*;	MOV	AX,PR_DSPCSZ2		; 文字表示サイズ
;*;	CALLC	VTXSIZ			; character size set.
;*;
;*;	MOV	AX,PR_DSPCLR2		; 文字表示色
;*;	CALLC	VTXCOL			; character color set.
;*;
;*;	MOV	BX,WDILIST		; スタイルリストオフセット
;*;	MOVX	D_ITM_A_NM,DS:[BX][I_ITEM_A_NM] ; アイテム種別名
;*;	MOV	SI,D_ITM_A_NM		;
;*;
;*;	MOV	AX,PR_DSPXX		; 表示Ｘ位置
;*;	MOV	BX,PR_DSPYY		; 表示Ｙ位置
;*;	CALLC	VTXPOR			; vram text print OR.
;*;
;*;	ADD	WD_DSP_SYY,16		; パラメータ表示Ｙ位置
;*;
;*;	RET
;*;WIDITM_TITLE	ENDP



;	文字列の表示
;	-I- PR_DSPVAL : 表示内容（文字列のアドレス）
;	    PR_DSPXX  : 表示Ｘ位置
;	    PR_DSPYY  : 表示Ｙ位置
;	    PR_DSPCLR2: 内容文字表示色
;	    PR_DSPCSZ2: 内容文字表示サイズ

WIDITM_STRINGS	PROC	NEAR
	PUSH	ES			;
	PUSH	BX			;

	CALLC	STRCLEAR		; 文字列バッファクリア

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ

	MOV	SI,PR_DSPVAL		; 表示値（文字列のアドレス）
	MOV	CX,WIDITM_NM_LEN	; アイテム文字最大長さ
	CALLC	STRSET			; 文字列バッファセット

	MOV	STR_BUFF[WIDITM_NM_LEN],WORD PTR 0 ; EOS

	MOV	AX,PR_DSPCSZ2		; 文字表示サイズ
	CALLC	VTXSIZ			; character size set.

	MOV	AX,PR_DSPCLR2		; 文字表示色
	CALLC	VTXCOL			; character color set.

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	VTXPOR			; vram text print OR.

	POP	BX			;
	POP	ES			;
	RET
WIDITM_STRINGS	ENDP




;	アイテム表示のフレーム
;	-I- WD_DSPXX : ウインドウＸ位置
;	    WD_DSPYY : ウインドウＹ位置
;	    WD_DSP_LXX : ウインドウＸ長さ
;	    WD_DSP_LYY : ウインドウＹ長さ

WIDITM_FLAME	PROC	NEAR
	CALL	WIDITM_CLR		; 表示エリアクリア

	MOVX	WDX1,WD_DSPXX		; ウインドウＸ位置
	MOVX	WDY1,WD_DSPYY		; ウインドウＹ位置
	MOVX	WDX2,WD_DSP_LXX		; ウインドウＸ長さ
	MOVX	WDY2,WD_DSP_LYY		; ウインドウＹ長さ

	SUB	WDX1,1			;
	SUB	WDY1,8-2		;
	ADD	WDX2,2			;
	ADD	WDY2,10+2		;
	CALLC	WID_1_FLAME		; WINDOWS/フレーム１
	RET

;*NON*;	MOV	AX,WD_DSPXX		; ウインドウＸ位置
;*NON*;	MOV	VX1,AX			;
;*NON*;	ADD	AX,WD_DSP_LXX		; ウインドウＸ長さ
;*NON*;	DEC	AX			;
;*NON*;	MOV	VX2,AX			;
;*NON*;
;*NON*;	MOV	AX,WD_DSPYY		; ウインドウＹ位置
;*NON*;	MOV	VY1,AX			;
;*NON*;	ADD	AX,WD_DSP_LYY		; ウインドウＹ長さ
;*NON*;	DEC	AX			;
;*NON*;	MOV	VY2,AX			;
;*NON*;
;*NON*;	ADD	VX1,1			;
;*NON*;	ADD	VX2,1			;
;*NON*;	ADD	VY1,8			;
;*NON*;	ADD	VY2,8			;
;*NON*;	MOV	CX,W_COL4		; カラー・黒
;*NON*;	CALL	BOXMSS			; ＢＯＸメッシュ
;*NON*;	SUB	VX1,1			;
;*NON*;	SUB	VX2,1			;
;*NON*;	SUB	VY1,8			;
;*NON*;	SUB	VY2,8			;
;*NON*;
;*NON*;	MOV	CX,W_COL3		; カラー・暗い灰
;*NON*;	CALL	BOXPAL			; ＢＯＸペイント
;*NON*;	MOV	CX,1			;
;*NON*;	CALL	BOXMSS			; ＢＯＸメッシュ

	RET
WIDITM_FLAME	ENDP



;	表示エリアクリア
;	-I- WD_DSPXX   : ウインドウＸ位置
;	    WD_DSPYY   : ウインドウＹ位置
;	    WD_DSP_LXX : ウインドウＸ長さ
;	    WD_DSP_LYY : ウインドウＹ長さ

WIDITM_CLR	PROC	NEAR
	MOV	AX,WD_DSPXX		; ウインドウＸ位置
	MOV	VX1,AX			;
	ADD	AX,WD_DSP_LXX		; ウインドウＸ長さ
	DEC	AX			;
	MOV	VX2,AX			;

	MOV	AX,WD_DSPYY		; ウインドウＹ位置
	MOV	VY1,AX			;
	ADD	AX,WD_DSP_LYY		; ウインドウＹ長さ
	DEC	AX			;
	MOV	VY2,AX			;
	MOV	CX,0000B		;
	CALLC	BOXPAL			; ＢＯＸペイント

	RET
WIDITM_CLR	ENDP



;	表示値表示
;	-I- PR_DSPVAL : 表示値
;	    PR_DSPXX  : 表示Ｘ位置
;	    PR_DSPYY  : 表示Ｙ位置
;	    PR_DSPCLR3: 数値表示色
;	    PR_DSPCSZ3: 数値文字表示サイズ
;	    PR_DSPUNIT: 内容表示 内容の単位系

WIDVALDSP	PROC	NEAR
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ

	MOVX	WDP_VAL,PR_DSPVAL	; WINDOWS/内容表示値
	MOVX	WDP_UNIT,PR_DSPUNIT	; WINDOWS/内容表示単位系
	CALLC	WID_UNIT		; WINDOWS/単位別文字列化

;*NON*;	MOV	AX,PR_DSPCSZ3		; 数値文字表示サイズ
;*NON*;	CALLC	VTXSIZ			; character size set.
;*NON*;
;*NON*;	MOV	AX,PR_DSPCLR3		; 数値表示色
;*NON*;	CALLC	VTXCOL			; character color set.

	MOV	AX,PR_DSPCLR3		; 数値表示色
	CALLC	MITCOL			; mini string color.

	MOV	AX,PR_DSPUNIT		; 内容表示 単位系
	CMP	AX,UNIT_ARGE		; 単位系 年齢
	JE	WIDVALDSP_ZEN		;

	MOV	AX,PR_DSPUNIT		; 内容表示 単位系
	CMP	AX,UNIT_GOLD		; 単位系 通貨
	JE	WIDVALDSP_ZEN		;

WIDVALDSP_HAN:
	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	MDTPRN			; MID string. (null=end of string)
;*NON*;	CALLC	VTXPOR			; vram text print OR.
	JMP	WIDVALDSP_EXIT		;
WIDVALDSP_ZEN:
	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	MBTPRN			; BIG string. (null=end of string)
	JMP	WIDVALDSP_EXIT		;
WIDVALDSP_EXIT:
	RET
WIDVALDSP	ENDP


;	注目文字列ＰＵＴ
;	-I- DS:SI : 文字列バッファ
;	    PR_DSPXX  : 表示Ｘ位置
;	    PR_DSPYY  : 表示Ｙ位置

STRING_PUT	PROC	NEAR
	PUSH	SI
	MOV	AX,PR_DSPCSZ4		; 注目文字表示サイズ
	CALLC	VTXSIZ			; character size set.
	MOV	AX,PR_DSPCLR4		; 注目表示色
	CALLC	VTXCOL			; character color set.
	POP	SI

	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	CALLC	VTXPOR			; vram text print OR.
	RET
STRING_PUT	ENDP



;	文字ＩＤアドレスＧＥＴ
;	-I- CX : ＩＤ
;	-O- SI : 環境文字アドレス

ID_TO_ADRS	PROC	NEAR
	SHL	CX,1				; word.
	MOV	ES,SEGWID			;
	MOV	DI,WIDOFS_ENVIR			; 環境テーブル
	MOV	BX,ES:[DI]			;
	ADD	BX,CX				;
	MOV	SI,ES:[BX]			;
	RET
ID_TO_ADRS	ENDP


WINDOW	ENDS




DATA	SEGMENT	PUBLIC	'DATA'

WIDITM_UP	DW	0		; 内容表示 描画開始位置
WIDITM_CNT	DW	9		; 内容表示 描画本数
WIDITM_START	DW	0		; 内容表示 描画開始番号
WIDITM_END	DW	8		; 内容表示 描画終了番号

WIDITM_CNTX	DW	3		; 内容表示 Ｘ並び数
WIDITM_CNTY	DW	5		; 内容表示 Ｙ並び数

LOCATE_HIGHT	DW	8		; 表示ライン１本の高さ
LINE_WIDTH	DW	16		; パラメータ表示１本の長さ
LINE_HIGHT	DW	16		; パラメータ表示１本の高さ

G_COL1		DW	8		; グラフカラー
PNTNUM		DW	0		; スタイルリストポインタ

WD_DSPXX	DW	0		; ウインドウＸ位置
WD_DSPYY	DW	0		; ウインドウＹ位置
WD_DSP_LXX	DW	0		; ウインドウＸ長さ
WD_DSP_LYY	DW	0		; ウインドウＹ長さ
WD_DSP_SXX	DW	0		; パラメータ表示Ｘ位置
WD_DSP_SYY	DW	0		; パラメータ表示Ｙ位置

PR_DSPXX	DW	0		; 表示Ｘ位置
PR_DSPYY	DW	0		; 表示Ｙ位置
PR_DSPVAL	DW	0		; 内容表示値
PR_DSPCLR2	DW	15		; 文字表示色
PR_DSPCSZ2	DW	0		; 文字表示サイズ
PR_DSPCLR3	DW	15		; 数値表示色
PR_DSPCSZ3	DW	0		; 数値文字表示サイズ
PR_DSPCLR4	DW	15		; 注目表示色
PR_DSPCSZ4	DW	0		; 注目文字表示サイズ
PR_DSPUNIT	DW	0		; 内容表示 単位系

PIC_NUMBER	DW	0		; アイテム絵番号

D_ITM_A_NM	DW	0		; アイテム種別名
D_ITM_PRAM	DW	0		; パラメータ数
D_ITM_WORDS	DW	0		; パラメータＷＯＲＤ数
D_ITM_TOP	DW	0		; パラメータスタイル先頭
D_ITM_ADRS	DW	0		; アイテムオフセット

D_ITM_MAXSET	DW	100		; パラメータ数制限

REC_NO		DW	0		; パラメータレコード

MAX_X		DW	0		; 最大Ｘ
MAX_Y		DW	0		; 最大Ｙ

GOLD_VAL	DW	0		; お金


;	ウインドウロケーションテーブル

WD_ITM_LCT_NUM	DW	0			; アイテムウインドウ配置番号
WD_ITM_LCT_PNT	DW	0			; アイテムオープン番号
WD_ITM_LCT_OFX	DW	2			; ロケーションＸオフセット
WD_ITM_LCT_OFY	DW	1			; ロケーションＹオフセット

WD_ITM_LCT_MAX	DW	13,12,4			; アイテムウインドウ最大数

WD_ITM_LCT_XX_TBL DW	WD_ITM_LCT_XX,WD_ITM_LCT_XX2	; ロケーションＸ
		DW	WD_ITM_LCT_XX3
WD_ITM_LCT_YY_TBL DW	WD_ITM_LCT_YY,WD_ITM_LCT_YY2	; ロケーションＹ
		DW	WD_ITM_LCT_YY3
WD_ITM_LCT_XX	LABEL	BYTE			; ロケーションＸ
	DB	 0, 0, 0, 0, 0
	DB	16,16,16
;*;	DB	16,16,16,16,16
	DB	32,32,32,32,32
WD_ITM_LCT_YY	LABEL	BYTE			; ロケーションＹ
	DB	0, 7+1,14+2,21+3,28+4
	DB	14+2,21+3,28+4
;*;	DB	13,17,21,25,29
	DB	0, 7+1,14+2,21+3,28+4
WD_ITM_LCT_XX2	LABEL	BYTE			; ロケーションＸ
	DB	00,16,32
	DB	00,16,32
	DB	00,16,32
	DB	00,16,32
WD_ITM_LCT_YY2	LABEL	BYTE			; ロケーションＹ
	DB	20  ,20  ,20
	DB	28  ,28  ,28
	DB	12  ,12  ,12
	DB	4   ,4   ,4
WD_ITM_LCT_XX3	LABEL	BYTE			; ロケーションＸ
	DB	5,5
	DB	26,26
WD_ITM_LCT_YY3	LABEL	BYTE			; ロケーションＹ
	DB	16  ,26
	DB	20  ,28

PIC_TABLE	LABEL	WORD
	DW	ID_26			; 01ナイフ		
	DW	ID_27			; 02こん棒		
	DW	ID_28			; 03メイス		
	DW	ID_29			; 04ショートソード	
	DW	ID_30			; 05ロングソード	
	DW	ID_31			; 06バトルアックス	
	DW	ID_32			; 07カタナ		
	DW	ID_33			; 08皮の帽子	
	DW	ID_34			; 09鉄兜		
	DW	ID_35			; 10鉄仮面		
	DW	ID_36			; 11皮鎧		
	DW	ID_37			; 12鎖かたびら	
	DW	ID_38			; 13鉄の鎧		
	DW	ID_39			; 14ビキニの鎧	
	DW	ID_41			; 15薬草		
	DW	ID_42			; 16ぬいぐるみ	
	DW	ID_43			; 17かわいい便箋	
	DW	ID_44			; 18本		
	DW	ID_45			; 19詩集		
	DW	ID_46			; 20ティーカップ	
	DW	ID_47			; 21ドレス		

	DW	ID_00			; 22無効＝証書

	DW	ID_52			; 23宿屋		
	DW	ID_54			; 24武器屋		
	DW	ID_55			; 25教会		
	DW	ID_57			; 26医者		
	DW	ID_60			; 27代筆屋		
	DW	ID_53			; 28酒屋		
	DW	ID_61			; 29狩人		
	DW	ID_58			; 30あやしい宿屋	
	DW	ID_56			; 31メイド		
	DW	ID_62			; 32木コリ		
	DW	ID_59			; 33あやしい酒場	
	DW	ID_63			; 34人足		

	DW	ID_65			; 35武芸		
	DW	ID_66			; 36学問		
	DW	ID_67			; 37礼法		
	DW	ID_68			; 38武者修行	

;*;MSG_PRICE	DB	"price",0

MSG_YOU_TEN	DB	"要、",0		; 「要、」


;	教育一覧表示

ADRS_KYOIKU_TBL	DW	0			; 教育一覧アドレス

WD_NAME_ID	DW	0			; 名前ＩＤ
WD_STYLE	DW	0			; スタイル

TBL_BUGEI	LABEL	WORD			; 武芸
		DW	35			;0 絵の番号
		DW	10+2+4			;2 Ｘ
		DW	64			;4 Ｙ
		DW	ID_65			;6 武芸
		DW	2			;8 スタイル
		DW	PRICE_SHOKYU		;10 初級値段
		DW	PRICE_CHUKYU		;12 中級値段
		DW	PRICE_JOHKYU		;14 上級値段

TBL_GAKUMON	LABEL	WORD			; 学問
		DW	36			; 絵の番号
		DW	10+2+4			; Ｘ
		DW	64			; Ｙ
		DW	ID_66			; 学問
		DW	2			; スタイル
		DW	PRICE_SHOKYU		; 初級値段
		DW	PRICE_CHUKYU		; 中級値段
		DW	PRICE_JOHKYU		; 上級値段

TBL_REIHO	LABEL	WORD			; 礼法
		DW	37			; 絵の番号
		DW	10+2			; Ｘ
		DW	64-16			; Ｙ
		DW	ID_67			; 礼法
		DW	1			; スタイル
		DW	PRICE_REIHOU		; 礼法値段

TBL_MUSYA	LABEL	WORD			; 武者修行
		DW	38			; 絵の番号
		DW	10+2			; Ｘ
		DW	64-16			; Ｙ
		DW	ID_68			; 武者修行
		DW	0			; スタイル

DATA	ENDS

	END
;
;	end of "WIDITM.ASM"
;
