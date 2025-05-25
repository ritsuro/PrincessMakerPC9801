; "KOSODATE.ASM" PC-9801UV11 make by R.H 1990/10/13
;
;
;	「子育て」
;
;	テストメイン	その１
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	KOSO.INC
INCLUDE	KOSO2.INC
INCLUDE	WINDOW.INC
INCLUDE	..\KOSO6\KYOKU.INC

WD_OPEN_TYPE		EQU	2;3	; オープンタイプ

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	KOSODATE		; 「子育て」

PUBLIC	MAIN_WINDOW_RE_WRITE	; メインウインドウ・再表示

PUBLIC	DBG_INTER		; デバックメニュー

PUBLIC	AUTO_DEMO_START		; オート実行
PUBLIC	AUTO_DEMO_STOP		; オート実行ストップ

PUBLIC	TEST_MUSIC_M		; 音楽テスト（メニュー付き）

EXTRN	KOSOMAIN:NEAR		; ゲームの大まかな流れ

EXTRN	WIDBORTH_SYSOPEN:NEAR	; WINDOWS/誕生日システムウインドウ

EXTRN	TBLSEGRET:NEAR		; 各セグメント指定を初期状態にする

EXTRN	OPENING:NEAR		; オープニング

EXTRN	R_LOADIN:NEAR		; スタート時ロード

;voidvoidvoid

EXTRN	R_SR_YOIDESUKA:NEAR	; よいですか

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

EXTRN	WIDALLOC:NEAR		; WINDOWS/データ結合
EXTRN	R_SOUBI:NEAR		; 装備
EXTRN	R_KAIMON:NEAR		; 買物
EXTRN	R_SCHED:NEAR		; スケジュール
EXTRN	R_PROG:NEAR		; スケジュール実行

EXTRN	R_SENTOU_BU_LOAD:NEAR	; 武闘会戦闘・先行ロード
EXTRN	R_SENTOU_BU_OPEN:NEAR	; 武闘会戦闘・ＯＰＥＮ
EXTRN	R_SENTOU_BU:NEAR	; 武闘会戦闘！
EXTRN	R_SENTOU_BU_CLOSE:NEAR	; 武闘会戦闘・ＣＬＯＳＥ

EXTRN	R_SCHO_MONTH:NEAR	; 成長の月次処理
EXTRN	R_SCHO_DAYS:NEAR	; 成長の日次処理

EXTRN	RANDAM:NEAR		; 乱数

EXTRN	WIDCCT_INIT:NEAR	; WINDOWS/キャラクタ初期処理
EXTRN	WIDCCT_OPEN:NEAR	; WINDOWS/キャラクタオープン
EXTRN	WIDCCT_CLOSE:NEAR	; WINDOWS/キャラクタクローズ
EXTRN	WIDCCT_CHANGE:NEAR	; WINDOWS/キャラクタチェンジ

EXTRN	WIDHED_INIT:NEAR	; WINDOWS/ヘッダー初期処理
EXTRN	WIDHED:NEAR		; WINDOWS/ヘッダー表示
EXTRN	WIDHED_RELOC:NEAR	; WINDOWS/ヘッダー位置変更
EXTRN	WIDHED_CAL:NEAR		; WINDOWS/ヘッダー位置変更・計算のみ

EXTRN	WIDHBR_INIT:NEAR	; WINDOWS/横グラフ初期処理
EXTRN	WIDHBR:NEAR		; WINDOWS/横グラフ
EXTRN	WIDHBR_RELOC:NEAR	; WINDOWS/横グラフ位置変更

EXTRN	WIDVAL_INIT:NEAR	; WINDOWS/内容表示初期処理
EXTRN	WIDVAL:NEAR		; WINDOWS/内容表示
EXTRN	WIDVAL_RELOC:NEAR	; WINDOWS/内容表示位置変更

EXTRN	WIDITEM_INIT:NEAR	; WINDOWS/アイテム管理初期処理
EXTRN	WIDITEM_CLEAR:NEAR	; WINDOWS/アイテム表示設定クリア
EXTRN	WIDITEM_OPEN:NEAR	; WINDOWS/アイテムオープン
EXTRN	WIDITEM_CLOSE:NEAR	; WINDOWS/アイテムクローズ

EXTRN	WIDWAZA_OPEN:NEAR	; WINDOWS/技（わざ）オープン
EXTRN	WIDWAZA_CLOSE:NEAR	; WINDOWS/技（わざ）クローズ

EXTRN	WIDWORKS_OPEN:NEAR	; WINDOWS/行い（おこない）オープン
EXTRN	WIDWORKS_CLOSE:NEAR	; WINDOWS/行い（おこない）クローズ

EXTRN	WIDTXT_INIT:NEAR	; WINDOWS/テキストウインドウ初期処理
EXTRN	WIDTXT:NEAR		; WINDOWS/テキストウインドウ
EXTRN	WIDTXT_OPEN:NEAR	; WINDOWS/テキストウインドウＯＰＥＮ
EXTRN	WIDTXT_CLOSE:NEAR	; WINDOWS/テキストウインドウＣＬＯＳＥ
EXTRN	WIDTXT_RELOC:NEAR	; WINDOWS/テキストウインドウ位置変更
EXTRN	WIDTXT_MODE:NEAR	; WINDOWS/テキストウインドウモード設定

EXTRN	WIDKAZ_INIT:NEAR	; WINDOWS/ウインドウ飾り初期処理

EXTRN	WIDSLC_INIT:NEAR	; WINDOWS/セレクト・ウインドウ初期処理
EXTRN	WIDSLC:NEAR		; WINDOWS/セレクト・ウインドウ

EXTRN	WIDITM_INIT:NEAR	; WINDOWS/アイテム系初期処理
EXTRN	WIDITM:NEAR		; WINDOWS/アイテム系表示
EXTRN	WIDITM_OPEN:NEAR	; WINDOWS/アイテム系オープン

EXTRN	WIDBTN_INIT:NEAR	; WINDOWS/ボタン初期処理
;EXTRN	WIDBTN_OPEN:NEAR	; WINDOWS/ボタンオープン
;EXTRN	WIDBTN_CLOSE:NEAR	; WINDOWS/ボタンクローズ
;EXTRN	WIDBTN_TOUCH:NEAR	; WINDOWS/ボタンタッチチェック

EXTRN	WIDBAR_INIT:NEAR	; WINDOWS/バー・初期処理
;EXTRN	WIDBAR_TITLE:NEAR	; WINDOWS/バー・タイトル

EXTRN	WIDCLEN_INIT:NEAR	; WINDOWS/カレンダー・初期処理
EXTRN	WIDCLEN_SET:NEAR	; WINDOWS/カレンダー・時間設定
EXTRN	WIDCLEN_SHOW:NEAR	; WINDOWS/カレンダー・再表示
EXTRN	WIDCLEN_UDATE:NEAR	; WINDOWS/カレンダー・更新処理
EXTRN	WIDCLEN_GET:NEAR	; WINDOWS/カレンダー・読み取り処理

EXTRN	WID_GIRL_INIT:NEAR	; WINDOWS/ＧＩＲＬウインドウ初期処理
EXTRN	WID_GIRL:NEAR		; WINDOWS/ＧＩＲＬウインドウ

EXTRN	WID_BG_INIT:NEAR	; WINDOWS/ＢＧウインドウ初期処理
EXTRN	WID_MBG_DISP:NEAR	; WINDOWS/メインＢＧウインドウ表示

EXTRN	WIDSTAT_INIT:NEAR	; WIDNOWS/ステータスウインドウ初期処理
EXTRN	WIDSTAT:NEAR		; WINDOWS/ステータス

EXTRN	WIDALLOC_MY_GIRL:NEAR	; WINDOWS/私の娘・データ結合

EXTRN	WIDDSP_SAVE:NEAR	; WINDOWS/画面退避
EXTRN	WIDDSP_LOAD:NEAR	; WINDOWS/画面復元

EXTRN	WIDDSP_SV_F:NEAR	; WINDOWS/画面フル退避
EXTRN	WIDDSP_LD_F:NEAR	; WINDOWS/画面フル復元

EXTRN	WIDFRM_MAIN_SRT:NEAR	; WINDOWS/フレーム・メインスタート時
EXTRN	WIDFRM_MAIN:NEAR	; WINDOWS/フレーム・メイン

EXTRN	WIDMTRX_INIT:NEAR	; WINDOWS/マトリックス初期処理
EXTRN	WIDMTRX_OPEN:NEAR	; WINDOWS/マトリックスＯＰＥＮ
EXTRN	WIDMTRX_SET:NEAR	; WINDOWS/マトリックスセット
EXTRN	WIDMTRX_CLOSE:NEAR	; WINDOWS/マトリックスＣＬＯＳＥ

EXTRN	WIDEVNT_INIT:NEAR	; WINDOWS/イベントウインドウ初期処理
EXTRN	WIDEVNT_OPEN:NEAR	; WINDOWS/イベントウインドウＯＰＥＮ
EXTRN	WIDEVNT_CLOSE:NEAR	; WINDOWS/イベントウインドウＣＬＯＳＥ

EXTRN	WIDFACE_INIT:NEAR	; WINDOWS/フェイスウインドウ初期処理
EXTRN	WIDFACE_OPEN:NEAR	; WINDOWS/フェイスウインドウＯＰＥＮ
EXTRN	WIDFACE_CLOSE:NEAR	; WINDOWS/フェイスウインドウＣＬＯＳＥ

