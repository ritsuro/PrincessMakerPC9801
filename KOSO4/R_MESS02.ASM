; "R_MESS02.ASM" PC-9801UV11 make by R.H 1991/02/26
;
;
;	「子育て」
;
;	メッセージ・武芸・学問・礼法
;
;
;	R_MS_BUGEI_SRT		; 武芸スタート台詞
;	R_MS_BUGEI_DAYS		; 武芸日々台詞
;	R_MS_BUGEI_UPD		; 武芸決算台詞
;	R_MS_BUGEI_TST		; 武芸試験台詞
;
;	R_MS_GAKUM_SRT		; 学問スタート台詞
;	R_MS_GAKUM_DAYS		; 学問日々台詞
;	R_MS_GAKUM_UPD		; 学問決算台詞
;	R_MS_GAKUM_TST		; 学問試験台詞
;
;	R_MS_REIHO_SRT		; 礼法スタート台詞
;	R_MS_REIHO_DAYS		; 礼法日々台詞
;	R_MS_REIHO_UPD		; 礼法決算台詞
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO6\KYOKU.INC

CODE	SEGMENT	PUBLIC	'CODE'
CODE	ENDS
DATA	SEGMENT	PUBLIC	'DATA'
DATA	ENDS
R_SEG2	SEGMENT	PUBLIC	'R_SEG2'		; コード
R_SEG2	ENDS
R_SEG3	SEGMENT	PUBLIC	'R_SEG3'		; テキスト
R_SEG3	ENDS


; ****************************************************
;	武芸・学問・礼法フラグ
; ****************************************************

		;bit	FEDCBA9876543210
FLG_L_FIRST	EQU	0000000000000010B	; 初級２回目以降
FLG_M_FIRST	EQU	0000000000000100B	; 中級２回目以降
FLG_H_FIRST	EQU	0000000000001000B	; 上級２回目以降
FLG_X_FIRST	EQU	0000000000010000B	; 卒業２回目以降

SLT_BUGEI	EQU	0			; フラグ武芸
SLT_GAKUMON	EQU	2			; フラグ学問
SLT_REIHOU	EQU	4			; フラグ礼法

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
;	武芸スタート台詞
;	-I- DX : クラス 1=初級,2=中級,3=上級,4=卒業
; ****************************************************

FUNC	RR_MS_BUGEI_SRT,R_MS_BUGEI_SRT
	BANDED	DX,4
	MOV	MY_CLASS,DX			; クラス

	CALL	TALK_SRT02			; 会話スタート（クリア無し）

	MOV	SI,MY_CLASS			; クラス
	MOV	DI,2				; 2=武芸師範
	CALLC	WIDFACE_OPEN_W			; WINDOWS/行いフェイスＯＰＥＮ

	MOV	BX,MY_CLASS			; クラス
	DEC	BX				; －１
	SHL	BX,1				; word pointer.
	MOVX	ES,<SEG R_SEG3>			;
	PRINTV	ES:BGE_SRT_NAM_TBL[BX]		; 師範名前


	MOV	CX,MY_CLASS			; 1=初級,2=中級,3=上級,4=卒業
	MOV	DX,1				;
	SHL	DX,CL				;0000000000000010B  初級２回目
						;0000000000000100B  中級２回目
						;0000000000001000B  上級２回目
						;0000000000010000B  卒業２回目
	MOV	ES,BUGARE_FLG_SEG		; 武・学・礼フラグセグメント
	MOV	DI,BUGARE_FLG_OFS		; 武・学・礼フラグオフセット
	TEST	ES:[DI][SLT_BUGEI],DX		; フラグ武芸 ２回目以降
	JNZ	R_MS_BUGEI_SRT_2ND		;
	OR	ES:[DI][SLT_BUGEI],DX		;

R_MS_BUGEI_SRT_FST:				;
	MOVX	ES,<SEG R_SEG3>			;
	PRINTVF	ES:BGE_SRT_FST_TBL[BX]		; はじめて会う
	JMP	R_MS_BUGEI_SRT_6		;

