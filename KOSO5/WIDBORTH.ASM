; "WIDBORTH.ASM" PC-9801UV11 make by R.H 1991/04/18
;
;
;	「子育て」
;
;	誕生日ウインドウ
;
;
;	WIDBORTH_INIT			; WINDOWS/誕生日ウインドウ初期処理
;	WIDBORTH_SYSOPEN		; WINDOWS/誕生日システムウインドウ
;	WIDBORTH_SET			; WINDOWS/誕生日ウインドウ実行
;
;
; (C) 1990,1991 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO4\WORDID.INC

OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味

CLEND_OFST_X	EQU	5			; 表示・カレンダーＸ開始位置
CLEND_OFST_Y	EQU	34			; 表示・カレンダーＹ開始位置

CLEND_STEP_X	EQU	25			; 表示・カレンダーＸ開始位置
CLEND_STEP_Y	EQU	88			; 表示・カレンダーＹ開始位置

CLEND_HANI_X	EQU	20			; 表示・カレンダーＸ範囲
CLEND_HANI_Y	EQU	80			; 表示・カレンダーＹ範囲

CLEND_NARABI_X	EQU	3			; 表示・カレンダーＸ並び
CLEND_NARABI_Y	EQU	4			; 表示・カレンダーＹ並び

CLM_DAYS_MAX_X	EQU	7			; 表示・カレンダー日・数Ｘ
CLM_DAYS_MAX_Y	EQU	5			; 表示・カレンダー日・数Ｙ

OFS_HEAD_XX	EQU	9			; 表示・カレンダーヘッダＸ
OFS_HEAD_YY	EQU	0			; 表示・カレンダーヘッダＹ

HIGHT_DAYS_STR	EQU	13			; 表示・カレンダー日・高さ
WIDTH_DAYS_STR	EQU	3			; 表示・カレンダー日・幅

HIGHT_HEAD_STR	EQU	13			; 表示・カレンダーヘッダ・高さ

CLM_CLND_CNT_X	EQU	7			; カレンダー並び数Ｘ
CLM_CLND_CNT_Y	EQU	6			; カレンダー並び数Ｙ


COLOR_MONTH	EQU	15			; 月色
COLOR_BLUEDAY	EQU	15			; 平日色
COLOR_HOLIDAY	EQU	4			; 休み色
COLOR_DATESET	EQU	15			; 日付色

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

; ****************************************************
;	ＷＳＥＬＥＣＴ	＜指定文字列＞
;	SELECT	"話す,渡す,行く"
;	結果は WIDSNM （ユーザ選択番号）に反映される
;	             : =FFFFH : 指定なし
; ****************************************************

WSELECT	MACRO	SSSS
	LOCAL	L1,L2
	JMP	L2
DATA	SEGMENT	PUBLIC	'DATA'
	EXTRN	WIDSNM:WORD		; セレクト・ウインドウ／ユーザ選択番号
L1	DB	SSSS,0
DATA	ENDS
L2:
	MOV	AX,DS			; テキストバッファセグメント
	MOV	ES,AX			;
	MOV	BX,OFFSET L1		; 表示単語アドレス
	CALL	WWWIDSLC2		; セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	ENDM


MOVE_SET	MACRO	SOUID,DESTID,X1,Y1,X2,Y2,X3,Y3
	MOV	AX,WORD PTR SOUID[0]
	MOV	SSSOU0,AX
	MOV	AX,WORD PTR SOUID[2]
	MOV	SSSOU1,AX
	MOV	AX,WORD PTR SOUID[4]
	MOV	SSSOU2,AX
	MOV	AX,WORD PTR SOUID[6]
	MOV	SSSOU3,AX
	MOV	AX,WORD PTR DESTID[0]
	MOV	SSDES0,AX
	MOV	AX,WORD PTR DESTID[2]
	MOV	SSDES1,AX
	MOV	AX,WORD PTR DESTID[4]
	MOV	SSDES2,AX
	MOV	AX,WORD PTR DESTID[6]
	MOV	SSDES3,AX
	MOV	AX,X1
	MOV	WORD PTR VX1,AX
	MOV	AX,Y1
	MOV	WORD PTR VY1,AX
	MOV	AX,X2
	MOV	WORD PTR VX2,AX
	MOV	AX,Y2
	MOV	WORD PTR VY2,AX
	MOV	AX,X3
	MOV	WORD PTR VX3,AX
	MOV	AX,Y3
	MOV	WORD PTR VY3,AX
	ENDM


;	ＰＲＸＹＺ	文字列,ＶＡＬ,文字列2,ＶＡＬ2,文字列3,ＶＡＬ3
;	（改行有りワード値プリント１０進）

PRXYZ	MACRO	STRING,PARAM,STRING2,PARAM2,STRING3,PARAM3
	LOCAL	L1,L2,L3,L4
	PUSH	SI
	PUSH	DX
	JMP	L4
DATA	SEGMENT	PUBLIC	'DATA'
	EVEN
L1	DB	STRING,0
L2	DB	STRING2,0
L3	DB	STRING3,0
	EVEN
DATA	ENDS

L4:	MOV	SI,OFFSET L1
	CALL	PRINT
	MOV	DX,PARAM
	CALL	DECSTR
	CALL	PRINT
	MOV	SI,OFFSET L2
	CALL	PRINT
	MOV	DX,PARAM2
	CALL	DECSTR
	CALL	PRINT
	MOV	SI,OFFSET L3
	CALL	PRINT
	MOV	DX,PARAM3
	CALL	DECSTR
	CALL	PRINT
	POP	DX
	POP	SI
	CALL	LFPRN	; line feed.
	ENDM


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
;	WINDOWS/誕生日ウインドウ初期処理
; ****************************************************

FUNC	WWIDBORTH_INIT,WIDBORTH_INIT
	RET
FEND	WWIDBORTH_INIT


; ****************************************************
;	WINDOWS/誕生日システムウインドウ
;	-O- AX : 0=通常,1=データロード
; ****************************************************

FUNC	WWIDBORTH_SYSOPEN,WIDBORTH_SYSOPEN
	CALLC	PT_OPEN_ALL_LD		; オープニング全ロード

	MOV	DX,16			;
	CALLC	PT_PALET_ST		; パレットのセット

	CALLC	RANDAM_STR		; 乱数スタート

WIDBORTH_SYSOPEN_LOOP:
	WSELECT	"ゲームスタート,画 面 モード,データロード"
	CMP	WIDSNM,0		;
	JE	WIDBORTH_SYSOPEN_GAME	;
	CMP	WIDSNM,1		;
	JE	WIDBORTH_SYSOPEN_MODE	;
	CMP	WIDSNM,2		;
	JE	WIDBORTH_SYSOPEN_LOAD	;
	JMP	WIDBORTH_SYSOPEN_LOOP	;

WIDBORTH_SYSOPEN_GAME:			;
	CALL	OPENING_SET		; ゲーム名前と誕生日の設定
	JMP	WIDBORTH_SYSOPEN_EXIT	;
WIDBORTH_SYSOPEN_MODE:
	CALL	MENU_SETUP		; セットアップメニュー
	JMP	WIDBORTH_SYSOPEN_NEXT	;
WIDBORTH_SYSOPEN_LOAD:
	CALL	MENU_LOAD		; ロードメニュー
	CMP	AX,1			; 0=通常,1=データロード
	JE	WIDBORTH_SYSOPEN_LOADE	;
	CALLC	PT_OPEN_ALL_LD		; オープニング全ロード
	JMP	WIDBORTH_SYSOPEN_NEXT	;
WIDBORTH_SYSOPEN_NEXT:			;
	JMP	WIDBORTH_SYSOPEN_LOOP	;

WIDBORTH_SYSOPEN_EXIT:
	MOV	AX,0			; 0=通常
	RET