EXTRN	WIDFUKI_INIT:NEAR	; WINDOWS/ふきだしウインドウ初期処理
EXTRN	WIDFUKI:NEAR		; WINDOWS/ふきだしウインドウ
EXTRN	WIDFUKI_OPEN:NEAR	; WINDOWS/ふきだしウインドウＯＰＥＮ
EXTRN	WIDFUKI_CLOSE:NEAR	; WINDOWS/ふきだしウインドウＣＬＯＳＥ

EXTRN	WIDPROP_INIT:NEAR	; WINDOWS/プロポ・ウインドウ初期処理
EXTRN	WIDPROP_ALL:NEAR	; WINDOWS/プロポ・ウインドウ全表示
EXTRN	WIDPROP_OPEN:NEAR	; WINDOWS/プロポ・ウインドウＯＰＥＮ
EXTRN	WIDPROP_CLOSE:NEAR	; WINDOWS/プロポ・ウインドウＣＬＯＳＥ

EXTRN	WID_GIRL_BORTH:NEAR	; WINDOWS/ＧＩＲＬウインドウ成長
EXTRN	WID_GIRL_FACE:NEAR	; WINDOWS/ＧＩＲＬウインドウ顔

EXTRN	WIDDSP_ALG:NEAR		; WINDOWS/季節アナログ設定
EXTRN	WIDDSP_ALG_PLT:NEAR	; WINDOWS/季節アナログパレットセット

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	KEYTEN:NEAR		; キーボード・読み込み

EXTRN	PT_BANK29_LOAD:NEAR	; バンク＃２から＃９までロード

EXTRN	PT_PALET_LD:NEAR	; パレットのロード
EXTRN	PT_PALET_ST:NEAR	; パレットのセット
EXTRN	PT_PALET_PLD:NEAR	; パレットのテーブルのみセット
EXTRN	PT_PALET_PLDP:NEAR	; パレットのテーブルのみセット（テーブル指定）
EXTRN	PT_PALET_S_GM:NEAR	; パレットのセット・ゲーム面

;*NON*;EXTRN PT_CHR_FACE:NEAR	; 顔変化
EXTRN	PT_CHR_DRESS:NEAR	; 服変化（４シーズン）
EXTRN	PT_CHR_BASE:NEAR	; キャラクタ・ベース

EXTRN	PT_CHR_BG_MAIN:NEAR	; メインＢＧ－ＰＵＴ

EXTRN	MSCSRT:NEAR		; カーソルスタート
EXTRN	MSCMOV:NEAR		; カーソル移動
EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR		; カーソルストップ
EXTRN	MSCSTS:NEAR		; マウスカーソルステータス

EXTRN	MSWWAT:NEAR		; カーソルボタン待ち

EXTRN	MUSINI:NEAR		; マウスの初期化
EXTRN	MUSSTP:NEAR		; マウスの終了

EXTRN	KYBSRT:NEAR		; keybord start.
EXTRN	KYBEND:NEAR		; keybord end.

EXTRN	US_WAIT:NEAR		; ユーザ待ち

EXTRN	WIDDSP_LD_F:NEAR	; WINDOWS/画面フル復元
EXTRN	WIDDSP_SV_F:NEAR	; WINDOWS/画面フル退避

EXTRN	PT_MISSCON:NEAR		; ミスコンＰＵＴ
EXTRN	PT_MNSTER:NEAR		; モンスターＰＵＴ
EXTRN	PT_TOHSHI:NEAR		; 闘士ＰＵＴ

EXTRN	PT_CHR_BASE:NEAR	; キャラクタ・ベース
EXTRN	PT_CHR_DRESS:NEAR	; 服変化（４シーズン）
EXTRN	PT_CHR_BG_BATLE:NEAR	; バトルＢＧ－ＰＵＴ

EXTRN	M_INIT:NEAR		; 音楽システム初期処理
EXTRN	M_EXIT:NEAR		; 音楽システム終了処理
EXTRN	M_PLAY:NEAR		; 音楽演奏
EXTRN	M_STOP:NEAR		; 音楽停止
EXTRN	M_FDOT:NEAR		; 音楽フェードアウト
EXTRN	M_SHOU:NEAR		; 音楽小節ウエイト

EXTRN	PT_BACA_LD:NEAR		; バカンスの絵ロード
EXTRN	PT_BACA_PUT:NEAR	; バカンスの絵ＰＵＴ

EXTRN	RANDAM_STR:NEAR		; 乱数スタート


BUFF_LEN	EQU	20	; バッファ長さ



; ****************************************************
;	「子育て」
; ****************************************************

KOSODATE	PROC	NEAR
	CALL	RANDAM_STR		; 乱数スタート

	CALL	AUTO_DEMO_STOP		; オート実行ストップ
	MOV	DEMO_MODE_SYU,0		; デモモード収穫祭 0=通常,66=収穫祭ﾙｰﾌﾟ

	CALL	WIDALLOC		; WINDOWS/データ結合

	CALL	WIDCCT_INIT		; WINDOWS/キャラクタ初期処理
	CALL	WIDTXT_INIT		; WINDOWS/テキストウインドウ初期処理
	CALL	WIDSLC_INIT		; WINDOWS/セレクト・ウインドウ初期処理
	CALL	WIDVAL_INIT		; WINDOWS/内容表示初期処理
	CALL	WIDKAZ_INIT		; WINDOWS/ウインドウ飾り初期処理
	CALL	WIDITEM_INIT		; WINDOWS/アイテム管理初期処理
	CALL	WIDITM_INIT		; WINDOWS/アイテム系初期処理
	CALL	WIDBTN_INIT		; WINDOWS/ボタン初期処理
	CALL	WIDHED_INIT		; WINDOWS/ヘッダー初期処理
	CALL	WIDHBR_INIT		; WINDOWS/横グラフ初期処理
	CALL	WIDBAR_INIT		; WINDOWS/バー・初期処理
	CALL	WIDCLEN_INIT		; WINDOWS/カレンダー・初期処理
	CALL	WID_GIRL_INIT		; WINDOWS/ＧＩＲＬウインドウ初期処理
	CALL	WID_BG_INIT		; WINDOWS/ＢＧウインドウ初期処理
	CALL	WIDSTAT_INIT		; WIDNOWS/ステータスウインドウ初期処理
	CALL	WIDMTRX_INIT		; WINDOWS/マトリックス初期処理
	CALL	WIDEVNT_INIT		; WINDOWS/イベントウインドウ初期処理
	CALL	WIDFACE_INIT		; WINDOWS/フェイスウインドウ初期処理
	CALL	WIDFUKI_INIT		; WINDOWS/ふきだしウインドウ初期処理
	CALL	WIDPROP_INIT		; WINDOWS/プロポ・ウインドウ初期処理

	CALL	PT_BANK29_LOAD		; バンク＃２から＃９までロード
	CALL	PT_PALET_S_GM		; パレットのセット・ゲーム面

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;*;	RET				;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	MOV	AX,0			; wait timer count.
	CALL	TMVST2			; V-SYNC timer2 set.

	CALL	KEYTEN			; キーボード・読み込み
	CMP	BX,3			; 3=PLUS,4=ESC (-1:押していない)
	JE	KOSODATE_SKIP		;

	CALL	VRMCLR			; ＶＲＡＭクリア

;*;	JMP	KOSODATE_SKIP;;;;;;;;;;;;;;
;*;
;voidvoidvoid
;voidvoidvoid
;*;	RET;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	CALL	WIDBORTH_SYSOPEN	; WINDOWS/誕生日システムウインドウ
	CMP	AX,1			; 0=通常,1=データロード
	JE	KOSODATE_SKIP		;

;*;	CALL	MENU_SETUP		; セットアップメニュー
;*;	CALL	VRMCLR			; ＶＲＡＭクリア
;*;	MOV	AX,0			; wait timer count.
;*;	CALL	TMVST2			; V-SYNC timer2 set.
;*;	CALL	MENU_LOAD		; ロードメニュー
;*;	CMP	AX,1			; 0=通常,1=データロード
;*;	JE	KOSODATE_SKIP		;
;*;	CALL	VRMCLR			; ＶＲＡＭクリア

KOSODATE_OPEN:				;
	CALL	OPENING			; オープニング

KOSODATE_SKIP:				;
	CALL	TBLSEGRET		; 各セグメント指定を初期状態にする

	CALL	WIDFRM_MAIN_SRT		; WINDOWS/フレーム・メインスタート時

;;	CALL	CLS			;＊＊＊＊＊＊＊＊＊＊＊＊＊

	JMP	KOSODATE_MAIN		; ＩＮＴＥＲ

KOSODATE_LOOP:				;

SELECT	"ノーマル実行,ランダム実行,デバック,モンスターデータ,crt:アナログ,crt:白黒,crt:PC-386LSX-H40 ｶﾗｰ15,歳,顔,服,音楽,DOS EXIT"

	CMP	WIDSNM,0		; ノーマル実行
	JMPEQ	KOSODATE_MAIN		;
	CMP	WIDSNM,1		; ランダム実行
	JE	KOSODATE_AUTO		;
	CMP	WIDSNM,2		; デバック
	JE	KOSODATE_DEBUG		;
	CMP	WIDSNM,3		; モンスターデータ
	JE	KOSODATE_MONSTER	;

	CMP	WIDSNM,4		; アナログ
	JE	KOSODATE_COLOR_AN	;
	CMP	WIDSNM,5		; 白黒
	JMPEQ	KOSODATE_COLOR_BW	;
	CMP	WIDSNM,6		; PC-386LSX-H40 ｶﾗｰ15
	JMPEQ	KOSODATE_COLOR_LSX	;

	CMP	WIDSNM,7		; 歳
	JMPEQ	KOSODATE_AGE		;
	CMP	WIDSNM,8		; 顔
	JMPEQ	KOSODATE_FACE		;
	CMP	WIDSNM,9		; 服
	JMPEQ	KOSODATE_DRESS		;
	CMP	WIDSNM,10		; 音楽
	JMPEQ	KOSODATE_MUSIC		;
	CMP	WIDSNM,11		; DOS EXIT
	JMPEQ	KOSODATE_EXIT		;

	JMP	KOSODATE_MAIN		;

