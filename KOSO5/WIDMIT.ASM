; "WIDMIT.ASM" PC-9801UV11 make by R.H 1990/10/22
;
;
;	ＷＩＮＤＯＷＳ／アイテム系管理（管理系）
;
;
;	WIDITEM_INIT		; WINDOWS/アイテム管理初期処理
;	WIDITEM_CLEAR		; WINDOWS/アイテム表示設定クリア
;	WIDITEM_STYLE		; WINDOWS/アイテムスタイルリスト
;	WIDITEM_OPEN		; WINDOWS/アイテムオープン
;	WIDITEM_CLOSE		; WINDOWS/アイテムクローズ
;	WIDWAZA_STYLE		; WINDOWS/技（わざ）スタイルリスト
;	WIDWAZA_OPEN		; WINDOWS/技（わざ）オープン
;	WIDWAZA_CLOSE		; WINDOWS/技（わざ）クローズ
;	WIDWORKS_STYLE		; WINDOWS/行い（おこない）スタイルリスト
;	WIDWORKS_OPEN		; WINDOWS/行い（おこない）オープン
;	WIDWORKS_CLOSE		; WINDOWS/行い（おこない）クローズ
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
	MOV	AX,WORD PTR SOUR
	MOV	WORD PTR DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

MOVXBW	MACRO	DEST,SOUR_BYTE
	MOV	AH,0
	MOV	AL,SOUR_BYTE
	MOV	DEST,AX
	ENDM

S_TYP_NOP	EQU	0		; 0=何もない
S_TYP_NAME	EQU	1		; 1=名前
S_TYP_STR	EQU	2		; 2=文字列
S_TYP_GOLD	EQU	3		; 3=通貨
S_TYP_GRAP	EQU	4		; 4=文字列と数値(ｸﾞﾗﾌ)
S_TYP_VAL	EQU	5		; 5=数値
S_TYP_AGE	EQU	6		; 6=年齢
S_TYP_HELP	EQU	7		; 7=説明



WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA


; ****************************************************
;	WINDOWS/アイテム管理初期処理
; ****************************************************

FUNC	WWIDITEM_INIT,WIDITEM_INIT
	RET
FEND	WWIDITEM_INIT


; ****************************************************
;	WINDOWS/アイテム表示設定クリア
; ****************************************************

FUNC	WWIDITEM_CLEAR,WIDITEM_CLEAR
	CALLC	WIDITM_OPEN		; WINDOWS/アイテム系オープン
	RET
FEND	WWIDITEM_CLEAR


; ****************************************************
;	WINDOWS/アイテムスタイルリスト
;	-I- DX : 種別・0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾, 4=道具
;	               5=資格
;	-O- BX : スタイルリストオフセット
; ****************************************************

FUNC	WWIDITEM_STYLE,WIDITEM_STYLE
	PUSH	CX
;*;	CMP	DX,6			; 種別
;*;	JL	WIDITEM_STYLE_START	;
;*;	MOV	DX,0
WIDITEM_STYLE_START:
	MOV	BX,DX			; スタイルリストを取り出す
	SHL	BX,1			; word pointer.
	ADD	BX,OFFSET TBL_NM_ITEM	; アイテム種別を
	MOVX	STYLE_LIST_ITEM,DS:[BX]	; スタイルリストのアイテム種別名へ

	MOV	BX,OFFSET STYLE_LIST_ITEM ; スタイルリストオフセット
	POP	CX
	RET
FEND	WWIDITEM_STYLE



; ****************************************************
;	WINDOWS/アイテムオープン
;	-I- DX : 種別・0=武器, 1=防具・兜, 2=防具・鎧, 3=防具・盾, 4=道具
;	    CX : レコード番号
;	-O- AX : 0=正常,1=種別が範囲外,2=レコード番号が範囲外
; ****************************************************

