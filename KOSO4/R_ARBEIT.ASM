; "R_ARBEIT.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	アルバイト
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

;*;CCT_OPEN_TYPE	EQU	4	; オープンタイプ
;*;NISSU_ARBEIT		EQU	10	; 日数・アルバイト

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

MOVXBW	MACRO	DEST,SOUR
	MOV	AH,0
	MOV	AL,SOUR
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

PUBLIC	R_ARBEIT_SET		; アルバイトセット
PUBLIC	R_ARBEIT_SRT		; アルバイトスタート
PUBLIC	R_ARBEIT_RUN		; アルバイト実行
PUBLIC	R_ARBEIT_UPD		; アルバイト決算

PUBLIC	R_SEIKOU_HANTEI		; 成功判定

EXTRN	R_MS_ARBT_SRT:NEAR	; アルバイトスタート台詞
EXTRN	R_MS_ARBT_DAYS:NEAR	; アルバイト日々台詞
EXTRN	R_MS_ARBT_UPD:NEAR	; アルバイト決算台詞

EXTRN	R_MS_ARBA_DAME_TXT:NEAR	; ★アルバイトが断られるとき★

EXTRN	R_WEEKDAY:NEAR		; 平日が何日あるかの計算

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	R_WORK_SCH:NEAR		; 行い条件検索
EXTRN	R_WORK_RGET:NEAR	; 行いレコードＧＥＴ

EXTRN	R_GET_SELECT:NEAR	; ｱｲﾃﾑレコード内から選択単語を取り出す
EXTRN	R_ADD_SELECT:NEAR	; 選択単語へ追加
EXTRN	R_ENV_IDNAME:NEAR	; 環境文字のＩＤ検索

EXTRN	RANDAM_100:NEAR		; 乱数１００

EXTRN	WIDSLC_INIT:NEAR	; WINDOWS/セレクト・ウインドウ初期処理
EXTRN	WIDSLC:NEAR		; WINDOWS/セレクト・ウインドウ

EXTRN	R_SR_WORK_HELP:NEAR	; 仕事に対する説明
EXTRN	R_SR_WORK_PAY:NEAR	; 仕事に対する収入

EXTRN	R_SR_DATE_OFF:NEAR	; 休息日や祝日か？

EXTRN	R_SR_PRICE:NEAR		; 通貨表示
EXTRN	R_SR_IDSTR:NEAR		; ＩＤ文字列表示
EXTRN	R_SR_POINT:NEAR		; ポイント表示
EXTRN	R_SR_POINT_H:NEAR	; ポイント半角表示
EXTRN	R_SR_WIDSTR:NEAR	; 文字列表示

EXTRN	R_SR_DATE_NOW:NEAR	; 本日の日付
EXTRN	R_SR_SR_LF:NEAR		; 改行
EXTRN	R_SR_SR_DESU:NEAR	; "です"
EXTRN	R_SR_SR_POTU:NEAR	; "・"
EXTRN	R_SR_SR_PER:NEAR	; "／"
EXTRN	R_SR_SR_KAKO:NEAR	; "「"
EXTRN	R_SR_SR_KOKA:NEAR	; "」"

EXTRN	WIDFACE_INIT:NEAR	; WINDOWS/フェイスウインドウ初期処理
EXTRN	WIDFACE_OPEN_W:NEAR	; WINDOWS/行いフェイスＯＰＥＮ
EXTRN	WIDFACE_CLOSE_W:NEAR	; WINDOWS/行いフェイスＯＰＥＮ

EXTRN	WIDFACE_OPEN_G:NEAR	; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
EXTRN	WIDFACE_CLOSE_G:NEAR	; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ
EXTRN	WIDFACE_PUT_G:NEAR	; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＰＵＴ

EXTRN	WIDDSP_SV_WD:NEAR	; WINDOWS/ワイドアイテム退避
EXTRN	WIDDSP_LD_WD:NEAR	; WINDOWS/ワイドアイテム復元

