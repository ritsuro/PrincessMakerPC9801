; "R_BUGEI.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	武芸
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

;*;CCT_OPEN_TYPE	EQU	4	; オープンタイプ
;*;NISSU_BUGEIN		EQU	10	; 日数・武芸

CLASS_SHOKYU	EQU	1	; 初級
CLASS_CHUKYU	EQU	2	; 中級
CLASS_JOHKYU	EQU	3	; 上級
CLASS_SOTUGY	EQU	4	; 卒業

LEVEL_SHOKYU	EQU	4	; 初級レベル
LEVEL_CHUKYU	EQU	9	; 中級レベル
LEVEL_JOHKYU	EQU	40	; 上級レベル

PRICE_SHOKYU	EQU	10	; 初級値段
PRICE_CHUKYU	EQU	20	; 中級値段
PRICE_JOHKYU	EQU	40	; 上級値段

PRICE_S_SHOKYU	EQU	50	; 初級試験値段
PRICE_S_CHUKYU	EQU	100	; 中級試験値段
PRICE_S_JOHKYU	EQU	200	; 上級試験値段

UP_SHOKYU	EQU	2	; 初級・経験値ＵＰ
UP_CHUKYU	EQU	3	; 中級・経験値ＵＰ
UP_JOHKYU	EQU	5	; 上級・経験値ＵＰ

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

PUBLIC	R_BUGEI_SET			; 武芸セット
PUBLIC	R_BUGEI_SRT			; 武芸スタート
PUBLIC	R_BUGEI_RUN			; 武芸実行
PUBLIC	R_BUGEI_UPD			; 武芸決算

EXTRN	R_MS_BUGEI_SRT:NEAR		; 武芸スタート台詞
EXTRN	R_MS_BUGEI_DAYS:NEAR		; 武芸日々台詞
EXTRN	R_MS_BUGEI_UPD:NEAR		; 武芸決算台詞
EXTRN	R_MS_BUGEI_TST:NEAR		; 武芸試験台詞

EXTRN	R_SENTOU_GE_OPEN:NEAR		; 武芸戦闘・ＯＰＥＮ
EXTRN	R_SENTOU_GE:NEAR		; 武芸戦闘！
EXTRN	R_SENTOU_GE_CLOSE:NEAR		; 武芸戦闘・ＣＬＯＳＥ
;*;EXTRN R_SENTOU:NEAR			; 戦闘！

EXTRN	R_MAIN_WINDOW_DSP:NEAR		; メインウインドウ復帰

;*;EXTRN R_LEVEL_UP:NEAR		; レベルＵＰ処理

EXTRN	R_WEEKDAY:NEAR			; 平日が何日あるかの計算

EXTRN	R_SEIKOU_HANTEI:NEAR		; 成功判定

EXTRN	R_KEISAN:NEAR			; 各計算処理

EXTRN	R_ITEM_SCH:NEAR			; アイテム条件検索
EXTRN	R_ITM_MOCHIMON:NEAR		; 持物アイテム検索
EXTRN	R_GET_SELECT:NEAR		; ｱｲﾃﾑレコード内から選択単語を取り出す
EXTRN	R_ITEM_NMSH:NEAR		; 名前でアイテム検索
EXTRN	R_ITM_MOTTERU:NEAR		; 持っているか検索

EXTRN	R_SHOGO_TAKE:NEAR		; 称号を手に入れた

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

EXTRN	WIDHED:NEAR			; WINDOWS/ヘッダー表示
EXTRN	WIDPROP_ALL:NEAR		; WINDOWS/プロポ・ウインドウ全表示

EXTRN	MAIN_WINDOW_RE_WRITE:NEAR	; メインウインドウ・再表示

;*;EXTRN	WIDDSP_SAVE:NEAR		; WINDOWS/画面退避
;*;EXTRN	WIDDSP_LOAD:NEAR		; WINDOWS/画面復元
;*;
;*;EXTRN	WIDCCT_INIT:NEAR		; WINDOWS/キャラクタ初期処理
;*;EXTRN	WIDCCT_OPEN:NEAR		; WINDOWS/キャラクタオープン
;*;EXTRN	WIDCCT_CLOSE:NEAR		; WINDOWS/キャラクタクローズ
;*;EXTRN	WIDCCT_CHANGE:NEAR		; WINDOWS/キャラクタチェンジ