KOSODATE_AUTO:				;
	CALL	AUTO_DEMO_START		; オート実行
	SELECT	"スタート"
	CALL	KOSOMAIN		; ゲームの大まかな流れ
	JMP	KOSODATE_LOOP		;

KOSODATE_DEBUG:				;
	CALL	DBG_INTER		; デバックメニュー
	JMP	KOSODATE_LOOP		;

KOSODATE_MAIN:				;
	CALL	KOSOMAIN		; ゲームの大まかな流れ
	JMP	KOSODATE_LOOP		;

KOSODATE_MONSTER:			;
	CALL	MONSTER_DATA		; モンスターデータ
	JMP	KOSODATE_LOOP		;

KOSODATE_COLOR_AN:			;
	MOV	SW_ANALOG,0		; 0=normal analog
	CALL	BRIIN		; 明度５０％からノーマルへ
	JMP	KOSODATE_LOOP		;

KOSODATE_COLOR_LSX:			;
	MOV	SW_ANALOG,1		; 1=386LSX(15color)
	CALL	BRIIN		; 明度５０％からノーマルへ
	JMP	KOSODATE_LOOP		;

KOSODATE_COLOR_DIG:			;
	MOV	SW_ANALOG,2		; 2=full DIGITAL
	CALL	BRIIN		; 明度５０％からノーマルへ
	JMP	KOSODATE_LOOP		;

KOSODATE_COLOR_BW:			;
	MOV	SW_ANALOG,3		; 3=B/W
	CALL	BRIIN		; 明度５０％からノーマルへ
	JMP	KOSODATE_LOOP		;

KOSODATE_AGE:				;
	SELECT	"10,11,12,13,14,15,16,17,end"
	CMP	WIDSNM,OFFF		; ノーマル実行
	JMPEQ	KOSODATE_LOOP		;
	CMP	WIDSNM,8		; ノーマル実行
	JMPEQ	KOSODATE_LOOP		;

	MOV	AX,WIDSNM		; ノーマル実行
	INC	AX			;
	MOV	NUM,AX			;
	MOV	AX,WIDSNM		; ノーマル実行
	ADD	AX,10			; 年齢
KOSODATE_AGE_SET:			;
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	ES:[BX][VTB_NENREI][VAL_VALUE],AX	; 4. 年齢

	CMPX	W_GIRL_GROW,NUM		; 少女（成長１,成長２・・・）
	JE	KOSODATE_NEXT		;

	MOVX	W_GIRL_GROW,NUM		; 少女（成長１,成長２・・・）
	MOVX	W_GIRL_SEASON,WIDCHAR_DRESS	; 自分の娘の着ている服
	CALL	WID_GIRL_BORTH		; WINDOWS/ＧＩＲＬウインドウ成長
KOSODATE_NEXT:				;
	JMP	KOSODATE_AGE		;

KOSODATE_FACE:				;
	SELECT	"普,病,非,end"		;
	CMP	WIDSNM,OFFF		; ノーマル実行
	JMPEQ	KOSODATE_LOOP		;
	CMP	WIDSNM,3		; ノーマル実行
	JMPEQ	KOSODATE_LOOP		;

	MOV	AX,WIDSNM		; ノーマル実行
	INC	AX			;
	CMP	W_GIRL_FACE,AX		; 顔（１－３）
	JE	KOSODATE_FNEXT		;

	MOV	W_GIRL_FACE,AX		; 顔（１－３）
	CALL	WID_GIRL_FACE		; WINDOWS/ＧＩＲＬウインドウ顔
KOSODATE_FNEXT:				;
	JMP	KOSODATE_FACE		;

KOSODATE_DRESS:				;
	SELECT	"春,夏,秋,冬,end"	;
	CMP	WIDSNM,OFFF		; ノーマル実行
	JMPEQ	KOSODATE_LOOP		;
	CMP	WIDSNM,4		; ノーマル実行
	JMPEQ	KOSODATE_LOOP		;

	MOV	AX,WIDSNM		; ノーマル実行
	INC	AX			;
	CMP	W_GIRL_SEASON,AX	; 季節（1:春，2:夏，3:秋，4:冬）
	JE	KOSODATE_DNEXT		;

	MOV	W_GIRL_SEASON,AX	; 季節（1:春，2:夏，3:秋，4:冬）
	CALL	WID_GIRL_BORTH		; WINDOWS/ＧＩＲＬウインドウ成長
KOSODATE_DNEXT:				;
	JMP	KOSODATE_DRESS		;

KOSODATE_MUSIC:				;
	CALL	TEST_MUSIC_M		; 音楽テスト（メニュー付き）
	JMP	KOSODATE_LOOP		;

KOSODATE_EXIT:				;
	RET
KOSODATE	ENDP


; ****************************************************
;	モンスターデータ
; ****************************************************

MONSTER_DATA	PROC	NEAR

	MOV	MSTR_MENU_PNT,0	; モンスターメニューポインタ


MONSTER_DATA_LOOP:
	CMPX	MSTR_MENU_PNT,MSTR_MENU_MAX	; モンスターメニュー数
	JL	MONSTER_DATA_3			;

	MOV	MSTR_MENU_PNT,0			; モンスターメニューポインタ
MONSTER_DATA_3:
	MOVX	ES,DS				; テキストバッファセグメント
	MOV	SI,MSTR_MENU_PNT		;
	SHL	SI,1				; word pointer.
	MOV	BX,DS:MSTR_MENU_TABLE[SI]	; モンスターメニューテーブル
	CALL	WIDSLC2				; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡）
	CMP	WIDSNM,OFFF			; offf=無指定
	JE	MONSTER_DATA_LOOP_E		;
	CMP	WIDSNM,0			; 0=終
	JE	MONSTER_DATA_LOOP_E		;
	CMP	WIDSNM,1			; 1=次
	JE	MONSTER_DATA_NEXT		;

	SUB	WIDSNM,2			; これを１の位にする
	MOV	AX,MSTR_MENU_PNT		; モンスターメニューポインタ
	MOV	BX,10				;
	MUL	BX				; １０倍、つまり十の位にする
	ADD	AX,WIDSNM			;

	MOV	MONSTER_NUMBER,AX		; モンスター番号
	CALL	MONSTER_DISPLY			; モンスター表示

	JMP	MONSTER_DATA_LOOP

MONSTER_DATA_NEXT:
	INC	MSTR_MENU_PNT			; モンスターメニューポインタ
	JMP	MONSTER_DATA_LOOP

MONSTER_DATA_LOOP_E:

	RET
MONSTER_DATA	ENDP


; ****************************************************
;	モンスター表示
;	-I- MONSTER_NUMBER : モンスター番号
; ****************************************************

MONSTER_DISPLY	PROC	NEAR

	MOV	DX,16			; パレットのパターン番号
	MOV	AX,1			; パレットテーブル番号
	CALL	PT_PALET_PLDP		; パレットのテーブルのみセット

	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避

	CALL	VRMCLR			; ＶＲＡＭクリア

	MOV	BX,1			; パレットテーブル番号
	CALL	PLSET			; パレットセット

	MOV	AX,12			; Ｘオフセット
	MOV	BX,0			; Ｙオフセット
	MOV	DX,2			; 寺院の丘（武闘会）
	CALL	PT_CHR_BG_BATLE		; バトルＢＧ－ＰＵＴ

	CMP	MONSTER_NUMBER,0	; 0=ヒロイン
	JE	MONSTER_DISPLY_HEROIN	;
	CMP	MONSTER_NUMBER,23	; 1-23まで=闘士
	JBE	MONSTER_DISPLY_TOHSHI	;
	CMP	MONSTER_NUMBER,33	; 24-33まで=モンスター
	JBE	MONSTER_DISPLY_MONSTER	;
	CMP	MONSTER_NUMBER,50	; 34-50まで=ミスコン
	JBE	MONSTER_DISPLY_MISSCON	;

MONSTER_DISPLY_HEROIN:
	MOV	DX,1			; 少女（成長１,成長２,成長３,成長４）
	MOV	AX,0			; Ｘオフセット
	MOV	BX,0			; Ｙオフセット
	CALL	PT_CHR_BASE		; キャラクタ・ベース
	MOV	DX,1			; 少女（成長１,成長２,成長３,成長４）
	MOV	CX,WIDCHAR_DRESS	; 自分の娘の着ている服
	MOV	AX,0			; Ｘオフセット
	MOV	BX,0			; Ｙオフセット
	CALL	PT_CHR_DRESS		; 服変化（４シーズン）
	JMP	MONSTER_DISPLY_STAT

MONSTER_DISPLY_TOHSHI:			;
	MOV	AX,12			; Ｘオフセット
	MOV	BX,0			; Ｙオフセット
	MOV	DX,MONSTER_NUMBER	; モンスター番号
	INC	DX			;
	CALL	PT_TOHSHI		; 闘士ＰＵＴ
	JMP	MONSTER_DISPLY_STAT

MONSTER_DISPLY_MONSTER:
	MOV	AX,12			; Ｘオフセット
	MOV	BX,0			; Ｙオフセット
	MOV	DX,MONSTER_NUMBER	; モンスター番号
	SUB	DX,23			;
	CALL	PT_MNSTER		; モンスターＰＵＴ
	JMP	MONSTER_DISPLY_STAT

