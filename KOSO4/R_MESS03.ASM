; "R_MESS03.ASM" PC-9801UV11 make by R.H 1991/02/26
;
;
;	「子育て」
;
;	メッセージ・アルバイト
;
;	プログラムの最後に　INCLUDE　R_MESAD3.INC　がある。
;
;
;	R_MS_ARBT_SRT		; アルバイトスタート台詞
;	R_MS_ARBT_DAYS		; アルバイト日々台詞
;	R_MS_ARBT_UPD		; アルバイト決算台詞
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	WORDID.INC
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
;	アルバイト・フラグ
; ****************************************************

		;bit	FEDCBA9876543210
FLG_W_FIRST	EQU	0000000000000010B	; ２回目以降

SLT_YADOYA	EQU	2*1			; 1=フラグ宿屋
SLT_SAKAYA	EQU	2*2			; 2=フラグ酒屋
SLT_BUKIYA	EQU	2*3			; 3=フラグ武器屋
SLT_KYOKAI	EQU	2*4			; 4=フラグ教会
SLT_MEIDOO	EQU	2*5			; 5=フラグメイド
SLT_DOCTOR	EQU	2*6			; 6=フラグ医者
SLT_AYAYAD	EQU	2*7			; 7=フラグあやしい宿屋
SLT_AYASKE	EQU	2*8			; 8=フラグあやしい酒場
SLT_DAIHIT	EQU	2*9			; 9=フラグ代筆屋
SLT_HANTER	EQU	2*10			; 10=フラグ狩人
SLT_KIKORI	EQU	2*11			; 11=フラグ木コリ
SLT_NINSOK	EQU	2*12			; 12=フラグ人足


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


R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

EXTRN	TALK_START:NEAR		; 会話スタート(R_SEG2)
EXTRN	TALK_END:NEAR		; 会話ストップ(R_SEG2)
EXTRN	TALK_SRT02:NEAR		; 会話スタート（クリア無し）(R_SEG2)
EXTRN	TALK_FIN:NEAR		; 会話ストップ（クリア無し）(R_SEG2)
EXTRN	MESSAGE_LF:NEAR		; メッセージ改行(R_SEG2)
EXTRN	HOW_MANY_YEARS:NEAR	; 何年目か BX=年のword pointer(R_SEG2)


; ****************************************************
;	アルバイトスタート台詞
;	-I- BX : アルバイト名前アドレス
; ****************************************************

FUNC	RR_MS_ARBT_SRT,R_MS_ARBT_SRT
	CALL	A_ID_SEARCH		; アルバイト番号ＩＤ検索
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	R_MS_ARBT_SRT_SKIP	;

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,ARBEIT_ADRS		; アルバイトポインタ
	PRINTV	ES:ARBT_SRT0[BX]	; 今日から&nは町の宿屋でお仕事です。

	MOV	ES,ARBEIT_FLG_SEG	; アルバイトフラグセグメント
	MOV	DI,ARBEIT_FLG_OFS	; アルバイトフラグオフセット
	MOV	BX,ARBEIT_ADRS		; アルバイトポインタ
	TSTW	ES:[DI][BX],FLG_W_FIRST	; フラグ武芸 ２回目以降
	JNZ	R_MS_ARBT_SRT_2ND	;
	ORW	ES:[DI][BX],FLG_W_FIRST	;

R_MS_ARBT_SRT_FST:
	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,ARBEIT_ADRS		; アルバイトポインタ
	PRINTVF	ES:ARBT_SRT1[BX]	; １回目｢来たわね。仕事は

	JMP	R_MS_ARBT_SRT_KURU	;
R_MS_ARBT_SRT_2ND:
	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,ARBEIT_ADRS		; アルバイトポインタ
	PRINTVF	ES:ARBT_SRT2[BX]	; ２回目｢しっかり働いておくれよ」

R_MS_ARBT_SRT_KURU:
	PUSH	ES
	PUSH	BX
	CALL	ZUCIZUCI		; あいづち
	POP	BX
	POP	ES
	PRINTVF	ES:ARBT_SRT3[BX]	; 来る日も来る日も

R_MS_ARBT_SRT_EXIT:
	CALL	TALK_FIN		; 会話ストップ（クリア無し）
R_MS_ARBT_SRT_SKIP:
	RET
FEND	RR_MS_ARBT_SRT


