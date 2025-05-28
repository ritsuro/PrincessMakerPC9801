; "R_GAKUMO.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	学問
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

;*;CCT_OPEN_TYPE	EQU	4	; オープンタイプ
;*;NISSU_GAKUMON	EQU	10	; 日数・学問

CLASS_SHOKYU	EQU	1	; 初級
CLASS_CHUKYU	EQU	2	; 中級
CLASS_JOHKYU	EQU	3	; 上級
CLASS_SOTUGY	EQU	4	; 卒業

LEVEL_SHOKYU	EQU	50	; 初級レベル
LEVEL_CHUKYU	EQU	150	; 中級レベル
LEVEL_JOHKYU	EQU	300	; 上級レベル

PRICE_SHOKYU	EQU	10	; 初級値段
PRICE_CHUKYU	EQU	20	; 中級値段
PRICE_JOHKYU	EQU	40	; 上級値段

PRICE_S_SHOKYU	EQU	50	; 初級試験値段
PRICE_S_CHUKYU	EQU	100	; 中級試験値段
PRICE_S_JOHKYU	EQU	200	; 上級試験値段

UP_SHOKYU	EQU	2	; 初級・知力ＵＰ
UP_CHUKYU	EQU	3	; 中級・知力ＵＰ
UP_JOHKYU	EQU	5	; 上級・知力ＵＰ

TIRED_SHOKYU	EQU	2	; 初級・疲労ＵＰ
TIRED_CHUKYU	EQU	3	; 中級・疲労ＵＰ
TIRED_JOHKYU	EQU	5	; 上級・疲労ＵＰ


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

PUBLIC	R_GAKUMO_SET			; 学問セット
PUBLIC	R_GAKUMO_SRT			; 学問スタート
PUBLIC	R_GAKUMO_RUN			; 学問実行
PUBLIC	R_GAKUMO_UPD			; 学問決算

EXTRN	R_MS_GAKUM_SRT:NEAR		; 学問スタート台詞
EXTRN	R_MS_GAKUM_DAYS:NEAR		; 学問日々台詞
EXTRN	R_MS_GAKUM_UPD:NEAR		; 学問決算台詞
EXTRN	R_MS_GAKUM_TST:NEAR		; 学問試験台詞

EXTRN	R_WEEKDAY:NEAR			; 平日が何日あるかの計算

EXTRN	R_SEIKOU_HANTEI:NEAR		; 成功判定

EXTRN	R_KEISAN:NEAR			; 各計算処理

EXTRN	R_ITEM_SCH:NEAR			; アイテム条件検索
EXTRN	R_ITM_MOCHIMON:NEAR		; 持物アイテム検索
EXTRN	R_GET_SELECT:NEAR		; ｱｲﾃﾑレコード内から選択単語を取り出す
EXTRN	R_ITEM_NMSH:NEAR		; 名前でアイテム検索
EXTRN	R_ITM_MOTTERU:NEAR		; 持っているか検索

EXTRN	R_K_CALC_MAHO:NEAR		; 魔法を手に入れた

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

EXTRN	R_SHOGO_TAKE:NEAR		; 称号を手に入れた

EXTRN	WIDHED:NEAR			; WINDOWS/ヘッダー表示
EXTRN	WIDPROP_ALL:NEAR		; WINDOWS/プロポ・ウインドウ全表示

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
EXTRN	R_SR_FACE_IYA_WAIT:NEAR		; フェイスの嫌味ＷＡＩＴ
EXTRN	US_WAIT:NEAR			; ユーザ待ち
EXTRN	TM_WAIT:NEAR			; タイマ待ち

; ****************************************************
;	学問
;	-I- R_NISSU  : 日数
;	-O- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列（アドレス）
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    KETTEI   : 0=決定,1=考え直す
;
;	    GAKUMO_CLASS    : 学問クラス
;	    GAKUMO_PAY      : 学費分割
;	    GAKUMO_UP       : 上昇する知力
;	    GAKUMO_HIROU    : 上昇する疲労
;	    CHIRYOKU        : 知力
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
; ****************************************************

R_GAKUMO_SET	PROC	NEAR
	MOV	R_KOUMKU,ID_66		; 学問		

	CALL	R_GAKUMO_UPC		; 学問クラスＵＰチェック
	CMP	CLASS_UP_FLAG,2		; 2=卒業
	JE	R_GAKUMO_SET_SOTUGYO	;
	CMP	CLASS_UP_FLAG,1		; 1=クラスＵＰ
	JNE	R_GAKUMO_SET_3		;
	PR_TXTR	"・・・@おぉ、進級していますよ"
R_GAKUMO_SET_3:				;

	MOV	KETTEI,0		; 0=決定
	RET
R_GAKUMO_SET_SOTUGYO:
	PR_TXT	"@もう卒業してた。"
	MOV	KETTEI,1		; 1=考え直す
	RET
R_GAKUMO_SET	ENDP



