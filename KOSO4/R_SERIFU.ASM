; "R_SERIFU.ASM" PC-9801UV11 make by R.H 1990/11/10
;
;
;	「子育て」
;
;	台詞処理
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO\WINDOW.INC

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

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_SR_GIRL_NAME		; キャラクタ名
PUBLIC	R_SR_GIRL_FNAME		; キャラクタ姓
PUBLIC	R_SR_GIRL_FULL_NAME	; キャラクタ名+姓
PUBLIC	R_SR_GIRL_SHOGO		; キャラクタの称号
PUBLIC	R_SR_GIRL_HELP		; キャラクタに対する説明

PUBLIC	R_SR_ITEM_NAME		; アイテム名
PUBLIC	R_SR_ITEM_HELP		; アイテムに対する説明
PUBLIC	R_SR_ITEM_PRICE		; アイテムに対する値段
PUBLIC	R_SR_ITEM_BUY		; アイテムに対する買取り値段

PUBLIC	R_SR_WORK_HELP		; 仕事に対する説明
PUBLIC	R_SR_WORK_PAY		; 仕事に対する収入

PUBLIC	R_SR_PRICE		; 通貨表示
PUBLIC	R_SR_IDSTR		; ＩＤ文字列表示
PUBLIC	R_SR_POINT		; ポイント表示
PUBLIC	R_SR_POINT_H		; ポイント半角表示
PUBLIC	R_SR_WIDSTR		; 文字列表示

PUBLIC	R_SR_DATE_NOW		; 本日の日付
PUBLIC	R_SR_DATE_USR		; ユーザの日付
PUBLIC	R_SR_DATE_OFF		; 休息日や祝日か？

PUBLIC	R_SR_BATLE_KEIKEN	; 経験値ｍを得た。
PUBLIC	R_SR_BATLE_OKANE	; お金ｍを得た。

PUBLIC	R_SR_SR_LF		; 改行
PUBLIC	R_SR_SR_DESU		; "です"
PUBLIC	R_SR_SR_POTU		; "・"
PUBLIC	R_SR_SR_PER		; "／"
PUBLIC	R_SR_SR_KAKO		; "「"
PUBLIC	R_SR_SR_KOKA		; "」"
PUBLIC	R_SR_SR_NITI		; "日間"
PUBLIC	R_SR_SR_WA		; "は"

PUBLIC	R_SR_GIRL_NAMEGET	; キャラクタ名ＧＥＴ
PUBLIC	R_SR_GIRL_F_NAMEGET	; キャラクタ姓ＧＥＴ
PUBLIC	R_SR_GIRL_FULNAMGET	; キャラクタ名+姓ＧＥＴ

PUBLIC	R_SR_GIRL_FUKU		; キャラクタ服名

PUBLIC	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
PUBLIC	R_SR_FACE_IYA_WAIT	; フェイスの嫌味ＷＡＩＴ
PUBLIC	R_SR_YOIDESUKA		; よいですか

PUBLIC	R_SR_TK_MESSAGE		; 敵意、好意のメッセージ
PUBLIC	R_SR_TOKU_MESSAGE	; 特徴のメッセージ
PUBLIC	R_SR_DOSURU		; "どうする？"
PUBLIC	R_SR_SL_NAME		; select○○○です
PUBLIC	R_SR_NAINAI		; "「なにもないよ、シクシク」"

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	WIDTXT_INIT:NEAR	; WINDOWS/テキストウインドウ初期処理
EXTRN	WIDTXT:NEAR		; WINDOWS/テキストウインドウ
EXTRN	WIDTXT_OPEN:NEAR	; WINDOWS/テキストウインドウＯＰＥＮ
EXTRN	WIDTXT_CLOSE:NEAR	; WINDOWS/テキストウインドウＣＬＯＳＥ
EXTRN	WIDTXT_RELOC:NEAR	; WINDOWS/テキストウインドウ位置変更

EXTRN	WID_UNIT:NEAR		; WINDOWS/単位別文字列化

EXTRN	WIDSLC2:NEAR		; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）

EXTRN	ADDSTRSET:NEAR		; 文字列の連結

EXTRN	STR_N_HNZN:NEAR		; 文字列半角を全角
EXTRN	STRZEROC:NEAR		; 文字列バッファ０クリア
EXTRN	STRSET:NEAR		; 文字列バッファセット
EXTRN	STRSETZ:NEAR		; 文字列バッファセット
EXTRN	STRLENSPZ:NEAR		; 文字列長さスペースまで


