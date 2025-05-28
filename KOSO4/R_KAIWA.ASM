; "R_KAIWA.ASM" PC-9801UV11 make by R.H 1991/02/20
;
;
;	「子育て」
;
;	会話
;
;	R_KAIWA			; 娘との会話
;
;
;
;	ここから R_SOUBI_KISEKAE（着せ替えモード）へ行く
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC

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
;	Ｒ＿ＳＥＧ２　から　ＣＯＤＥ　へ　ＣＡＬＬ
; ****************************************************

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
	CALL	MESSAGE_PRINT		; メッセージ表示
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

R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

EXTRN	MESSAGE_PRINT:NEAR	; メッセージ表示

; ****************************************************
;	娘との会話
; ****************************************************

FUNC	RR_KAIWA,R_KAIWA
	MOV	AX,2				; 2=フラグ
	CALLC	R_KAIWA_JYOHO			; 会話情報
	CMP	AX,2				; 2=会話駄目
	JMPEQ	R_KAIWA_DAME			;

	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
	MOVX	MESS_SEG,<SEG R_SEG3>		; メッセージセグメント

	CALLC	TKRHME				; 台詞ホームポジション
	PRINTX	"たまには親子の対話も必要だ。"

	MOV	AX,1			; 口ぱくモード 1=口ぱくあり
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,0				; Ｉ／Ｏ 0:読み出し,1:書き込み
	MOV	S_FUNC,41			; 41=ヘッダーフラグのＩ／Ｏ
	CALLC	R_KEISAN			; 各計算処理
	MOV	MY_FLAGS,DX			; ヘッダフラグ

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	DX,0				; 根性を除くフラグ=1
	MOV	S_FUNC,59			; 59=体力、腕力・・・で一番は
	CALLC	R_KEISAN			; 各計算処理
	MOV	MY_ICHIBAN,BX			; 一番の能力

;*;	WSELECT	"やさしく話す,きびしく話す,お説教する,着がえる"
	WSELECT	"やさしく話す,きびしく話す,お説教する"
	CMP	WIDSNM,0			;
	JE	R_KAIWA_YASASHIKU		;
	CMP	WIDSNM,1			;
	JE	R_KAIWA_KIBISHIKU		;
	CMP	WIDSNM,2			;
	JE	R_KAIWA_SEKKYOU			;
	JMP	R_KAIWA_BREAK			;
R_KAIWA_YASASHIKU:
	CALL	KAIWA_YASASHIKU			; やさしく話す
	JMP	R_KAIWA_KIW_END			;
R_KAIWA_KIBISHIKU:
	CALL	KAIWA_KIBISHIKU			; きびしく話す
	JMP	R_KAIWA_KIW_END			;
R_KAIWA_SEKKYOU:
	CALL	KAIWA_SEKKYOU			; 説　教
	JMP	R_KAIWA_KIW_END			;
;*;R_KAIWA_KISEKAE:
;*;	CALLC	R_SOUBI_KISEKAE			; 着せ替えモード
;*;	JMP	R_KAIWA_EXIT
R_KAIWA_KIW_END:
	WSELECT	"ふむ・・・"

	JMP	R_KAIWA_EXIT
R_KAIWA_BREAK:
	MOV	AX,1				; 1=クリア
	CALLC	R_KAIWA_JYOHO			; 会話情報
R_KAIWA_EXIT:
	CALLC	TKRHME				; 台詞ホームポジション
	MOV	AX,0			; 口ぱくモード 0=口ぱくなし
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
	RET
R_KAIWA_DAME:
	RET
FEND	RR_KAIWA


; ****************************************************
;	やさしく話す
;	-I- MY_FLAGS   : ヘッダフラグ
;	    MY_ICHIBAN : 一番の能力
; ****************************************************

KAIWA_YASASHIKU	PROC	NEAR
	CALL	TALK_YASASHIKU		; やさしく話すおれ
	CALL	S_WAIT			; 会話ＷＡＩＴ

	MOV	MY_TALK_MODE,1		; 会話モード 1=やさしく話す
	CALL	SEKKYO_KEISAN		; 説教計算

	TEST	MY_FLAGS,FLAGS_HIKOU	; 非行化
	JNZ	KAIWA_YASASHIKU_HIKOU	;

	CMP	DX,2			; 結果 1=良い,2=悪い
	JE	KAIWA_YASASHIKU_WARUI	; 悪い