MONSTER_DISPLY_MISSCON:
	MOV	AX,6+12+11		; Ｘオフセット
	MOV	BX,108			; Ｙオフセット
	MOV	DX,MONSTER_NUMBER	; モンスター番号
	SUB	DX,33			;
	INC	DX			; １は自分の娘なのでスキップ
	CALL	PT_MISSCON		; ミスコンＰＵＴ
	JMP	MONSTER_DISPLY_STAT

MONSTER_DISPLY_STAT:

	SELECT	"ステータス"

	MOV	AX,MONSTER_NUMBER	; ヘッダー番号＝モンスター番号
	MOV	DX,8			; タイプ８（デバッグ／ステータス）
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	SELECT	"よいですか"

MONSTER_DISPLY_EXIT:
	CALL	VRMCLR			; ＶＲＡＭクリア
	MOV	BX,0			; パレットテーブル番号
	CALL	PLSET			; パレットセット
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元
	RET
MONSTER_DISPLY	ENDP


; ****************************************************
;	メインウインドウ・再表示
; ****************************************************

MAIN_WINDOW_RE_WRITE	PROC	NEAR
	CALL	WIDFRM_MAIN		; WINDOWS/フレーム・メイン
	CALL	WIDCLEN_SHOW		; WINDOWS/カレンダー・再表示
	CALL	WIDDSP_ALG		; WINDOWS/季節アナログ設定
	CALL	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更
	RET
MAIN_WINDOW_RE_WRITE	ENDP


; ****************************************************
;	デバックメニュー
; ****************************************************

DBG_INTER	PROC	NEAR
	CMP	DEMO_MODE,22		; デモモード 0=通常,22=デモモード
	JNE	DBG_INTER_START		;
	RET
DBG_INTER_START:
	PUSH	IPLMSW		; パレットエフェクト単位時間(VSYNC)

	CALL	TMVSAV		; V-SYNC timer value save.

	MOV	IPLMSW,1	; パレットエフェクト単位時間(VSYNC)

	CALL	BRIOUT		; 明度５０％ダウン

	CALL	KYBEND		; keybord end.

	CALL	COMMANDS	; コマンド ＊＊＊

	CALL	KEYCLEAR	; キーテーブルクリア

	CALL	CLS		;text clear.

	CALL	KYBSRT		; keybord start.

	CALL	BRIIN		; 明度５０％からノーマルへ

	CALL	TMVLOD		; V-SYNC timer value load.

	POP	IPLMSW		; パレットエフェクト単位時間(VSYNC)

	CALL	CMD_PROC	; コマンド実行

	RET
DBG_INTER	ENDP



; ****************************************************
;	コマンド
;	-O- CMND_WORD : コマンドワード
;	    CMD_LINE  : コマンドライン
; ****************************************************

COMMANDS	PROC	NEAR
	MOV	CMND_WORD,0		; コマンドワード
	LC	0,23			;
	INP	"コマンド＝"		;
	CALL	CMD_SET			; コマンドラインセット
	LC	0,23			;
	PR	"                  "
	RET
COMMANDS	ENDP



CP_CALL	MACRO	WCMD,LBL
	LOCAL	L1
	XCHG	AH,AL
	CMP	AX,WCMD
	XCHG	AH,AL
	JNE	L1
	PUSH	AX
	CALL	LBL
	POP	AX
	RET
L1:
	ENDM

CP_FLAG	MACRO	WCMD,VVV
	LOCAL	L1
	XCHG	AH,AL
	CMP	AX,WCMD
	XCHG	AH,AL
	JNE	L1
	PUSH	AX
	NOT	VVV
	POP	AX
	RET
L1:
	ENDM



; ****************************************************
;	コマンド実行
;	-I- CMND_WORD : コマンドワード
;	    CMD_LINE  : コマンドライン
; ****************************************************

CMD_PROC	PROC	NEAR
	MOV	SI,OFFSET CMD_LINE	; コマンドライン
	CALL	STRDEC			;
	CMP	DX,0			;
	JE	CMD_PROC_001		;
	MOV	FLAG_SUPER,DX		; スーパー指定
CMD_PROC_001:

	MOV	AX,CMND_WORD		; コマンドワード
	CMP	AH,'a'
	JB	CMD_PROC_1
	SUB	AH,'a'-'A'
CMD_PROC_1:
	CMP	AL,'a'
	JB	CMD_PROC_11
	SUB	AL,'a'-'A'
CMD_PROC_11:

	CP_CALL	"QQ",CMD_PROC_BREAK	; 強制終了フラグセット

	CP_CALL	"TM",TEMP_DISP		; 内部データ表示
	CP_CALL	"AN",ANALOG_SET		; analog switch.

	CP_CALL	"SS",AUTO_DEMO_START	; オート実行

	CMP	FLAG_SUPER,5410		; スーパー指定
	JE	CMD_PROC_22		;
	RET
CMD_PROC_22:

	CP_CALL	"CV",EDIT_VALUE		; パラメータ操作（内容値）
	CP_CALL	"CC",EDIT_PARA		; パラメータ操作
;voidvoidvoid
	CP_CALL	"DT",CMD_UPDATE		; 日付更新


	CP_CALL	"HC",HEAD_CHANGE	; ヘッダーチェンジ
;*;	CP_CALL	"TT",TEXT_TEST		; テキストテスト
;*;	CP_CALL	"TB",BATL_TEST		; バトルテスト
	CP_CALL	"TX",BUTOH_TEST		; 武闘会テスト
	CP_CALL	"TS",TEST_MUSIC		; 音楽テスト

;*;	CP_CALL	"IB",DISP_ITEM_B	; アイテム表示・武器
;*;	CP_CALL	"IK",DISP_ITEM_K	; アイテム表示・兜
;*;	CP_CALL	"IY",DISP_ITEM_Y	; アイテム表示・鎧
;*;	CP_CALL	"IT",DISP_ITEM_T	; アイテム表示・盾
;*;	CP_CALL	"ID",DISP_ITEM_D	; アイテム表示・道具

;*;	CP_CALL	"WM",DISP_WAZA_T	; 技（わざ）表示・魔法
;*;	CP_CALL	"WT",DISP_WAZA_D	; 技（わざ）表示・力技
;*;	CP_CALL	"GW",DISP_GYOU_S	; 行い（おこない）表示・お仕事



	CP_CALL	"TH",TEST_HORIDAY	; テストバカンス

;*NON*;	CP_CALL	"PT",CMD_PUT_CHK	; ＰＵＴチェック
;*NON*;	CP_CALL	"SC",SCHEDULE		; スケジュール
	CP_CALL	"SK",AUTO_DEMO_SYU_START ; 収穫祭無限ループ

	CP_CALL	"MD",CMD_MODE		; モード

	CP_CALL	"XM",R_SCHO_MONTH	; 成長の月次処理
	CP_CALL	"XD",R_SCHO_DAYS	; 成長の日次処理

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

	; フラグ
	CP_FLAG	"FH",FLAG_GRAP		; 横グラフ表示フラグ
	; フラグ
	CP_FLAG	"MS",DEBUG_MONSTER_SKIP	; (R_MUSYA.ASM)モンスタースキップ

	RET
CMD_PROC	ENDP


; ****************************************************
;	モード
; ****************************************************

CMD_MODE	PROC	NEAR
	MOV	S_FUNC,32		; 32=マッハモード
	MOV	AX,1			;
	CALL	R_KEISAN		; 各計算処理
	RET
CMD_MODE	ENDP



; ****************************************************
;	強制終了フラグセット
; ****************************************************

CMD_PROC_BREAK	PROC	NEAR
	MOV	EXIT_FLAG,1		; １＝強制終了
	RET
CMD_PROC_BREAK	ENDP


; ****************************************************
;	ヘッダーチェンジ
;	-I- CMD_LINE  : コマンドライン
;	-O- MAN_NUM   : 娘番号
; ****************************************************

HEAD_CHANGE	PROC	NEAR
	MOV	SI,OFFSET CMD_LINE	; コマンドライン
	ADD	SI,2			; コマンドライン
	CALL	STRDEC			;
	MOV	MAN_NUM,DX		;

	MOV	DX,MAN_NUM		;
	CALL	WIDALLOC_MY_GIRL	; WINDOWS/私の娘・データ結合

	MOV	DX,MAN_NUM		;
	MOV	WIDCHAR_NUMBER_MUSUME,DX ; 自分の娘のキャラ番号（＝Ｎｏ．０）

	CALL	CMND_STATUS		; コマンド／ステータス
	RET
HEAD_CHANGE	ENDP