; ****************************************************
;	キャラクタ名
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
; ****************************************************

R_SR_GIRL_NAME	PROC	NEAR
	MOVX	ADRS_HOW,R_SR_CHR_ADRS	; 台詞・キャラクタアドレス

	CALL	STRCLEAR		; 文字列バッファクリア

	; ヘッダー

	MOV	BX,ADRS_HOW		; 人物
					; BX=ヘッダー

	; 名前

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_NAME]	; SI=名

	; 説明セット

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALL	STRSETZ			; 文字列バッファセット

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_GIRL_NAME	ENDP


; ****************************************************
;	キャラクタ姓
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
; ****************************************************

R_SR_GIRL_FNAME		PROC	NEAR
	CALL	STRZEROC		; 文字列バッファ０クリア
;*;	CALL	STRCLEAR		; 文字列バッファクリア

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALL	R_SR_GIRL_F_NAMEGET	; キャラクタ姓ＧＥＴ

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_GIRL_FNAME		ENDP


; ****************************************************
;	キャラクタ名+姓
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
; ****************************************************

R_SR_GIRL_FULL_NAME	PROC	NEAR
	CALL	STRZEROC		; 文字列バッファ０クリア
;*;	CALL	STRCLEAR		; 文字列バッファクリア

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALL	R_SR_GIRL_FULNAMGET	; キャラクタ名+姓ＧＥＴ

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_GIRL_FULL_NAME	ENDP



; ****************************************************
;	キャラクタの称号
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
; ****************************************************

R_SR_GIRL_SHOGO	PROC	NEAR
	MOVX	ADRS_HOW,R_SR_CHR_ADRS	; 台詞・キャラクタアドレス

	CALL	STRCLEAR		; 文字列バッファクリア

	; ヘッダー

	MOV	BX,ADRS_HOW		; 人物
					; BX=ヘッダー

	; 称号

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_SHOGO]	; SI=称号

	; 説明セット

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALL	STRSETZ			; 文字列バッファセット

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_GIRL_SHOGO	ENDP



; ****************************************************
;	キャラクタに対する説明
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
; ****************************************************

R_SR_GIRL_HELP	PROC	NEAR
	MOVX	ADRS_HOW,R_SR_CHR_ADRS	; 台詞・キャラクタアドレス

	CALL	STRCLEAR		; 文字列バッファクリア

	; ヘッダー

	MOV	BX,ADRS_HOW		; 人物
					; BX=ヘッダー

	; 説明

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_HELP]	; SI=説明

	; 説明セット

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALL	STRSETZ			; 文字列バッファセット

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_GIRL_HELP	ENDP


; ****************************************************
;	アイテム名
;	-I- R_SR_ITM_ADRS : 台詞・アイテムアドレス
; ****************************************************

R_SR_ITEM_NAME	PROC	NEAR
	MOVX	ADRS_ITEM,R_SR_ITM_ADRS	; 台詞・アイテムアドレス

	CALL	STRCLEAR		; 文字列バッファクリア

	; 説明

	MOV	BX,ADRS_ITEM		; アイテムアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][ITM_NAME]	; SI=ｱｲﾃﾑ名

	; 説明セット

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALL	STRSETZ			; 文字列バッファセット

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_ITEM_NAME	ENDP


; ****************************************************
;	アイテムに対する説明
;	-I- R_SR_ITM_ADRS : 台詞・アイテムアドレス
; ****************************************************

R_SR_ITEM_HELP	PROC	NEAR
	MOVX	ADRS_ITEM,R_SR_ITM_ADRS	; 台詞・アイテムアドレス

	CALL	STRCLEAR		; 文字列バッファクリア

	; 説明

	MOV	BX,ADRS_ITEM		; アイテムアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][ITM_HELP]	; SI=説明

	; 説明セット

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALL	STRSETZ			; 文字列バッファセット

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_ITEM_HELP	ENDP


; ****************************************************
;	アイテムに対する値段
;	-I- R_SR_ITM_ADRS : 台詞・アイテムアドレス
;	-O- DX : 金額
; ****************************************************

R_SR_ITEM_PRICE	PROC	NEAR
	MOVX	ADRS_ITEM,R_SR_ITM_ADRS	; 台詞・アイテムアドレス

	CALL	STRCLEAR		; 文字列バッファクリア

	; 値段

	MOV	BX,ADRS_ITEM		; アイテムアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DX,ES:[BX][ITM_PRICE]	; DX=値段

	CALL	R_SR_PRICE		; 通貨表示

	RET
