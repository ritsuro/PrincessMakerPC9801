; "WIDNAME.ASM" PC-9801UV11 make by R.H 1990/12/17
;
;
;	「子育て」
;
;	名前ウインドウ
;
;
;	WIDNAME_INIT			; WINDOWS/名前ウインドウ初期処理
;	WIDNAME_SET			; WINDOWS/名前ウインドウ全表示
;	WIDNAME_PRINT			; WINDOWS/名前ウインドウ文字列表示
;	WIDNAME_PRINTG			; WINDOWS/名前ウインドウ文字列ＧＯＬＤ
;	WIDNAME_MESSAGE			; WINDOWS/名前ウインドウ・メッセージ
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO\WINDOW.INC

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


BUFFLEN		EQU	8*2	; 名前バッファ長さ

				; 0=16x16,1=32x32,2=16x24,3=16x32
FONTSIZ		EQU	0	; フォントサイズ

SCREEN_STR_X	EQU	40-13	; スクリーン文字Ｘ
SCREEN_STR_Y	EQU	180	; スクリーン文字Ｙ

NAME_CHR_X1	EQU	32	; 名前Ｘキャラ位置
NAME_CHR_X2	EQU	32+2*1	;
NAME_CHR_X3	EQU	32+2*2	;
NAME_CHR_X4	EQU	32+2*3	;
NAME_CHR_X5	EQU	32+2*4	;
NAME_CHR_X6	EQU	32+2*5	;
NAME_CHR_X7	EQU	32+2*6	;
NAME_CHR_X8	EQU	32+2*7	;
NAME_CHR_Y1	EQU	200	; 名前Ｙキャラ位置
NAME_CHR_Y2	EQU	144	;

WIDTH_X		EQU	4	; 横間隔
WIDTH_X_F	EQU	8	; ファンクション横間隔
WIDTH_Y		EQU	20	; 高さ間隔

BTN_X1		EQU	17	; ボタン横位置
BTN_X2		EQU	17+4	;
BTN_X3		EQU	17+4*2	;
BTN_X4		EQU	17+4*3	;
BTN_X5		EQU	17+4*4	;
BTN_X6		EQU	17+4*5	;
BTN_X7		EQU	17+4*6	;
BTN_X8		EQU	17+4*7	;
BTN_X9		EQU	17+4*8	;
BTN_X10		EQU	17+4*9	;
BTN_X11		EQU	17+4*10	;
BTN_X12		EQU	17+4*11	;
BTN_XE		EQU	17+4*12	;
	
BTN_Y1		EQU	225	; ボタン高さ
BTN_Y2		EQU	225+20	;
BTN_Y3		EQU	225+20*2	;
BTN_Y4		EQU	225+20*3	;
BTN_Y5		EQU	225+20*4	;
BTN_Y6		EQU	225+20*5	;
BTN_Y7		EQU	225+20*6	;
BTN_Y8		EQU	225+20*7	;
BTN_Y9		EQU	225+20*8	;
BTN_Y10		EQU	225+20*9	;
BTN_Y11		EQU	225+20*10	;

FUNC_TOP	EQU	61	; ボタン番号／ファンクション先頭
FUNC_NEXT	EQU	61	; ボタン番号／ＮＥＸＴボタン
FUNC_BS		EQU	62	; ボタン番号／ＢＳボタン
FUNC_MAX	EQU	62	; ボタン番号／ボタン最後

BTN_OFSET_X	EQU	0	; キートップＸオフセット
BTN_OFSET_FX	EQU	0	; キートップＸＦＵＮＣオフセット
BTN_OFSET_Y	EQU	0	; キートップＹオフセット

FONTCOL		EQU	3	; 台詞カラー
FONTCOLF	EQU	4	; 台詞カラー・ふち
FONTCOLGL	EQU	5	; 台詞カラー・ゴールド１段
FONTCOLG	EQU	9	; 台詞カラー・ゴールド
FONTCOLGH	EQU	10	; 台詞カラー・ゴールドハイライト
FONTCOLGF	EQU	14	; 台詞カラー・ゴールドふち
TITLE_FONTCOL	EQU	14	; タイトルカラー


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA

; ****************************************************
;	WINDOWS/名前ウインドウ初期処理
; ****************************************************

FUNC	WWIDNAME_INIT,WIDNAME_INIT
	RET
FEND	WWIDNAME_INIT


; ****************************************************
;	WINDOWS/名前ウインドウ全表示
;	-I- AX : 0=最初,1=キャンセルで戻ってきた
;	-O- AX : 0=通常,1=スキップ
; ****************************************************

FUNC	WWIDNAME_SET,WIDNAME_SET
	CMP	AX,1			; 1=キャンセルで戻ってきた
	JMPEQ	WIDNAME_SET_333		;

	MOV	BX,0
	MOV	CX,16
WIDNAME_SET1:
	MOV	CRTSKP[BX],0	; パレット編集処理のスキップ(1=ｽｷｯﾌﾟ)
	INC	BX
	INC	BX
	LOOP	WIDNAME_SET1

;*;	; (1) 空色
;*;
;*;	MOV	VX1,0
;*;	MOV	VY1,0
;*;	MOV	VX2,79
;*;	MOV	VY2,399
;*;	MOV	CX,11
;*;	CALLC	BOXPAL			; ＢＯＸペイント

	; (2) ボタン

	CALL	WIDNAME_OPEN		; ウインドウＯＰＥＮ

	; (3) ジワー

	MOV	CLRVEW,250		; color.
	MOV	CLRCNS,56		; contrast.
	MOV	CLRBRI,100		; brightness.
	CALLC	PLTCIS			; カラー・ＩＮ／時分割初期
	MOV	AX,60*1			;
	CALLC	TMVWAT			; V-SYNC timer wait.
	MOV	CX,22			;
WIDNAME_SET_LOOP:			;
	PUSH	CX			;
	MOV	AX,2			;
	CALLC	TMVWAT			; V-SYNC timer wait.
	CALLC	PLTOLT			; パレット・オーバラップ／時分割処理
	POP	CX			;
	LOOP	WIDNAME_SET_LOOP	;

WIDNAME_SET_1:				;

	; (4) 入力セット

	MOV	SCRN_MSG,1		;"family name（あなたの名字）"
	CALL	SCREEN_PRINT		; スクリーンＰＲＩＮＴ

WIDNAME_SET_2:				;

	; (4-1) 名前消し

	MOV	VX1,18
	MOV	VY1,136
	MOV	VX2,60
	MOV	VY2,136+26
	MOV	CX,2
	CALLC	BOXPAL			; ＢＯＸペイント

	CALLC	MSCSRT			; カーソルスタート
	CALL	WIDPNL_SELECT		; パネル・ウインドウ選択指定
	PUSH	AX			;
	CALLC	MSCSTP			;
	POP	AX			;
	CMP	AX,1			; 1=スキップ
	JMPEQ	WIDNAME_SET_SKIP	;
	CMP	AX,2			; 2=キャンセル
	JE	WIDNAME_SET_2		;
	CALL	FAMILY_NAME_SET		; ファミリーネームセット

	; (5) 名前消し

	MOV	VX1,18
	MOV	VY1,136
	MOV	VX2,60
	MOV	VY2,200
	MOV	CX,2
	CALLC	BOXPAL			; ＢＯＸペイント

	; (6) カラーＯＬ

	MOV	AX,0			; オーバラップ開始パレットテーブル番号
	MOV	BX,2			; オーバラップ終了パレットテーブル番号
	CALLC	PLTOLS			; パレット・オーバラップ／時分割初期
	MOV	AX,60*1			;
	CALLC	TMVWAT			; V-SYNC timer wait.
	MOV	CX,22			;
WIDNAME_SET_LOOP2:			;
	PUSH	CX			;
	MOV	AX,1			;
	CALLC	TMVWAT			; V-SYNC timer wait.
	CALLC	PLTOLT			; パレット・オーバラップ／時分割処理
	POP	CX			;
	LOOP	WIDNAME_SET_LOOP2	;

	JMP	WIDNAME_SET_444		;

WIDNAME_SET_333:			;
	CALL	WIDNAME_OPEN		; ウインドウＯＰＥＮ