EXTRN	TKRSET:NEAR			; 台詞改行のカウンタリセット
EXTRN	WIDTXT:NEAR			; テキストウインドウ

EXTRN	R_SR_FACE_WAIT:NEAR		; フェイスのＷＡＩＴ
EXTRN	R_SR_FACE_IYA_WAIT:NEAR		; フェイスの嫌味ＷＡＩＴ
EXTRN	US_WAIT:NEAR			; ユーザ待ち
EXTRN	TM_WAIT:NEAR			; タイマ待ち

; ****************************************************
;	武芸
;	-I- R_NISSU  : 日数
;	-O- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    KETTEI   : 0=決定,1=考え直す
;
;	    BUGEI_CLASS     : 武芸クラス
;	    BUGEI_PAY       : 学費分割
;	    BUGEI_UP        : 上昇する経験値
;	    BUGEI_HIROU     : 上昇する疲労
;	    KEIKENCH        : 経験値
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
; ****************************************************

R_BUGEI_SET	PROC	NEAR
	MOV	R_KOUMKU,ID_65		; 武芸

;*;	MOVX	R_NISSU,NISSU_BUGEIN	; 日数・武芸
;*NON*;	PR_TXT	"@武芸は"

	CALL	R_BUGEI_UPC		; 武芸クラスＵＰチェック
	CMP	CLASS_UP_FLAG,2		; 0=前と変わらず,1=クラスＵＰ,2=卒業
	JE	R_BUGEI_SET_SOTUGYO	;
	CMP	CLASS_UP_FLAG,1		; 0=前と変わらず,1=クラスＵＰ,2=卒業
	JNE	R_BUGEI_SET_3		;
	PR_TXT	"・・・@おぉ、試合に勝ちましたね"
R_BUGEI_SET_3:				;

;*NON*;	MOV	DX,R_NAISTR		;
;*NON*;	CALL	R_SR_WIDSTR		; 文字列表示
;*NON*;
;*NON*;	MOV	DX,R_SYUTSU		; 出金
;*NON*;	CALL	R_SR_PRICE		; 通貨表示

;*STP*;	SELECT	"決めた,べつのにしよう"
;*STP*;	CMP	WIDSNM,0		; ユーザ選択番号
;*STP*;	JNE	R_BUGEI_SET_YAMERU	;

	MOV	KETTEI,0		; 0=決定
	RET
;*STP*;R_BUGEI_SET_YAMERU:
;*STP*;	PR_TXT	"@武芸はやめよっかな・・・"
;*STP*;	MOV	KETTEI,1		; 1=考え直す
;*STP*;	RET
R_BUGEI_SET_SOTUGYO:
	PR_TXT	"@もう卒業してた。"
	MOV	KETTEI,1		; 1=考え直す
	RET
R_BUGEI_SET	ENDP



; ****************************************************
;	武芸スタート
;	-I- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    R_NISSU  : 日数
;	    KETTEI   : 0=決定,1=考え直す
;
;	-O- BUGEI_CLASS     : 武芸クラス
;	    BUGEI_PAY       : 学費分割
;	    BUGEI_UP        : 上昇する経験値
;	    BUGEI_HIROU     : 上昇する疲労
;	    KEIKENCH        : 経験値
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
; ****************************************************

R_BUGEI_SRT	PROC	NEAR
	CALL	R_BUGEI_UPC		; 武芸クラスＵＰチェック
	CMP	BUGEI_CLASS,CLASS_SOTUGY ; 卒業
	JE	R_BUGEI_SRT_SOTSUGYO	;

	PR_CLS				;
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

	MOV	DX,BUGEI_CLASS		; 武芸クラス1=初級,2=中級,3=上級,4=卒業
	CALL	R_MS_BUGEI_SRT		; 武芸スタート台詞

	MOV	DX,6			; 6=武芸道場
	CALL	WIDEVNT_OPEN		; WINDOWS/イベントウインドウＯＰＥＮ

R_BUGEI_SRT_EXIT:
	RET

