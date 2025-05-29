; "R_MESADD.INC" PC-9801UV11 make by R.H 1991/04/27
;
;
;	「子育て」
;
;	ＩＮＣＬＵＤＥ	追加メッセージ
;
;	R_MS_KYOIKU_TXT		; スケジュール教育選択時メッセージ
;	R_MS_MACHINOKOE_MN	; 街の声メイン
;
; (C) 1991 ritsurou hashimoto.

R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

; ****************************************************
;	スケジュール教育選択時メッセージ
; ****************************************************

FUNC	RR_MS_KYOIKU_TXT,R_MS_KYOIKU_TXT

	CALL	HOW_MANY_YEARS			; 何年目か

	MOVX	ES,<SEG R_SEG3>			;
	MOV	SI,ES:MSG_SC_AD[BX]		; 教育選択メッセージ

R_MS_KYOIKU_TXT_PRN:
	MOV	MESS_ADRS,SI			; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示

	RET
FEND	RR_MS_KYOIKU_TXT


TEXT_IN

;	☆★☆スケジュール決定時のリアクション★☆★
;	★娘をきたえる

		EVEN
MSG_SC_AD	LABEL	WORD			; 教育選択メッセージ
		DW	MSG_SC_AD_Y12		;１～２年目
		DW	MSG_SC_AD_Y34		;３～４年目
		DW	MSG_SC_AD_Y56		;５～６年目
		DW	MSG_SC_AD_Y78		;７～８年目
MSG_SC_AD_Y12	DB	"＊＊＊＊＊＊＊＊＊＊＊＊",0
MSG_SC_AD_Y34	DB	"＊＊＊＊＊＊＊＊＊＊＊",0
MSG_SC_AD_Y56	DB	"＊＊＊＊＊＊＊＊＊",0
MSG_SC_AD_Y78	DB	"＊＊＊＊＊＊＊＊＊＊＊＊",0

TEXT_OUT


; ****************************************************
;	街の声メイン
; ****************************************************

FUNC	RR_MS_MACHINOKOE_MN,R_MS_MACHINOKOE_MN
	CALL	TALK_START			; 会話スタート

	PRINTX	"世間の評価も無視できない。町に行ってこの子の評判を聞いてみようか……"
	WSELECT	"よし！,やめよう"
	CMP	WIDSNM,0			; ユーザ選択番号
	JNE	RR_MS_MACHINOKOE_MN_SKIP	;
	CALL	FAR PTR RR_MS_MACHINOKOE	; 街の声
	RET
RR_MS_MACHINOKOE_MN_SKIP:
	CALL	TALK_END			; 会話ストップ
	RET
FEND	RR_MS_MACHINOKOE_MN

R_SEG2	ENDS

;
;	end of "R_MESADD.INC"
;