WIDNAME_SET_444:			;

	; (7) 娘の名前

	MOV	SCRN_MSG,2		;"girl's name（むすめのなまえ）"
	CALL	SCREEN_PRINT		; スクリーンＰＲＩＮＴ
	CALLC	MSCSRT			; カーソルスタート
	CALL	WIDPNL_SELECT		; パネル・ウインドウ選択指定
	PUSH	AX			;
	CALLC	MSCSTP			;
	POP	AX			;
	CMP	AX,2			; 2=キャンセル
	JNE	WIDNAME_SET_55		;

	; (7-2) キャンセルカラーＯＬ

	MOV	AX,2			; オーバラップ開始パレットテーブル番号
	MOV	BX,0			; オーバラップ終了パレットテーブル番号
	CALLC	PLTOLS			; パレット・オーバラップ／時分割初期
	MOV	AX,60*1			;
	CALLC	TMVWAT			; V-SYNC timer wait.
	MOV	CX,22			;
WIDNAME_SET_LOOP0:			;
	PUSH	CX			;
	MOV	AX,1			;
	CALLC	TMVWAT			; V-SYNC timer wait.
	CALLC	PLTOLT			; パレット・オーバラップ／時分割処理
	POP	CX			;
	LOOP	WIDNAME_SET_LOOP0	;

	JMP	WIDNAME_SET_1		;

WIDNAME_SET_55:				;
	CALL	GIRLS_NAME_SET		; ファーストネームセット

	CALL	WIDNAME_CLOSE		; ウインドウＣＬＯＳＥ
	MOV	AX,0			; 0=通常
	RET
WIDNAME_SET_SKIP:
	CALLC	MSCSTP			;
	MOV	AX,1			; 1=スキップ
	RET
FEND	WWIDNAME_SET


; ****************************************************
;	WINDOWS/名前ウインドウ文字列表示
;	-I- DS:SI   : string. (null=end of string)
;	    AX      : location x point.
;	    BX      : location y point.
; ****************************************************

FUNC	WWIDNAME_PRINT,WIDNAME_PRINT
	CALL	STRING_PUT		; 文字列の表示
	RET
FEND	WWIDNAME_PRINT


; ****************************************************
;	WINDOWS/名前ウインドウ文字列ＧＯＬＤ
;	-I- DS:SI   : string. (null=end of string)
;	    AX      : location x point.
;	    BX      : location y point.
; ****************************************************

FUNC	WWIDNAME_PRINTG,WIDNAME_PRINTG
	CALL	STRING_PUTG		; 文字列の表示・ＧＯＬＤ
	RET
FEND	WWIDNAME_PRINTG


; ****************************************************
;	WINDOWS/名前ウインドウ・メッセージ
;	-I- DX : スクリーンメッセージ番号
;		3="blood type  （むすめの血液型）"
; ****************************************************

FUNC	WWIDNAME_MESSAGE,WIDNAME_MESSAGE
	MOV	SCRN_MSG,DX		; スクリーンメッセージ番号
	CALL	SCREEN_PRINT		; スクリーンＰＲＩＮＴ
	RET
FEND	WWIDNAME_MESSAGE


; ****************************************************
;	ウインドウＯＰＥＮ
; ****************************************************

WIDNAME_OPEN	PROC	NEAR
;*;	MOV	VX1,15
;*;	MOV	VY1,156
;*;	MOV	VX2,63
;*;	MOV	VY2,380
;*;	MOV	CX,2
;*;	CALLC	BOXPAL			; ＢＯＸペイント

	CALL	BOTTAN_PUTS		; ボタンＰＵＴ

	RET
WIDNAME_OPEN	ENDP


; ****************************************************
;	ウインドウＣＬＯＳＥ
; ****************************************************

WIDNAME_CLOSE	PROC	NEAR
	RET
WIDNAME_CLOSE	ENDP



; ****************************************************
;	パネル・ウインドウ選択指定
;	-I- SCRN_MSG   : スクリーンメッセージ番号(１のとき＋スキップ出来る技)
;	-O- SSLINE_BUF : 名前バッファ
;	    SSLINE_LEN : 名前バッファ文字長さ
;	    AX         : 0=通常,1=スキップ,2=キャンセル
; ****************************************************

WIDPNL_SELECT	PROC	NEAR
	MOV	AX,0			; カーソル現在位置
	CALL	NAME_CUR_SET		; 名前カーソルセット

	MOV	NOW_BOTTAN,OFFF		; 現在ボタン番号
WIDPNL_SELECT_RETRY:			;
	CALLC	MSCWAT			; カーソルボタンＯＦＦ待ち

	MOV	MOUSEFLAG,OFFF		; マウスＯＮ／ＯＦＦフラグ
	MOV	SSLINE_LEN,0		; 名前バッファ文字長さ
WIDPNL_SELECT_LOOP:			;
	CMP	SCRN_MSG,1		; (１のとき＋スキップ出来る技)
	JNE	WIDPNL_SELECT_01	;
	CALLC	KEYTEN			; キーボード・読み込み
	CMP	BX,3			; 3=PLUS,4=ESC (-1:押していない)
	JNE	WIDPNL_SELECT_01	;
	JMP	WIDPNL_SELECT_ENDSKIP	;
WIDPNL_SELECT_01:			;

	CALLC	MSCMOV			; カーソル移動
	CMP	DL,1			; 右ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	WIDPNL_SELECT_1		;
	JMP	WIDPNL_SELECT_CANCEL	;
WIDPNL_SELECT_1:			;
	CMP	DH,1			; 左ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	WIDPNL_SELECT_2		;
	JMP	WIDPNL_SELECT_ON	;
WIDPNL_SELECT_2:			;
	MOV	MOUSEX,AX		; マウスＸ
	MOV	MOUSEY,BX		; マウスＹ

	MOV	MOUSEFLAG,OFFF		; マウスＯＮ／ＯＦＦフラグ

	CALL	BOTTAN_PIC		; ボタンピック
	CMP	AX,1			; 1=見つかった,0=見つからない
	JE	WIDPNL_SELECT_CHK	;

	CMP	NOW_BOTTAN,OFFF		; 現在ボタン番号
	JE	WIDPNL_SELECT_SKIP0	;
	MOV	AX,NOW_BOTTAN		; 現在ボタン番号
	MOV	BTNNUMBER,AX		; ボタン番号
	CALLC	MSCSTP			; カーソルストップ
	CALL	BTN_OFF			; ボタンＯＦＦ
	CALLC	MSCSRT			; カーソルスタート
WIDPNL_SELECT_SKIP0:			;
	MOV	NOW_BOTTAN,OFFF		; 現在ボタン番号

	JMP	WIDPNL_SELECT_NEXT	;

WIDPNL_SELECT_CHK:			;
	MOV	AX,NOW_BOTTAN		; 現在ボタン番号
	CMP	AX,BTNNUMBER		; ボタン番号
	JE	WIDPNL_SELECT_NEXT	;

	CALLC	MSCSTP			; カーソルストップ

	CMP	NOW_BOTTAN,OFFF		; 現在ボタン番号
	JE	WIDPNL_SELECT_SKIP	;
	PUSH	BTNNUMBER		; ボタン番号
	MOV	AX,NOW_BOTTAN		; 現在ボタン番号
	MOV	BTNNUMBER,AX		; ボタン番号
	CALL	BTN_OFF			; ボタンＯＦＦ
	POP	BTNNUMBER		; ボタン番号
WIDPNL_SELECT_SKIP:			;

	CALL	BTN_ON			; ボタンＯＮ

	CALLC	MSCSRT			; カーソルスタート

	MOV	AX,BTNNUMBER		; ボタン番号
	MOV	NOW_BOTTAN,AX		; 現在ボタン番号

	JMP	WIDPNL_SELECT_NEXT	;

WIDPNL_SELECT_ON:			;
	CMP	MOUSEFLAG,OFFF		; マウスＯＮ／ＯＦＦフラグ
	JNE	WIDPNL_SELECT_NEXT	;

	MOV	MOUSEFLAG,0		; マウスＯＮ／ＯＦＦフラグ

	CALL	NAME_EDIT		; 名前編集

	CMP	BTNNUMBER,FUNC_NEXT	; ボタン番号／ＮＥＸＴボタン
	JE	WIDPNL_SELECT_EXIT	;
WIDPNL_SELECT_NEXT:			;
;*;	CALL	BOTTAN_ANIME		; ボタンアニメーション
;*;	CALL	NAME_CUR_BRN		; 名前カーソル点滅

	JMP	WIDPNL_SELECT_LOOP	;
WIDPNL_SELECT_EXIT:			;

	CALL	WID_CHECK		; 禁則チェック
	CMP	AX,0			; 0=ＯＫ,1=駄目
	JE	WIDPNL_SELECT_EXIT2	;
	JMP	WIDPNL_SELECT_RETRY	;
