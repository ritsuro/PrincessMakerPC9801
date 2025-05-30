; "R_SOUBI.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	装備
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC

CCT_OPEN_TYPE	EQU	7	; オープンタイプ

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


PUBLIC	R_SOUBI			; 装備

PUBLIC	R_SOUBI_KISEKAE		; 着せ替えモード

PUBLIC	R_SOUBI_S_DOUGU		; 戦闘時・道具の使用

EXTRN	R_LOADS:NEAR		; ロード＆セーブ

EXTRN	R_DISP_ITEM_M:NEAR	; 持物アイテム表示

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	MUSIC_KOSODATE:NEAR	; 子育てのテーマ

EXTRN	R_ITEM_SCH:NEAR		; アイテム条件検索
EXTRN	R_ITM_SYUBETU:NEAR	; 持物アイテム種別検索
EXTRN	R_ITM_OFFSET:NEAR	; 持物アイテムのアイテムオフセット計算
EXTRN	R_ITM_MOCH_DEL:NEAR	; 持物アイテム削除
EXTRN	R_GET_SELECT:NEAR	; ｱｲﾃﾑレコード内から選択単語を取り出す
EXTRN	R_ADD_SELECT:NEAR	; 選択単語へ追加
EXTRN	R_ITM_MOCHIMON:NEAR	; 持物アイテム検索

EXTRN	R_SR_GIRL_NAME:NEAR	; キャラクタ名
EXTRN	R_SR_GIRL_SHOGO:NEAR	; キャラクタの称号
EXTRN	R_SR_GIRL_HELP:NEAR	; キャラクタに対する説明

EXTRN	R_SR_ITEM_HELP:NEAR	; アイテムに対する説明
EXTRN	R_SR_ITEM_PRICE:NEAR	; アイテムに対する値段

EXTRN	R_SR_GIRL_FUKU:NEAR	; キャラクタ服名
EXTRN	R_SR_SR_DESU:NEAR	; "です"
EXTRN	R_SR_NAINAI:NEAR	; "「なにもないよ、シクシク」"

EXTRN	R_SCHO_KISEKAE:NEAR	; 娘着せ替えの処理


EXTRN	WIDSTAT_INIT:NEAR	; WIDNOWS/ステータスウインドウ初期処理
EXTRN	WIDSTAT:NEAR		; WINDOWS/ステータス

EXTRN	WIDSLC_INIT:NEAR	; WINDOWS/セレクト・ウインドウ初期処理
EXTRN	WIDSLC:NEAR		; WINDOWS/セレクト・ウインドウ

EXTRN	WIDITEM_CLEAR:NEAR	; WINDOWS/アイテム表示設定クリア
EXTRN	WIDITEM_INIT:NEAR	; WINDOWS/アイテム管理初期処理
EXTRN	WIDITEM_OPEN:NEAR	; WINDOWS/アイテムオープン
EXTRN	WIDITEM_CLOSE:NEAR	; WINDOWS/アイテムクローズ

EXTRN	WIDBAR_SOUBI_OPEN:NEAR	; WINDOWS/バー・装備ＯＰＥＮ
EXTRN	WIDBAR_SOUBI_CLOSE:NEAR	; WINDOWS/バー・装備ＣＬＯＳＥ
EXTRN	WIDBAR_SOUBI:NEAR	; WINDOWS/バー・装備ＰＵＴ

EXTRN	WIDWAZA_OPEN:NEAR	; WINDOWS/技（わざ）オープン
EXTRN	WIDWAZA_CLOSE:NEAR	; WINDOWS/技（わざ）クローズ

EXTRN	WIDWORKS_OPEN:NEAR	; WINDOWS/行い（おこない）オープン
EXTRN	WIDWORKS_CLOSE:NEAR	; WINDOWS/行い（おこない）クローズ

EXTRN	WIDDSP_SAVE:NEAR	; WINDOWS/画面退避
EXTRN	WIDDSP_LOAD:NEAR	; WINDOWS/画面復元
EXTRN	WIDDSP_SV_H:NEAR	; WINDOWS/画面範囲退避
EXTRN	WIDDSP_LD_H:NEAR	; WINDOWS/画面範囲復元
EXTRN	WIDFRM_BACKSAVE:NEAR	; WINDOWS/背景をセーブ
EXTRN	WIDFRM_BACKLOAD:NEAR	; WINDOWS/背景をロード