R_MS_BUGEI_SRT_2ND:				;
	MOVX	ES,<SEG R_SEG3>			;
	PRINTVF	ES:BGE_SRT_2ND_TBL[BX]		; ２度目
	JMP	R_MS_BUGEI_SRT_6		;

R_MS_BUGEI_SRT_6:				;
	PUSH	ES
	PUSH	BX
	CALL	ZUCIZUCI			; あいづち
	MUSIC_FAR	KYOKU_F_O		; 音楽フェードアウト
	CALLC	WIDFACE_CLOSE_W			; WINDOWS/行いフェイスCLOSE
	POP	BX
	POP	ES
	PRINTVF	ES:BGE_SRT_SIG_TBL[BX]		; スタート台詞

R_MS_BUGEI_SRT_EXIT:
	CALL	TALK_FIN			; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_BUGEI_SRT


; ****************************************************
;	武芸日々台詞
;	-I- DX : 経験値
; ****************************************************

FUNC	RR_MS_BUGEI_DAYS,R_MS_BUGEI_DAYS
	MOV	TXT_KEIKEN,DX		; テキスト経験値

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	PRINTX	"本日の成果は……"

	CMP	TXT_KEIKEN,0		; テキスト経験値
	JE	R_MS_BUGEI_DAYS_SHIPPAI	;

R_MS_BUGEI_DAYS_SEIKO:			; ＊成功時＊
	PRINTX	"@&nは&kの経験値を得た。"
	JMP	R_MS_BUGEI_DAYS_EXIT

R_MS_BUGEI_DAYS_SHIPPAI:		; ＊失敗時＊
	CALL	HOW_MANY_YEARS		; 何年目か BX=年のword pointer(R_SEG2)

	MOVX	ES,<SEG R_SEG3>		;
	PRINTVF	ES:BGE_DAYS_TBL[BX]	; 失敗時台詞

	PRINTX	"@今日の訓練は何も得るものがなかった……"
	JMP	R_MS_BUGEI_DAYS_EXIT

R_MS_BUGEI_DAYS_EXIT:
	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_BUGEI_DAYS


; ****************************************************
;	武芸決算台詞
;	-I- DX : 経験値
;	    CX : 日数
; ****************************************************

FUNC	RR_MS_BUGEI_UPD,R_MS_BUGEI_UPD
	MOV	TXT_KEIKEN,DX		; テキスト経験値
	MOV	TXT_DAYS,CX		; テキスト日数

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	;＊武芸の訓練が終った時＊
	PRINTX	"&d日間の修行で&nは合計&kの経験値を得た。"

	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_BUGEI_UPD


; ****************************************************
;	武芸試験台詞
;	-I- DX : クラス 1=初級,2=中級,3=上級
;	    BX : 台詞種類 1=勧誘,2=受験する場合,3=受験しない場合
;			  4=負けた場合１（相手の残りＨＰが８０％以上）
;			  5=負けた場合２（相手の残りＨＰが８０％未満）
;			  6=勝った場合
;			  7=なにもないとき
; ****************************************************

FUNC	RR_MS_BUGEI_TST,R_MS_BUGEI_TST
	BANDED	DX,3
	BANDED	BX,7
	MOV	MY_CLASS,DX		; クラス 1=初級,2=中級,3=上級
	MOV	NUM,BX			; 台詞種類

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,MY_CLASS		; クラス 1=初級,2=中級,3=上級
	SHL	BX,1			; word pointer.
	MOV	DI,ES:BGE_TST_ALL_TBL[BX] ;試験テーブル
	MOV	BX,NUM			; 台詞種類
	SHL	BX,1			; word pointer.
	PRINTV	ES:[DI][BX]		; 台詞

	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_BUGEI_TST


TEXT_IN

	;☆★☆★武芸の訓練時のメッセージ☆★☆

;		初級　　　中級　　　上級	卒業

BGE_SRT_NAM_TBL	LABEL	WORD					;師範名前
	DW	BGE_1_NAME,BGE_2_NAME,BGE_3_NAME,BGE_4_NAME
