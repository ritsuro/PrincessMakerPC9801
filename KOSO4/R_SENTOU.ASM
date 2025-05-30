; "R_SENTOU.ASM" PC-9801UV11 make by R.H 1990/11/29
;
;
;	「子育て」
;
;	戦闘！／デモ版
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

CCT_OPEN_TYP_MY	EQU	5	; オープンタイプ・私
CCT_OPEN_TYP_TK	EQU	6	; オープンタイプ・敵

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

;*;PUBLIC R_SENTOU			; 戦闘！

PUBLIC	R_SENTOU_GE_OPEN		; 武芸戦闘・ＯＰＥＮ
PUBLIC	R_SENTOU_GE			; 武芸戦闘！
PUBLIC	R_SENTOU_GE_CLOSE		; 武芸戦闘・ＣＬＯＳＥ

PUBLIC	R_SENTOU_BU_LOAD		; 武闘会戦闘・先行ロード
PUBLIC	R_SENTOU_BU_OPEN		; 武闘会戦闘・ＯＰＥＮ
PUBLIC	R_SENTOU_BU			; 武闘会戦闘！
PUBLIC	R_SENTOU_BU_CLOSE		; 武闘会戦闘・ＣＬＯＳＥ

PUBLIC	R_SENTOU_MS_LOAD		; 武者修行・先行ロード
PUBLIC	R_SENTOU_MS_OPEN		; 武者修行・ＯＰＥＮ
PUBLIC	R_SENTOU_MS			; 武者修行戦闘！
PUBLIC	R_SENTOU_MS_CLOSE		; 武者修行・ＣＬＯＳＥ

PUBLIC	R_LEVEL_UP			; レベルＵＰ処理
PUBLIC	R_SENTOU_MSG			; 敵好メッセージ

EXTRN	R_MAGIC_ARU:NEAR		; 所有魔法ある？
EXTRN	R_MAGIC_LIST:NEAR		; 所有魔法リスト
EXTRN	R_ENV_IDNAME:NEAR		; 環境文字のＩＤ検索

EXTRN	R_KEISAN:NEAR			; 各計算処理

EXTRN	R_SOUBI_S_DOUGU:NEAR		; 戦闘時・道具の使用

EXTRN	R_SR_SR_KAKO:NEAR		; "「"
EXTRN	R_SR_SR_KOKA:NEAR		; "」"
EXTRN	R_SR_SR_WA:NEAR			; "は"
EXTRN	R_SR_DOSURU:NEAR		; "どうする？"

EXTRN	R_SR_BATLE_KEIKEN:NEAR		; 経験値ｍを得た。
EXTRN	R_SR_BATLE_OKANE:NEAR		; お金ｍを得た。

EXTRN	R_SR_YOIDESUKA:NEAR		; よいですか

EXTRN	R_MS_BUTOH:NEAR			; 武闘会メッセージ
EXTRN	R_MS_MESSAGE:NEAR		; その他メッセージ

EXTRN	RANDAM_100:NEAR			; 乱数１００
EXTRN	RANDAM_200:NEAR			; 乱数２００
EXTRN	RANDAM_CX:NEAR			; 乱数範囲指定

EXTRN	WIDALLOC_MY_GIRL:NEAR		; WINDOWS/キャラクタ・データ結合
EXTRN	WIDALLOC_TEKICHR:NEAR		; WINDOWS/敵キャラクタ・データ結合

EXTRN	WIDDSP_SV_H:NEAR		; WINDOWS/画面範囲退避
EXTRN	WIDDSP_LD_H:NEAR		; WINDOWS/画面範囲復元

EXTRN	WIDDSP_SV_F:NEAR		; WINDOWS/画面フル退避
EXTRN	WIDDSP_LD_F:NEAR		; WINDOWS/画面フル復元

EXTRN	WIDCCT_INIT:NEAR		; WINDOWS/キャラクタ初期処理
EXTRN	WIDCCT_OPEN:NEAR		; WINDOWS/キャラクタオープン
EXTRN	WIDCCT_CLOSE:NEAR		; WINDOWS/キャラクタクローズ
EXTRN	WIDCCT_CHANGE:NEAR		; WINDOWS/キャラクタチェンジ

EXTRN	WIDHED_INIT:NEAR		; WINDOWS/ヘッダー初期処理
EXTRN	WIDHED:NEAR			; WINDOWS/ヘッダー表示
EXTRN	WIDHED_D_HP:NEAR		; WINDOWS/ヘッダ・ＨＰ表示
EXTRN	WIDHED_RELOC:NEAR		; WINDOWS/ヘッダー位置変更
EXTRN	WIDHED_CAL:NEAR			; WINDOWS/ヘッダー位置変更・計算のみ
EXTRN	WIDHED_C_SEIZA:NEAR		; WINDOWS/星座チェック

EXTRN	WIDHBR_INIT:NEAR		; WINDOWS/横グラフ初期処理
EXTRN	WIDHBR:NEAR			; WINDOWS/横グラフ表示
EXTRN	WIDHBRS:NEAR			; WINDOWS/横グラフ再表示
EXTRN	WIDHBRSN:NEAR			; WINDOWS/横グラフ再表示（ﾌﾞﾘﾝｸなし）
EXTRN	WIDHBR_MAX:NEAR			; WINDOWS/横グラフ最大表示
EXTRN	WIDHBR_RELOC:NEAR		; WINDOWS/横グラフ位置変更

EXTRN	WIDFUKI_INIT:NEAR		; WINDOWS/ふきだしウインドウ初期処理
EXTRN	WIDFUKI:NEAR			; WINDOWS/ふきだしウインドウ
EXTRN	WIDFUKI_OPEN:NEAR		; WINDOWS/ふきだしウインドウＯＰＥＮ
EXTRN	WIDFUKI_CLOSE:NEAR		; WINDOWS/ふきだしウインドウＣＬＯＳＥ

EXTRN	WIDTXT_INIT:NEAR		; WINDOWS/テキストウインドウ初期処理
EXTRN	WIDTXT:NEAR			; WINDOWS/テキストウインドウ
EXTRN	WIDTXT_OPEN:NEAR		; WINDOWS/テキストウインドウＯＰＥＮ
EXTRN	WIDTXT_CLOSE:NEAR		; WINDOWS/テキストウインドウＣＬＯＳＥ
EXTRN	WIDTXT_RELOC:NEAR		; WINDOWS/テキストウインドウ位置変更

EXTRN	WIDSLC:NEAR			; WINDOWS/セレクト・ウインドウ

EXTRN	R_SR_TK_MESSAGE:NEAR		; 敵意、好意のメッセージ
EXTRN	R_SR_TOKU_MESSAGE:NEAR		; 特徴のメッセージ

EXTRN	R_SR_GIRL_NAME:NEAR		; キャラクタ名
EXTRN	R_SR_GIRL_SHOGO:NEAR		; キャラクタの称号
EXTRN	R_SR_GIRL_HELP:NEAR		; キャラクタに対する説明
EXTRN	R_SR_POINT:NEAR			; ポイント表示

EXTRN	R_MS_KUCHIPAKU:NEAR		; 口パクモード
EXTRN	R_MS_KUCHISTOP:NEAR		; 口パクモード終り

EXTRN	PT_FREAM:NEAR			; メインフレーム
EXTRN	PT_FREAM_LEFT:NEAR		; メインフレーム左
EXTRN	PT_FREAM_BATL:NEAR		; バトルフレーム
EXTRN	PT_FREAM_BUGEI:NEAR		; 武芸フレーム
EXTRN	PT_CHR_BG_BATLE:NEAR		; バトルＢＧ－ＰＵＴ
EXTRN	PT_MNSTER:NEAR			; モンスターＰＵＴ
EXTRN	PT_TOHSHI:NEAR			; 闘士ＰＵＴ
EXTRN	PT_SHIHAN:NEAR			; 師範ＰＵＴ

EXTRN	PT_CHR_BG_BUGEI:NEAR		; 武芸ＢＧ－ＰＵＴ

EXTRN	PT_FREAM:NEAR			; メインフレーム

EXTRN	PT_BUTOH_ALL_LOAD:NEAR		; 武闘会関係全ロード
EXTRN	PT_CHR_BG_BUTOH:NEAR		; 武闘会ＢＧ－ＰＵＴ
EXTRN	PT_FREAM_BUTOH:NEAR		; 武闘会フレーム

EXTRN	PT_MUSYA_ALL_LOAD:NEAR		; 武者修行関係全ロード
EXTRN	PT_FREAM_MUSYA:NEAR		; 武者修行フレーム

EXTRN	PT_LD_SHOCK:NEAR		; ショックＬＯＡＤ
EXTRN	PT_PUT_SHOCK:NEAR		; ショックＰＵＴ

EXTRN	WIDDSP_SV_F:NEAR		; WINDOWS/画面フル退避
EXTRN	WIDDSP_LD_F:NEAR		; WINDOWS/画面フル復元

EXTRN	WIDDSP_SV_MYST:NEAR		; WINDOWS/ＭＹステータス退避
EXTRN	WIDDSP_LD_MYST:NEAR		; WINDOWS/ＭＹステータス復元

EXTRN	WIDDSP_SV_YOU:NEAR		; WINDOWS/ＹＯＵヘッダー退避
EXTRN	WIDDSP_LD_YOU:NEAR		; WINDOWS/ＹＯＵヘッダー復元

EXTRN	WIDDSP_SV_YOUST:NEAR		; WINDOWS/ＹＯＵステータス退避
EXTRN	WIDDSP_LD_YOUST:NEAR		; WINDOWS/ＹＯＵステータス復元

EXTRN	MSCSRT:NEAR			; カーソルスタート
EXTRN	MSCMOV:NEAR			; カーソル移動
EXTRN	MSCWAT:NEAR			; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR			; カーソルストップ
EXTRN	MSCSTS:NEAR			; マウスカーソルステータス
EXTRN	MSCPNT:NEAR			; カーソル表示位置

EXTRN	US_WAIT:NEAR			; ユーザ待ち
EXTRN	TM_WAIT:NEAR			; タイマ待ち
EXTRN	BYTE_TBL_SCH:NEAR		; バイトテーブルサーチ


;*;; ****************************************************
;*;;	戦闘！
;*;;	-I- AX   : キャラクタ番号／私の娘
;*;;	    BX   : キャラクタ番号／私の娘のライバル
;*;;	-O- AX   : 1=合格,2=不合格
;*;; ****************************************************
;*;
;*;R_SENTOU	PROC	NEAR
;*;	MOV	AX,0			; キャラクタ番号／私の娘
;*;	MOV	BX,1			; キャラクタ番号／私の娘のライバル
;*;
;*;	PUSH	AX
;*;	PUSH	BX
;*;	CALL	R_SENTOU_GE_OPEN		; 武芸戦闘・ＯＰＥＮ
;*;	POP	BX
;*;	POP	AX
;*;
;*;	CALL	R_SENTOU_GE			; 武芸戦闘！
;*;
;*;	PUSH	AX
;*;	CALL	R_SENTOU_GE_CLOSE		; 武芸戦闘・ＣＬＯＳＥ
;*;	POP	AX
;*;	RET
;*;R_SENTOU	ENDP


; ****************************************************
;	武芸戦闘・ＯＰＥＮ
; ****************************************************

R_SENTOU_GE_OPEN	PROC	NEAR
	CALL	PT_FREAM		; メインフレーム
	CALL	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更
	CALL	PT_CHR_BG_BUGEI		; 武芸ＢＧ－ＰＵＴ
	RET
R_SENTOU_GE_OPEN	ENDP


; ****************************************************
;	武芸戦闘・ＣＬＯＳＥ
; ****************************************************

R_SENTOU_GE_CLOSE	PROC	NEAR
	RET
R_SENTOU_GE_CLOSE	ENDP


; ****************************************************
;	武芸戦闘！
;	-I- AX   : キャラクタ番号／私の娘
;	    BX   : キャラクタ番号／私の師範
;	-O- AX   : 1=合格,2=不合格
; ****************************************************

R_SENTOU_GE	PROC	NEAR
	MOV	CHAR_MY_GIRL,AX		; キャラクタ番号／私の娘
	MOV	CHAR_RIVAL,BX		; キャラクタ番号／私の師範

	MOV	PP_NIGE_FLG_MY,1	; 私、逃げる禁止フラグ
	MOV	PP_NIGE_FLG_TK,1	; 敵、逃げる禁止フラグ

	MOV	PP_HP_MY,999		; 私のＨＰ（）
	MOV	PP_HP_TK,999		; 敵のＨＰ（）
	MOV	PINCH_MY_LVL,0		; 私のピンチレベル
	MOV	PINCH_TK_LVL,0		; 敵のピンチレベル

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	CALL	BWID_OPEN_GE		; バトルウインドウＯＰＥＮ・武芸編

	CALL	BWID_MAIN		; バトルＭＡＩＮ

	CALL	R_SR_YOIDESUKA		; よいですか

;*;	SELECT	"よい？,1,2かち,3まけ"
;*;	MOVX	BTL_KEKKA,WIDSNM; バトル結果 2=勝った,3=負けた,4=逃げた

	MOV	AX,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	S_FUNC,27		; 27=キャラクタの全整合チェック
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,27		; 27=キャラクタの全整合チェック
	CALL	R_KEISAN		; 各計算処理

	CMP	BTL_KEKKA,2		; バトル結果 2=勝った,3=負けた,4=逃げた
	JNE	R_SENTOU_GE_FUGOHKAKU	;

R_SENTOU_GE_GOHKAKU:
	MOV	AX,1			; 1=合格
	RET
R_SENTOU_GE_FUGOHKAKU:
	MOV	AX,2			; 2=不合格
	RET