; ****************************************************
;	学問スタート
;	-I- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列（アドレス）
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    R_NISSU  : 日数
;
;	-O- GAKUMO_CLASS    : 学問クラス
;	    GAKUMO_PAY      : 学費分割
;	    GAKUMO_UP       : 上昇する知力
;	    GAKUMO_HIROU    : 上昇する疲労
;	    CHIRYOKU        : 知力
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
; ****************************************************

R_GAKUMO_SRT	PROC	NEAR
	CALL	R_GAKUMO_UPC		; 学問クラスＵＰチェック
	CMP	GAKUMO_CLASS,CLASS_SOTUGY ; 4=卒業
	JE	R_GAKUMO_SRT_SOTSUGYO	;

	PR_CLS
	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,R_KOUMKU		; 項目
	CALL	R_SR_IDSTR		; ＩＤ文字列表示
	CALL	R_SR_SR_POTU		; "・"
	MOV	DX,R_NAISTR		; 内容文字列（アドレス）
	CALL	R_SR_WIDSTR		; 文字列表示
	CALL	R_SR_SR_KOKA		; "」"
	PR_TXT	"@料金は全部で"		;
	MOV	DX,R_SYUTSU		; 出金
	CALL	R_SR_PRICE		; 通貨表示

	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_SRT		; 学問スタート台詞

	MOV	DX,7			; 7=学問場
	CALL	WIDEVNT_OPEN		; WINDOWS/イベントウインドウＯＰＥＮ

R_GAKUMO_SRT_EXIT:
	RET

R_GAKUMO_SRT_SOTSUGYO:
	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_SRT		; 学問スタート台詞
	RET
R_GAKUMO_SRT	ENDP



; ****************************************************
;	学問クラスＵＰチェック
;
;	-I/O- GAKUMO_CLAS_OLD : 前の学問クラス
;	-O- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列（アドレス）
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    R_NISSU  : 日数
;	    KETTEI   : 0=決定,1=考え直す
;
;	    GAKUMO_CLASS    : 学問クラス
;	    GAKUMO_PAY      : 学費分割
;	    GAKUMO_UP       : 上昇する知力
;	    GAKUMO_HIROU    : 上昇する疲労
;	    CHIRYOKU        : 知力
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
;	    CLASS_UP_FLAG   : クラスＵＰフラグ
;			    : 0=前と変わらず,1=クラスＵＰ,2=卒業
; ****************************************************

R_GAKUMO_UPC	PROC	NEAR

	; 知性

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DX,ES:[SI][GTB_TIRYOKU][GRP_VALMAX]; グラフ最大知力
	MOV	CHIRYOKU,DX		; 知力

;*;	MOV	DX,ID_12		; 知力		
;*;	CALL	R_SR_IDSTR		; ＩＤ文字列表示
;*;	MOV	DX,CHIRYOKU		; 知力
;*;	CALL	R_SR_POINT		; ポイント表示

	; 合格証でクラスを調べる

	CALL	CLASS_CHK		; 級のチェック


	CMPX	GAKUMO_CLASS,CLASS_SHOKYU ; 初級
	JE	R_GAKUMO_UPC_SHOKYU	;
	CMPX	GAKUMO_CLASS,CLASS_CHUKYU ; 中級
	JE	R_GAKUMO_UPC_CHUKYU	;
	CMPX	GAKUMO_CLASS,CLASS_JOHKYU ; 上級
	JE	R_GAKUMO_UPC_JOHKYU	;
;**;	CMP	GAKUMO_CLASS,CLASS_SOTUGY ; 卒業
	JMP	R_GAKUMO_UPC_SOTUGYO	;

R_GAKUMO_UPC_SHOKYU:
	WD_ADRS	ID_72,R_NAISTR		; 初級
	MOV	GAKUMO_PAY,PRICE_SHOKYU	; 初級値段
	MOV	GAKUMO_UP,UP_SHOKYU	; 初級・知力ＵＰ
	MOV	GAKUMO_HIROU,TIRED_SHOKYU ; 初級・疲労ＵＰ
	JMP	R_GAKUMO_UPC_YN		;
R_GAKUMO_UPC_CHUKYU:
	WD_ADRS	ID_73,R_NAISTR		; 中級
	MOV	GAKUMO_PAY,PRICE_CHUKYU	; 中級値段
	MOV	GAKUMO_UP,UP_CHUKYU	; 中級・知力ＵＰ
	MOV	GAKUMO_HIROU,TIRED_CHUKYU ; 中級・疲労ＵＰ
	JMP	R_GAKUMO_UPC_YN		;
R_GAKUMO_UPC_JOHKYU:
	WD_ADRS	ID_74,R_NAISTR		; 上級
	MOV	GAKUMO_PAY,PRICE_JOHKYU	; 上級値段
	MOV	GAKUMO_UP,UP_JOHKYU	; 上級・知力ＵＰ
	MOV	GAKUMO_HIROU,TIRED_JOHKYU ; 上級・疲労ＵＰ
	JMP	R_GAKUMO_UPC_YN		;