BGE_SRT_FST_TBL	LABEL	WORD					;はじめて会う
	DW	BGE_1_SRT1,BGE_2_SRT1,BGE_3_SRT1,BGE_4_SRT1
BGE_SRT_2ND_TBL	LABEL	WORD					;２度目
	DW	BGE_1_SRT2,BGE_2_SRT2,BGE_3_SRT2,BGE_4_SRT2
BGE_SRT_SIG_TBL	LABEL	WORD					;スタート台詞
	DW	BGE_1_SIGO,BGE_2_SIGO,BGE_3_SIGO,BGE_4_SIGO

BGE_1_NAME DB "初級師範アーネスト",0
BGE_1_SRT1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_1_SRT2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_1_SIGO DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

BGE_2_NAME DB "中級師範エレミス",0
BGE_2_SRT1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊"
	   DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_2_SRT2 DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_2_SIGO DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊",0

BGE_3_NAME DB "上級師範ラトス",0
BGE_3_SRT1 DB "｢＊＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_3_SRT2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_3_SIGO DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	卒業してしまったら 

BGE_4_NAME DB "初級師範アーネスト",0
BGE_4_SRT1 LABEL BYTE
BGE_4_SRT2 DB "｢＊＊＊＊＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_4_SIGO DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	☆日々失敗編☆

BGE_DAYS_TBL	LABEL	WORD		; 失敗時台詞
	DW	BGE_DAYS12,BGE_DAYS34,BGE_DAYS56,BGE_DAYS78
BGE_DAYS12 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_DAYS34 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_DAYS56 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_DAYS78 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆試験編☆

BGE_TST_ALL_TBL	LABEL	WORD	;試験テーブル
	DW	BGE_1_TST_TBL	;base0.
	DW	BGE_1_TST_TBL	;初級師範アーネスト
	DW	BGE_2_TST_TBL	;中級師範エレミス
	DW	BGE_3_TST_TBL	;上級師範ラトス

BGE_1_TST_TBL	LABEL	WORD	;初級師範アーネスト
	DW	BGE_1_TST_1	;base0.
	DW	BGE_1_TST_1	;勧誘
	DW	BGE_1_TST_2	;受験する場合
	DW	BGE_1_TST_3	;受験しない場合
	DW	BGE_1_TST_4	;負けた場合１（相手の残りＨＰが８０％以上）
	DW	BGE_1_TST_5	;負けた場合２（相手の残りＨＰが８０％未満）
	DW	BGE_1_TST_6	;勝った場合
	DW	BGE_1_TST_7	;なにもないとき
BGE_1_TST_1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_1_TST_2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_1_TST_3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_1_TST_4 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_1_TST_5 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_1_TST_6 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_1_TST_7 DB "｢＊＊＊＊＊＊＊」",0

BGE_2_TST_TBL	LABEL	WORD	;中級師範エレミス
	DW	BGE_2_TST_1	;base0.
	DW	BGE_2_TST_1	;勧誘
	DW	BGE_2_TST_2	;受験する場合
	DW	BGE_2_TST_3	;受験しない場合
	DW	BGE_2_TST_4	;負けた場合１（相手の残りＨＰが８０％以上）
	DW	BGE_2_TST_5	;負けた場合２（相手の残りＨＰが８０％未満）
	DW	BGE_2_TST_6	;勝った場合
	DW	BGE_2_TST_7	;なにもないとき
BGE_2_TST_1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_2_TST_2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_2_TST_3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_2_TST_4 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_2_TST_5 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_2_TST_6 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_2_TST_7 DB "｢＊＊＊＊＊＊＊＊＊＊」",0


BGE_3_TST_TBL	LABEL	WORD	;上級師範ラトス
	DW	BGE_3_TST_1	;base0.
	DW	BGE_3_TST_1	;勧誘
	DW	BGE_3_TST_2	;受験する場合
	DW	BGE_3_TST_3	;受験しない場合
	DW	BGE_3_TST_4	;負けた場合１（相手の残りＨＰが８０％以上）
	DW	BGE_3_TST_5	;負けた場合２（相手の残りＨＰが８０％未満）
	DW	BGE_3_TST_6	;勝った場合
	DW	BGE_3_TST_7	;なにもないとき