R_SENTOU_GE	ENDP


; ****************************************************
;	バトルウインドウＯＰＥＮ・武芸編
;	-I- CHAR_MY_GIRL : キャラクタ番号／私の娘
;	    CHAR_RIVAL   : キャラクタ番号／師範
; ****************************************************

BWID_OPEN_GE	PROC	NEAR
	MOVX	ES,DS			;
	MOV	DI,OFFSET WID_SHIHAN_TBL ; (byte)師範テーブル
	MOV	DX,CHAR_RIVAL		; キャラクタ番号／私の娘のライバル
	CALL	BYTE_TBL_SCH		; バイトテーブルサーチ
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	BWID_OPEN_GE_SET	;

	MOV	DX,CX			; 師範番号(CX=みつかったオフセット)
	MOV	AX,0			; ＰＵＴ　Ｘ座標
	MOV	BX,0			; ＰＵＴ　Ｙ座標
	CALL	PT_SHIHAN		; 師範ＰＵＴ

BWID_OPEN_GE_SET:
	CALL	STATUS_SETUP		; ステータス・セットアップ
	RET
BWID_OPEN_GE	ENDP



; ****************************************************
;	武闘会戦闘・先行ロード
; ****************************************************

R_SENTOU_BU_LOAD	PROC	NEAR
	CALL	PT_BUTOH_ALL_LOAD	; 武闘会関係全ロード
	RET
R_SENTOU_BU_LOAD	ENDP


; ****************************************************
;	武闘会戦闘・ＯＰＥＮ
; ****************************************************

R_SENTOU_BU_OPEN	PROC	NEAR
	CALL	PT_FREAM_BUTOH		; 武闘会フレーム
	CALL	PT_CHR_BG_BUTOH		; 武闘会ＢＧ－ＰＵＴ
	CALL	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更
	RET
R_SENTOU_BU_OPEN	ENDP


; ****************************************************
;	武闘会戦闘・ＣＬＯＳＥ
; ****************************************************

R_SENTOU_BU_CLOSE	PROC	NEAR
	CALL	BWID_CLOSE_BT		; バトルウインドウＣＬＯＳＥ・武闘会編
	RET
R_SENTOU_BU_CLOSE	ENDP



; ****************************************************
;	武闘会戦闘！
;	-I- AX   : キャラクタ番号／私の娘
;	    BX   : キャラクタ番号／私の娘のライバル
;	    DX   : 第何試合か？
;	-O- AX   : 1=合格,2=不合格
; ****************************************************

R_SENTOU_BU	PROC	NEAR
	MOV	CHAR_MY_GIRL,AX		; キャラクタ番号／私の娘
	MOV	CHAR_RIVAL,BX		; キャラクタ番号／私の娘のライバル
	MOV	TAG_LEVEL,DX		; 第何試合か？

;*;	PRV	"TAG_LEVEL=",TAG_LEVEL	; 第何試合か？

	MOV	PP_NIGE_FLG_MY,1	; 私、逃げる禁止フラグ
	MOV	PP_NIGE_FLG_TK,1	; 敵、逃げる禁止フラグ

	MOV	PP_HP_MY,999		; 私のＨＰ（）
	MOV	PP_HP_TK,999		; 敵のＨＰ（）
	MOV	PINCH_MY_LVL,0		; 私のピンチレベル
	MOV	PINCH_TK_LVL,0		; 敵のピンチレベル

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	CALL	BWID_OPEN_BT		; バトルウインドウＯＰＥＮ・武闘会編

	CMP	TAG_LEVEL,2		; 第何試合か？
	JNE	R_SENTOU_BU_2		;
R_SENTOU_BU_1:
	MOV	BX,1			; 1=開始時・１回戦目
	JMP	R_SENTOU_BU_3		;
R_SENTOU_BU_2:
	MOV	BX,2			; 2=開始時・次
R_SENTOU_BU_3:
	CALL	R_MS_BUTOH		; 武闘会メッセージ

	CALL	BWID_MAIN		; バトルＭＡＩＮ

	PR_WAIT

	CMP	BTL_KEKKA,2		; バトル結果 2=勝った,3=負けた,4=逃げた
	JNE	R_SENTOU_BU_5		;
R_SENTOU_BU_4:
	MOV	BX,3			; 3=終了時・勝ち
	JMP	R_SENTOU_BU_6		;
R_SENTOU_BU_5:
	MOV	BX,4			; 4=終了時・負け
R_SENTOU_BU_6:
	CALL	R_MS_BUTOH		; 武闘会メッセージ

;*;	PR_WAIT
;*;	PR_CLS
;*;
;*;	CALL	MSG_TEKI		; 「敵、」
;*;
;*;	CMP	BTL_KEKKA,2		; バトル結果 2=勝った,3=負けた,4=逃げた
;*;	JE	R_SENTOU_BU_SUKI	;
;*;
;*;R_SENTOU_BU_TEKI:			;
;*;	MOV	BX,2			; 2=○○○はもろくも敗れ去った‥‥‥
;*;	CALL	R_MS_MESSAGE		; その他メッセージ
;*;
;*;	MOV	FLG_TK_KANJO,1		; 1=敵意
;*;	CALL	MSG_TK_KOU		; 敵好メッセージ
;*;
;*;	MOV	BX,3			; 3=｢しょうがない、ミス・コンでも
;*;	CALL	R_MS_MESSAGE		; その他メッセージ
;*;	JMP	R_SENTOU_BU_YOI		;
;*;
;*;R_SENTOU_BU_SUKI:			;
;*;	MOV	FLG_TK_KANJO,2		; 2=好意
;*;	CALL	MSG_TK_KOU		; 敵好メッセージ
;*;
;*;	MOV	BX,1			;1=やった！○○○の勝利だ。
;*;	CALL	R_MS_MESSAGE		; その他メッセージ
;*;
;*;R_SENTOU_BU_YOI:

	CALL	R_SR_YOIDESUKA		; よいですか

;*;	SELECT	"よい？,1,2かち,3まけ"
;*;	MOVX	BTL_KEKKA,WIDSNM; バトル結果 2=勝った,3=負けた,4=逃げた

	MOV	AX,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	S_FUNC,27		; 27=キャラクタの全整合チェック
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,27		; 27=キャラクタの全整合チェック
	CALL	R_KEISAN		; 各計算処理

	CMP	BTL_KEKKA,2		; バトル結果 2=勝った,3=負けた,4=逃げた
	JNE	R_SENTOU_BU_FUGOHKAKU	;

R_SENTOU_BU_GOHKAKU:
	MOV	AX,1			; 1=合格
	RET
R_SENTOU_BU_FUGOHKAKU:
	MOV	AX,2			; 2=不合格
	RET
R_SENTOU_BU	ENDP


; ****************************************************
;	武者修行・先行ロード
; ****************************************************

R_SENTOU_MS_LOAD	PROC	NEAR
	CALL	PT_MUSYA_ALL_LOAD	; 武者修行関係全ロード
	RET
R_SENTOU_MS_LOAD	ENDP


; ****************************************************
;	武者修行・ＯＰＥＮ
; ****************************************************

R_SENTOU_MS_OPEN	PROC	NEAR
	CALL	PT_FREAM_MUSYA		; 武者修行フレーム
	CALL	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更
	RET
R_SENTOU_MS_OPEN	ENDP


; ****************************************************
;	武者修行・ＣＬＯＳＥ
; ****************************************************

R_SENTOU_MS_CLOSE	PROC	NEAR
	CALL	BWID_CLOSE_MS		; バトルウインドウＣＬＯＳＥ・武者修行
	RET
R_SENTOU_MS_CLOSE	ENDP


; ****************************************************
;	武者修行戦闘！
;	-I- AX   : キャラクタ番号／私の娘
;	    BX   : キャラクタ番号／私の娘のライバル
;	-O- AX   : 1=合格,2=不合格
;	    DX   : 得た経験値
; ****************************************************

R_SENTOU_MS	PROC	NEAR
	MOV	CHAR_MY_GIRL,AX		; キャラクタ番号／私の娘
	MOV	CHAR_RIVAL,BX		; キャラクタ番号／私の娘のライバル

	PR_CLS
	PR_TXT	"何かに出会った‥‥‥！@"

	MOV	PP_NIGE_FLG_MY,0	; 私、逃げる禁止フラグ
	MOV	PP_NIGE_FLG_TK,0	; 敵、逃げる禁止フラグ

	MOV	PP_HP_MY,999		; 私のＨＰ（）
	MOV	PP_HP_TK,999		; 敵のＨＰ（）
	MOV	PINCH_MY_LVL,0		; 私のピンチレベル
	MOV	PINCH_TK_LVL,0		; 敵のピンチレベル

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	BWID_OPEN_MS		; バトルウインドウＯＰＥＮ・武者修行
	MUSIC	KYOKU_BATLE		; バﾄﾙ

	MOV	MY_MAGIC_KIND,0			; 私、魔法種類 0=通常
	MOV	TK_MAGIC_KIND,0			; 敵、魔法種類 0=通常
	MOV	MY_BOUGYO_UP_FLAG,0		; 私、防御ＵＰフラグ 0=通常
	MOV	TK_BOUGYO_UP_FLAG,0		; 敵、防御ＵＰフラグ 0=通常

	MOV	BTL_COUNT,0			; バトル回数

	CALL	PARAMETER_GET			; 各パラメータ

	CALL	MSG_MUSUME			; 「娘、」
	CALL	R_SR_SR_KAKO			; "「"
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"だ！"				;
	CALL	R_SR_SR_KOKA			; "」"

	CALL	BWID_START		; 戦闘モードその１
	CMP	BTL_KEKKA,1		; バトル結果
	JNE	R_SENTOU_MS_KETCHAKU	; 1=どうする,2=勝った,3=負けた,4=逃げた
					; 5=敵が去る,6=やり過ごす,7=脱出成功
	CALL	BWID_MAIN		; バトルＭＡＩＮ

R_SENTOU_MS_KETCHAKU:
	MUSIC	KYOKU_F_O		; 音楽フェードアウト
	CALL	R_SR_YOIDESUKA		; よいですか

;*;	SELECT	"よい？,1,2かち,3まけ"
;*;	MOVX	BTL_KEKKA,WIDSNM; バトル結果 2=勝った,3=負けた,4=逃げた

	MOV	AX,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,30		; 30=生き返る
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	S_FUNC,27		; 27=キャラクタの全整合チェック
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,27		; 27=キャラクタの全整合チェック
	CALL	R_KEISAN		; 各計算処理

	CMP	BTL_KEKKA,3		; バトル結果 2=勝った,3=負けた,4=逃げた
					; 5=敵が去る,6=やり過ごす,7=脱出成功
	JE	R_SENTOU_MS_FUGOHKAKU	;
R_SENTOU_MS_GOHKAKU:
	PR_CLS

	MOV	DX,0			; 経験値

	CMP	BTL_KEKKA,2		; バトル結果 2=勝った
	JNE	R_SENTOU_MS_GOHKAKU2	;

	CALL	VICTORY_TK_UBAU		; 敵から金と経験値を貰う
	MOV	DX,GIVE_KEIKEN		; 経験値
R_SENTOU_MS_GOHKAKU2:			;
	MOV	AX,1			; 1=合格
	RET
R_SENTOU_MS_FUGOHKAKU:
	MOV	DX,0			; 経験値
	MOV	AX,2			; 2=不合格
	RET
R_SENTOU_MS	ENDP



;*NON*;; ****************************************************
;*NON*;;	バトルウインドウＯＰＥＮ
;*NON*;;	-I- CHAR_MY_GIRL : キャラクタ番号／私の娘
;*NON*;;	    CHAR_RIVAL   : キャラクタ番号／私の娘のライバル
;*NON*;; ****************************************************
;*NON*;
;*NON*;BWID_OPEN	PROC	NEAR
;*NON*;	PR_CLS
;*NON*;	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避
;*NON*;
;*NON*;	CALL	PT_FREAM		; メインフレーム
;*NON*;
;*NON*;	CALL	BWID_TEKI		; バトル敵表示
;*NON*;
;*NON*;	CALL	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更
;*NON*;
;*NON*;	CALL	STATUS_SETUP		; ステータス・セットアップ
;*NON*;
;*NON*;	RET
;*NON*;BWID_OPEN	ENDP
;*NON*;; ****************************************************
;*NON*;;	バトル敵表示
;*NON*;;	-I- CHAR_MY_GIRL : キャラクタ番号／私の娘
;*NON*;;	    CHAR_RIVAL   : キャラクタ番号／私の娘のライバル
;*NON*;; ****************************************************
;*NON*;
;*NON*;BWID_TEKI	PROC	NEAR
;*NON*;	MOV	AX,0			; ＰＵＴ　Ｘ座標
;*NON*;	MOV	BX,0			; ＰＵＴ　Ｙ座標
;*NON*;	MOV	DX,2			; 2=寺院の丘
;*NON*;	CALL	PT_CHR_BG_BATLE		; バトルＢＧ－ＰＵＴ
;*NON*;
;*NON*;	MOV	AX,0			; ＰＵＴ　Ｘ座標
;*NON*;	MOV	BX,0			; ＰＵＴ　Ｙ座標
;*NON*;	MOV	DX,2			; モンスター番号表(byte)
;*NON*;	CALL	PT_MNSTER		; モンスターＰＵＴ
;*NON*;
;*NON*;	RET
;*NON*;BWID_TEKI	ENDP
;*NON*;; ****************************************************
;*NON*;;	バトルウインドウＣＬＯＳＥ
;*NON*;; ****************************************************
;*NON*;
;*NON*;BWID_CLOSE	PROC	NEAR
;*NON*;	MOV	DX,CCT_OPEN_TYP_TK	; オープンタイプ・敵
;*NON*;	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
;*NON*;
;*NON*;	MOV	DX,CCT_OPEN_TYP_MY	; オープンタイプ・私
;*NON*;	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ
;*NON*;
;*NON*;
;*NON*;	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元
;*NON*;	PR_CLS
;*NON*;	RET
;*NON*;BWID_CLOSE	ENDP