FUNC	WWIDITEM_OPEN,WIDITEM_OPEN
	CALL	FAR PTR WWIDITEM_STYLE	; WINDOWS/アイテムスタイルリスト
	MOV	WDILIST,BX		; スタイルリストオフセット

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	MOV	BX,DX			; テーブルのアイテムテーブルを取り出す
	SHL	BX,1			; word pointer.
	SHL	BX,1			; * 4
	ADD	BX,WIDOFS_ITEM		; アイテムテーブル
	MOVX	WDINO,ES:[BX]		; アイテムテーブルオフセット（先頭）

	CMP	CX,ES:[BX][2]		; 数
	JGE	WIDITEM_OPEN_ERR_REC	;


	MOV	AX,STYLE_LIST_ITEM[4]	; パラメータＷＯＲＤ数
	SHL	AX,1			; word count.
	MUL	CX			;
	ADD	WDINO,AX		; アイテムオフセット

	CALLC	WIDITM			; WINDOWS/アイテム系表示

	MOV	AX,0			; 0=正常
	RET
WIDITEM_OPEN_ERR_ATR:
	MOV	AX,1			; 1=種別が範囲外
	RET
WIDITEM_OPEN_ERR_REC:
	MOV	AX,2			; 2=レコード番号が範囲外
	RET
FEND	WWIDITEM_OPEN


; ****************************************************
;	WINDOWS/アイテムクローズ
; ****************************************************

FUNC	WWIDITEM_CLOSE,WIDITEM_CLOSE
	RET
FEND	WWIDITEM_CLOSE



; ****************************************************
;	WINDOWS/技（わざ）スタイルリスト
;	-I- DX : 種別・0=魔法,1=力技
;	-O- BX : スタイルリストオフセット
; ****************************************************

FUNC	WWIDWAZA_STYLE,WIDWAZA_STYLE
	PUSH	CX
;*;	CMP	DX,2			; 種別
;*;	JL	WIDWAZA_STYLE_START	;
;*;	MOV	DX,0
WIDWAZA_STYLE_START:
	MOV	BX,DX			; スタイルリストを取り出す
	SHL	BX,1			; word pointer.
	ADD	BX,OFFSET TBL_NM_WAZA	; 技（わざ）種別を
	MOVX	STYLE_LIST_WAZA,DS:[BX]	; スタイルリストのアイテム種別名へ

	MOV	BX,OFFSET STYLE_LIST_WAZA ; スタイルリストオフセット
	POP	CX
	RET
FEND	WWIDWAZA_STYLE



; ****************************************************
;	WINDOWS/技（わざ）オープン
;	-I- DX : 種別・0=魔法,1=力技
;	    CX : レコード番号
;	-O- AX : 0=正常,1=種別が範囲外,2=レコード番号が範囲外
; ****************************************************

FUNC	WWIDWAZA_OPEN,WIDWAZA_OPEN
	CALL	FAR PTR WWIDWAZA_STYLE	; WINDOWS/技（わざ）スタイルリスト
	MOV	WDILIST,BX		; スタイルリストオフセット

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	MOV	BX,DX			; テーブルのアイテムテーブルを取り出す
	SHL	BX,1			; word pointer.
	SHL	BX,1			; * 4
	ADD	BX,WIDOFS_WAZA		; アイテムテーブル
	MOVX	WDINO,ES:[BX]		; アイテムテーブルオフセット（先頭）

	CMP	CX,ES:[BX][2]		; 数
	JGE	WIDWAZA_OPEN_ERR_REC	;

	MOV	AX,STYLE_LIST_WAZA[4]	; パラメータＷＯＲＤ数
	SHL	AX,1			; word count.
	MUL	CX			;
	ADD	WDINO,AX		; アイテムオフセット

	CALLC	WIDITM			; WINDOWS/アイテム系表示

	MOV	AX,0			; 0=正常
	RET
WIDWAZA_OPEN_ERR_ATR:
	MOV	AX,1			; 1=種別が範囲外
	RET
WIDWAZA_OPEN_ERR_REC:
	MOV	AX,2			; 2=レコード番号が範囲外
	RET
FEND	WWIDWAZA_OPEN