BGE_3_TST_1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_3_TST_2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_3_TST_3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_3_TST_4 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊」",0
BGE_3_TST_5 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_3_TST_6 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
BGE_3_TST_7 DB "｢＊＊＊＊＊＊＊」",0

TEXT_OUT


; ****************************************************
;	学問スタート台詞
;	-I- DX : クラス 1=初級,2=中級,3=上級,4=卒業
; ****************************************************

FUNC	RR_MS_GAKUM_SRT,R_MS_GAKUM_SRT
	BANDED	DX,4				;
	MOV	MY_CLASS,DX			; クラス

	CALL	TALK_SRT02			; 会話スタート（クリア無し）

	MOV	SI,1				; 1=学問場の先生
	MOV	DI,3				; 3=学問場
	CALLC	WIDFACE_OPEN_W			; WINDOWS/行いフェイスＯＰＥＮ

	MOV	BX,MY_CLASS			; クラス
	DEC	BX				; －１
	SHL	BX,1				; word pointer.

	PRINTV	<OFFSET GAK_NAME>		; "学問所教官ギブソン"


	MOV	CX,MY_CLASS			; 1=初級,2=中級,3=上級,4=卒業
	MOV	DX,1				;
	SHL	DX,CL				;0000000000000010B  初級２回目
						;0000000000000100B  中級２回目
						;0000000000001000B  上級２回目
						;0000000000010000B  卒業２回目
	MOV	ES,BUGARE_FLG_SEG		; 武・学・礼フラグセグメント
	MOV	DI,BUGARE_FLG_OFS		; 武・学・礼フラグオフセット
	TEST	ES:[DI][SLT_GAKUMON],DX		; フラグ武芸 ２回目以降
	JNZ	R_MS_GAKUM_SRT_2ND		;
	OR	ES:[DI][SLT_GAKUMON],DX		;

R_MS_GAKUM_SRT_FST:				;
	MOVX	ES,<SEG R_SEG3>			;
	PRINTVF	ES:GAK_SRT_FST_TBL[BX]		; はじめて会う
	JMP	R_MS_GAKUM_SRT_6		;

R_MS_GAKUM_SRT_2ND:				;
	MOVX	ES,<SEG R_SEG3>			;
	PRINTVF	ES:GAK_SRT_2ND_TBL[BX]		; ２度目
	JMP	R_MS_GAKUM_SRT_6		;

R_MS_GAKUM_SRT_6:				;
	PUSH	ES
	PUSH	BX
	CALL	ZUCIZUCI			; あいづち
	MUSIC_FAR	KYOKU_F_O		; 音楽フェードアウト
	CALLC	WIDFACE_CLOSE_W			; WINDOWS/行いフェイスCLOSE
	POP	BX
	POP	ES
	PRINTVF	ES:GAK_SRT_SIG_TBL[BX]		; スタート台詞

R_MS_GAKUM_SRT_EXIT:
	CALL	TALK_FIN			; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_GAKUM_SRT


; ****************************************************
;	学問日々台詞
;	-I- DX : 知力
; ****************************************************

FUNC	RR_MS_GAKUM_DAYS,R_MS_GAKUM_DAYS
	MOV	TXT_PARM,DX		; 知力

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	PRINTX	"本日の学習の成果は……"

	CMP	TXT_PARM,0		; 知力
	JE	R_MS_GAKUM_DAYS_SHIPPAI	;

R_MS_GAKUM_DAYS_SEIKO:			; ＊成功時＊
	PRINTX	"@&nの知力が&0アップした！"
	JMP	R_MS_GAKUM_DAYS_EXIT

R_MS_GAKUM_DAYS_SHIPPAI:		; ＊失敗時＊
	CALL	HOW_MANY_YEARS		; 何年目か BX=年のword pointer(R_SEG2)

	MOVX	ES,<SEG R_SEG3>		;
	PRINTVF	ES:GAK_DAYS_TBL[BX]	; 失敗時台詞

	PRINTX	"@何も得るものがなかった……"
	JMP	R_MS_GAKUM_DAYS_EXIT