R_GAKUMO_UPC_YN:
	CALL	R_WEEKDAY		; 平日が何日あるかの計算
	MOV	BX,SCD_WEEKDAY		; 平日カウンタ
	MOV	AX,GAKUMO_PAY		; 学費
	MUL	BX			;
	MOV	R_SYUTSU,AX		; 出金
	MOV	R_NYUKIN,0		; 入金

	CMPX	GAKUMO_CLASS,GAKUMO_CLAS_OLD	; 前の学問クラス
	JE	R_GAKUMO_UPC_NORMAL		;

	CMP	GAKUMO_CLAS_OLD,OFFF		; 前の学問ＯＦＦか？
	JNE	R_GAKUMO_UPC_88			;
	MOVX	GAKUMO_CLAS_OLD,GAKUMO_CLASS	; 前の学問クラス
	JMP	R_GAKUMO_UPC_NORMAL		;
R_GAKUMO_UPC_88:				;
	MOVX	GAKUMO_CLAS_OLD,GAKUMO_CLASS	; 前の学問クラス
R_GAKUMO_UPC_UP:
	MOV	CLASS_UP_FLAG,1		; 1=クラスＵＰ
	RET
R_GAKUMO_UPC_SOTUGYO:
	WD_ADRS	ID_74,R_NAISTR			; 上級
	MOV	CLASS_UP_FLAG,2		; 2=卒業
	RET
R_GAKUMO_UPC_NORMAL:
	MOV	CLASS_UP_FLAG,0		; 0=前と変わらず
	RET
R_GAKUMO_UPC	ENDP



; ****************************************************
;	学問実行
;	-I-   GAKUMO_CLASS : 学問クラス
;	      GAKUMO_PAY   : 学費分割
;	      GAKUMO_UP    : 上昇する知力
;	      GAKUMO_HIROU : 上昇する疲労
;	      R_KOUMKU     : 項目
;	      R_NAISTR     : 内容文字列（アドレス）
;	-I/O- R_NYUKIN     : 入金
;	      R_SYUTSU     : 出金
; ****************************************************

R_GAKUMO_RUN	PROC	NEAR
	CALL	R_SR_DATE_OFF		; 休息日や祝日か？
	CMP	AX,1			; 0=休みではない,1=休み
	JMPEQ	R_GAKUMO_RUN_SUNDAY	;

	CMP	GAKUMO_CLASS,CLASS_SOTUGY ; 4=卒業
	JMPEQ	R_GAKUMO_RUN_EXIT	;

	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,R_KOUMKU		; 項目
	CALL	R_SR_IDSTR		; ＩＤ文字列表示
	CALL	R_SR_SR_POTU		; "・"
	MOV	DX,R_NAISTR		; 内容文字列（アドレス）
	CALL	R_SR_WIDSTR		; 文字列表示
	CALL	R_SR_SR_KOKA		; "」"

	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	AX,GAKUMO_PAY		; 学費分割
	MOV	S_FUNC,8		; 8=支払い
	CALL	R_KEISAN		; 各計算処理
	MOV	GAKUMO_FLAG,AX		; 0=学問しました,2=お金が足りません
	CMP	GAKUMO_FLAG,2		;
	JE	R_GAKUMO_RUN_NO_MONEY	;

	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	S_FUNC,6		; 6=学問成功率計算
	CALL	R_KEISAN		; 各計算処理

	MOV	V_SEIKOU,AX		; 成功率

	MOV	DX,AX			; 成功率
	CALL	R_SEIKOU_HANTEI		; 成功判定
	CMP	AX,1			; 1=成功です,0=失敗です
	JE	R_GAKUMO_RUN_OK		;

	CALL	WIDFACE_OPEN_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
	MOV	DX,2			; 顔 2=失敗
	CALL	WIDFACE_PUT_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ

	MOV	DX,0			; 知力 失敗
	CALL	R_MS_GAKUM_DAYS		; 学問日々台詞

	CALL	TM_WAIT			; タイマ待ち

	CALL	WIDFACE_CLOSE_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	JMP	R_GAKUMO_RUN_EXIT	;
R_GAKUMO_RUN_OK:			;
	CALL	WIDFACE_OPEN_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
	MOV	DX,1			; 顔 1=成功
	CALL	WIDFACE_PUT_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ

;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;
;*;	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	MOV	DX,GAKUMO_UP		; 上昇する知力
	CALL	R_MS_GAKUM_DAYS		; 学問日々台詞

	MOV	BX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	DX,GAKUMO_UP		; 上昇する知力
	MOV	CX,GAKUMO_HIROU		; 上昇する疲労
	MOV	AX,0			; 学費はもう払っています
	MOV	S_FUNC,7		; 7=学問パラメータ計算
	CALL	R_KEISAN		; 各計算処理