R_BUGEI_SRT_SOTSUGYO:
	MOV	DX,BUGEI_CLASS		; 武芸クラス1=初級,2=中級,3=上級,4=卒業
	CALL	R_MS_BUGEI_SRT		; 武芸スタート台詞
	RET
R_BUGEI_SRT	ENDP



; ****************************************************
;	武芸クラスＵＰチェック
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
;	    BUGEI_CLASS     : 武芸クラス
;	    BUGEI_PAY       : 学費分割
;	    BUGEI_UP        : 上昇する経験値
;	    BUGEI_HIROU     : 上昇する疲労
;	    KEIKENCH        : 経験値
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
;	    CLASS_UP_FLAG   : クラスＵＰフラグ
;			      0=前と変わらず,1=クラスＵＰ,2=卒業
; ****************************************************

R_BUGEI_UPC	PROC	NEAR

	; 経験値

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DX,ES:[BX][GTB_KEIKEN][GRP_VALMAX] ; 9. 経験値
	MOV	KEIKENCH,DX		; 経験値

;*;	MOV	DX,ID_19		; 経験値
;*;	CALL	R_SR_IDSTR		; ＩＤ文字列表示
;*;	MOV	DX,KEIKENCH		; 経験値
;*;	CALL	R_SR_POINT		; ポイント表示

	; 合格証でクラスを調べる

	CALL	CLASS_CHK		; 級のチェック


	CMPX	BUGEI_CLASS,CLASS_SHOKYU ; 初級
	JE	R_BUGEI_SET_SHOKYU	;
	CMPX	BUGEI_CLASS,CLASS_CHUKYU ; 中級
	JE	R_BUGEI_SET_CHUKYU	;
	CMPX	BUGEI_CLASS,CLASS_JOHKYU ; 上級
	JE	R_BUGEI_SET_JOHKYU	;
;**;	CMP	BUGEI_CLASS,CLASS_SOTUGY ; 卒業
	JMP	R_BUGEI_UPC_SOTUGYO	;

R_BUGEI_SET_SHOKYU:
	WD_ADRS	ID_72,R_NAISTR		; 初級
	MOV	BUGEI_PAY,PRICE_SHOKYU	; 初級値段
	MOV	BUGEI_UP,UP_SHOKYU	; 初級・経験値ＵＰ
	MOV	BUGEI_HIROU,TIRED_SHOKYU ; 初級・疲労ＵＰ
	JMP	R_BUGEI_SET_YN		;
R_BUGEI_SET_CHUKYU:
	WD_ADRS	ID_73,R_NAISTR		; 中級
	MOV	BUGEI_PAY,PRICE_CHUKYU	; 中級値段
	MOV	BUGEI_UP,UP_CHUKYU	; 中級・経験値ＵＰ
	MOV	BUGEI_HIROU,TIRED_CHUKYU ; 中級・疲労ＵＰ
	JMP	R_BUGEI_SET_YN		;
R_BUGEI_SET_JOHKYU:
	WD_ADRS	ID_74,R_NAISTR		; 上級
	MOV	BUGEI_PAY,PRICE_JOHKYU	; 上級値段
	MOV	BUGEI_UP,UP_JOHKYU	; 上級・経験値ＵＰ
	MOV	BUGEI_HIROU,TIRED_JOHKYU ; 上級・疲労ＵＰ
	JMP	R_BUGEI_SET_YN		;

R_BUGEI_SET_YN:
	CALL	R_WEEKDAY		; 平日が何日あるかの計算
	MOV	BX,SCD_WEEKDAY		; 平日カウンタ
	MOV	AX,BUGEI_PAY		; 学費分割
	MUL	BX			;
	MOV	R_SYUTSU,AX		; 出金
	MOV	R_NYUKIN,0		; 入金

	CMPX	BUGEI_CLASS,BUGEI_CLAS_OLD	; 前の武芸クラス
	JE	R_BUGEI_UPC_NORMAL		;

	CMP	BUGEI_CLAS_OLD,OFFF		; 前の武芸ＯＦＦか？
	JNE	R_BUGEI_UPC_88			;
	MOVX	BUGEI_CLAS_OLD,BUGEI_CLASS	; 前の武芸クラス
	JMP	R_BUGEI_UPC_NORMAL		;
R_BUGEI_UPC_88:					;
	MOVX	BUGEI_CLAS_OLD,BUGEI_CLASS	; 前の武芸クラス