; ****************************************************
;	ステータス・セットアップ
;	-I- CHAR_MY_GIRL : キャラクタ番号／私の娘
;	    CHAR_RIVAL   : キャラクタ番号／私の娘のライバル
; ****************************************************

STATUS_SETUP	PROC	NEAR
	MOV	DX,CHAR_MY_GIRL		; キャラクタ番号／私の娘
	CALL	WIDALLOC_MY_GIRL	; WINDOWS/キャラクタ・データ結合

	MOV	DX,CHAR_RIVAL		; キャラクタ番号／私の娘のライバル
	CALL	WIDALLOC_TEKICHR	; WINDOWS/敵キャラクタ・データ結合

	; 私

	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	MOV	DX,CCT_OPEN_TYP_MY	; オープンタイプ・私
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

;*;	MOV	WDGNO,0			; 0. 体力
;*;	CALL	WIDHBRS			; WINDOWS/横グラフ再表示

	MOV	WDGNO,10		; 10.から15.まで
	MOV	CX,6			;
STATUS_SETUP_3:				;
	PUSH	CX			;
	MOV	AX,4			; wait timer count.
	CALL	TMVSET			; V-SYNC timer set.
	CALL	WIDHBRSN		; WINDOWS/横グラフ再表示（ﾌﾞﾘﾝｸなし）
	INC	WDGNO			;
	CALL	TMVEWT			; V-SYNC timer end wait.
	POP	CX			;
	LOOP	STATUS_SETUP_3		;

	MOV	WDGNO,15		; 15. ＭＰ
	CALL	WIDHBRS			; WINDOWS/横グラフ再表示

	; 敵

	MOV	AX,WIDTK_CHAR_NO	; 敵キャラクタＮｏ．
	MOV	DX,CCT_OPEN_TYP_TK	; オープンタイプ・敵
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

;*;	MOV	WDGNO,0			; 0. 体力
;*;	CALL	WIDHBRS			; WINDOWS/横グラフ再表示

	MOV	WDGNO,10		; 10.から15.まで
	MOV	CX,6			;
STATUS_SETUP_4:				;
	PUSH	CX			;
	MOV	AX,4			; wait timer count.
	CALL	TMVSET			; V-SYNC timer set.
	CALL	WIDHBRSN		; WINDOWS/横グラフ再表示（ﾌﾞﾘﾝｸなし）
	INC	WDGNO			;
	CALL	TMVEWT			; V-SYNC timer end wait.
	POP	CX			;
	LOOP	STATUS_SETUP_4		;

	MOV	WDGNO,15		; 15. ＭＰ
	CALL	WIDHBRS			; WINDOWS/横グラフ再表示

	MOV	DX,CHAR_MY_GIRL		; キャラクタ番号／私の娘
	CALL	WIDALLOC_MY_GIRL	; WINDOWS/キャラクタ・データ結合

	MOV	DX,CHAR_RIVAL		; キャラクタ番号／私の娘のライバル
	CALL	WIDALLOC_TEKICHR	; WINDOWS/敵キャラクタ・データ結合
	RET
STATUS_SETUP	ENDP


; ****************************************************
;	バトルウインドウＯＰＥＮ・武闘会編
;	-I- CHAR_MY_GIRL : キャラクタ番号／私の娘
;	    CHAR_RIVAL   : キャラクタ番号／私の娘のライバル
; ****************************************************

BWID_OPEN_BT	PROC	NEAR
	CALL	BWID_TEKI_BT		; バトル敵表示・武闘会編
	CALL	STATUS_SETUP		; ステータス・セットアップ
	RET
BWID_OPEN_BT	ENDP


; ****************************************************
;	バトル敵表示・武闘会編
;	-I- CHAR_RIVAL   : キャラクタ番号／私の娘のライバル
; ****************************************************

BWID_TEKI_BT	PROC	NEAR
	MOVX	ES,DS			;
	MOV	DI,OFFSET WID_BUTOH_TBL	; (byte)武闘会テーブル
	MOV	DX,CHAR_RIVAL		; キャラクタ番号／私の娘のライバル
	CALL	BYTE_TBL_SCH		; バイトテーブルサーチ
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	BWID_TEKI_BT_EXIT	;

	MOV	DX,CX			; 闘士番号(CX=みつかったオフセット)
	MOV	AX,0			; ＰＵＴ　Ｘ座標
	MOV	BX,0			; ＰＵＴ　Ｙ座標
	CALL	PT_TOHSHI		; 闘士ＰＵＴ

BWID_TEKI_BT_EXIT:
	RET
BWID_TEKI_BT	ENDP



; ****************************************************
;	バトルウインドウＣＬＯＳＥ・武闘会編
; ****************************************************

BWID_CLOSE_BT	PROC	NEAR
	MOV	DX,CCT_OPEN_TYP_TK	; オープンタイプ・敵
	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ

	MOV	DX,CCT_OPEN_TYP_MY	; オープンタイプ・私
	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ

	RET
BWID_CLOSE_BT	ENDP


; ****************************************************
;	バトルウインドウＯＰＥＮ・武者修行
;	-I- CHAR_MY_GIRL : キャラクタ番号／私の娘
;	    CHAR_RIVAL   : キャラクタ番号／私の娘のライバル
; ****************************************************

BWID_OPEN_MS	PROC	NEAR
	CALL	BWID_TEKI_MS		; バトル敵表示・武者修行
	CALL	STATUS_SETUP		; ステータス・セットアップ
	RET
BWID_OPEN_MS	ENDP


; ****************************************************
;	バトル敵表示・武者修行
;	-I- CHAR_RIVAL   : キャラクタ番号／私の娘のライバル
; ****************************************************

BWID_TEKI_MS	PROC	NEAR
	MOVX	ES,DS			;
	MOV	DI,OFFSET WID_MONSTER_TBL ; (byte)モンスターテーブル
	MOV	DX,CHAR_RIVAL		; キャラクタ番号／私の娘のライバル
	CALL	BYTE_TBL_SCH		; バイトテーブルサーチ
	CMP	AX,0			; 1=見つかった,0=見つからない
	JE	BWID_TEKI_MS_EXIT	;

	MOV	DX,CX			; モンスタ番号(CX=みつかったオフセット)
	MOV	AX,0			; ＰＵＴ　Ｘ座標
	MOV	BX,0			; ＰＵＴ　Ｙ座標
	CALL	PT_MNSTER		; モンスターＰＵＴ

BWID_TEKI_MS_EXIT:
	RET
BWID_TEKI_MS	ENDP


; ****************************************************
;	バトルウインドウＣＬＯＳＥ・武者修行
; ****************************************************

BWID_CLOSE_MS	PROC	NEAR
	MOV	DX,CCT_OPEN_TYP_TK	; オープンタイプ・敵
	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ

	MOV	DX,CCT_OPEN_TYP_MY	; オープンタイプ・私
	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ

	RET
BWID_CLOSE_MS	ENDP


; ****************************************************
;	戦闘モードその１
;	-O- BTL_KEKKA : バトル結果
;		1=どうする,2=勝った,3=負けた,4=逃げた
;		5=敵が去る,6=やり過ごす,7=脱出成功
; ****************************************************

BWID_START	PROC	NEAR
	SELECT	"戦う,話しかける,隠れる,逃げる"
	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JE	BWID_START_TATAKAU	;
	CMP	WIDSNM,0		; 戦う
	JE	BWID_START_TATAKAU	;
	CMP	WIDSNM,1		; 話しかける
	JE	BWID_START_HANASU	;
	CMP	WIDSNM,2		; 隠れる
	JE	BWID_START_KAKURERU	;
	CMP	WIDSNM,3		; 逃げる
	JE	BWID_START_NIGERU	;
BWID_START_TATAKAU:
	CALL	B_SRT_TATAKAU		; 出会い・戦う
	RET
BWID_START_HANASU:
	CALL	B_SRT_HANASU		; 出会い・話しかける
	RET
BWID_START_KAKURERU:
	CALL	B_SRT_KAKURERU		; 出会い・隠れる
	RET
BWID_START_NIGERU:
	CALL	B_SRT_NIGERU		; 出会い・逃げる
	RET
BWID_START	ENDP


; ****************************************************
;	出会い・戦う
;	-O- BTL_KEKKA : バトル結果 1=どうする
; ****************************************************

B_SRT_TATAKAU	PROC	NEAR
	MOV	BTL_KEKKA,1			; 1=どうする
	RET
B_SRT_TATAKAU	ENDP


; ****************************************************
;	出会い・話しかける
;	-O- BTL_KEKKA : バトル結果
;		1=どうする,2=勝った,3=負けた,4=逃げた
;		5=敵が去る
; ****************************************************

B_SRT_HANASU	PROC	NEAR

	PR_LF					;

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,56			; 56=話しかける成功率
	CALL	R_KEISAN			; 各計算処理
	MOV	V_SEIKOU,AX			; 成功率

;*;	PRV	"話 成功率＝",AX

	CALL	RANDAM_100			; 乱数１００
	CMP	AX,V_SEIKOU			; 成功したか？
	JBE	B_SRT_HANASU_KOUI		;
B_SRT_HANASU_TEKII:				;
	MOV	FLG_TK_KANJO,1			; 1=敵意
	CALL	MSG_TK_KOU			; 敵好メッセージ
	CALL	KOUGEI_TK_BOW			; 敵の攻撃
	JMP	B_SRT_HANASU_TK_CHR		;
B_SRT_HANASU_KOUI:				;
	MOV	FLG_TK_KANJO,2			; 2=好意
	CALL	MSG_TK_KOU			; 敵好メッセージ
	MOV	BTL_KEKKA,5			; バトル結果 5=敵が去る
B_SRT_HANASU_TK_CHR:
	RET
B_SRT_HANASU	ENDP


; ****************************************************
;	出会い・隠れる
;	-O- BTL_KEKKA : バトル結果
;		1=どうする,2=勝った,3=負けた,4=逃げた
;		5=敵が去る
; ****************************************************

B_SRT_KAKURERU	PROC	NEAR
	MOV	V_SEIKOU,50			; 成功率５０％

	CALL	RANDAM_100			; 乱数１００
	CMP	AX,V_SEIKOU			; 成功したか？
	JBE	B_SRT_KAKURERU_SEIKOU		;

B_SRT_KAKURERU_SIPPAI:				;
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"に見つかった！"		;
	MOV	BTL_KEKKA,1			; 1=どうする
	JMP	B_SRT_KAKURERU_EXIT		;

B_SRT_KAKURERU_SEIKOU:				;
	PR_LF
	CALL	MSG_TEKI			; 「敵、」
	CALL	R_SR_SR_WA			; "は"
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"に気づかない"			;

	CALL	R_SR_DOSURU			; "どうする？"
	SELECT	"やっつける！,やりすごす"
	CMP	WIDSNM,OFFF			; ユーザ選択番号
	JE	B_SRT_KAKURERU_SARU		;
	CMP	WIDSNM,0			; やる！
	JE	B_SRT_KAKURERU_YARE		;
	CMP	WIDSNM,1			; やりすごす
	JE	B_SRT_KAKURERU_SARU		;

B_SRT_KAKURERU_YARE:				;
	MOV	MY_MAGIC_KIND,0			; 魔法種類 0=通常
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	CALL	R_MAGIC_ARU			; 所有魔法ある？
	CMP	CX,0				; 技数
	JE	B_SRT_KAKURERU_GEKI		;

	SELECT	"攻撃,魔法"			;
	CMP	WIDSNM,OFFF			; ユーザ選択番号
	JE	B_SRT_KAKURERU_GEKI		;
	CMP	WIDSNM,0			; 攻撃
	JE	B_SRT_KAKURERU_GEKI		;
	CALL	CMND_MAHO			; 魔法
	CMP	AX,1				; 1=実行,0=やめる
	JNE	B_SRT_KAKURERU_YARE		;

B_SRT_KAKURERU_GEKI:				;
	CALL	KOUGEI_MY_BOW			; 私の攻撃
	CMP	BTL_KEKKA,4			; バトル結果  4=逃げた
	JE	B_SRT_KAKURERU_SARU		;
	JMP	B_SRT_KAKURERU_EXIT		;

B_SRT_KAKURERU_SARU:
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"は去っていった"		;
	MOV	BTL_KEKKA,5			; バトル結果 5=敵が去る

B_SRT_KAKURERU_EXIT:
	RET
B_SRT_KAKURERU	ENDP


; ****************************************************
;	出会い・逃げる
;	-O- BTL_KEKKA : バトル結果
;		1=どうする,2=勝った,3=負けた,4=逃げた
;		5=敵が去る,6=やり過ごす,7=脱出成功
; ****************************************************

B_SRT_NIGERU	PROC	NEAR
	CALL	CMND_NIGERU		; 逃げる
	CMP	BTL_KEKKA,4		; バトル結果  1=どうする,4=逃げた
	JE	B_SRT_NIGERU_SEIKOU	;
	CALL	KOUGEI_TK_BOW		; 敵の攻撃
	RET
B_SRT_NIGERU_SEIKOU:
	RET
B_SRT_NIGERU	ENDP


; ****************************************************
;	バトルＭＡＩＮ
;	-O-   BTL_KEKKA: バトル結果    2=勝った,3=負けた,4=逃げた
; ****************************************************

