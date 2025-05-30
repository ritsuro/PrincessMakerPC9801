; "R_REIHOU.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	礼法
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

;*;CCT_OPEN_TYPE	EQU	4	; オープンタイプ
;*;NISSU_REIHOU		EQU	10	; 日数・礼法

PRICE_REIHOU	EQU	10	; 礼法値段

UP_KIHIN	EQU	5	; 上昇する気品
UP_HIROU	EQU	5	; 上昇する疲労


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

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_REIHOU_SET			; 礼法セット
PUBLIC	R_REIHOU_SRT			; 礼法スタート
PUBLIC	R_REIHOU_RUN			; 礼法実行
PUBLIC	R_REIHOU_UPD			; 礼法決算

EXTRN	R_MS_REIHO_SRT:NEAR		; 礼法スタート台詞
EXTRN	R_MS_REIHO_DAYS:NEAR		; 礼法日々台詞
EXTRN	R_MS_REIHO_UPD:NEAR		; 礼法決算台詞

EXTRN	R_WEEKDAY:NEAR			; 平日が何日あるかの計算

EXTRN	R_SEIKOU_HANTEI:NEAR		; 成功判定

EXTRN	R_KEISAN:NEAR			; 各計算処理

EXTRN	R_ITEM_SCH:NEAR			; アイテム条件検索
EXTRN	R_ITM_MOCHIMON:NEAR		; 持物アイテム検索
EXTRN	R_GET_SELECT:NEAR		; ｱｲﾃﾑレコード内から選択単語を取り出す
EXTRN	R_ITEM_NMSH:NEAR		; 名前でアイテム検索
EXTRN	R_ITM_MOTTERU:NEAR		; 持っているか検索

EXTRN	WIDSLC_INIT:NEAR		; WINDOWS/セレクト・ウインドウ初期処理
EXTRN	WIDSLC:NEAR			; WINDOWS/セレクト・ウインドウ

EXTRN	R_SR_DATE_OFF:NEAR		; 休息日や祝日か？

EXTRN	R_SR_PRICE:NEAR			; 通貨表示
EXTRN	R_SR_IDSTR:NEAR			; ＩＤ文字列表示
EXTRN	R_SR_POINT:NEAR			; ポイント表示
EXTRN	R_SR_WIDSTR:NEAR		; 文字列表示

EXTRN	R_SR_DATE_NOW:NEAR		; 本日の日付
EXTRN	R_SR_SR_LF:NEAR			; 改行
EXTRN	R_SR_SR_DESU:NEAR		; "です"
EXTRN	R_SR_SR_POTU:NEAR		; "・"
EXTRN	R_SR_SR_KAKO:NEAR		; "「"
EXTRN	R_SR_SR_KOKA:NEAR		; "」"

EXTRN	WIDFACE_INIT:NEAR		; WINDOWS/フェイスウインドウ初期処理
EXTRN	WIDFACE_OPEN_W:NEAR		; WINDOWS/行いフェイスＯＰＥＮ
EXTRN	WIDFACE_CLOSE_W:NEAR		; WINDOWS/行いフェイスＣＬＯＳＥ

EXTRN	WIDFACE_OPEN_G:NEAR		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
EXTRN	WIDFACE_CLOSE_G:NEAR		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ
EXTRN	WIDFACE_PUT_G:NEAR		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＰＵＴ

EXTRN	WIDEVNT_INIT:NEAR		; WINDOWS/イベントウインドウ初期処理
EXTRN	WIDEVNT_OPEN:NEAR		; WINDOWS/イベントウインドウＯＰＥＮ
EXTRN	WIDEVNT_CLOSE:NEAR		; WINDOWS/イベントウインドウＣＬＯＳＥ
EXTRN	WIDEVNT_OPEN_W:NEAR		; WINDOWS/行いイベントＯＰＥＮ
EXTRN	WIDEVNT_CLOSE_W:NEAR		; WINDOWS/行いイベントＣＬＯＳＥ

;*;EXTRN	WIDDSP_SAVE:NEAR		; WINDOWS/画面退避
;*;EXTRN	WIDDSP_LOAD:NEAR		; WINDOWS/画面復元
;*;
;*;EXTRN	WIDCCT_INIT:NEAR		; WINDOWS/キャラクタ初期処理
;*;EXTRN	WIDCCT_OPEN:NEAR		; WINDOWS/キャラクタオープン
;*;EXTRN	WIDCCT_CLOSE:NEAR		; WINDOWS/キャラクタクローズ
;*;EXTRN	WIDCCT_CHANGE:NEAR		; WINDOWS/キャラクタチェンジ