; ****************************************************
;	WINDOWS/技（わざ）クローズ
; ****************************************************

FUNC	WWIDWAZA_CLOSE,WIDWAZA_CLOSE
	RET
FEND	WWIDWAZA_CLOSE



; ****************************************************
;	WINDOWS/行い（おこない）スタイルリスト
;	-I- DX : 種別・0=お仕事
;	-O- BX : スタイルリストオフセット
; ****************************************************

FUNC	WWIDWORKS_STYLE,WIDWORKS_STYLE
	PUSH	CX
;*;	CMP	DX,1			; 種別
;*;	JL	WIDWORKS_STYLE_START	;
;*;	MOV	DX,0
WIDWORKS_STYLE_START:
	MOV	BX,DX			; スタイルリストを取り出す
	SHL	BX,1			; word pointer.
	ADD	BX,OFFSET TBL_NM_WORKS	; 行い（おこない）種別
	MOVX	STYLE_LIST_WORKS,DS:[BX] ; スタイルリストのアイテム種別名へ

	MOV	BX,OFFSET STYLE_LIST_WORKS ; スタイルリストオフセット

	POP	CX
	RET
FEND	WWIDWORKS_STYLE


; ****************************************************
;	WINDOWS/行い（おこない）オープン
;	-I- DX : 種別・0=お仕事
;	    CX : レコード番号
;	-O- AX : 0=正常,1=種別が範囲外,2=レコード番号が範囲外
; ****************************************************

FUNC	WWIDWORKS_OPEN,WIDWORKS_OPEN
	CALL	FAR PTR WWIDWORKS_STYLE	;WINDOWS/行い（おこない）スタイルリスト
	MOV	WDILIST,BX		; スタイルリストオフセット

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	MOV	BX,DX			; テーブルのアイテムテーブルを取り出す
	SHL	BX,1			; word pointer.
	SHL	BX,1			; * 4
	ADD	BX,WIDOFS_WORKS		; アイテムテーブル
	MOVX	WDINO,ES:[BX]		; アイテムテーブルオフセット（先頭）

	CMP	CX,ES:[BX][2]		; 数
	JGE	WIDWORKS_OPEN_ERR_REC	;


	MOV	AX,STYLE_LIST_WORKS[4]	; パラメータＷＯＲＤ数
	SHL	AX,1			; word count.
	MUL	CX			;
	ADD	WDINO,AX		; アイテムオフセット

	CALLC	WIDITMWD		; WINDOWS/アイテム系ワイド表示

	MOV	AX,0			; 0=正常
	RET
WIDWORKS_OPEN_ERR_ATR:
	MOV	AX,1			; 1=種別が範囲外
	RET
WIDWORKS_OPEN_ERR_REC:
	MOV	AX,2			; 2=レコード番号が範囲外
	RET
FEND	WWIDWORKS_OPEN



; ****************************************************
;	WINDOWS/行い（おこない）クローズ
; ****************************************************

FUNC	WWIDWORKS_CLOSE,WIDWORKS_CLOSE
	RET
FEND	WWIDWORKS_CLOSE


WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

; ****************************************************
;	ＷＩＮＤＯＷＳ用／アイテム系（道具,技,仕事）
; ****************************************************
;
;		［アイテム種別名　　］
;		［パラメータ数　　　］
;		［パラメータＷＯＲＤ数］
;		［パラメータ１タイプ］
;		［パラメータ名　　　］
;		［パラメータ２タイプ］
;		［パラメータ名　　　］
;		［パラメータ３タイプ］
;		［　　　　．　　　　］
;		［　　　　．　　　　］
;		［　　　　．　　　　］

;	アイテム種別

TBL_NM_ITEM	LABEL	WORD
	DW	OFFSET NAME_BUKI	; 武器
	DW	OFFSET NAME_KABUTO	; 防具・兜
	DW	OFFSET NAME_YOROI	; 防具・鎧
	DW	OFFSET NAME_TATE	; 防具・盾
	DW	OFFSET NAME_DOUG	; 道具
	DW	OFFSET NAME_SHIKAKU	; 道具