;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
;*;
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元

	CALL	WIDFACE_CLOSE_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	JMP	R_GAKUMO_RUN_EXIT	;

R_GAKUMO_RUN_NO_MONEY:			;
	SUBX	R_SYUTSU,GAKUMO_PAY	; 学費分割

	PR_TXT	"@お金がたりない！？"
;*NON*;	CALL	TM_WAIT			; タイマ待ち＊＊＊＊＊＊＊
	JMP	R_GAKUMO_RUN_EXIT	;

R_GAKUMO_RUN_SUNDAY:
	CALL	TM_WAIT			; タイマ待ち＊＊＊＊＊＊＊
R_GAKUMO_RUN_EXIT:
	RET
R_GAKUMO_RUN	ENDP


; ****************************************************
;	学問決算
;	-I- CHIRYOKU : 元の知力
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
; ****************************************************

R_GAKUMO_UPD	PROC	NEAR
	CMP	GAKUMO_CLASS,CLASS_SOTUGY ; 4=卒業
	JMPEQ	R_GAKUMO_UPD_SKIP	;

	; 知性

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DX,ES:[SI][GTB_TIRYOKU][GRP_VALMAX]; グラフ最大知力
	MOV	CHIRYOKU_UP,DX		; ＵＰした後の知力

	MOV	DX,CHIRYOKU_UP		; ＵＰした後の知力
	SUB	DX,CHIRYOKU		; 元の知力
	MOV	CX,R_HEIJITSU		; 平日
	CALL	R_MS_GAKUM_UPD		; 学問決算台詞

	MOV	SI,1			; 学問クラス
	MOV	DI,3			; 3=学問場の先生
	CALL	WIDFACE_OPEN_W		; WINDOWS/行いフェイスＯＰＥＮ

	CALL	JYOKYU_CHK		; 昇級チェック
	CMP	SHOKYU,0		; 昇級 0=無し
	JMPEQ	R_GAKUMO_UPD_NORMAL	;

	MOV	BX,1			; 1=勧誘
	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_TST		; 学問試験台詞

	SELECT	"受験します,やめておきます"
	CMP	WIDSNM,0		; ユーザ選択番号
	JMPNE	R_GAKUMO_UPD_YAME	;

	MOV	BX,GAKUMO_CLASS		; 学問クラス
	SHL	BX,1			; word pointer.
	MOVX	GAKUMO_TEST_PAY,DS:PRICE_SHIKEN[BX]	; 受験価格

	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	AX,GAKUMO_TEST_PAY	; 受験料
	MOV	S_FUNC,8		; 8=支払い
	CALL	R_KEISAN		; 各計算処理
	CMP	AX,2			; 0=支払いしました,2=お金が足りません
	JMPEQ	R_GAKUMO_UPD_NO_MONEY	;

	MOV	BX,2			; 2=受験する場合
	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_TST		; 学問試験台詞

	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ

	CALL	QIZMODE			; クイズモード
	CMP	AX,1			; 1=合格,2=不合格
	JMPNE	R_GAKUMO_UPD_NORMAL	;

;*;	MOV	BX,SHIKAKUSHO_AD	; 合格証書のアイテムアドレス
;*;	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
;*;	MOV	DX,ES:[BX]		;
;*;	CALL	R_SR_WIDSTR		; 文字列表示

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,SHIKAKUSHO_AD	; 合格証書のアイテムアドレス
	MOV	CX,5			; 種別・5=資格
	MOV	DX,SHIKAKUSHO		; 合格証書のアイテムＮＯ．
	MOV	S_FUNC,1		; 買物計算
	CALL	R_KEISAN		; 各計算処理
	CMP	AX,2			; 2=いっぱいで持てません
	JE	R_GAKUMO_UPD_KACHI_DAKEDO

R_GAKUMO_UPD_KACHI:			;
	MOV	BX,5			; 5=合格
	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_TST		; 学問試験台詞
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	MAGIC_INTER		; 魔法取得
	CALL	SHOGO_ATAERU		; 称号を与える
	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
	JMP	R_GAKUMO_UPD_EXIT	;
R_GAKUMO_UPD_KACHI_DAKEDO:		;
	MOV	BX,5			; 5=合格
	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_TST		; 学問試験台詞
	PR_WAIT
	PR_TXT "@｢だけど、持物が多くて@合格証が持てないね。」@残念だった‥‥‥"
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_IYA_WAIT	; フェイスの嫌味ＷＡＩＴ
	JMP	R_GAKUMO_UPD_EXIT	;
R_GAKUMO_UPD_MAKE:			;
	MOV	BX,4			; 4=不合格
	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_TST		; 学問試験台詞
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
	JMP	R_GAKUMO_UPD_EXIT	;