BWID_MAIN	PROC	NEAR
	MOV	MY_MAGIC_KIND,0			; 私、魔法種類 0=通常
	MOV	TK_MAGIC_KIND,0			; 敵、魔法種類 0=通常
	MOV	MY_BOUGYO_UP_FLAG,0		; 私、防御ＵＰフラグ 0=通常
	MOV	TK_BOUGYO_UP_FLAG,0		; 敵、防御ＵＰフラグ 0=通常

	CALL	SENTOU_SEIZA			; 戦闘・星座セット

	MOV	BTL_COUNT,0			; バトル回数

	CALL	PARAMETER_GET			; 各パラメータ
BWID_MAIN_LOOP:
	CALL	PARAMETER_DAMEG			; ダメージ計算
	CALL	BTL_SELECT			; バトル選択

	CALL	CMND_PROC			; コマンド処理

	CMP	BTL_KEKKA,2			; バトル結果 2=勝った
	JE	BWID_MAIN_KATTA			;
	CMP	BTL_KEKKA,3			; バトル結果 3=負けた
	JE	BWID_MAIN_MAKETA		;
	CMP	BTL_KEKKA,4			; バトル結果 4=逃げた
	JE	BWID_MAIN_NIGETA		;

	JMP	BWID_MAIN_LOOP			;

BWID_MAIN_KATTA:				;
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"をたおした！"			;
	JMP	BWID_MAIN_EXIT			;
BWID_MAIN_MAKETA:				;
	PR_LF					;
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"はまけた・・・"		;
	JMP	BWID_MAIN_EXIT			;
BWID_MAIN_NIGETA:				;
	JMP	BWID_MAIN_EXIT			;
BWID_MAIN_EXIT:					;
	CALL	ALL_MAGIC_CLEAR			; 全ての魔法がとける
	RET
BWID_MAIN	ENDP


; ****************************************************
;	コマンド処理
;	-I-   BTL_CMND : バトルコマンド 1=攻撃,2=魔法,3=道具,4=逃げる
;	-I/O- BTL_COUNT: バトル回数
;	-O-   BTL_KEKKA: バトル結果     1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

CMND_PROC	PROC	NEAR
	MOV	MY_MAGIC_KIND,0		; 私、魔法種類 0=通常
	MOV	TK_MAGIC_KIND,0		; 敵、魔法種類 0=通常

	INC	BTL_COUNT		; バトル回数
	MOV	BTL_KEKKA,1		; バトル結果 1=どうする

	MOV	AX,BTL_CMND		; バトルコマンド

	CMP	AX,1			; 1=攻撃
	JE	CMND_PROC_KOUGEKI	;
	CMP	AX,2			; 2=魔法
	JE	CMND_PROC_MAHO		;
	CMP	AX,3			; 3=道具
	JE	CMND_PROC_DOUGU		;
	CMP	AX,4			; 4=逃げる
	JE	CMND_PROC_NIGERU	;

	JMP	CMND_PROC_DOSURU	;

CMND_PROC_KOUGEKI:			; 攻撃
	CALL	CMND_KOUGEKI		; 攻撃
	JMP	CMND_PROC_SET		;
CMND_PROC_MAHO:				; 魔法
	CALL	CMND_MAHO		; 魔法
	CMP	AX,0			; 0=やめる
	JE	CMND_PROC_SET		;
	CALL	CMND_KOUGEKI		; 攻撃
	JMP	CMND_PROC_SET		;
CMND_PROC_DOUGU:			; 道具
	CALL	CMND_DOUGU		; 道具
	JMP	CMND_PROC_SET		;
CMND_PROC_NIGERU:			; 逃げる
	CALL	CMND_NIGERU		; 逃げる
	CMP	BTL_KEKKA,4		; バトル結果  1=どうする,4=逃げた
	JE	CMND_PROC_SET		;
	CALL	KOUGEI_TK_BOW		; 敵の攻撃
	JMP	CMND_PROC_SET		;
CMND_PROC_SET:				;

	RET
CMND_PROC_DOSURU:
	MOV	BTL_KEKKA,1		; バトル結果
	RET
CMND_PROC_KATTA:
	MOV	BTL_KEKKA,2		; バトル結果
	RET
CMND_PROC_MAKETA:
	MOV	BTL_KEKKA,3		; バトル結果
	RET
CMND_PROC_NIGETA:
	MOV	BTL_KEKKA,4		; バトル結果
	RET
CMND_PROC	ENDP


; ****************************************************
;	攻撃
;	-O- BTL_KEKKA: バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

CMND_KOUGEKI	PROC	NEAR
	MOV	DX,PP_SENTE		; 私の先手確率
	CALL	SAIKORO			; 成功判定
	CMP	AX,0			; 1=成功です,0=失敗です
	JMPEQ	CMND_KOUGEKI_GOTE	;

CMND_KOUGEKI_SENTE:
	CALL	KOUGEI_MY_BOW		; 私の攻撃
	CMP	BTL_KEKKA,2		; バトル結果  2=勝った
	JE	CMND_KOUGEKI_EXIT	; 勝ち

	CMP	BTL_KEKKA,4		; バトル結果  4=逃げた
	JNE	CMND_KOUGEKI_TEKI	;

	CALL	CMND_NIGERU		; 逃げる
	CMP	BTL_KEKKA,4		; バトル結果  4=逃げた
	JE	CMND_KOUGEKI_EXIT	; 逃げきる

CMND_KOUGEKI_TEKI:
	CALL	KOUGEI_TK_BOW		; 敵の攻撃
	JMP	CMND_KOUGEKI_EXIT	;


CMND_KOUGEKI_GOTE:
	CALL	KOUGEI_TK_BOW		; 敵の攻撃
	CMP	BTL_KEKKA,1		; バトル結果  1=どうする
	JNE	CMND_KOUGEKI_EXIT	;

	CALL	KOUGEI_MY_BOW		; 私の攻撃
	CMP	BTL_KEKKA,4		; バトル結果  4=逃げた
	JNE	CMND_KOUGEKI_EXIT	;

	CALL	CMND_NIGERU		; 逃げる
	JMP	CMND_KOUGEKI_EXIT	;

CMND_KOUGEKI_EXIT:
	RET
CMND_KOUGEKI	ENDP


; ****************************************************
;	魔法
;	-O- AX        : 1=実行,0=やめる
;	    MY_MAGIC_KIND : 魔法種類 0=通常,1=攻撃魔法,2=防御魔法,3=治療魔法
; ****************************************************

CMND_MAHO	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	CALL	R_MAGIC_LIST			; 所有魔法リスト

CMND_MAHO_LOOP:					;
	CALL	WIDSLC				; WINDOWS/セレクト・ウインドウ
	CMP	WIDSNM,OFFF			; ユーザ選択番号
	JMPEQ	CMND_MAHO_YAMERU		;

	MOV	SI,WIDSNM			; ユーザ選択番号
	SHL	SI,1				; word pointer.
	MOV	BX,DS:ATMTBL[SI]		; 魔法文字のアドレス
	CALL	MAGIC_NUMBER			; 魔法番号の検索
	MOV	MY_MAGIC_KIND,AX		; 私、魔法種類

	CMP	MY_MAGIC_KIND,2			; 2=防御魔法
	JNE	CMND_MAHO_55			;
	CMP	MY_BOUGYO_UP_FLAG,0		; 私、防御ＵＰフラグ
	JE	CMND_MAHO_55			;

	PR_TXT	"@防御魔法はもう、使っています"
	JMP	CMND_MAHO_LOOP			;
CMND_MAHO_55:					;

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,MY_MAGIC_KIND		; 私、魔法種類
	CALL	MAGIC_MP_CHECK			; 魔法の消費ＭＰチェック

	CMP	AX,0				; 0=ＯＫ,1=ＭＰが足りません
	JE	CMND_MAHO_OK			;

	PR_TXT	"@ＭＰが足りません"		;

	JMP	CMND_MAHO_LOOP			;

CMND_MAHO_OK:
	MOV	AX,1				; 1=実行,0=やめる
	RET 
CMND_MAHO_YAMERU:
	MOV	MY_MAGIC_KIND,0			; 私、魔法種類
	MOV	AX,0				; 1=実行,0=やめる
	RET
CMND_MAHO	ENDP


; ****************************************************
;	道具
; ****************************************************

CMND_DOUGU	PROC	NEAR
	MOV	DX,CCT_OPEN_TYP_MY		; オープンタイプ・私
	CALL	WIDCCT_CHANGE			; WINDOWS/キャラクタチェンジ
	CALL	R_SOUBI_S_DOUGU			; 戦闘時・道具の使用
	RET
CMND_DOUGU	ENDP


; ****************************************************
;	逃げる
;	-O- BTL_KEKKA: バトル結果  1=どうする,4=逃げた
; ****************************************************

CMND_NIGERU	PROC	NEAR	
	PR_LF					;
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"は臆病風に吹かれた@「＊＊＊＊＊＊＊」@"
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"は逃げ出した！"		;

	; 逃げて成功するのか！？

	MOV	DX,PP_NIGE_HIT_MY		; 逃げる成功率
	CALL	SAIKORO				; 成功判定
	CMP	AX,1				; 1=成功です,0=失敗です
	JMPEQ	CMND_NIGERU_NIGETA		; 成功ならば逃げ切る

	PR_TXT	"@しかし敵に回り込まれて逃げられない！"
	MOV	BTL_KEKKA,1			; 1=どうする
	RET
CMND_NIGERU_NIGETA:
	PR_TXT	"@脱出成功。あの敵はまだ荷が重いようだ‥‥‥"
	MOV	BTL_KEKKA,4			; 4=逃げた
	RET
CMND_NIGERU	ENDP


; ****************************************************
;	私の攻撃
;	-I- MY_MAGIC_KIND : 魔法種類 0=通常,1=攻撃魔法,2=防御魔法,3=治療魔法
;	-O- BTL_KEKKA     : バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

KOUGEI_MY_BOW	PROC	NEAR
	CMP	MY_MAGIC_KIND,0		; 魔法種類 0=通常
	JE	KOUGEI_MY_BOW_NORMAL	;

	CALL	KOUGEI_MP_MY		; 私の魔法
	JMP	KOUGEI_MY_BOW_EXIT	;
KOUGEI_MY_BOW_NORMAL:
	CALL	KOUGEI_MY		; 私の通常攻撃
KOUGEI_MY_BOW_EXIT:
	RET
KOUGEI_MY_BOW	ENDP


; ****************************************************
;	敵の攻撃
;	-O- BTL_KEKKA: バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

KOUGEI_TK_BOW	PROC	NEAR
	CALL	MAGIC_TK_CHECK		; 敵は魔法を使うか？
	CMP	AX,1			; 1=実行,0=やめる
	JE	KOUGEI_TK_BOW_MAGIC	;

KOUGEI_TK_BOW_NORMAL:
	CALL	KOUGEI_TK		; 敵の常攻撃
	JMP	KOUGEI_TK_BOW_EXIT	;
KOUGEI_TK_BOW_MAGIC:
	CALL	KOUGEI_MP_TK		; 敵の魔法
KOUGEI_TK_BOW_EXIT:
	RET
KOUGEI_TK_BOW	ENDP


; ****************************************************
;	敵は魔法を使うか？
;	-O- AX        : 1=実行,0=やめる
;	    TK_MAGIC_KIND : 魔法種類 0=通常,4=ニードル（攻）,5=ファイア（攻）
;			6=マジックミサイル（攻）,7=バリア（防）,8=ヒール（回）
;			9=サンダー（攻）
; ****************************************************

MAGIC_TK_CHECK	PROC	NEAR
	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	CALL	R_MAGIC_LIST			; 所有魔法リスト

	CMP	ATMMAX,0			; WINDOWS/表示単語の数
	JE	MAGIC_TK_CHECK_YAMERU		;

	CALL	RANDAM_100			; 乱数１００
	CMP	AX,50				; ５０％の確率
	JG	MAGIC_TK_CHECK_YAMERU		;

	MOV	CX,ATMMAX			; WINDOWS/表示単語の数
	CALL	RANDAM_CX			; 乱数範囲指定
	MOV	SI,AX				; １からＣＸの数字
	DEC	SI				; base 0.
	SHL	SI,1				; word pointer.
	MOV	BX,DS:ATMTBL[SI]		; 魔法文字のアドレス
	CALL	MAGIC_NUMBER			; 魔法番号の検索
	MOV	TK_MAGIC_KIND,AX		; 魔法番号

	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	BX,TK_MAGIC_KIND		; 敵、魔法番号
	CALL	MAGIC_MP_CHECK			; 魔法の消費ＭＰチェック
	CMP	AX,1				; 1=ＭＰが足りません
	JE	MAGIC_TK_CHECK_NONE		;

MAGIC_TK_CHECK_OK:
	MOV	AX,1				; 1=実行,0=やめる
	RET
MAGIC_TK_CHECK_NONE:				;
	PR_LF
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"がＭＰ不足で悩んでいます"
MAGIC_TK_CHECK_YAMERU:
	MOV	TK_MAGIC_KIND,0			; 敵、魔法種類
	MOV	AX,0				; 1=実行,0=やめる
	RET
MAGIC_TK_CHECK	ENDP


; ****************************************************
;	私の通常攻撃
;	-O- BTL_KEKKA: バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

KOUGEI_MY	PROC	NEAR

	; 勝手に逃げるのか！？

	CMP	PP_NIGE_FLG_MY,0		; 私、逃げる禁止フラグ
	JNE	KOUGEI_MY_2			;

	MOV	DX,PP_NIGERU_MY			; 私、逃げる確率
	CALL	SAIKORO				; 成功判定
	CMP	AX,1				; 1=成功です,0=失敗です
	JMPEQ	KOUGEI_MY_NIGETA		; こわーい！