EXTRN	WIDCCT_INIT:NEAR	; WINDOWS/キャラクタ初期処理
EXTRN	WIDCCT_OPEN:NEAR	; WINDOWS/キャラクタオープン
EXTRN	WIDCCT_CLOSE:NEAR	; WINDOWS/キャラクタクローズ
EXTRN	WIDCCT_CHANGE:NEAR	; WINDOWS/キャラクタチェンジ

EXTRN	WIDHBR_INIT:NEAR	; WINDOWS/横グラフ初期処理
EXTRN	WIDHBR:NEAR		; WINDOWS/横グラフ表示
EXTRN	WIDHBRS:NEAR		; WINDOWS/横グラフ再表示
EXTRN	WIDHBR_MAX:NEAR		; WINDOWS/横グラフ最大表示
EXTRN	WIDHBR_RELOC:NEAR	; WINDOWS/横グラフ位置変更

EXTRN	TEST_MUSIC_M:NEAR	; 音楽テスト（メニュー付き）

EXTRN	TKRHME:NEAR		; 台詞ホームポジション

EXTRN	MSCSRT:NEAR		; カーソルスタート
EXTRN	MSCMOV:NEAR		; カーソル移動
EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR		; カーソルストップ
EXTRN	MSCSTS:NEAR		; マウスカーソルステータス

EXTRN	KEYTEN:NEAR		; キーボード・読み込み


; ****************************************************
;	装備
;	-O- AX  : 0=通常,1=データをロードした。
; ****************************************************

R_SOUBI		PROC	NEAR
	CALL	TKRHME			; 台詞ホームポジション
	PR_TXT	"えーと、この子の現在の状態は………"

	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス

	CALL	WIDDSP_SAVE			; WINDOWS/画面退避

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,14			; 14=ヘッダー整合
	CALL	R_KEISAN			; 各計算処理

	MOVX	W_STAT_HEAD_NO,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	CALL	WIDSTAT				; WINDOWS/ステータス

;*NON*;	MOV	WDGNO,0				; 0. 体力
;*NON*;	CALL	WIDHBRS				; WINDOWS/横グラフ再表示

R_SOUBI_LOOP:					;
SELECT	"武器の装備,兜の装備,鎧の装備,道具を使う,着がえ,セーブ,ロード,おわりました"

	CALL	WIDDSP_LOAD			; WINDOWS/画面復元

	CMP	WIDSNM,0			;
	JE	R_SHOW_BUKI			; 0.武器
	CMP	WIDSNM,1			;
	JE	R_SHOW_BOUGU_KABUTO		; 1.防具・兜
	CMP	WIDSNM,2			;
	JE	R_SHOW_BOUGU_YOROI		; 2.防具・鎧
	CMP	WIDSNM,3			;
	JE	R_SOUBI_DOUGU			; 3.道具
	CMP	WIDSNM,4			;
	JE	R_SOUBI_KIGAE			; 4.着替え
	CMP	WIDSNM,5			;
	JE	R_SOUBI_SAVE			; 5.セーブ
	CMP	WIDSNM,6			;
	JE	R_SOUBI_LOAD			; 6.ロード
	CMP	WIDSNM,OFFF			;
	JE	R_SOUBI_EXIT			;

	JMP	R_SOUBI_EXIT			;

R_SHOW_BUKI:					;
	CALL	SHOW_BUKI			; 0.武器
	JMP	R_SOUBI_LOOP			;
R_SHOW_BOUGU_KABUTO:				;
	CALL	SHOW_BOUGU_KABUTO		; 1.防具・兜
	JMP	R_SOUBI_LOOP			;
R_SHOW_BOUGU_YOROI:				;
	CALL	SHOW_BOUGU_YOROI		; 2.防具・鎧
	JMP	R_SOUBI_LOOP			;
R_SOUBI_DOUGU:					;
	CALL	DOUGU_MENU			; 3.道具 道具メニュー
	JMP	R_SOUBI_LOOP			;
R_SOUBI_KIGAE:					;
	CALL	KISEKAE_MODE			; 4.着せ替えモード
	JMP	R_SOUBI_LOOP			;