; ****************************************************
;	アルバイト日々台詞
;	-I- BX : アルバイト名前アドレス
;	    AX : ミスフラグ 1=成功,2=ミス！
; ****************************************************

FUNC	RR_MS_ARBT_DAYS,R_MS_ARBT_DAYS
	CMP	AX,1			; ミスフラグ 1=成功,2=ミス！
	JE	R_MS_ARBT_DAYS_SKIP	;

	CALL	A_ID_SEARCH		; アルバイト番号ＩＤ検索
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	R_MS_ARBT_DAYS_SKIP	;

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,ARBEIT_ADRS		; アルバイトポインタ
	MOV	DI,ES:ARBT_DAYS[BX]	; address
	PRINTV	ES:[DI][0]		; 仕事でミスをした。

	CALL	A_RANDAM		; アルバイト乱数
	MOV	BX,SAIKORO_ADRS		; アルバイト乱数ポインタ
	PRINTVF	ES:[DI][BX]		;

	CALL	TALK_FIN		; 会話ストップ（クリア無し）

R_MS_ARBT_DAYS_SKIP:			;
	RET
FEND	RR_MS_ARBT_DAYS


; ****************************************************
;	アルバイト決算台詞
;	-I- BX : アルバイト名前アドレス
;	    AX : ミスフラグ 1=成功,2=ミス！
;	    DX : 稼いだお金
;	    CX : 稼いだ日数
; ****************************************************

FUNC	RR_MS_ARBT_UPD,R_MS_ARBT_UPD
	MOV	MISS_FLAG,AX		; ミスフラグ 1=成功,2=ミス！
	MOV	TXT_MONEY,DX		; テキストお金
	MOV	TXT_DAYS,CX		; テキスト日数

	CALL	A_ID_SEARCH		; アルバイト番号ＩＤ検索
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	R_MS_ARBT_UPD_SKIP	;

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	CMP	MISS_FLAG,2		; ミスフラグ 1=成功,2=ミス！
	JE	R_MS_ARBT_UPD_MISS	;

R_MS_ARBT_UPD_OK:			;
	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,ARBEIT_ADRS		; アルバイトポインタ
	PRINTV	ES:ARBT_END1[BX]	; ｢ごくろうさん、＊ミスがなかったら＊

	JMP	R_MS_ARBT_UPD_EXIT	;

R_MS_ARBT_UPD_MISS:			;
	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,ARBEIT_ADRS		; アルバイトポインタ
	PRINTV	ES:ARBT_END2[BX]	; ｢ごくろうさん。＊ミスがあったら＊

R_MS_ARBT_UPD_EXIT:			;
	CALL	TALK_FIN		; 会話ストップ（クリア無し）

R_MS_ARBT_UPD_SKIP:			;
	RET
FEND	RR_MS_ARBT_UPD


; ****************************************************
;	アルバイト番号ＩＤ検索
;	-I- BX         : アルバイト名前アドレス
;	-O- AX         : 1=見つかった,0=見つからない
;	    ARBEIT_NUM : アルバイト番号
;	    ARBEIT_ADRS: アルバイトポインタ
; ****************************************************

A_ID_SEARCH	PROC	NEAR
	CALLC	R_ENV_IDNAME			; 環境文字のＩＤ検索
	CMP	AX,0				; 1=見つかった,0=見つからない
	JE	A_ID_SEARCH_EXIT		;
						; DX : ＩＤ

	MOVX	ES,<SEG R_SEG3>			; テキスト
	MOV	DI,OFFSET ID_TABLE_ARBT		; 名前ＩＤ
	CALLC	BYTE_TBL_SCH			; バイトテーブルサーチ
	MOV	ARBEIT_NUM,CX			; アルバイト番号
	SHL	CX,1				; word pointer.
	MOV	ARBEIT_ADRS,CX			; アルバイトポインタ
A_ID_SEARCH_EXIT:
	RET
A_ID_SEARCH	ENDP


; ****************************************************
;	アルバイト乱数
;	-O- SAIKORO      : アルバイト乱数
;	    SAIKORO_ADRS : アルバイト乱数ポインタ
; ****************************************************