KOUGEI_MY_2:					;

	; 攻撃は命中するか！？

	PR_LF					;
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"の攻撃@"

	MOV	DX,PP_MEICHU_MY			; 命中率
	CALL	SAIKORO				; 成功判定
	CMP	AX,0				; 1=成功です,0=失敗です
	JMPEQ	KOUGEI_MY_DAMEDA		; だめだ！

	CALL	DAMEGE_VAL_TK			; 敵へのダメージ値は！！
	CALL	DAMEGE_TK			; 敵のダメージ！
	CMP	BTL_KEKKA,2			; バトル結果  2=勝った
	JE	KOUGEI_MY_KATTA			;

	PR_TXT	"@バシィ！！"
	CALL	ACTION_KOUGEKI			; 攻撃アクション
	MOV	BTL_KEKKA,1			; 1=どうする
	RET
KOUGEI_MY_DAMEDA:
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"は攻撃をかわした！"		;
	MOV	BTL_KEKKA,1			; 1=どうする
	RET
KOUGEI_MY_KATTA:
	PR_TXT	"@勝ったぁぁぁぁ！"		;
	MOV	BTL_KEKKA,2			; 2=勝った
	RET
KOUGEI_MY_NIGETA:
	PR_TXT	"@「＊＊＊＊＊」たじろぐ"
	CALL	MSG_MUSUME			; 「娘、」
	MOV	BTL_KEKKA,4			; 4=逃げた
	RET
KOUGEI_MY	ENDP


; ****************************************************
;	敵の通常攻撃
;	-O- BTL_KEKKA: バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

KOUGEI_TK	PROC	NEAR

	; 敵は逃げるか！？

	CMP	PP_NIGE_FLG_TK,0		; 敵、逃げる禁止フラグ
	JNE	KOUGEI_TK_2			;

	MOV	DX,PP_NIGERU_TK			; 敵、逃げる確率
	CALL	SAIKORO				; 成功判定
	CMP	AX,1				; 1=成功です,0=失敗です
	JMPEQ	KOUGEI_TK_NIGETA		; 逃げた！
KOUGEI_TK_2:

	; 敵の攻撃は命中するか！？

	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"の攻撃"

	MOV	DX,PP_MEICHU_TK			; 敵命中率
	CALL	SAIKORO				; 成功判定
	CMP	AX,0				; 1=成功です,0=失敗です
	JMPEQ	KOUGEI_TK_DAMEDA		; だめだ！

	CALL	DAMEGE_VAL_MY			; 私へのダメージ値は！！
	CALL	DAMEGE_MY			; 私のダメージ！
	CMP	BTL_KEKKA,3			; バトル結果  3=負けた
	JE	KOUGEI_TK_SINDA			;

	PR_TXT	"@ドガガッ！"
	CALL	ACTION_HANGEKI			; 反撃アクション
	MOV	BTL_KEKKA,1			; 1=どうする
	RET
KOUGEI_TK_DAMEDA:
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"の攻撃をかわした！"		;
	MOV	BTL_KEKKA,1			; 1=どうする
	RET
KOUGEI_TK_SINDA:
	PR_LF					;
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"はとどめをさされた。"		;
	MOV	BTL_KEKKA,3			; 3=負けた
	RET
KOUGEI_TK_NIGETA:
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"は逃げた。"			;
	MOV	BTL_KEKKA,4			; 4=逃げた
	RET
	RET
KOUGEI_TK	ENDP


; ****************************************************
;	私の魔法
;	-I- MY_MAGIC_KIND : 魔法種類 0=通常,1=攻撃魔法,2=防御魔法,3=治療魔法
;	-O- BTL_KEKKA  : バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

KOUGEI_MP_MY	PROC	NEAR
						; 勝手に逃げるのか！？
	CMP	PP_NIGE_FLG_MY,0		; 私、逃げる禁止フラグ
	JNE	KOUGEI_MP_MY_2			;
	MOV	DX,PP_NIGERU_MY			; 私、逃げる確率
	CALL	SAIKORO				; 成功判定
	CMP	AX,1				; 1=成功です,0=失敗です
	JMPEQ	KOUGEI_MP_MY_NIGETA		; こわーい！
KOUGEI_MP_MY_2:					;

	MOV	AX,MY_MAGIC_KIND		; 魔法種類
	CALL	ACTION_MAGIC			; 魔法アクション

	CMP	MY_MAGIC_KIND,1			; 1=攻撃魔法
	JE	KOUGEI_MP_MY_KOHGEKI		;
	CMP	MY_MAGIC_KIND,2			; 2=防御魔法
	JE	KOUGEI_MP_MY_BOUGYO		;
	CMP	MY_MAGIC_KIND,3			; 3=治療魔法
	JE	KOUGEI_MP_MY_CHIRYO		;
	JMP	KOUGEI_MP_MY_NIGETA		; こわーい！

KOUGEI_MP_MY_BOUGYO:				; 防御魔法
	CALL	MM_BOUGYO			; 技／防御魔法
	JMP	KOUGEI_MP_MY_DOSURU		;

KOUGEI_MP_MY_CHIRYO:				; 治療魔法
	CALL	MM_CHIRYO			; 治療魔法
	JMP	KOUGEI_MP_MY_DOSURU		;

KOUGEI_MP_MY_KOHGEKI:				; 攻撃魔法
	CALL	MM_KOUGEKI			; 技／攻撃魔法
	CMP	BTL_KEKKA,2			; バトル結果  2=勝った
	JE	KOUGEI_MP_MY_KATTA		;
	JMP	KOUGEI_MP_MY_DOSURU		;

KOUGEI_MP_MY_DOSURU:
	MOV	BTL_KEKKA,1			; 1=どうする
	RET
KOUGEI_MP_MY_KATTA:
	PR_TXT	"@やった！"
	MOV	BTL_KEKKA,2			; 2=勝った
	RET
KOUGEI_MP_MY_NIGETA:
	PR_TXT	"@「＊＊＊＊＊」たじろぐ"
	CALL	MSG_MUSUME			; 「娘、」
	MOV	BTL_KEKKA,4			; 4=逃げた
	RET
KOUGEI_MP_MY	ENDP


; ****************************************************
;	敵の魔法
;	-I- TK_MAGIC_KIND : 魔法種類 0=通常,4=ニードル（攻）,5=ファイア（攻）
;			6=マジックミサイル（攻）,7=バリア（防）,8=ヒール（回）
;			9=サンダー（攻）
;	-O- BTL_KEKKA: バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

KOUGEI_MP_TK	PROC	NEAR
						; 敵は逃げるか！？
	CMP	PP_NIGE_FLG_TK,0		; 敵、逃げる禁止フラグ
	JNE	KOUGEI_MP_TK_2			;
	MOV	DX,PP_NIGERU_TK			; 敵、逃げる確率
	CALL	SAIKORO				; 成功判定
	CMP	AX,1				; 1=成功です,0=失敗です
	JMPEQ	KOUGEI_MP_TK_NIGETA		; 逃げた！
KOUGEI_MP_TK_2:

	MOV	AX,TK_MAGIC_KIND		; 魔法種類
	CALL	ACTION_MAGIC			; 魔法アクション

	CMP	TK_MAGIC_KIND,4			; 4=ニードル（攻）
	JE	KOUGEI_MP_TK_NIDLE		;
	CMP	TK_MAGIC_KIND,5			; 5=ファイア（攻）
	JE	KOUGEI_MP_TK_FIRE		;
	CMP	TK_MAGIC_KIND,6			; 6=マジックミサイル（攻）
	JE	KOUGEI_MP_TK_MISSILE		;
	CMP	TK_MAGIC_KIND,7			; 7=バリア（防）
	JE	KOUGEI_MP_TK_BARIA		;
	CMP	TK_MAGIC_KIND,8			; 8=ヒール（回）
	JE	KOUGEI_MP_TK_HEEL		;
	CMP	TK_MAGIC_KIND,9			; 9=サンダー（攻）
	JE	KOUGEI_MP_TK_THUNDER		;

	JMP	KOUGEI_MP_TK_NIGETA		; こわーい！

KOUGEI_MP_TK_NIDLE:				;
	CALL	MM_NIDLE			; 4ニードル（攻）
	JMP	KOUGEI_MP_TK_KOUGEKI		;
KOUGEI_MP_TK_FIRE:				;
	CALL	MM_FIRE				; 5ファイア（攻）
	JMP	KOUGEI_MP_TK_KOUGEKI		;
KOUGEI_MP_TK_MISSILE:				;
	CALL	MM_MISSILE			; 6マジックミサイル（攻）
	JMP	KOUGEI_MP_TK_KOUGEKI		;
KOUGEI_MP_TK_BARIA:				;
	CALL	MM_BARIA			; 7バリア（防）
	JMP	KOUGEI_MP_TK_DOSURU		;
KOUGEI_MP_TK_HEEL:				;
	CALL	MM_HEEL				; 8ヒール（回）
	JMP	KOUGEI_MP_TK_DOSURU		;
KOUGEI_MP_TK_THUNDER:				;
	CALL	MM_THUNDER			; 9サンダー（攻）
	JMP	KOUGEI_MP_TK_KOUGEKI		;

KOUGEI_MP_TK_KOUGEKI:
	CMP	BTL_KEKKA,3			; バトル結果  3=負けた
	JE	KOUGEI_MP_TK_SINDA		;
KOUGEI_MP_TK_DOSURU:
	MOV	BTL_KEKKA,1			; 1=どうする
	RET					;
KOUGEI_MP_TK_SINDA:
	PR_LF					;
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"はとどめをさされた。"		;
	MOV	BTL_KEKKA,3			; 3=負けた
	RET
KOUGEI_MP_TK_NIGETA:
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"は逃げた。"			;
	MOV	BTL_KEKKA,4			; 4=逃げた
	RET
KOUGEI_MP_TK	ENDP



; ****************************************************
;	敵のダメージ！
;	-I- DX        : ダメージ
;	-O- BTL_KEKKA : バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

DAMEGE_TK	PROC	NEAR
	PUSH	DX
	MOV	DX,CCT_OPEN_TYP_TK		; オープンタイプ・敵
	CALL	WIDCCT_CHANGE			; WINDOWS/キャラクタチェンジ
	POP	DX

	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	CALL	MSG_DAMEGE			; 「？？のダメージ！」

	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,23			; 23=ダメージ判定
	CALL	R_KEISAN			; 各計算処理
	MOV	PP_HP_TK,AX			; 敵のＨＰ
	CMP	DX,1				; 0=大丈夫,1=死にました
	JE	DAMEGE_TK_SINI			;

	MOV	BTL_KEKKA,1			; バトル結果  1=どうする
	JMP	DAMEGE_TK_SET			;
DAMEGE_TK_SINI:
	MOV	BTL_KEKKA,2			; バトル結果  2=勝った
	JMP	DAMEGE_TK_SET			;
DAMEGE_TK_SET:
	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	DX,0				; 復活するポイント
	MOV	S_FUNC,28			; 28=ＨＰセット
	CALL	R_KEISAN			; 各計算処理

	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,14			; 14=ヘッダー整合
	CALL	R_KEISAN			; 各計算処理

	MOVX	WDHNO,WIDTK_CHAR_NO		; 敵キャラクタＮｏ．
	CALL	WIDHED_D_HP			; WINDOWS/ヘッダ・ＨＰ表示
	RET
DAMEGE_TK	ENDP


; ****************************************************
;	私のダメージ！
;	-I- DX        : ダメージ
;	-O- BTL_KEKKA: バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

DAMEGE_MY	PROC	NEAR
	PUSH	DX
	MOV	DX,CCT_OPEN_TYP_MY		; オープンタイプ・私
	CALL	WIDCCT_CHANGE			; WINDOWS/キャラクタチェンジ
	POP	DX

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	CALL	MSG_DAMEGE			; 「？？のダメージ！」

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,23			; 23=ダメージ判定
	CALL	R_KEISAN			; 各計算処理
	MOV	PP_HP_MY,AX			; 私のＨＰ
	CMP	DX,1				; 0=大丈夫,1=死にました
	JE	DAMEGE_MY_SINI			;

	MOV	BTL_KEKKA,1			; バトル結果  1=どうする
	JMP	DAMEGE_MY_SET			;

DAMEGE_MY_SINI:
	MOV	BTL_KEKKA,3			; バトル結果  3=負けた
	JMP	DAMEGE_MY_SET			;

DAMEGE_MY_SET:
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	DX,0				; 復活するポイント
	MOV	S_FUNC,28			; 28=ＨＰセット
	CALL	R_KEISAN			; 各計算処理

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,14			; 14=ヘッダー整合
	CALL	R_KEISAN			; 各計算処理

	MOVX	WDHNO,WIDMY_GIRL_NO		; 私の娘Ｎｏ．
	CALL	WIDHED_D_HP			; WINDOWS/ヘッダ・ＨＰ表示
	RET
DAMEGE_MY	ENDP


; ****************************************************
;	敵へのダメージ値は！！
;	-I- PP_KAISIN_MY  : 私の会心確率
;	    PP_K_DAMEG_TK : 敵の会心ダメージ
;	    PP_DAMEG_TK   : 敵のダメージ
;	-O- DX            : ダメージ
; ****************************************************

DAMEGE_VAL_TK	PROC	NEAR
	MOV	DX,PP_KAISIN_MY			; 私の会心確率
	CALL	SAIKORO				; 成功判定
	CMP	AX,0				; 1=成功です,0=失敗です
	JE	DAMEGE_VAL_TK_NORMAL		;

DAMEGE_VAL_TK_KAISHIN:
	PR_LF					;
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"会心の一撃！"
	MOV	DX,PP_K_DAMEG_TK		; 敵の会心ダメージ
	RET