NAME_BUKI	DB	"武器",0
NAME_KABUTO	DB	"防具･兜",0
NAME_YOROI	DB	"防具･鎧",0
NAME_TATE	DB	"防具･盾",0
NAME_DOUG	DB	"道具",0
NAME_SHIKAKU	DB	"資格",0

;	技（わざ）種別

TBL_NM_WAZA	LABEL	WORD
	DW	OFFSET NAME_MAHO	; 魔法
	DW	OFFSET	NAME_WAZA	; 技
NAME_MAHO	DB	"魔法",0
NAME_WAZA	DB	"技",0

;	行い（おこない）種別

TBL_NM_WORKS	LABEL	WORD
	DW	OFFSET NAME_SIGOTO	; 仕事
NAME_SIGOTO	DB	"仕事",0


NAME_ITEM	DB	"ｱｲﾃﾑ名",0
NAME_NEDAN	DB	"値段",0
NAME_KOUKA	DB	"効果",0
NAME_SYUSEI	DB	"修正能力",0
NAME_SEIGEN	DB	"年齢制限",0
NAME_SETUMEI	DB	"説明",0


;	スタイルリスト／武器・道具表示用

STYLE_LIST_ITEM		LABEL	WORD
		DW	NAME_BUKI		;［アイテム種別名　　］
		DW	6			;［パラメータ数　　　］
		DW	1+1+2+2+2+1		;［パラメータＷＯＲＤ数］
		;
		DW	S_TYP_NAME		;［パラメータ１タイプ］
		DW	NAME_ITEM		;［パラメータ名　　　］
		;
		DW	S_TYP_GOLD		;［パラメータ２タイプ］
		DW	NAME_NEDAN		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ３タイプ］
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ４タイプ］
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ５タイプ］
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_HELP		;［パラメータ６タイプ］
		DW	NAME_SETUMEI		;［パラメータ名　　　］


;	スタイルリスト／技（わざ）表示用

STYLE_LIST_WAZA		LABEL	WORD
		DW	NAME_MAHO		;［アイテム種別名　　］
		DW	6			;［パラメータ数　　　］
		DW	1+1+2+2+2+1		;［パラメータＷＯＲＤ数］
		;
		DW	S_TYP_NAME		;［パラメータ１タイプ］
		DW	NAME_ITEM		;［パラメータ名　　　］
		;
		DW	S_TYP_NOP		;［パラメータ２タイプ］
		DW	NAME_NEDAN		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ３タイプ］
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ４タイプ］
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ５タイプ］
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_HELP		;［パラメータ６タイプ］
		DW	NAME_SETUMEI		;［パラメータ名　　　］


;	スタイルリスト／行い（おこない）表示用

STYLE_LIST_WORKS	LABEL	WORD
		DW	NAME_SIGOTO		;［アイテム種別名　　］
		DW	10			;［パラメータ数　　　］
		DW	1+1+1+2*5+1+1		;［パラメータＷＯＲＤ数］
		;
		DW	S_TYP_NAME		;［パラメータ１タイプ］医者
		DW	NAME_ITEM		;［パラメータ名　　　］
		;
		DW	S_TYP_GOLD		;［パラメータ２タイプ］１０
		DW	NAME_NEDAN		;［パラメータ名　　　］
		;
		DW	S_TYP_STR		;［パラメータ３タイプ］知力
		DW	NAME_SYUSEI		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ４タイプ］疲労＋２
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ５タイプ］知力＋８
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ６タイプ］
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ７タイプ］
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_GRAP		;［パラメータ８タイプ］
		DW	NAME_KOUKA		;［パラメータ名　　　］
		;
		DW	S_TYP_AGE		;［パラメータ９タイプ］
		DW	NAME_SEIGEN		;［パラメータ名　　　］
		;
		DW	S_TYP_HELP		;［パラメータ１０タイプ］
		DW	NAME_SETUMEI		;［パラメータ名　　　　］

DATA	ENDS

	END
;
;	end of "WIDMIT.ASM"
;