R_MS_GAKUM_DAYS_EXIT:
	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_GAKUM_DAYS


; ****************************************************
;	学問決算台詞
;	-I- DX : 知力
;	    CX : 日数
; ****************************************************

FUNC	RR_MS_GAKUM_UPD,R_MS_GAKUM_UPD
	MOV	TXT_PARM,DX		; 知力
	MOV	TXT_DAYS,CX		; テキスト日数

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	PRINTX	"&d日の勉強で&nの知力は合計&0上がった。"

	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_GAKUM_UPD


; ****************************************************
;	学問試験台詞
;	-I- DX : クラス 1=初級,2=中級,3=上級
;	    BX : 台詞種類 1=勧誘,2=受験する場合,3=受験しない場合
;			  4=不合格,5=合格
;			  6=なにもないとき
; ****************************************************

FUNC	RR_MS_GAKUM_TST,R_MS_GAKUM_TST
	BANDED	DX,3
	BANDED	BX,6
	MOV	MY_CLASS,DX		; クラス 1=初級,2=中級,3=上級
	MOV	NUM,BX			; 台詞種類

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,MY_CLASS		; クラス 1=初級,2=中級,3=上級
	SHL	BX,1			; word pointer.
	MOV	DI,ES:GAK_TST_ALL_TBL[BX] ;試験テーブル
	MOV	BX,NUM			; 台詞種類
	SHL	BX,1			; word pointer.
	PRINTV	ES:[DI][BX]		; 台詞

	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_GAKUM_TST


TEXT_IN
	;☆★☆★学問を習う☆★☆

GAK_NAME DB "学問所教官ギブソン",0

;		初級　　　中級　　　上級	卒業

GAK_SRT_FST_TBL	LABEL	WORD					;はじめて会う
	DW	GAK_1_SRT1,GAK_2_SRT1,GAK_3_SRT1,GAK_4_SRT1
GAK_SRT_2ND_TBL	LABEL	WORD					;２度目
	DW	GAK_1_SRT2,GAK_2_SRT2,GAK_3_SRT2,GAK_4_SRT2
GAK_SRT_SIG_TBL	LABEL	WORD					;スタート台詞
	DW	GAK_1_SIGO,GAK_2_SIGO,GAK_3_SIGO,GAK_4_SIGO

	;初級
GAK_1_SRT1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	   DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_1_SRT2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_1_SIGO DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
	;中級
GAK_2_SRT1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	   DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_2_SRT2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_2_SIGO DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

	;上級
GAK_3_SRT1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	   DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_3_SRT2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_3_SIGO DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

	;☆★卒業してしまったら☆★学問所教官ギブソン
GAK_4_SRT1 LABEL BYTE
GAK_4_SRT2 DB "｢＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_4_SIGO DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	☆日々失敗編☆

GAK_DAYS_TBL	LABEL	WORD		; 失敗時台詞
	DW	GAK_DAYS12,GAK_DAYS34,GAK_DAYS56,GAK_DAYS78
GAK_DAYS12 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_DAYS34 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_DAYS56 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_DAYS78 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0


;	☆試験編☆

GAK_TST_ALL_TBL	LABEL	WORD	;試験テーブル
	DW	GAK_1_TST_TBL	;base0.
	DW	GAK_1_TST_TBL	;☆★初級コースの場合☆★
	DW	GAK_2_TST_TBL	;☆★中級コースの場合☆★
	DW	GAK_3_TST_TBL	;☆★上級コースの場合☆★

GAK_1_TST_TBL	LABEL	WORD	;☆★初級コースの場合☆★
	DW	GAK_1_TST_1	;base0.
	DW	GAK_1_TST_1	;勧誘
	DW	GAK_1_TST_2	;受験する場合
	DW	GAK_1_TST_3	;受験しない場合
	DW	GAK_1_TST_4	;不合格
	DW	GAK_1_TST_5	;合格
	DW	GAK_1_TST_6	;なにもないとき