R_SR_ITEM_PRICE	ENDP


; ****************************************************
;	アイテムに対する買取り値段
;	-I- R_SR_ITM_ADRS : 台詞・アイテムアドレス
;	-O- DX : 金額
; ****************************************************

R_SR_ITEM_BUY	PROC	NEAR
	MOVX	ADRS_ITEM,R_SR_ITM_ADRS	; 台詞・アイテムアドレス

	CALL	STRCLEAR		; 文字列バッファクリア

	; 値段

	MOV	DI,ADRS_ITEM		; アイテムアドレス
	MOV	S_FUNC,68		; 68=買取り価格
	CALL	R_KEISAN		; 各計算処理

	CALL	R_SR_PRICE		; 通貨表示

	RET
R_SR_ITEM_BUY	ENDP


; ****************************************************
;	仕事に対する説明
;	-I- R_SR_ITM_ADRS : 台詞・アイテムアドレス
; ****************************************************

R_SR_WORK_HELP	PROC	NEAR
	MOVX	ADRS_ITEM,R_SR_ITM_ADRS	; 台詞・アイテムアドレス

	CALL	STRCLEAR		; 文字列バッファクリア

	; 説明

	MOV	BX,ADRS_ITEM		; アイテムアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][WRK_HELP]	; SI=説明

	; 説明セット

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALL	STRSETZ			; 文字列バッファセット

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_WORK_HELP	ENDP



; ****************************************************
;	仕事に対する収入
;	-I- R_SR_ITM_ADRS : 台詞・アイテムアドレス
; ****************************************************

R_SR_WORK_PAY	PROC	NEAR
	MOVX	ADRS_ITEM,R_SR_ITM_ADRS	; 台詞・アイテムアドレス

	CALL	STRCLEAR		; 文字列バッファクリア

	; 値段

	MOV	BX,ADRS_ITEM		; アイテムアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	DX,ES:[BX][WRK_PAY]	; DX=収入

	CALL	R_SR_PRICE		; 通貨表示

	RET
R_SR_WORK_PAY	ENDP



; ****************************************************
;	通貨表示
;	-I- DX : 金額
; ****************************************************

R_SR_PRICE	PROC	NEAR
	PUSH	DX

	; 文字列化

	MOV	WDP_VAL,DX		; 内容表示値
	MOV	WDP_UNIT,UNIT_GOLD	; 単位系 通貨
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALL	WID_UNIT		; WINDOWS/単位別文字列化

	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファのアドレス
	CALL	STR_N_HNZN		; 文字列半角を全角

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	POP	DX
	RET
R_SR_PRICE	ENDP


; ****************************************************
;	ＩＤ文字列表示
;	-I- DX : ＩＤ
;	-O- WDTXTADR : 文字列アドレス
; ****************************************************

R_SR_IDSTR	PROC	NEAR
	MOV	ES,SEGWID		;
	MOV	DI,WIDOFS_ENVIR		; 環境テーブル
	MOV	BX,ES:[DI]		;
	SHL	DX,1			; word pointer.
	ADD	BX,DX			;

	MOVX	WDTXTADR,ES:[BX]	;
	MOVX	WDTXTSEG,SEGWID		; 内容表示セグメント

	; テキストウインドウへ

	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_IDSTR	ENDP


; ****************************************************
;	ポイント表示
;	-I- DX : ポイント
; ****************************************************

R_SR_POINT	PROC	NEAR

	; 文字列化

	MOV	WDP_VAL,DX		; 内容表示値
	MOV	WDP_UNIT,UNIT_NONE	; 単位系 無し
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALL	WID_UNIT		; WINDOWS/単位別文字列化

	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	INC	SI			;
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファのアドレス
	CALL	STR_N_HNZN		; 文字列半角を全角

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_POINT	ENDP


; ****************************************************
;	ポイント半角表示
;	-I- DX : ポイント
; ****************************************************

R_SR_POINT_H	PROC	NEAR

	; 文字列化

	MOV	WDP_VAL,DX		; 内容表示値
	MOV	WDP_UNIT,UNIT_NONE	; 単位系 無し
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALL	WID_UNIT		; WINDOWS/単位別文字列化

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_VAL_BUFF ; 表示文字列アドレス
	INC	WDTXTADR		;
	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_POINT_H	ENDP