R_BUGEI_UPC_UP:
	MOV	CLASS_UP_FLAG,1			; 1=クラスＵＰ
	RET
R_BUGEI_UPC_SOTUGYO:
	WD_ADRS	ID_74,R_NAISTR			; 上級
	MOV	BUGEI_PAY,PRICE_JOHKYU		; 上級値段
	MOV	BUGEI_UP,UP_JOHKYU		; 上級・経験値ＵＰ
	MOV	BUGEI_HIROU,TIRED_JOHKYU	; 上級・疲労ＵＰ
	MOV	CLASS_UP_FLAG,2			; 2=卒業
	RET
R_BUGEI_UPC_NORMAL:
	MOV	CLASS_UP_FLAG,0			; 0=前と変わらず
	RET
R_BUGEI_UPC	ENDP



; ****************************************************
;	武芸実行
;	-I-   BUGEI_CLASS : 武芸クラス
;	      BUGEI_PAY   : 学費分割
;	      BUGEI_UP    : 上昇する経験値
;	      BUGEI_HIROU : 上昇する疲労
;	      R_KOUMKU     : 項目
;	      R_NAISTR     : 内容文字列（アドレス）
;	-I/O- R_NYUKIN     : 入金
;	      R_SYUTSU     : 出金
; ****************************************************

R_BUGEI_RUN	PROC	NEAR
	CALL	R_SR_DATE_OFF		; 休息日や祝日か？
	CMP	AX,1			; 0=休みではない,1=休み
	JMPEQ	R_BUGEI_RUN_SUNDAY	;

	CMP	BUGEI_CLASS,CLASS_SOTUGY ; 卒業
	JMPEQ	R_BUGEI_RUN_EXIT	;

	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,R_KOUMKU		; 項目
	CALL	R_SR_IDSTR		; ＩＤ文字列表示
	CALL	R_SR_SR_POTU		; "・"
	MOV	DX,R_NAISTR		; 内容文字列（アドレス）
	CALL	R_SR_WIDSTR		; 文字列表示
	CALL	R_SR_SR_KOKA		; "」"

	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	AX,BUGEI_PAY		; 学費分割
	MOV	S_FUNC,8		; 8=支払い
	CALL	R_KEISAN		; 各計算処理
	MOV	BUGEI_FLAG,AX		; 0=武芸しました,2=お金が足りません
	CMP	BUGEI_FLAG,2		;
	JE	R_BUGEI_RUN_NO_MONEY	;

	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	S_FUNC,11		; 11=武芸成功率計算
	CALL	R_KEISAN		; 各計算処理

	MOV	V_SEIKOU,AX		; 成功率

	MOV	DX,AX			; 成功率
	CALL	R_SEIKOU_HANTEI		; 成功判定
	CMP	AX,1			; 1=成功です,0=失敗です
	JE	R_BUGEI_RUN_OK		;

	CALL	WIDFACE_OPEN_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
	MOV	DX,2			; 顔 2=失敗
	CALL	WIDFACE_PUT_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ

	MOV	DX,0			; 経験値　失敗
	CALL	R_MS_BUGEI_DAYS		; 武芸日々台詞

	CALL	TM_WAIT			; タイマ待ち

	CALL	WIDFACE_CLOSE_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	JMP	R_BUGEI_RUN_EXIT	;
R_BUGEI_RUN_OK:				;
	CALL	WIDFACE_OPEN_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
	MOV	DX,1			; 顔 1=成功
	CALL	WIDFACE_PUT_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ

;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;
;*;	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	MOV	DX,BUGEI_UP		; 上昇する経験値
	CALL	R_MS_BUGEI_DAYS		; 武芸日々台詞

	MOV	BX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	DX,BUGEI_UP		; 上昇する経験値
	MOV	CX,BUGEI_HIROU		; 上昇する疲労
	MOV	AX,0			; 学費はもう払っています
	MOV	S_FUNC,12		; 12=武芸パラメータ計算
	CALL	R_KEISAN		; 各計算処理

;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
;*;
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*;
;*;	CALL	R_LEVEL_UP		; レベルＵＰ処理

	CALL	WIDFACE_CLOSE_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	JMP	R_BUGEI_RUN_EXIT	;