;*;; ****************************************************
;*;;	アイテム表示・武器
;*;;	-I- CMD_LINE  : コマンドライン
;*;; ****************************************************
;*;
;*;DISP_ITEM_B	PROC	NEAR
;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;	MOV	REC_NO,0
;*;DISP_ITEM_B_LOOP:
;*;	MOV	DX,0			; 種別
;*;	MOV	CX,REC_NO		; レコード番号
;*;	CALL	WIDITEM_OPEN		; WINDOWS/アイテムオープン
;*;	CMP	AX,0			; 0=正常
;*;	JNE	DISP_ITEM_B_LOOP_E	;
;*;
;*;	INC	REC_NO			; レコード番号
;*;	JMP	DISP_ITEM_B_LOOP
;*;DISP_ITEM_B_LOOP_E:
;*;	CALL	US_WAIT			; ユーザ待ち
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*;	RET
;*;DISP_ITEM_B	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	アイテム表示・兜
;*;;	-I- CMD_LINE  : コマンドライン
;*;; ****************************************************
;*;
;*;DISP_ITEM_K	PROC	NEAR
;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;	MOV	REC_NO,0
;*;DISP_ITEM_K_LOOP:
;*;	MOV	DX,1			; 種別
;*;	MOV	CX,REC_NO		; レコード番号
;*;	CALL	WIDITEM_OPEN		; WINDOWS/アイテムオープン
;*;	CMP	AX,0			; 0=正常
;*;	JNE	DISP_ITEM_K_LOOP_E	;
;*;
;*;	INC	REC_NO			; レコード番号
;*;	JMP	DISP_ITEM_K_LOOP
;*;DISP_ITEM_K_LOOP_E:
;*;	CALL	US_WAIT			; ユーザ待ち
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*;	RET
;*;DISP_ITEM_K	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	アイテム表示・鎧
;*;;	-I- CMD_LINE  : コマンドライン
;*;; ****************************************************
;*;
;*;DISP_ITEM_Y	PROC	NEAR
;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;	MOV	REC_NO,0
;*;DISP_ITEM_Y_LOOP:
;*;	MOV	DX,2			; 種別
;*;	MOV	CX,REC_NO		; レコード番号
;*;	CALL	WIDITEM_OPEN		; WINDOWS/アイテムオープン
;*;	CMP	AX,0			; 0=正常
;*;	JNE	DISP_ITEM_Y_LOOP_E	;
;*;
;*;	INC	REC_NO			; レコード番号
;*;	JMP	DISP_ITEM_Y_LOOP
;*;DISP_ITEM_Y_LOOP_E:
;*;	CALL	US_WAIT			; ユーザ待ち
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*;	RET
;*;DISP_ITEM_Y	ENDP
;*;
;*;
;*;
;*;; ****************************************************
;*;;	アイテム表示・盾
;*;;	-I- CMD_LINE  : コマンドライン
;*;; ****************************************************
;*;
;*;DISP_ITEM_T	PROC	NEAR
;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;	MOV	REC_NO,0
;*;DISP_ITEM_T_LOOP:
;*;	MOV	DX,3			; 種別
;*;	MOV	CX,REC_NO		; レコード番号
;*;	CALL	WIDITEM_OPEN		; WINDOWS/アイテムオープン
;*;	CMP	AX,0			; 0=正常
;*;	JNE	DISP_ITEM_T_LOOP_E	;
;*;
;*;	INC	REC_NO			; レコード番号
;*;	JMP	DISP_ITEM_T_LOOP
;*;DISP_ITEM_T_LOOP_E:
;*;	CALL	US_WAIT			; ユーザ待ち
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*;	RET
;*;DISP_ITEM_T	ENDP
;*;
;*;
;*;
;*;; ****************************************************
;*;;	アイテム表示・道具
;*;;	-I- CMD_LINE  : コマンドライン
;*;; ****************************************************
;*;
;*;DISP_ITEM_D	PROC	NEAR
;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;	MOV	REC_NO,0
;*;DISP_ITEM_D_LOOP:
;*;	MOV	DX,4			; 種別
;*;	MOV	CX,REC_NO		; レコード番号
;*;	CALL	WIDITEM_OPEN		; WINDOWS/アイテムオープン
;*;	CMP	AX,0			; 0=正常
;*;	JNE	DISP_ITEM_D_LOOP_E	;
;*;
;*;	INC	REC_NO			; レコード番号
;*;	JMP	DISP_ITEM_D_LOOP
;*;DISP_ITEM_D_LOOP_E:
;*;	CALL	US_WAIT			; ユーザ待ち
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*;	RET
;*;DISP_ITEM_D	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	技（わざ）表示・魔法
;*;;	-I- CMD_LINE  : コマンドライン
;*;; ****************************************************
;*;
;*;DISP_WAZA_T	PROC	NEAR
;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;	MOV	REC_NO,0
;*;DISP_WAZA_T_LOOP:
;*;	MOV	DX,0			; 種別
;*;	MOV	CX,REC_NO		; レコード番号
;*;	CALL	WIDWAZA_OPEN		; WINDOWS/技（わざ）オープン
;*;	CMP	AX,0			; 0=正常
;*;	JNE	DISP_WAZA_T_LOOP_E	;
;*;
;*;	INC	REC_NO			; レコード番号
;*;	JMP	DISP_WAZA_T_LOOP
;*;DISP_WAZA_T_LOOP_E:
;*;	CALL	US_WAIT			; ユーザ待ち
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*;	RET
;*;DISP_WAZA_T	ENDP



;*;; ****************************************************
;*;;	技（わざ）表示・力技
;*;;	-I- CMD_LINE  : コマンドライン
;*;; ****************************************************
;*;
;*;DISP_WAZA_D	PROC	NEAR
;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;	MOV	REC_NO,0
;*;DISP_WAZA_D_LOOP:
;*;	MOV	DX,1			; 種別
;*;	MOV	CX,REC_NO		; レコード番号
;*;	CALL	WIDWAZA_OPEN		; WINDOWS/技（わざ）オープン
;*;	CMP	AX,0			; 0=正常
;*;	JNE	DISP_WAZA_D_LOOP_E	;
;*;
;*;	INC	REC_NO			; レコード番号
;*;	JMP	DISP_WAZA_D_LOOP
;*;DISP_WAZA_D_LOOP_E:
;*;	CALL	US_WAIT			; ユーザ待ち
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*;	RET
;*;DISP_WAZA_D	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	行い（おこない）表示・お仕事
;*;;	-I- CMD_LINE  : コマンドライン
;*;; ****************************************************
;*;
;*;DISP_GYOU_S	PROC	NEAR
;*;	CALL	WIDITEM_CLEAR		; WINDOWS/アイテム表示設定クリア
;*;	CALL	WIDDSP_SAVE		; WINDOWS/画面退避
;*;	MOV	REC_NO,0
;*;DISP_GYOU_S_LOOP:
;*;	MOV	DX,0			; 種別
;*;	MOV	CX,REC_NO		; レコード番号
;*;	CALL	WIDWORKS_OPEN		; WINDOWS/行い（おこない）オープン
;*;	CMP	AX,0			; 0=正常
;*;	JNE	DISP_GYOU_S_LOOP_E	;
;*;
;*;	INC	REC_NO			; レコード番号
;*;	JMP	DISP_GYOU_S_LOOP
;*;DISP_GYOU_S_LOOP_E:
;*;	CALL	US_WAIT			; ユーザ待ち
;*;	CALL	WIDDSP_LOAD		; WINDOWS/画面復元
;*;	RET
;*;DISP_GYOU_S	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	テキストテスト
;*;;	-I- CMD_LINE  : コマンドライン
;*;; ****************************************************
;*;
;*;TEXT_TEST	PROC	NEAR
;*;	CALL	WIDTXT_OPEN		; WINDOWS/テキストウインドウＯＰＥＮ
;*;	MOV	WDTXTSEG,DS		; WINDOWS/表示文字列セグメント
;*;	MOV	WDTXTADR,OFFSET MSG_TEST ; WINDOWS/表示文字列アドレス
;*;	CALL	WIDTXT			; WINDOWS/テキストウインドウ
;*;	CALL	WIDTXT_CLOSE		; WINDOWS/テキストウインドウＣＬＯＳＥ
;*;	RET
;*;TEXT_TEST	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	バトルテスト
;*;; ****************************************************
;*;
;*;BATL_TEST	PROC	NEAR
;*;	CALL	R_SENTOU			; 戦闘！
;*;	CALL	MAIN_WINDOW_RE_WRITE		; メインウインドウ・再表示
;*;	RET
;*;BATL_TEST	ENDP


; ****************************************************
;	武闘会テスト
; ****************************************************

BUTOH_TEST	PROC	NEAR
	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避

	CALL	R_SENTOU_BU_LOAD	; 武闘会戦闘・先行ロード
	CALL	R_SENTOU_BU_OPEN	; 武闘会戦闘・ＯＰＥＮ

	MOV	AX,0			; キャラクタ番号／私の娘
	MOV	BX,1			; キャラクタ番号／私の娘のライバル

	CALL	R_SENTOU_BU		; 武闘会戦闘！
	CALL	R_SENTOU_BU_CLOSE	; 武闘会戦闘・ＣＬＯＳＥ

	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元
	RET
BUTOH_TEST	ENDP


; ****************************************************
;	音楽テスト
;	-I- CMD_LINE  : コマンドライン
; ****************************************************

TEST_MUSIC	PROC	NEAR
	MOV	SI,OFFSET CMD_LINE	; コマンドライン
	ADD	SI,2			; コマンドライン
	CALL	STRDEC			;

	MOV	AX,DX			; 曲データ番号
	CALL	M_PLAY			; 音楽演奏
	RET
TEST_MUSIC	ENDP


; ****************************************************
;	音楽テスト（メニュー付き）
; ****************************************************

TEST_MUSIC_M	PROC	NEAR

TEST_MUSIC_M_LOOP:
	SELECT	"END,1プﾛﾛｰグ,2ﾒｲﾝﾃｰﾏ,3子育て,4非行化(ﾎﾞﾂ),5病気,6お城,7修行,8ｱﾙバｲﾄ,9バｶﾝｽ,10城外,11収穫祭,12武闘会,13ﾐｽｺﾝ,14バﾄﾙ,15ｴﾝデｨﾝグ,FOUT"
	CMP	WIDSNM,0		; ノーマル実行
	JE	TEST_MUSIC_M_EXIT	;
	CMP	WIDSNM,16		;
	JE	TEST_MUSIC_M_FOUT	;
	CMP	WIDSNM,15		; ノーマル実行
	JNBE	TEST_MUSIC_M_EXIT	;

	MOV	AX,WIDSNM		; 曲データ番号
	CALL	M_PLAY			; 音楽演奏

	JMP	TEST_MUSIC_M_LOOP	;