EXTRN	WIDEVNT_INIT:NEAR	; WINDOWS/イベントウインドウ初期処理
EXTRN	WIDEVNT_OPEN:NEAR	; WINDOWS/イベントウインドウＯＰＥＮ
EXTRN	WIDEVNT_CLOSE:NEAR	; WINDOWS/イベントウインドウＣＬＯＳＥ
EXTRN	WIDEVNT_OPEN_W:NEAR	; WINDOWS/行いイベントＯＰＥＮ
EXTRN	WIDEVNT_CLOSE_W:NEAR	; WINDOWS/行いイベントＣＬＯＳＥ

EXTRN	WIDITEM_CLEAR:NEAR	; WINDOWS/アイテム表示設定クリア

EXTRN	WIDWORKS_OPEN:NEAR	; WINDOWS/行い（おこない）オープン
EXTRN	WIDWORKS_CLOSE:NEAR	; WINDOWS/行い（おこない）クローズ

EXTRN	WIDTXT:NEAR		; テキストウインドウ

EXTRN	WIDHED:NEAR		; WINDOWS/ヘッダー表示
EXTRN	WIDPROP_ALL:NEAR	; WINDOWS/プロポ・ウインドウ全表示

;*;EXTRN	WIDDSP_SAVE:NEAR	; WINDOWS/画面退避
;*;EXTRN	WIDDSP_LOAD:NEAR	; WINDOWS/画面復元
;*;
;*;EXTRN	WIDCCT_INIT:NEAR	; WINDOWS/キャラクタ初期処理
;*;EXTRN	WIDCCT_OPEN:NEAR	; WINDOWS/キャラクタオープン
;*;EXTRN	WIDCCT_CLOSE:NEAR	; WINDOWS/キャラクタクローズ
;*;EXTRN	WIDCCT_CHANGE:NEAR	; WINDOWS/キャラクタチェンジ

EXTRN	BYTE_TBL_SCH:NEAR		; バイトテーブルサーチ

EXTRN	R_SR_FACE_WAIT:NEAR		; フェイスのＷＡＩＴ
EXTRN	R_SR_FACE_IYA_WAIT:NEAR		; フェイスの嫌味ＷＡＩＴ
EXTRN	US_WAIT:NEAR			; ユーザ待ち
EXTRN	TM_WAIT:NEAR			; タイマ待ち



; ****************************************************
;	アルバイト
;	-I- R_NISSU  : 日数
;	-O- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    R_NISSU  : 日数
;	    KETTEI   : 0=決定,1=考え直す
; ****************************************************

R_ARBEIT_SET	PROC	NEAR
	MOV	R_KOUMKU,ID_70		; アルバイト

;*STP*;	PR_CLS
;*STP*;	PR_TXT	"@アルバイト、どれにしますか？"

	CALL	WIDDSP_SV_WD		; WINDOWS/ワイドアイテム退避

R_ARBEIT_SET_RETRY:
	CALL	WORK_SELECT		; アルバイト選択
	CALL	DISP_GYOU_S		; 行い（おこない）表示・お仕事

	CALL	WIDSLC			; WINDOWS/セレクト・ウインドウ
	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JMPEQ	R_ARBEIT_SET_YAMERU	;
	MOV	DX,ATMMAX		; 表示単語の数
	DEC	DX			;
	CMP	WIDSNM,DX		;「やりなおし」
	JMPEQ	R_ARBEIT_SET_YAMERU	;

	MOV	BX,WIDSNM		; ユーザ選択番号
	SHL	BX,1			;

	MOVX	R_NAIYOU,DS:K_TBL_REC[BX] ; 検索レコードテーブル

	MOV	SI,DS:K_TBL_OFSET[BX]	; お仕事のアドレス
	MOV	ES,SEGWID		;
	MOVX	R_NAISTR,ES:[SI][WRK_NAME] ; 0.仕事名
	MOVX	R_NYUKIN,ES:[SI][WRK_PAY]  ; 1.バイト料
	MOV	R_SYUTSU,0		; 出金
;*;	MOV	R_NISSU,NISSU_ARBEIT	; 日数・アルバイト

	CALL	FUMFUM			; ふむふむ

	CMP	KETTEI,1		; 1=考え直す
	JMPEQ	R_ARBEIT_SET_RETRY	;