R_BUGEI_RUN_NO_MONEY:			;
	SUBX	R_SYUTSU,BUGEI_PAY	; 学費分割

	PR_TXT	"@お金がたりない！？"
;*NON*;	CALL	TM_WAIT			; タイマ待ち＊＊＊＊＊＊＊
	JMP	R_BUGEI_RUN_EXIT	;

R_BUGEI_RUN_SUNDAY:
	CALL	TM_WAIT			; タイマ待ち＊＊＊＊＊＊＊
R_BUGEI_RUN_EXIT:
	RET
R_BUGEI_RUN	ENDP


; ****************************************************
;	武芸決算
;	-I- KEIKENCH : 元の経験値
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
; ****************************************************

R_BUGEI_UPD	PROC	NEAR
	CMP	BUGEI_CLASS,CLASS_SOTUGY ; 卒業
	JMPEQ	R_BUGEI_UPD_SKIP	;

	; 経験値

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DX,ES:[SI][GTB_KEIKEN][GRP_VALMAX]; グラフ最大経験値
	MOV	KEIKENCH_UP,DX		; ＵＰした後の経験値

	MOV	DX,KEIKENCH_UP		; ＵＰした後の経験値
	SUB	DX,KEIKENCH		; 元の経験値
	MOV	CX,R_HEIJITSU		; 平日
	CALL	R_MS_BUGEI_UPD		; 武芸決算台詞

	MOV	SI,BUGEI_CLASS		; 武芸クラス
	MOV	DI,2			; 2=武芸師範
	CALL	WIDFACE_OPEN_W		; WINDOWS/行いフェイスＯＰＥＮ

	CALL	JYOKYU_CHK		; 昇級チェック
	CMP	SHOKYU,0		; 昇級 0=無し
	JMPEQ	R_BUGEI_UPD_NORMAL	;

	MOV	BX,1			; 1=勧誘
	MOV	DX,BUGEI_CLASS		; 武芸クラス
	CALL	R_MS_BUGEI_TST		; 武芸試験台詞

	SELECT	"受験します,やめておきます"
	CMP	WIDSNM,0		; ユーザ選択番号
	JMPNE	R_BUGEI_UPD_YAME	;

	MOV	BX,BUGEI_CLASS		; 武芸クラス
	SHL	BX,1			; word pointer.
	MOVX	BUGEI_TEST_PAY,DS:PRICE_SHIKEN[BX]	; 受験価格

	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	AX,BUGEI_TEST_PAY	; 受験料
	MOV	S_FUNC,8		; 8=支払い
	CALL	R_KEISAN		; 各計算処理
	CMP	AX,2			; 0=支払いしました,2=お金が足りません
	JMPEQ	R_BUGEI_UPD_NO_MONEY	;

	MOV	BX,2			; 2=受験する場合
	MOV	DX,BUGEI_CLASS		; 武芸クラス
	CALL	R_MS_BUGEI_TST		; 武芸試験台詞

	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ

	CALL	BATLEMODE		; バトルモード
	CMP	AX,2			; 1=合格,2=不合格
	JMPEQ	R_BUGEI_UPD_MAKE	;

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
	JE	R_BUGEI_UPD_KACHI_DAKEDO

R_BUGEI_UPD_KACHI:			;
	MOV	BX,6			; 6=勝った場合
	MOV	DX,BUGEI_CLASS		; 武芸クラス
	CALL	R_MS_BUGEI_TST		; 武芸試験台詞
	CALL	SHOGO_ATAERU		; 称号を与える
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
	JMP	R_BUGEI_UPD_EXIT	;
R_BUGEI_UPD_KACHI_DAKEDO:
	MOV	BX,6			; 6=勝った場合
	MOV	DX,BUGEI_CLASS		; 武芸クラス
	CALL	R_MS_BUGEI_TST		; 武芸試験台詞
	PR_WAIT
	PR_TXT "@｢＊＊＊＊＊＊＊＊＊＊@＊＊＊＊＊＊＊＊＊＊」@残念だった‥‥‥"
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_IYA_WAIT	; フェイスの嫌味ＷＡＩＴ
	JMP	R_BUGEI_UPD_EXIT	;