DAMEGE_VAL_TK_NORMAL:
	MOV	DX,PP_DAMEG_TK			; 敵のダメージ
	RET
DAMEGE_VAL_TK	ENDP


; ****************************************************
;	私へのダメージ値は！！
;	-I- PP_TUKON_TK   : 敵の痛恨確率
;	    PP_T_DAMEG_MY : 私の痛恨ダメージ
;	    PP_DAMEG_MY   : 私のダメージ
;	-O- DX            : ダメージ
; ****************************************************

DAMEGE_VAL_MY	PROC	NEAR
	MOV	DX,PP_TUKON_TK			; 敵の痛恨確率
	CALL	SAIKORO				; 成功判定
	CMP	AX,0				; 1=成功です,0=失敗です
	JE	DAMEGE_VAL_MY_NORMAL		;

DAMEGE_VAL_MY_KAISHIN:
	PR_LF
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"痛恨の一撃！"
	MOV	DX,PP_T_DAMEG_MY		; 私の痛恨ダメージ
	RET
DAMEGE_VAL_MY_NORMAL:
	MOV	DX,PP_DAMEG_MY			; 私のダメージ
	RET
DAMEGE_VAL_MY	ENDP


; ****************************************************
;	バトル選択
;	-O- BTL_CMND : バトルコマンド 1=攻撃,2=魔法,3=道具,4=逃げる
; ****************************************************

BTL_SELECT	PROC	NEAR

BTL_SELECT_START:				;
	CALL	R_SR_DOSURU			; "どうする？"
	CMP	PP_NIGE_FLG_MY,0		; 私、逃げる禁止フラグ
	JNE	BTL_SELECT_2			;

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	CALL	R_MAGIC_ARU			; 所有魔法ある？
	CMP	CX,0				; 技数
	JE	BTL_SELECT_11			;

	SELECT	"攻撃,魔法,道具を使う,逃げる"	;
	JMP	BTL_SELECT_3			;

BTL_SELECT_11:					;
	SELECT	"攻撃,道具を使う,逃げる"	;
	CMP	WIDSNM,1			; ユーザ選択番号
	JNE	BTL_SELECT_12			;
	INC	WIDSNM				;
	JMP	BTL_SELECT_3			;
BTL_SELECT_12:					;
	CMP	WIDSNM,2			;
	JNE	BTL_SELECT_13			;
	INC	WIDSNM				;
	JMP	BTL_SELECT_3			;
BTL_SELECT_13:					;
	JMP	BTL_SELECT_3			;

BTL_SELECT_2:					;
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	CALL	R_MAGIC_ARU			; 所有魔法ある？
	CMP	CX,0				; 技数
	JE	BTL_SELECT_21			;

	SELECT	"攻撃,魔法"	;,道具を使う"	;
	JMP	BTL_SELECT_3			;

BTL_SELECT_21:					;
	SELECT	"攻撃"		;,道具を使う"	;
	JMP	BTL_SELECT_3			;


BTL_SELECT_3:					;
	CMP	WIDSNM,OFFF			; ユーザ選択番号
	JNE	BTL_SELECT_SET			;

	PR_TXT	"@どうするのだ！！！"		;
	JMP	BTL_SELECT_START		;
BTL_SELECT_SET:
	MOV	AX,WIDSNM			; ユーザ選択番号
	INC	AX				;
	MOV	BTL_CMND,AX			; バトルコマンド
BTL_SELECT_EXIT:

	RET
BTL_SELECT	ENDP


; ****************************************************
;	レベルＵＰ処理
;	-I- BX : ヘッダ・アドレス
; ****************************************************

R_LEVEL_UP	PROC	NEAR
	CMP	BX,WIDMY_GIRL_OF		; 私の娘アドレス
	JNE	R_LEVEL_UP_5			;

	CALL	R_LEVEL_UP_GIRL			; 私の娘レベルＵＰ処理

	JMP	R_LEVEL_UP_EXIT
R_LEVEL_UP_5:
	MOV	AX,BX				; 私の娘アドレス
	MOV	S_FUNC,26			; 26=レベルＵＰ
	CALL	R_KEISAN			; 各計算処理
R_LEVEL_UP_EXIT:
	RET
R_LEVEL_UP	ENDP


; ****************************************************
;	私の娘レベルＵＰ処理
; ****************************************************

R_LEVEL_UP_GIRL		PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,26			; 26=レベルＵＰ
	CALL	R_KEISAN			; 各計算処理
	CMP	AX,1				; 1=レベルＵＰ
	JNE	R_LEVEL_UP_GIRL_EXIT		;

	PR_LF					;
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"はレベルが上がった。"

R_LEVEL_UP_GIRL_EXIT:
	RET
R_LEVEL_UP_GIRL		ENDP


; ****************************************************
;	各パラメータ
;	-I- WIDMY_GIRL_OF : 私の娘アドレス
;	    WIDTK_CHAR_OF : 敵キャラクタアドレス
; ****************************************************

PARAMETER_GET	PROC	NEAR

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,17			; 17=先手計算
	CALL	R_KEISAN			; 各計算処理
	MOV	PP_SENTE,AX			; 私の先手確率


	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,18			; 18=命中率計算
	CALL	R_KEISAN			; 各計算処理
	MOV	PP_MEICHU_MY,AX			; 命中率
	MOV	PP_MEICHU_TK,BX			; 敵命中率



	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,20			; 20=会心確率
	CALL	R_KEISAN			; 各計算処理
	MOV	PP_KAISIN_MY,AX			; 私の会心確率
	MOV	PP_TUKON_TK,BX			; 敵の痛恨確率


	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,21			; 21=逃げる成功率計算
	CALL	R_KEISAN			; 各計算処理
	MOV	PP_NIGE_HIT_MY,AX		; 逃げる成功率


	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,22			; 22=勝手に逃げる確率計算
	CALL	R_KEISAN			; 各計算処理
	MOV	PP_NIGERU_MY,AX			; 私、逃げる確率
	MOV	PP_NIGERU_TK,BX			; 敵、逃げる確率


;*;	CALL	PARAMETER_DAMEG			; ダメージ計算

;*;	LC	0,0
;*;	PRV	"私の先手確率=",PP_SENTE
;*;	PRV	"命中率      =",PP_MEICHU_MY
;*;	PRV	"敵命中率    =",PP_MEICHU_TK
;*;	PRV	"私のダメージ    =",PP_DAMEG_MY
;*;	PRV	"敵のダメージ    =",PP_DAMEG_TK
;*;	PRV	"私の魔法ダメージ=",PP_M_DAMEG_MY
;*;	PRV	"敵の魔法ダメージ=",PP_M_DAMEG_TK
;*;	PRV	"私の痛恨ダメージ=",PP_T_DAMEG_MY
;*;	PRV	"敵の会心ダメージ=",PP_K_DAMEG_TK
;*;	PRV	"私の会心確率  =",PP_KAISIN_MY
;*;	PRV	"敵の痛恨確率  =",PP_TUKON_TK
;*;	PRV	"逃げる成功率  =",PP_NIGE_HIT_MY
;*;	PRV	"私、逃げる確率=",PP_NIGERU_MY
;*;	PRV	"敵、逃げる確率=",PP_NIGERU_TK

	RET
PARAMETER_GET	ENDP


; ****************************************************
;	ダメージ計算
;	-I- WIDMY_GIRL_OF : 私の娘アドレス
;	    WIDTK_CHAR_OF : 敵キャラクタアドレス
; ****************************************************

PARAMETER_DAMEG	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,19			; 19=ダメージ計算
	CALL	R_KEISAN			; 各計算処理
	MOV	PP_DAMEG_MY,AX			; 私のダメージ
	MOV	PP_DAMEG_TK,BX			; 敵のダメージ
	MOV	PP_M_DAMEG_MY,CX		; 私の魔法ダメージ
	MOV	PP_M_DAMEG_TK,DX		; 敵の魔法ダメージ
	MOV	PP_T_DAMEG_MY,SI		; 私の痛恨ダメージ
	MOV	PP_K_DAMEG_TK,DI		; 敵の会心ダメージ
	RET
PARAMETER_DAMEG	ENDP


; ****************************************************
;	成功判定
;	-I- DX : 成功率
;	-O- AX : 1=成功です,0=失敗です
; ****************************************************

SAIKORO	PROC	NEAR
	MOV	V_SEIKOU,DX		; 成功率
	CALL	RANDAM_100		; 乱数１００
	MOV	V_SAIKORO,AX		; サイコロ

	CMPX	V_SEIKOU,V_SAIKORO	; 成功率 サイコロ
	JL	SAIKORO_OH_MY_GOT	;

SAIKORO_OK:
	MOV	AX,1			; 1=成功です
	RET
SAIKORO_OH_MY_GOT:
	MOV	AX,0			; 0=失敗です
	RET
SAIKORO	ENDP



;*;; ****************************************************
;*;;	敵決めセリフ
;*;; ****************************************************
;*;
;*;FUKI_TEKI	PROC	NEAR
;*;	MOV	DX,1			; ふきだし番号
;*;	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ
;*;
;*;	MOV	DX,1			; ふきだし番号
;*;	MOV	SI,OFFSET MSG_S1	;
;*;	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ
;*;
;*;	PR_TXT	"戦士シーラ「ハハハッ！青っちょろい小娘め、@"
;*;	PR_TXT	"私と戦うとは身の程を知らぬわっ！@"
;*;
;*;	MOV	AX,60*1			; wait timer count.
;*;	CALL	TMVWAT			; V-SYNC timer wait.
;*;
;*;	EXTRN	XSTOPX:FAR		; ＳＴＯＰキー終了処理
;*;	MOV	BP,SP			;
;*;	MOV	AX,OFFSET XSTOPX	; ＳＴＯＰキー終了処理
;*;	MOV	[BP],AX			; ＩＰ
;*;	MOV	AX,SEG CODE		;
;*;	MOV	[BP][2],AX		; ＣＳ
;*;	; SS:SP [  I P  ] +0
;*;	;       [  C S  ] +2
;*;	MOV	DX,1			; ふきだし番号
;*;	CALL	WIDFUKI_CLOSE		; WINDOWS/ふきだしウインドウＣＬＯＳＥ
;*;	RET
;*;FUKI_TEKI	ENDP


; ****************************************************
;	私、決めセリフ
; ****************************************************

FUKI_MY		PROC	NEAR
	RET
FUKI_MY		ENDP



; ****************************************************
;	攻撃アクション
; ****************************************************

ACTION_KOUGEKI	PROC	NEAR
	CMPX	PP_HP_TK,PINCH_HP_TK	; 敵のピンチＨＰ
	JBE	ACTION_KOUGEKI_STRAT	;
	JMP	ACTION_KOUGEKI_NORMAL	;

ACTION_KOUGEKI_STRAT:

	INC	PINCH_TK_LVL		; 敵のピンチレベル

	CALL	BLACK			; ブラックアウト

	MOV	AX,4			; wait timer count.
	CALL	TMVSET			; V-SYNC timer set.
	CALL	TMVEWT			; V-SYNC timer end wait.

	CALL	WHTFLS			; ＷＨＩＴＥ・ＦＬＡＳＨ

;*;	CALL	TEKIKIZU		; 敵キズ

	JMP	ACTION_KOUGEKI_EXIT	;

ACTION_KOUGEKI_NORMAL:			;

	MOV	AX,4			; wait timer count.
	CALL	TMVSET			; V-SYNC timer set.

	MOV	BX,0			; パレットテーブル番号
	MOV	CRXVEW,0		; 色相回転（０ー３６０）
	MOV	CRXCNS,100		; 彩度倍率（０ー１００）
	MOV	CRXBRI,100		; 明度倍率（０ー１００）
	MOV	CRXWHI,80		; ホワイトレベル（０ー１００）
	CALL	PLPSET			; パレット編集セット

	CALL	TMVEWT			; V-SYNC timer end wait.

	MOV	BX,0			;
	CALL	PLSET			; パレットセット

	MOV	AX,4			; wait timer count.
	CALL	TMVSET			; V-SYNC timer set.
	CALL	TMVEWT			; V-SYNC timer end wait.

ACTION_KOUGEKI_EXIT:			;
	RET
ACTION_KOUGEKI	ENDP


; ****************************************************
;	反撃アクション
; ****************************************************

ACTION_HANGEKI	PROC	NEAR
	CMPX	PP_HP_MY,PINCH_HP_MY	; 私のピンチＨＰ
	JBE	ACTION_HANGEKI_STRAT	;
	JMP	ACTION_HANGEKI_NORMAL	;

ACTION_HANGEKI_STRAT:
	MOV	CLRVEW,0		; color.
	MOV	CLRCNS,100		; contrast.
	MOV	CLRBRI,100		; brightness.
	CALL	COLFLS			; カラー・ＦＬＡＳＨ

	MOV	AX,4			; wait timer count.
	CALL	TMVSET			; V-SYNC timer set.
	CALL	TMVEWT			; V-SYNC timer end wait.

	MOV	BX,0			;
	CALL	PLSET			; パレットセット

	MOV	AX,4			; wait timer count.
	CALL	TMVSET			; V-SYNC timer set.
	CALL	TMVEWT			; V-SYNC timer end wait.

	INC	PINCH_MY_LVL		; 私のピンチレベル

ACTION_HANGEKI_GYA:
	CALL	CHISHIBUKI		; 血しぶき