;*;	PR_CLS

	CALL	R_WEEKDAY		; 平日が何日あるかの計算
	MOV	BX,SCD_WEEKDAY		; 平日カウンタ
	MOV	AX,R_NYUKIN		; 入金
	MUL	BX			;
	MOV	R_NYUKIN,AX		; 入金

	CALL	WIDDSP_LD_WD		; WINDOWS/ワイドアイテム復元
	MOV	KETTEI,0		; 0=決定
	RET
R_ARBEIT_SET_YAMERU:
	CALL	WIDDSP_LD_WD		; WINDOWS/ワイドアイテム復元
	MOV	KETTEI,1		; 1=考え直す
	RET
R_ARBEIT_SET	ENDP



; ****************************************************
;	ふむふむ
;	-I- WIDSNM   : ユーザ選択番号
;	-O- KETTEI   : 0=決定,1=考え直す
; ****************************************************

FUMFUM	PROC	NEAR
;*STP*;	PR_CLS
	PR_TXT	"@「"
	MOVX	WDTXTSEG,SEGWID			; 表示文字列セグメント
	MOVX	WDTXTADR,R_NAISTR		; 表示文字列アドレス
	CALL	WIDTXT				; テキストウインドウ
	PR_TXT	"、"
	MOV	SI,WIDSNM			; ユーザ選択番号
	SHL	SI,1				; word pointer.
	MOVX	R_SR_ITM_ADRS,DS:K_TBL_OFSET[SI] ; 何を買うか（アドレス）
	CALL	R_SR_WORK_HELP			; 仕事に対する説明
	PR_TXT	"、バイト料は"
	CALL	R_SR_WORK_PAY			; 仕事に対する収入
	PR_TXT	"」@"

;*STP*;	SELECT	"決めた,べつのにしよう"
;*STP*;	CMP	WIDSNM,0			; ユーザ選択番号
;*STP*;	JNE	FUMFUM_YAME			;

	MOV	KETTEI,0			; 0=決定
	RET
;*STP*;FUMFUM_YAME:
;*STP*;	PR_TXT	"ほかは？"
;*STP*;	MOV	KETTEI,1			; 1=考え直す
;*STP*;	RET
FUMFUM	ENDP



; ****************************************************
;	アルバイト選択
;
;	最後に「やりなおし」を付け加えます。
;
;	-O- ATMSEG   : テキストバッファセグメント
;	    ATMMAX   : 表示単語の数
;	    ATMTBL[] : 表示単語アドレス
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_OFSET[] : 検索レコードｵﾌｾｯﾄテーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

WORK_SELECT	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	AX,ES:[BX][VTB_NENREI][VAL_VALUE] ; 4. 年齢
	MOV	DX,0			; 行い種別
	CALL	R_WORK_SCH		; 行い条件検索

	MOV	BX,0			; 何ワード目か
	CALL	R_GET_SELECT	; ｱｲﾃﾑレコード内から選択文字アドレスを取り出す

	WD_ADRS	ID_109,DX		; やりなおし(DX=文字アドレス(ATMSEG内))
	CALL	R_ADD_SELECT		; 選択単語へ追加

	RET
WORK_SELECT	ENDP


; ****************************************************
;	行い（おこない）表示・お仕事
; ****************************************************

DISP_GYOU_S	PROC	NEAR
	CALL	WIDITEM_CLEAR		; WINDOWS/アイテム表示設定クリア

	MOV	REC_NO,0
DISP_GYOU_S_LOOP:
	CMPX	REC_NO,K_TBL_MAX	; 検索レコード数
	JGE	DISP_GYOU_S_LOOP_E	;
	MOV	BX,REC_NO		; レコード番号
	SHL	BX,1			; word pointer.
	MOV	CX,DS:K_TBL_REC[BX]	; 検索レコードテーブル
	MOV	DX,0			; 種別
	CALL	WIDWORKS_OPEN		; WINDOWS/行い（おこない）オープン
	CMP	AX,0			; 0=正常
	JNE	DISP_GYOU_S_LOOP_E	;

	INC	REC_NO			; レコード番号
	JMP	DISP_GYOU_S_LOOP