R_BUGEI_UPD_MAKE:			;
					; 5=負けた場合２（ＨＰ８０％未満）
	MOV	BX,4			; 4=負けた場合１（ＨＰ８０％以上）
	MOV	DX,BUGEI_CLASS		; 武芸クラス
	CALL	R_MS_BUGEI_TST		; 武芸試験台詞
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
	JMP	R_BUGEI_UPD_EXIT	;
R_BUGEI_UPD_NO_MONEY:
	PR_TXT	"@お金が足りない！！"
	MOV	BX,3			; 3=受験しない場合
	MOV	DX,BUGEI_CLASS		; 武芸クラス
	CALL	R_MS_BUGEI_TST		; 武芸試験台詞
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_IYA_WAIT	; フェイスの嫌味ＷＡＩＴ
	JMP	R_BUGEI_UPD_EXIT	;
R_BUGEI_UPD_YAME:
	MOV	BX,3			; 3=受験しない場合
	MOV	DX,BUGEI_CLASS		; 武芸クラス
	CALL	R_MS_BUGEI_TST		; 武芸試験台詞
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_IYA_WAIT	; フェイスの嫌味ＷＡＩＴ
	JMP	R_BUGEI_UPD_EXIT	;
R_BUGEI_UPD_NORMAL:
	MOV	BX,7			; 7=なにもないとき
	MOV	DX,BUGEI_CLASS		; 武芸クラス
	CALL	R_MS_BUGEI_TST		; 武芸試験台詞
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
R_BUGEI_UPD_EXIT:
	CALL	WIDFACE_CLOSE_W		; WINDOWS/行いフェイスＣＬＯＳＥ
	CALL	WIDEVNT_CLOSE		; WINDOWS/イベントウインドウＣＬＯＳＥ
R_BUGEI_UPD_SKIP:
	RET
R_BUGEI_UPD	ENDP


; ****************************************************
;	称号を与える
; ****************************************************

SHOGO_ATAERU	PROC	NEAR
	MOV	AX,BUGEI_CLASS		; 武芸クラス
	CMP	AX,CLASS_SHOKYU		; 初級
	JE	SHOGO_ATAERU_1		;
	CMP	AX,CLASS_CHUKYU		; 中級
	JE	SHOGO_ATAERU_2		;
	CMP	AX,CLASS_JOHKYU		; 上級
	JE	SHOGO_ATAERU_3		;
	JMP	SHOGO_ATAERU_EXIT	;

SHOGO_ATAERU_1:
	MOV	DX,ID_117		; 剣士
	CALL	R_SHOGO_TAKE		; 称号を手に入れた
	JMP	SHOGO_ATAERU_EXIT	;
SHOGO_ATAERU_2:
	MOV	DX,ID_118		; 上級剣士
	CALL	R_SHOGO_TAKE		; 称号を手に入れた
	JMP	SHOGO_ATAERU_EXIT	;
SHOGO_ATAERU_3:
	MOV	DX,ID_119		; 剣聖
	CALL	R_SHOGO_TAKE		; 称号を手に入れた
	JMP	SHOGO_ATAERU_EXIT	;
SHOGO_ATAERU_EXIT:
	CALL	WIDHED			; WINDOWS/ヘッダー表示
	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示
	RET
SHOGO_ATAERU	ENDP


; ****************************************************
;	昇級チェック
;	-I- KEIKENCH    : 元の経験値
;	    KEIKENCH_UP : ＵＰした後の経験値
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
;	-O- SHOKYU      : 昇級（0=無し,1=初級試験,2=中級試験,3=上級試験）
; ****************************************************

JYOKYU_CHK	PROC	NEAR
	MOV	SHOKYU,0		; 昇級（0=無し,
					;   1=初級試験,2=中級試験,3=上級試験）

;**;	CALL	CLASS_CHK		; 級のチェック

	CMPX	BUGEI_CLASS,CLASS_SHOKYU ; 初級
	JE	JYOKYU_CHK_SHOKYU	; 初級レベル
	CMPX	BUGEI_CLASS,CLASS_CHUKYU ; 中級
	JMPEQ	JYOKYU_CHK_CHUKYU	; 中級レベル
	CMPX	BUGEI_CLASS,CLASS_JOHKYU ; 上級
	JMPEQ	JYOKYU_CHK_JOHKYU	; 上級レベル