TEST_MUSIC_M_FOUT:			;
	EXTRN	M_FDOT:NEAR		; 音楽フェードアウト
	CALL	M_FDOT			; 音楽フェードアウト

	JMP	TEST_MUSIC_M_LOOP	;
TEST_MUSIC_M_EXIT:
	MUSIC	KYOKU_M_CUT			; 音楽カット
	RET
TEST_MUSIC_M	ENDP


;*NON*;; ****************************************************
;*NON*;;	スケジュール
;*NON*;; ****************************************************
;*NON*;
;*NON*;SCHEDULE	PROC	NEAR
;*NON*;	CALL	R_SCHED			; スケジュール
;*NON*;	CALL	R_PROG			; スケジュール実行
;*NON*;	RET
;*NON*;SCHEDULE	ENDP


; ****************************************************
;	オート実行
; ****************************************************

AUTO_DEMO_START	PROC	NEAR
	MOV	WIDSDEMO,55		; デモフラグ0=通常,55=ランダムセレクト
	MOV	WIDBDEMO,33		; デモフラグ0=通常,33=ランダムセレクト
	MOV	TALKDEMO,55		; デモフラグ0=通常,55=ランダムセレクト
	MOV	R_LDDEMO,33		; デモフラグ0=通常,33=ランダムセレクト
	MOV	RRMAPWIDEMO,55		; デモフラグ0=通常,55=ランダムセレクト
	MOV	DEMO_MODE,22		; デモモード0=通常,22=デモモード
	MOV	DEBUG_RANDUM_DIR,22	; (R_MUSYA.ASM)ランダム移動モード=22
	RET
AUTO_DEMO_START	ENDP


; ****************************************************
;	収穫祭無限ループ
; ****************************************************

AUTO_DEMO_SYU_START	PROC	NEAR
	CMP	DEMO_MODE_SYU,66	; デモモード収穫祭 0=通常,66=収穫祭ﾙｰﾌﾟ
	JE	AUTO_DEMO_SYU_START_STOP
	MOV	DEMO_MODE_SYU,66	; デモモード収穫祭 66=収穫祭ﾙｰﾌﾟ
	PRF	"収穫祭無限ループ"
	RET
AUTO_DEMO_SYU_START_STOP:
	MOV	DEMO_MODE_SYU,0		; デモモード収穫祭 0=通常
	PRF	"解除"
	RET
AUTO_DEMO_SYU_START	ENDP


; ****************************************************
;	オート実行ストップ
; ****************************************************

AUTO_DEMO_STOP	PROC	NEAR
	MOV	WIDSDEMO,0		; デモフラグ0=通常,55=ランダムセレクト
	MOV	WIDBDEMO,0		; デモフラグ0=通常,33=ランダムセレクト
	MOV	TALKDEMO,0		; デモフラグ0=通常,55=ランダムセレクト
	MOV	R_LDDEMO,0		; デモフラグ0=通常,33=ランダムセレクト
	MOV	RRMAPWIDEMO,0		; デモフラグ0=通常,55=ランダムセレクト
	MOV	DEMO_MODE,0		; デモモード0=通常,22=デモモード
	MOV	DEBUG_RANDUM_DIR,0	; (R_MUSYA.ASM)ランダム移動モード=22
	RET
AUTO_DEMO_STOP	ENDP


;*;; ****************************************************
;*;;	スケジュール無限実行
;*;; ****************************************************
;*;
;*;SCHEDULE_ALL	PROC	NEAR
;*;	CALL	CMND_STATUS		; コマンド／ステータス
;*;	MOV	WIDSDEMO,55		; デモフラグ0=通常,55=ランダムセレクト
;*;	MOV	WIDBDEMO,33		; デモフラグ0=通常,33=ランダムセレクト
;*;	MOV	TALKDEMO,55		; デモフラグ0=通常,55=ランダムセレクト
;*;	MOV	R_LDDEMO,33		; デモフラグ0=通常,33=ランダムセレクト
;*;	MOV	RRMAPWIDEMO,55		; デモフラグ0=通常,55=ランダムセレクト
;*;	MOV	DEMO_MODE,22		; デモモード0=通常,22=デモモード
;*;
;*;;*;SCHEDULE_ALL_LOOP:
;*;;*;	CALL	R_SCHED			; スケジュール
;*;;*;	CALL	R_PROG			; スケジュール実行
;*;;*;	JMP	SCHEDULE_ALL_LOOP	;
;*;	RET
;*;SCHEDULE_ALL	ENDP


;*;; ****************************************************
;*;;	ＰＵＴチェック
;*;;	-I- CMD_LINE  : コマンドライン
;*;;
;*;;	ＰＴ＿ｍｎ　　　ｍ＝少女（成長１,成長２,成長３,成長４）
;*;;	　　｜　　　　　ｎ＝季節（1:春，2:夏，3:秋，4:冬）
;*;;	　　Ｂベース
;*;;	　　Ｄ服
;*;;	　　Ｆ顔　　　　ｎ＝表情（１－３）
;*;;	　　Ｍ背景　　　ｍ＝背景（1:右,2:左）
;*;; ****************************************************
;*;
;*;CMD_PUT_CHK	PROC	NEAR
;*;	MOV	SI,OFFSET CMD_LINE	; コマンドライン
;*;
;*;	MOV	AH,DS:[SI][3]		; 成長
;*;	MOV	AL,DS:[SI][4]		; 季節
;*;	SUB	AH,'0'			;
;*;	SUB	AL,'0'			;
;*;	MOV	BYTE PTR FLAG_GIRL,AH	; 少女（成長１,成長２,成長３,成長４）
;*;	MOV	BYTE PTR FLAG_SIDE,AH	; 背景（1:右,2:左）
;*;	MOV	BYTE PTR FLAG_SEASON,AL	; 季節（1:春，2:夏，3:秋，4:冬）
;*;	MOV	BYTE PTR FLAG_FACE,AL	; 顔（１－３）
;*;
;*;	CMP	DS:[SI][2],BYTE PTR 'B'	; ベース
;*;	JMPEQ	CMD_PUT_CHK_BASE	;
;*;	CMP	DS:[SI][2],BYTE PTR 'D'	; 服
;*;	JMPEQ	CMD_PUT_CHK_DRESS	;
;*;	CMP	DS:[SI][2],BYTE PTR 'F'	; 顔
;*;	JMPEQ	CMD_PUT_CHK_FACE	;
;*;	CMP	DS:[SI][2],BYTE PTR 'M'	; 背景
;*;	JMPEQ	CMD_PUT_CHK_BG		;
;*;
;*;	PRF	"ＰＴ＿ｍｎ　　　ｍ＝少女（成長１,成長２,成長３,成長４）"
;*;	PRF	"　　｜　　　　　ｎ＝季節（1:春，2:夏，3:秋，4:冬）"
;*;	PRF	"　　Ｂベース"
;*;	PRF	"　　Ｄ服"
;*;	PRF	"　　Ｆ顔　　　　ｎ＝表情（１－３）"
;*;	PRF	"　　Ｍ背景　　　ｍ＝背景（1:右,2:左）"
;*;	RET
;*;
;*;CMD_PUT_CHK_BASE:
;*;	MOV	DX,FLAG_GIRL		; 少女（成長１,成長２,成長３,成長４）
;*;	MOV	AX,0			; ＰＵＴ　Ｘ座標
;*;	MOV	BX,0			; ＰＵＴ　Ｙ座標
;*;	CALL	PT_CHR_BASE		; キャラクタ・ベース
;*;	JMP	CMD_PUT_CHK_EXIT	;
;*;CMD_PUT_CHK_DRESS:
;*;	MOV	DX,FLAG_GIRL		; 少女（成長１,成長２,成長３,成長４）
;*;	MOV	CX,FLAG_SEASON		; 季節（1:春，2:夏，3:秋，4:冬）
;*;	MOV	AX,0			; ＰＵＴ　Ｘ座標
;*;	MOV	BX,0			; ＰＵＴ　Ｙ座標
;*;	CALL	PT_CHR_DRESS		; 服変化（４シーズン）
;*;	JMP	CMD_PUT_CHK_EXIT	;
;*;CMD_PUT_CHK_FACE:
;*;;*NON*;	MOV	DX,FLAG_GIRL	; 少女（成長１,成長２,成長３,成長４）
;*;*;NON*;	MOV	CX,FLAG_FACE		; 顔（１－３）
;*;;*NON*;	MOV	AX,0			; ＰＵＴ　Ｘ座標
;*;;*NON*;	MOV	BX,0			; ＰＵＴ　Ｙ座標
;*;;*NON*;	CALL	PT_CHR_FACE		; 顔変化
;*;	JMP	CMD_PUT_CHK_EXIT	;
;*;CMD_PUT_CHK_BG:
;*;	MOV	DX,FLAG_SIDE		; 背景（1:右,2:左）
;*;	MOV	CX,FLAG_SEASON		; 季節（1:春，2:夏，3:秋，4:冬）
;*;	MOV	AX,0			; ＰＵＴ　Ｘ座標
;*;	MOV	BX,0			; ＰＵＴ　Ｙ座標
;*;	CALL	PT_CHR_BG_MAIN		; メインＢＧ－ＰＵＴ
;*;	CALL	WIDCLEN_SHOW		; WINDOWS/カレンダー・再表示
;*;	CALL	WIDDSP_ALG		; WINDOWS/季節アナログ設定
;*;	JMP	CMD_PUT_CHK_EXIT	;
;*;CMD_PUT_CHK_EXIT:
;*;	RET
;*;CMD_PUT_CHK	ENDP