;*;	MOV	AX,3			; wait timer count.
;*;	CALL	TMVSET			; V-SYNC timer set.
;*;	CALL	TMVEWT			; V-SYNC timer end wait.
;*;	MOV	CLRVEW,359		; color.
;*;	MOV	CLRCNS,100		; contrast.
;*;	MOV	CLRBRI,100		; brightness.
;*;	CALL	PLTCIS			; カラー・ＩＮ／時分割初期
;*;	MOV	CX,22			;
;*;ACTION_HANGEKI_GYA_L:			;
;*;	PUSH	CX			;
;*;	MOV	AX,1			; wait timer count.
;*;	CALL	TMVSET			; V-SYNC timer set.
;*;	CALL	PLTOLT			; パレット・オーバラップ／時分割処理
;*;	CALL	TMVEWT			; V-SYNC timer end wait.
;*;	POP	CX			;
;*;	LOOP	ACTION_HANGEKI_GYA_L	;
	JMP	ACTION_HANGEKI_EXIT	;

ACTION_HANGEKI_NORMAL:
	MOV	CLRVEW,0		; color.
	MOV	CLRCNS,100		; contrast.
	MOV	CLRBRI,100		; brightness.
	CALL	COLFLS			; カラー・ＦＬＡＳＨ
;*;	CALL	COLFUL			; カラー・ＦＵＬＬ
;*;	MOV	AX,10			; wait timer count.
;*;	CALL	TMVSET			; V-SYNC timer set.
;*;	CALL	TMVEWT			; V-SYNC timer end wait.
;*;	MOV	BX,0			;
;*;	CALL	PLSET			; パレットセット

ACTION_HANGEKI_EXIT:
	RET
ACTION_HANGEKI	ENDP


; ****************************************************
;	魔法アクション
;	-I- AX : 魔法
;		0=通常
;		1=攻撃魔法
;		2=防御魔法
;		3=治療魔法
;		4=ニードル（攻）
;		5=ファイア（攻）
;		6=マジックミサイル（攻）
;		7=バリア（防）
;		8=ヒール（回）
;		9=サンダー（攻）
; ****************************************************

ACTION_MAGIC	PROC	NEAR
	MOV	CLRVEW,60		; color.
	MOV	CLRCNS,50		; contrast.
	MOV	CLRBRI,100		; brightness.
	CALL	COLFLS			; カラー・ＦＬＡＳＨ
	RET
ACTION_MAGIC	ENDP


;*;; ****************************************************
;*;;	敵キズ
;*;; ****************************************************
;*;
;*;TEKIKIZU	PROC	NEAR
;*;
;*;	CALL	RANSU_PNT_TK		; 敵の乱数座標
;*;	MOV	DX,10			; ショック番号
;*;	CALL	PT_PUT_SHOCK		; ショックＰＵＴ
;*;
;*;	RET
;*;TEKIKIZU	ENDP


; ****************************************************
;	血しぶき
; ****************************************************

CHISHIBUKI	PROC	NEAR
	CMP	PINCH_MY_LVL,6		; 私のピンチレベル
	JNE	CHISHIBUKI_2		;

	CALL	RANSU_PNT		; 私の乱数座標
	CMP	AX,34			;
	JLE	CHISHIBUKI_1		;
	MOV	AX,34			;
CHISHIBUKI_1:
	CMP	BX,300			;
	JLE	CHISHIBUKI_12		;
	MOV	BX,300			;
CHISHIBUKI_12:
	MOV	DX,0			; ショック番号
	CALL	PT_PUT_SHOCK		; ショックＰＵＴ

CHISHIBUKI_2:

	CALL	RANSU_PNT		; 私の乱数座標
	MOV	DX,2			; ショック番号
	CALL	PT_PUT_SHOCK		; ショックＰＵＴ

	CALL	RANSU_PNT		; 私の乱数座標
	MOV	DX,4			; ショック番号
	CALL	PT_PUT_SHOCK		; ショックＰＵＴ

	CALL	RANSU_PNT		; 私の乱数座標
	MOV	DX,6			; ショック番号
	CALL	PT_PUT_SHOCK		; ショックＰＵＴ

	CALL	RANSU_PNT		; 私の乱数座標
	MOV	DX,8			; ショック番号
	CALL	PT_PUT_SHOCK		; ショックＰＵＴ
	RET
CHISHIBUKI	ENDP


; ****************************************************
;	私の乱数座標
;	-O- AX : Ｘ
;	    BX : Ｙ
; ****************************************************

RANSU_PNT	PROC	NEAR
	CALL	RANDAM_200		; 乱数２００
	MOV	XX1,AX			; Ｘ
	AND	XX1,0FFH		;256
RANSU_PNT_1:
	CMP	XX1,45			;
	JLE	RANSU_PNT_2		;
	SUB	XX1,45			;
	JMP	RANSU_PNT_1		;
RANSU_PNT_2:
	MOV	CX,150			;
	CALL	RANDAM_CX		; 乱数範囲指定
	MOV	YY1,AX			; Ｙ
	ADD	XX1,1			;
	ADD	YY1,140	+20		;DEMO
	MOV	AX,XX1			;
	MOV	BX,YY1			;
	RET
RANSU_PNT	ENDP


;*;; ****************************************************
;*;;	敵の乱数座標
;*;;	-O- AX : Ｘ
;*;;	    BX : Ｙ
;*;; ****************************************************
;*;
;*;RANSU_PNT_TK	PROC	NEAR
;*;	CALL	RANDAM_200		; 乱数２００
;*;	MOV	XX1,AX			; Ｘ
;*;	AND	XX1,0FH			; 16
;*;	CALL	RANDAM_200		; 乱数２００
;*;	MOV	YY1,AX			; Ｙ
;*;	ADD	XX1,18			;
;*;	ADD	YY1,100			;
;*;	MOV	AX,XX1			;
;*;	MOV	BX,YY1			;
;*;	RET
;*;RANSU_PNT_TK	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	赤のみ
;*;; ****************************************************
;*;
;*;RED_ONLY	PROC	NEAR
;*;	MOV	AX,DS			;
;*;	MOV	ES,AX			;
;*;	MOV	DI,OFFSET CRTSKP	; パレット編集処理のスキップ(1=ｽｷｯﾌﾟ)
;*;	MOV	AX,1			; 1=スキップ
;*;	MOV	CX,15			;
;*;	REP	STOSW			;
;*;	MOV	CRTSKP[10*2],1		; パレット編集処理のスキップ(1=ｽｷｯﾌﾟ)
;*;	CALL	BLACK			; ＢＬＡＣＫ
;*;	MOV	CRTSKP[10*2],0		; パレット編集処理のスキップ(1=ｽｷｯﾌﾟ)
;*;	RET
;*;RED_ONLY	ENDP


; ****************************************************
;	魔法の消費ＭＰチェック
;	-I- AX : キャラクタアドレス
;	    BX : 魔法番号
;	-O- AX : 0=ＯＫ,1=ＭＰが足りません
; ****************************************************

MAGIC_MP_CHECK	PROC	NEAR
	SHL	BX,1				; word pointer.
	MOV	DX,USE_MP_TABLE[BX]		; 消費ＭＰ
	MOV	S_FUNC,51			; 51=ＭＰの消費チェック
	CALL	R_KEISAN			; 各計算処理
	RET
MAGIC_MP_CHECK	ENDP


; ****************************************************
;	技／攻撃魔法
;	-O- BTL_KEKKA : バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

MM_KOUGEKI	PROC	NEAR
	PR_LF
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"の攻撃魔法@「＊＊＊＊＊」"	;

	MOV	DX,USE_MP_KOUGEKI		; 攻撃魔法・消費ＭＰ
	CALL	MP_SHOUHI_MY			; 私、消費ＭＰ

	MOV	DX,PP_M_DAMEG_TK		; 敵の魔法ダメージ
	CALL	DAMEGE_TK			; 敵のダメージ！
	RET
MM_KOUGEKI	ENDP


; ****************************************************
;	技／防御魔法
;	-I/O- MY_BOUGYO_UP_FLAG : 防御ＵＰフラグ 0=通常,1=装甲強度３０％ＵＰ
; ****************************************************

MM_BOUGYO	PROC	NEAR
	CMP	MY_BOUGYO_UP_FLAG,0	; 防御ＵＰフラグ
	JNE	MM_BOUGYO_EXIT		;

	MOV	MY_BOUGYO_UP_FLAG,1	;  1=装甲強度３０％ＵＰ

	MOV	DX,USE_MP_BOUGYO	; 防御魔法・消費ＭＰ
	CALL	MP_SHOUHI_MY		; 私、消費ＭＰ

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,53		; 53=装甲強度の一時ＵＰ
	CALL	R_KEISAN		; 各計算処理

	PR_LF
	CALL	MSG_MUSUME			; 「娘、」
	PR_TXT	"の装甲強度があがった！"

	CALL	PARAMETER_DAMEG		; ダメージ計算

MM_BOUGYO_EXIT:
	RET
MM_BOUGYO	ENDP


; ****************************************************
;	技／治療魔法
; ****************************************************

MM_CHIRYO	PROC	NEAR
	MOV	DX,USE_MP_CHIRYO	; 治療魔法・消費ＭＰ
	CALL	MP_SHOUHI_MY		; 私、消費ＭＰ

	MOV	CX,20			; 範囲　回復ポイントは１０から３０
	CALL	RANDAM_CX		; 乱数範囲指定
	ADD	AX,9			;
	MOV	DX,AX			; 復活するポイント=１からＣＸの数字

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,55		; 55=ＨＰの回復
	PUSH	DX
	CALL	R_KEISAN		; 各計算処理
	POP	DX

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	CALL	MSG_HP_KAIFUKU			; 「ＨＰが？？回復」

	RET
MM_CHIRYO	ENDP


; ****************************************************
;	4ニードル（攻）
;	-O- BTL_KEKKA : バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

MM_NIDLE	PROC	NEAR
	PR_LF
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"が二―ドルで攻撃！"

	MOV	DX,USE_MP_NIDLE			; ニードル（攻）・消費ＭＰ
	CALL	MP_SHOUHI_TK			; 敵、消費ＭＰ

	MOV	DX,PP_DAMEG_MY			; 私のダメージ
	CALL	DAMEGE_MY			; 私のダメージ！
	RET
MM_NIDLE	ENDP


; ****************************************************
;	5ファイア（攻）
;	-O- BTL_KEKKA : バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

MM_FIRE		PROC	NEAR
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"がファイアで攻撃！"

	MOV	DX,USE_MP_FIRE			; ファイア（攻）・消費ＭＰ
	CALL	MP_SHOUHI_TK			; 敵、消費ＭＰ

	MOV	DX,PP_DAMEG_MY			; 私のダメージ
	CALL	DAMEGE_MY			; 私のダメージ！
	RET
MM_FIRE		ENDP


; ****************************************************
;	6マジックミサイル（攻）
;	-O- BTL_KEKKA : バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

MM_MISSILE	PROC	NEAR
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"がマジックミサイルで攻撃！"

	MOV	DX,USE_MP_MISSILE	; マジックミサイル（攻）・消費ＭＰ
	CALL	MP_SHOUHI_TK			; 敵、消費ＭＰ

	MOV	DX,PP_DAMEG_MY			; 私のダメージ
	CALL	DAMEGE_MY			; 私のダメージ！
	RET
MM_MISSILE	ENDP


; ****************************************************
;	7バリア（防）
; ****************************************************

MM_BARIA	PROC	NEAR
	CMP	TK_BOUGYO_UP_FLAG,0	; 敵、防御ＵＰフラグ
	JNE	MM_BARIA_EXIT		;

	MOV	TK_BOUGYO_UP_FLAG,1	; 敵、防御ＵＰフラグ

	MOV	DX,USE_MP_BOUGYO	; 防御魔法・消費ＭＰ
	CALL	MP_SHOUHI_TK		; 敵、消費ＭＰ

	MOV	AX,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	S_FUNC,53		; 53=装甲強度の一時ＵＰ
	CALL	R_KEISAN		; 各計算処理

	PR_LF
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"がバリアでまもっている！"

	CALL	PARAMETER_DAMEG		; ダメージ計算

MM_BARIA_EXIT:
	RET
MM_BARIA	ENDP


; ****************************************************
;	8ヒール（回）
; ****************************************************

MM_HEEL		PROC	NEAR
	MOV	DX,USE_MP_HEEL			; ヒール（回）・消費ＭＰ
	CALL	MP_SHOUHI_TK			; 敵、消費ＭＰ

	MOV	CX,20			; 範囲　回復ポイントは１０から３０
	CALL	RANDAM_CX		; 乱数範囲指定
	ADD	AX,9			;
	MOV	DX,AX			; 復活するポイント=１からＣＸの数字

	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,55			; 55=ＨＰの回復
	PUSH	DX
	CALL	R_KEISAN			; 各計算処理
	POP	DX

	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	CALL	MSG_HP_KAIFUKU			; 「ＨＰが？？回復」

	RET
MM_HEEL		ENDP


; ****************************************************
;	9サンダー（攻）
;	-O- BTL_KEKKA : バトル結果  1=どうする,2=勝った,3=負けた,4=逃げた
; ****************************************************

MM_THUNDER	PROC	NEAR
	PR_LF					;
	CALL	MSG_TEKI			; 「敵、」
	PR_TXT	"がサンダーで攻撃！"

	MOV	DX,USE_MP_THUNDER		; サンダー（攻）・消費ＭＰ
	CALL	MP_SHOUHI_TK			; 敵、消費ＭＰ

	MOV	DX,PP_DAMEG_MY			; 私のダメージ
	CALL	DAMEGE_MY			; 私のダメージ！
	RET
MM_THUNDER	ENDP


; ****************************************************
;	全ての魔法がとける
; ****************************************************

ALL_MAGIC_CLEAR	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,54		; 54=装甲強度の通常値
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	S_FUNC,54		; 54=装甲強度の通常値
	CALL	R_KEISAN		; 各計算処理
	RET