WIDBORTH_SYSOPEN_LOADE:
	MOV	AX,1			; 1=データロード
	RET
FEND	WWIDBORTH_SYSOPEN


; ****************************************************
;	セットアップメニュー
; ****************************************************

MENU_SETUP	PROC	NEAR
	WSELECT	"通 常 の カ ラ ー に す る,ノｰトパｿｺﾝの液晶８階調にする,PC-386LSX-H40 ｶﾗｰ15にする,なんだかわからない"
	CMP	WIDSNM,1		; ノーマル実行
	JE	MENU_SETUP_COLOR_BW	;
	CMP	WIDSNM,2		; ノーマル実行
	JE	MENU_SETUP_COLOR_LSX	;

	MOV	SW_ANALOG,0		; 0=normal analog
	CALLC	NORMIN			; ノーマルカラー
;*;	CALLC	BRIIN			; 明度５０％からノーマルへ
	RET
MENU_SETUP_COLOR_LSX:			;
	MOV	SW_ANALOG,1		; 1=386LSX(15color)
	CALLC	NORMIN			; ノーマルカラー
;*;	CALLC	BRIIN			; 明度５０％からノーマルへ
	RET
MENU_SETUP_COLOR_BW:			;
	MOV	SW_ANALOG,3		; 3=B/W
	CALLC	NORMIN			; ノーマルカラー
;*;	CALLC	BRIIN			; 明度５０％からノーマルへ
	RET
MENU_SETUP	ENDP


; ****************************************************
;	ロードメニュー
;	-O- AX : 0=通常,1=データロード
; ****************************************************

MENU_LOAD	PROC	NEAR
	CALLC	R_LOADIN		; スタート時ロード
	CMP	AX,0			; 0=通常
	JE	MENU_LOAD_NONE		;

	CALLC	WIDDSP_SV_F		; WINDOWS/画面フル退避
	CALLC	VRMDP1			; ＶＲＡＭ１表示
	CALLC	VRMWT1			; ＶＲＡＭ１アクセス

	MOV	AX,1			; 1=データロード
	RET
MENU_LOAD_NONE:
	MOV	AX,0			; 0=通常
	RET
MENU_LOAD	ENDP



; ****************************************************
;	ゲーム名前と誕生日の設定
; ****************************************************

OPENING_SET	PROC	NEAR
	MOV	AX,0			; 0=最初
	JMP	OPENING_SET_12		;

OPENING_SET_11:				;
	MOV	AX,1			; 1=キャンセルで戻ってきた
OPENING_SET_12:				;
	CALLC	OPENNAME		; オープニング・名前入力
	CMP	AX,1			; 1=スキップ
	JE	OPENING_SET_EXIT	;

OPENING_SET_22:
	CALLC	WIDBROOD_SET		; WINDOWS/血液型入力
	CMP	AX,2			; 2=キャンセル
	JE	OPENING_SET_11		;

	CALL	FAR PTR WWIDBORTH_SET	; WINDOWS/誕生日ウインドウ実行
	CMP	AX,2			; 2=キャンセル
	JE	OPENING_SET_22		;

	CALLC	WIDALLOC_MEM		; WINDOWS/データ結合・メモリ上のみ

OPENING_SET_EXIT:
	RET
OPENING_SET	ENDP



; ****************************************************
;	WINDOWS/誕生日ウインドウ実行
;	-O- AX : 0=通常,1=スキップ,2=キャンセル
; ****************************************************

FUNC	WWIDBORTH_SET,WIDBORTH_SET

	CALL	BORTH_OPEN		; 誕生日ＯＰＥＮ

	CALL	BORTH_MAIN		; 誕生日ＭＡＩＮ
	CMP	AX,1			; 1=キャンセル
	JE	WIDBORTH_SET_CANCEL	;

	CALL	BORTH_CLOSE		; 誕生日ＣＬＯＳＥ

	MOV	AX,0			; 0=通常
	RET
WIDBORTH_SET_CANCEL:
	MOV	AX,2			; 2=キャンセル
	RET
FEND	WWIDBORTH_SET



; ****************************************************
;	誕生日ＯＰＥＮ
; ****************************************************

BORTH_OPEN	PROC	NEAR
	MOV	FLAG_SAVE,0		; 退避フラグ
	MOV	OLD_CLNDXX,0		; カーソル前回Ｘ
	MOV	OLD_CLNDYY,0		; カーソル前回Ｙ
	MOV	OLD_BASEXX,0		; ベース前回Ｘ
	MOV	OLD_BASEYY,0		; ベース前回Ｙ

;*;	MOV	DX,12			; 12=名前入力／娘
;*;	CALLC	PT_PALET_ST		; パレットのセット

	CALLC	VRMWT0			; ＶＲＡＭ０

	CALLC	WIDDSP_SV_F		; WINDOWS/画面フル退避 vram0 -> vram1
	CALLC	VRMDP1			; ＶＲＡＭ１表示

	CALLC	PT_OPEN_BORTH		; 誕生日フレーム

	CALLC	VRMDP0			; ＶＲＡＭ０表示
	RET
BORTH_OPEN	ENDP


; ****************************************************
;	誕生日ＣＬＯＳＥ
; ****************************************************

BORTH_CLOSE	PROC	NEAR
	RET
BORTH_CLOSE	ENDP


; ****************************************************
;	誕生日ＭＡＩＮ
;	-O- AX        : 1=キャンセル
; ****************************************************

BORTH_MAIN	PROC	NEAR
;*;	CALL	SHOW_SEIZA			; 表示・星座
;*;	CALL	SHOW_BLOOD			; 表示・血液型

	MOV	DX,12				;
	CALLC	PT_PALET_ST			; パレットのセット

	CALL	CLEND_MAIN			; カレンダーメイン

	CALL	WID_SLCT			; マウスセレクト
	CMP	AX,1				; 1=キャンセル
	JE	BORTH_MAIN_CANCEL		;

	CALL	VALDATE_TO_STRING		; 日付の文字列セット
	CALL	BORTH_SETER			; 誕生日データベースＳＥＴ

	MOV	AX,0
	RET
BORTH_MAIN_CANCEL:
	MOV	AX,1			; 1=キャンセル
	RET
BORTH_MAIN	ENDP


; ****************************************************
;	マウスセレクト
;	-I- SET_YEAR  : 設定・年代
;	    SET_MONTH : 設定・月
;	    SET_DAYS  : 設定・日
;	-O- AX        : 1=キャンセル
; ****************************************************

WID_SLCT	PROC	NEAR
	CALLC	MSCWAT			; カーソルボタンＯＦＦ待ち

	MOV	SCH_POS_YEAR_N,0	; 年
	MOV	SCH_POS_MNTH_N,0	; 月
	MOV	SCH_POS_DAYS_N,0	; 日
	MOV	OLD_YEAR,0		; 前回・年
	MOV	OLD_MONTH,0		; 前回・月
	MOV	OLD_DATE,0		; 前回・日

	CALLC	MSCSRT			; カーソルスタート
WID_SLCT_LOOP:
	CALLC	MSCMOV			; カーソル移動
	CMP	DL,1			; 右ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	WID_SLCT_1		;
	JMP	WID_SLCT_CANCEL		;
WID_SLCT_1:				;
	CMP	DH,1			; 左ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	WID_SLCT_2		;
	JMP	WID_SLCT_ON		;
WID_SLCT_2:				;
	MOV	MOUSEX,AX		; マウスＸ
	MOV	MOUSEY,BX		; マウスＹ
	MOV	MOUSEFLAG,OFFF		; マウスＯＮ／ＯＦＦフラグ

	CALL	CLEND_SCH		; カレンダーサーチ・月
	MOV	FLAG_KETTEI,AX		; 決定フラグ
	CMP	AX,0			; 0=無し,1=一致した
	JE	WID_SLCT_5		;

	CALL	CLEND_SCH_DAYS		; カレンダーサーチ・日
	MOV	FLAG_KETTEI,AX		; 決定フラグ
	CMP	AX,0			; 0=無し,1=一致した
	JE	WID_SLCT_5		;
	JMP	WID_SLCT_NEXT		;