DISP_GYOU_S_LOOP_E:
	RET
DISP_GYOU_S	ENDP


; ****************************************************
;	アルバイトスタート
;	-I-   R_KOUMKU : 項目
;	      R_NAISTR : 内容文字列（バイト名）
;	      R_NAIYOU : 内容値（レコード番号）
;	-O-   FLAG_FURYOU : フラグ・不良はおことわり=1
; ****************************************************

R_ARBEIT_SRT	PROC	NEAR
	CALL	PARA_GET		; パラメータＧＥＴ
	CMP	AX,1			; 0=正常,1=エラー
	JMPEQ	R_ARBEIT_SRT_EXIT	;

	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,U_NAME		; 0.仕事名
	CALL	R_SR_WIDSTR		; 文字列表示
	CALL	R_SR_SR_KOKA		; "」"

	CALL	ARBA_START_FACE		; アルバイト・フェイス始め

	MOV	CNT_SHIPPAI,0		; 失敗カウンタ
	MOV	CNT_KASEGI,0		; 稼ぎカウンタ

R_ARBEIT_SRT_EXIT:
	RET
R_ARBEIT_SRT	ENDP


; ****************************************************
;	アルバイト決算
;	-I-   R_KOUMKU : 項目
;	      R_NAISTR : 内容文字列（バイト名）
;	      R_NAIYOU : 内容値（レコード番号）
;	      FLAG_FURYOU : フラグ・不良はおことわり=1
; ****************************************************

R_ARBEIT_UPD	PROC	NEAR
	CMP	FLAG_FURYOU,1		; フラグ・不良はおことわり=1
	JE	R_ARBEIT_UPD_EXIT	;

	CALL	PARA_GET		; パラメータＧＥＴ
	CMP	AX,1			; 0=正常,1=エラー
	JMPEQ	R_ARBEIT_UPD_EXIT	;

	PR_CLS
	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,U_NAME		; 0.仕事名
	CALL	R_SR_WIDSTR		; 文字列表示
	CALL	R_SR_SR_KOKA		; "」"
	PR_TXT	"の仕事は終わった。"
	CALL	ARBA_END_FACE		; アルバイト・フェイス終り

R_ARBEIT_UPD_EXIT:
	RET
R_ARBEIT_UPD	ENDP


; ****************************************************
;	アルバイト実行
;	-I-   R_KOUMKU : 項目
;	      R_NAISTR : 内容文字列（バイト名）
;	      R_NAIYOU : 内容値（レコード番号）
;	      FLAG_FURYOU : フラグ・不良はおことわり=1
;	-I/O- R_NYUKIN : 入金
;	      R_SYUTSU : 出金
; ****************************************************

R_ARBEIT_RUN	PROC	NEAR
	CALL	R_SR_DATE_OFF		; 休息日や祝日か？
	CMP	AX,1			; 0=休みではない,1=休み
	JMPEQ	R_ARBEIT_RUN_SUNDAY	;

	CMP	FLAG_FURYOU,1		; フラグ・不良はおことわり=1
	JMPEQ	R_ARBEIT_RUN_FURYOUKA	;

	CALL	PARA_GET		; パラメータＧＥＴ
	CMP	AX,1			; 0=正常,1=エラー
	JMPEQ	R_ARBEIT_RUN_ERROR	;

	PR_LF
	CALL	R_SR_SR_KAKO		; "「"
	MOV	DX,U_NAME		; 0.仕事名
	CALL	R_SR_WIDSTR		; 文字列表示
	CALL	R_SR_SR_KOKA		; "」"

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	BX,PARA_ADRS		; 行いパラメータアドレス
	MOV	S_FUNC,2		; 2=アルバイト成功率計算
	CALL	R_KEISAN		; 各計算処理

	MOV	V_SEIKOU,AX		; 成功率

	CALL	SEIKOU_HANTEI		; 成功判定
	CMP	AX,1			; 1=成功です,0=失敗です
	JE	R_ARBEIT_RUN_OK		;

	CALL	WIDFACE_OPEN_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
	MOV	DX,2			; 顔 2=失敗
	CALL	WIDFACE_PUT_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ

	MOV	AX,2			; ミスフラグ 1=成功,2=ミス！
	MOV	BX,U_NAME		; 0.仕事名
	CALL	R_MS_ARBT_DAYS		; アルバイト日々台詞

	INC	CNT_SHIPPAI		; 失敗カウンタ

	SUBX	R_NYUKIN,U_PAY		; バイト料が１日分減る

	CALL	TM_WAIT			; タイマ待ち

	WD_CMP	ID_55,U_NAME		; 0.仕事名  教会
	JE	R_ARBEIT_RUN_OK_22	;

	CALL	WIDFACE_CLOSE_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	JMP	R_ARBEIT_RUN_EXIT	;