; ****************************************************
;	文字列表示
;	-I- DX       : SEGWIDの文字列
;	-O- WDTXTADR : 文字列アドレス
; ****************************************************

R_SR_WIDSTR	PROC	NEAR
	MOV	WDTXTADR,DX		;
	MOVX	WDTXTSEG,SEGWID		; 内容表示セグメント

	; テキストウインドウへ

	CALL	WIDTXT			; テキストウインドウ

	RET
R_SR_WIDSTR	ENDP


; ****************************************************
;	本日の日付
; ****************************************************

R_SR_DATE_NOW	PROC	NEAR
;*;	MOV	DX,VAL_YEAR	; (now)年
;*;	CALL	R_SR_VAL	; 数値表示
;*;	MOV	DX,"年"		;
;*;	CALL	R_SR_KANJI	; １文字表示

	MOV	DX,VAL_MONTH	; (now)月
	CALL	R_SR_VAL	; 数値表示
	MOV	DX,"月"		;
	CALL	R_SR_KANJI	; １文字表示

	MOV	DX,VAL_DATE	; (now)日
	CALL	R_SR_VAL	; 数値表示
	MOV	DX,"日"		;
	CALL	R_SR_KANJI	; １文字表示

	MOV	DX,VAL_WEEK	; (now)曜日
	CALL	R_SR_YOUBI	; 曜日表示

	;	TM_SEASON		; (now)季節（1:春,2:夏,3:秋,4:冬）
	;	FLG_SHOGATSU		; (now)フラグ・正月
	;	FLG_URUBI		; (now)フラグ・うるう日
	;	FLG_CHRISTMAS_EVE 	; (now)フラグ・クリスマスイブ
	;	FLG_BORTH		; (now)フラグ・誕生日

	RET
R_SR_DATE_NOW	ENDP


; ****************************************************
;	ユーザの日付
; ****************************************************

R_SR_DATE_USR	PROC	NEAR
	MOV	DX,UCK_YEAR	; (user)年
	CALL	R_SR_VAL	; 数値表示
	MOV	DX,"年"		;
	CALL	R_SR_KANJI	; １文字表示

	MOV	DX,UCK_MONTH	; (user)月
	CALL	R_SR_VAL	; 数値表示
	MOV	DX,"月"		;
	CALL	R_SR_KANJI	; １文字表示

	MOV	DX,UCK_DATE	; (user)日
	CALL	R_SR_VAL	; 数値表示
	MOV	DX,"日"		;
	CALL	R_SR_KANJI	; １文字表示

	MOV	DX,UCK_WEEK	; (user)曜日
	CALL	R_SR_YOUBI	; 曜日表示

	RET
R_SR_DATE_USR	ENDP


; ****************************************************
;	休息日や祝日か？
;	-O- AX : 0=休みではない,1=休み
; ****************************************************

R_SR_DATE_OFF	PROC	NEAR
;*err*;	CMP	FLG_HOLIDAY,0		; (now)フラグ・休日
;*err*;	JE	R_SR_DATE_OFF_SUN	;
	CMP	VAL_WEEK,0		; (now)曜日 0=（日）Sunday
	JNE	R_SR_DATE_OFF_SUN	;
	PR_TXT	"@きょうは日曜日でした。"
R_SR_DATE_OFF_SUN:
	CMP	FLG_SHOGATSU,1		; (now)フラグ・正月
	JE	R_SR_DATE_OFF_SHOGATSU	;
	CMP	FLG_URUBI,1		; (now)フラグ・うるう日
	JE	R_SR_DATE_OFF_URUBI	;
	CMP	FLG_CHRISTMAS_EVE,1	; (now)フラグ・クリスマスイブ
	JE	R_SR_DATE_OFF_CHRISTMAS_EVE
	CMP	FLG_BORTH,1		; (now)フラグ・誕生日
	JE	R_SR_DATE_OFF_BORTH	;

	JMP	R_SR_DATE_OFF_EXIT	;

R_SR_DATE_OFF_SHOGATSU:			; (now)フラグ・正月
	PR_TXT	"@正月がきました"
	JMP	R_SR_DATE_OFF_EXIT	;

R_SR_DATE_OFF_URUBI:			; (now)フラグ・うるう日
	PR_TXT	"うるう日"
	JMP	R_SR_DATE_OFF_EXIT	;