WID_SLCT_5:
	CMP	FLAG_SAVE,0		; 退避フラグ
	JE	WID_SLCT_NEXT		;
	CALLC	MSCSTP
	CALL	CLND_CURSOLE_LD		; カレンダ復元
	CALL	CLR_DATE_SET		; クリア日付
	CALLC	MSCSRT

	MOV	SCH_POS_YEAR_N,0	; 年
	MOV	SCH_POS_MNTH_N,0	; 月
	MOV	SCH_POS_DAYS_N,0	; 日
	MOV	OLD_YEAR,0		; 前回・年
	MOV	OLD_MONTH,0		; 前回・月
	MOV	OLD_DATE,0		; 前回・日

WID_SLCT_NEXT:
	JMP	WID_SLCT_LOOP		;

WID_SLCT_ON:				;
	CMP	FLAG_KETTEI,0		; 決定フラグ
	JMPEQ	WID_SLCT_LOOP		;

	MOVX	SET_YEAR,SCH_POS_YEAR_N		; 年
	MOVX	SET_MONTH,SCH_POS_MNTH_N	; 月
	MOVX	SET_DAYS,SCH_POS_DAYS_N		; 日

	CMP	SET_MONTH,2		; 月
	JNE	WID_SLCT_EXIT		;
	CMP	SET_DAYS,29		; 日
	JNE	WID_SLCT_EXIT		;
	JMP	WID_SLCT_LOOP		;
WID_SLCT_EXIT:
	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,0			;
	RET
WID_SLCT_CANCEL:
	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,1			; 1=キャンセル
	RET
WID_SLCT	ENDP


; ****************************************************
;	カレンダーサーチ・月
;	-I- MOUSEX : マウスＸ
;	    MOUSEY : マウスＹ
;	-O- AX     : 0=無し,1=一致した
;	    SCH_POS_MNTH_N : 表示・１カレンダー・月
;	    SCH_POS_MNTH_X : 表示・カレンダーＸ開始位置
;	    SCH_POS_MNTH_Y : 表示・カレンダーＹ開始位置
;	    SCH_POS_OFST_X : サーチ・オフセットＸ
;	    SCH_POS_OFST_Y : サーチ・オフセットＹ
; ****************************************************

CLEND_SCH	PROC	NEAR
	MOV	SET_CLD_MONTH,4			; 表示・１カレンダー・月

	MOV	LOC_1_CLEND_Y,CLEND_OFST_Y	; 表示・カレンダーＹ開始位置
	MOV	CX,CLEND_NARABI_Y		; 表示・カレンダーＹ並び
CLEND_SCH_SHOW_LOOP_YY:				;
	PUSH	CX				;

	MOV	LOC_1_CLEND_X,CLEND_OFST_X	; 表示・カレンダーＸ開始位置
	MOV	CX,CLEND_NARABI_X		; 表示・カレンダーＸ並び
CLEND_SCH_SHOW_LOOP_XX:				;
	PUSH	CX				;

	MOV	AX,LOC_1_CLEND_X		; 表示・カレンダーＸ開始位置
	MOV	BX,LOC_1_CLEND_Y		; 表示・カレンダーＹ開始位置
	ADD	AX,CLEND_HANI_X			; 表示・カレンダーＸ範囲
	ADD	BX,CLEND_HANI_Y			; 表示・カレンダーＹ範囲
	MOV	LOC_E_CLEND_X,AX		; 表示・カレンダー右下Ｘ
	MOV	LOC_E_CLEND_Y,BX		; 表示・カレンダー右下Ｙ

	MOV	AX,MOUSEX			; マウスＸ
	MOV	BX,MOUSEY			; マウスＹ
	ARACHK	LOC_1_CLEND_X,LOC_1_CLEND_Y,LOC_E_CLEND_X,LOC_E_CLEND_Y,CLEND_SCH_SEARCH

	INC	SET_CLD_MONTH			; 表示・１カレンダー・月
	CMP	SET_CLD_MONTH,12		; 年越しか？
	JLE	CLEND_SCH_SHOW_55		;
	INC	SET_CLD_YEAR			; 表示・１カレンダー・年
	MOV	SET_CLD_MONTH,1			; 表示・１カレンダー・月
CLEND_SCH_SHOW_55:				;

	ADD	LOC_1_CLEND_X,CLEND_STEP_X	; 表示・カレンダーＸ開始位置
	POP	CX				;
	LOOP	CLEND_SCH_SHOW_LOOP_XX		;

	ADD	LOC_1_CLEND_Y,CLEND_STEP_Y	; 表示・カレンダーＹ開始位置
	POP	CX				;
	LOOP	CLEND_SCH_SHOW_LOOP_YY		;
	JMP	CLEND_SCH_NONE

CLEND_SCH_SEARCH:
	POP	CX
	POP	CX

	MOVX	SCH_POS_MNTH_N,SET_CLD_MONTH	; 表示・１カレンダー・月
	MOVX	SCH_POS_MNTH_X,LOC_1_CLEND_X	; 表示・カレンダーＸ開始位置
	MOVX	SCH_POS_MNTH_Y,LOC_1_CLEND_Y	; 表示・カレンダーＹ開始位置
	MOV	AX,MOUSEX			; マウスＸ
	MOV	BX,MOUSEY			; マウスＹ
	SUB	AX,LOC_1_CLEND_X		; 表示・カレンダーＸ開始位置
	SUB	BX,LOC_1_CLEND_Y		; 表示・カレンダーＹ開始位置
	MOV	SCH_POS_OFST_X,AX		; サーチ・オフセットＸ
	MOV	SCH_POS_OFST_Y,BX		; サーチ・オフセットＹ
	MOV	AX,1				; 1=一致した
	RET
CLEND_SCH_NONE:
	MOV	AX,0				; 0=無し
	RET
CLEND_SCH	ENDP


; ****************************************************
;	カレンダーサーチ・日
;	-I- SCH_POS_MNTH_N : 表示・１カレンダー・月
;	    SCH_POS_MNTH_X : 表示・カレンダーＸ開始位置
;	    SCH_POS_MNTH_Y : 表示・カレンダーＹ開始位置
;	    SCH_POS_OFST_X : サーチ・オフセットＸ
;	    SCH_POS_OFST_Y : サーチ・オフセットＹ
;	-O- AX      : 0=無し,1=一致した
;	    SCH_POS_YEAR_N : 年
;	    SCH_POS_MNTH_N : 月
;	    SCH_POS_DAYS_N : 日
; ****************************************************

CLEND_SCH_DAYS	PROC	NEAR
	MOVX	XX1,SCH_POS_OFST_X	; サーチ・オフセットＸ
	MOVX	YY1,SCH_POS_OFST_Y	; サーチ・オフセットＹ
	CALL	MTRX_SCH		; マトリックスサーチ
	CMP	AX,0			; 0=無し,1=一致した
	JE	CLEND_SCH_DAYS_NONE	;


	CALL	TOSHI_NOCHI		; 年・日サーチ
	CMP	AX,0			; 0=無し,1=一致した
	JE	CLEND_SCH_DAYS_NONE	;

	CALL	SHOW_DATESET		; 日付の表示

;	    SCH_POS_MNTH_X : 表示・カレンダーＸ開始位置
;	    SCH_POS_MNTH_Y : 表示・カレンダーＹ開始位置
;	    SCH_POS_OFST_X : サーチ・オフセットＸ
;	    SCH_POS_OFST_Y : サーチ・オフセットＹ


CLEND_SCH_DAYS_SCH:
	MOV	AX,1				; 1=一致した
	RET