WIDPNL_SELECT_EXIT2:			;
	CALLC	MSCSTP			; カーソルストップ
	CALL	BTN_OFF			; ボタンＯＦＦ
	CALLC	MSCSRT			; カーソルスタート

;*;	CALL	WEL_COME		; ようこそ
	MOV	AX,0			; 0=通常
	RET
WIDPNL_SELECT_ENDSKIP:			;
	MOV	AX,1			; 1=スキップ
	RET
WIDPNL_SELECT_CANCEL:			;
	CALLC	MSCSTP			; カーソルストップ
	CALL	BTN_OFF			; ボタンＯＦＦ
	CALLC	MSCSRT			; カーソルスタート
	MOV	AX,2			; 2=キャンセル
	RET
WIDPNL_SELECT	ENDP


; ****************************************************
;	ボタンピック
;	-I- MOUSEX    : マウスＸ
;	    MOUSEY    : マウスＹ
;	-O- AX        : 1=見つかった,0=見つからない
;	    BTNNUMBER : ボタン番号
;	    BTNX      : ボタンＸ
;	    BTNY      : ボタンＹ
; ****************************************************

BOTTAN_PIC	PROC	NEAR
	MOV	AX,MOUSEX		; マウスＸ
	MOV	BX,MOUSEY		; マウスＹ

	CMP	BX,BTN_Y6		;
	JL	BOTTAN_PIC02		;
	JMP	BOTTAN_PIC_CDAN		; 中段
BOTTAN_PIC02:				;

	CMP	AX,BTN_X1		; ボタン横位置
	JGE	BOTTAN_PIC3		;
	JMP	BOTTAN_PIC_NOT_FOUND	;
BOTTAN_PIC3:				;
	CMP	AX,BTN_X2		;
	JGE	BOTTAN_PIC31		;
	MOV	BTNNUMBER,1		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC31:				;
	CMP	AX,BTN_X3		;
	JGE	BOTTAN_PIC32		;
	MOV	BTNNUMBER,6		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC32:				;
	CMP	AX,BTN_X4		;
	JGE	BOTTAN_PIC33		;
	MOV	BTNNUMBER,11		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC33:				;
	CMP	AX,BTN_X5		;
	JGE	BOTTAN_PIC34		;
	MOV	BTNNUMBER,16		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC34:				;
	CMP	AX,BTN_X6		;
	JGE	BOTTAN_PIC35		;
	MOV	BTNNUMBER,21		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC35:				;
	CMP	AX,BTN_X7		;
	JGE	BOTTAN_PIC36		;
	MOV	BTNNUMBER,26		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC36:				;
	CMP	AX,BTN_X8		;
	JGE	BOTTAN_PIC37		;
	MOV	BTNNUMBER,31		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC37:				;
	CMP	AX,BTN_X9		;
	JGE	BOTTAN_PIC38		;
	MOV	BTNNUMBER,36		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC38:				;
	CMP	AX,BTN_X10		;
	JGE	BOTTAN_PIC39		;
	MOV	BTNNUMBER,41		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC39:				;
	CMP	AX,BTN_X11		;
	JNBE	BOTTAN_PIC40		;
	MOV	BTNNUMBER,46		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC40:				;
	CMP	AX,BTN_X12		;
	JNBE	BOTTAN_PIC41		;
	MOV	BTNNUMBER,51		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;
BOTTAN_PIC41:				;
	CMP	AX,BTN_XE		;
	JNBE	BOTTAN_PIC_NOT_FOUND	;
	MOV	BTNNUMBER,56		; ボタン番号
	JMP	BOTTAN_PIC_SCH		;

BOTTAN_PIC_CDAN:			; 中段
	MOV	BTNNUMBER,FUNC_TOP	; ボタン番号／ファンクション先頭
	JMP	BOTTAN_PIC_SCH		;


BOTTAN_PIC_SCH:				;
	MOV	CX,5			;
BOTTAN_PIC_LOOP:			;
	CMP	BTNNUMBER,FUNC_MAX	; ボタン番号／ボタン最後
	JNBE	BOTTAN_PIC_NOT_FOUND	;
	PUSH	CX			;
	CALL	BTN_LOC_CMP		; ボタンロケーション比較
	POP	CX			;
	CMP	AX,1			; 1=一致する,0=一致しない
	JE	BOTTAN_PIC_NOT_OK	;
	INC	BTNNUMBER		; ボタン番号
	LOOP	BOTTAN_PIC_LOOP		;

	JMP	BOTTAN_PIC_NOT_FOUND	;

BOTTAN_PIC_NOT_OK:
	MOV	AX,1			; 1=見つかった
	RET				;
BOTTAN_PIC_NOT_FOUND:
	MOV	BTNNUMBER,0		; ボタン番号
	MOV	AX,0			; 0=見つからない
	RET				;
BOTTAN_PIC	ENDP


; ****************************************************
;	ボタンロケーション比較
;	-I- BTNNUMBER : ボタン番号
;	    MOUSEX    : マウスＸ
;	    MOUSEY    : マウスＹ
;	-O- AX        : 1=一致する,0=一致しない
;	    BTNX      : ボタンＸ
;	    BTNY      : ボタンＹ
; ****************************************************

BTN_LOC_CMP	PROC	NEAR
	CALL	BTN_LOC			; ボタンロケーション計算
	MOV	AX,BTNX			; ボタンＸ
	MOV	BX,BTNY			; ボタンＹ
	MOV	CX,AX			; X
	MOV	DX,BX			; Y
	ADD	CX,BTNXSZ		; ボタンサイズＸ
	ADD	DX,BTNYSZ		; ボタンサイズＹ
	DEC	CX			; 横間隔
	DEC	DX			; 高さ間隔

	CMP	MOUSEX,AX		; マウスＸ
	JB	BTN_LOC_CMP_NON		;
	CMP	MOUSEX,CX		; マウスＸ
	JNBE	BTN_LOC_CMP_NON		;

	CMP	MOUSEY,BX		; マウスＹ
	JB	BTN_LOC_CMP_NON		;
	CMP	MOUSEY,DX		; マウスＹ
	JNBE	BTN_LOC_CMP_NON		;
BTN_LOC_CMP_EQ:
	MOV	AX,1			; 1=一致する
	RET				;
BTN_LOC_CMP_NON:
	MOV	AX,0			; 0=一致しない
	RET				;
BTN_LOC_CMP	ENDP


; ****************************************************
;	名前カーソルセット
;	-I- AX : カーソル現在位置
; ****************************************************

NAME_CUR_SET	PROC	NEAR
	MOV	CURSOLE_NOW,AX		; カーソル現在位置
	MOV	CURSOLE_FLAG,0		; カーソルＯＮ／ＯＦＦ
	RET
NAME_CUR_SET	ENDP


; ****************************************************
;	スクリーンＰＲＩＮＴ
;	-I- SCRN_MSG : スクリーンメッセージ番号
; ****************************************************

SCREEN_PRINT	PROC	NEAR
	MOV	SCREEN_LINE,0		; スクリーン行

	MOV	VX1,18
	MOV	VY1,136
	MOV	VX2,60
	MOV	VY2,200
	MOV	CX,2
	CALLC	BOXPAL			; ＢＯＸペイント

	CALL	SCREEN_PRIN2		; スクリーンＰＲＩＮＴ２
	RET
SCREEN_PRINT	ENDP


; ****************************************************
;	スクリーンＰＲＩＮＴ２
;	-I- SCRN_MSG    : スクリーンメッセージ番号
;	    SCREEN_LINE : スクリーン行
; ****************************************************

SCREEN_PRIN2	PROC	NEAR
	MOV	BX,SCRN_MSG		; スクリーンメッセージ番号
	SHL	BX,1			; word pointer.
	MOV	SI,DS:SCRN_MSG_TABLE[BX] ; スクリーンメッセージテーブル

	LODSW				;
	MOV	WORD PTR SCREEN_CHR,AX	; スクリーンＰＵＴキャラクタ
	MOV	DX,SCREEN_STR_X		; スクリーン文字Ｘ

	MOV	AX,SCREEN_LINE		; スクリーン行
	MOV	BL,16			;
	IMUL	BL			; AL=AL*BL
	ADD	AX,SCREEN_STR_Y		; スクリーン文字Ｙ
	MOV	BX,AX			; Y.