R_SOUBI_SAVE:					;
	CALL	DSK_SAVE			; 5.セーブ
	JMP	R_SOUBI_LOOP			;
R_SOUBI_LOAD:					;
	CALL	DSK_LOAD			; 6.ロード
	CMP	AX,1				; 0=通常,1=データロード
	JE	R_SOUBI_NEW_LOAD		;
	JMP	R_SOUBI_LOOP			;

R_SOUBI_EXIT:
	CALL	TKRHME				; 台詞ホームポジション
	MOV	AX,0				; 0=通常
	RET
R_SOUBI_NEW_LOAD:
	CALL	TKRHME				; 台詞ホームポジション
	MOV	AX,1				; 1=データをロードした。
	RET
R_SOUBI		ENDP


; ****************************************************
;	着せ替えモード
; ****************************************************

R_SOUBI_KISEKAE		PROC	NEAR
	CALL	KISEKAE_MODE		; 着せ替えモード
	RET
R_SOUBI_KISEKAE		ENDP


; ****************************************************
;	戦闘時・道具の使用
; ****************************************************

R_SOUBI_S_DOUGU	PROC	NEAR
	PR_TXT	"@道具"

	MOV	WDX1,1	;0		; エリア左上座標Ｘ
	MOV	WDY1,1	;0		; エリア左上座標Ｙ
	MOV	WDX2,48	;51		; エリアサイズＸ
	MOV	WDY2,364;400-33		; エリアサイズＹ
	CALL	WIDDSP_SV_H		; WINDOWS/画面範囲退避
;*;	MOV	DX,0			; 背景退避用パーツバンク番号＃0
;*;	CALL	WIDFRM_BACKSAVE		; WINDOWS/背景をセーブ

	MOV	ITEM_ATTR,4		; アイテム種別 4=道具
	CALL	SHOW_MOCHIMONO		; 持物は？

	CMP	K_TBL_MAX,0		; 検索レコード数
	JMPEQ	R_SOUBI_S_DOUGU_NONE	;

	PR_TXT	"@どれか、使いますか？"

	CALL	R_ITM_OFFSET		; 持物アイテムのアイテムオフセット計算

	MOV	BX,0			; 何ワード目か
	CALL	R_GET_SELECT		; ｱｲﾃﾑレコード内から選択単語を取り出す

	CALL	WIDSLC			; WINDOWS/セレクト・ウインドウ

	MOV	WDX1,1	;0		; エリア左上座標Ｘ
	MOV	WDY1,1	;0		; エリア左上座標Ｙ
	MOV	WDX2,48	;51		; エリアサイズＸ
	MOV	WDY2,364;400-33		; エリアサイズＹ
	CALL	WIDDSP_LD_H		; WINDOWS/画面範囲復元
;*;	CALL	WIDFRM_BACKLOAD		; WINDOWS/背景をロード

	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JMPEQ	R_SOUBI_S_DOUGU_EXIT	;


	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	BX,WIDSNM		; ユーザ選択番号
	SHL	BX,1			;
	MOV	DX,DS:K_TBL_OFSET[BX]	; アイテム（道具）アドレス
	MOV	S_FUNC,13		; 13=道具使用
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,WIDSNM		; ユーザ選択番号
	SHL	BX,1			;
	MOV	DX,DS:K_TBL_MOCHI[BX]	; DX=持物リスト削除番号
	CALL	R_ITM_MOCH_DEL		; 持物アイテム削除

	JMP	R_SOUBI_S_DOUGU_EXIT	;

R_SOUBI_S_DOUGU_NONE:			;
	CALL	R_SR_NAINAI		; "「なにもないよ、シクシク」"
R_SOUBI_S_DOUGU_EXIT:			;
	RET
R_SOUBI_S_DOUGU	ENDP


