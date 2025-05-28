; "R_KYUSOK.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	休息
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC

;*;CCT_OPEN_TYPE	EQU	4	; オープンタイプ
;*;NISSU_KYUSOK		EQU	10	; 日数・休息

MOVX	MACRO	DEST,SOUR
	MOV	AX,WORD PTR SOUR
	MOV	WORD PTR DEST,AX
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

DIVX	MACRO	RRR
	LOCAL	LL
	CMP	RRR,0
	JE	LL
	DIV	RRR
LL:
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_KYUSOK_SET			; 休息セット
PUBLIC	R_KYUSOK_SRT			; 休息スタート
PUBLIC	R_KYUSOK_RUN			; 休息実行
PUBLIC	R_KYUSOK_UPD			; 休息決算

EXTRN	R_KEISAN:NEAR			; 各計算処理

EXTRN	R_WORK_SCH:NEAR			; 行い条件検索
EXTRN	R_GET_SELECT:NEAR		; ｱｲﾃﾑレコード内から選択単語を取り出す

EXTRN	R_MS_KYUSOKU:NEAR		; 休息時メッセージ

EXTRN	WIDSLC_INIT:NEAR		; WINDOWS/セレクト・ウインドウ初期処理
EXTRN	WIDSLC:NEAR			; WINDOWS/セレクト・ウインドウ

EXTRN	WIDEVNT_INIT:NEAR		; WINDOWS/イベントウインドウ初期処理
EXTRN	WIDEVNT_OPEN:NEAR		; WINDOWS/イベントウインドウＯＰＥＮ
EXTRN	WIDEVNT_CLOSE:NEAR		; WINDOWS/イベントウインドウＣＬＯＳＥ
EXTRN	WIDEVNT_OPEN_W:NEAR		; WINDOWS/行いイベントＯＰＥＮ
EXTRN	WIDEVNT_CLOSE_W:NEAR		; WINDOWS/行いイベントＣＬＯＳＥ

EXTRN	R_SR_PRICE:NEAR			; 通貨表示
EXTRN	R_SR_IDSTR:NEAR			; ＩＤ文字列表示
EXTRN	R_SR_POINT:NEAR			; ポイント表示
EXTRN	R_SR_WIDSTR:NEAR		; 文字列表示

EXTRN	R_SR_DATE_NOW:NEAR		; 本日の日付
EXTRN	R_SR_DATE_USR:NEAR		; ユーザの日付

EXTRN	R_SR_SR_LF:NEAR			; 改行
EXTRN	R_SR_SR_DESU:NEAR		; "です"
EXTRN	R_SR_SR_POTU:NEAR		; "・"
EXTRN	R_SR_SR_KAKO:NEAR		; "「"
EXTRN	R_SR_SR_KOKA:NEAR		; "」"
EXTRN	R_SR_SR_NITI:NEAR		; "日間"

;*;EXTRN	WIDDSP_SAVE:NEAR	; WINDOWS/画面退避
;*;EXTRN	WIDDSP_LOAD:NEAR	; WINDOWS/画面復元
;*;
;*;EXTRN	WIDCCT_INIT:NEAR	; WINDOWS/キャラクタ初期処理
;*;EXTRN	WIDCCT_OPEN:NEAR	; WINDOWS/キャラクタオープン
;*;EXTRN	WIDCCT_CLOSE:NEAR	; WINDOWS/キャラクタクローズ
;*;EXTRN	WIDCCT_CHANGE:NEAR	; WINDOWS/キャラクタチェンジ

EXTRN	TM_WAIT:NEAR		; タイマ待ち

; ****************************************************
;	休息
;	-I- R_NISSU  : 日数
;	-O- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    KETTEI   : 0=決定,1=考え直す
; ****************************************************

R_KYUSOK_SET	PROC	NEAR
	MOV	R_KOUMKU,ID_69		; 休息

;*;	MOV	R_NISSU,NISSU_KYUSOK	; 日数・休息

	PR_TXT	"@休息、"
;*;	MOV	DX,R_NISSU		; 日数・アルバイト
;*;	CALL	R_SR_POINT		; ポイント表示
;*;	CALL	R_SR_SR_NITI		; "日間"
;*;	CALL	R_SR_SR_POTU		; "・"
;*;	MOV	DX,ID_15		; 疲労
;*;	CALL	R_SR_IDSTR		; ＩＤ文字列表示


	WD_ADRS	ID_00,R_NAISTR		; 無効
	MOV	R_NAIYOU,0		;
	MOV	R_NYUKIN,0		;
	MOVX	R_SYUTSU,0		;


	CALL	SELECT_DATS		; 日数の決定


	MOV	AX,ZENKAI_GOLD		; 全回復の金額
	MOV	DX,0			;
	MOV	BX,R_NISSU		; ／日数
	DIVX	BX			;
	CMP	DX,0			; あまりは？
	JE	R_KYUSOK_SET_5		;
	INC	AX			;