SCREEN_PRIN2_LOOP:			;
	PUSH	DX			;
	PUSH	BX			;
	PUSH	SI			;

	MOV	AX,DX			; X.
	MOV	SI,OFFSET SCREEN_CHR	; スクリーンＰＵＴキャラクタ
	CALL	STRING_PUT		; 文字列の表示

	POP	SI			;
	POP	BX			;
	POP	DX			;
	ADD	DX,2			; X=X+2
	LODSW				;
	MOV	WORD PTR SCREEN_CHR,AX	; スクリーンＰＵＴキャラクタ
	CMP	AL,0			;
	JNE	SCREEN_PRIN2_LOOP	;

	RET
SCREEN_PRIN2	ENDP



; ****************************************************
;	ボタンＰＵＴ
; ****************************************************

BOTTAN_PUTS	PROC	NEAR
	MOV	BTNNUMBER,1		; ボタン番号

	MOV	CX,FUNC_MAX		; ボタン番号／ボタン最後
BOTTAN_PUTS_LOOP:			;
	PUSH	CX			;

	CALL	BTN_OFF			; ボタンＯＦＦ
	INC	BTNNUMBER		; ボタン番号

	POP	CX			;
	LOOP	BOTTAN_PUTS_LOOP	;

	RET
BOTTAN_PUTS	ENDP


; ****************************************************
;	ボタンＯＦＦ
;	-I- BTNNUMBER : ボタン番号
; ****************************************************

BTN_OFF	PROC	NEAR
	CALL	BTN_LOC			; ボタンロケーション計算
	CALL	BTN_KTOPB		; ボタン・キートップＰＵＴ影付き
	RET
BTN_OFF	ENDP


; ****************************************************
;	ボタンＯＮ
;	-I- BTNNUMBER : ボタン番号
; ****************************************************

BTN_ON	PROC	NEAR
	CALL	BTN_LOC		; ボタンロケーション計算
	CALL	BTN_KTOPB_ON	; ボタン・キートップＰＵＴ影付き／ＯＮ
	RET
BTN_ON	ENDP


; ****************************************************
;	ボタン・キートップＰＵＴ影付き
;	-I- BTNNUMBER : ボタン番号
;	    BTNX      : ボタンＸ
;	    BTNY      : ボタンＹ
; ****************************************************

BTN_KTOPB	PROC	NEAR
	CALL	BTN_CHAR		; ボタン・キャラクタ

	MOV	AX,BTNX      		; ボタンＸ
	MOV	BX,BTNY			; ボタンＹ

	CMP	BTNNUMBER,FUNC_TOP	; ボタン番号／ファンクション先頭
	JGE	BTN_KTOPB2		;
	ADD	AX,BTN_OFSET_X		; キートップＸオフセット
	JMP	BTN_KTOPB21		;
BTN_KTOPB2:				;
	ADD	AX,BTN_OFSET_FX		; キートップＸＦＵＮＣオフセット
BTN_KTOPB21:
	ADD	BX,BTN_OFSET_Y		; キートップＹオフセット

	MOV	SI,OFFSET SSETA_CHAR	; 入力キャラクタ
	CALL	STRING_PUT		; 文字列の表示
	RET
BTN_KTOPB	ENDP


; ****************************************************
;	ボタン・キートップＰＵＴ影付き／ＯＮ
;	-I- BTNNUMBER : ボタン番号
;	    BTNX      : ボタンＸ
;	    BTNY      : ボタンＹ
; ****************************************************

BTN_KTOPB_ON	PROC	NEAR
	CALL	BTN_CHAR		; ボタン・キャラクタ

	MOV	AX,BTNX      		; ボタンＸ
	MOV	BX,BTNY			; ボタンＹ

	CMP	BTNNUMBER,FUNC_TOP	; ボタン番号／ファンクション先頭
	JGE	BTN_KTOPB_ON2		;
	ADD	AX,BTN_OFSET_X		; キートップＸオフセット
	JMP	BTN_KTOPB_ON21		;
BTN_KTOPB_ON2:				;
	ADD	AX,BTN_OFSET_FX		; キートップＸＦＵＮＣオフセット
BTN_KTOPB_ON21:
	ADD	BX,BTN_OFSET_Y		; キートップＹオフセット

	MOV	SI,OFFSET SSETA_CHAR	; 入力キャラクタ
	CALL	STRING_PUTG		; 文字列の表示・ＧＯＬＤ
	RET
BTN_KTOPB_ON	ENDP




; ****************************************************
;	文字列の表示
;	-i- DS:SI   : string. (null=end of string)
;	    AX      : location x point.
;	    BX      : location y point.
; ****************************************************

STRING_PUT	PROC	NEAR
	MOV	STRN_XX,AX		; 文字Ｘ
	MOV	STRN_YY,BX		; 文字Ｙ
	MOV	STRN_ADRS,SI		; 文字アドレス

	MOV	AX,FONTSIZ		; フォントサイズ
	CALLC	VTXSIZ			; character size set.

	MOV	AX,FONTCOLF		; 台詞カラー・ふち
	CALLC	VTXCOL			; character color set.
	MOV	AX,STRN_XX		; 文字Ｘ
	MOV	BX,STRN_YY		; 文字Ｙ
	ADD	BX,2			; 文字Ｙ
	MOV	SI,STRN_ADRS		; 文字アドレス
	CALLC	VTXPOR			; vram text print OR.

	MOV	AX,FONTCOL		; 台詞カラー
	CALLC	VTXCOL			; character color set.
	MOV	AX,STRN_XX		; 文字Ｘ
	MOV	BX,STRN_YY		; 文字Ｙ
	MOV	SI,STRN_ADRS		; 文字アドレス
	CALLC	VTXPOR			; vram text print OR.
	MOV	AX,STRN_XX		; 文字Ｘ
	MOV	BX,STRN_YY		; 文字Ｙ
	ADD	BX,1			; 文字Ｙ
	MOV	SI,STRN_ADRS		; 文字アドレス
	CALLC	VTXPOR			; vram text print OR.

	RET
STRING_PUT	ENDP


; ****************************************************
;	文字列の表示・ＧＯＬＤ
;	-i- DS:SI   : string. (null=end of string)
;	    AX      : location x point.
;	    BX      : location y point.
; ****************************************************

STRING_PUTG	PROC	NEAR
	PUSH	SEGVT0		; text put vram segment plean 0.
	PUSH	SEGVT1		; text put vram segment plean 1.
	PUSH	SEGVT2		; text put vram segment plean 2.
	PUSH	SEGVT3		; text put vram segment plean 3.

	PUSH	SSEFC0		; visual data segment plean 0
	PUSH	SSEFC1		; visual data segment plean 1
	PUSH	SSEFC2		; visual data segment plean 2
	PUSH	SSEFC3		; visual data segment plean 3

	MOV	STRN_XX,AX		; 文字Ｘ
	INC	BX			;
	MOV	STRN_YY,BX		; 文字Ｙ
	MOV	STRN_ADRS,SI		; 文字アドレス

	CALL	STRXLEN			; string length.
	MOV	STRN_LEN,CX		; 文字長さ

	MOVX	SEGVT0,ARA003[0]	; text put vram segment plean 0.
	MOVX	SEGVT1,ARA003[2]	; text put vram segment plean 1.
	MOVX	SEGVT2,ARA003[4]	; text put vram segment plean 2.
	MOVX	SEGVT3,ARA003[6]	; text put vram segment plean 3.

	MOVX	SSSOU0,ARA003[0]
	MOVX	SSSOU1,ARA003[2]
	MOVX	SSSOU2,ARA003[4]
	MOVX	SSSOU3,ARA003[6]
	MOVX	SSDES0,ARAVRM[0]
	MOVX	SSDES1,ARAVRM[2]
	MOVX	SSDES2,ARAVRM[4]
	MOVX	SSDES3,ARAVRM[6]

	MOVX	SSEFC0,ARA003[0]	; visual data segment plean 0
	MOVX	SSEFC1,ARA003[2]	; visual data segment plean 1
	MOVX	SSEFC2,ARA003[4]	; visual data segment plean 2
	MOVX	SSEFC3,ARA003[6]	; visual data segment plean 3
	MOV	VX1,0
	MOV	VY1,0
	MOV	VX2,40
	MOV	VY2,60
	MOV	CX,2
	CALLC	BOXPAL		; ＢＯＸペイント


	MOV	AX,FONTSIZ		; フォントサイズ
	CALLC	VTXSIZ			; character size set.

	; (1) ノーマル部分

	MOV	AX,FONTCOLGF		; 台詞カラー・ゴールドふち
	CALLC	VTXCOL			; character color set.
	MOV	AX,0			; 文字Ｘ
	MOV	BX,1;2			; 文字Ｙ
	MOV	SI,STRN_ADRS		; 文字アドレス
	CALLC	VTXPOR			; vram text print OR.

	MOV	AX,FONTCOLGL		; 台詞カラー・ゴールド１段
	CALLC	VTXCOL			; character color set.
	MOV	AX,0			; 文字Ｘ
	MOV	BX,0			; 文字Ｙ
	MOV	SI,STRN_ADRS		; 文字アドレス
	CALLC	VTXPOR			; vram text print OR.