R_SR_DATE_OFF_CHRISTMAS_EVE:		; (now)フラグ・クリスマスイブ
	PR_TXT	"@クリスマス・イブ"
	JMP	R_SR_DATE_OFF_EXIT	;

R_SR_DATE_OFF_BORTH:			; (now)フラグ・誕生日
	PR_TXT	"誕生日"
	JMP	R_SR_DATE_OFF_EXIT	;

R_SR_DATE_OFF_EXIT:			;
	MOV	AX,FLG_HOLIDAY		; 休息日フラグ
	RET
R_SR_DATE_OFF	ENDP


; ****************************************************
;	経験値ｍを得た。
;	-I- DX : ポイント
; ****************************************************

R_SR_BATLE_KEIKEN	PROC	NEAR
	PUSH	DX
	PR_TXT	"経験値"
	POP	DX
	CALL	R_SR_POINT		; ポイント表示
	PR_TXT	"を得た。"
	RET
R_SR_BATLE_KEIKEN	ENDP


; ****************************************************
;	お金ｍを得た。
;	-I- DX : 金額
; ****************************************************

R_SR_BATLE_OKANE	PROC	NEAR
	CALL	R_SR_PRICE		; 通貨表示
	PR_TXT	"を得た。"
	RET
R_SR_BATLE_OKANE	ENDP


; ****************************************************
;	改行
; ****************************************************

R_SR_SR_LF	PROC	NEAR
	MOV	DL,0		;
	MOV	DH,'@'		;
	CALL	R_SR_KANJI	; １文字表示
	RET
R_SR_SR_LF	ENDP



; ****************************************************
;	"です"
; ****************************************************

R_SR_SR_DESU	PROC	NEAR
	MOV	WDTXTADR,OFFSET MSG_DESU	; "です"
	MOV	WDTXTSEG,SEG DATA		;
	CALL	WIDTXT				; テキストウインドウ
	RET
R_SR_SR_DESU	ENDP

; ****************************************************
;	"・"
; ****************************************************

R_SR_SR_POTU	PROC	NEAR
	MOV	DH,"･"		;
	MOV	DL,0		;
	CALL	R_SR_KANJI	; １文字表示
	RET
R_SR_SR_POTU	ENDP

; ****************************************************
;	"／"
; ****************************************************

R_SR_SR_PER	PROC	NEAR
	MOV	DH,"/"		;
	MOV	DL,0		;
	CALL	R_SR_KANJI	; １文字表示
	RET
R_SR_SR_PER	ENDP

; ****************************************************
;	"「"
; ****************************************************

R_SR_SR_KAKO	PROC	NEAR
	MOV	DH,"｢"		;
	MOV	DL,0		;
	CALL	R_SR_KANJI	; １文字表示
	RET
R_SR_SR_KAKO	ENDP

; ****************************************************
;	"」"
; ****************************************************

R_SR_SR_KOKA	PROC	NEAR
	MOV	DX,"」"		;
	CALL	R_SR_KANJI	; １文字表示
	RET
R_SR_SR_KOKA	ENDP

; ****************************************************
;	"日間"
; ****************************************************

R_SR_SR_NITI	PROC	NEAR
	MOV	WDTXTADR,OFFSET MSG_NITI	; "日間"
	MOV	WDTXTSEG,SEG DATA		;
	CALL	WIDTXT				; テキストウインドウ
	RET
R_SR_SR_NITI	ENDP

; ****************************************************
;	"は"
; ****************************************************

R_SR_SR_WA	PROC	NEAR
	MOV	DX,"は"		;
	CALL	R_SR_KANJI	; １文字表示
	RET
R_SR_SR_WA	ENDP


; ****************************************************
;	キャラクタ名ＧＥＴ
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
;	    DS:[DI] : セットするべき領域
;	    CX      : 名前長さ
; ****************************************************

R_SR_GIRL_NAMEGET	PROC	NEAR
	MOV	BX,R_SR_CHR_ADRS	; 台詞・キャラクタアドレス

	; 名前

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_NAME]	; SI=名

	; セット

;*;	CALL	STRSETZ			; 文字列バッファセット
	CALL	STRSET			; 文字列バッファセット

	RET
R_SR_GIRL_NAMEGET	ENDP


; ****************************************************
;	キャラクタ姓ＧＥＴ
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
;	    DS:[DI] : セットするべき領域
;	    CX      : 名前長さ
; ****************************************************