KAIWA_YASASHIKU_YOI:			;
	;　☆　疲労が根性より高い場合（疲労が半分に減少）
        PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊‥‥‥｣"
	PRINTX	"@疲労が減った。"
	JMP	KAIWA_YASASHIKU_EXIT	;
KAIWA_YASASHIKU_WARUI:			;
	;  ★  根性が疲労より高い場合（根性が１～１０低下）
        PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@根性が減った。"
	JMP	KAIWA_YASASHIKU_EXIT	;
KAIWA_YASASHIKU_HIKOU:			;
	;  ＊  非行化していたら‥‥‥（根性が１０～２０低下）
        PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
        PRINTX	"@＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@根性が減った。"
	JMP	KAIWA_YASASHIKU_EXIT	;
KAIWA_YASASHIKU_EXIT:
	RET
KAIWA_YASASHIKU	ENDP


; ****************************************************
;	きびしく話す
; ****************************************************

KAIWA_KIBISHIKU	PROC	NEAR
	CALL	TALK_KIBISHIKU		; きびしく話すおれ
	CALL	S_WAIT			; 会話ＷＡＩＴ

	MOV	MY_TALK_MODE,2		; 会話モード 2=きびしく話す
	CALL	SEKKYO_KEISAN		; 説教計算

	TEST	MY_FLAGS,FLAGS_HIKOU	; 非行化
	JNZ	KAIWA_KIBISHIKU_HIKOU	;

	CMP	DX,2			; 結果 1=良い,2=悪い
	JE	KAIWA_KIBISHIKU_WARUI	; 悪い

KAIWA_KIBISHIKU_YOI:			;
	;　★　根性が疲労より高い場合（根性が１～１０上昇）
        PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@根性があがった"
	JMP	KAIWA_KIBISHIKU_EXIT	;
KAIWA_KIBISHIKU_WARUI:			;
	;　☆　疲労が根性より高い場合（疲労が１～１０上昇）
        PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
        PRINTX	"@＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@疲労が増した。"
	JMP	KAIWA_KIBISHIKU_EXIT	;
KAIWA_KIBISHIKU_HIKOU:			;
	;　＊　非行化していたら‥‥‥（パラメータ変化なし)
 	PRINTX	"@｢ちぇ‥‥‥｣"
	JMP	KAIWA_KIBISHIKU_EXIT	;
KAIWA_KIBISHIKU_EXIT:
	RET
KAIWA_KIBISHIKU	ENDP


; ****************************************************
;	説　教
; ****************************************************

KAIWA_SEKKYOU	PROC	NEAR
	CALL	TALK_SEKKYOU		; 説教するおれ
	CALL	S_WAIT			; 会話ＷＡＩＴ

	MOV	MY_TALK_MODE,3		; 会話モード 3=説教
	CALL	SEKKYO_KEISAN		; 説教計算

	TEST	MY_FLAGS,FLAGS_HIKOU	; 非行化
	JNZ	KAIWA_SEKKYOU_HIKOU	;

	CMP	DX,2			; 結果 1=良い,2=悪い
	JE	KAIWA_SEKKYOU_WARUI	; 悪い

KAIWA_SEKKYOU_YOI:			;
	;　☆　モラルが疲労より高ければ（モラル１～１０上昇）
        PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@モラルがあがった。"
	JMP	KAIWA_SEKKYOU_EXIT	;
KAIWA_SEKKYOU_WARUI:			;
	;　★　疲労がモラルより高いとき（モラル１～１０低下）
   PRINTX "@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@モラルがさがった。"
	CALL	KAIWA_POWER_SEKKYO	; さらに説教！
	JMP	KAIWA_SEKKYOU_EXIT	;
KAIWA_SEKKYOU_HIKOU:			;
	;　＊　非行化していたら・・・（パラメータ変化なし）
        PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	JMP	KAIWA_SEKKYOU_EXIT	;
KAIWA_SEKKYOU_EXIT:
	RET
KAIWA_SEKKYOU	ENDP


; ****************************************************
;	さらに説教！
; ****************************************************