CLEND_SCH_DAYS_NONE:
	MOV	AX,0				; 0=無し
	RET
CLEND_SCH_DAYS	ENDP


; ****************************************************
;	年・日サーチ
;	-I- SCHXX          : サーチＸ
;	    SCHYY          : サーチＹ
;	    SCH_POS_MNTH_N : 表示・１カレンダー・月
;	    CLNDTBL_S_WEEK[]: 月毎の始め曜日
;	    CLNDTBL_E_DAYS[]: 月毎の末日
;	-O- AX             : 0=無し,1=一致した
;	    SCH_POS_YEAR_N : サーチ・何年
;	    SCH_POS_DAYS_N : サーチ・何日
; ****************************************************

TOSHI_NOCHI	PROC	NEAR
	MOV	AX,SCHYY			; サーチＹ
	MOV	DX,0				;
	MOV	BX,CLM_CLND_CNT_X		; ×カレンダー並び数Ｘ
	MUL	BX				;
	ADD	AX,SCHXX			; ＋サーチＸ
	INC	AX				; +1
	MOV	SCH_POS_DAYS_N,AX		; サーチ・何日

	MOV	BX,SCH_POS_MNTH_N		; 表示・１カレンダー・月
	MOVXBW	CX,DS:CLNDTBL_S_WEEK[BX]	; 月毎の始め曜日
	MOVXBW	DX,DS:CLNDTBL_E_DAYS[BX]	; 月毎の末日

	SUB	SCH_POS_DAYS_N,CX		; サーチ・何日
	JLE	TOSHI_NOCHI_NONE		;

	CMP	SCH_POS_DAYS_N,DX		; 月毎の末日
	JG	TOSHI_NOCHI_NONE		;

	MOV	DX,DISP_SRT_YEAR		; 表示開始年
	MOV	SCH_POS_YEAR_N,DX		; サーチ・何年
	CMP	SCH_POS_MNTH_N,4		; 表示・１カレンダー・月
	JGE	TOSHI_NOCHI_77			;
	INC	SCH_POS_YEAR_N			; サーチ・何年
TOSHI_NOCHI_77:					;

TOSHI_NOCHI_SCH:
	MOV	AX,1				; 1=一致した
	RET
TOSHI_NOCHI_NONE:
	MOV	AX,0				; 0=無し
	RET
TOSHI_NOCHI	ENDP


; ****************************************************
;	マトリックスサーチ
;	-I- XX1,YY1 : サーチポイント
;	-O- AX      : 0=無し,1=一致した
;	    SCHXX   : サーチＸ
;	    SCHYY   : サーチＹ
; ****************************************************

MTRX_SCH	PROC	NEAR
	MOV	SCHXX,0				; サーチＸ
	MOV	SCHYY,0				; サーチＹ

	MOV	YY2,0				;
	MOV	CX,CLM_CLND_CNT_Y		; カレンダー並び数Ｙ
MTRX_SCH_LOOP_YY:				;
	ADD	YY2,HIGHT_DAYS_STR		; 表示・カレンダー日・高さ
	CMPX	YY1,YY2				;
	JBE	MTRX_SCH_SCH_YY			;
	INC	SCHYY				; サーチＹ
	LOOP	MTRX_SCH_LOOP_YY		;
	JMP	MTRX_SCH_NONE			;
MTRX_SCH_SCH_YY:				;

	MOV	XX2,0				;
	MOV	CX,CLM_CLND_CNT_X		; カレンダー並び数Ｘ
MTRX_SCH_LOOP_XX:				;
	ADD	XX2,WIDTH_DAYS_STR		; 表示・カレンダー日・幅
	CMPX	XX1,XX2				;
	JBE	MTRX_SCH_SCH_XX			;
	INC	SCHXX				; サーチＸ
	LOOP	MTRX_SCH_LOOP_XX		;
	JMP	MTRX_SCH_NONE			;
MTRX_SCH_SCH_XX:				;

MTRX_SCH_SCH:
	MOV	AX,1				; 1=一致した
	RET
MTRX_SCH_NONE:
	MOV	AX,0				; 0=無し
	RET
MTRX_SCH	ENDP



; ****************************************************
;	カレンダーメイン
; ****************************************************

CLEND_MAIN	PROC	NEAR
	CALL	ALL_CLENDER_SHOW		; 全カレンダー表示
	CALL	BORTH_TITLE			; 誕生日タイトル
	RET
CLEND_MAIN	ENDP


; ****************************************************
;	誕生日タイトル
; ****************************************************

BORTH_TITLE	PROC	NEAR
	MOV	AX,3			; location x point.
	MOV	BX,13			; location y point.
	MOV	SI,OFFSET MSG_TITLE	; "誕生日"
	CALLC	WIDNAME_PRINT		; WINDOWS/名前ウインドウ文字列表示
	RET
BORTH_TITLE	ENDP


; ****************************************************
;	全カレンダー表示
; ****************************************************

ALL_CLENDER_SHOW	PROC	NEAR
	MOVX	SET_CLD_YEAR,DISP_SRT_YEAR	; 表示・１カレンダー・年
	MOV	SET_CLD_MONTH,4			; 表示・１カレンダー・月

	MOV	LOC_1_CLEND_Y,CLEND_OFST_Y	; 表示・カレンダーＹ開始位置

	MOV	CX,CLEND_NARABI_Y		; 表示・カレンダーＹ並び
ALL_CLENDER_SHOW_LOOP_YY:			;
	PUSH	CX				;

	MOV	LOC_1_CLEND_X,CLEND_OFST_X	; 表示・カレンダーＸ開始位置

	MOV	CX,CLEND_NARABI_X		; 表示・カレンダーＸ並び
ALL_CLENDER_SHOW_LOOP_XX:
	PUSH	CX				;

	MOVX	UCK_YEAR,SET_CLD_YEAR		; 表示・１カレンダー・年
	MOVX	UCK_MONTH,SET_CLD_MONTH		; 表示・１カレンダー・月
	CALLC	WIDCLEN_MONTH_C			; WINDOWS/カレンダー・月データ
	MOVX	SET_CLD_DAY_END,UCK_M_END	; (user)月末の日
	MOVX	SET_CLD_S_WEEK,UCK_WEEK		; (user)曜日

	CALL	ONE_CLENDER_SHOW		; １カレンダー表示

	MOV	AX,SET_CLD_S_WEEK		; (user)曜日
	MOV	DX,SET_CLD_DAY_END		; (user)月末の日
	MOV	BX,SET_CLD_MONTH		; 表示・１カレンダー・月
	MOV	DS:CLNDTBL_S_WEEK[BX],AL	; 月毎の始め曜日
	MOV	DS:CLNDTBL_E_DAYS[BX],DL	; 月毎の末日

	INC	SET_CLD_MONTH			; 表示・１カレンダー・月
	CMP	SET_CLD_MONTH,12		; 年越しか？
	JLE	ALL_CLENDER_SHOW_55		;
	INC	SET_CLD_YEAR			; 表示・１カレンダー・年
	MOV	SET_CLD_MONTH,1			; 表示・１カレンダー・月
ALL_CLENDER_SHOW_55:				;

	ADD	LOC_1_CLEND_X,CLEND_STEP_X	; 表示・カレンダーＸ開始位置
	POP	CX				;
	LOOP	ALL_CLENDER_SHOW_LOOP_XX	;

	ADD	LOC_1_CLEND_Y,CLEND_STEP_Y	; 表示・カレンダーＹ開始位置
	POP	CX				;
	LOOP	ALL_CLENDER_SHOW_LOOP_YY	;

	RET
ALL_CLENDER_SHOW	ENDP