;**;	CMP	BUGEI_CLASS,CLASS_SOTUGY ; 卒業
	JMP	JYOKYU_CHK_EXIT		;


JYOKYU_CHK_SHOKYU:			; 初級レベル
	CMPX	KEIKENCH_UP,LEVEL_SHOKYU ; 初級レベル越えたか？
	JBE	JYOKYU_CHK_EXIT		;

	MOV	SHOKYU,1		; 昇級 1=初級試験
	JMP	JYOKYU_CHK_EXIT		;

JYOKYU_CHK_CHUKYU:			; 中級レベル
	CMPX	KEIKENCH_UP,LEVEL_CHUKYU ; 中級レベル越えたか？
	JBE	JYOKYU_CHK_EXIT		;

	MOV	SHOKYU,2		; 昇級 2=中級試験
	JMP	JYOKYU_CHK_EXIT		;

JYOKYU_CHK_JOHKYU:			; 上級レベル
	CMPX	KEIKENCH_UP,LEVEL_JOHKYU ; 上級レベル越えたか？
	JBE	JYOKYU_CHK_EXIT		;

	MOV	SHOKYU,3		; 昇級 3=上級試験
	JMP	JYOKYU_CHK_EXIT		;

JYOKYU_CHK_EXIT:
	RET
JYOKYU_CHK	ENDP


; ****************************************************
;	級のチェック
;	-O- BUGEI_CLASS    : 武芸クラス
;	    SHIKAKUSHO_HAVE : 持っている合格証書のアイテムＮＯ．
;	    SHIKAKUSHO      : 狙う合格証書のアイテムＮＯ．
;	    SHIKAKUSHO_AD   : 狙う合格証書のアイテムアドレス
; ****************************************************

CLASS_CHK	PROC	NEAR

	; 持物を検索して合格証を持ってるかチェック

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_ITM_MOCHIMON		; 持物アイテム検索

	MOV	BUGEI_CLASS,CLASS_SOTUGY ; 卒業

	; 上級？

	MOV	AX,ID_84		; 武芸上級合格証
	MOV	DX,5			; 種別・5=資格
	CALL	R_ITEM_NMSH		; 名前でアイテム検索

	MOV	SHIKAKUSHO_AD,BX	; 合格証書のアイテムアドレス
	MOV	SHIKAKUSHO_HAVE,DX	; 持っている合格証書のアイテムＮＯ．
	MOV	AX,5			; 種別・5=資格
	CALL	R_ITM_MOTTERU		; 持っているか検索

	CMP	AX,1			; 1=見つかった
	JMPEQ	CLASS_CHK_SET		;

	MOVX	SHIKAKUSHO,SHIKAKUSHO_HAVE ; 合格証書のアイテムＮＯ．

	MOV	BUGEI_CLASS,CLASS_JOHKYU ; 上級

	; 中級？

	MOV	AX,ID_83		; 武芸中級合格証
	MOV	DX,5			; 種別・5=資格
	CALL	R_ITEM_NMSH		; 名前でアイテム検索

	MOV	SHIKAKUSHO_AD,BX	; 合格証書のアイテムアドレス
	MOV	SHIKAKUSHO_HAVE,DX	; 持っている合格証書のアイテムＮＯ．
	MOV	AX,5			; 種別・5=資格
	CALL	R_ITM_MOTTERU		; 持っているか検索

	CMP	AX,1			; 1=見つかった
	JMPEQ	CLASS_CHK_SET		;

	MOVX	SHIKAKUSHO,SHIKAKUSHO_HAVE ; 合格証書のアイテムＮＯ．

	MOV	BUGEI_CLASS,CLASS_CHUKYU ; 中級

	; 初級？

	MOV	AX,ID_82		; 武芸初級合格証
	MOV	DX,5			; 種別・5=資格
	CALL	R_ITEM_NMSH		; 名前でアイテム検索

	MOV	SHIKAKUSHO_AD,BX	; 合格証書のアイテムアドレス
	MOV	SHIKAKUSHO_HAVE,DX	; 持っている合格証書のアイテムＮＯ．
	MOV	AX,5			; 種別・5=資格
	CALL	R_ITM_MOTTERU		; 持っているか検索

	CMP	AX,1			; 1=見つかった
	JMPEQ	CLASS_CHK_SET		;

	MOVX	SHIKAKUSHO,SHIKAKUSHO_HAVE ; 合格証書のアイテムＮＯ．

	MOV	BUGEI_CLASS,CLASS_SHOKYU ; 初級