;*;	MOV	AX,0			; 文字Ｘ
;*;	MOV	BX,1			; 文字Ｙ
;*;	MOV	SI,STRN_ADRS		; 文字アドレス
;*;	CALLC	VTXPOR			; vram text print OR.

	; (2) ゴールド部分

	MOV	AX,FONTCOLGF		; 台詞カラー・ゴールドふち
	CALLC	VTXCOL			; character color set.
	MOV	AX,0			; 文字Ｘ
	MOV	BX,1+20;2+20			; 文字Ｙ
	MOV	SI,STRN_ADRS		; 文字アドレス
	CALLC	VTXPOR			; vram text print OR.

	MOV	AX,FONTCOLG		; 台詞カラー・ゴールド
	CALLC	VTXCOL			; character color set.
	MOV	AX,0			; 文字Ｘ
	MOV	BX,0+20			; 文字Ｙ
	MOV	SI,STRN_ADRS		; 文字アドレス
	CALLC	VTXPOR			; vram text print OR.
;*;	MOV	AX,0			; 文字Ｘ
;*;	MOV	BX,1+20			; 文字Ｙ
;*;	MOV	SI,STRN_ADRS		; 文字アドレス
;*;	CALLC	VTXPOR			; vram text print OR.

	; (3) ハイライト部分

	MOV	AX,FONTCOLGF		; 台詞カラー・ゴールドふち
	CALLC	VTXCOL			; character color set.
	MOV	AX,0			; 文字Ｘ
	MOV	BX,1+40;2+40			; 文字Ｙ
	MOV	SI,STRN_ADRS		; 文字アドレス
	CALLC	VTXPOR			; vram text print OR.

	MOV	AX,FONTCOLGH		; 台詞カラー・ゴールドハイライト
	CALLC	VTXCOL			; character color set.
	MOV	AX,0			; 文字Ｘ
	MOV	BX,0+40			; 文字Ｙ
	MOV	SI,STRN_ADRS		; 文字アドレス
	CALLC	VTXPOR			; vram text print OR.
;*;	MOV	AX,0			; 文字Ｘ
;*;	MOV	BX,1+40			; 文字Ｙ
;*;	MOV	SI,STRN_ADRS		; 文字アドレス
;*;	CALLC	VTXPOR			; vram text print OR.

	; (4) 合成と画面転送

	MOV	VX1,0			; まず、ノーマルを置く
	MOV	VY1,0			;
	MOVX	VX2,STRN_LEN		; 文字長さ
	MOV	VY2,16+2		;
	MOVX	VX3,STRN_XX		; 文字Ｘ
	MOVX	VY3,STRN_YY		; 文字Ｙ
	CALLC	MOVEVR			; vram to vram move.

	MOV	VX1,0			; つぎに、ゴールドの帯を真中へ置き、
	MOV	VY1,20+4		;
	MOVX	VX2,STRN_LEN		; 文字長さ
	MOV	VY2,5			;
	MOVX	VX3,STRN_XX		; 文字Ｘ
	MOVX	VY3,STRN_YY		; 文字Ｙ
	ADD	VY3,4			;
	CALLC	MOVEVR			; vram to vram move.

	MOV	VX1,0			; 仕上げに、ハイライトを入れる
	MOV	VY1,40+5		;
	MOVX	VX2,STRN_LEN		; 文字長さ
	MOV	VY2,2			;
	MOVX	VX3,STRN_XX		; 文字Ｘ
	MOVX	VY3,STRN_YY		; 文字Ｙ
	ADD	VY3,5			;
	CALLC	MOVEVR			; vram to vram move.

	POP	SSEFC3		; visual data segment plean 3
	POP	SSEFC2		; visual data segment plean 2
	POP	SSEFC1		; visual data segment plean 1
	POP	SSEFC0		; visual data segment plean 0

	POP	SEGVT3		; text put vram segment plean 3.
	POP	SEGVT2		; text put vram segment plean 2.
	POP	SEGVT1		; text put vram segment plean 1.
	POP	SEGVT0		; text put vram segment plean 0.
	RET
STRING_PUTG	ENDP


; ****************************************************
;	ボタンロケーション計算
;	-I- BTNNUMBER : ボタン番号
;	-O- BTNX      : ボタンＸ
;	    BTNY      : ボタンＹ
;	    BTNXSZ    : ボタンサイズＸ
;	    BTNYSZ    : ボタンサイズＹ
; ****************************************************

BTN_LOC	PROC	NEAR
	CMP	BTNNUMBER,FUNC_TOP	; ボタン番号／ファンクション先頭
	JGE	BTN_LOC_55		;

	MOV	AX,BTNNUMBER		; ボタン番号
	DEC	AX			; AX=AX-1
	CWD				;
	MOV	BX,5			; 縦に５個ずつ並んでいる
	IDIV	BX			; AX=AX/BX  DX=AX MOD BX

	MOV	BL,WIDTH_X		; x 横間隔　横は何列目か？
	IMUL	BL			; AX=AL*BL

	ADD	AX,BTN_X1		; ボタン横位置
	MOV	BTNX,AX			; ボタンＸは求められた

	MOV	AX,DX			; 縦何段目か？
	MOV	BX,WIDTH_Y		; 高さ間隔
	CWD				;
	IMUL	BX			; AX=AX*BX
	ADD	AX,BTN_Y1		; ボタン高さ
	MOV	BTNY,AX			; ボタンＹは求められた

	MOV	BTNXSZ,WIDTH_X		; ボタンサイズＸ
	MOV	BTNYSZ,WIDTH_Y		; ボタンサイズＹ

	JMP	BTN_LOC_99		;

BTN_LOC_55:				; 中段

	MOV	AX,BTNNUMBER		; ボタン番号
	SUB	AX,FUNC_TOP		; ボタン番号／ファンクション先頭
	MOV	BX,WIDTH_X_F		; ファンクション横間隔
	IMUL	BL			; AX=AX*BX
	ADD	AX,BTN_X1		; ボタン横位置
	MOV	BTNX,AX			; ボタンＸは求められた

	MOV	BTNY,BTN_Y6		; ボタン高さ

	MOV	BTNXSZ,WIDTH_X_F	; ボタンサイズＸ
	MOV	BTNYSZ,WIDTH_Y		; ボタンサイズＹ

	JMP	BTN_LOC_99		;

BTN_LOC_99:
	RET
BTN_LOC	ENDP


; ****************************************************
;	ボタン・キャラクタ
;	-I- BTNNUMBER  : ボタン番号
;	-O- SSETA_CHAR : 入力キャラクタ
; ****************************************************

BTN_CHAR	PROC	NEAR
	CMP	BTNNUMBER,FUNC_TOP	; ボタン番号／ファンクション先頭
	JGE	BTN_CHAR_FUNC		;

	CALL	BTN_CHAR2		; ボタン・キャラクタその２

	RET

BTN_CHAR_FUNC:
	MOV	BX,BTNNUMBER		; ボタン番号／ファンクション先頭
	SUB	BX,FUNC_TOP		; ボタン番号／ファンクション先頭
	SHL	BX,1			;
	MOV	SI,DS:FUNC_TOP_TABLE[BX] ; ファンクション
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET SSETA_CHAR	; 入力キャラクタ
	MOV	CX,8			;
	REP	MOVSB			;
	MOV	WORD PTR SSETA_CHAR[8],0 ; 入力キャラクタ
	RET
BTN_CHAR	ENDP


; ****************************************************
;	ボタン・キャラクタその２
;	-I- BTNNUMBER  : ボタン番号
;	-O- SSETA_CHAR : 入力キャラクタ
; ****************************************************

BTN_CHAR2	PROC	NEAR
	MOV	BX,BTNNUMBER		; ボタン番号
	DEC	BX			; base.
	SHL	BX,1			; word pointer.
	MOV	AX,WORD PTR DS:BTN_TOP_TABLE[BX]
	MOV	WORD PTR SSETA_CHAR,AX	 ; 入力キャラクタ
	MOV	WORD PTR SSETA_CHAR[2],0 ; 入力キャラクタ
	RET
BTN_CHAR2	ENDP