; ****************************************************
;	１カレンダー表示
;	-I- LOC_1_CLEND_X : 表示１カレンダーＸ
;	    LOC_1_CLEND_Y : 表示１カレンダーＹ
;	    SET_CLD_YEAR  : 表示・１カレンダー・年
;	    SET_CLD_MONTH : 表示・１カレンダー・月
;	    SET_CLD_DAY_END : 表示・１カレンダー・末日
;	    SET_CLD_S_WEEK  : 表示・１カレンダー・開始曜日
; ****************************************************

ONE_CLENDER_SHOW	PROC	NEAR
	MOV	NOW_CLEND_DAY,1			; 表示・カレンダー日

	MOV	DAYS_FONT_COLOR,COLOR_MONTH	; 月色
	MOVX	LOC_DAYS_X,LOC_1_CLEND_X	; 表示・１カレンダーＸ
	MOVX	LOC_DAYS_Y,LOC_1_CLEND_Y	; 表示・１カレンダーＹ
	ADD	LOC_DAYS_X,OFS_HEAD_XX		; 表示・カレンダーヘッダＸ
	ADD	LOC_DAYS_Y,OFS_HEAD_YY		; 表示・カレンダーヘッダＹ
	SUB	LOC_DAYS_Y,HIGHT_HEAD_STR	; 表示・カレンダーヘッダ・高さ
	CALL	HEAD_DISP			; カレンダーヘッダー・表示

	MOVX	CLM_DAYS_X,SET_CLD_S_WEEK	; 表示・１カレンダー・開始曜日
	MOVX	LOC_DAYS_X,LOC_1_CLEND_X	; 表示・１カレンダーＸ

	MOV	AX,3				;
	MOV	DX,0				;
	MOV	BX,SET_CLD_S_WEEK		; 表示・１カレンダー・開始曜日
	MUL	BX				;
	ADD	LOC_DAYS_X,AX			; 表示・１カレンダーＸ

	MOV	CLM_DAYS_Y,0			; 表示・カレンダー日カラムＹ
	MOVX	LOC_DAYS_Y,LOC_1_CLEND_Y	; 表示・１カレンダーＹ
ONE_CLENDER_SHOW_LOOP:
	CMPX	NOW_CLEND_DAY,SET_CLD_DAY_END	; 表示・１カレンダー・末日
	JG	ONE_CLENDER_SHOW_LOOP_E		;

	CMP	CLM_DAYS_X,CLM_DAYS_MAX_X	; 表示・カレンダー日・数Ｘ
	JB	ONE_CLENDER_SHOW_3X		;
	MOV	CLM_DAYS_X,0			; 表示・カレンダー日カラムＸ
	INC	CLM_DAYS_Y			; 表示・カレンダー日カラムＹ
	MOVX	LOC_DAYS_X,LOC_1_CLEND_X	; 表示・１カレンダーＸ
	ADD	LOC_DAYS_Y,HIGHT_DAYS_STR	; 表示・カレンダー日・高さ
	MOV	DAYS_FONT_COLOR,COLOR_HOLIDAY	; 休み色
ONE_CLENDER_SHOW_3X:

	MOV	DAYS_FONT_COLOR,COLOR_BLUEDAY	; 平日色
	CMP	CLM_DAYS_X,0			; 表示・カレンダー日カラムＸ
	JNE	ONE_CLENDER_SHOW_44		;
	MOV	DAYS_FONT_COLOR,COLOR_HOLIDAY	; 休み色
ONE_CLENDER_SHOW_44:

	CALL	DAYS_DISP			; 日・表示

	INC	CLM_DAYS_X			; 表示・カレンダー日カラムＸ
	ADD	LOC_DAYS_X,WIDTH_DAYS_STR	; 表示・１カレンダーＸ
	INC	NOW_CLEND_DAY			; 表示・カレンダー日
	JMP	ONE_CLENDER_SHOW_LOOP		;
ONE_CLENDER_SHOW_LOOP_E:
	RET
ONE_CLENDER_SHOW	ENDP


; ****************************************************
;	カレンダーヘッダー・表示
;	-I- LOC_DAYS_X     : 表示・１カレンダーＸ
;	    LOC_DAYS_Y     : 表示・１カレンダーＹ
;	    SET_CLD_YEAR   : 表示・１カレンダー・年
;	    SET_CLD_MONTH  : 表示・１カレンダー・月
;	    DAYS_FONT_COLOR: 表示・フォントカラー
; ****************************************************

HEAD_DISP	PROC	NEAR
	MOV	AX,DAYS_FONT_COLOR		; 表示・フォントカラー
	CALLC	MITCOL				; mini string color.

	MOV	DX,SET_CLD_MONTH		; 表示・１カレンダー・月
	CALLC	DECSTR				;
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	ADD	SI,3				;
	MOV	AX,LOC_DAYS_X			; 表示・１カレンダーＸ
	MOV	BX,LOC_DAYS_Y			; 表示・１カレンダーＹ
	CALL	NUMBER_STR_PUT			; 数字文字列表示

	MOV	DX,SET_CLD_YEAR			; 表示・１カレンダー・年
	CALLC	DECSTR				;
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	ADD	SI,1				;
	MOV	AX,LOC_DAYS_X			; 表示・１カレンダーＸ
	ADD	AX,3				;
	MOV	BX,LOC_DAYS_Y			; 表示・１カレンダーＹ
	CALL	MINI_STR_PUT			; ｍｉｎｉ文字列ＰＵＴ
;*;	CALL	NUMBER_STR_PUT			; 数字文字列表示
	RET
HEAD_DISP	ENDP


; ****************************************************
;	カレンダー日・表示
;	-I- LOC_DAYS_X     : 表示・１カレンダーＸ
;	    LOC_DAYS_Y     : 表示・１カレンダーＹ
;	    NOW_CLEND_DAY  : 表示・カレンダー日
;	    DAYS_FONT_COLOR: 表示・フォントカラー
; ****************************************************

DAYS_DISP	PROC	NEAR
	MOV	AX,DAYS_FONT_COLOR		; 表示・フォントカラー
	CALLC	MITCOL				; mini string color.

	MOV	DX,NOW_CLEND_DAY		; 表示・カレンダー日
	CALLC	DECSTR				;
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	ADD	SI,3				;
	MOV	AX,LOC_DAYS_X			; 表示・１カレンダーＸ
	MOV	BX,LOC_DAYS_Y			; 表示・１カレンダーＹ
	CALL	NUMBER_STR_PUT			; 数字文字列表示
	RET
DAYS_DISP	ENDP


; ****************************************************
;	日付の表示
;	-I- SCH_POS_YEAR_N : サーチ・何年
;	    SCH_POS_MNTH_N : 表示・カレンダー・月
;	    SCH_POS_DAYS_N : サーチ・何日
;
;	    SCH_POS_MNTH_X : 表示・カレンダーＸ開始位置
;	    SCH_POS_MNTH_Y : 表示・カレンダーＹ開始位置
;	    SCH_POS_OFST_X : サーチ・オフセットＸ
;	    SCH_POS_OFST_Y : サーチ・オフセットＹ
; ****************************************************

SHOW_DATESET	PROC	NEAR
	MOV	AX,COLOR_DATESET		; 日付色
	CALLC	MITCOL				; mini string color.

	CMPX	OLD_YEAR,SCH_POS_YEAR_N		;
	JE	SHOW_DATESET_2			;
	MOVX	OLD_YEAR,SCH_POS_YEAR_N		;
	MOVX	DSP_YEAR,SCH_POS_YEAR_N		; サーチ・何年
	CALL	SHOW_YEAR			; 表示・年
SHOW_DATESET_2:

	CMPX	OLD_MONTH,SCH_POS_MNTH_N	;
	JE	SHOW_DATESET_3			;
	MOVX	OLD_MONTH,SCH_POS_MNTH_N	;
	MOVX	DSP_MONTH,SCH_POS_MNTH_N	; 表示・１カレンダー・月
	CALL	SHOW_MONTH			; 表示・月