R_SR_GIRL_F_NAMEGET	PROC	NEAR
	MOV	BX,R_SR_CHR_ADRS	; 台詞・キャラクタアドレス

	; 名前

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_FNAME]	; SI=姓

	; セット

;*;	CALL	STRSETZ			; 文字列バッファセット
	CALL	STRSET			; 文字列バッファセット

	RET
R_SR_GIRL_F_NAMEGET	ENDP


; ****************************************************
;	キャラクタ名+姓ＧＥＴ
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
;	    DS:[DI] : セットするべき領域
;	    CX      : 名前長さ
; ****************************************************

R_SR_GIRL_FULNAMGET	PROC	NEAR
	MOV	USER_LENGTH,CX		; ユーザ文字長さ

	PUSH	DI
	MOV	BX,R_SR_CHR_ADRS	; 台詞・キャラクタアドレス
	; 名前
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_NAME]	; SI=名
	; セット
	CALL	STRSETZ			; 文字列バッファセット
	POP	DI

	PUSH	DI
	MOVX	ES,DS			;
	CALL	STRLENSPZ		; 文字列長さスペースまで
	POP	DI

	SUB	USER_LENGTH,CX		; ユーザ文字長さ

	ADD	DI,CX			; 表示単語長さ
	MOV	AX,WORD PTR MSG_TEN	; "・"
	MOV	DS:[DI],AX		; "・"
	ADD	DI,2

	SUB	USER_LENGTH,2		; ユーザ文字長さ

	MOV	CX,USER_LENGTH		; ユーザ文字長さ

	PUSH	DI			; セットするべき領域
	CALL	R_SR_GIRL_F_NAMEGET	; キャラクタ姓ＧＥＴ
	POP	DI			;

	CMP	BYTE PTR DS:[DI],0	;
	JNE	R_SR_GIRL_FULNAMGET_8	;
	DEC	DI
	DEC	DI
	MOV	WORD PTR DS:[DI],0	; "・"を消す
	DEC	CX
	DEC	CX
R_SR_GIRL_FULNAMGET_8:

	RET
R_SR_GIRL_FULNAMGET	ENDP


; ****************************************************
;	キャラクタ服名
; ****************************************************

R_SR_GIRL_FUKU	PROC	NEAR
	CMPX	WIDCHAR_DRESS,DRESS_NAME_MAX	; オーバ？（ありえないはず）
	JNB	R_SR_GIRL_FUKU_EXIT		;

	MOV	BX,WIDCHAR_DRESS		; 自分の娘の着ている服
	SHL	BX,1				; word pointer.
	MOVX	WDTXTADR,DS:DRESS_NAME[BX]	; 表示文字列アドレス
	MOV	WDTXTSEG,SEG DATA		;
	CALL	WIDTXT				; テキストウインドウ
R_SR_GIRL_FUKU_EXIT:
	RET
R_SR_GIRL_FUKU	ENDP


; ****************************************************
;	フェイスのＷＡＩＴ
; ****************************************************

R_SR_FACE_WAIT	PROC	NEAR
	SELECT	"はい"
	RET
R_SR_FACE_WAIT	ENDP


; ****************************************************
;	フェイスの嫌味ＷＡＩＴ
; ****************************************************

R_SR_FACE_IYA_WAIT	PROC	NEAR
	SELECT	"・・・・"
	RET
R_SR_FACE_IYA_WAIT	ENDP


; ****************************************************
;	よいですか
; ****************************************************

R_SR_YOIDESUKA	PROC	NEAR
	SELECT	"よいですか"
	RET
R_SR_YOIDESUKA	ENDP


; ****************************************************
;	敵意、好意のメッセージ
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
;	    AX            : 1=敵意,2=好意
; ****************************************************

R_SR_TK_MESSAGE		PROC	NEAR
	MOV	BX,R_SR_CHR_ADRS	; 台詞・キャラクタアドレス
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,ES:[BX][HED_LST_MS]	; SI=メッセージリスト

	CMP	AX,1			; 1=敵意
	JE	R_SR_TK_MESSAGE_TEKII	;
	CMP	AX,2			; 2=好意
	JE	R_SR_TK_MESSAGE_KOUI	;
	JMP	R_SR_TK_MESSAGE_EXIT
R_SR_TK_MESSAGE_TEKII:
	MOV	BX,ES:[SI][0]		; 1.敵意のメッセージ
	JMP	R_SR_TK_MESSAGE_PRINT	;