KAIWA_POWER_SEKKYO	PROC	NEAR
	WSELECT	"このくらいにしておく,さらに説教する,せっかんする"
	CMP	WIDSNM,1			;
	JE	KAIWA_POWER_SEKKYO_SEKKYO	;
	CMP	WIDSNM,2			;
	JE	KAIWA_POWER_SEKKYO_SEKKAN	;
	JMP	KAIWA_POWER_SEKKYO_EXIT		;


KAIWA_POWER_SEKKYO_SEKKYO:			; さらに説教する

	; 自キャラがどんな状態でも同じ反応をしめします（モラル１～１０上昇）

	PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	CALL	S_WAIT				; 会話ＷＡＩＴ

	MOV	MY_TALK_MODE,4			; 会話モード 4=さらに説教
	CALL	SEKKYO_KEISAN			; 説教計算

	PRINTX	"@｢＊＊＊＊＊＊｣"
	PRINTX	"@モラルがあがった。"

	JMP	KAIWA_POWER_SEKKYO_EXIT		;


KAIWA_POWER_SEKKYO_SEKKAN:			; せっかんする

	PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	CALL	S_WAIT				; 会話ＷＡＩＴ

	MOV	MY_TALK_MODE,5			; 会話モード 5=せっかん
	CALL	SEKKYO_KEISAN			; 説教計算
	CMP	DX,2				; 結果 1=良い,2=悪い
	JE	KAIWA_POWER_SEKKYO_SEKK_2	; 悪い

KAIWA_POWER_SEKKYO_SEKK_1:
	;　☆　各能力（体力、腕力、知力、気品、根性、色気、モラル）
	; で色気が最も高いとき（色気１～１０上昇・モラル１０～２０低下）

	PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@色気があがった。"

	JMP	KAIWA_POWER_SARA_NEXT		; つづき

KAIWA_POWER_SEKKYO_SEKK_2:
	;　★　その他の場合（モラル１～１０低下）

	PRINTX	"@｢＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@モラルがさがった。"

	JMP	KAIWA_POWER_SARA_NEXT		; つづき

KAIWA_POWER_SARA_NEXT:
	WSELECT	"このくらいにしておく,さらにせっかんする"
	CMP	WIDSNM,1			;
	JE	KAIWA_POWER_SARA_SEKKAN		; さらにせっかん
	JMP	KAIWA_POWER_SEKKYO_EXIT		;

KAIWA_POWER_SARA_SEKKAN:			; さらにせっかん
	PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊｣"

	MOV	MY_TALK_MODE,6			; 会話モード 6=さらにせっかん
	CALL	SEKKYO_KEISAN			; 説教計算
	CMP	DX,2				; 結果 1=良い,2=悪い
	JE	KAIWA_POWER_SARA_2		; 悪い

KAIWA_POWER_SARA_1:
	;　☆　各能力（体力、腕力、知力、気品、根性、色気、モラル）で色気が最も		; 高いとき（色気１０～２０上昇・モラル１０～２０低下）

	PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@色気があがった。"

	JMP	KAIWA_POWER_SEKKYO_EXIT

KAIWA_POWER_SARA_2:
	;　★　その他の場合（根性１０～２０低下・モラル１～１０低下）

	PRINTX	"@｢＊＊＊＊＊＊＊＊＊＊＊＊＊｣"
	PRINTX	"@モラルと根性がさがった。"

	JMP	KAIWA_POWER_SEKKYO_EXIT


KAIWA_POWER_SEKKYO_EXIT:
	RET
KAIWA_POWER_SEKKYO	ENDP


; ****************************************************
;	やさしく話すおれ
;	｢やあ、○○○。お前はとても△△△子だなあ。お父さんは嬉しいよ。｣
;	-I- MY_ICHIBAN : 一番の能力
; ****************************************************

TALK_YASASHIKU	PROC	NEAR
	PRINTX	"｢やあ、"		;
	CALLC	R_SR_GIRL_NAME		; キャラクタ名
	PRINTX	"。お前はとても"	;