R_ARBEIT_RUN_OK_22:
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,1			; 変動するモラル
	MOV	S_FUNC,57		; 57=モラル計算
	CALL	R_KEISAN		; 各計算処理

	CALL	WIDFACE_CLOSE_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	JMP	R_ARBEIT_RUN_EXIT	;
R_ARBEIT_RUN_OK:
	CALL	WIDFACE_OPEN_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＯＰＥＮ
	MOV	DX,1			; 顔 1=成功
	CALL	WIDFACE_PUT_G		; WINDOWS/ＧＩＲＬｳｲﾝドｳ成功失敗ＰＵＴ

;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;
;*;	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	PR_TXT	"@今日のお仕事は大成功☆"

	CALL	TM_WAIT			; タイマ待ち

;*;	MOV	AX,1			; ミスフラグ 1=成功,2=ミス！
;*;	MOV	BX,U_NAME		; 0.仕事名
;*;	CALL	R_MS_ARBT_DAYS		; アルバイト日々台詞

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,PARA_ADRS		; 行いパラメータアドレス
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	S_FUNC,3		; 3=アルバイトパラメータ計算
	CALL	R_KEISAN		; 各計算処理

	INC	CNT_KASEGI		; 稼ぎカウンタ

;*;	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
;*;	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
;*;
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元

	CALL	WIDFACE_CLOSE_G		; WINDOWS/GIRLｳｲﾝドｳ成功失敗ＣＬＯＳＥ

	JMP	R_ARBEIT_RUN_EXIT	;

R_ARBEIT_RUN_SUNDAY:
	CALL	TM_WAIT			; タイマ待ち
R_ARBEIT_RUN_EXIT:
	RET
R_ARBEIT_RUN_FURYOUKA:
	RET
R_ARBEIT_RUN_ERROR:
	PR_TXT	"シゴトシタクナーイ！！"
	RET
R_ARBEIT_RUN	ENDP



; ****************************************************
;	成功判定
;	-I- DX : 成功率
;	-O- AX : 1=成功です,0=失敗です
; ****************************************************

R_SEIKOU_HANTEI	PROC	NEAR
	MOV	V_SEIKOU,DX		; 成功率
	CALL	SEIKOU_HANTEI		; 成功判定
	RET
R_SEIKOU_HANTEI	ENDP



; ****************************************************
;	成功判定
;	-I- V_SEIKOU : 成功率
;	-O- AX       : 1=成功です,0=失敗です
;	    V_SAIKORO: サイコロ
; ****************************************************

SEIKOU_HANTEI	PROC	NEAR
;*;	PR_TXT	"@成功率:"

	CALL	RANDAM_100		; 乱数１００
	MOV	V_SAIKORO,AX		; サイコロ

;*;	MOV	DX,V_SAIKORO		; サイコロ
;*;	CALL	R_SR_POINT_H		; ポイント半角表示
;*;	CALL	R_SR_SR_PER		; "／"
;*;	MOV	DX,V_SEIKOU		; 成功率
;*;	CALL	R_SR_POINT_H		; ポイント半角表示


	CMPX	V_SEIKOU,V_SAIKORO	; 成功率 サイコロ
	JL	SEIKOU_HANTEI_OH_MY_GOT	;

SEIKOU_HANTEI_OK:
;*;	PR_TXT	"○"
	MOV	AX,1			; 1=成功です
	RET