GAK_1_TST_1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_1_TST_2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_1_TST_3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_1_TST_4 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_1_TST_5 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_1_TST_6 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

GAK_2_TST_TBL	LABEL	WORD	;☆★中級コースの場合☆★
	DW	GAK_2_TST_1	;base0.
	DW	GAK_2_TST_1	;勧誘
	DW	GAK_2_TST_2	;受験する場合
	DW	GAK_2_TST_3	;受験しない場合
	DW	GAK_2_TST_4	;不合格
	DW	GAK_2_TST_5	;合格
	DW	GAK_2_TST_6	;なにもないとき
GAK_2_TST_1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_2_TST_2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_2_TST_3 DB "｢＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_2_TST_4 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_2_TST_5 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_2_TST_6 DB "｢＊＊＊＊＊＊＊＊」",0


GAK_3_TST_TBL	LABEL	WORD	;☆★上級コースの場合☆★
	DW	GAK_3_TST_1	;base0.
	DW	GAK_3_TST_1	;勧誘
	DW	GAK_3_TST_2	;受験する場合
	DW	GAK_3_TST_3	;受験しない場合
	DW	GAK_3_TST_4	;不合格
	DW	GAK_3_TST_5	;合格
	DW	GAK_3_TST_6	;なにもないとき
GAK_3_TST_1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_3_TST_2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_3_TST_3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_3_TST_4 DB "｢＊＊＊＊＊＊＊＊＊＊」",0
GAK_3_TST_5 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
GAK_3_TST_6 DB "｢＊＊＊＊＊＊＊＊＊＊」",0

TEXT_OUT


; ****************************************************
;	礼法スタート台詞
; ****************************************************

FUNC	RR_MS_REIHO_SRT,R_MS_REIHO_SRT
	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	MOV	SI,1			; 1=礼法の先生
	MOV	DI,4			; 4=礼法の先生
	CALLC	WIDFACE_OPEN_W		; WINDOWS/行いフェイスＯＰＥＮ

	MOV	ES,BUGARE_FLG_SEG		; 武・学・礼フラグセグメント
	MOV	DI,BUGARE_FLG_OFS		; 武・学・礼フラグオフセット
	TSTW	ES:[DI][SLT_REIHOU],FLG_L_FIRST	; 初級２回目以降
	JNZ	R_MS_REIHO_SRT_2ND		;
	ORW	ES:[DI][SLT_REIHOU],FLG_L_FIRST	; 初級２回目以降

R_MS_REIHO_SRT_FST:				;
	PRINTVF	<OFFSET REI_SRT_FST>		;
	JMP	R_MS_REIHO_SRT_6		;

R_MS_REIHO_SRT_2ND:				;
	PRINTVF <OFFSET REI_SRT_2ND>		;

R_MS_REIHO_SRT_6:				;
	CALL	ZUCIZUCI			; あいづち

	MOV	AX,40				; wait timer count.
	CALLC	TMVSET				; V-SYNC timer set.

	MUSIC_FAR	KYOKU_F_O		; 音楽フェードアウト

	CALLC	WIDFACE_CLOSE_W			; WINDOWS/行いフェイスCLOSE

	CALLC	TMVEWT				; V-SYNC timer end wait.

	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_REIHO_SRT


; ****************************************************
;	礼法日々台詞
;	-I- DX : 気品
; ****************************************************

FUNC	RR_MS_REIHO_DAYS,R_MS_REIHO_DAYS
	MOV	TXT_PARM,DX		; 気品

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	PRINTX	"本日のお稽古の成果は……"

	CMP	TXT_PARM,0		; 気品
	JE	R_MS_REIHO_DAYS_SIPPAI	;

R_MS_REIHO_DAYS_SEIKO:			;＊成功時＊
	PRINTX	"@&nの気品が&0アップした！"
	JMP	R_MS_REIHO_DAYS_EXIT

R_MS_REIHO_DAYS_SIPPAI:
	CALL	HOW_MANY_YEARS		; 何年目か BX=年のword pointer(R_SEG2)

	MOVX	ES,<SEG R_SEG3>		;
	PRINTVF	ES:REI_DAYS_TBL[BX]	; 失敗時台詞

	;＊失敗時＊
	PRINTX	"@何も身に付かなかったようだ……"
	JMP	R_MS_REIHO_DAYS_EXIT