EXTRN	R_SR_FACE_WAIT:NEAR		; フェイスのＷＡＩＴ
EXTRN	US_WAIT:NEAR			; ユーザ待ち
EXTRN	TM_WAIT:NEAR			; タイマ待ち

; ****************************************************
;	礼法
;	-I- R_NISSU  : 日数・礼法
;	-O- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    KETTEI   : 0=決定,1=考え直す
;	-O- REIHOU_UP: 上昇する気品
;	    HIROU_UP : 上昇する疲労
;	    CNT_TRAY : 実行した回数
;	    CNT_SEIKOU : 成功した回数
;	    CNT_FUBARAI: お金が無い回数
; ****************************************************

R_REIHOU_SET	PROC	NEAR
	MOV	R_KOUMKU,ID_67		; 礼法

	MOV	REIHOU_UP,UP_KIHIN	; 上昇する気品
	MOV	HIROU_UP,UP_HIROU	; 上昇する疲労

	MOV	CNT_TRAY,0		; 実行した回数
	MOV	CNT_SEIKOU,0		; 成功した回数
	MOV	CNT_FUBARAI,0		; お金が無い回数

	WD_ADRS	ID_00,R_NAISTR		; 無効
	MOV	R_NAIYOU,0		;
	MOV	R_NYUKIN,0		;
	MOV	REIHOU_PAY,PRICE_REIHOU	; 礼法分割

	CALL	R_WEEKDAY		; 平日が何日あるかの計算
	MOV	BX,SCD_WEEKDAY		; 平日カウンタ
	MOV	AX,REIHOU_PAY		; 礼法分割
	MUL	BX			;
	MOV	R_SYUTSU,AX		; 出金
	MOV	R_NYUKIN,0		; 入金

	MOV	KETTEI,0		; 0=決定
	RET
R_REIHOU_SET	ENDP


; ****************************************************
;	礼法スタート
; ****************************************************

R_REIHOU_SRT	PROC	NEAR
	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,R_KOUMKU		; 項目
	CALL	R_SR_IDSTR		; ＩＤ文字列表示
	CALL	R_SR_SR_KOKA		; "」"
	PR_TXT	"@料金は全部で"		;
	MOV	DX,R_SYUTSU		; 出金
	CALL	R_SR_PRICE		; 通貨表示

	CALL	R_MS_REIHO_SRT		; 礼法スタート台詞

	MOV	DX,8			; 8=礼法の道場
	CALL	WIDEVNT_OPEN		; WINDOWS/イベントウインドウＯＰＥＮ

	RET
R_REIHOU_SRT	ENDP


; ****************************************************
;	礼法実行
;	-I-   REIHOU_PAY   : 礼法分割
;	      REIHOU_UP    : 上昇する気品
;	      HIROU_UP     : 上昇する疲労
;	      R_KOUMKU     : 項目
;	      R_NAISTR     : 内容文字列（アドレス）
;	-I/O- R_NYUKIN     : 入金
;	      R_SYUTSU     : 出金
;	      CNT_TRAY     : 実行した回数
;	      CNT_SEIKOU   : 成功した回数
;	      CNT_FUBARAI  : お金が無い回数
; ****************************************************

R_REIHOU_RUN	PROC	NEAR
	CALL	R_SR_DATE_OFF		; 休息日や祝日か？
	CMP	AX,1			; 0=休みではない,1=休み
	JMPEQ	R_REIHOU_RUN_SUNDAY	;

	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,R_KOUMKU		; 項目
	CALL	R_SR_IDSTR		; ＩＤ文字列表示
	CALL	R_SR_SR_KOKA		; "」"

	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	AX,REIHOU_PAY		; 礼法分割
	MOV	S_FUNC,8		; 8=支払い
	CALL	R_KEISAN		; 各計算処理
	CMP	AX,2			; 2=お金が足りません
	JE	R_REIHOU_RUN_NO_MONEY	;

	INC	CNT_TRAY		; 実行した回数

	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	S_FUNC,9		; 9=礼法成功率計算
	CALL	R_KEISAN		; 各計算処理

	MOV	V_SEIKOU,AX		; 成功率

	MOV	DX,AX			; 成功率
	CALL	R_SEIKOU_HANTEI		; 成功判定
	CMP	AX,1			; 1=成功です,0=失敗です
	JE	R_REIHOU_RUN_OK		;

	CALL	WIDFACE_OPEN_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
	MOV	DX,2			; 顔 2=失敗
	CALL	WIDFACE_PUT_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ

	MOV	DX,0			; 気品
	CALL	R_MS_REIHO_DAYS		; 礼法日々台詞

	CALL	TM_WAIT			; タイマ待ち

	CALL	WIDFACE_CLOSE_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	JMP	R_REIHOU_RUN_EXIT	;