SHOW_DATESET_3:

	CMPX	OLD_DATE,SCH_POS_DAYS_N		;
	JE	SHOW_DATESET_4			;
	MOVX	OLD_DATE,SCH_POS_DAYS_N		;
	MOVX	DSP_DATE,SCH_POS_DAYS_N		; サーチ・何日
	CALL	SHOW_DATE			; 表示・日

	CALL	DATE_CURSOLE			; 日付カーソル
SHOW_DATESET_4:

SHOW_DATESET_EXIT:
	RET
SHOW_DATESET	ENDP


; ****************************************************
;	日付カーソル
;	-I- SCH_POS_MNTH_X : 表示・カレンダーＸ開始位置
;	    SCH_POS_MNTH_Y : 表示・カレンダーＹ開始位置
;	    SCHXX   : サーチＸ
;	    SCHYY   : サーチＹ
;	    DSP_DATE   : 表示・日
; ****************************************************

DATE_CURSOLE	PROC	NEAR
	MOV	AX,SCHXX			; サーチＸ
	MOV	BX,WIDTH_DAYS_STR		; 表示・カレンダー日・幅
	MUL	BX				;
	ADD	AX,SCH_POS_MNTH_X		; 表示・カレンダーＸ開始位置
	MOV	XX1,AX				; Ｘ

	MOV	AX,SCHYY			; サーチＹ
	MOV	BX,HIGHT_DAYS_STR		; 表示・カレンダー日・高さ
	MUL	BX				;
	ADD	AX,SCH_POS_MNTH_Y		; 表示・カレンダーＹ開始位置
	MOV	YY1,AX				; Ｙ

	MOV	AX,14
	CALLC	MITCOL				; mini string color.

	MOVX	CLNDXX,XX1			; カーソルＸ
	MOVX	CLNDYY,YY1			; カーソルＹ
	MOVX	BASEXX,SCH_POS_MNTH_X		; 表示・カレンダーＸ開始位置
	MOVX	BASEYY,SCH_POS_MNTH_Y		; 表示・カレンダーＹ開始位置
	CALL	CLND_CURSOLE			; カレンダーカーソル

	RET
DATE_CURSOLE	ENDP


; ****************************************************
;	名前表示
; ****************************************************

SHOW_NAME	PROC	NEAR
	CALLC	STRZEROC			; 文字列バッファ０クリア
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 台詞・キャラクタアドレス
	MOV	DI,OFFSET STR_BUFF		; 文字列バッファ
	MOV	CX,STRING_LEN			; string length.
	CALLC	R_SR_GIRL_FULNAMGET		; キャラクタ名+姓ＧＥＴ

	MOV	SI,OFFSET STR_BUFF		; 文字列バッファ
	MOV	AX,LOC_NAME_X			; 表示・名前・Ｘ
	MOV	BX,LOC_NAME_Y			; 表示・名前・Ｙ
	CALL	GOLD_STR_PUT			; ＧＯＬＤ文字列ＰＵＴ
	RET
SHOW_NAME	ENDP


; ****************************************************
;	表示・年
;	-I- DSP_YEAR : 表示・年
; ****************************************************

SHOW_YEAR	PROC	NEAR
	MOV	DX,DSP_YEAR		; 表示・年
	CALLC	DECSTR			;
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	ADD	SI,1			;
	MOV	AX,LOC_YEAR_X		; 表示・年・Ｘ
	MOV	BX,LOC_YEAR_Y		; 表示・年・Ｙ
	MOV	CX,4			; 長さ
	CALL	MINI_STR_CLR		; ｍｉｎｉ文字列ＣＬＥＡＲ
	CALL	MINI_STR_PUT		; ｍｉｎｉ文字列ＰＵＴ
	RET
SHOW_YEAR	ENDP


; ****************************************************
;	表示・月
;	-I- DSP_MONTH : 表示・月
; ****************************************************

SHOW_MONTH	PROC	NEAR
	MOV	DX,DSP_MONTH		; 表示・月
	CALLC	DECSTR			;
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	ADD	SI,3			;
	MOV	AX,LOC_MONTH_X		; 表示・月・Ｘ
	MOV	BX,LOC_MONTH_Y		; 表示・月・Ｙ
	MOV	CX,2			; 長さ
	CALL	MINI_STR_CLR		; ｍｉｎｉ文字列ＣＬＥＡＲ
	CALL	MINI_STR_PUT		; ｍｉｎｉ文字列ＰＵＴ
	RET
SHOW_MONTH	ENDP


; ****************************************************
;	表示・日
;	-I- DSP_DATE : 表示・日
; ****************************************************

SHOW_DATE	PROC	NEAR
	MOV	DX,DSP_DATE		; 表示・日
	CALLC	DECSTR			;
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	ADD	SI,3			;
	MOV	AX,LOC_DATE_X		; 表示・日・Ｘ
	MOV	BX,LOC_DATE_Y		; 表示・日・Ｙ
	MOV	CX,2			; 長さ
	CALL	MINI_STR_CLR		; ｍｉｎｉ文字列ＣＬＥＡＲ
	CALL	MINI_STR_PUT		; ｍｉｎｉ文字列ＰＵＴ
	RET
SHOW_DATE	ENDP


; ****************************************************
;	クリア日付
; ****************************************************

CLR_DATE_SET	PROC	NEAR
	MOV	AX,LOC_YEAR_X		; 表示・年・Ｘ
	MOV	BX,LOC_YEAR_Y		; 表示・年・Ｙ
	MOV	CX,4			; 長さ
	CALL	MINI_STR_CLR		; ｍｉｎｉ文字列ＣＬＥＡＲ

	MOV	AX,LOC_MONTH_X		; 表示・月・Ｘ
	MOV	BX,LOC_MONTH_Y		; 表示・月・Ｙ
	MOV	CX,2			; 長さ
	CALL	MINI_STR_CLR		; ｍｉｎｉ文字列ＣＬＥＡＲ

	MOV	AX,LOC_DATE_X		; 表示・日・Ｘ
	MOV	BX,LOC_DATE_Y		; 表示・日・Ｙ
	MOV	CX,2			; 長さ
	CALL	MINI_STR_CLR		; ｍｉｎｉ文字列ＣＬＥＡＲ

	RET
CLR_DATE_SET	ENDP


; ****************************************************
;	表示・星座
;	-I- DSP_SEIZA : 表示・星座
; ****************************************************

SHOW_SEIZA	PROC	NEAR
	MOV	DX,DSP_SEIZA		; 表示・星座
	MOV	AX,LOC_SEIZA_X		; 表示・星座・Ｘ
	MOV	BX,LOC_SEIZA_Y		; 表示・星座・Ｙ
	CALL	SEIZA_PUT		; 星座ＰＵＴ
	RET
SHOW_SEIZA	ENDP


; ****************************************************
;	表示・血液型
;	-I- DSP_BLOOD : 表示・血液型1=A,2=AB,3=B,4=O
; ****************************************************

SHOW_BLOOD	PROC	NEAR
	MOV	DX,DSP_BLOOD		; 表示・血液型1=A,2=AB,3=B,4=O
	MOV	AX,LOC_BLOOD_X		; 表示・血液型・Ｘ
	MOV	BX,LOC_BLOOD_Y		; 表示・血液型・Ｙ
	CALL	BLOOD_PUT		; 血液型ＰＵＴ
	RET
SHOW_BLOOD	ENDP


; ****************************************************
;	星座ＰＵＴ
;	-I- AX : Ｘ位置
;	    BX : Ｙ位置
;	    DX : 星座
;		1=おひつじ座
;		2=おうし座
;		3=ふたご座
;		4=かに座
;		5=しし座
;		6=おとめ座
;		7=てんびん座
;		8=さそり座
;		9=いて座
;		10=やぎ座
;		11=みずがめ座
;		12=うお座
; ****************************************************