;*NON*;; ****************************************************
;*NON*;;	装備メニュー
;*NON*;; ****************************************************
;*NON*;
;*NON*;SOUBI_MENU	PROC	NEAR
;*NON*;	PR_TXT	"なにを装備しますか？@"
;*NON*;
;*NON*;	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
;*NON*;SOUBI_MENU_SEL:
;*NON*;	S_CALL	"武器,兜,鎧,やめる",SOUBI_MENU_EE
;*NON*;	DW	SHOW_BUKI			; 0.武器
;*NON*;	DW	SHOW_BOUGU_KABUTO		; 1.防具・兜
;*NON*;	DW	SHOW_BOUGU_YOROI		; 2.防具・鎧
;*NON*;	DW	NONE_NONE			; 3.やめる
;*NON*;SOUBI_MENU_EE:
;*NON*;	CMP	WIDSNM,3			; ユーザ選択番号
;*NON*;	JE	SOUBI_MENU_EXIT
;*NON*;	CMP	WIDSNM,OFFF			; ユーザ選択番号
;*NON*;	JE	SOUBI_MENU_EXIT
;*NON*;
;*NON*;	JMP	SOUBI_MENU_SEL
;*NON*;
;*NON*;SOUBI_MENU_EXIT:
;*NON*;	CALL	R_SR_GIRL_NAME			; キャラクタ名
;*NON*;	PR_TXTR	"は装備を終えた。@"
;*NON*;SOUBI_MENU_BREAK:
;*NON*;	RET
;*NON*;SOUBI_MENU_MACHIGAE:
;*NON*;	PR_TXTR	"やめる。@"
;*NON*;	RET
;*NON*;SOUBI_MENU	ENDP


; ****************************************************
;	ロード
;	-O- AX : 0=通常,1=データロード
; ****************************************************

DSK_LOAD	PROC	NEAR
	PR_CLS
	PR_TXT	"ロード"
	MOV	R_LOAD_FUNC,1		; 1=ロード
	CALL	R_LOADS			; ロード＆セーブ
	RET
DSK_LOAD	ENDP


; ****************************************************
;	セーブ
; ****************************************************

DSK_SAVE	PROC	NEAR
	PR_CLS
	PR_TXT	"セーブ"
	MOV	R_LOAD_FUNC,2		; 2=セーブ
	CALL	R_LOADS			; ロード＆セーブ
	RET
DSK_SAVE	ENDP


; ****************************************************
;	道具メニュー
; ****************************************************

DOUGU_MENU	PROC	NEAR
	PR_TXT	"@道具"

	MOV	ITEM_ATTR,4		; アイテム種別 4=道具
	CALL	SHOW_MOCHIMONO		; 持物は？

	CMP	K_TBL_MAX,0		; 検索レコード数
	JMPEQ	DOUGU_MENU_NONE		;

	PR_TXT	"@どれを、使いますか？"

	CALL	R_ITM_OFFSET		; 持物アイテムのアイテムオフセット計算

	MOV	BX,0			; 何ワード目か
	CALL	R_GET_SELECT		; ｱｲﾃﾑレコード内から選択単語を取り出す

	CALL	WIDSLC			; WINDOWS/セレクト・ウインドウ

	CALL	WIDDSP_LOAD		; WINDOWS/画面復元

	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JMPEQ	DOUGU_MENU_EXIT		;


	MOVX	W_STAT_HEAD_NO,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	CALL	WIDSTAT				; WINDOWS/ステータス

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	SI,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	BX,WIDSNM		; ユーザ選択番号
	SHL	BX,1			;
	MOV	DX,DS:K_TBL_OFSET[BX]	; アイテム（道具）アドレス
	MOV	S_FUNC,13		; 13=道具使用
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	BX,WIDSNM		; ユーザ選択番号
	SHL	BX,1			;
	MOV	DX,DS:K_TBL_MOCHI[BX]	; DX=持物リスト削除番号
	CALL	R_ITM_MOCH_DEL		; 持物アイテム削除

	JMP	DOUGU_MENU_EXIT		;
DOUGU_MENU_NONE:			;
	SELECT	"「＊＊＊＊＊＊＊＊＊＊＊」"
DOUGU_MENU_EXIT:
	RET
DOUGU_MENU	ENDP


; ****************************************************
;	着せ替えモード
; ****************************************************

KISEKAE_MODE	PROC	NEAR
	PR_TXT	"@着替え"
KISEKAE_MODE_LOOP:
	PR_TXT	"@どうする"

	CALL	KEYTEN		; キーボード・読み込み
	CMP	BX,1		; 1=HELP,2=HOME,3=PLUS,4=ESC (-1:押していない)
	JE	KISEKAE_MODE_12

KISEKAE_MODE_11:
	SELECT	"春服,夏服,秋服,冬服,おわりました"
	JMP	KISEKAE_MODE_13