R_GAKUMO_UPD_NO_MONEY:
	PR_TXT	"@お金が足りない！！"
	MOV	BX,3			; 3=受験しない場合
	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_TST		; 学問試験台詞
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_IYA_WAIT	; フェイスの嫌味ＷＡＩＴ
	JMP	R_GAKUMO_UPD_EXIT	;
R_GAKUMO_UPD_YAME:
	MOV	BX,3			; 3=受験しない場合
	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_TST		; 学問試験台詞
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_IYA_WAIT	; フェイスの嫌味ＷＡＩＴ
	JMP	R_GAKUMO_UPD_EXIT	;
R_GAKUMO_UPD_NORMAL:
	MOV	BX,6			; 6=なにもないとき
	MOV	DX,GAKUMO_CLASS		; 学問クラス
	CALL	R_MS_GAKUM_TST		; 学問試験台詞
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
R_GAKUMO_UPD_EXIT:
	CALL	WIDFACE_CLOSE_W		; WINDOWS/行いフェイスＣＬＯＳＥ
	CALL	WIDEVNT_CLOSE		; WINDOWS/イベントウインドウＣＬＯＳＥ
R_GAKUMO_UPD_SKIP:
	RET
R_GAKUMO_UPD	ENDP


; ****************************************************
;	称号を与える
; ****************************************************

SHOGO_ATAERU	PROC	NEAR
	MOV	AX,GAKUMO_CLASS		; 学問クラス
	CMP	AX,CLASS_SHOKYU		; 初級
	JE	SHOGO_ATAERU_1		;
	CMP	AX,CLASS_CHUKYU		; 中級
	JE	SHOGO_ATAERU_2		;
	CMP	AX,CLASS_JOHKYU		; 上級
	JE	SHOGO_ATAERU_3		;
	JMP	SHOGO_ATAERU_EXIT	;

SHOGO_ATAERU_1:
	MOV	DX,ID_120		; 二級学士
	CALL	R_SHOGO_TAKE		; 称号を手に入れた
	JMP	SHOGO_ATAERU_EXIT	;
SHOGO_ATAERU_2:
	MOV	DX,ID_121		; 一級学士
	CALL	R_SHOGO_TAKE		; 称号を手に入れた
	JMP	SHOGO_ATAERU_EXIT	;
SHOGO_ATAERU_3:
	MOV	DX,ID_122		; 博士
	CALL	R_SHOGO_TAKE		; 称号を手に入れた
	JMP	SHOGO_ATAERU_EXIT	;
SHOGO_ATAERU_EXIT:
	CALL	WIDHED			; WINDOWS/ヘッダー表示
	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示
	RET
SHOGO_ATAERU	ENDP


; ****************************************************
;	魔法取得
;	-I- GAKUMO_CLASS : 学問クラス
; ****************************************************

MAGIC_INTER	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,GAKUMO_CLASS		; 学問クラスと魔法の種類は同じさ！
					; 魔法の種類 1=攻撃魔法,
					; 2=防御魔法,3=治療魔法
	CALL	R_K_CALC_MAHO		; 魔法を手に入れた
	RET
MAGIC_INTER	ENDP


; ****************************************************
;	昇級チェック
;	-I- CHIRYOKU    : 元の知力
;	    CHIRYOKU_UP : ＵＰした後の知力
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
;	-O- SHOKYU      : 昇級（0=無し,1=初級試験,2=中級試験,3=上級試験）
; ****************************************************

JYOKYU_CHK	PROC	NEAR
	MOV	SHOKYU,0		; 昇級（0=無し,
					;   1=初級試験,2=中級試験,3=上級試験）

;**;	CALL	CLASS_CHK		; 級のチェック

	CMPX	GAKUMO_CLASS,CLASS_SHOKYU ; 初級
	JE	JYOKYU_CHK_SHOKYU	; 初級レベル
	CMPX	GAKUMO_CLASS,CLASS_CHUKYU ; 中級
	JMPEQ	JYOKYU_CHK_CHUKYU	; 中級レベル
	CMPX	GAKUMO_CLASS,CLASS_JOHKYU ; 上級
	JMPEQ	JYOKYU_CHK_JOHKYU	; 上級レベル
;**;	CMP	GAKUMO_CLASS,CLASS_SOTUGY ; 卒業
	JMP	JYOKYU_CHK_EXIT		;