A_RANDAM	PROC	NEAR
	PUSH	ES
	PUSH	DI
	PUSH	SI
	PUSH	AX
	MOV	CX,6			; 範囲 ６まで
	CALLC	RANDAM_CX		; 乱数範囲指定
	MOV	SAIKORO,AX		; アルバイト乱数
	SHL	AX,1			; word pointer.
	MOV	SAIKORO_ADRS,AX		; アルバイト乱数ポインタ
	POP	AX
	POP	SI
	POP	DI
	POP	ES
	RET
A_RANDAM	ENDP


; ****************************************************
;	あいづち
; ****************************************************

ZUCIZUCI	PROC	NEAR
	CALLC	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
	MUSIC_FAR	KYOKU_F_O	; 音楽フェードアウト
	RET
ZUCIZUCI	ENDP

TEXT_IN

ID_TABLE_ARBT	LABEL	BYTE	; 名前ＩＤ
		DB	12	; テーブルサイズ=n
		DB	ID_52	; 1=宿屋
		DB	ID_53	; 2=酒屋
		DB	ID_54	; 3=武器屋
		DB	ID_55	; 4=教会
		DB	ID_56	; 5=メイド
		DB	ID_57	; 6=医者
		DB	ID_58	; 7=あやしい宿屋
		DB	ID_59	; 8=あやしい酒場
		DB	ID_60	; 9=代筆屋
		DB	ID_61	; 10=狩人
		DB	ID_62	; 11=木コリ
		DB	ID_63	; 12=人足

ARBT_NAME	LABEL	WORD	; 宿屋のおかみ・エレノア
	DW ARBT_01_NAME,ARBT_01_NAME,ARBT_02_NAME,ARBT_03_NAME,ARBT_04_NAME
	DW ARBT_05_NAME,ARBT_06_NAME,ARBT_07_NAME,ARBT_08_NAME,ARBT_09_NAME
	DW ARBT_10_NAME,ARBT_11_NAME,ARBT_12_NAME
ARBT_SRT0	LABEL	WORD	; 今日から&nは町の宿屋でお仕事です。
	DW ARBT_01_SRT0,ARBT_01_SRT0,ARBT_02_SRT0,ARBT_03_SRT0,ARBT_04_SRT0
	DW ARBT_05_SRT0,ARBT_06_SRT0,ARBT_07_SRT0,ARBT_08_SRT0,ARBT_09_SRT0
	DW ARBT_10_SRT0,ARBT_11_SRT0,ARBT_12_SRT0
ARBT_SRT1	LABEL	WORD	; １回目｢来たわね。仕事は
	DW ARBT_01_SRT1,ARBT_01_SRT1,ARBT_02_SRT1,ARBT_03_SRT1,ARBT_04_SRT1
	DW ARBT_05_SRT1,ARBT_06_SRT1,ARBT_07_SRT1,ARBT_08_SRT1,ARBT_09_SRT1
	DW ARBT_10_SRT1,ARBT_11_SRT1,ARBT_12_SRT1
ARBT_SRT2	LABEL	WORD	; ２回目｢しっかり働いておくれよ」
	DW ARBT_01_SRT2,ARBT_01_SRT2,ARBT_02_SRT2,ARBT_03_SRT2,ARBT_04_SRT2
	DW ARBT_05_SRT2,ARBT_06_SRT2,ARBT_07_SRT2,ARBT_08_SRT2,ARBT_09_SRT2
	DW ARBT_10_SRT2,ARBT_11_SRT2,ARBT_12_SRT2
ARBT_SRT3	LABEL	WORD	; 来る日も来る日も
	DW ARBT_01_SRT3,ARBT_01_SRT3,ARBT_02_SRT3,ARBT_03_SRT3,ARBT_04_SRT3
	DW ARBT_05_SRT3,ARBT_06_SRT3,ARBT_07_SRT3,ARBT_08_SRT3,ARBT_09_SRT3
	DW ARBT_10_SRT3,ARBT_11_SRT3,ARBT_12_SRT3
ARBT_DAYS	LABEL	WORD	; 仕事でミスをした。
	DW ARBT_01_DAYS,ARBT_01_DAYS,ARBT_02_DAYS,ARBT_03_DAYS,ARBT_04_DAYS
	DW ARBT_05_DAYS,ARBT_06_DAYS,ARBT_07_DAYS,ARBT_08_DAYS,ARBT_09_DAYS
	DW ARBT_10_DAYS,ARBT_11_DAYS,ARBT_12_DAYS