; ****************************************************
;	名前プリント
;	・このプリントは最後の１文字のみＰＵＴします
;	-I- SSLINE_LEN : 名前バッファ文字長さ
;	    SSLINE_BUF : 名前バッファ
; ****************************************************

NAME_PRINT	PROC	NEAR
	MOV	BX,SSLINE_LEN		; 名前バッファ文字長さ
	CMP	BX,0			;
	JE	NAME_PRINT_EXIT		;

	DEC	BX			;
	DEC	BX			; - 2
	MOV	AX,WORD PTR DS:SSLINE_BUF[BX]	; 名前バッファ
	MOV	WORD PTR NAME_CHR,AX	; なまえキャラクタ(2byte)

	SHR	BX,1			; / 2
	MOV	NAME_NUM,BX		; なまえキャラ番号
	CALL	NAME_CHR_PUT		; 名前キャラＰＵＴ
NAME_PRINT_EXIT:			;
	RET
NAME_PRINT	ENDP


; ****************************************************
;	名前キャラＰＵＴ
;	-I- NAME_NUM : なまえキャラ番号
;	    NAME_CHR : なまえキャラクタ(2byte)
; ****************************************************

NAME_CHR_PUT	PROC	NEAR
	CALL	CHR_PUT			; キャラクタＰＵＴ
	RET
NAME_CHR_PUT	ENDP

; ****************************************************
;	キャラクタＰＵＴ
;	-I- NAME_NUM : なまえキャラ番号
;	    NAME_CHR : なまえキャラクタ(2byte)
; ****************************************************

CHR_PUT	PROC	NEAR
	MOV	BX,NAME_NUM		; なまえキャラ番号
	SHL	BX,1			; word pointer.
	MOV	DX,DS:NAME_X_LOC[BX]	;

	MOV	BX,NAME_NUM		; なまえキャラ番号
	SHL	BX,1			; word pointer.
	MOV	AX,DS:NAME_X_LOC[BX]	;
	MOV	BX,NAME_CHR_Y2		; 名前Ｙキャラ位置

	MOV	SI,OFFSET NAME_CHR	; なまえキャラクタ(2byte)
	CALL	STRING_PUTG		; 文字列の表示・ＧＯＬＤ

	RET
CHR_PUT	ENDP


; ****************************************************
;	名前クリア
; ****************************************************

NAME_CLEAR	PROC	NEAR
	MOV	VX1,18
	MOV	VY1,136
	MOV	VX2,60
	MOV	VY2,162
	MOV	CX,2
	CALLC	BOXPAL			; ＢＯＸペイント

;*;	MOV	NAME_NUM,8		; なまえキャラ番号
;*;	MOV	AX,WORD PTR KNJ_SPC	; 漢字スペース
;*;	MOV	WORD PTR NAME_CHR,AX	; なまえキャラクタ(2byte)
;*;
;*;	MOV	CX,8			;
;*;NAME_CLEAR_LOOP:			;
;*;	PUSH	CX			;
;*;	CALL	NAME_CHR_PUT		; 名前キャラＰＵＴ
;*;	DEC	NAME_NUM		; なまえキャラ番号
;*;	POP	CX			;
;*;	LOOP	NAME_CLEAR_LOOP		;
;*;	CALL	NAME_CHR_PUT		; 名前キャラＰＵＴ
	RET
NAME_CLEAR	ENDP


; ****************************************************
;	名前ＢＳ
; ****************************************************

NAME_BS		PROC	NEAR
	SUB	SSLINE_LEN,2		; 名前バッファ文字長さ
	JGE	NAME_BS_2		;
	MOV	SSLINE_LEN,0		; 名前バッファ文字長さ
NAME_BS_2:				;

	MOV	AX,WORD PTR KNJ_SPC		; 名前バッファ
	MOV	BX,SSLINE_LEN			; 名前バッファ文字長さ
	MOV	WORD PTR DS:SSLINE_BUF[BX],AX	; 名前バッファ

	MOV	AX,SSLINE_LEN		; カーソル現在位置
	SHR	AX,1			;
	CALL	NAME_CUR_SET		; 名前カーソルセット


	MOV	AX,SSLINE_LEN		; カーソル現在位置
	SHR	AX,1			;
	MOV	NAME_NUM,AX		; なまえキャラ番号
	MOV	AX,WORD PTR KNJ_SPC	; 漢字スペース
	MOV	WORD PTR NAME_CHR,AX	; なまえキャラクタ(2byte)
	CALL	NAME_CHR_PUT		; 名前キャラＰＵＴ

	RET
NAME_BS		ENDP


; ****************************************************
;	ファミリーネームセット
;	-I- SSLINE_BUF      : 名前バッファ
;	    SSLINE_LEN      : 名前バッファ文字長さ
;	-O- LEN_NAME_SECOND : ファミリーネーム長さ
;	    NAME_SECOND     : ファミリーネーム
; ****************************************************

FAMILY_NAME_SET	PROC	NEAR
	MOV	CX,SSLINE_LEN		; 名前バッファ文字長さ
	MOV	LEN_NAME_SECOND,CX	; ファミリーネーム長さ

	MOV	SI,OFFSET SSLINE_BUF	; 名前バッファ
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET NAME_SECOND	; ファミリーネーム
	REP	MOVSB			;
	MOV	AX,0			;
	STOSW				; end of string.


	; データベース

	; (1) ヘッダー

	MOV	BX,WIDMY_GIRL_OF	; 私の娘アドレス BX=ヘッダー

	; (2) 姓

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ES:[BX][HED_FNAME]	; DI=名

	; (3) 転送

	MOV	CX,LEN_NAME_SECOND	; ファミリーネーム長さ
	MOV	SI,OFFSET SSLINE_BUF	; 名前バッファ
	REP	MOVSB			;
	MOV	AL,0			;
	STOSW				; end of string.

	RET
FAMILY_NAME_SET	ENDP


; ****************************************************
;	ファーストネームセット
;	-I- SSLINE_BUF : 名前バッファ
;	    SSLINE_LEN      : 名前バッファ文字長さ
;	-O- LEN_NAME_FIRST : ファーストネーム長さ
;	    NAME_FIRST     : ファーストネーム
; ****************************************************

GIRLS_NAME_SET	PROC	NEAR
	MOV	CX,SSLINE_LEN		; 名前バッファ文字長さ
	MOV	LEN_NAME_FIRST,CX	; ファーストネーム長さ

	MOV	SI,OFFSET SSLINE_BUF	; 名前バッファ
	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	DI,OFFSET NAME_FIRST	; ファーストネーム
	REP	MOVSB			;
	MOV	AX,0			;
	STOSW				; end of string.


	; データベース

	; (1) ヘッダー

	MOV	BX,WIDMY_GIRL_OF	; 私の娘アドレス BX=ヘッダー

	; (2) 名前

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ES:[BX][HED_NAME]	; DI=名

	; (3) 転送

	MOV	CX,SSLINE_LEN		; 名前バッファ文字長さ
	MOV	SI,OFFSET SSLINE_BUF	; 名前バッファ
	REP	MOVSB			;
	MOV	AX,0			;
	STOSW				; end of string.

	RET
GIRLS_NAME_SET	ENDP


; ****************************************************
;	名前編集
;	-I- NOW_BOTTAN : 現在ボタン番号
;	    BTNNUMBER  : ボタン番号
;	-O- SSETA_CHAR[] : 入力キャラクタ
; ****************************************************

NAME_EDIT	PROC	NEAR
	CMP	NOW_BOTTAN,OFFF		; 現在ボタン番号
	JNE	NAME_EDIT_START		;
	RET

NAME_EDIT_START:
	CMP	BTNNUMBER,FUNC_TOP	; ボタン番号／ファンクション先頭
	JE	NAME_EDIT_EXIT		;
	CMP	BTNNUMBER,FUNC_NEXT	; ボタン番号／ＮＥＸＴボタン
	JE	NAME_EDIT_EXIT		;

	CMP	BTNNUMBER,FUNC_BS	; ボタン番号／ＢＳボタン
	JNE	NAME_EDIT_22		;

	CALLC	MSCSTP			; カーソルストップ
	CALL	NAME_BS			; 名前ＢＳ
	CALLC	MSCSRT			; カーソルスタート

	JMP	NAME_EDIT_EXIT		;