;*NON*;
;*NON*;; ***********************************************
;*NON*;;	実行メニュー
;*NON*;;	-I- WDBTNPUSH: ボタン押したフラグ 0=ボタンに触れてない
;*NON*;;	               1=ボタンに触れた,  2=ボタンを押した
;*NON*;;	    WDBTNNUM : 選択ボタン番号  0=ボタンに触れてない
;*NON*;;	               1=ＹＥＳ,2=ＮＯ,3=王様,4=町の評判
;*NON*;;	               5=ステータス,6=娘と話す,7=買物
;*NON*;; ***********************************************
;*NON*;
;*NON*;RUN_MENU	PROC	NEAR
;*NON*;	CMP	WDBTNPUSH,2		; 2=ボタンを押した
;*NON*;	JE	RUN_MENU_START		;
;*NON*;	RET
;*NON*;
;*NON*;RUN_MENU_START:
;*NON*;
;*NON*;	BANDCHK	WDBTNNUM,1,7,RUN_MENU_ERROR	; 選択ボタン番号チェック
;*NON*;
;*NON*;;*;	PR_TXT	"ボタンが押された　"
;*NON*;
;*NON*;	JMPTBL	WDBTNNUM		; 選択ボタン番号
;*NON*;	DW	OFFSET RUN_MENU_ERROR	;
;*NON*;	DW	OFFSET RUN_MENU_YES	; 1=ＹＥＳ
;*NON*;	DW	OFFSET RUN_MENU_NO	; 2=ＮＯ
;*NON*;	DW	OFFSET RUN_MENU_KING	; 3=王様
;*NON*;	DW	OFFSET RUN_MENU_TOWNS	; 4=町の評判
;*NON*;	DW	OFFSET RUN_MENU_STATUS	; 5=ステータス
;*NON*;	DW	OFFSET RUN_MENU_TALK	; 6=娘と話す
;*NON*;	DW	OFFSET RUN_MENU_SHOP	; 7=買物
;*NON*;
;*NON*;RUN_MENU_YES:				; 1=ＹＥＳ
;*NON*;	PR_TXT	"ＹＥＳ"
;*NON*;	RET
;*NON*;
;*NON*;RUN_MENU_NO:				; 2=ＮＯ
;*NON*;	PR_TXT	"ＮＯ"
;*NON*;	RET
;*NON*;
;*NON*;RUN_MENU_KING:				; 3=王様
;*NON*;	PR_TXT	"王様"
;*NON*;	RET
;*NON*;
;*NON*;RUN_MENU_TOWNS:				; 4=町の評判
;*NON*;	PR_TXT	"町の評判"
;*NON*;	RET
;*NON*;
;*NON*;RUN_MENU_STATUS:			; 5=ステータス
;*NON*;	CALL	MSCSTP			; カーソルストップ
;*NON*;	PR_TXT	"ステータス"
;*NON*;	CALL	CMND_STATUS		; コマンド／ステータス
;*NON*;	CALL	MSCSRT			; カーソルスタート
;*NON*;	RET
;*NON*;
;*NON*;RUN_MENU_TALK:				; 6=娘と話す
;*NON*;	PR_TXT	"わーいわーいのわーい"
;*NON*;	RET
;*NON*;
;*NON*;RUN_MENU_SHOP:				; 7=買物
;*NON*;	CALL	MSCSTP			; カーソルストップ
;*NON*;	CALL	R_KAIMON		; 買物
;*NON*;	CALL	MSCSRT			; カーソルスタート
;*NON*;	RET
;*NON*;
;*NON*;RUN_MENU_ERROR:
;*NON*;	PR_TXT	"選択ボタン番号エラー WDBTNNUM=",WDBTNNUM
;*NON*;	RET
;*NON*;RUN_MENU	ENDP



; ***********************************************
;	コマンド／ステータス
;	-I- MAN_NUM   : 娘番号
; ***********************************************

CMND_STATUS	PROC	NEAR
;*;	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避

	CALL	R_SOUBI			; 装備

;*;	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元
	RET
CMND_STATUS	ENDP



; ***********************************************
;	日付更新
;	-I- CMD_LINE  : コマンドライン
;	    "DT1990/10/10"
; ***********************************************

CMD_UPDATE	PROC	NEAR
	MOV	SI,OFFSET CMD_LINE	; コマンドライン
	INC	SI
	INC	SI
	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_ENVIR			; 環境テーブル
	MOV	DI,ES:[BX][KAN_ENVIR_TIME]	; 環境時間
	MOV	CX,10				;
	REP	MOVSB				;

	CALL	WIDCLEN_SHOW			; WINDOWS/カレンダー・再表示
	CALL	WIDDSP_ALG		; WINDOWS/季節アナログ設定
	RET
CMD_UPDATE	ENDP


; ****************************************************
;	内部データ表示
; ****************************************************

TEMP_DISP	PROC	NEAR
	CALL	BLACK			; ブラックアウト

	CALL	CLS			; cls.

	PRVH	"CODE  =",<SEG CODE>
	PRVH	"SEGDOS=",SEGDOS
	PRVH	"SEGWID=",SEGWID
	PRVH	"SEGFRE=",SEGFRE
	PRVH	"0=",SEGPAT0
	PRVH	"1=",SEGPAT1
	PRVH	"2=",SEGPAT2
	PRVH	"3=",SEGPAT3
	PRVH	"4=",SEGPAT4
	PRVH	"5=",SEGPAT5
	PRVH	"6=",SEGPAT6
	PRVH	"7=",SEGPAT7
	PRVH	"8=",SEGPAT8
	PRVH	"9=",SEGPAT9
	PRVH	"10=",SEGPAT10

	CALL	US_WAIT			; ユーザ待ち

	CALL	CLS			; cls.

	CALL	BRIIN			; 明度５０％からノーマルへ

	RET
TEMP_DISP	ENDP


; ***********************************************
;	analog switch.
; ***********************************************

ANALOG_SET	PROC	NEAR
	CALL	BRIOUT		; 明度５０％ダウン

	INP	"0=normal analog,1=386LSX(15color),2=full DIGITAL,3=B/W : "
	CALL	STRDEC
	MOV	SW_ANALOG,DX		; analog switch.

	CALL	BRIIN		; 明度５０％からノーマルへ
	RET
ANALOG_SET	ENDP


; ***********************************************
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
; ***********************************************

OCHI_HYOUJI	PROC	NEAR
	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避

	CALL	CLS
	CALL	VRMCLR

;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

	CALL	R_SR_YOIDESUKA		; よいですか

	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元
	RET
OCHI_HYOUJI	ENDP


; ***********************************************
;voidvoidvoid
;voidvoidvoid
; ***********************************************

OCHI_HYOU1	PROC	NEAR
;voidvoidvoid
;voidvoidvoid
	RET
OCHI_HYOU1	ENDP


; ***********************************************
;voidvoidvoid
;voidvoidvoid
; ***********************************************

OCHI_HYOU2	PROC	NEAR
;voidvoidvoid
;voidvoidvoid
	RET
OCHI_HYOU2	ENDP


; ***********************************************
;voidvoidvoid
;voidvoidvoid
; ***********************************************

OCHI_HYOU3	PROC	NEAR
;voidvoidvoid
;voidvoidvoid
	RET
OCHI_HYOU3	ENDP


; ***********************************************
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
; ***********************************************

OCHI_HYOU4	PROC	NEAR
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid
;voidvoidvoid

;voidvoidvoid
	JG	OCHI_HYOU4_21		;
	MOV	DX,1			;
	JMP	OCHI_HYOU4_77		;
OCHI_HYOU4_21:
;voidvoidvoid
	JG	OCHI_HYOU4_22		;
	MOV	DX,2			;
	JMP	OCHI_HYOU4_77		;
OCHI_HYOU4_22:
;voidvoidvoid
	JG	OCHI_HYOU4_23		;
	MOV	DX,3			;
	JMP	OCHI_HYOU4_77		;
OCHI_HYOU4_23:
;voidvoidvoid
	JG	OCHI_HYOU4_24		;
	MOV	DX,4			;
	JMP	OCHI_HYOU4_77		;
OCHI_HYOU4_24:
;voidvoidvoid
	JG	OCHI_HYOU4_25		;
	MOV	DX,5			;
	JMP	OCHI_HYOU4_77		;
OCHI_HYOU4_25:
OCHI_HYOU4_77:
;voidvoidvoid

;voidvoidvoid

;*;	MUSIC	KYOKU_F_O		; 音楽フェードアウト
;*;	CALL	FEDOUT			; Ｆ．Ｏ
;*;	CALL	VRMCLR			; ＶＲＡＭクリア
;voidvoidvoid
;voidvoidvoid

	RET
OCHI_HYOU4	ENDP


; ***********************************************
;	テストバカンス
;	-I- CMD_LINE  : コマンドライン
;
;	"TH12"	:成長１，夏
;
; ***********************************************

TEST_HORIDAY	PROC	NEAR
	MOV	AX,0

	MOV	AL,CMD_LINE[2]
	SUB	AL,'0'
	CMP	AL,0
	JB	TEST_HORIDAY_EXIT
	CMP	AL,9
	JNBE	TEST_HORIDAY_EXIT
	MOV	DX,AX

	MOV	AL,CMD_LINE[3]
	SUB	AL,'0'
	CMP	AL,0
	JB	TEST_HORIDAY_EXIT
	CMP	AL,9
	JNBE	TEST_HORIDAY_EXIT
	MOV	CX,AX

	PUSH	CX
	PUSH	DX
	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避
	POP	DX
	POP	CX

	;	DX : 少女（成長１,成長２,成長３,成長４）
	;	CX : 季節（1:春，2:夏，3:秋，4:冬）
	CALL	PT_BACA_LD		; バカンスの絵ロード
	CALL	PT_BACA_PUT		; バカンスの絵ＰＵＴ

	CALL	R_SR_YOIDESUKA		; よいですか

	CALL	WIDDSP_ALG		; WINDOWS/季節アナログ設定

	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元