R_SR_TK_MESSAGE_KOUI:
	MOV	BX,ES:[SI][2]		; 2.好意のメッセージ
	JMP	R_SR_TK_MESSAGE_PRINT	;
R_SR_TK_MESSAGE_PRINT:
	MOV	WDTXTSEG,ES		; 表示文字列セグメント
	MOV	WDTXTADR,BX		; 表示文字列アドレス
	CALL	TKRSET			; 台詞改行のカウンタリセット
	CALL	WIDTXT			; テキストウインドウ
R_SR_TK_MESSAGE_EXIT:
	RET
R_SR_TK_MESSAGE		ENDP


; ****************************************************
;	特徴のメッセージ
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
; ****************************************************

R_SR_TOKU_MESSAGE	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,R_SR_CHR_ADRS	; 台詞・キャラクタアドレス
	MOV	SI,ES:[BX][HED_HELP]	; 説明

	MOV	WDTXTSEG,ES		; 表示文字列セグメント
	MOV	WDTXTADR,SI		; 表示文字列アドレス

	CALL	TKRSET			; 台詞改行のカウンタリセット
	CALL	WIDTXT			; テキストウインドウ

	CALL	R_SR_SR_POTU		; "・"

	CALL	R_SR_GIRL_FULL_NAME	; キャラクタ名+姓
	RET
R_SR_TOKU_MESSAGE	ENDP


; ****************************************************
;	"どうする？"
; ****************************************************

R_SR_DOSURU	PROC	NEAR
	MOV	WDTXTADR,OFFSET MSG_DOSURU	; "どうする？"
	MOV	WDTXTSEG,SEG DATA		;
	CALL	WIDTXT				; テキストウインドウ
	RET
R_SR_DOSURU	ENDP


; ****************************************************
;	"○○○です"
;	-I- R_SR_CHR_ADRS : 台詞・キャラクタアドレス
; ****************************************************

R_SR_SL_NAME	PROC	NEAR
	CALL	STRZEROC		; 文字列バッファ０クリア

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; バッファ最大長さ
	CALL	R_SR_GIRL_NAMEGET	; キャラクタ名ＧＥＴ

	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	SI,OFFSET MSG_DESU	; "です。" 連結する文字列
	CALL	ADDSTRSET		; 文字列の連結

	MOVX	ES,DS			;
	MOV	BX,OFFSET STR_BUFF	; 文字列バッファ
	CALL	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	RET
R_SR_SL_NAME	ENDP


; ****************************************************
;	"「なにもないよ、シクシク」"
; ****************************************************

R_SR_NAINAI	PROC	NEAR
	SELECT	"「＊＊＊＊＊＊＊＊＊＊＊」"
	RET
R_SR_NAINAI	ENDP


; ****************************************************
;	数値表示
;	-I- DX : 数値
; ****************************************************

R_SR_VAL	PROC	NEAR

	; 文字列化

	MOV	WDP_VAL,DX		; 内容表示値
	MOV	WDP_UNIT,UNIT_NONE	; 単位系 無し
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALL	WID_UNIT		; WINDOWS/単位別文字列化

	; テキストウインドウへ

	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_VAL_BUFF ; 表示文字列アドレス
	INC	WDTXTADR		;
	CALL	WIDTXT			; テキストウインドウ

;*;
;*;	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;	INC	SI			; ＋１
;*;	MOV	DI,OFFSET STR_BUFF	; 文字列バッファのアドレス
;*;	CALL	STR_N_HNZN		; 文字列半角を全角
;*;
;*;	; テキストウインドウへ
;*;
;*;	MOV	WDTXTSEG,SEG DATA	;
;*;	MOV	WDTXTADR,OFFSET STR_BUFF ; 表示文字列アドレス
;*;	CALL	WIDTXT			; テキストウインドウ
;*;
	RET
R_SR_VAL	ENDP


; ****************************************************
;	１文字表示
;	-I- DX : ＪＩＳ漢字
; ****************************************************

R_SR_KANJI	PROC	NEAR
	MOV	STR_KANJI[0],DH		; 表示文字列アドレス
	MOV	STR_KANJI[1],DL		; 表示文字列アドレス
	MOV	WDTXTSEG,SEG DATA	;
	MOV	WDTXTADR,OFFSET STR_KANJI ; 表示文字列アドレス
	CALL	WIDTXT			; テキストウインドウ
	RET
R_SR_KANJI	ENDP


; ****************************************************
;	曜日表示
;	-I- DX : 曜日
; ****************************************************