ALL_MAGIC_CLEAR	ENDP


; ****************************************************
;	敵好メッセージ
;	-I- DX : 感情フラグ 1=敵意,2=好意
; ****************************************************

R_SENTOU_MSG	PROC	NEAR
	MOV	FLG_TK_KANJO,DX		; 感情フラグ 1=敵意,2=好意
	CALL	MSG_TK_KOU		; 敵好メッセージ
	RET
R_SENTOU_MSG	ENDP


; ****************************************************
;	敵好メッセージ
;	-I- FLG_TK_KANJO : 感情フラグ 1=敵意,2=好意
; ****************************************************

MSG_TK_KOU	PROC	NEAR
;*;	PR_LF					;
	CALL	R_SR_SR_KAKO			; "「"
	MOVX	R_SR_CHR_ADRS,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	AX,FLG_TK_KANJO			; 感情フラグ 1=敵意,2=好意
	CALL	R_SR_TK_MESSAGE			; 敵意、好意のメッセージ
	CALL	R_SR_SR_KOKA			; "」"
	RET
MSG_TK_KOU	ENDP


; ****************************************************
;	私、消費ＭＰ
;	-I- DX : 消費ＭＰ
; ****************************************************

MP_SHOUHI_MY	PROC	NEAR
	PUSH	DX
	MOV	DX,CCT_OPEN_TYP_MY		; オープンタイプ・私
	CALL	WIDCCT_CHANGE			; WINDOWS/キャラクタチェンジ
	POP	DX

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,52			; 52=ＭＰの消費
	CALL	R_KEISAN			; 各計算処理

	RET
MP_SHOUHI_MY	ENDP


; ****************************************************
;	敵、消費ＭＰ
; ****************************************************

MP_SHOUHI_TK	PROC	NEAR
	PUSH	DX
	MOV	DX,CCT_OPEN_TYP_TK		; オープンタイプ・敵
	CALL	WIDCCT_CHANGE			; WINDOWS/キャラクタチェンジ
	POP	DX

	MOV	AX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,52			; 52=ＭＰの消費
	CALL	R_KEISAN			; 各計算処理
	RET
MP_SHOUHI_TK	ENDP


; ****************************************************
;	「娘、」
; ****************************************************

MSG_MUSUME	PROC	NEAR
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_SR_GIRL_NAME			; キャラクタ名
	RET
MSG_MUSUME	ENDP


; ****************************************************
;	「敵、」
; ****************************************************

MSG_TEKI	PROC	NEAR
	MOVX	R_SR_CHR_ADRS,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	CALL	R_SR_GIRL_NAME			; キャラクタ名
	RET
MSG_TEKI	ENDP


; ****************************************************
;	「ＨＰが？？回復」
;	-I- AX : キャラクタアドレス
;	    DX : 回復ポイント
; ****************************************************

MSG_HP_KAIFUKU	PROC	NEAR
	PUSH	DX
	PUSH	AX
	PR_TXT	"@魔法で"
	POP	R_SR_CHR_ADRS			; キャラクタアドレス
	CALL	R_SR_GIRL_NAME			; キャラクタ名
	PR_TXT	"のＨＰが"
	POP	DX
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"回復"
	RET
MSG_HP_KAIFUKU	ENDP


; ****************************************************
;	「？？のダメージ！」
;	-I- AX : キャラクタアドレス
;	    DX : ダメージ
; ****************************************************

MSG_DAMEGE	PROC	NEAR
	PUSH	DX

	PUSH	DX
	PUSH	AX
	PR_LF
	POP	R_SR_CHR_ADRS			; キャラクタアドレス
	CALL	R_SR_GIRL_NAME			; キャラクタ名
	PR_TXT	"は"
	POP	DX
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"のダメージを受けた！"

	POP	DX
	RET
MSG_DAMEGE	ENDP


; ****************************************************
;	魔法番号の検索
;	-I- BX : 魔法文字のアドレス
;	-O- AX : 魔法番号
;		 0=通常
;		 1=攻撃魔法
;		 2=防御魔法
;		 3=治療魔法
;		 4=ニードル（攻）
;		 5=ファイア（攻）
;		 6=マジックミサイル（攻）
;		 7=バリア（防）
;		 8=ヒール（回）
;		 9=サンダー（攻）
; ****************************************************

MAGIC_NUMBER	PROC	NEAR
	CALL	R_ENV_IDNAME		; 環境文字のＩＤ検索
	CMP	AX,0			; 0=見つからない
	JE	MAGIC_NUMBER_N0		;

	MOV	AX,0			;

	CMP	DL,ID_48		; 攻撃魔法
	JE	MAGIC_NUMBER_N1		;
	CMP	DL,ID_49		; 防御魔法	
	JE	MAGIC_NUMBER_N2		;
	CMP	DL,ID_50		; 治療魔法	
	JE	MAGIC_NUMBER_N3		;
	CMP	DL,ID_110		; ニードル
	JE	MAGIC_NUMBER_N4		;
	CMP	DL,ID_111		; ファイア
	JE	MAGIC_NUMBER_N5		;
	CMP	DL,ID_112		; マジックミサイル
	JE	MAGIC_NUMBER_N6		;
	CMP	DL,ID_113		; バリア
	JE	MAGIC_NUMBER_N7		;
	CMP	DL,ID_114		; ヒール
	JE	MAGIC_NUMBER_N8		;
	CMP	DL,ID_115		; サンダー
	JE	MAGIC_NUMBER_N9		;
MAGIC_NUMBER_N0:
	MOV	AL,0			; 0=通常
	RET
MAGIC_NUMBER_N1:
	MOV	AL,1			; 1=攻撃魔法
	RET
MAGIC_NUMBER_N2:
	MOV	AL,2			; 2=防御魔法
	RET
MAGIC_NUMBER_N3:
	MOV	AL,3			; 3=治療魔法
	RET
MAGIC_NUMBER_N4:
	MOV	AL,4			; 4=ニードル（攻）
	RET
MAGIC_NUMBER_N5:
	MOV	AL,5			; 5=ファイア（攻）
	RET
MAGIC_NUMBER_N6:
	MOV	AL,6			; 6=マジックミサイル（攻）
	RET
MAGIC_NUMBER_N7:
	MOV	AL,7			; 7=バリア（防）
	RET
MAGIC_NUMBER_N8:
	MOV	AL,8			; 8=ヒール（回）
	RET
MAGIC_NUMBER_N9:
	MOV	AL,9			; 9=サンダー（攻）
	RET
MAGIC_NUMBER	ENDP



; ****************************************************
;	敵から金と経験値を貰う
;	-O- GIVE_MONEY  : お金
;	    GIVE_KEIKEN : 経験値
; ****************************************************

VICTORY_TK_UBAU	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	BX,WIDTK_CHAR_OF		; 敵キャラクタアドレス
	MOV	S_FUNC,69			; 69=敵から金と経験値を貰う
	CALL	R_KEISAN			; 各計算処理
	MOV	GIVE_MONEY,AX			; お金
	MOV	GIVE_KEIKEN,DX			; 経験値

	MOV	DX,GIVE_KEIKEN			; 経験値
	CALL	R_SR_BATLE_KEIKEN		; 経験値ｍを得た。
	PR_LF
	MOV	DX,GIVE_MONEY			; お金
	CALL	R_SR_BATLE_OKANE		; お金ｍを得た。

	CALL	WIDHED_D_HP			; WINDOWS/ヘッダ・ＨＰ表示

	RET
VICTORY_TK_UBAU	ENDP


; ****************************************************
;	戦闘・星座セット
; ****************************************************

SENTOU_SEIZA	PROC	NEAR

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	SI,WIDOFS_VAL			; 内容表示テーブルオフセット
	MOV	BX,ES:[SI][VTB_SEIZA][VAL_VALUE] ; 星座名

	CALL	WIDHED_C_SEIZA			; WINDOWS/星座チェック
	MOV	SEIZA_MY,CX			; 私の星座

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	SI,WIDOFS_VL_TK			; 敵・内容表示オフセット
	MOV	BX,ES:[SI][VTB_SEIZA][VAL_VALUE] ; 星座名

	CALL	WIDHED_C_SEIZA			; WINDOWS/星座チェック
	MOV	SEIZA_TK,CX			; 敵の星座

;*;	PRV	"SEIZA_MY=",SEIZA_MY
;*;	PRV	"SEIZA_TK=",SEIZA_TK

	RET
SENTOU_SEIZA	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	WIDSNM:WORD		; ユーザ選択番号
EXTRN	S_FUNC:WORD		; 計算ファンクション

EXTRN	R_SR_CHR_ADRS:WORD	; 台詞・キャラクタアドレス
EXTRN	R_SR_ITM_ADRS:WORD	; 台詞・アイテムアドレス

EXTRN	WDX1:WORD		; WINDOWS/ point x1.
EXTRN	WDY1:WORD		; WINDOWS/ point y1.
EXTRN	WDX2:WORD		; WINDOWS/ point x2.
EXTRN	WDY2:WORD		; WINDOWS/ point y2.

CHAR_MY_GIRL	DW	0	; キャラクタ番号／私の娘
CHAR_RIVAL	DW	1	; キャラクタ番号／私の娘のライバル

PINCH_HP_MY	DW	20	; 私のピンチＨＰ
PINCH_MY_LVL	DW	0	; 私のピンチレベル

PINCH_HP_TK	DW	20	; 敵のピンチＨＰ
PINCH_TK_LVL	DW	0	; 敵のピンチレベル

SEIZA_MY	DW	0	; 私の星座
SEIZA_TK	DW	0	; 敵の星座

BTL_CMND	DW	0	; バトルコマンド
				; 1=攻撃,2=魔法,3=道具,4=逃げる

BTL_KEKKA	DW	0	; バトル結果
				; 1=どうする,2=勝った,3=負けた,4=逃げた
				; 5=敵が去る,6=やり過ごす,7=脱出成功

BWID_XP		DW	0	; ウインドウ左上座標Ｘ
BWID_YP		DW	0	; ウインドウ左上座標Ｙ
BWID_XL		DW	51	; ウインドウサイズＸ
BWID_YL		DW	400	; ウインドウサイズＹ

BTL_COUNT	DW	0	; バトル回数

PP_SENTE	DW	0	; 私の先手確率

PP_MEICHU_MY	DW	0	; 命中率
PP_MEICHU_TK	DW	0	; 敵命中率

PP_DAMEG_MY	DW	0	; 私のダメージ
PP_DAMEG_TK	DW	0	; 敵のダメージ

PP_M_DAMEG_MY	DW	0	; 私の魔法ダメージ
PP_M_DAMEG_TK	DW	0	; 敵の魔法ダメージ

PP_T_DAMEG_MY	DW	0	; 私の痛恨ダメージ
PP_K_DAMEG_TK	DW	0	; 敵の会心ダメージ

PP_KAISIN_MY	DW	0	; 私の会心確率
PP_TUKON_TK	DW	0	; 敵の痛恨確率

PP_NIGE_HIT_MY	DW	0	; 逃げる成功率
PP_NIGERU_MY	DW	0	; 私、逃げる確率
PP_NIGERU_TK	DW	0	; 敵、逃げる確率
PP_NIGE_FLG_MY	DW	0	; 私、逃げる禁止フラグ
PP_NIGE_FLG_TK	DW	0	; 敵、逃げる禁止フラグ

PP_HP_MY	DW	0	; 私のＨＰ
PP_HP_TK	DW	0	; 敵のＨＰ


V_SEIKOU	DW	0	; 成功率
V_SAIKORO	DW	0	; サイコロ

FLG_TK_KANJO	DW	0	; 感情フラグ 1=敵意,2=好意

XX1		DW	0	; Ｘ
YY1		DW	0	; Ｙ

MY_MAGIC_KIND	DW	0	; 私、魔法種類
TK_MAGIC_KIND	DW	0	; 敵、魔法種類
				;  0=通常
				;  1=攻撃魔法
				;  2=防御魔法
				;  3=治療魔法
				;  4=ニードル（攻）
				;  5=ファイア（攻）
				;  6=マジックミサイル（攻）
				;  7=バリア（防）
				;  8=ヒール（回）
				;  9=サンダー（攻）

MY_BOUGYO_UP_FLAG DW	0	; 私、防御ＵＰフラグ
TK_BOUGYO_UP_FLAG DW	0	; 敵、防御ＵＰフラグ
				;  0=通常
				;  1=装甲強度３０％ＵＰ

USE_MP_TABLE	LABEL	WORD	; 消費ＭＰテーブル
		DW	0	; 0
USE_MP_KOUGEKI	DW	20	; 1攻撃魔法・消費ＭＰ
USE_MP_BOUGYO	DW	15	; 2防御魔法・消費ＭＰ
USE_MP_CHIRYO	DW	5	; 3治療魔法・消費ＭＰ
USE_MP_NIDLE	DW	20	; 4ニードル（攻）・消費ＭＰ
USE_MP_FIRE	DW	20	; 5ファイア（攻）・消費ＭＰ
USE_MP_MISSILE	DW	20	; 6マジックミサイル（攻）・消費ＭＰ
USE_MP_BARIA	DW	15	; 7バリア（防）・消費ＭＰ
USE_MP_HEEL	DW	5	; 8ヒール（回）・消費ＭＰ
USE_MP_THUNDER	DW	20	; 9サンダー（攻）・消費ＭＰ

TAG_LEVEL	DW	0	; 第何試合か？

GIVE_MONEY	DW	0	; お金
GIVE_KEIKEN	DW	0	; 経験値

DATA	ENDS

	END
;
;	end of "R_SENTOU.ASM"
;