SEIZA_PUT	PROC	NEAR
	CALLC	PT_PUT_SEIZA		; 星座ＰＵＴ
	RET
SEIZA_PUT	ENDP


; ****************************************************
;	血液型ＰＵＴ
;	-I- AX : Ｘ位置
;	    BX : Ｙ位置
;	    DX : 血液型
;		1=Ａ型
;		2=Ｂ型
;		3=ＡＢ型
;		4=Ｏ型
; ****************************************************

BLOOD_PUT	PROC	NEAR
	CALLC	PT_PUT_BLOOD		; 血液型ＰＵＴ
	RET
BLOOD_PUT	ENDP


; ****************************************************
;	ＧＯＬＤ文字列ＰＵＴ
;	-I- SI : 文字列
;	    AX : Ｘ
;	    BX : Ｙ
; ****************************************************

GOLD_STR_PUT	PROC	NEAR
	CALLC	WIDNAME_PRINTG		; WINDOWS/名前ウインドウ文字列ＧＯＬＤ
	RET
GOLD_STR_PUT	ENDP


; ****************************************************
;	ｍｉｎｉ文字列ＰＵＴ
;	-I- SI : 文字列
;	    AX : Ｘ
;	    BX : Ｙ
; ****************************************************

MINI_STR_PUT	PROC	NEAR
	CALLC	MITPRN				; mini string.
	RET
MINI_STR_PUT	ENDP


; ****************************************************
;	ｍｉｎｉ文字列ＣＬＥＡＲ
;	-I- AX : Ｘ
;	    BX : Ｙ
;	    CX : 長さ
; ****************************************************

MINI_STR_CLR	PROC	NEAR
	PUSH	SI
	PUSH	AX
	PUSH	BX

	PUSH	AX
	PUSH	BX
	PUSH	CX

	MOV	VX1,AX
	MOV	VY1,BX
	ADD	AX,CX
	DEC	AX
	ADD	BX,8-1
	MOV	VX2,AX
	MOV	VY2,BX
	MOV	CX,3 ;2		; カラー
	CALLC	BOXPAL		; ＢＯＸペイント

	POP	CX
	POP	BX
	POP	AX

	ADD	BX,8
	MOV	VX1,AX
	MOV	VY1,BX
	ADD	AX,CX
	DEC	AX
	MOV	VX2,AX
	MOV	VY2,BX
	MOV	CX,4		; カラー
	CALLC	BOXPAL		; ＢＯＸペイント

	POP	BX
	POP	AX
	POP	SI
	RET
MINI_STR_CLR	ENDP


; ****************************************************
;	数字文字列表示
;	-I- SI : 文字列
;	    AX : Ｘ
;	    BX : Ｙ
; ****************************************************

NUMBER_STR_PUT	PROC	NEAR
	CALLC	MGXPRN			; GAINAX mini string.
	RET
NUMBER_STR_PUT	ENDP


; ****************************************************
;	日付の文字列セット
; ****************************************************

VALDATE_TO_STRING	PROC	NEAR
	MOV	DX,SET_YEAR			; 設定・年代
	CALLC	DECSTR				;
	MOVX	<WORD PTR TANJYOUBI_YEAR[0]>,DS:[SI][1]	; "1659/"
	MOVX	<WORD PTR TANJYOUBI_YEAR[2]>,DS:[SI][3]	;

	MOV	DX,SET_MONTH			; 設定・月
	CALLC	DECSTR				;
	MOVX	<WORD PTR TANJYOUBI_MONTH[0]>,DS:[SI][3] ; "05/"

	MOV	DX,SET_DAYS			; 設定・日
	CALLC	DECSTR				;
	MOVX	<WORD PTR TANJYOUBI_DAYS[0]>,DS:[SI][3]	; "04"
	RET
VALDATE_TO_STRING	ENDP


; ****************************************************
;	誕生日データベースＳＥＴ
; ****************************************************

BORTH_SETER	PROC	NEAR

	; データベース

	; (1) ヘッダー

	MOV	BX,WIDMY_GIRL_OF		; 私の娘アドレス BX=ヘッダー

	; (2) 名前

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ES:[BX][HED_VA_OFS]		; DI=内容表示テーブルオフセット

	; (3) 内容テーブルへアクセス

	MOV	DX,ES:[DI][VTB_TANJOBI][VAL_VALUE] ; DX=誕生日オフセット

	; (4) 転送

	MOV	DI,DX				; "1659/05/04"
	MOV	SI,OFFSET TANJYOUBI		; 誕生日
	MOV	CX,10				; 文字長さ１０
	REP	MOVSB				;

	RET
BORTH_SETER	ENDP


; ****************************************************
;	カレンダーカーソル
;	-I- CLNDXX : カーソルＸ
;	    CLNDYY : カーソルＹ
;	    BASEXX : ベースＸ
;	    BASEYY : ベースＹ
;	    DSP_DATE : 表示・日
;	    XX1    : Ｘ
;	    YY1    : Ｙ
;	-I/O- FLAG_SAVE : 退避フラグ
; ****************************************************

CLND_CURSOLE	PROC	NEAR
	CMPX	OLD_CLNDXX,CLNDXX		; カーソルＸ
	JNE	CLND_CURSOLE_START		;
	CMPX	OLD_CLNDYY,CLNDYY		; カーソルＹ
	JNE	CLND_CURSOLE_START		;
	RET
CLND_CURSOLE_START:
	MOV	FLAG_CLEAR,0			; クリアフラグ 1=クリア

	CALLC	MSCSTP


	CMPX	OLD_BASEXX,BASEXX		; ベースＸ
	JNE	CLND_CURSOLE_11			;
	CMPX	OLD_BASEYY,BASEYY		; ベースＹ
	JNE	CLND_CURSOLE_11			;
	JMP	CLND_CURSOLE_55			;
CLND_CURSOLE_11:
	CALL	CLND_CURSOLE_LD			; カレンダ復元

;;	CMP	FLAG_SAVE,0			; 退避フラグ
;;	JE	CLND_CURSOLE_22			;
;;	MOVE_SET ARA001,ARAVRM,OLD_BASEXX,OLD_BASEYY,CLEND_HANI_X,CLEND_HANI_Y,OLD_BASEXX,OLD_BASEYY
;;	CALLC	MOVEVR				; vram to vram move.
;;CLND_CURSOLE_22:

	MOVE_SET ARAVRM,ARA001,BASEXX,BASEYY,CLEND_HANI_X,CLEND_HANI_Y,BASEXX,BASEYY
	CALLC	MOVEVR				; vram to vram move.


CLND_CURSOLE_55:
	CMP	FLAG_SAVE,0			; 退避フラグ
	JE	CLND_CURSOLE_66			;
	MOVE_SET ARA001,ARAVRM,OLD_CLNDXX,OLD_CLNDYY,WIDTH_DAYS_STR,HIGHT_DAYS_STR,OLD_CLNDXX,OLD_CLNDYY
	CALLC	MOVEVR				; vram to vram move.
CLND_CURSOLE_66:
	MOVE_SET ARAVRM,ARA001,CLNDXX,CLNDYY,WIDTH_DAYS_STR,HIGHT_DAYS_STR,CLNDXX,CLNDYY
	CALLC	MOVEVR				; vram to vram move.

;	-I- CLNDXX : カーソルＸ
;	    CLNDYY : カーソルＹ

	CMP	FLAG_CLEAR,1			; クリアフラグ
	JE	CLND_CURSOLE_EXIT		;

	MOV	DX,DSP_DATE			; 表示・日
	CALLC	DECSTR				;
	CALLC	STRZTS				; "00123" - > "  123"
	ADD	SI,3				;
	MOV	AX,XX1				; Ｘ
	MOV	BX,YY1				; Ｙ
	CALL	NUMBER_STR_PUT			; 数字文字列表示

	MOVX	OLD_BASEXX,BASEXX		; ベースＸ
	MOVX	OLD_BASEYY,BASEYY		; ベースＹ
	MOVX	OLD_CLNDXX,CLNDXX		; カーソルＸ
	MOVX	OLD_CLNDYY,CLNDYY		; カーソルＹ

	MOV	FLAG_SAVE,1			; 退避フラグ

	CALLC	MSCSRT