R_MS_REIHO_DAYS_EXIT:
	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_REIHO_DAYS


; ****************************************************
;	礼法決算台詞
;	-I- DX : 気品
;	    CX : 日数
; ****************************************************

FUNC	RR_MS_REIHO_UPD,R_MS_REIHO_UPD
	MOV	TXT_PARM,DX		; 知力
	MOV	TXT_DAYS,CX		; テキスト日数

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,62		; 62=気品段階
	CALLC	R_KEISAN		; 各計算処理
	MOV	KIHIN_LEV1,DX		; 気品段階（１から６）
	MOV	KIHIN_LEV2,AX		; 気品段階（１から３）

	MOV	BX,KIHIN_LEV1		; 気品段階（１から６）
	BANDED	BX,5			; ５まで

	SHL	BX,1			;
	MOVX	ES,<SEG R_SEG3>		;
	PRINTV	ES:REI_FIN_TBL[BX]	;＊礼法が終ったら＊

	CALL	TALK_FIN		; 会話ストップ（クリア無し）
	RET
FEND	RR_MS_REIHO_UPD

TEXT_IN

;	☆★☆礼法の訓練時のメッセージ★☆★

;	礼法師匠・ラトゥ伯爵夫人

REI_SRT_FST DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	    DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
REI_SRT_2ND DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆日々失敗編☆

REI_DAYS_TBL	LABEL	WORD		; 失敗時台詞
	DW	REI_DAYS12,REI_DAYS34,REI_DAYS56,REI_DAYS78
REI_DAYS12 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
REI_DAYS34 DB "｢＊＊＊＊＊＊＊＊＊」",0
REI_DAYS56 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
REI_DAYS78 DB "｢＊＊＊＊＊＊＊＊＊」",0

REI_FIN_TBL	LABEL	WORD	;＊礼法が終ったら＊
	DW	REI_FIN1	; base0.
	DW	REI_FIN1
	DW	REI_FIN2
	DW	REI_FIN3
	DW	REI_FIN4
	DW	REI_FIN5
REI_FIN1 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
REI_FIN2 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	 DB "＊＊＊＊＊＊＊＊」",0
REI_FIN3 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
REI_FIN4 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
REI_FIN5 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
REI_FIN6 DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

TEXT_OUT

; ****************************************************
;	あいづち
; ****************************************************

ZUCIZUCI	PROC	NEAR
	CALLC	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
	RET
ZUCIZUCI	ENDP


; ****************************************************
;	WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
; ****************************************************

WWIDSLC2	PROC	NEAR
	CALLC	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	RET
WWIDSLC2	ENDP

R_SEG2	ENDS





DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	S_FUNC:WORD			; 計算ファンクション
EXTRN	MESS_ADRS:WORD			; メッセージアドレス
EXTRN	MESS_SEG:WORD			; メッセージセグメント

EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス
EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス
EXTRN	R_NAISTR:WORD			; 内容文字列

EXTRN	TXT_PARM:WORD			; テキストパラメータ
EXTRN	TXT_MONEY:WORD			; テキストお金
EXTRN	TXT_DAYS:WORD			; テキスト日数
EXTRN	TXT_KEIKEN:WORD			; テキスト経験値

EXTRN	S_FUNC:WORD			; 計算ファンクション
EXTRN	WIDSNM:WORD			; ユーザ選択番号

EXTRN	BUGARE_FLG_OFS:WORD		; 武・学・礼フラグオフセット
EXTRN	BUGARE_FLG_SEG:WORD		; 武・学・礼フラグセグメント

MY_CLASS	DW	0		; クラス 1=初級,2=中級,3=上級

KIHIN_LEV1	DW	0		; 気品段階（１から６）
KIHIN_LEV2	DW	0		; 気品段階（１から３）

NUM		DW	0		; 番号

DATA	ENDS

	END
;
;	end of "R_MESS02.ASM"
;
