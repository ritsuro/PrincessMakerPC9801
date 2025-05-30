; "R_SCHED2.ASM" PC-9801UV11 make by R.H 1991/04/26
;
;
;	「子育て」
;
;	スケジュール２
;
;	R_SCHED2		; 娘を教育する
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC

; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチン
; ****************************************************

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
SUBLL	PROC	FAR
	ENDM

; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチンの終り
; ****************************************************

FEND	MACRO	SUBLL

SUBLL	ENDP
	ENDM

; ****************************************************
;	Ｒ＿ＳＥＧ２セグメントからＣＯＤＥセグメントへ
; ****************************************************

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

; ****************************************************
;	ＣＯＤＥセグメントからＲ＿ＳＥＧ２セグメントへ
; ****************************************************

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
L1:
	ENDM

; ****************************************************
;	Ｒ＿ＳＥＧ２　から　ＣＯＤＥ　へ　ＣＡＬＬ
; ****************************************************

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
	ASSUME	CS:R_SEG2,DS:DATA
L1:	CALL	L2	
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
	CALL	WWIDSLC2		; セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	ENDM

; ****************************************************
;	ＰＲＩＮＴＸ	＜文字列＞
;	文字列データのウインドウ表示
; ****************************************************

PRINTX	MACRO	STRING
	LOCAL	L1
R_SEG3	SEGMENT	PUBLIC	'R_SEG3'	; テキスト
L1	DB	STRING,0
R_SEG3	ENDS
	MOV	MESS_ADRS,OFFSET L1	; メッセージアドレス
	EXTRN	MESSAGE_PRINT:NEAR	; メッセージ表示
	CALL	MESSAGE_PRINT		; メッセージ表示
	ENDM

; ****************************************************
;	ＰＲＩＮＴＶ	＜文字列＞
;	文字列データ（アドレス）のウインドウ表示
; ****************************************************

PRINTV	MACRO	ADRS
	MOV	AX,ADRS			; メッセージアドレス
	MOV	MESS_ADRS,AX		; メッセージアドレス
	EXTRN	MESSAGE_PRINT:NEAR	; メッセージ表示
	CALL	MESSAGE_PRINT		; メッセージ表示
	ENDM

; ****************************************************
;	ＰＲＩＮＴＶＦ	＜文字列＞
;	文字列データ（アドレス）のウインドウ表示＋改行
; ****************************************************

PRINTVF	MACRO	ADRS
	EXTRN	MESSAGE_LF:NEAR		; メッセージ改行(R_SEG2)
	CALL	MESSAGE_LF		;
	MOV	AX,ADRS			; メッセージアドレス
	MOV	MESS_ADRS,AX		; メッセージアドレス
	EXTRN	MESSAGE_PRINT:NEAR	; メッセージ表示
	CALL	MESSAGE_PRINT		;
	ENDM

; ****************************************************
;	テキストセグメントの始まり
; ****************************************************

TEXT_IN		MACRO
R_SEG3	SEGMENT	PUBLIC	'R_SEG3'	; テキスト
	ENDM

; ****************************************************
;	テキストセグメントの終り
; ****************************************************

TEXT_OUT	MACRO
R_SEG3	ENDS
	ENDM

; ****************************************************
;	その他
; ****************************************************

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
TSTW	MACRO	DEST,SOUR
	TEST	WORD PTR DEST,SOUR
	ENDM
ORW	MACRO	DEST,SOUR
	OR	WORD PTR DEST,SOUR
	ENDM
BANDED	MACRO	TRGET,MAXMAX
	LOCAL	L1
	CMP	TRGET,MAXMAX
	JBE	L1
	MOV	TRGET,MAXMAX
L1:
	ENDM

R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

EXTRN	TALK_START:NEAR		; 会話スタート(R_SEG2)
EXTRN	TALK_END:NEAR		; 会話ストップ(R_SEG2)
EXTRN	TALK_SRT02:NEAR		; 会話スタート（クリア無し）(R_SEG2)
EXTRN	TALK_FIN:NEAR		; 会話ストップ（クリア無し）(R_SEG2)
EXTRN	MESSAGE_LF:NEAR		; メッセージ改行(R_SEG2)
EXTRN	HOW_MANY_YEARS:NEAR	; 何年目か BX=年のword pointer(R_SEG2)


; ****************************************************
;	娘を教育する
;	-O-   KETTEI   : 0=決定,1=考え直す
;	      DX       : 項目 0=武芸,1=学問,2=礼法,3=武者修行
; ****************************************************

FUNC	RR_SCHED2,R_SCHED2
	CALLC	TKRHME			; 台詞ホームポジション

	CALLC	R_MS_KYOIKU_TXT		; スケジュール教育選択時メッセージ

	CALLC	WIDDSP_SV_WD		; WINDOWS/ワイドアイテム退避

	CALLC	WIDITM_SWK		; WINDOWS/アイテムフレーム教育一覧表示

	WD_ADRS	ID_00,R_NAISTR		; 無効		

	WSELECT	"武芸,学問,礼法,武者修行"

	CALLC	WIDDSP_LD_WD		; WINDOWS/ワイドアイテム復元

	CMP	WIDSNM,OFFF
	JE	R_SCHED2_BACK

	MOVX	KOUMOKU,WIDSNM			; 項目

	MOV	BX,WIDSNM			;
	MOV	AX,1				; 1=決定
	CALLC	R_MS_SCHED_TXT		; スケジュール選択時のメッセージ

	CMP	WIDSNM,0			; 武芸
	JE	R_SCHED2_00			;
	CMP	WIDSNM,1			; 学問
	JE	R_SCHED2_01			;
	CMP	WIDSNM,2			; 礼法
	JE	R_SCHED2_02			;
	CMP	WIDSNM,3			; 武者修行
	JE	R_SCHED2_03			;

	JMP	R_SCHED2_BACK

R_SCHED2_00:
	CALLC	R_BUGEI_SET			; 武芸
	JMP	R_SCHED2_EXIT			;
R_SCHED2_01:
	CALLC	R_GAKUMO_SET			; 学問
	JMP	R_SCHED2_EXIT			;
R_SCHED2_02:
	CALLC	R_REIHOU_SET			; 礼法
	JMP	R_SCHED2_EXIT			;
R_SCHED2_03:
	CALLC	R_MUSYA_SET			; 武者修行
	JMP	R_SCHED2_EXIT			;

R_SCHED2_EXIT:
	MOV	DX,KOUMOKU		; 項目 0=武芸,1=学問,2=礼法,3=武者修行
	MOV	KETTEI,0			; 0=決定
	RET
R_SCHED2_BACK:
	MOV	DX,0
	MOV	KETTEI,1			; 1=考え直す
	RET
FEND	RR_SCHED2


; ****************************************************
;	WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
; ****************************************************

WWIDSLC2	PROC	NEAR
	CALLC	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	RET
WWIDSLC2	ENDP

R_SEG2	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	KETTEI:WORD		; 決定フラグ

EXTRN	R_NAISTR:WORD		; 内容文字列

KOUMOKU	DW	0		; 項目

DATA	ENDS

	END
;
;	end of "R_SCHED2.ASM"
;