SEIKOU_HANTEI_OH_MY_GOT:
;*;	PR_TXT	"×"
	MOV	AX,0			; 0=失敗です
	RET
SEIKOU_HANTEI	ENDP


; ****************************************************
;	パラメータＧＥＴ
;	-I- R_NAIYOU : 内容値（レコード番号）
;	-O- PARA_ADRS: パラメータアドレス
;	    AX       : 0=正常,1=エラー
; ****************************************************

PARA_GET	PROC	NEAR
	MOV	DX,0			; 種別・0=仕事
	MOV	CX,R_NAIYOU		; 内容値（レコード番号）
	CALL	R_WORK_RGET		; 行いレコードＧＥＴ
	CMP	AX,1			; 0=正常,1=レコード番号が範囲外
	JE	PARA_GET_ERROR		;

	MOV	PARA_ADRS,BX		; パラメータアドレス

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント

	MOVX	U_NAME,ES:[BX]		; 0.仕事名
	MOVX	U_PAY ,ES:[BX][2]	; 1.バイト料
	MOVX	U_KIND,ES:[BX][4]	; 2.修正能力
	MOVX	U_KKA1,ES:[BX][6]	; 3.効果１
	MOVX	U_VAL1,ES:[BX][8]	; 4.加減値
	MOVX	U_KKA2,ES:[BX][10]	; 5.効果２
	MOVX	U_VAL2,ES:[BX][12]	; 6.加減値
	MOVX	U_KKA3,ES:[BX][14]	; 7.効果３
	MOVX	U_VAL3,ES:[BX][16]	; 8.加減値
	MOVX	U_KKA4,ES:[BX][18]	; 9.効果４
	MOVX	U_VAL4,ES:[BX][20]	; 10.加減値
	MOVX	U_KKA5,ES:[BX][22]	; 11.効果５
	MOVX	U_VAL5,ES:[BX][24]	; 12.加減値
	MOVX	U_AGE ,ES:[BX][26]	; 13.年齢制限
	MOVX	U_HELP,ES:[BX][28]	; 14.説明

	MOV	AX,0			; 0=正常
	RET
PARA_GET_ERROR:
	MOV	AX,1			; 1=エラー
	RET
PARA_GET	ENDP


; ****************************************************
;	アルバイト・フェイス始め
;	-I- U_NAME : 0.仕事名
;	-O- FLAG_FURYOU : フラグ・不良はおことわり=1
; ****************************************************

ARBA_START_FACE	PROC	NEAR
	MOV	FLAG_FURYOU,0		; フラグ・不良はおことわり=1

	CALL	ARB_TABLE_SCH		; アルバイト・テーブルサーチ

	MOV	SI,ARBA_FCE_NUM		; 見つかったフェイス番号
	MOV	DI,5			; 種類 5=アルバイトの雇主
	CALL	WIDFACE_OPEN_W		; WINDOWS/行いフェイスＯＰＥＮ

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,0			; Ｉ／Ｏ 0:読み出し,1:書き込み
	MOV	S_FUNC,41		; 41=ヘッダーフラグのＩ／Ｏ
	CALL	R_KEISAN		; 各計算処理
	TEST	DX,FLAGS_HIKOU		; bit13 : 非行化
	JNZ	ARBA_START_FACE_DAME	;

	MOV	BX,U_NAME		; 0.仕事名
	CALL	R_MS_ARBT_SRT		; アルバイトスタート台詞

;*;	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ

ARBA_START_FACE_33:			;
	CALL	WIDFACE_CLOSE_W		; WINDOWS/行いフェイスＣＬＯＳＥ

	MUSIC	KYOKU_ARBEIT		; ｱﾙバｲﾄ

	MOV	DX,ARBA_FCE_NUM		; 見つかったフェイス番号
	CALL	WIDEVNT_OPEN_W		; WINDOWS/行いイベントＯＰＥＮ

	RET