CLASS_CHK_SET:
CLASS_CHK_EXIT:
	RET
CLASS_CHK	ENDP


; ****************************************************
;	バトルモード
;	-I- BUGEI_CLASS : 武芸クラス
;	-O- AX : 1=合格,2=不合格
; ****************************************************

BATLEMODE	PROC	NEAR
	CMPX	BUGEI_CLASS,CLASS_SHOKYU	; 初級
	JE	BATLEMODE_1			;
	CMPX	BUGEI_CLASS,CLASS_CHUKYU	; 中級
	JE	BATLEMODE_2			;
	CMPX	BUGEI_CLASS,CLASS_JOHKYU	; 上級
	JE	BATLEMODE_3			;

BATLEMODE_1:
	MOV	SHIHAN_CHR_NUM,51		; キャラクタ番号／私の師範
	JMP	BATLEMODE_SRT
BATLEMODE_2:
	MOV	SHIHAN_CHR_NUM,52		; キャラクタ番号／私の師範
	JMP	BATLEMODE_SRT
BATLEMODE_3:
	MOV	SHIHAN_CHR_NUM,53		; キャラクタ番号／私の師範
BATLEMODE_SRT:
	CALL	R_SENTOU_GE_OPEN		; 武芸戦闘・ＯＰＥＮ
	MOV	AX,0				; キャラクタ番号／私の娘
	MOV	BX,SHIHAN_CHR_NUM		; キャラクタ番号／私の師範
	CALL	R_SENTOU_GE			; 武芸戦闘！

	PUSH	AX				;

	CALL	R_SENTOU_GE_CLOSE		; 武芸戦闘・ＣＬＯＳＥ

	CALL	R_MAIN_WINDOW_DSP		; メインウインドウ復帰
	MOV	DX,6				; 6=武芸道場
	CALL	WIDEVNT_OPEN			; WINDOWS/イベントＯＰＥＮ
	MOV	SI,BUGEI_CLASS		; 武芸クラス
	MOV	DI,2				; 2=武芸師範
	CALL	WIDFACE_OPEN_W			; WINDOWS/行いフェイスＯＰＥＮ

	POP	AX				;
	CMP	AX,2				; 1=合格,2=不合格
	JE	BATLEMODE_RAKUDAI		;

BATLEMODE_GOUKAKU:
	MOV	AX,1				; 1=合格
	RET
BATLEMODE_RAKUDAI:
	MOV	AX,2				; 2=不合格
	RET
BATLEMODE	ENDP


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

BUGEI_CLASS	DW	0	; 武芸クラス
BUGEI_PAY	DW	0	; 学費分割
BUGEI_TEST_PAY	DW	0	; 受験料
BUGEI_UP	DW	0	; 上昇する経験値
BUGEI_HIROU	DW	0	; 上昇する疲労
BUGEI_FLAG	DW	0	; 0=武芸しました,2=お金が足りません

BUGEI_CLAS_OLD	DW	OFFF	; 前の武芸クラス

KEIKENCH	DW	0	; 経験値
KEIKENCH_UP	DW	0	; ＵＰした後の経験値

SHIHAN_CHR_NUM	DW	0	; キャラクタ番号／私の師範

CLASS_UP_FLAG	DW	0	; クラスＵＰフラグ
				; 0=前と変わらず,1=クラスＵＰ,2=卒業

SHOKYU		DW	0	; 昇級（0=無し,
				;       1=初級試験,2=中級試験,3=上級試験）

V_SEIKOU	DW	0	; 成功率

SHIKAKUSHO_HAVE	DW	0	; 持っている合格証書のアイテムＮＯ．
SHIKAKUSHO	DW	0	; 合格証書のアイテムＮＯ．
SHIKAKUSHO_AD	DW	0	; 合格証書のアイテムアドレス

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

DATA	ENDS

	END
;
;	end of "R_BUGEI.ASM"
;