TEST_HORIDAY_EXIT:
	RET
TEST_HORIDAY	ENDP


; ***********************************************
;	パラメータ操作
;	-I- CMD_LINE  : コマンドライン
;
;	"ＣＣ０１　２００"　ポイント
;	 0011223344556677
; ***********************************************

EDIT_PARA	PROC	NEAR
	CMP	CMD_LINE[2],0		;
	JNE	EDIT_PARA_START		;
	RET
EDIT_PARA_START:
	MOV	SI,OFFSET CMD_LINE	; コマンドライン
	ADD	SI,2			; コマンドライン
	MOV	DS:[SI][2],BYTE PTR 0	;
	CALL	STRDEC			;

	MOV	AX,DX			; パラメータ番号
	MOV	BX,GRP_NEXT		; 次のグラフ
	MUL	BX			;
	MOV	SI,AX			; パラメータオフセット

	PUSH	SI
	MOV	SI,OFFSET CMD_LINE	; コマンドライン
	ADD	SI,5			; コマンドライン
	CALL	STRDEC			;
	POP	SI

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_GRP		; グラフテーブルオフセット
	MOV	ES:[BX][SI][GRP_VALUE],DX
	MOV	ES:[BX][SI][GRP_VALMAX],DX
	RET
EDIT_PARA	ENDP


; ***********************************************
;	パラメータ操作（内容値）
;	-I- CMD_LINE  : コマンドライン
;
;	"ＣＶ０１　２００"　内容値
;	 0011223344556677
; ***********************************************

EDIT_VALUE	PROC	NEAR
	CMP	CMD_LINE[2],0		;
	JNE	EDIT_VALUE_START	;
	RET
EDIT_VALUE_START:
	MOV	SI,OFFSET CMD_LINE	; コマンドライン
	ADD	SI,2			; コマンドライン
	MOV	DS:[SI][2],BYTE PTR 0	;
	CALL	STRDEC			;

	MOV	AX,DX			; パラメータ番号
	MOV	BX,VAL_NEXT		; 次の内容表示
	MUL	BX			;
	MOV	SI,AX			; パラメータオフセット

	PUSH	SI
	MOV	SI,OFFSET CMD_LINE	; コマンドライン
	ADD	SI,5			; コマンドライン
	CALL	STRDEC			;
	POP	SI

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_VAL		; 内容表示テーブルオフセット
	MOV	ES:[BX][SI][VAL_VALUE],DX
	RET
EDIT_VALUE	ENDP


; ***********************************************
;	コマンドラインセット
;	-I- DS:SI     : コマンドライン
;	-O- CMD_LINE  : コマンドライン
;	    CMND_WORD : コマンドワード
; ***********************************************

CMD_SET		PROC	NEAR
	MOV	AX,DS:[SI]			;
	MOV	CMND_WORD,AX			; コマンドワード

	MOV	AX,DS				;
	MOV	ES,AX				;
	MOV	CX,BUFF_LEN			; バッファ長さ
	MOV	DI,OFFSET CMD_LINE		; コマンドライン
	REP	MOVSB				;
	RET
CMD_SET		ENDP



; ***********************************************
;	キーテーブルクリア
; ***********************************************

KEYCLEAR	PROC	NEAR
	MOV	BX,0
	MOV	CX,16
KEYCLEAR2:
	MOV	BYTE PTR KYTBLS[BX],0	; key code table.
	INC	BX
	LOOP	KEYCLEAR2
	RET
KEYCLEAR	ENDP


CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	EXIT_FLAG			; １＝強制終了
PUBLIC	DEMO_MODE_SYU			; デモモード収穫祭 0=通常,66=収穫祭ﾙｰﾌﾟ

EXTRN	KYTBLS:BYTE			; key code table top.

EXTRN	WIDSDEMO:WORD			; (WIDSLCT.ASM)デモフラグ
					; 0=通常,55=ランダムセレクト
EXTRN	WIDBDEMO:WORD			; (WIDBTN.ASM)デモフラグ
					; 0=通常,33=ランダムセレクト
EXTRN	TALKDEMO:WORD			; (TALKER.ASM)デモフラグ
					; 0=通常,55=ランダムセレクト
EXTRN	R_LDDEMO:WORD			; (R_LOADS.ASM)デモフラグ
					; 0=通常,33=ランダムセレクト
EXTRN	RRMAPWIDEMO:WORD		; (R_MAPWID.ASM)デモフラグ
					; 0=通常,55=ランダムセレクト

EXTRN	DEBUG_RANDUM_DIR:WORD		; (R_MUSYA.ASM)ランダム移動モード
EXTRN	DEBUG_MONSTER_SKIP:WORD		; (R_MUSYA.ASM)モンスタースキップ

EXTRN	SLCT_CLASS:WORD			; 階級選択
EXTRN	SLCT_WORKS:WORD			; 仕事選択


EXTRN	SEGDOS:WORD			; ＤＯＳインターフェースセグメント
EXTRN	SEGWID:WORD			; ＷＩＮＤＯＷＳセグメント
EXTRN	SEGFRE:WORD			; フリー領域の先頭セグメント

EXTRN	SEGPAT0:WORD
EXTRN	SEGPAT1:WORD
EXTRN	SEGPAT2:WORD
EXTRN	SEGPAT3:WORD
EXTRN	SEGPAT4:WORD
EXTRN	SEGPAT5:WORD
EXTRN	SEGPAT6:WORD
EXTRN	SEGPAT7:WORD
EXTRN	SEGPAT8:WORD
EXTRN	SEGPAT9:WORD
EXTRN	SEGPAT10:WORD
EXTRN	SSDES0:WORD
EXTRN	SSDES1:WORD
EXTRN	SSDES2:WORD
EXTRN	SSDES3:WORD
EXTRN	SSSOU0:WORD
EXTRN	SSSOU1:WORD
EXTRN	SSSOU2:WORD
EXTRN	SSSOU3:WORD



EXTRN	SW_ANALOG:WORD			; analog switch.
					; 0=normal analog
					; 1=386LSX(15color)
					; 2=full DIGITAL
					; 3=B/W

EXTRN	IPLMSW:WORD			; パレットエフェクト単位時間(VSYNC)

EXTRN	R_LOAD_FUNC:WORD		; ロードセーブ機能 1=ロード,2=セーブ

EXTRN	W_STAT_HEAD_NO:WORD		; ヘッダー番号

EXTRN	S_FUNC:WORD			; 計算ファンクション

EXTRN	W_GIRL_SEASON:WORD		; 季節（1:春，2:夏，3:秋，4:冬）
EXTRN	W_GIRL_GROW:WORD		; 少女（成長１,成長２,成長３,成長４）
EXTRN	W_GIRL_FACE:WORD		; 顔（１－３）

EXTRN	OCHI_KIND:WORD			; 落ちの種類
EXTRN	OCHI_CUT:WORD			; 落ちのカット番号

DEMO_MODE	DW	0		; デモモード 0=通常,22=デモモード
DEMO_MODE_SYU	DW	0		; デモモード収穫祭 0=通常,66=収穫祭ﾙｰﾌﾟ

HANDLE		DW	5 DUP (0)	; ハンドル

NUM		DW	0
REC_NO		DW	0
MAN_NUM		DW	0

CMND_WORD	DW	0	; コマンドワード

FLAG_GRAP	DW	0	; 横グラフ表示フラグ
;*;FLAG_UPDATE	DW	0	; 日付更新フラグ

FLAG_GIRL	DW	0	; 少女（成長１,成長２,成長３,成長４）
FLAG_SEASON	DW	0	; 季節（1:春，2:夏，3:秋，4:冬）
FLAG_FACE	DW	0	; 顔（１－３）
FLAG_SIDE	DW	0	; 背景（1:右,2:左）

EXIT_FLAG	DW	0	; １＝強制終了

CMD_LINE	DB	BUFF_LEN DUP (0),0,0	; コマンドライン


MONSTER_NUMBER	DW	0	; モンスター番号

MSTR_MENU_PNT	DW	0	; モンスターメニューポインタ
MSTR_MENU_MAX	DW	6	; モンスターメニュー数
MSTR_MENU_TABLE	LABEL	WORD	; モンスターメニューテーブル
		DW	OFFSET MSTR_D_00
		DW	OFFSET MSTR_D_01
		DW	OFFSET MSTR_D_02
		DW	OFFSET MSTR_D_03
		DW	OFFSET MSTR_D_04
		DW	OFFSET MSTR_D_05
MSTR_D_00	DB	"終,次,00,01,02,03,04,05,06,07,08,09",0
MSTR_D_01	DB	"終,次,10,11,12,13,14,15,16,17,18,19",0
MSTR_D_02	DB	"終,次,20,21,22,23,24,25,26,27,28,29",0
MSTR_D_03	DB	"終,次,30,31,32,33,34,35,36,37,38,39",0
MSTR_D_04	DB	"終,次,40,41,42,43,44,45,46,47,48,49",0
MSTR_D_05	DB	"終,次,50,51,52,53,54,55,56,57,58,59",0


FLAG_SUPER	DW	0	; スーパー指定

;*;;	表示文字列
;*;
;*;MSG_TEST	LABEL	BYTE
;*;		DB	"１@"
;*;		DB	"２@"
;*;		DB	"３@"
;*;		DB	"４@"
;*;		DB	"５@"
;*;		DB	"６@"
;*;		DB	"７@"
;*;		DB	"８@"
;*;		DB	0,0

DATA	ENDS

	END
;
;	end of "KOSODATE.ASM"
;