R_REIHOU_RUN_OK:			;
	CALL	WIDFACE_OPEN_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
	MOV	DX,1			; 顔 1=成功
	CALL	WIDFACE_PUT_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ

	INC	CNT_SEIKOU		; 成功した回数

;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;
;*;	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	MOV	DX,REIHOU_UP		; 上昇する気品
	CALL	R_MS_REIHO_DAYS		; 礼法日々台詞

	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	DX,REIHOU_UP		; 上昇する気品
	MOV	CX,HIROU_UP		; 上昇する疲労
	MOV	AX,0			; 学費はもう払っています
	MOV	S_FUNC,10		; 10=礼法パラメータ計算
	CALL	R_KEISAN		; 各計算処理

;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
;*;
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元

	CALL	WIDFACE_CLOSE_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	JMP	R_REIHOU_RUN_EXIT	;


R_REIHOU_RUN_NO_MONEY:			;
	SUBX	R_SYUTSU,REIHOU_PAY	; 礼法分割
	INC	CNT_FUBARAI		; お金が無い回数

	PR_TXTR	"@お金がたりない！？"
;*NON*;	CALL	TM_WAIT			; タイマ待ち＊＊＊＊＊＊＊
	JMP	R_REIHOU_RUN_EXIT	;

R_REIHOU_RUN_SUNDAY:			;
	CALL	TM_WAIT			; タイマ待ち＊＊＊＊＊＊＊
R_REIHOU_RUN_EXIT:			;
	RET
R_REIHOU_RUN	ENDP


; ****************************************************
;	礼法決算
;	-I- CNT_TRAY     : 実行した回数
;	    CNT_SEIKOU   : 成功した回数
;	    CNT_FUBARAI  : お金が無い回数
; ****************************************************

R_REIHOU_UPD	PROC	NEAR
;*STP*;	PR_CLS
	MOV	SI,1			; 1=礼法の先生
	MOV	DI,4			; 4=礼法の先生
	CALL	WIDFACE_OPEN_W		; WINDOWS/行いフェイスＯＰＥＮ

	; 根性と気品

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DX,ES:[SI][GTB_KONJYO][GRP_VALMAX]; グラフ最大根性
	MOV	KONJOU,DX		; 根性
	MOV	DX,ES:[SI][GTB_KIHIN][GRP_VALMAX]; グラフ最大気品
	MOV	KIHIN,DX		; 気品

	MOV	CX,R_HEIJITSU		; 平日
	MOV	DX,KIHIN		; 気品
	CALL	R_MS_REIHO_UPD		; 礼法決算台詞

	MUSIC	KYOKU_F_O		; 音楽フェードアウト

	CMP	CNT_FUBARAI,2		; お金が無い回数
	JL	R_REIHOU_UPD_2		;
	PR_TXT	"@｢＊＊＊＊＊＊＊＊＊＊@＊＊＊＊＊＊＊＊＊＊＊＊｣"
R_REIHOU_UPD_2:

	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
	CALL	WIDFACE_CLOSE_W		; WINDOWS/行いフェイスＣＬＯＳＥ
	CALL	WIDEVNT_CLOSE		; WINDOWS/イベントウインドウＣＬＯＳＥ
;*;	PR_WAIT
	RET
R_REIHOU_UPD	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	WIDSNM:WORD			; ユーザ選択番号

EXTRN	SCD_WEEKDAY:WORD		; 平日カウンタ

EXTRN	R_KOUMKU:WORD			; 項目
EXTRN	R_NAISTR:WORD			; 内容文字列
EXTRN	R_NAIYOU:WORD			; 内容値
EXTRN	R_NYUKIN:WORD			; 入金
EXTRN	R_SYUTSU:WORD			; 出金
EXTRN	R_NISSU:WORD			; 日数
EXTRN	R_HEIJITSU:WORD			; 平日

EXTRN	KETTEI:WORD			; 決定フラグ

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

REIHOU_PAY	DW	0	; 礼法分割
REIHOU_UP	DW	0	; 上昇する気品
HIROU_UP	DW	0	; 上昇する疲労

KONJOU		DW	0	; 根性
KIHIN		DW	0	; 気品

V_SEIKOU	DW	0	; 成功率

CNT_TRAY	DW	0	; 実行した回数
CNT_SEIKOU	DW	0	; 成功した回数
CNT_FUBARAI	DW	0	; お金が無い回数

DATA	ENDS

	END
;
;	end of "R_REIHOU.ASM"
;