KISEKAE_MODE_12:
	SELECT	"春服,夏服,秋服,冬服,おわりました,とりあえず脱ぐ,おんがく"
KISEKAE_MODE_13:

	CMP	WIDSNM,0			; 春服
	JE	KISEKAE_MODE_HARU		;
	CMP	WIDSNM,1			; 夏服
	JE	KISEKAE_MODE_NATSU		;
	CMP	WIDSNM,2			; 秋服
	JE	KISEKAE_MODE_AKI		;
	CMP	WIDSNM,3			; 冬服
	JE	KISEKAE_MODE_FUYU		;
	CMP	WIDSNM,4			; おわりました
	JE	KISEKAE_MODE_OWARI		;
	CMP	WIDSNM,5			; とりあえず脱ぐ
	JE	KISEKAE_MODE_NUGU		;
	CMP	WIDSNM,6			; 音楽
	JE	KISEKAE_MODE_MUSIC		;
	CMP	WIDSNM,OFFF			; EXIT
	JE	KISEKAE_MODE_OWARI		;
	JMP	KISEKAE_MODE_NEXT		;
KISEKAE_MODE_HARU:				;
	MOV	DX,1				; 何を着る 1=春服
	CALL	KISEKAE_KIRU			; 着替え・着る
	JMP	KISEKAE_MODE_NEXT		;
KISEKAE_MODE_NATSU:				;
	MOV	DX,2				; 何を着る 2=夏服
	CALL	KISEKAE_KIRU			; 着替え・着る
	JMP	KISEKAE_MODE_NEXT		;
KISEKAE_MODE_AKI:				;
	MOV	DX,3				; 何を着る 3=秋服
	CALL	KISEKAE_KIRU			; 着替え・着る
	JMP	KISEKAE_MODE_NEXT		;
KISEKAE_MODE_FUYU:				;
	MOV	DX,4				; 何を着る 4=冬服
	CALL	KISEKAE_KIRU			; 着替え・着る
	JMP	KISEKAE_MODE_NEXT		;
KISEKAE_MODE_NUGU:				;
	CALL	KISEKAE_NUGU			; 着替え・脱ぐ
	JMP	KISEKAE_MODE_NEXT		;
KISEKAE_MODE_MUSIC:				;
	CALL	TEST_MUSIC_M			; 音楽テスト（メニュー付き）
	CALL	MUSIC_KOSODATE			; 子育てのテーマ
	JMP	KISEKAE_MODE_NEXT		;

KISEKAE_MODE_NEXT:
	JMP	KISEKAE_MODE_LOOP		;

KISEKAE_MODE_OWARI:
	CMP	WIDCHAR_DRESS,0		; 自分の娘の着ている服 0=何も着ない
	JNE	KISEKAE_MODE_EXIT	;

	PR_TXT	"@「＊＊＊＊＊＊＊＊＊」"

	JMP	KISEKAE_MODE_LOOP

KISEKAE_MODE_EXIT:
	RET
KISEKAE_MODE	ENDP


; ****************************************************
;	着替え・脱ぐ
; ****************************************************

KISEKAE_NUGU	PROC	NEAR

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,49		; 49=服は何を着ているか
	CALL	R_KEISAN		; 各計算処理
	CMP	DX,0			; 自分の娘の着ている服
	JNE	KISEKAE_NUGU_4		;

	PR_TXT	"@もう、"		;
	CALL	R_SR_GIRL_FUKU		; キャラクタ服名
	CALL	R_SR_SR_DESU		; "です"
	JMP	KISEKAE_NUGU_EXIT	;

KISEKAE_NUGU_4:

	MOV	WIDCHAR_DRESS,0		; 自分の娘の着ている服 0=何も着ない

	MOV	DX,WIDCHAR_DRESS	; 自分の娘の着ている服
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,50		; 50=服の着替え
	CALL	R_KEISAN		; 各計算処理

	CALL	R_SCHO_KISEKAE		; 娘着せ替えの処理
KISEKAE_NUGU_EXIT:
	RET
KISEKAE_NUGU	ENDP


; ****************************************************
;	着替え・着る
;	-I- DX : 何を着る 0=何も着ない,1=春服,2=夏服,3=秋,4=冬
; ****************************************************