R_SR_YOUBI	PROC	NEAR
	MOV	BX,DX			; 曜日
	SHL	BX,1			; word pointer.
	MOVX	WDTXTADR,DS:NAME_WEEK[BX] ; 曜日
	MOV	WDTXTSEG,SEG DATA	;
	CALL	WIDTXT			; テキストウインドウ
	RET
R_SR_YOUBI	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	R_SR_CHR_ADRS		; 台詞・キャラクタアドレス
PUBLIC	R_SR_ITM_ADRS		; 台詞・アイテムアドレス

EXTRN	S_FUNC:WORD		; 計算ファンクション

EXTRN	NOW_DATE:BYTE		; (now)現在時間
EXTRN	VAL_YEAR:WORD		; (now)年
EXTRN	VAL_MONTH:WORD		; (now)月
EXTRN	VAL_WEEK:WORD		; (now)曜日
EXTRN	VAL_DATE:WORD		; (now)日
EXTRN	VAL_A_DATE:WORD		; (now)年内合計日付
EXTRN	TM_SEASON:WORD		; (now)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	FLG_SHOGATSU:WORD	; (now)フラグ・正月
EXTRN	FLG_URUBI:WORD		; (now)フラグ・うるう日
EXTRN	FLG_CHRISTMAS_EVE:WORD 	; (now)フラグ・クリスマスイブ
EXTRN	FLG_BORTH:WORD		; (now)フラグ・誕生日
EXTRN	FLG_HOLIDAY:WORD	; (now)フラグ・休日

EXTRN	USR_DATE:BYTE		; (user)現在時間退避
EXTRN	UCK_YEAR:WORD		; (user)年
EXTRN	UCK_MONTH:WORD		; (user)月
EXTRN	UCK_WEEK:WORD		; (user)曜日
EXTRN	UCK_DATE:WORD		; (user)日
EXTRN	UCK_A_DATE:WORD		; (user)年内合計日付
EXTRN	UCK_SEASON:WORD		; (user)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	UCK_SHOGATSU:WORD	; (user)フラグ・正月
EXTRN	UCK_URUBI:WORD		; (user)フラグ・うるう日
EXTRN	UCK_CHRISTMAS_EVE:WORD	; (user)フラグ・クリスマスイブ
EXTRN	UCK_BORTH:WORD		; (user)フラグ・誕生日
EXTRN	UCK_HOLIDAY:WORD	; (user)フラグ・休日

USER_LENGTH	DW	0	; ユーザ文字長さ

R_SR_CHR_ADRS	DW	0	; 台詞・キャラクタアドレス
R_SR_ITM_ADRS	DW	0	; 台詞・アイテムアドレス

ADRS_HOW	DW	0	; 人物
ADRS_ITEM	DW	0	; アイテム

VAL_ATTR	DW	0	; 種別
VAL_RECNO	DW	0	; レコードＮＯ

STR_KANJI	DB	0,0,0,0	; ＪＩＳ漢字

NAME_WEEK	LABEL	WORD
	DW	NAME_W_1
	DW	NAME_W_2
	DW	NAME_W_3
	DW	NAME_W_4
	DW	NAME_W_5
	DW	NAME_W_6
	DW	NAME_W_7
NAME_W_1	DB	"(日)",0	;Sunday
NAME_W_2	DB	"(月)",0	;Monday
NAME_W_3	DB	"(火)",0	;Tuesday
NAME_W_4	DB	"(水)",0	;Wednesday
NAME_W_5	DB	"(木)",0	;Thursday
NAME_W_6	DB	"(金)",0	;Friday
NAME_W_7	DB	"(土)",0	;Saturday

DRESS_NAME_MAX	DW	5
DRESS_NAME	LABEL	WORD
	DW	DRESS_N_0
	DW	DRESS_N_1
	DW	DRESS_N_2
	DW	DRESS_N_3
	DW	DRESS_N_4
DRESS_N_0	DB	"はだか",0
DRESS_N_1	DB	"春服",0
DRESS_N_2	DB	"夏服",0
DRESS_N_3	DB	"秋服",0
DRESS_N_4	DB	"冬服",0

MSG_DESU	DB	"です。",0
MSG_NITI	DB	"日間",0
MSG_TEN		DB	"・",0
MSG_DOSURU	DB	"@どうする？",0

DATA	ENDS

	END
;
;	end of "R_SERIFU.ASM"
;