TEXT_IN
 TK_YASA_TBL DW TK_YS_0,TK_YS_1,TK_YS_2,TK_YS_3,TK_YS_4,TK_YS_5,TK_YS_6
 TK_YS_0 DB	"丈夫で強い",0		;体力
 TK_YS_1 DB	"強い",0		;腕力
 TK_YS_2 DB	"賢い",0		;知力
 TK_YS_3 DB	"上品な",0		;気品
 TK_YS_4 DB	"元気な",0		;根性
 TK_YS_5 DB	"魅力的な",0		;色気
 TK_YS_6 DB	"良い",0		;モラル
TEXT_OUT
	MOVX	ES,<SEG R_SEG3>			;
	MOV	BX,MY_ICHIBAN			; 一番の能力
	SHL	BX,1				; word pointer.
	MOVX	MESS_ADRS,ES:TK_YASA_TBL[BX]	; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示
	PRINTX	"子だなあ。お父さんは嬉しいよ｡｣"
	RET
TALK_YASASHIKU	ENDP


; ****************************************************
;	きびしく話すおれ
;	｢これ、○○○！しっかり努力せんといかんぞ｣
; ****************************************************

TALK_KIBISHIKU	PROC	NEAR
	PRINTX	"｢これ、"
	CALLC	R_SR_GIRL_NAME		; キャラクタ名
	PRINTX	"！しっかり努力せんといかんぞ｣"
	RET
TALK_KIBISHIKU	ENDP


; ****************************************************
;	説教するおれ
;	｢○○○！まったくお前という娘は△△△‥‥‥がみがみがみ｣
;	-I- MY_ICHIBAN : 一番の能力
; ****************************************************

TALK_SEKKYOU	PROC	NEAR
	PRINTX	"｢"
	CALLC	R_SR_GIRL_NAME		; キャラクタ名
	PRINTX	"！まったくお前という娘は"
TEXT_IN
 TK_SEKK_TBL DW TK_SE_0,TK_SE_1,TK_SE_2,TK_SE_3,TK_SE_4,TK_SE_5,TK_SE_6
 TK_SE_0 DB	"＊＊＊＊＊＊＊＊",0				;体力
 TK_SE_1 DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;腕力
 TK_SE_2 DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;知力
 TK_SE_3 DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;気品
 TK_SE_4 DB	"＊＊＊＊＊＊＊＊＊＊＊＊",0			;根性
 TK_SE_5 DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0		;色気
 TK_SE_6 DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0	;モラル
TEXT_OUT
	MOVX	ES,<SEG R_SEG3>			;
	MOV	BX,MY_ICHIBAN			; 一番の能力
	SHL	BX,1				; word pointer.
	MOVX	MESS_ADRS,ES:TK_SEKK_TBL[BX]	; メッセージアドレス
	CALL	MESSAGE_PRINT			; メッセージ表示
	PRINTX	"‥‥‥がみがみがみ｣"
	RET
TALK_SEKKYOU	ENDP


; ****************************************************
;	説教計算
;	-I- MY_TALK_MODE : 会話モード
;		1=やさしく話す,2=きびしく話す
;		3=説教,4=さらに説教,5=せっかん
;		6=さらにせっかん
;	-O- DX : 結果 1=良い,2=悪い
; ****************************************************

SEKKYO_KEISAN	PROC	NEAR
	MOV	CX,10				;
	CALLC	RANDAM_CX			; 乱数範囲指定
	MOV	CX,AX				; 乱数
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	DX,MY_TALK_MODE			; 会話モード
	MOV	S_FUNC,58			; 58=娘と話す計算
	CALLC	R_KEISAN			; 各計算処理
	RET
SEKKYO_KEISAN	ENDP

; ****************************************************
;	会話ＷＡＩＴ
; ****************************************************

S_WAIT	PROC	NEAR
	CALLC	TM_WAIT				; タイマ待ち
	RET
S_WAIT	ENDP


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

MY_TALK_MODE	DW	0		; 会話モード
					; 1=やさしく話す,2=きびしく話す
					; 3=説教,4=さらに説教,5=せっかん
					; 6=さらにせっかん

MY_FLAGS	DW	0		; ヘッダフラグ
MY_ICHIBAN	DW	0		; 一番の能力
					; 0=体力、1=腕力、2=知力、3=気品
					; 4=根性、5=色気、6=モラル

DATA	ENDS

	END
;
;	end of "R_KAIWA.ASM"
;