;*NON*;	; 持物を検索して合格証を持ってるかチェック
;*NON*;
;*NON*;	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
;*NON*;	CALL	R_ITM_MOCHIMON		; 持物アイテム検索
;*NON*;
;*NON*;	; 上級？
;*NON*;
;*NON*;	MOV	AX,ID_81		; 学問上級合格証
;*NON*;	MOV	DX,5			; 種別・5=資格
;*NON*;	CALL	R_ITEM_NMSH		; 名前でアイテム検索
;*NON*;
;*NON*;	MOV	SHIKAKUSHO_AD,BX	; 合格証書のアイテムアドレス
;*NON*;	MOV	SHIKAKUSHO_HAVE,DX	; 持っている合格証書のアイテムＮＯ．
;*NON*;	MOV	AX,5			; 種別・5=資格
;*NON*;	CALL	R_ITM_MOTTERU		; 持っているか検索
;*NON*;
;*NON*;	CMP	AX,1			; 1=見つかった
;*NON*;	JMPEQ	JYOKYU_CHK_EXIT		;
;*NON*;
;*NON*;	MOVX	SHIKAKUSHO,SHIKAKUSHO_HAVE ; 合格証書のアイテムＮＯ．
;*NON*;
;*NON*;
;*NON*;	; 中級？
;*NON*;
;*NON*;	MOV	AX,ID_80		; 学問中級合格証
;*NON*;	MOV	DX,5			; 種別・5=資格
;*NON*;	CALL	R_ITEM_NMSH		; 名前でアイテム検索
;*NON*;
;*NON*;	MOV	SHIKAKUSHO_AD,BX	; 合格証書のアイテムアドレス
;*NON*;	MOV	SHIKAKUSHO_HAVE,DX	; 持っている合格証書のアイテムＮＯ．
;*NON*;	MOV	AX,5			; 種別・5=資格
;*NON*;	CALL	R_ITM_MOTTERU		; 持っているか検索
;*NON*;
;*NON*;	CMP	AX,1			; 1=見つかった
;*NON*;	JMPEQ	JYOKYU_CHK_JOHKYU	; 上級レベル
;*NON*;
;*NON*;	MOVX	SHIKAKUSHO,SHIKAKUSHO_HAVE ; 合格証書のアイテムＮＯ．
;*NON*;
;*NON*;
;*NON*;	; 初級？
;*NON*;
;*NON*;	MOV	AX,ID_79		; 学問初級合格証
;*NON*;	MOV	DX,5			; 種別・5=資格
;*NON*;	CALL	R_ITEM_NMSH		; 名前でアイテム検索
;*NON*;
;*NON*;	MOV	SHIKAKUSHO_AD,BX	; 合格証書のアイテムアドレス
;*NON*;	MOV	SHIKAKUSHO_HAVE,DX	; 持っている合格証書のアイテムＮＯ．
;*NON*;	MOV	AX,5			; 種別・5=資格
;*NON*;	CALL	R_ITM_MOTTERU		; 持っているか検索
;*NON*;
;*NON*;	CMP	AX,1			; 1=見つかった
;*NON*;	JMPEQ	JYOKYU_CHK_CHUKYU	; 中級レベル
;*NON*;
;*NON*;	MOVX	SHIKAKUSHO,SHIKAKUSHO_HAVE ; 合格証書のアイテムＮＯ．

JYOKYU_CHK_SHOKYU:			; 初級レベル
	CMPX	CHIRYOKU_UP,LEVEL_SHOKYU ; 初級レベル越えたか？
	JBE	JYOKYU_CHK_EXIT		;

	MOV	SHOKYU,1		; 昇級 1=初級試験
	JMP	JYOKYU_CHK_EXIT		;

JYOKYU_CHK_CHUKYU:			; 中級レベル
	CMPX	CHIRYOKU_UP,LEVEL_CHUKYU ; 中級レベル越えたか？
	JBE	JYOKYU_CHK_EXIT		;

	MOV	SHOKYU,2		; 昇級 2=中級試験
	JMP	JYOKYU_CHK_EXIT		;

JYOKYU_CHK_JOHKYU:			; 上級レベル
	CMPX	CHIRYOKU_UP,LEVEL_JOHKYU ; 上級レベル越えたか？
	JBE	JYOKYU_CHK_EXIT		;

	MOV	SHOKYU,3		; 昇級 3=上級試験
	JMP	JYOKYU_CHK_EXIT		;

JYOKYU_CHK_EXIT:
	RET
JYOKYU_CHK	ENDP


; ****************************************************
;	級のチェック
;	-O- GAKUMO_CLASS    : 学問クラス
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
; ****************************************************