R_KYUSOK_SET_5:
	MOV	ZENKAI_DIV,AX		; 全回復の金額分割

	MOVX	R_SYUTSU,ZENKAI_GOLD	; 全回復の金額

;*;	MOV	DX,R_SYUTSU		; 出金
;*;	CALL	R_SR_PRICE		; 通貨表示


;*STP*;	SELECT	"決めた,べつのにしよう"
;*STP*;	CMP	WIDSNM,0		; ユーザ選択番号
;*STP*;	JNE	R_KYUSOK_SET_YAMERU	;

	MOV	KETTEI,0		; 0=決定
	RET
;*STP*;R_KYUSOK_SET_YAMERU:
;*STP*;	PR_TXT	"@いらないかな・・・"
;*STP*;	MOV	KETTEI,1		; 1=考え直す
;*STP*;	RET
R_KYUSOK_SET	ENDP



; ****************************************************
;	日数の決定
;	-I-   R_NISSU     : 日数
;	-O-   ZENKAI_GOLD : 全回復の金額
;	      HIROU_POINT : 疲労ポイント
;	      ZENKAI_FLAG : 全回復フラグ1=全快,2=金なし,0=疲労残
;	      ZENKAI_DIV  : 全回復の金額分割
; ****************************************************

SELECT_DATS	PROC	NEAR
	MOV	AX,R_NISSU		; 日数
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	S_FUNC,4		; 4=休息最高予算
	CALL	R_KEISAN		; 各計算処理

	MOV	ZENKAI_GOLD,AX		; 全回復の金額
	MOV	HIROU_POINT,DX		; 疲労ポイント

	PR_TXT	"おこづかい"
	MOV	DX,ZENKAI_GOLD		; 全回復の金額
	CALL	R_SR_PRICE		; 通貨表示
	PR_TXT	"が必要です"

	MOV	ZENKAI_FLAG,0		; 全回復フラグ 0=疲労残
	RET
SELECT_DATS	ENDP


; ****************************************************
;	休息スタート
;	-I- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列（アドレス）
;	    R_NAIYOU : 内容値
;	-I/O- R_NYUKIN : 入金
;	      R_SYUTSU : 出金
;	      R_NISSU  : 日数
;	-O- ZENKAI_DIV  : 全回復の金額分割
;	    ZENKAI_GOLD : 全回復の金額
;	    ZENKAI_FLAG : 全回復フラグ1=全快,2=金なし,0=疲労残
; ****************************************************

R_KYUSOK_SRT	PROC	NEAR
	MOV	AX,1			; 1=開始
	CALL	R_MS_KYUSOKU		; 休息時メッセージ

	MOV	AX,R_NISSU		; 日数
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	S_FUNC,4		; 4=休息最高予算
	CALL	R_KEISAN		; 各計算処理

	MOV	ZENKAI_GOLD,AX		; 全回復の金額
	MOV	HIROU_POINT,DX		; 疲労ポイント

	MOV	AX,ZENKAI_GOLD		; 全回復の金額
	MOV	DX,0			;
	MOV	BX,R_NISSU		; ／日数
	DIVX	BX			;
	CMP	DX,0			; あまりは？
	JE	R_KYUSOK_SRT_3		;
	INC	AX			;
R_KYUSOK_SRT_3:
	MOV	ZENKAI_DIV,AX		; 全回復の金額分割

	MOVX	R_SYUTSU,ZENKAI_GOLD	; 全回復の金額

	CMP	ZENKAI_GOLD,0		; 全回復の金額
	JNE	R_KYUSOK_SRT_7		;
	PR_TXT	"@疲労無しです。"
	MOV	ZENKAI_FLAG,0		; 全回復フラグ1=全快,0=疲労残
	JMP	R_KYUSOK_SRT_8		;
R_KYUSOK_SRT_7:				;
	PR_LF
	MOV	DX,ZENKAI_GOLD		; 全回復の金額
	CALL	R_SR_PRICE		; 通貨表示
	PR_TXT	"で全部回復です。"
R_KYUSOK_SRT_8:
	MOV	DX,9			; 9=休息
	CALL	WIDEVNT_OPEN		; WINDOWS/イベントウインドウＯＰＥＮ
	RET
R_KYUSOK_SRT	ENDP