ARBT_END1	LABEL	WORD	; ｢ごくろうさん、＊ミスがなかったら＊
	DW ARBT_01_END1,ARBT_01_END1,ARBT_02_END1,ARBT_03_END1,ARBT_04_END1
	DW ARBT_05_END1,ARBT_06_END1,ARBT_07_END1,ARBT_08_END1,ARBT_09_END1
	DW ARBT_10_END1,ARBT_11_END1,ARBT_12_END1
ARBT_END2	LABEL	WORD	; ｢ごくろうさん。＊ミスがあったら＊
	DW ARBT_01_END2,ARBT_01_END2,ARBT_02_END2,ARBT_03_END2,ARBT_04_END2
	DW ARBT_05_END2,ARBT_06_END2,ARBT_07_END2,ARBT_08_END2,ARBT_09_END2
	DW ARBT_10_END2,ARBT_11_END2,ARBT_12_END2

ARBT_01_DAYS	LABEL	WORD
	DW	ARBT_01_DAY0,ARBT_01_DAY1,ARBT_01_DAY2,ARBT_01_DAY3
	DW	ARBT_01_DAY4,ARBT_01_DAY5,ARBT_01_DAY6
ARBT_02_DAYS	LABEL	WORD
	DW	ARBT_02_DAY0,ARBT_02_DAY1,ARBT_02_DAY2,ARBT_02_DAY3
	DW	ARBT_02_DAY4,ARBT_02_DAY5,ARBT_02_DAY6
ARBT_03_DAYS	LABEL	WORD
	DW	ARBT_03_DAY0,ARBT_03_DAY1,ARBT_03_DAY2,ARBT_03_DAY3
	DW	ARBT_03_DAY4,ARBT_03_DAY5,ARBT_03_DAY6
ARBT_04_DAYS	LABEL	WORD
	DW	ARBT_04_DAY0,ARBT_04_DAY1,ARBT_04_DAY2,ARBT_04_DAY3
	DW	ARBT_04_DAY4,ARBT_04_DAY5,ARBT_04_DAY6
ARBT_05_DAYS	LABEL	WORD
	DW	ARBT_05_DAY0,ARBT_05_DAY1,ARBT_05_DAY2,ARBT_05_DAY3
	DW	ARBT_05_DAY4,ARBT_05_DAY5,ARBT_05_DAY6
ARBT_06_DAYS	LABEL	WORD
	DW	ARBT_06_DAY0,ARBT_06_DAY1,ARBT_06_DAY2,ARBT_06_DAY3
	DW	ARBT_06_DAY4,ARBT_06_DAY5,ARBT_06_DAY6
ARBT_07_DAYS	LABEL	WORD
	DW	ARBT_07_DAY0,ARBT_07_DAY1,ARBT_07_DAY2,ARBT_07_DAY3
	DW	ARBT_07_DAY4,ARBT_07_DAY5,ARBT_07_DAY6
ARBT_08_DAYS	LABEL	WORD
	DW	ARBT_08_DAY0,ARBT_08_DAY1,ARBT_08_DAY2,ARBT_08_DAY3
	DW	ARBT_08_DAY4,ARBT_08_DAY5,ARBT_08_DAY6
ARBT_09_DAYS	LABEL	WORD
	DW	ARBT_09_DAY0,ARBT_09_DAY1,ARBT_09_DAY2,ARBT_09_DAY3
	DW	ARBT_09_DAY4,ARBT_09_DAY5,ARBT_09_DAY6
ARBT_10_DAYS	LABEL	WORD
	DW	ARBT_10_DAY0,ARBT_10_DAY1,ARBT_10_DAY2,ARBT_10_DAY3
	DW	ARBT_10_DAY4,ARBT_10_DAY5,ARBT_10_DAY6
ARBT_11_DAYS	LABEL	WORD
	DW	ARBT_11_DAY0,ARBT_11_DAY1,ARBT_11_DAY2,ARBT_11_DAY3
	DW	ARBT_11_DAY4,ARBT_11_DAY5,ARBT_11_DAY6
ARBT_12_DAYS	LABEL	WORD
	DW	ARBT_12_DAY0,ARBT_12_DAY1,ARBT_12_DAY2,ARBT_12_DAY3
	DW	ARBT_12_DAY4,ARBT_12_DAY5,ARBT_12_DAY6


;	☆★☆アルバイト時のメッセージ★☆★