CLND_CURSOLE_EXIT:
	RET
CLND_CURSOLE	ENDP


; ****************************************************
;	カレンダ復元
;	-I/O- FLAG_SAVE : 退避フラグ
; ****************************************************

CLND_CURSOLE_LD	PROC	NEAR
	CMP	FLAG_SAVE,0			; 退避フラグ
	JE	CLND_CURSOLE_LD_22		;
	MOVE_SET ARA001,ARAVRM,OLD_BASEXX,OLD_BASEYY,CLEND_HANI_X,CLEND_HANI_Y,OLD_BASEXX,OLD_BASEYY
	CALLC	MOVEVR				; vram to vram move.
	MOV	FLAG_SAVE,0			; 退避フラグ
CLND_CURSOLE_LD_22:
	RET
CLND_CURSOLE_LD	ENDP


; ****************************************************
;	WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
; ****************************************************

WWWIDSLC2	PROC	NEAR
	CALLC	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	RET
WWWIDSLC2	ENDP

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SW_ANALOG:WORD			; analog switch.
					; 0=normal analog
					; 1=386LSX(15color)
					; 2=full DIGITAL
					; 3=B/W

EXTRN	IPLMSW:WORD			; パレットエフェクト単位時間(VSYNC)

EXTRN	USR_DATE:BYTE			; (user)現在時間退避
EXTRN	UCK_YEAR:WORD			; (user)年
EXTRN	UCK_MONTH:WORD			; (user)月
EXTRN	UCK_WEEK:WORD			; (user)曜日
EXTRN	UCK_DATE:WORD			; (user)日
EXTRN	UCK_A_DATE:WORD			; (user)年内合計日付
EXTRN	UCK_M_END:WORD			; (user)月末の日
EXTRN	UCK_SEASON:WORD			; (user)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	UCK_SHOGATSU:WORD		; (user)フラグ・正月
EXTRN	UCK_URUBI:WORD			; (user)フラグ・うるう日
EXTRN	UCK_CHRISTMAS_EVE:WORD		; (user)フラグ・クリスマスイブ
EXTRN	UCK_BORTH:WORD			; (user)フラグ・誕生日
EXTRN	UCK_HOLIDAY:WORD		; (user)フラグ・休日
EXTRN	UCK_SYUKAKU:WORD		; (user)フラグ・収穫祭の準備

EXTRN	R_SR_CHR_ADRS:WORD			; 台詞・キャラクタアドレス

SET_YEAR	DW	1659			; 設定・年代
SET_MONTH	DW	04			; 設定・月
SET_DAYS	DW	04			; 設定・日

TANJYOUBI	LABEL	BYTE			;"1659/05/04",0,0  誕生日
TANJYOUBI_YEAR	DB	"1659/"			;
TANJYOUBI_MONTH	DB	"05/"			;
TANJYOUBI_DAYS	DB	"04",0,0		;

		EVEN
CLNDTBL_S_WEEK	DB	13 DUP (0)		; 月毎の始め曜日
CLNDTBL_E_DAYS	DB	13 DUP (0)		; 月毎の末日

		EVEN
DSP_YEAR	DW	1659			; 表示・年
DSP_MONTH	DW	4			; 表示・月
DSP_DATE	DW	21			; 表示・日
DSP_SEIZA	DW	3			; 表示・星座
DSP_BLOOD	DW	2			; 表示・血液型1=A,2=AB,3=B,4=O

OLD_YEAR	DW	1659			; 前回・年
OLD_MONTH	DW	4			; 前回・月
OLD_DATE	DW	21			; 前回・日

DISP_SRT_YEAR	DW	1659			; 表示開始年

LOC_NAME_X	DW	50			; 表示・名前・Ｘ
LOC_NAME_Y	DW	8			; 表示・名前・Ｙ
LOC_YEAR_X	DW	3			; 表示・年・Ｘ
LOC_YEAR_Y	DW	12+22			; 表示・年・Ｙ
LOC_MONTH_X	DW	3+5			; 表示・月・Ｘ
LOC_MONTH_Y	DW	12+22			; 表示・月・Ｙ
LOC_DATE_X	DW	3+5+3			; 表示・日・Ｘ
LOC_DATE_Y	DW	12+22			; 表示・日・Ｙ
LOC_SEIZA_X	DW	2			; 表示・星座・Ｘ
LOC_SEIZA_Y	DW	8			; 表示・星座・Ｙ
LOC_BLOOD_X	DW	2			; 表示・血液型・Ｘ
LOC_BLOOD_Y	DW	8			; 表示・血液型・Ｙ

LOC_1_CLEND_X	DW	30			; 表示・１カレンダーＸ
LOC_1_CLEND_Y	DW	200			; 表示・１カレンダーＹ
LOC_E_CLEND_X	DW	30			; 表示・カレンダー右下Ｘ
LOC_E_CLEND_Y	DW	200			; 表示・カレンダー右下Ｙ

LOC_DAYS_X	DW	0			; 表示・カレンダー日Ｘ
LOC_DAYS_Y	DW	0			; 表示・カレンダー日Ｙ

CLM_DAYS_X	DW	0			; 表示・カレンダー日カラムＸ
CLM_DAYS_Y	DW	0			; 表示・カレンダー日カラムＹ

SET_CLD_YEAR	DW	10			; 表示・１カレンダー・年
SET_CLD_MONTH	DW	10			; 表示・１カレンダー・月
SET_CLD_DAY_END	DW	31			; 表示・１カレンダー・末日
SET_CLD_S_WEEK	DW	2			; 表示・１カレンダー・開始曜日

NOW_CLEND_DAY	DW	0			; 表示・カレンダー日

DAYS_FONT_COLOR	DW	0			; 表示・フォントカラー

SCH_POS_MNTH_N	DW	0			; サーチ・何月
SCH_POS_MNTH_X	DW	0			; サーチ・月Ｘ
SCH_POS_MNTH_Y	DW	0			; サーチ・月Ｙ
SCH_POS_OFST_X	DW	0			; サーチ・オフセットＸ
SCH_POS_OFST_Y	DW	0			; サーチ・オフセットＹ
SCH_POS_YEAR_N	DW	0			; サーチ・何年
SCH_POS_DAYS_N	DW	0			; サーチ・何日

MOUSEFLAG	DW	0		; マウスＯＮ／ＯＦＦフラグ
MOUSEX		DW	0		; マウスＸ
MOUSEY		DW	0		; マウスＹ

SCHXX		DW	0		; サーチＸ
SCHYY		DW	0		; サーチＹ

FLAG_SAVE	DW	0		; 退避フラグ
FLAG_CLEAR	DW	0		; クリアフラグ
CLNDXX		DW	0		; カーソルＸ
CLNDYY		DW	0		; カーソルＹ
OLD_CLNDXX	DW	0		; カーソル前回Ｘ
OLD_CLNDYY	DW	0		; カーソル前回Ｙ
BASEXX		DW	0		; ベースＸ
BASEYY		DW	0		; ベースＹ
OLD_BASEXX	DW	0		; ベース前回Ｘ
OLD_BASEYY	DW	0		; ベース前回Ｙ

FLAG_KETTEI	DW	0		; 決定フラグ

XX1		DW	0		; Ｘ
YY1		DW	0		; Ｙ
XX2		DW	0		; Ｘ
YY2		DW	0		; Ｙ

MSG_TITLE	DB	"娘の誕生日",0,0

DATA	ENDS

	END
;
;	end of "WIDBORTH.ASM"
;