ARBA_START_FACE_DAME:
	MOV	BX,U_NAME		; 0.仕事名
	CALL	R_MS_ARBA_DAME_TXT	; ★アルバイトが断られるとき★
	CMP	DX,1			; フラグ・不良でもアルバイトＯＫだよ=1
	JE	ARBA_START_FACE_33	;

	CALL	MUSIC_KOSODATE		; 子育てのテーマ

	MOV	FLAG_FURYOU,1		; フラグ・不良はおことわり=1

	CALL	R_SR_FACE_IYA_WAIT	; フェイスの嫌味ＷＡＩＴ
;*;	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ

	CALL	WIDFACE_CLOSE_W		; WINDOWS/行いフェイスＣＬＯＳＥ
	RET
ARBA_START_FACE	ENDP


; ****************************************************
;	アルバイト・フェイス終り
;	-I- U_NAME : 0.仕事名
; ****************************************************

ARBA_END_FACE	PROC	NEAR
	CALL	ARB_TABLE_SCH		; アルバイト・テーブルサーチ

	MOV	SI,ARBA_FCE_NUM		; 見つかったフェイス番号
	MOV	DI,5			; 種類 5=アルバイトの雇主
	CALL	WIDFACE_OPEN_W		; WINDOWS/行いフェイスＯＰＥＮ

	CMP	CNT_SHIPPAI,0		; 失敗カウンタ
	JNE	ARBA_END_FACE_2		;

	CALL	IKAGAWA_CHK		; いかがわしい仕事かチェック
	CMP	AX,2			; 1=普通,2=いかがわしい
	JE	ARBA_END_FACE_1		;

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,7			; 7=アルバイトパーフェクト賞
	MOV	CX,0			;
	MOV	S_FUNC,72		; 72=収穫祭等の評価
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,1			; ミスフラグ 1=成功
	JMP	ARBA_END_FACE_3		;
ARBA_END_FACE_1:			;
	MOV	AX,1			; ミスフラグ 1=成功
	JMP	ARBA_END_FACE_3		;
ARBA_END_FACE_2:			;
	MOV	AX,2			; ミスフラグ 2=ミス！
ARBA_END_FACE_3:			;
	MOV	BX,U_NAME		; 0.仕事名
	MOV	DX,R_NYUKIN		; 稼いだお金
	MOV	CX,CNT_KASEGI		; 稼ぎカウンタ 稼いだ日数
	CALL	R_MS_ARBT_UPD		; アルバイト決算台詞

	CMP	CNT_SHIPPAI,0		; 失敗カウンタ
	JNE	ARBA_END_FACE_5		;
	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示
ARBA_END_FACE_5:			;

	CMP	CNT_SHIPPAI,0		; 失敗カウンタ
	JNE	ARBA_END_FACE_7		;
	CALL	R_SR_FACE_WAIT		; フェイスのＷＡＩＴ
	JMP	ARBA_END_FACE_8		;
ARBA_END_FACE_7:
	CALL	R_SR_FACE_IYA_WAIT	; フェイスの嫌味ＷＡＩＴ
ARBA_END_FACE_8:

	CALL	WIDFACE_CLOSE_W		; WINDOWS/行いフェイスＯＰＥＮ

	CALL	WIDEVNT_CLOSE_W		; WINDOWS/行いイベントＣＬＯＳＥ
	RET
ARBA_END_FACE	ENDP


; ****************************************************
;	いかがわしい仕事かチェック
;	-I- U_NAME : 0.仕事名
;	-O- AX     : 1=普通,2=いかがわしい
; ****************************************************

IKAGAWA_CHK	PROC	NEAR
	WD_CMP	ID_58,U_NAME		; あやしい宿屋
	JE	IKAGAWA_CHK_IKA		;
	WD_CMP	ID_59,U_NAME		; あやしい酒場
	JE	IKAGAWA_CHK_IKA		;

	MOV	AX,1			; 1=普通
	RET
IKAGAWA_CHK_IKA:
	MOV	AX,2			; 2=いかがわしい
	RET
IKAGAWA_CHK	ENDP


; ****************************************************
;	アルバイト・テーブルサーチ
;	-I- U_NAME   : 0.仕事名
;	-O- ARBA_SCH : 見つかった対応表番号
;	    ARBA_FCE_NUM : 見つかったフェイス番号
; ****************************************************