CLASS_CHK	PROC	NEAR

	; 持物を検索して合格証を持ってるかチェック

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_ITM_MOCHIMON		; 持物アイテム検索

	MOV	GAKUMO_CLASS,CLASS_SOTUGY ; 卒業

	; 上級？

	MOV	AX,ID_81		; 学問上級合格証
	MOV	DX,5			; 種別・5=資格
	CALL	R_ITEM_NMSH		; 名前でアイテム検索

	MOV	SHIKAKUSHO_AD,BX	; 合格証書のアイテムアドレス
	MOV	SHIKAKUSHO_HAVE,DX	; 持っている合格証書のアイテムＮＯ．
	MOV	AX,5			; 種別・5=資格
	CALL	R_ITM_MOTTERU		; 持っているか検索

	CMP	AX,1			; 1=見つかった
	JMPEQ	CLASS_CHK_SET		;

	MOVX	SHIKAKUSHO,SHIKAKUSHO_HAVE ; 合格証書のアイテムＮＯ．

	MOV	GAKUMO_CLASS,CLASS_JOHKYU ; 上級

	; 中級？

	MOV	AX,ID_80		; 学問中級合格証
	MOV	DX,5			; 種別・5=資格
	CALL	R_ITEM_NMSH		; 名前でアイテム検索

	MOV	SHIKAKUSHO_AD,BX	; 合格証書のアイテムアドレス
	MOV	SHIKAKUSHO_HAVE,DX	; 持っている合格証書のアイテムＮＯ．
	MOV	AX,5			; 種別・5=資格
	CALL	R_ITM_MOTTERU		; 持っているか検索

	CMP	AX,1			; 1=見つかった
	JMPEQ	CLASS_CHK_SET		;

	MOVX	SHIKAKUSHO,SHIKAKUSHO_HAVE ; 合格証書のアイテムＮＯ．

	MOV	GAKUMO_CLASS,CLASS_CHUKYU ; 中級

	; 初級？

	MOV	AX,ID_79		; 学問初級合格証
	MOV	DX,5			; 種別・5=資格
	CALL	R_ITEM_NMSH		; 名前でアイテム検索

	MOV	SHIKAKUSHO_AD,BX	; 合格証書のアイテムアドレス
	MOV	SHIKAKUSHO_HAVE,DX	; 持っている合格証書のアイテムＮＯ．
	MOV	AX,5			; 種別・5=資格
	CALL	R_ITM_MOTTERU		; 持っているか検索

	CMP	AX,1			; 1=見つかった
	JMPEQ	CLASS_CHK_SET		;

	MOVX	SHIKAKUSHO,SHIKAKUSHO_HAVE ; 合格証書のアイテムＮＯ．

	MOV	GAKUMO_CLASS,CLASS_SHOKYU ; 初級

CLASS_CHK_SET:
CLASS_CHK_EXIT:
	RET
CLASS_CHK	ENDP


; ****************************************************
;	クイズモード
;	-O- AX : 1=合格,2=不合格
; ****************************************************

QIZMODE	PROC	NEAR
	PR_CLS
	PR_TXT	"試験問題です。    第１問@"

	MOV	BX,GAKUMO_CLASS		; 卒業
	DEC	BX			;
	SHL	BX,1			;
	SHL	BX,1			; * 4
	MOV	MONTBL_POINTER,BX	; 問題アドレスポインタ

	MOVX	WDTXTADR,DS:MONTBL_MONDAI[BX]	; 問題
	CALL	WIDTXT2			; WINDOWS/テキストウインドウ２

QIZMODE_WLOP1:
	MOVX	ES,DS			; テキストバッファセグメント
	MOV	SI,MONTBL_POINTER	; 問題アドレスポインタ
	MOV	BX,DS:MONTBL_ANSER[SI]	; 答３択
	CALL	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	CMP	WIDSNM,OFFF		; とりあえずＯＦＦという意味
	JE	QIZMODE_WLOP1		;

	MOV	BX,MONTBL_POINTER	; 問題アドレスポインタ
	CMPX	WIDSNM,DS:MONTBL_KOTAE[BX] ; 答
	JNE	QIZMODE_RAKUDAI		;


	ADD	MONTBL_POINTER,2	; 問題アドレスポインタ

	PR_CLS
	PR_TXT	"合格です。    第２問@"

	MOV	BX,MONTBL_POINTER	; 問題アドレスポインタ
	MOVX	WDTXTADR,DS:MONTBL_MONDAI[BX]	; 問題
	CALL	WIDTXT2			; WINDOWS/テキストウインドウ２

QIZMODE_WLOP2:
	MOVX	ES,DS			; テキストバッファセグメント
	MOV	SI,MONTBL_POINTER	; 問題アドレスポインタ
	MOV	BX,DS:MONTBL_ANSER[SI]	; 答３択
	CALL	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	CMP	WIDSNM,OFFF		; とりあえずＯＦＦという意味
	JE	QIZMODE_WLOP2		;

	MOV	BX,MONTBL_POINTER	; 問題アドレスポインタ
	CMPX	WIDSNM,DS:MONTBL_KOTAE[BX] ; 答
	JNE	QIZMODE_RAKUDAI		;


QIZMODE_GOUKAKU:
	PR_TXT	"合格です。@"
	MOV	AX,1			; 1=合格
	RET
QIZMODE_RAKUDAI:
	PR_TXT	"落第です。@"
	MOV	AX,2			; 2=不合格
	RET
QIZMODE	ENDP