KISEKAE_KIRU	PROC	NEAR
	MOV	NUM,DX			; 番号

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,49		; 49=服は何を着ているか
	CALL	R_KEISAN		; 各計算処理
	CMP	DX,NUM			; 自分の娘の着ている服
	JNE	KISEKAE_KIRU_4		;

	PR_TXT	"@もう、"		;
	CALL	R_SR_GIRL_FUKU		; キャラクタ服名
	CALL	R_SR_SR_DESU		; "です"
	JMP	KISEKAE_KIRU_EXIT	;

KISEKAE_KIRU_4:

	PR_TXT	"@着替え中"

	MOVX	WIDCHAR_DRESS,NUM		; 自分の娘の着ている服

	MOV	DX,WIDCHAR_DRESS		; 自分の娘の着ている服
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	S_FUNC,50			; 50=服の着替え
	CALL	R_KEISAN			; 各計算処理

	CALL	R_SCHO_KISEKAE			; 娘着せ替えの処理

	PR_TXT	"@着替えました。"

KISEKAE_KIRU_EXIT:
	RET
KISEKAE_KIRU	ENDP


; ****************************************************
;	武器
; ****************************************************

SHOW_BUKI	PROC	NEAR
	PR_TXT	"@武器"
	MOV	ITEM_ATTR,0		; アイテム種別 0=武器
	CALL	SOUBI_SET		; 装備セット
	RET
SHOW_BUKI	ENDP


; ****************************************************
;	防具・兜
; ****************************************************

SHOW_BOUGU_KABUTO	PROC	NEAR
	PR_TXT	"@兜"
	MOV	ITEM_ATTR,1		; アイテム種別 1=防具・兜
	CALL	SOUBI_SET		; 装備セット
	RET
SHOW_BOUGU_KABUTO	ENDP


; ****************************************************
;	防具・鎧
; ****************************************************

SHOW_BOUGU_YOROI	PROC	NEAR
	PR_TXT	"@鎧"
	MOV	ITEM_ATTR,2		; アイテム種別 2=防具・鎧
	CALL	SOUBI_SET		; 装備セット
	RET
SHOW_BOUGU_YOROI	ENDP



; ****************************************************
;	装備セット
;	-I- ITEM_ATTR : アイテム種別 0=武器,1=防具・兜,2=防具・鎧
;	                             3=防具・盾, 4=道具
; ****************************************************

SOUBI_SET	PROC	NEAR

	CALL	SHOW_MOCHIMONO		; 持物は？

	CMP	K_TBL_MAX,0		; 検索レコード数
	JMPEQ	SOUBI_SET_NONE		;

	PR_TXT	"@どれを、装備しますか？"

	CALL	R_ITM_OFFSET		; 持物アイテムのアイテムオフセット計算

	MOV	BX,0			; 何ワード目か
	CALL	R_GET_SELECT		; ｱｲﾃﾑレコード内から選択単語を取り出す

	WD_ADRS	ID_86,DX		; "何も装備しない"
	CALL	R_ADD_SELECT		; 選択単語へ追加
	MOV	AX,ATMMAX		; ユーザ選択番号
	DEC	AX			;
	MOV	NONE_NUM,AX		; 指定＝何も装備しない

	CALL	WIDSLC			; WINDOWS/セレクト・ウインドウ

	CALL	WIDDSP_LOAD		; WINDOWS/画面復元

	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JMPEQ	SOUBI_SET_EXIT		;

	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	MOV	WDGNO,0			; 0. 体力
	CALL	WIDHBRS			; WINDOWS/横グラフ再表示

	JMP	SOUBI_SET_INTER		;

SOUBI_SET_LOOP:
	CALL	WIDBAR_SOUBI		; WINDOWS/バー・装備ＰＵＴ
	CALL	WIDSLC			; WINDOWS/セレクト・ウインドウ

SOUBI_SET_INTER:

	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JMPEQ	SOUBI_SET_EXIT		;


;*;	PR_TXT	"@装備・はずす"

	MOV	BX,ITEM_ATTR			; アイテム種別
	MOV	CX,WIDOFS_ITEM			; アイテムテーブル
	MOV	SI,WIDOFS_GRP			; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL			; 内容表示テーブルオフセット

	CMPX	WIDSNM,NONE_NUM			; 指定＝何も装備しない
	JNE	SOUBI_SET_55			;

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	DX,0				; 表示停止スイッチ0=OFF 1=ON
	MOV	S_FUNC,16			; 16=装備・はずす
	CALL	R_KEISAN			; 各計算処理
	JMP	SOUBI_SET_NEXT			;

