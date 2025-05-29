; "R_MESAD3.INC" PC-9801UV11 make by R.H 1991/04/27
;
;
;	「子育て」
;
;	ＩＮＣＬＵＤＥ	追加メッセージ
;
;	R_MS_ARBA_DAME_TXT	; ★アルバイトが断られるとき★
;
; (C) 1991 ritsurou hashimoto.

R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

; ****************************************************
;	★アルバイトが断られるとき★
;	-I- BX : アルバイト名前アドレス
;	-O- DX : フラグ・不良でもアルバイトＯＫだよ=1
; ****************************************************

FUNC	RR_MS_ARBA_DAME_TXT,R_MS_ARBA_DAME_TXT
	MOV	ARBITE_OK,0		; フラグ・不良でもアルバイトＯＫだよ

	CALL	A_ID_SEARCH		; アルバイト番号ＩＤ検索
	CMP	AX,0			; 1=見つかった,0=見つからない
	JMPEQ	R_MS_ARBT_SRT_SKIP	;

	CMP	ARBEIT_NUM,4		; アルバイト番号 4=教会
	JE	R_MS_ARBA_DAME_TXT_OK	;
	CMP	ARBEIT_NUM,7		; 7=あやしい宿屋
	JE	R_MS_ARBA_DAME_TXT_OK	;
	CMP	ARBEIT_NUM,8		; 8=あやしい酒場
	JE	R_MS_ARBA_DAME_TXT_OK	;
	JMP	R_MS_ARBA_DAME_TXT_33	;
R_MS_ARBA_DAME_TXT_OK:			;
	MOV	ARBITE_OK,1		; フラグ・不良でもアルバイトＯＫだよ
R_MS_ARBA_DAME_TXT_33:			;

	CALL	TALK_SRT02		; 会話スタート（クリア無し）

	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,ARBEIT_ADRS		; アルバイトポインタ
	PRINTV	ES:ARBT_NAME[BX]	; 宿屋のおかみ・エレノア

	MOVX	ES,<SEG R_SEG3>		;
	MOV	BX,ARBEIT_ADRS		; アルバイトポインタ
	PRINTVF	ES:ARBT_DAME[BX]	; 「おや‥‥‥うちでは不良は

	CALL	TALK_FIN		; 会話ストップ（クリア無し）
R_MS_ARBA_DAME_TXT_SKIP:
	MOV	DX,ARBITE_OK		; フラグ・不良でもアルバイトＯＫだよ
	RET
FEND	RR_MS_ARBA_DAME_TXT

TEXT_IN

;	プリンセスメーカー台詞追加分
;
;	☆★☆アルバイトが断られるとき★☆★

ARBT_DAME	LABEL	WORD	; 「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」
	DW ARBT_01_DAME,ARBT_01_DAME,ARBT_02_DAME,ARBT_03_DAME,ARBT_04_DAME
	DW ARBT_05_DAME,ARBT_06_DAME,ARBT_07_DAME,ARBT_08_DAME,ARBT_09_DAME
	DW ARBT_10_DAME,ARBT_11_DAME,ARBT_12_DAME

;	宿屋のおかみ・エレノア
ARBT_01_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	酒屋の主人・ドミニコ
ARBT_02_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	武器屋の主人・ガレック
ARBT_03_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	ブスキイ神父
ARBT_04_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	家政婦長・イラメニア
ARBT_05_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	ゴローニン医師
ARBT_06_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	宿屋の女主人・クラリーノ
ARBT_07_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	酒場の主人・ダンケ＝シン
ARBT_08_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	代筆師・ムラシ
ARBT_09_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	狩人・フー＝アモ
ARBT_10_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	木コリ・サトミチ
ARBT_11_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

;	ゴリアーテ親方
ARBT_12_DAME	DB	"「＊＊＊＊＊＊＊＊＊＊＊＊＊」",0

TEXT_OUT

R_SEG2	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

ARBITE_OK	DW	0		; フラグ・不良でもアルバイトＯＫだよ

DATA	ENDS

;
;	end of "R_MESAD3.INC"
;