; ****************************************************
;	＊＊＊宿屋の場合＊＊＊
; ****************************************************

ARBT_01_NAME	DB "宿屋のおかみ・エレノア",0
ARBT_01_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_01_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊」",0
ARBT_01_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_01_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_01_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_01_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_01_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_01_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_01_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_01_DAY5	DB "｢＊＊＊＊＊＊＊＊＊」",0
ARBT_01_DAY6	DB "｢＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_01_END1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊&d＊＊＊＊＊＊&m＊＊＊＊＊＊＊＊」",0

;	＊ミスがあったら＊

ARBT_01_END2	DB "｢＊＊＊＊＊＊＊＊＊&d＊＊＊＊＊＊&m＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

; ****************************************************
;	＊＊＊酒屋の場合＊＊＊
; ****************************************************

ARBT_02_NAME	DB "酒屋の主人・ドミニコ",0
ARBT_02_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_02_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_02_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_02_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_02_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_02_DAY1	DB "｢＊＊＊＊＊＊＊＊＊」",0
ARBT_02_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊」",0
ARBT_02_DAY3	DB "｢＊＊＊＊＊＊＊＊」",0
ARBT_02_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_02_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_02_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_02_END1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊&d＊＊＊＊＊&m＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	＊ミスがあったら＊

ARBT_02_END2	DB "｢&d＊＊＊＊＊&m＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊」",0

; ****************************************************
;	＊＊＊武器屋の場合＊＊＊
; ****************************************************

ARBT_03_NAME	DB "武器屋の主人・ガレック",0
ARBT_03_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_03_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_03_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_03_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_03_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_03_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_03_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_03_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_03_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_03_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_03_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_03_END1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊&d＊＊＊＊＊＊&m＊＊」",0

;	＊ミスがあったら＊

ARBT_03_END2	DB "｢＊＊＊&d＊＊＊＊＊&m＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

; ****************************************************
;	＊＊＊教会の場合＊＊＊
; ****************************************************

ARBT_04_NAME	DB "ブスキイ神父",0
ARBT_04_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_04_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

ARBT_04_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊」",0
ARBT_04_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_04_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_04_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_04_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_04_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_04_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_04_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_04_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_04_END1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "&d＊＊＊＊＊＊&m＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	＊ミスがあったら＊

ARBT_04_END2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "&d＊＊＊＊＊&m＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊」",0

; ****************************************************
;	＊＊＊メイドの場合＊＊＊
; ****************************************************

ARBT_05_NAME	DB "家政婦長・イラメニア",0
ARBT_05_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_05_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_05_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_05_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_05_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_05_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_05_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_05_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_05_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_05_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_05_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_05_END1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊&d＊＊＊＊＊＊＊&m＊」",0

;	＊ミスがあったら＊

ARBT_05_END2	DB "｢＊＊＊&d＊＊＊＊＊＊&m＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

; ****************************************************
;	＊＊＊医者の場合＊＊＊
; ****************************************************

ARBT_06_NAME	DB "ゴローニン医師",0
ARBT_06_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_06_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_06_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_06_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_06_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_06_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_06_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_06_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_06_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_06_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_06_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_06_END1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "&d＊＊＊&m＊＊＊＊」",0

;	＊ミスがあったら＊

ARBT_06_END2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "&d＊＊＊＊＊&m＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊」",0

; ****************************************************
;	＊＊＊あやしい宿屋の場合＊＊＊
; ****************************************************

ARBT_07_NAME	DB "宿屋の女主人・クラリーノ",0
ARBT_07_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_07_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊」",0
ARBT_07_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_07_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_07_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_07_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_07_DAY2	DB "｢＊＊＊＊」",0
ARBT_07_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_07_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_07_DAY5	DB "｢＊＊＊＊＊＊＊＊＊」",0
ARBT_07_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_07_END1	DB "｢&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊&d＊＊＊&m」",0

;	＊ミスがあったら＊

ARBT_07_END2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊&d＊＊&m＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

; ****************************************************
;	＊＊＊あやしい酒場の場合＊＊＊
; ****************************************************

ARBT_08_NAME	DB "酒場の主人・ダンケ＝シン",0
ARBT_08_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_08_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊」",0
ARBT_08_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_08_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_08_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_08_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_08_DAY2	DB "｢＊＊＊＊＊」",0
ARBT_08_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_08_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_08_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_08_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_08_END1	DB "｢＊＊＊＊＊＊＊＊&n＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊&d＊＊＊&m＊＊＊＊＊＊＊＊＊＊＊」",0