SOUBI_SET_55:					;
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	DX,1				; 表示停止スイッチ0=OFF 1=ON
	MOV	S_FUNC,16			; 16=装備・はずす
	CALL	R_KEISAN			; 各計算処理
	;	-O- AX : 0=正常,1=装備していない


;*;	PR_TXT	"@装備・つける"

	MOV	SI,WIDSNM			; ユーザ選択番号
	SHL	SI,1				;
	MOV	DX,DS:K_TBL_OFSET[SI]		; アイテムアドレス
	MOV	CX,DS:K_TBL_REC[SI]		; アイテムレコードＮＯ
	MOV	BX,DS:K_TBL_ATR[SI]		; アイテム種別
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス

	MOV	SI,WIDOFS_GRP			; グラフテーブルオフセット
	MOV	DI,WIDOFS_VAL			; 内容表示テーブルオフセット

	MOV	S_FUNC,15			; 15=装備・つける
	CALL	R_KEISAN			; 各計算処理
	;	-O- AX : 0=正常,1=装備を外せ

SOUBI_SET_NEXT:					;
	JMP	SOUBI_SET_LOOP			;


SOUBI_SET_EXIT:					;
	CALL	WIDDSP_LOAD			; WINDOWS/画面復元
	RET
SOUBI_SET_NONE:
	SELECT	"「＊＊＊＊＊＊＊＊＊」"
	RET
SOUBI_SET	ENDP



; ****************************************************
;	持物は？
;	-I- ITEM_ATTR : アイテム種別 0=武器,1=防具・兜,2=防具・鎧
;	                             3=防具・盾, 4=道具
;	-O- K_TBL_ATR[]   : 検索レコード種別テーブル
;	    K_TBL_REC[]   : 検索レコードテーブル
;	    K_TBL_MOCHI[] : 検索レコード持物テーブル
;	    K_TBL_MAX     : 検索レコード数
; ****************************************************

SHOW_MOCHIMONO	PROC	NEAR
	PR_TXT	"は、"

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,ITEM_ATTR		; 検索するアイテム属性
	CALL	R_ITM_SYUBETU		; 持物アイテム種別検索
	CALL	R_DISP_ITEM_M		; 持物アイテム表示

	RET
SHOW_MOCHIMONO	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	R_SR_CHR_ADRS:WORD	; 台詞・キャラクタアドレス
EXTRN	R_SR_ITM_ADRS:WORD	; 台詞・アイテムアドレス

EXTRN	R_LOAD_FUNC:WORD	; ロードセーブ機能

EXTRN	S_FUNC:WORD		; 計算ファンクション

EXTRN	K_TBL_REC:WORD		; 検索レコードテーブル
EXTRN	K_TBL_OFSET:WORD	; 検索レコードｵﾌｾｯﾄテーブル
EXTRN	K_TBL_MOCHI:WORD	; 検索レコード持物テーブル
EXTRN	K_TBL_ATR:WORD		; 検索レコード種別テーブル
EXTRN	K_TBL_MAX:WORD		; 検索レコード数
EXTRN	K_TBL_DIM:WORD		; 検索レコードテーブルサイズ

EXTRN	W_STAT_HEAD_NO:NEAR	; ヘッダー番号(WIDSTAT.ASM)

EXTRN	ATMSEG:WORD		; WINDOWS/テキストバッファセグメント
EXTRN	ATMTBL:WORD		; WINDOWS/表示単語アドレス
EXTRN	ATMMAX:WORD		; WINDOWS/表示単語の数
EXTRN	ATMDIM:WORD	 	; WINDOWS/表示単語のテーブルサイズ

ITEM_ATTR	DW	0	; アイテム種別 0=武器,1=防具・兜,2=防具・鎧
				;              3=防具・盾, 4=道具

REC_NO		DW	0	; レコード番号

NONE_NUM	DW	0	; 指定＝何も装備しない

NUM		DW	0	; 番号

DATA	ENDS

	END
;
;	end of "R_SOUBI.ASM"
;