NAME_EDIT_22:
	CALL	BTN_CHAR2		; ボタン・キャラクタその２
	CALL	CNV_DAK			; 濁点判定と処理

	CALLC	MSCSTP			; カーソルストップ
	CALL	NAME_PRINT		; 名前プリント
	CALLC	MSCSRT			; カーソルスタート

	MOV	AX,SSLINE_LEN		; カーソル現在位置
	SHR	AX,1			;
	CALL	NAME_CUR_SET		; 名前カーソルセット
NAME_EDIT_EXIT:
	RET
NAME_EDIT	ENDP



; ****************************************************
;	禁則チェック
;	-I- SSLINE_LEN : 名前バッファ文字長さ
;	    SSLINE_BUF : 名前バッファ
;	-O- AX         : 0=ＯＫ,1=駄目
; ****************************************************

WID_CHECK	PROC	NEAR
	CMP	SSLINE_LEN,0		; 名前バッファ文字長さ
	JNE	WID_CHECK_2		;

					; ”名前なし！”
	CALLC	MSCSTP			; カーソルストップ
	MOV	SCRN_MSG,10		; スクリーンメッセージ番号
	CALL	SCREEN_PRINT		; スクリーンＰＲＩＮＴ
	CALL	WID_NAME_CLEAR		; 名前クリア
	CALLC	MSCSRT			; カーソルスタート

	JMP	WID_CHECK_ERROR		;

WID_CHECK_2:
	CALL	WID_KINSOKU		; 禁則チェック・エッチ名前チェック
	CMP	AX,0			; 0=ＯＫ
	JE	WID_CHECK_OK		;

					; ”エッチ！”
	CALLC	MSCSTP			; カーソルストップ
	MOV	SCRN_MSG,11		; スクリーンメッセージ番号
	CALL	SCREEN_PRINT		; スクリーンＰＲＩＮＴ
	CALLC	MSCSRT			; カーソルスタート

	JMP	WID_CHECK_ERROR		;

WID_CHECK_OK:
;*;	CALL	MUSIC_MODE		; ミュージックモード
;*;	CMP	AX,1			; 0=何もない,1=演奏があった
;*;	JE	WID_CHECK_ERROR		;

	MOV	AX,0			; 0=ＯＫ
	RET
WID_CHECK_ERROR:
	MOV	AX,1			; 1=駄目
	RET
WID_CHECK	ENDP



; ****************************************************
;	名前クリア
; ****************************************************

WID_NAME_CLEAR	PROC	NEAR
	MOV	SSLINE_LEN,0		; 名前バッファ文字長さ

	MOV	AX,DS			;
	MOV	ES,AX			;
	MOV	AX,WORD PTR KNJ_SPC	; 名前バッファ
	MOV	CX,BUFFLEN/2		; 名前バッファ長さ
	MOV	DI,OFFSET SSLINE_BUF	; 名前バッファ
	REP	STOSW			;

	CALL	NAME_CLEAR		; 名前クリア

	MOV	AX,0			; カーソル現在位置
	CALL	NAME_CUR_SET		; 名前カーソルセット
	RET
WID_NAME_CLEAR	ENDP


; ****************************************************
;	禁則チェック・エッチ名前チェック
;	-I- SSLINE_LEN : 名前バッファ文字長さ
;	    SSLINE_BUF : 名前バッファ
;	-O- AX         : 0=ＯＫ,1=駄目
; ****************************************************

WID_KINSOKU	PROC	NEAR
	MOV	SI,OFFSET SSLINE_BUF	; 名前バッファ
	MOV	DI,OFFSET KINSOKU_TABLE	; 禁則の名前一覧(１バイト目は長さ)
	MOV	CX,SSLINE_LEN		; 名前バッファ文字長さ
WID_KINSOKU_2:
	MOV	AL,DS:[DI]		; 禁則の名前一覧(１バイト目は長さ)
	CBW				;
	INC	DI			;

	CMP	AX,-1			; データ終り？
	JE	WID_KINSOKU_OK		;

	CMP	AX,CX			; 長さは一緒か？
	JNE	WID_KINSOKU_4		;

	CALL	STRNCMP			; string compare.
	JE	WID_KINSOKU_ERROR	; cf,zf :comper set.

WID_KINSOKU_4:				;
	ADD	DI,AX			; 次の単語
	JMP	WID_KINSOKU_2		;

WID_KINSOKU_OK:
	MOV	AX,0			; 0=ＯＫ
	RET
WID_KINSOKU_ERROR:
	MOV	AX,1			; 1=駄目
	RET
WID_KINSOKU	ENDP


; ****************************************************
;	濁点判定と処理
;	-I-   SSETA_CHAR   : 入力キャラクタ
;	-I/O- SSLINE_LEN   : 名前バッファ文字長さ
;	      SSLINE_BUF[] : 名前バッファ
;	-O-   DX           : 2=通常,1=濁点変換した,0=エラー
; ****************************************************

CNV_DAK	PROC	NEAR
	MOV	DX,WORD PTR SSETA_CHAR		; DX=入力キャラクタ

	MOV	BX,SSLINE_LEN			  ;
	MOV	AX,WORD PTR DS:SSLINE_BUF[BX][-2] ; AX=１つ前のキャラクタ

	CMP	DX,WORD PTR KNJ_DAKU		; 濁点か？
	JNE	CNV_DAK_1			;

	CMP	SSLINE_LEN,0			; 名前バッファ文字長さ
	JE	CNV_DAK_NONE			;

	CALL	CNV_DAKUTEN			; 濁点変換
	CMP	DX,1				; 0=対象外,1=変換
	JE	CNV_DAK_OK			;

	JMP	CNV_DAK_NONE			;

CNV_DAK_1:
	CMP	DX,WORD PTR KNJ_HANDAKU		; 半濁点か？
	JNE	CNV_DAK_2

	CMP	SSLINE_LEN,0			; 名前バッファ文字長さ
	JE	CNV_DAK_NONE			;

	CALL	CNV_HANDAKU			; 半濁点変換
	CMP	DX,1				; 0=対象外,1=変換
	JE	CNV_DAK_OK			;

	JMP	CNV_DAK_NONE			;

CNV_DAK_2:
	MOV	AX,SSLINE_LEN			; 名前バッファ文字長さ
	CMP	AX,BUFFLEN			; 名前バッファ長さ
	JNB	CNV_DAK_NONE			;

	MOV	BX,SSLINE_LEN			; 名前バッファ文字長さ
	MOV	WORD PTR DS:SSLINE_BUF[BX],DX	; 名前バッファ
	MOV	AX,WORD PTR KNJ_SPC	; 名前バッファ
	MOV	WORD PTR DS:SSLINE_BUF[BX][2],AX

	ADD	SSLINE_LEN,2			; 名前バッファ文字長さ

	MOV	DX,2				; 2=通常
	RET

CNV_DAK_OK:
	MOV	BX,SSLINE_LEN			  ; 名前バッファ文字長さ
	MOV	WORD PTR DS:SSLINE_BUF[BX][-2],AX ; 名前バッファ

	MOV	DX,1				; 1=濁点変換した
	RET

CNV_DAK_NONE:
	MOV	DX,0				; 0=エラー
	RET
CNV_DAK	ENDP




; ****************************************************
;	濁点変換
;	-I- AX : 対象キャラクタ（漢字）
;	-O- AX : 変換キャラクタ
;	    DX : 0=対象外,1=変換
; ****************************************************

CNV_DAKUTEN	PROC	NEAR
	MOV	DX,DS
	MOV	ES,DX
	MOV	DI,OFFSET DAKUTEN_TBL	; カキクケコサシ・・・
	MOV	CX,21			; <=====
	REPNE	SCASW
	JNE	CNV_DAKUTEN_NONE

	SUB	DI,OFFSET DAKUTEN_TBL+2 ; カキクケコサシ・・・
	MOV	SI,DI			;
	ADD	SI,OFFSET DAKUTEN_TBLX	; ガギグゲゴザジ・・・
	LODSW				;

	MOV	DX,1			; 1=変換
	RET				;
CNV_DAKUTEN_NONE:
	MOV	DX,0			; 対象外
	RET				;
CNV_DAKUTEN	ENDP



; ****************************************************
;	半濁点変換
;	-I- AX : 対象キャラクタ（漢字）
;	-O- AX : 変換キャラクタ
;	    DX : 0=対象外,1=変換
; ****************************************************

CNV_HANDAKU	PROC	NEAR
	MOV	DX,DS
	MOV	ES,DX
	MOV	DI,OFFSET HANDAKU_TBL	; ハヒフヘホ
	MOV	CX,5			; <=====
	REPNE	SCASW
	JNE	CNV_HANDAKU_NONE

	SUB	DI,OFFSET HANDAKU_TBL+2	; ハヒフヘホ
	MOV	SI,DI			;
	ADD	SI,OFFSET HANDAKU_TBLX	; パピプペポ
	LODSW				;

	MOV	DX,1			; 1=変換
	RET				;