;*;; ****************************************************
;*;;	クイズモード
;*;;	-O- AX : 1=合格,2=不合格
;*;; ****************************************************
;*;
;*;QIZMODE		PROC	NEAR
;*;	PR_CLS
;*;	PR_TXT	"試験問題です。    第１問@"
;*;	PR_TXT	"星占いは、古代メソポタミアの遊牧民によって発見された、天文学を基礎とした占いです。"
;*;	PR_TXT	"火星はどの星座の守護星でしょう。@"
;*;	;*;PR_WAIT
;*;
;*;	SELECT	"蟹座（かに）,おひつじ座,双子座（ふたご）"
;*;	CMP	WIDSNM,1		; ユーザ選択番号
;*;	JNE	QIZMODE_RAKUDAI		;
;*;
;*;	PR_CLS
;*;	PR_TXT	"合格です。    第２問@"
;*;	PR_TXT	"片思いを両思いへ実らせる、エジプトに古くから伝わるおまじないは何でしょう@"
;*;;*;	PR_WAIT
;*;
;*;	SELECT	"あいてのコップに鼻水を塗り付ける,ねこをピラミッドの上から落とす,冠を風呂に入れた後ユリイカと叫んで通りを裸で走る"
;*;	CMP	WIDSNM,1		; ユーザ選択番号
;*;	JNE	QIZMODE_RAKUDAI		;
;*;
;*;	PR_TXT	"ピンポーン、合格です。@"
;*;	MOV	AX,1			; 1=合格
;*;	RET
;*;QIZMODE_RAKUDAI:
;*;	PR_TXT	"ブッブー、落第です。@"
;*;	MOV	AX,2			; 2=不合格
;*;	RET
;*;QIZMODE		ENDP


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

GAKUMO_CLASS	DW	0	; 学問クラス
GAKUMO_PAY	DW	0	; 学費分割
GAKUMO_TEST_PAY	DW	0	; 受験料
GAKUMO_UP	DW	0	; 上昇する知力
GAKUMO_HIROU	DW	0	; 上昇する疲労
GAKUMO_FLAG	DW	0	; 0=学問しました,2=お金が足りません

GAKUMO_CLAS_OLD	DW	OFFF	; 前の学問クラス

CHIRYOKU	DW	0	; 知力
CHIRYOKU_UP	DW	0	; ＵＰした後の知力

SHOKYU		DW	0	; 昇級（0=無し,
				;       1=初級試験,2=中級試験,3=上級試験）

V_SEIKOU	DW	0	; 成功率

SHIKAKUSHO_HAVE	DW	0	; 持っている合格証書のアイテムＮＯ．
SHIKAKUSHO	DW	0	; 合格証書のアイテムＮＯ．
SHIKAKUSHO_AD	DW	0	; 合格証書のアイテムアドレス

CLASS_UP_FLAG	DW	0	; クラスＵＰフラグ
				; 0=前と変わらず,1=クラスＵＰ,2=卒業

MSG_KYU		LABEL	WORD	; 級
	DW	ID_72		; 初級
	DW	ID_72		; 初級
	DW	ID_73		; 中級
	DW	ID_74		; 上級

PRICE_SHIKEN	LABEL	WORD		; 受験価格
	DW	PRICE_S_SHOKYU		;
	DW	PRICE_S_SHOKYU		; 初級試験値段
	DW	PRICE_S_CHUKYU		; 中級試験値段
	DW	PRICE_S_JOHKYU		; 上級試験値段

MONTBL_POINTER	DW	0		; 問題アドレスポインタ
MONTBL_MONDAI	LABEL	WORD		; 問題
		DW	MN01,MN02,MN03,MN04,MN05,MN06
MONTBL_ANSER	LABEL	WORD		; 答３択
		DW	WH01,WH02,WH03,WH04,WH05,WH06
MONTBL_KOTAE	DW	1,0,0,1,1,2	; 答


MN01	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

WH01	DB	"＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊＊＊",0
	;正解	＊＊＊＊＊＊＊＊＊＊


MN02	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

WH02	DB	"＊＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊＊",0
	;正解	＊＊＊＊＊＊＊＊

MN03	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

WH03	DB	"＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊＊＊＊＊",0
	;正解	＊＊＊＊＊＊＊＊＊＊＊＊

MN04	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

WH04	DB	"＊＊＊＊＊＊＊"	
	DB	",＊＊＊＊＊＊＊＊＊"
	DB	",＊＊",0
	;正解	＊＊＊＊＊＊＊＊＊

MN05	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

WH05	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

	;正解	＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊


MN06	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊"
	DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

WH06	DB	"＊＊＊＊＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊＊＊＊"
	DB	",＊＊＊＊＊＊＊＊",0

;正解	＊＊＊＊＊＊＊＊


;*;MSG_00_TBL	DW	MSG_01,MSG_01,MSG_02,MSG_03,MSG_04
;*;MSG_01	DB	"@ペンは剣よりも強し！",0
;*;MSG_02	DB	"@はじめますか。",0
;*;MSG_03	DB	"@才女はつねに孤独だ。",0
;*;MSG_04	DB	"@にんげんはかしこい。",0

DATA	ENDS

	END
;
;	end of "R_GAKUMO.ASM"
;