ARB_TABLE_SCH	PROC	NEAR
	MOV	BX,U_NAME		; 0.仕事名
	CALL	R_ENV_IDNAME		; 環境文字のＩＤ検索
	CMP	AX,0			; 0=見つからない
	JE	ARBA_FACE_EXIT		;
					; DX=ＩＤ
	MOVX	ES,DS			;
	MOV	DI,OFFSET ARBA_ID_TBL	; アルバイトＩＤ対応表
	CALL	BYTE_TBL_SCH		; バイトテーブルサーチ
	CMP	AX,0			; 0=見つからない
	JE	ARBA_FACE_EXIT		;

	MOV	ARBA_SCH,CX		; 見つかった対応表番号

	; アルバイトフェイス番号対応表

	MOV	BX,CX			;
	MOVXBW	ARBA_FCE_NUM,DS:ARBA_FCE_NO_TBL[BX]

ARBA_FACE_EXIT:
	RET
ARB_TABLE_SCH	ENDP



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

EXTRN	SCD_WEEKDAY:WORD		; 平日カウンタ

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

CNT_KASEGI	DW	0	; 稼ぎカウンタ
CNT_SHIPPAI	DW	0	; 失敗カウンタ

V_SEIKOU	DW	0	; 成功率
V_SAIKORO	DW	0	; サイコロ

PARA_ADRS	DW	0	; パラメータアドレス

U_NAME		DW	0	; 0.仕事名
U_PAY		DW	0	; 1.バイト料
U_KIND		DW	0	; 2.修正能力
U_KKA1		DW	0	; 3.効果１
U_VAL1		DW	0	; 4.加減値
U_KKA2		DW	0	; 5.効果２
U_VAL2		DW	0	; 6.加減値
U_KKA3		DW	0	; 7.効果３
U_VAL3		DW	0	; 8.加減値
U_KKA4		DW	0	; 9.効果４
U_VAL4		DW	0	; 10.加減値
U_KKA5		DW	0	; 11.効果５
U_VAL5		DW	0	; 12.加減値
U_AGE		DW	0	; 13.年齢制限
U_HELP		DW	0	; 14.説明

;	変動グラフテーブル

GRAP1		DW	0	; 変動グラフ１
GRAP2		DW	0	; 変動グラフ２
GRAP3		DW	0	; 変動グラフ３
GRAP4		DW	0	; 変動グラフ４
GRAP5		DW	0	; 変動グラフ５

;	アルバイトフェイステーブル

ARBA_SCH	DW	0	; 見つかった対応表番号
ARBA_ID_TBL	LABEL	BYTE	; アルバイトＩＤ対応表
	DB	12		; テーブルサイズ
	DB	ID_52		;1 宿屋
	DB	ID_53		;2 酒屋
	DB	ID_54		;3 武器屋
	DB	ID_55		;4 教会
	DB	ID_56		;5 メイド
	DB	ID_57		;6 医者
	DB	ID_58		;7 あやしい宿屋
	DB	ID_59		;8 あやしい酒場
	DB	ID_60		;9 代筆屋
	DB	ID_61		;10 狩人
	DB	ID_62		;11 木コリ
	DB	ID_63		;12 人足

ARBA_FCE_NUM	DW	0	; 見つかったフェイス番号
ARBA_FCE_NO_TBL	LABEL	BYTE	; アルバイトフェイス番号対応表
	DB	12		; テーブルサイズ
	DB	1		;1	1=宿屋
	DB	4		;2	4=酒場１
	DB	7		;3	7=武器屋
	DB	10		;4	10=教会
	DB	2		;5	2=メイド
	DB	5		;6	5=医者
	DB	8		;7	8=宿屋２
	DB	11		;8	11=酒場２
	DB	3		;9	3=代筆屋
	DB	6		;10	6=狩人
	DB	9		;11	9=木コリ
	DB	12		;12	12=人足

	EVEN
FLAG_FURYOU	DW	0	; フラグ・不良はおことわり=1

REC_NO		DW	0	; レコード番号

DATA	ENDS

	END
;
;	end of "R_ARBEIT.ASM"
;