CNV_HANDAKU_NONE:
	MOV	DX,0			; 対象外
	RET				;
CNV_HANDAKU	ENDP


; ****************************************************
;	string length.
;	-i- SI : source string.
;	-o- CX : string length.
; ****************************************************

STRXLEN	PROC	NEAR
	PUSH	ES
	PUSH	AX
	PUSH	DI

	MOV	AX,DS
	MOV	ES,AX
	MOV	CX,256
	MOV	DI,SI
	MOV	AL,0
	REPNE	SCASB
	DEC	DI
	MOV	CX,DI
	SUB	CX,SI

	POP	DI
	POP	AX
	POP	ES
	RET
STRXLEN	ENDP



; ****************************************************
;	string compare.
;	-i- SI : source string.
;	    DI : immediate string.
;	    CX : string length.
;	-o- cf,zf :comper set.
; ****************************************************

STRNCMP	PROC	NEAR
	PUSH	ES
	PUSH	DI
	PUSH	SI
	PUSH	CX

	PUSH	DS
	POP	ES
	REPE	CMPSB

	POP	CX
	POP	SI
	POP	DI
	POP	ES
	RET
STRNCMP	ENDP

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	NAME_FIRST:BYTE		; ファーストネーム
EXTRN	NAME_SECOND:BYTE	; ファミリーネーム
EXTRN	LEN_NAME_FIRST:WORD	; ファーストネーム長さ
EXTRN	LEN_NAME_SECOND:WORD	; ファミリーネーム長さ

EXTRN	ARA003:WORD		; 仮想ＶＲＡＭプレーン３（ＤＯＳ）

EXTRN	SEGVT0:WORD		; text put vram segment plean 0.
EXTRN	SEGVT1:WORD		; text put vram segment plean 1.
EXTRN	SEGVT2:WORD		; text put vram segment plean 2.
EXTRN	SEGVT3:WORD		; text put vram segment plean 3.

EXTRN	SSEFC0:WORD		; visual data segment plean 0
EXTRN	SSEFC1:WORD		; visual data segment plean 1
EXTRN	SSEFC2:WORD		; visual data segment plean 2
EXTRN	SSEFC3:WORD		; visual data segment plean 3


SCREEN_CHR	DB	"　",0,0	; スクリーンＰＵＴキャラクタ
SCREEN_LINE	DW	0		; スクリーン行

SSLINE_LEN	DW	0		; 名前バッファ文字長さ
SSLINE_BUF	DB	"　　　　　　　　",0,0	; 名前バッファ

CURSOLE_NOW	DW	0		; カーソル現在位置
CURSOLE_FLAG	DW	0		; カーソルＯＮ／ＯＦＦ

MOUSEFLAG	DW	0		; マウスＯＮ／ＯＦＦフラグ
MOUSEX		DW	0		; マウスＸ
MOUSEY		DW	0		; マウスＹ

NAME_X_LOC	LABEL	WORD		;
		DW	NAME_CHR_X1	; 名前Ｘキャラ位置
		DW	NAME_CHR_X2	;
		DW	NAME_CHR_X3	;
		DW	NAME_CHR_X4	;
		DW	NAME_CHR_X5	;
		DW	NAME_CHR_X6	;
		DW	NAME_CHR_X7	;
		DW	NAME_CHR_X8	;

NAME_NUM	DW	0		; なまえキャラ番号
NAME_CHR	DB	"  ",0,0	; なまえキャラクタ
KNJ_SPC		DB	"　",0,0	; 漢字スペース

NOW_BOTTAN	DW	0		; 現在ボタン番号

BTNNUMBER	DW	0		; ボタン番号
BTNX		DW	0		; ボタンＸ
BTNY		DW	0		; ボタンＹ
BTNXSZ		DW	0		; ボタンサイズＸ
BTNYSZ		DW	0		; ボタンサイズＹ

BTN_TOP_TABLE	LABEL	BYTE
	DB	"アイウエオ"		; 1-5
	DB	"カキクケコ"		;6-10
	DB	"サシスセソ"		;11-15
	DB	"タチツテト"		;16-20
	DB	"ナニヌネノ"		;21-25
	DB	"ハヒフヘホ"		;26-30
	DB	"マミムメモ"		;31-35
	DB	"ヤャユュヨ"		;36-40
	DB	"ラリルレロ"		;41-45
	DB	"ワンョ゜゛"		;46-50
	DB	"ッ○ー☆！"		;51-55
	DB	"ァィゥェォ"		;56-60

KNJ_DAKU	DB	"゛"		; 濁点
KNJ_HANDAKU	DB	"゜"		; 半濁点

			;1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 < 21 <===
DAKUTEN_TBL	DB	"カキクケコサシスセソタチツテトハヒフヘホウ",0
DAKUTEN_TBLX	DB	"ガギグゲゴザジズゼゾダヂヅデドバビブベボヴ",0

			;1 2 3 4 5 < 5
HANDAKU_TBL	DB	"ハヒフヘホ",0
HANDAKU_TBLX	DB	"パピプペポ",0

FUNC_TOP_TABLE	LABEL	WORD		; ファンクション
		DW	OFFSET FUNC_TABLE0
		DW	OFFSET FUNC_TABLE1
FUNC_TABLE0	DB	"おわり",0
FUNC_TABLE1	DB	"もどる",0


;	禁則の名前一覧

KINSOKU_TABLE	LABEL	BYTE
		DB	3*2,"＊＊＊"
		DB	3*2,"＊＊＊"
		DB	4*2,"＊＊＊＊"
		DB	3*2,"＊＊＊"
		DB	4*2,"＊＊＊＊"
		DB	3*2,"＊＊＊"
		DB	4*2,"＊＊＊＊"
		DB	-1		; end of table.
		EVEN
SSETA_CHAR	DB	"１２３４５６７８",0,0	; 入力キャラクタ

SCRN_MSG	DW	0			; スクリーンメッセージ番号
SCRN_MSG_TABLE	LABEL	WORD			; スクリーンメッセージテーブル
		DW	OFFSET	SCRN_MSG_TBL0	;
		DW	OFFSET	SCRN_MSG_TBL1	;
		DW	OFFSET	SCRN_MSG_TBL2	;
		DW	OFFSET	SCRN_MSG_TBL3	;
		DW	OFFSET	SCRN_MSG_TBL4	;
		DW	OFFSET	SCRN_MSG_TBL5	;
		DW	OFFSET	SCRN_MSG_TBL6	;
		DW	OFFSET	SCRN_MSG_TBL7	;
		DW	OFFSET	SCRN_MSG_TBL8	;
		DW	OFFSET	SCRN_MSG_TBL9	;
		DW	OFFSET	SCRN_MSG_TBL10	;
		DW	OFFSET	SCRN_MSG_TBL11	;
		DW	OFFSET	SCRN_MSG_TBL12	;
		DW	OFFSET	SCRN_MSG_TBL13	;
		DW	OFFSET	SCRN_MSG_TBL14	;
		DW	OFFSET	SCRN_MSG_TBL15	;
SCRN_MSG_TBL0	DB	0			;
SCRN_MSG_TBL1	DB	"family name （あなたの名字）",0
SCRN_MSG_TBL2	DB	"girl's name （むすめのなまえ）",0
SCRN_MSG_TBL3	DB	"blood type（むすめの血液型）",0
SCRN_MSG_TBL4	DB	0			;
SCRN_MSG_TBL5	DB	0			;
SCRN_MSG_TBL6	DB	0			;
SCRN_MSG_TBL7	DB	0
SCRN_MSG_TBL8	DB	0
SCRN_MSG_TBL9	DB	0
SCRN_MSG_TBL10	DB	"　　＊＊＊＊＊＊＊＊",0
SCRN_MSG_TBL11	DB	"　　　・・・・・・",0
SCRN_MSG_TBL12	DB	0
SCRN_MSG_TBL13	DB	0
SCRN_MSG_TBL14	DB	"ミュージックモード",0
SCRN_MSG_TBL15	DB	0

		EVEN
STRN_XX		DW	0	; 文字Ｘ
STRN_YY		DW	0	; 文字Ｙ
STRN_ADRS	DW	0	; 文字アドレス
STRN_LEN	DW	0	; 文字長さ

DATA	ENDS

	END
;
;	end of "WIDNAME.ASM"
;