;	＊ミスがあったら＊

ARBT_08_END2	DB "｢＊＊＊&d＊＊＊&m＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

; ****************************************************
;	＊＊＊代筆屋の場合＊＊＊
; ****************************************************
 
ARBT_09_NAME	DB "代筆師・ムラシ",0
ARBT_09_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_09_SRT1      DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
                DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
                DB "＊＊＊＊＊＊＊＊＊＊＊"
                DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_09_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_09_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_09_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_09_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_09_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_09_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_09_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_09_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_09_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
 
;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_09_END1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊&d＊＊＊＊＊&m＊」",0

;	＊ミスがあったら＊

ARBT_09_END2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
 



; ****************************************************
;	＊＊＊狩人の場合＊＊＊
; ****************************************************

ARBT_10_NAME	DB "狩人・フー＝アモ",0
ARBT_10_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_10_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_10_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_10_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_10_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_10_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_10_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_10_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_10_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_10_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_10_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_10_END1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "&d＊＊＊＊＊＊&m＊＊」",0

;	＊ミスがあったら＊

ARBT_10_END2	DB "｢＊＊＊&d＊＊＊＊＊&m＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
 
; ****************************************************
;	＊＊＊木コリの場合＊＊＊
; ****************************************************

ARBT_11_NAME	DB "木コリ、サトミチ",0
ARBT_11_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_11_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_11_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_11_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_11_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_11_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_11_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_11_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_11_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_11_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_11_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_11_END1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "&d＊＊＊＊＊＊&m＊」",0

;	＊ミスがあったら＊

ARBT_11_END2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊&d日分＊&m＊＊＊＊＊＊」",0

; ****************************************************
;	＊＊＊人足の場合＊＊＊
; ****************************************************

ARBT_12_NAME	DB "ゴリアーテ親方",0
ARBT_12_SRT0	DB "＊＊＊＊&n＊＊＊＊＊＊＊＊＊＊＊＊",0
ARBT_12_SRT1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
		DB "＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_12_SRT2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_12_SRT3	DB "&n＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊失敗した場合＊

ARBT_12_DAY0	DB "&n＊＊＊＊＊＊＊＊＊＊",0
ARBT_12_DAY1	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_12_DAY2	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_12_DAY3	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_12_DAY4	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_12_DAY5	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0
ARBT_12_DAY6	DB "｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	☆バイトが終了したら☆

;	＊ミスがなかったら＊

ARBT_12_END1	DB "｢＊＊＊＊＊＊＊&d＊＊＊＊＊＊&m＊＊＊＊＊＊＊＊」",0

;	＊ミスがあったら＊

ARBT_12_END2	DB "｢＊＊＊＊＊＊＊＊＊＊&d＊＊＊＊＊&m＊＊"
		DB "＊＊＊＊＊＊」",0

TEXT_OUT

R_SEG2	ENDS




DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス

EXTRN	R_NAISTR:WORD			; 内容文字列

EXTRN	TXT_PARM:WORD			; テキストパラメータ
EXTRN	TXT_MONEY:WORD			; テキストお金
EXTRN	TXT_DAYS:WORD			; テキスト日数
EXTRN	TXT_KEIKEN:WORD			; テキスト経験値

EXTRN	S_FUNC:WORD			; 計算ファンクション
EXTRN	WIDSNM:WORD			; ユーザ選択番号
EXTRN	MESS_ADRS:WORD			; メッセージアドレス
EXTRN	MESS_SEG:WORD			; メッセージセグメント

EXTRN	ARBEIT_FLG_OFS:WORD		; アルバイトフラグオフセット
EXTRN	ARBEIT_FLG_SEG:WORD		; アルバイトフラグセグメント

ARBEIT_NUM	DW	0		; アルバイト番号
ARBEIT_ADRS	DW	0		; アルバイトポインタ

SAIKORO		DW	0		; アルバイト乱数
SAIKORO_ADRS	DW	0		; アルバイト乱数ポインタ

MISS_FLAG	DW	0		; ミスフラグ 1=成功,2=ミス！

DATA	ENDS

INCLUDE	R_MESAD3.INC

	END
;
;	end of "R_MESS03.ASM"
;