; ****************************************************
;	休息実行
;	-I/O- ZENKAI_DIV  : 全回復の金額分割
;	      ZENKAI_GOLD : 全回復の金額
;	      ZENKAI_FLAG : 全回復フラグ1=全快,2=金なし,0=疲労残
;	      SCED_FREE_FLAG : 1=スケジュール流れた
; ****************************************************

R_KYUSOK_RUN	PROC	NEAR
	CMP	ZENKAI_FLAG,0		; 全回復フラグ1=全快,0=疲労残
	JNE	R_KYUSOK_RUN_EXIT	;

;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;
;*;	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	CMPX	ZENKAI_GOLD,ZENKAI_DIV	; 全回復の金額分割
	JNB	R_KYUSOK_RUN_3		;
	MOVX	ZENKAI_DIV,ZENKAI_GOLD	; 全回復の金額分割
R_KYUSOK_RUN_3:
	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,R_KOUMKU		; 項目
	CALL	R_SR_IDSTR		; ＩＤ文字列表示
	CALL	R_SR_SR_KOKA		; "」"

	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	AX,ZENKAI_DIV		; 全回復の金額分割
	MOV	S_FUNC,5		; 5=休息パラメータ計算
	CALL	R_KEISAN		; 各計算処理

	MOV	ZENKAI_FLAG,AX		; 全回復フラグ1=全快,2=金なし,0=疲労残

;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
;*;
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元

	CMP	ZENKAI_FLAG,2		; 全回復フラグ1=全快,2=金なし,0=疲労残
	JE	R_KYUSOK_RUN_NO_MONEY	;

	SUBX	ZENKAI_GOLD,ZENKAI_DIV	; 全回復の金額分割

	JMP	R_KYUSOK_RUN_EXIT	;

R_KYUSOK_RUN_NO_MONEY:			;
	SUBX	R_SYUTSU,ZENKAI_DIV	; 全回復の金額分割
	MOV	SCED_FREE_FLAG,1	; 1=スケジュール流れた
	PR_TXT	"@お金がたりない！？"
R_KYUSOK_RUN_EXIT:
	RET
R_KYUSOK_RUN	ENDP


; ****************************************************
;	休息決算
; ****************************************************

R_KYUSOK_UPD	PROC	NEAR
	MOV	AX,2			; 2=終了
	CALL	R_MS_KYUSOKU		; 休息時メッセージ
	CALL	WIDEVNT_CLOSE		; WINDOWS/イベントウインドウＣＬＯＳＥ
	RET
R_KYUSOK_UPD	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	WIDSNM:WORD			; ユーザ選択番号

EXTRN	R_KOUMKU:WORD			; 項目
EXTRN	R_NAISTR:WORD			; 内容文字列
EXTRN	R_NAIYOU:WORD			; 内容値
EXTRN	R_NYUKIN:WORD			; 入金
EXTRN	R_SYUTSU:WORD			; 出金
EXTRN	R_NISSU:WORD			; 日数

EXTRN	KETTEI:WORD			; 決定フラグ

EXTRN	SCED_FREE_FLAG:WORD		; スケジュール流れたフラグ

EXTRN	R_SR_CHR_ADRS:WORD	; 台詞・キャラクタアドレス
EXTRN	R_SR_ITM_ADRS:WORD	; 台詞・アイテムアドレス

EXTRN	S_FUNC:WORD		; 計算ファンクション

EXTRN	K_TBL_REC:WORD		; 検索レコードテーブル
EXTRN	K_TBL_OFSET:WORD	; 検索レコードｵﾌｾｯﾄテーブル
EXTRN	K_TBL_ATR:WORD		; 検索レコード種別テーブル
EXTRN	K_TBL_MAX:WORD		; 検索レコード数
EXTRN	K_TBL_DIM:WORD		; 検索レコードテーブルサイズ

EXTRN	ATMSEG:WORD		; WINDOWS/テキストバッファセグメント
EXTRN	ATMTBL:WORD		; WINDOWS/表示単語アドレス
EXTRN	ATMMAX:WORD		; WINDOWS/表示単語の数
EXTRN	ATMDIM:WORD	 	; WINDOWS/表示単語のテーブルサイズ

ZENKAI_GOLD	DW	0	; 全回復の金額
HIROU_POINT	DW	0	; 疲労ポイント

ZENKAI_DIV	DW	0	; 全回復の金額分割

ZENKAI_FLAG	DW	0	; 全回復フラグ1=全快,2=金なし,0=疲労残

DATA	ENDS

	END
;
;	end of "R_KYUSOK.ASM"
;
