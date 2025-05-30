; "R_MUSYA.ASM" PC-9801UV11 make by R.H 1990/11/6
;
;
;	「子育て」
;
;	武者修行
;
;
;	プログラム中で仮想ＶＲＡＭを使っている。
;
;	PUBLIC	DEBUG_MONSTER_SKIP : デバック用モンスタースキップ
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

CCT_OPEN_TYPE	EQU	3	; オープンタイプ

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

MOVXBW	MACRO	DEST,SOUR
	MOV	AH,0
	MOV	AL,SOUR
	MOV	DEST,AX
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	R_MUSYA_SET			; 武者修行セット
PUBLIC	R_MUSYA_MAIN			; 武者修行メイン

PUBLIC	KEIKEN_PRINT			; "経験値を得た。"

EXTRN	R_LOAD_MUSYA_LOAD:NEAR		; 武者プロセスの起動
EXTRN	R_LOAD_MUSYA_CALL:NEAR		; 武者プロセスの呼出し

EXTRN	R_MAIN_WINDOW_DSP:NEAR		; メインウインドウ復帰

EXTRN	BAD_WIND02_OPEN:NEAR		; 病気ステータス無表示ＯＰＥＮ
EXTRN	BAD_WIND02_CLOSE:NEAR		; 病気ステータス無表示ＣＬＯＳＥ

EXTRN	BAD_WIND03_OPEN:NEAR		; ステータス無表示ＯＰＥＮ
EXTRN	BAD_WIND03_CLOSE:NEAR		; ステータス無表示ＣＬＯＳＥ

EXTRN	R_MAPWID:NEAR			; マップ用メッセージウインドウ
EXTRN	R_MAPITM:NEAR			; マップ用アイテムウインドウ

EXTRN	R_KEISAN:NEAR			; 各計算処理

EXTRN	R_BORTH_DAY:NEAR		; 誕生日の処理
EXTRN	R_BORTH_DAY_DR:NEAR		; 日数遅れの誕生日

EXTRN	R_WORK_SCH:NEAR			; 行い条件検索
EXTRN	R_GET_SELECT:NEAR		; ｱｲﾃﾑレコード内から選択単語を取り出す

EXTRN	WIDSLC_INIT:NEAR		; WINDOWS/セレクト・ウインドウ初期処理
EXTRN	WIDSLC:NEAR			; WINDOWS/セレクト・ウインドウ

EXTRN	R_SR_PRICE:NEAR			; 通貨表示
EXTRN	R_SR_IDSTR:NEAR			; ＩＤ文字列表示

EXTRN	R_SCHO_MONTH:NEAR		; 成長の月次処理
EXTRN	R_SCHO_DAYS:NEAR		; 成長の日次処理

EXTRN	R_SENTOU_MS_LOAD:NEAR		; 武者修行・先行ロード
EXTRN	R_SENTOU_MS_OPEN:NEAR		; 武者修行・ＯＰＥＮ
EXTRN	R_SENTOU_MS:NEAR		; 武者修行戦闘！
EXTRN	R_SENTOU_MS_CLOSE:NEAR		; 武者修行・ＣＬＯＳＥ

EXTRN	WIDBAR_MUSYA_OPEN:NEAR		; WINDOWS/バー・武者修行行き先OPEN
EXTRN	WIDBAR_MUSYA_CLOSE:NEAR		; WINDOWS/バー・武者修行行き先CLOSE
EXTRN	WIDBAR_MUSYA:NEAR		; WINDOWS/バー・武者修行行き先PUT
EXTRN	WIDBAR_SOUBI_OPEN:NEAR		; WINDOWS/バー・装備ＯＰＥＮ
EXTRN	WIDBAR_SOUBI_CLOSE:NEAR		; WINDOWS/バー・装備ＣＬＯＳＥ

EXTRN	WIDFRM_MSA_OPEN:NEAR		; WINDOWS/武者修行ﾏｯプﾌﾚｰﾑＯＰＥＮ
EXTRN	WIDFRM_MSA_CLOSE:NEAR		; WINDOWS/武者修行ﾏｯプﾌﾚｰﾑＣＬＯＳＥ

EXTRN	WIDPROP_INIT:NEAR		; WINDOWS/プロポ・ウインドウ初期処理
EXTRN	WIDPROP_ALL:NEAR		; WINDOWS/プロポ・ウインドウ全表示
EXTRN	WIDPROP_OPEN:NEAR		; WINDOWS/プロポ・ウインドウＯＰＥＮ
EXTRN	WIDPROP_CLOSE:NEAR		; WINDOWS/プロポ・ウインドウＣＬＯＳＥ

EXTRN	WIDFRM_MAIN_HED:NEAR	; WINDOWS/フレーム・メイン・ヘッダ再表示

EXTRN	WIDDSP_SV_MN:NEAR		; WINDOWS/ｍｉｎｉステータス退避
EXTRN	WIDDSP_LD_MN:NEAR		; WINDOWS/ｍｉｎｉステータス復元

EXTRN	WIDCCT_INIT:NEAR		; WINDOWS/キャラクタ初期処理
EXTRN	WIDCCT_OPEN:NEAR		; WINDOWS/キャラクタオープン
EXTRN	WIDCCT_CLOSE:NEAR		; WINDOWS/キャラクタクローズ
EXTRN	WIDCCT_CHANGE:NEAR		; WINDOWS/キャラクタチェンジ

EXTRN	WIDCLEN_INIT:NEAR		; WINDOWS/カレンダー・初期処理
EXTRN	WIDCLEN_SET:NEAR		; WINDOWS/カレンダー・時間設定
EXTRN	WIDCLEN_SHOW:NEAR		; WINDOWS/カレンダー・再表示
EXTRN	WIDCLEN_UDATE:NEAR		; WINDOWS/カレンダー・更新処理
EXTRN	WIDCLEN_UDATE_ONLY:NEAR		; WINDOWS/カレンダー・更新のみ処理
EXTRN	WIDCLEN_GET:NEAR		; WINDOWS/カレンダー・読み取り処理
EXTRN	WIDCLEN_U_AD:NEAR		; WINDOWS/カレンダー・日付加算計算

EXTRN	WIDDSP_SV_MYST:NEAR		; WINDOWS/ＭＹステータス退避
EXTRN	WIDDSP_LD_MYST:NEAR		; WINDOWS/ＭＹステータス復元
EXTRN	WIDDSP_SV_YOU:NEAR		; WINDOWS/ＹＯＵヘッダー退避
EXTRN	WIDDSP_LD_YOU:NEAR		; WINDOWS/ＹＯＵヘッダー復元
EXTRN	WIDDSP_SV_YOUST:NEAR		; WINDOWS/ＹＯＵステータス退避
EXTRN	WIDDSP_LD_YOUST:NEAR		; WINDOWS/ＹＯＵステータス復元

EXTRN	MAIN_WINDOW_RE_WRITE:NEAR	; メインウインドウ・再表示

EXTRN	R_MS_MUSYA_SRT:NEAR		; 武者修行スタート台詞
EXTRN	R_MS_MUSYA_SLC:NEAR		; 武者修行選択台詞
EXTRN	R_MS_MUSYA_IDO:NEAR		; 武者修行移動台詞
EXTRN	R_MS_MUSYA_MAKE:NEAR		; 武者修行負け台詞

EXTRN	R_MS_KUCHIPAKU:NEAR		; 口パクモード
EXTRN	R_MS_KUCHISTOP:NEAR		; 口パクモード終り

EXTRN	R_SR_GIRL_NAME:NEAR		; キャラクタ名

EXTRN	R_SR_DATE_NOW:NEAR		; 本日の日付
EXTRN	R_SR_SR_LF:NEAR			; 改行
EXTRN	R_SR_SR_DESU:NEAR		; "です"
EXTRN	R_SR_SR_POTU:NEAR		; "・"
EXTRN	R_SR_PRICE:NEAR			; 通貨表示
EXTRN	R_SR_IDSTR:NEAR			; ＩＤ文字列表示
EXTRN	R_SR_POINT:NEAR			; ポイント表示
EXTRN	R_SR_WIDSTR:NEAR		; 文字列表示

EXTRN	R_SR_YOIDESUKA:NEAR		; よいですか

EXTRN	PT_PALET_ST:NEAR		; パレットのセット
EXTRN	PT_PALET_PLD:NEAR		; パレットのテーブルのみセット
EXTRN	PT_PALET_PLDP:NEAR		; パレットのテーブルのみセットﾃｰﾌﾞﾙ

EXTRN	PLTOLS:NEAR			; パレット・オーバラップ／時分割初期
EXTRN	PLTOLT:NEAR			; パレット・オーバラップ／時分割処理

EXTRN	PT_MUSYA_ALL_LOAD:NEAR		; 武者修行関係全ロード
EXTRN	PT_FREAM_MUSYA:NEAR		; 武者修行フレーム
;*;EXTRN PT_CHR_BG_MUSYA_LD:NEAR	; 武者修行ＢＧ－ロード
;*;EXTRN PT_CHR_BG_MUSYA_PT:NEAR	; 武者修行ＢＧ－ＰＵＴ

EXTRN	RANDAM_CX:NEAR			; 乱数範囲指定

EXTRN	PLTINTSW:NEAR			; パレット・割込み処理スイッチ

EXTRN	KEYHLT:NEAR			; キーボード機能のＯＮ／ＯＦＦ
EXTRN	MUSRED:NEAR			; マウス読み込み
EXTRN	MUSSET:NEAR			; マウス座標セット
EXTRN	MUSDSP:NEAR			; マウスＤＩＲのクリア

EXTRN	TKRSET:NEAR			; 台詞改行のカウンタリセット
EXTRN	TMVSET:NEAR			; V-SYNC timer set.
EXTRN	TMVEWT:NEAR			; V-SYNC timer end wait.


; ****************************************************
;	武者修行
;	-O- R_KOUMKU : 項目
;	    R_NAISTR : 内容文字列
;	    R_NAIYOU : 内容値
;	    R_NYUKIN : 入金
;	    R_SYUTSU : 出金
;	    KETTEI   : 0=決定,1=考え直す
; ****************************************************

R_MUSYA_SET	PROC	NEAR
	MOV	R_KOUMKU,ID_68		; 武者修行	

;*;	PR_TXT	"@武者修行"

	WD_ADRS	ID_00,R_NAISTR		; 無効
	MOV	R_NAIYOU,0		;
	MOV	R_NYUKIN,0		;
	MOVX	R_SYUTSU,0		;

;*STP*;	SELECT	"決めた,べつのにしよう"
;*STP*;	CMP	WIDSNM,1		; ユーザ選択番号
;*STP*;	JE	R_MUSYA_SET_YAMERU	;

	MOV	KETTEI,0		; 0=決定
	RET
;*STP*;R_MUSYA_SET_YAMERU:
;*STP*;	PR_TXT	"@武者修行はやめよ・・"
;*STP*;	MOV	KETTEI,1		; 1=考え直す
;*STP*;	RET
R_MUSYA_SET	ENDP


; ****************************************************
;	武者修行メイン
;	-I- DX : 継続か？ 0=通常,1=継続
;	-O- DX : 冒険中誕生日フラグ  1=冒険中に誕生日があった
;	    AX : 冒険の成功フラグ    1=成功している,2=やられた,3=ゴール
; ****************************************************

R_MUSYA_MAIN	PROC	NEAR
	MOV	QUEST_GOAL,0		; 冒険のゴール

	CMP	DX,1			; 継続か？ 0=通常,1=継続
	JE	R_MUSYA_MAIN_SKIP	;

	MOV	ALLDAY_COUNTER,0	; 全日数カウンタ（継続日数）

	CALL	R_MS_MUSYA_SRT		; 武者修行スタート台詞

	CALL	QEST_OPEN		; 冒険の幕開け

R_MUSYA_MAIN_SKIP:
	MOV	QUEST_BORTH_F,0		; 冒険中誕生日フラグ
	MOV	QUEST_SCCESS,0		; 冒険の成功フラグ

	CALL	BAD_WIND02_OPEN		; 病気ステータス無表示ＯＰＥＮ

	CALL	MOUSE_LCT_SAVE		; マウスロケート退避

	MOV	DAY_COUNTER,0		; 日数カウンタ
R_MUSYA_MAIN_LOOP:
	CMPX	DAY_COUNTER,R_NISSU	; 日数カウンタ
	JGE	R_MUSYA_MAIN_LOOP_END	;

	INC	ALLDAY_COUNTER		; 全日数カウンタ（継続日数）
	INC	DAY_COUNTER		; 日数カウンタ
	CALL	TIME_UPDATE		; 日付更新

;;	PR_LF
;;	CALL	TKRSET			; 台詞改行のカウンタリセット
	PR_CLS
	CALL	R_SR_DATE_NOW		; 本日の日付

	CALL	QEST_RUN		; 冒険！

	CALL	R_SCHO_DAYS		; 成長の日次処理

	CALL	WIDFRM_MAIN_HED		; WINDOWS/フレーム・メイン・ヘッダ再表
	CALL	WIDPROP_ALL		; WINDOWS/プロポ・ウインドウ全表示

	CMP	MY_GIRL_BORTH_F,1	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
	JNE	R_MUSYA_MAIN_NEXT	;

	MOV	QUEST_BORTH_F,1		; 1=冒険中に誕生日があった

R_MUSYA_MAIN_NEXT:
	CMP	QUEST_GOAL,1		; 冒険のゴール 1=ゴール
	JE	R_MUSYA_MAIN_GOAL	;
	CMP	QUEST_SCCESS,1		; 冒険の成功フラグ 1=成功している
	JNE	R_MUSYA_MAIN_DOWN	;

	JMP	R_MUSYA_MAIN_LOOP

R_MUSYA_MAIN_LOOP_END:
	CALL	MOUSE_LCT_LOAD			; マウスロケート復帰

	CALL	BAD_WIND02_CLOSE	; 病気ステータス無表示ＣＬＯＳＥ

	; 冒険成功

	CALL	QEST_CLOSE			; 冒険の終了

	JMP	R_MUSYA_MAIN_ALLE		;

R_MUSYA_MAIN_GOAL:				;
	CALL	MOUSE_LCT_LOAD			; マウスロケート復帰

	MOV	QUEST_SCCESS,3			; 3=ゴール

	CALL	QEST_CLOSE			; 冒険の終了

	; 家に帰った‥‥‥

	MOV	AX,1				; 1=ほうびアリ
	CALL	GHOUBI_INI			; 一周ごほうび

	MUSIC	KYOKU_F_O			; 音楽フェードアウト

	CALL	R_MS_KUCHIPAKU			; 口パクモード
	PR_LF					;
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_SR_GIRL_NAME			; キャラクタ名
	PR_TXT	"は家に帰った‥‥‥"
	CALL	R_MS_KUCHISTOP			; 口パクモード終り

	CALL	KEIKEN_PRINT			; "経験値を得た。"

	CALL	R_SR_YOIDESUKA			; よいですか

	CALL	R_MAIN_WINDOW_DSP		; メインウインドウ復帰

	CALL	MUSIC_KOSODATE			; 子育てのテーマ

	CMPX	DAY_COUNTER,R_NISSU		; 日数カウンタ
	JL	R_MUSYA_MAIN_3			;
	JMP	R_MUSYA_MAIN_ALLE		;
R_MUSYA_MAIN_3:					;
	JMP	R_MUSYA_MAIN_4			;

R_MUSYA_MAIN_DOWN:				;
	CALL	MOUSE_LCT_LOAD			; マウスロケート復帰

	CALL	QEST_CLOSE			; 冒険の終了

	; ○○○は戦いに敗れて家に逃げ帰った‥‥‥

	MOV	AX,2				; 2=ほうび無し
	CALL	GHOUBI_INI			; 一周ごほうび

	MUSIC	KYOKU_F_O			; 音楽フェードアウト

	CALL	R_MS_KUCHIPAKU			; 口パクモード
	PR_LF					;
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_SR_GIRL_NAME			; キャラクタ名
	PR_TXT	"は戦いに敗れて家に逃げ帰った‥‥‥"
	CALL	R_MS_KUCHISTOP			; 口パクモード終り

	CALL	KEIKEN_PRINT			; "経験値を得た。"

	CALL	R_SR_YOIDESUKA			; よいですか

	CALL	R_MAIN_WINDOW_DSP		; メインウインドウ復帰

	CALL	MUSIC_KOSODATE			; 子育てのテーマ

	CALL	R_MS_MUSYA_MAKE			; 武者修行負け台詞

	CMPX	DAY_COUNTER,R_NISSU		; 日数カウンタ
	JL	R_MUSYA_MAIN_4			;
	JMP	R_MUSYA_MAIN_ALLE		;
R_MUSYA_MAIN_4:					;

	; ○○○は、予定の残り△日分を家でぼんやり過ごした。

	CALL	R_MS_KUCHIPAKU			; 口パクモード
	PR_LF					;
	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	R_SR_GIRL_NAME			; キャラクタ名
	PR_TXT	"は、予定の残り"		;
	MOV	DX,R_NISSU			; 日数
	SUB	DX,DAY_COUNTER			; 日数カウンタ
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"日分を家でぼんやり過ごした。"	;
	CALL	R_MS_KUCHISTOP			; 口パクモード終り

	CMP	QUEST_BORTH_F,1			; 1=冒険中に誕生日があった
	JNE	R_MUSYA_MAIN_5			;
	CALL	R_BORTH_DAY_DR			; 日数遅れの誕生日
	MOV	QUEST_BORTH_F,0			;
R_MUSYA_MAIN_5:					;

	CALL	BAD_WIND03_OPEN			; ステータス無表示ＯＰＥＮ

R_MUSYA_MAIN_LOOP_2:				; 残り日数の消化
	CMPX	DAY_COUNTER,R_NISSU		; 日数カウンタ
	JGE	R_MUSYA_MAIN_LP_E_2		;

	CALL	GHOUBI_DAYS			; 一周ごほうび／日

	MOV	AX,4				; wait timer count.
	CALL	TMVSET				; V-SYNC timer set.
	INC	DAY_COUNTER			; 日数カウンタ
	CALL	WIDCLEN_UDATE			; WINDOWS/カレンダー・更新処理
	PR_LF
	CALL	TKRSET				; 台詞改行のカウンタリセット
	CALL	R_SR_DATE_NOW			; 本日の日付
	CALL	R_SCHO_DAYS			; 成長の日次処理
	CALL	TMVEWT				; V-SYNC timer end wait.
	CMP	MY_GIRL_BORTH_F,1	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ！
	JNE	R_MUSYA_MAIN_NEXT_2	;

	CALL	BAD_WIND03_CLOSE	; ステータス無表示ＣＬＯＳＥ

	CALL	R_BORTH_DAY		; 誕生日の処理

	CALL	BAD_WIND03_OPEN		; ステータス無表示ＯＰＥＮ

R_MUSYA_MAIN_NEXT_2:			;
	JMP	R_MUSYA_MAIN_LOOP_2	;

R_MUSYA_MAIN_LP_E_2:
	CALL	BAD_WIND03_CLOSE	; ステータス無表示ＣＬＯＳＥ
	CALL	GHOUBI_END		; 一周ごほうび／日

R_MUSYA_MAIN_ALLE:
	MOV	DX,QUEST_BORTH_F	; 1=冒険中に誕生日があった
	MOV	AX,QUEST_SCCESS		; 冒険の成功フラグ
	RET
R_MUSYA_MAIN	ENDP


; ****************************************************
;	冒険の幕開け
;	-O- WHERE_NOW     : 場所 1=近郊,2=辺境,3=蛮地
;	    KEIKENCHI_OLD : 旧経験値
; ****************************************************

QEST_OPEN	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	DX,0			; 加算される経験値
	MOV	S_FUNC,63		; 63=経験値の処理
	CALL	R_KEISAN		; 各計算処理
	MOV	KEIKENCHI_OLD,CX	; 旧経験値

	CALL	R_SENTOU_MS_LOAD	; 武者修行・先行ロード

	CALL	VRMWT1			; ＶＲＡＭ１アクセス

	CALL	R_SENTOU_MS_OPEN	; 武者修行・ＯＰＥＮ
	CALL	WIDBAR_MUSYA_OPEN	; WINDOWS/バー・武者修行行き先OPEN
	CALL	WIDBAR_SOUBI_OPEN	; WINDOWS/バー・装備ＯＰＥＮ
	CALL	WIDFRM_MSA_OPEN		; WINDOWS/武者修行ﾏｯプﾌﾚｰﾑＯＰＥＮ

;*;	MOV	AX,1			; 場所=1 近郊
;*;	CALL	PT_CHR_BG_MUSYA_LD	; 武者修行ＢＧ－ロード
;*;	CALL	PT_CHR_BG_MUSYA_PT	; 武者修行ＢＧ－ＰＵＴ
	MOV	FLAG_ANZEN,0		; 安全地帯フラグ
	MOV	QUEST_GOAL,0		; 冒険のゴール 1=ゴール
	MOV	WHERE_NOW,1		; 場所 1=近郊,2=辺境,3=蛮地

;*;	CALL	WIDCLEN_SET		; WINDOWS/カレンダー・設定処理

	PUSH	IPLMSW			; パレットエフェクト単位時間(VSYNC)
	MOV	IPLMSW,1		; パレットエフェクト単位時間(VSYNC)
	CALL	FEDOUT			; Ｆ・Ｏ（フェードアウト）
	POP	IPLMSW			; パレットエフェクト単位時間(VSYNC)

	MOVE_IMG	ARAVRM,ARA001,0,0,80,400,0,0
	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	MOVE_IMG	ARA001,ARAVRM,0,0,80,400,0,0

	MOV	DX,22			; 22=昼色 パレットのパターン番号
	CALL	PT_PALET_ST		; パレットのセット

	CALL	WIDPROP_OPEN		; WINDOWS/プロポ・ウインドウＯＰＥＮ

;*;	CALL	WIDCLEN_SET		; WINDOWS/カレンダー・時間設定
;*;	CALL	WIDDSP_SV_MN		; WINDOWS/ｍｉｎｉステータス退避

	MOV	AX,WIDMY_GIRL_NO	; 私の娘Ｎｏ．
	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	CALL	MUSYA_MAP_LOAD		; 武者マップ・ロード

	MUSIC	KYOKU_JYOGAI		; 城外

	CALL	R_MS_KUCHIPAKU		; 口パクモード
	PR_LF
	CALL	R_SR_GIRL_NAME		; キャラクタ名
	PR_TXT	"は用意を整えて城壁の外に出た‥‥‥"
	CALL	R_MS_KUCHISTOP		; 口パクモード終り
	RET
QEST_OPEN	ENDP


; ****************************************************
;	冒険の終了
; ****************************************************

QEST_CLOSE	PROC	NEAR
	CALL	WIDFRM_MSA_CLOSE	; WINDOWS/武者修行ﾏｯプﾌﾚｰﾑＣＬＯＳＥ
	CALL	WIDBAR_SOUBI_CLOSE	; WINDOWS/バー・装備ＣＬＯＳＥ
	CALL	WIDBAR_MUSYA_CLOSE	; WINDOWS/バー・武者修行行き先CLOSE
	CALL	R_SENTOU_MS_CLOSE	; 武者修行・ＣＬＯＳＥ

	MOV	DX,CCT_OPEN_TYPE	; オープンタイプ
	CALL	WIDCCT_CLOSE		; WINDOWS/キャラクタクローズ

;*;	CALL	WIDDSP_LD_MN		; WINDOWS/ｍｉｎｉステータス復元
;*NON*;	PUSH	IPLMSW			; パレットエフェクト単位時間(VSYNC)
;*NON*;	MOV	IPLMSW,1		; パレットエフェクト単位時間(VSYNC)
;*NON*;	CALL	FEDOUT			; Ｆ・Ｏ（フェードアウト）
;*NON*;	POP	IPLMSW			; パレットエフェクト単位時間(VSYNC)
;*NON*;	CALL	MAIN_WINDOW_RE_WRITE	; メインウインドウ・再表示
	RET
QEST_CLOSE	ENDP


; ****************************************************
;	冒険！
;	-I-   ALLDAY_COUNTER : 全日数カウンタ（継続日数）
;	-I/O- WHERE_NOW   : 場所 1=近郊,2=辺境,3=蛮地
; ****************************************************

QEST_RUN	PROC	NEAR
;*;	CALL	QEST_WHERE		; 行き先
;*;
;*;	MOV	DX,WHERE_NOW		; 場所 1=近郊,2=辺境,3=蛮地
;*;	CALL	R_MS_MUSYA_SLC		; 武者修行選択台詞

	PR_TXT	"@武者修行"		;
	MOV	DX,ALLDAY_COUNTER	; 全日数カウンタ（継続日数）
	CALL	R_SR_POINT		; ポイント表示
	PR_TXT	"日目"			;

	; ひる冒険！

;*;	MOV	DX,WHERE_NOW		; 場所 1=近郊,2=辺境,3=蛮地
;*;	MOV	CX,1			; いつ 1=昼
;*;	CALL	R_MS_MUSYA_IDO		; 武者修行移動台詞

	CALL	QEST_DAYS		; 昼の冒険

	CMP	QUEST_GOAL,1		; 冒険のゴール 1=ゴール
	JE	QEST_RUN_EXIT		;

	CMP	QUEST_SCCESS,1		; 冒険の成功フラグ 1=成功している
	JNE	QEST_RUN_EXIT		;

	; よる冒険！

	MOV	DX,WHERE_NOW		; 場所 1=近郊,2=辺境,3=蛮地
	MOV	CX,2			; いつ 2=夜
	CALL	R_MS_MUSYA_IDO		; 武者修行移動台詞

	CALL	QEST_NIGHT		; 夜の冒険

QEST_RUN_EXIT:
	RET
QEST_RUN	ENDP


;*;; ****************************************************
;*;;	行き先
;*;;	-I/O- WHERE_NOW : 場所 1=近郊,2=辺境,3=蛮地
;*;; ****************************************************
;*;
;*;QEST_WHERE	PROC	NEAR
;*;	PR_LF				;
;*;	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF	; 私の娘アドレス
;*;	CALL	R_SR_GIRL_NAME		; キャラクタ名
;*;
;*;	CALL	R_MS_KUCHIPAKU		; 口パクモード
;*;	PR_TXT	"｢どこへ行こうかな｣"	;
;*;	CALL	R_MS_KUCHISTOP		; 口パクモード終り
;*;
;*;	SELECT	"近郊,辺境地帯,蛮地"
;*;	CMP	WIDSNM,0		; 近郊
;*;	JE	QEST_WHERE_KINKO	;
;*;	CMP	WIDSNM,1		; 辺境地帯
;*;	JE	QEST_WHERE_HENKYO	;
;*;	CMP	WIDSNM,2		; 蛮地
;*;	JE	QEST_WHERE_BANCH	;
;*;	JMP	QEST_WHERE_EXIT		;
;*;QEST_WHERE_KINKO:
;*;	CMP	WHERE_NOW,1		; 場所 1=近郊
;*;	JE	QEST_WHERE_EXIT		;
;*;	MOV	WHERE_NOW,1		; 場所 1=近郊
;*;	CALL	BG_PUTS			; ＢＧのＰＵＴ
;*;	JMP	QEST_WHERE_EXIT
;*;
;*;QEST_WHERE_HENKYO:
;*;	CMP	WHERE_NOW,2		; 場所 2=辺境
;*;	JE	QEST_WHERE_EXIT		;
;*;	MOV	WHERE_NOW,2		; 場所 2=辺境
;*;	CALL	BG_PUTS			; ＢＧのＰＵＴ
;*;	JMP	QEST_WHERE_EXIT
;*;
;*;QEST_WHERE_BANCH:
;*;	CMP	WHERE_NOW,3		; 場所 2=辺境
;*;	JE	QEST_WHERE_EXIT		;
;*;	MOV	WHERE_NOW,3		; 場所 3=蛮地
;*;	CALL	BG_PUTS			; ＢＧのＰＵＴ
;*;	JMP	QEST_WHERE_EXIT
;*;
;*;QEST_WHERE_EXIT:
;*;	RET
;*;QEST_WHERE	ENDP


; ****************************************************
;	昼の冒険
;	-O- QUEST_SCCESS   : 冒険の成功フラグ 1=成功している,2=やられた
;	    QUEST_GOAL     : 冒険のゴール 1=ゴール
; ****************************************************

QEST_DAYS	PROC	NEAR
	MOV	WHEN_FLAG,1		; いつ 1=昼

	MOV	AX,LOND_DAY		; 昼の長さ
	CALL	TMVST3			; V-SYNC timer3 set.
	MOV	AX,LOND_AJAST		; 移動ウェイト
	CALL	TMVST2			; V-SYNC timer2 set.

;*;	CALL	MOUSE_LCT_SAVE		; マウスロケート退避

	MOV	AX,0			; 1=ＯＮ,0=ＯＦＦ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ
QEST_DAYS_LOOP:
	CALL	TMVCK3			; V-SYNC timer3 check.
	CMP	AX,1			; 0=timer now, 1=timer end.
	JE	QEST_DAYS_SET		;

	CALL	MUSYA_DIRECTION		; 武者マップ・方向
	CMP	DIRFLAG,0		; direction flag. 0=stop,1=moving.
	JE	QEST_DAYS_NEXT		;

	CALL	TMVCK2			; V-SYNC timer2 check.
	CMP	AX,0			; 0=timer now, 1=timer end.
	JE	QEST_DAYS_NEXT		;

	MOV	AX,LOND_AJAST		; 移動ウェイト
	CALL	TMVST2			; V-SYNC timer2 set.

	CALL	MUSYA_MAP_MOVE		; 武者マップ・ムーブ
	CMP	QUEST_GOAL,1		; 冒険のゴール 1=ゴール
	JE	QEST_DAYS_GOAL		;

QEST_DAYS_NEXT:
	JMP	QEST_DAYS_LOOP		;

QEST_DAYS_SET:
	MOV	AX,1			; 1=ＯＮ,0=ＯＦＦ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ

;*;	CALL	MOUSE_LCT_LOAD		; マウスロケート復帰

	CALL	SOUGUU_CHK		; 遭遇か！？

	CALL	BATLE_MODE		; バトルモード
	CMP	QUEST_SCCESS,1		; 冒険の成功フラグ 1=成功している
	JNE	QEST_DAYS_EXIT		;

	MUSIC	KYOKU_JYOGAI		; 城外

QEST_DAYS_EXIT:
	RET
QEST_DAYS_GOAL:
	MOV	AX,1			; 1=ＯＮ,0=ＯＦＦ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ
	RET
QEST_DAYS	ENDP


; ****************************************************
;	夜の冒険
;	-O- QUEST_SCCESS   : 冒険の成功フラグ 1=成功している,2=やられた
;	    QUEST_GOAL     : 冒険のゴール 1=ゴール
; ****************************************************

QEST_NIGHT	PROC	NEAR
	MOV	WHEN_FLAG,2		; いつ 2=夜

	CALL	PALET_EVENING		; 昼－＞夜　パレット

	MOV	AX,LOND_NIGHT		; 夜の長さ
	CALL	TMVST3			; V-SYNC timer3 set.
	MOV	AX,LOND_AJAST		; 移動ウェイト
	CALL	TMVST2			; V-SYNC timer2 set.

;*;	CALL	MOUSE_LCT_SAVE		; マウスロケート退避

	MOV	AX,0			; 1=ＯＮ,0=ＯＦＦ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ
QEST_NIGHT_LOOP:
	CALL	TMVCK3			; V-SYNC timer3 check.
	CMP	AX,1			; 0=timer now, 1=timer end.
	JE	QEST_NIGHT_SET		;

	CALL	MUSYA_DIRECTION		; 武者マップ・方向
	CMP	DIRFLAG,0		; direction flag. 0=stop,1=moving.
	JE	QEST_NIGHT_NEXT		;

	CALL	TMVCK2			; V-SYNC timer2 check.
	CMP	AX,0			; 0=timer now, 1=timer end.
	JE	QEST_NIGHT_NEXT		;

	MOV	AX,LOND_AJAST		; 移動ウェイト
	CALL	TMVST2			; V-SYNC timer2 set.

	CALL	MUSYA_MAP_MOVE		; 武者マップ・ムーブ
	CMP	QUEST_GOAL,1		; 冒険のゴール 1=ゴール
	JE	QEST_NIGHT_GOAL		;

QEST_NIGHT_NEXT:
	JMP	QEST_NIGHT_LOOP		;

QEST_NIGHT_SET:
	MOV	AX,1			; 1=ＯＮ,0=ＯＦＦ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ

;*;	CALL	MOUSE_LCT_LOAD		; マウスロケート復帰

	CALL	SOUGUU_CHK		; 遭遇か！？

	CALL	BATLE_MODE		; バトルモード
	CMP	QUEST_SCCESS,1		; 冒険の成功フラグ 1=成功している
	JNE	QEST_NIGHT_EXIT		;

	MUSIC	KYOKU_JYOGAI		; 城外

	CALL	HYOUKA_UP		; 評価ＵＰ処理

	CALL	PALET_MORNING		; 夜－＞昼　パレット

QEST_NIGHT_EXIT:
	RET
QEST_NIGHT_GOAL:
	MOV	AX,1			; 1=ＯＮ,0=ＯＦＦ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ
	RET
QEST_NIGHT	ENDP


; ****************************************************
;	バトルモード
;	-I- SOUGU_FLAG     : 遭遇フラグ 0=遭遇しない,1=遭遇！！
;	    SOUGU_ENTRY_NO : 遭遇モンスターエントリィ番号
;	    SOUGU_CHAR_NO  : 遭遇モンスターキャラクタ番号
;	-O- QUEST_SCCESS   : 冒険の成功フラグ 1=成功している,2=やられた
; ****************************************************

BATLE_MODE	PROC	NEAR
	MOV	QUEST_SCCESS,1		; 冒険の成功フラグ 1=成功している
	CMP	SOUGU_FLAG,0		; 遭遇フラグ 0=遭遇しない
	JMPEQ	BATLE_MODE_EXIT		;

	CALL	BAD_WIND02_CLOSE	; 病気ステータス無表示ＣＬＯＳＥ
	CALL	WIDDSP_SV_MYST		; WINDOWS/ＭＹステータス退避
	CALL	WIDDSP_SV_YOU		; WINDOWS/ＹＯＵヘッダー退避
	CALL	WIDDSP_SV_YOUST		; WINDOWS/ＹＯＵステータス退避

;*;	MOVE_IMG	ARAVRM,ARA001,1,32,50,336+32,1,32
;*;	CALL	VRMWT1			; ＶＲＡＭ１アクセス
;*;	MOVE_IMG	ARA001,ARAVRM,1,32,50,336+32,1,32
;*;	CALL	VRMWT0			; ＶＲＡＭ０アクセス

	CALL	MOUSE_LCT_LOAD			; マウスロケート復帰

	MOV	AX,WIDMY_GIRL_NO		; キャラクタ番号／私の娘
	MOV	BX,SOUGU_CHAR_NO		; 遭遇モンスターキャラクタ番号
	CALL	R_SENTOU_MS			; 武者修行戦闘！
						; AX : 1=合格,2=不合格
	MOV	QUEST_SCCESS,AX			; 冒険の成功フラグ
						; 1=成功している,2=やられた

	CALL	MOUSE_LCT_SAVE			; マウスロケート退避

	CMP	QUEST_SCCESS,1			; 1=成功している
	JNE	BATLE_MODE_2			;

BATLE_MODE_2:					;

;*;	CALL	VRMWT1				; ＶＲＡＭ１アクセス
;*;	CALL	PT_CHR_BG_MUSYA_PT		; 武者修行ＢＧ－ＰＵＴ
;*;	CALL	WIDCLEN_SET			; WINDOWS/カレンダー・設定処理
;*;	MOVE_IMG	ARAVRM,ARA001,1,32,50,336+32,1,32
;*;	CALL	VRMWT0				; ＶＲＡＭ０アクセス
;*;	MOVE_IMG	ARA001,ARAVRM,48,32,2,336,48,32
;*;	MOVE_IMG	ARA001,ARAVRM,1,32,50,336+32,1,32

	CALL	WIDDSP_LD_MYST			; WINDOWS/ＭＹステータス復元
	CALL	WIDDSP_LD_YOUST			; WINDOWS/ＹＯＵステータス復元
	CALL	WIDDSP_LD_YOU			; WINDOWS/ＹＯＵヘッダー復元
	CALL	BAD_WIND02_OPEN		; 病気ステータス無表示ＯＰＥＮ


	CALL	MUSYA_MAP_REWRITE	; 武者マップ・リライト

BATLE_MODE_EXIT:
	RET
BATLE_MODE	ENDP


; ****************************************************
;	評価ＵＰ処理
;	-I- WHERE_NOW : 場所 1=近郊,2=辺境,3=蛮地
;	＊名声は一日あたり、郊外で１、辺境地帯で２、蛮地で３あがります。
; ****************************************************

HYOUKA_UP	PROC	NEAR

	CMP	WHERE_NOW,1		; 場所 1=近郊
	JNE	HYOUKA_UP_KINKOU	;
	MOV	DX,1			; 加算される評価
	JMP	HYOUKA_UP_SET		;
HYOUKA_UP_KINKOU:			;

	CMP	WHERE_NOW,2		; 場所 2=辺境
	JNE	HYOUKA_UP_HENKYO	;
	MOV	DX,2			; 加算される評価
	JMP	HYOUKA_UP_SET		;
HYOUKA_UP_HENKYO:			;

	CMP	WHERE_NOW,3		; 場所 3=蛮地
	JNE	HYOUKA_UP_BANCHI	;
	MOV	DX,3			; 加算される評価
	JMP	HYOUKA_UP_SET		;
HYOUKA_UP_BANCHI:			;

	JMP	HYOUKA_UP_EXIT		;

HYOUKA_UP_SET:
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,42		; 42=評価処理
	CALL	R_KEISAN		; 各計算処理

HYOUKA_UP_EXIT:
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,74		; 74=武者修行の日次処理
	CALL	R_KEISAN		; 各計算処理
	RET
HYOUKA_UP	ENDP


;*;; ****************************************************
;*;;	ＢＧのＰＵＴ
;*;;	-I- WHERE_NOW : 場所 1=近郊,2=辺境,3=蛮地
;*;; ****************************************************
;*;
;*;BG_PUTS	PROC	NEAR
;*;	CALL	VRMWT1			; ＶＲＡＭ１アクセス
;*;
;*;;*;	MOV	AX,WHERE_NOW		; 場所 1=近郊,2=辺境,3=蛮地
;*;;*;	CALL	PT_CHR_BG_MUSYA_LD	; 武者修行ＢＧ－ロード
;*;;*;	CALL	PT_CHR_BG_MUSYA_PT	; 武者修行ＢＧ－ＰＵＴ
;*;
;*;	CALL	WIDCLEN_SET		; WINDOWS/カレンダー・設定処理
;*;
;*;	MOVE_IMG	ARAVRM,ARA001,1,32,50,336,1,32
;*;	CALL		VRMWT0			; ＶＲＡＭ０アクセス
;*;	OL_IMG		ARA001,ARAVRM,1,32,50,336,1,32
;*;
;*;	RET
;*;BG_PUTS	ENDP


; ****************************************************
;	昼－＞夜　パレット
; ****************************************************

PALET_EVENING	PROC	NEAR
	MOV	DX,22			; 22=昼色 パレットのパターン番号
	MOV	AX,1			; パレットテーブル番号
	CALL	PT_PALET_PLDP		; パレットのテーブルのみセットﾃｰﾌﾞﾙ

	MOV	DX,21			; 21=夜色　パレットのパターン番号
	MOV	AX,0			; パレットテーブル番号
	CALL	PT_PALET_PLDP		; パレットのテーブルのみセットﾃｰﾌﾞﾙ

	MOV	AX,1			; オーバラップ開始パレットテーブル番号
	MOV	BX,0			; オーバラップ終了パレットテーブル番号
	CALL	PLTOLS			; パレット・オーバラップ／時分割初期

	CALL	PLTINTSW		; パレット・割込み処理スイッチ

;*;	MOV	CX,22
;*;PALET_EVENING_LOOP:
;*;	PUSH	CX			;
;*;	MOV	AX,3			; wait timer count.
;*;	CALL	TMVSET			; V-SYNC timer set.
;*;	CALL	PLTOLT			; パレット・オーバラップ／時分割処理
;*;	CALL	TMVEWT			; V-SYNC timer end wait.
;*;	POP	CX
;*;	LOOP	PALET_EVENING_LOOP

	RET
PALET_EVENING	ENDP


; ****************************************************
;	夜－＞昼　パレット
; ****************************************************

PALET_MORNING	PROC	NEAR

	; PALET_EVENING（昼－＞夜　パレット）の逆

	MOV	DX,22			; 22=昼色 パレットのパターン番号
	MOV	AX,0			; パレットテーブル番号
	CALL	PT_PALET_PLDP		; パレットのテーブルのみセットﾃｰﾌﾞﾙ

	MOV	DX,21			; 21=夜色　パレットのパターン番号
	MOV	AX,1			; パレットテーブル番号
	CALL	PT_PALET_PLDP		; パレットのテーブルのみセットﾃｰﾌﾞﾙ

	MOV	AX,1			; オーバラップ開始パレットテーブル番号
	MOV	BX,0			; オーバラップ終了パレットテーブル番号
	CALL	PLTOLS			; パレット・オーバラップ／時分割初期

	CALL	PLTINTSW		; パレット・割込み処理スイッチ

;*;	MOV	CX,22
;*;PALET_MORNING_LOOP:
;*;	PUSH	CX			;
;*;	MOV	AX,3			; wait timer count.
;*;	CALL	TMVSET			; V-SYNC timer set.
;*;	CALL	PLTOLT			; パレット・オーバラップ／時分割処理
;*;	CALL	TMVEWT			; V-SYNC timer end wait.
;*;	POP	CX
;*;	LOOP	PALET_MORNING_LOOP

	RET
PALET_MORNING	ENDP


; ****************************************************
;	"経験値を得た。"
;	-I- ALLDAY_COUNTER : 全日数カウンタ（継続日数）
; ****************************************************

KEIKEN_PRINT	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	DX,0				; 加算される経験値
	MOV	S_FUNC,63			; 63=経験値の処理
	CALL	R_KEISAN			; 各計算処理
	MOV	KEIKENCHI_NOW,CX		; 現在経験値

	MOV	DX,KEIKENCHI_NOW		; 現在経験値
	CMP	DX,KEIKENCHI_OLD		; 旧経験値
	JE	KEIKEN_PRINT_EXIT		;

	CALL	R_MS_KUCHIPAKU			; 口パクモード
	PR_LF
	MOV	DX,ALLDAY_COUNTER		; 全日数カウンタ（継続日数）
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"日間の冒険で、合計"

	MOV	DX,KEIKENCHI_NOW		; 現在経験値
	SUB	DX,KEIKENCHI_OLD		; 旧経験値
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"の経験値を得た。"
	CALL	R_MS_KUCHISTOP			; 口パクモード終り

KEIKEN_PRINT_EXIT:
	RET
KEIKEN_PRINT	ENDP


; ****************************************************
;	遭遇か！？
;	-I- WHERE_NOW      : 場所 1=近郊,2=辺境,3=蛮地
;	    WHEN_FLAG      : いつ 1=昼,2=夜
;	-O- SOUGU_FLAG     : 遭遇フラグ 0=遭遇しない,1=遭遇！！
;	    SOUGU_ENTRY_NO : 遭遇モンスターエントリィ番号
;	    SOUGU_CHAR_NO  : 遭遇モンスターキャラクタ番号
; ****************************************************

SOUGUU_CHK	PROC	NEAR
;*DBG*;	PRV	"場所 WHERE_NOW=",WHERE_NOW
;*DBG*;	PRV	"いつ WHEN_FLAG=",WHEN_FLAG

	MOV	SOUGU_FLAG,0		; 遭遇フラグ
	MOV	SOUGU_ENTRY_NO,0	; 遭遇モンスターエントリィ番号
	MOV	SOUGU_CHAR_NO,0		; 遭遇モンスターキャラクタ番号

	CMP	DEBUG_MONSTER_SKIP,0	; デバック用モンスタースキップ
	JE	SOUGUU_CHK_2		;
	RET				;
SOUGUU_CHK_2:				;

	CMP	FLAG_ANZEN,1		; 安全地帯フラグ 1=安全地帯
	JE	SOUGUU_CHK_NONE		;

	MOV	BX,WHERE_NOW		; 場所 1=近郊,2=辺境,3=蛮地
	DEC	BX			;
	SHL	BX,1			; 2 byte pointer.
	ADD	BX,WHEN_FLAG		; いつ 1=昼,2=夜
	DEC	BX			;
	MOVXBW	SOUGU_PAR,DS:SOUGU_PAR_TBL[BX]	; 遭遇確率

;*DBG*;	PRV	"遭遇確率=",SOUGU_PAR

	MOV	CX,100			; 範囲（２００以内）
	CALL	RANDAM_CX		; 乱数範囲指定
	CMP	AX,SOUGU_PAR		; 遭遇確率
	JL	SOUGUU_CHK_SHOCK	;
	JMP	SOUGUU_CHK_NONE		;

SOUGUU_CHK_SHOCK:			;
	MOV	BX,WHERE_NOW		; 場所 1=近郊,2=辺境,3=蛮地
	DEC	BX			;
	SHL	BX,1			; 2byte step
	MOV	DX,WHEN_FLAG		; いつ 1=昼,2=夜
	DEC	DX			;
	ADD	BX,DX			;
	SHL	BX,1			; word pointer.
	MOV	SI,DS:SOUGU_CHR_TBL[BX]	; 遭遇モンスタテーブル
	MOV	SOUGU_CHR_ADRS,SI	; 遭遇モンスタアドレス
	MOVXBW	SOUGU_CHAR_MAX,DS:[SI]	; 遭遇モンスターキャラクタ数

	MOV	CX,SOUGU_CHAR_MAX	; 遭遇モンスターキャラクタ数
	CALL	RANDAM_CX		; 乱数範囲指定
	MOV	BX,AX			; １からＣＸの数字

	MOV	SI,SOUGU_CHR_ADRS	; 遭遇モンスタアドレス
	MOVXBW	SOUGU_ENTRY_NO,DS:[SI][BX] ; 遭遇モンスターエントリィ番号

;*DBG*;	PRV	"遭遇モンスターエントリィ番号=",SOUGU_ENTRY_NO

	MOV	BX,SOUGU_ENTRY_NO	; 遭遇モンスターエントリィ番号
	MOVXBW	DX,DS:WID_MONSTER_TBL[BX] ; (byte)モンスターテーブル
	MOV	SOUGU_CHAR_NO,DX	; 遭遇モンスターキャラクタ番号

;*DBG*;	PRV	"遭遇モンスターキャラクタ番号=",SOUGU_CHAR_NO

SOUGUU_CHK_EXIT:
	MOV	SOUGU_FLAG,1		; 遭遇フラグ 1=遭遇！！
	RET
SOUGUU_CHK_NONE:
	MOV	SOUGU_FLAG,0		; 遭遇フラグ 0=遭遇しない
	RET
SOUGUU_CHK	ENDP


; ****************************************************
;	日付更新
; ****************************************************

TIME_UPDATE	PROC	NEAR
	CALL	WIDCLEN_UDATE_ONLY	; WINDOWS/カレンダー・更新のみ処理
;*;	CALL	WIDCLEN_UDATE		; WINDOWS/カレンダー・更新処理
	RET
TIME_UPDATE	ENDP


; ****************************************************
;	一周ごほうび
;	-I- AX : 1=ほうびアリ,2=ほうび無し
; ****************************************************

GHOUBI_INI	PROC	NEAR
	MOV	KAIFUKU_FLAG,AX		; 疲労回復フラグ
	MOV	KAIFUKU_DAYCT,0		; 疲労回復日数
	MOV	KAIFUKU_POINT,0		; 疲労回復ポイント
	CMP	AX,1			; 1=ほうびアリ
	JNE	GHOUBI_INI_NASHI	;
	MOV	KAIFUKU_P_DAY,10	; 疲労回復ポイント／日
	RET
GHOUBI_INI_NASHI:
	MOV	KAIFUKU_P_DAY,0		; 疲労回復ポイント／日
	RET
GHOUBI_INI	ENDP


; ****************************************************
;	一周ごほうび／日
; ****************************************************

GHOUBI_DAYS	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	DX,KAIFUKU_P_DAY		; 疲労回復ポイント／日
	ADD	KAIFUKU_POINT,DX		; 疲労回復ポイント
	MOV	S_FUNC,71			; 71=とにかく疲労回復
	CALL	R_KEISAN			; 各計算処理
	INC	KAIFUKU_DAYCT			; 疲労回復日数
	RET
GHOUBI_DAYS	ENDP


; ****************************************************
;	一周ごほうび／日
; ****************************************************

GHOUBI_END	PROC	NEAR
	CMP	KAIFUKU_POINT,0			; 疲労回復ポイント
	JE	GHOUBI_END_EXIT			;

	MOV	AX,WIDMY_GIRL_OF		; 私の娘アドレス
	MOV	DX,50				; 加算される評価
	MOV	S_FUNC,42			; 42=評価処理
	CALL	R_KEISAN			; 各計算処理

	CALL	R_MS_KUCHIPAKU			; 口パクモード
	PR_TXT	"@評価が"
	MOV	DX,50				; 疲労回復日数
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"ＵＰした。@残り"
	MOV	DX,KAIFUKU_DAYCT		; 疲労回復日数
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"日間で、"
	MOV	DX,KAIFUKU_POINT		; 疲労回復ポイント
	CALL	R_SR_POINT			; ポイント表示
	PR_TXT	"の疲労を回復した。"
	CALL	R_MS_KUCHISTOP			; 口パクモード終り

	CALL	R_SR_YOIDESUKA		; よいですか

GHOUBI_END_EXIT:
	RET
GHOUBI_END	ENDP


; ****************************************************
;	武者マップ
; ****************************************************

; ****************************************************
;	武者マップ・ロード
; ****************************************************

MUSYA_MAP_LOAD	PROC	NEAR
	CALL	R_LOAD_MUSYA_LOAD	; 武者プロセスの起動

	MOV	BH,1			; 1=init
	CALL	R_LOAD_MUSYA_CALL	; 武者プロセスの呼出し

	MOV	MUSDRX,0		; mouse locate direction x(+-)
	MOV	MUSDRY,0		; mouse locate direction y(+-)
	MOV	KYDRX,0			; key locate direction x(+-)
	MOV	KYDRY,0			; key locate direction y(+-)
	MOV	DIRXX,0			; direction x.(-1,0,+1)
	MOV	DIRYY,0			; direction y.(-1,0,+1)
	MOV	DIRFLAG,0		; direction flag. 0=stop,1=moving.

	RET
MUSYA_MAP_LOAD	ENDP


; ****************************************************
;	武者マップ・ムーブ
;	-I- DIRXX : direction x.(-1,0,+1)
;	    DIRYY : direction y.(-1,0,+1)
;	-O- WHERE_NOW  : 場所 1=近郊,2=辺境,3=蛮地
;	    FLAG_ANZEN : 安全地帯フラグ 1=安全地帯
;	    QUEST_GOAL : 冒険のゴール 1=ゴール
;	    FLAG_IVENT : イベント 1=立て札,2=宝箱
; ****************************************************

MUSYA_MAP_MOVE	PROC	NEAR
	MOV	FLAG_ANZEN,0		; 安全地帯フラグ
	MOV	FLAG_IVENT,0		; イベント 1=立て札,2=宝箱
	MOV	QUEST_GOAL,0		; 冒険のゴール 1=ゴール

	MOV	BL,0			;
	MOV	BH,2			; 2=move
	MOV	CX,DIRXX		; direction x.(-1,0,+1)
	MOV	DX,DIRYY		; direction y.(-1,0,+1)
	CALL	R_LOAD_MUSYA_CALL	; 武者プロセスの呼出し
	CMP	BH,4			; 4=安全地帯
	JE	MUSYA_MAP_MOVE_ANZENCHITAI
	CMP	BH,5			; 5=ゴール
	JE	MUSYA_MAP_MOVE_GOAL	;
	CMP	BH,6			; 6=立て札
	JE	MUSYA_MAP_MOVE_KANBAN	;
	CMP	BH,7			; 7=宝箱
	JE	MUSYA_MAP_MOVE_TAKARA	;
MUSYA_MAP_MOVE_NORMAL:
	MOV	BYTE PTR WHERE_NOW,BH	; 場所 1=近郊,2=辺境,3=蛮地
	MOV	DX,WHERE_NOW		; 場所 1=近郊,2=辺境,3=蛮地
	CALL	WIDBAR_MUSYA		; WINDOWS/バー・武者修行行き先PUT
	RET
MUSYA_MAP_MOVE_ANZENCHITAI:
;*;	MOV	FLAG_ANZEN,1		; 安全地帯フラグ 1=安全地帯
	RET
MUSYA_MAP_MOVE_GOAL:
	MOV	QUEST_GOAL,1		; 冒険のゴール 1=ゴール
	RET
MUSYA_MAP_MOVE_KANBAN:
	CALL	MUSYA_KANBAN		; 武者修行・看板
	MOV	FLAG_IVENT,1		; イベント 1=立て札
	RET
MUSYA_MAP_MOVE_TAKARA:
	CALL	MUSYA_TAKARA		; 武者修行・宝箱
	MOV	FLAG_IVENT,2		; イベント 2=宝箱
	RET
MUSYA_MAP_MOVE	ENDP


; ****************************************************
;	武者修行・看板
; ****************************************************

MUSYA_KANBAN	PROC	NEAR
	PUSH	BX			;
	MOV	AX,1			; 1=ＯＮ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ
	CALL	MOUSE_LCT_LOAD		; マウスロケート復帰
	POP	BX			;
	MOV	DL,BL			; 立て札番号
	MOV	DH,0			;
	CALL	R_MAPWID		; マップ用メッセージウインドウ
	CALL	MUSYA_MAP_REWRITE	; 武者マップ・リライト

	MOV	AX,0			; 0=ＯＦＦ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ
	CALL	MOUSE_LCT_SAVE		; マウスロケート退避
	RET
MUSYA_KANBAN	ENDP


; ****************************************************
;	武者修行・宝箱
; ****************************************************

MUSYA_TAKARA	PROC	NEAR
	PUSH	BX			;

	MOV	BL,0			;
	MOV	BH,4			; 4="takara"open
	CALL	R_LOAD_MUSYA_CALL	; 武者プロセスの呼出し

	MOV	AX,1			; 1=ＯＮ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ

	CALL	MOUSE_LCT_LOAD		; マウスロケート復帰

	POP	BX			;
	MOV	DL,BL			; 宝箱番号
	MOV	DH,0			;
	CALL	R_MAPITM		; マップ用アイテムウインドウ
	CMP	AX,1			; 1=いっぱいで持てない
	JNE	MUSYA_TAKARA_5		;

	MOV	BL,0			;
	MOV	BH,5			; 5="takara"close
	CALL	R_LOAD_MUSYA_CALL	; 武者プロセスの呼出し
MUSYA_TAKARA_5:

	CALL	MUSYA_MAP_REWRITE	; 武者マップ・リライト

	MOV	AX,0			; 0=ＯＦＦ
	CALL	KEYHLT			; キーボード機能のＯＮ／ＯＦＦ
	CALL	MOUSE_LCT_SAVE		; マウスロケート退避
	RET
MUSYA_TAKARA	ENDP


; ****************************************************
;	武者マップ・リライト
; ****************************************************

MUSYA_MAP_REWRITE	PROC	NEAR
	MOV	BL,0			;
	MOV	BH,3			; 3=rewrite
	CALL	R_LOAD_MUSYA_CALL	; 武者プロセスの呼出し
	RET
MUSYA_MAP_REWRITE	ENDP



; ****************************************************
;	武者マップ・方向
;	-O- DIRXX   : direction x.(-1,0,+1)
;	    DIRYY   : direction y.(-1,0,+1)
;	    DIRFLAG : direction flag. 0=stop,1=moving.
; ****************************************************

MUSYA_DIRECTION	PROC	NEAR
	CMP	DEBUG_RANDUM_DIR,22	; デバック用ランダム移動モード
	JMPNE	MUSYA_DIRECTION_00	;

	MOV	AX,2			; 移動ウェイト
	CALL	TMVST2			; V-SYNC timer2 set.
MUSYA_DIRECTION_00WT:			;
	CALL	TMVCK2			; V-SYNC timer2 check.
	CMP	AX,0			; 0=timer now, 1=timer end.
	JE	MUSYA_DIRECTION_00WT	;

	INC	DEBUG_RANDUM_CNT	; デバック用ランダム移動カウンタ
	CMP	DEBUG_RANDUM_CNT,20	; デバック用ランダム移動カウンタ
	JNB	MUSYA_DIRECTION_0000	;

	JMP	MUSYA_DIRECTION_MOVING	;

MUSYA_DIRECTION_0000:
	MOV	DEBUG_RANDUM_CNT,0	; デバック用ランダム移動カウンタ

	MOV	CX,2			; 範囲（２００以内）
	CALL	RANDAM_CX		; 乱数範囲指定
	CMP	AX,2
	JE	MUSYA_DIRECTION_00YY
MUSYA_DIRECTION_00XX:
	MOV	CX,2			; 範囲（２００以内）
	CALL	RANDAM_CX		; 乱数範囲指定
	SHL	AX,1			; * 2  =>  2 or 4
	SUB	AX,3			; 2 or 4 -> -1 or 1
	MOV	DIRXX,AX		; direction x.(-1,0,+1)
	MOV	DIRYY,0			; direction y.(-1,0,+1)
	JMP	MUSYA_DIRECTION_MOVING	;

MUSYA_DIRECTION_00YY:
	MOV	CX,2			; 範囲（２００以内）
	CALL	RANDAM_CX		; 乱数範囲指定
	SHL	AX,1			; * 2  =>  2 or 4
	SUB	AX,3			; 2 or 4 -> -1 or 1
	MOV	DIRXX,0			; direction x.(-1,0,+1)
	MOV	DIRYY,AX		; direction y.(-1,0,+1)
	JMP	MUSYA_DIRECTION_MOVING	;

MUSYA_DIRECTION_00:

	MOV	AX,MUSDRX		; mouse locate direction x(+-)
	MOV	BX,MUSDRY		; mouse locate direction y(+-)

	MOV	DX,KYDRX		; key locate direction x(+-)
	OR	DX,KYDRY		; key locate direction y(+-)
	JZ	MUSYA_DIRECTION_1	;
	MOV	MUSDRX,0		; mouse locate direction x(+-)
	MOV	MUSDRY,0		; mouse locate direction y(+-)
	MOV	AX,KYDRX		; key locate direction x(+-)
	MOV	BX,KYDRY		; key locate direction y(+-)
MUSYA_DIRECTION_1:
	MOV	DIRXX,AX		; direction x.(-1,0,+1)
	MOV	DIRYY,BX		; direction y.(-1,0,+1)

	CMP	DIRXX,-1		; direction x.(-1,0,+1)
	JGE	MUSYA_DIREC_51		;
	MOV	DIRXX,-1		; direction x.(-1,0,+1)
MUSYA_DIREC_51:				;
	CMP	DIRXX,+1		; direction x.(-1,0,+1)
	JLE	MUSYA_DIREC_52		;
	MOV	DIRXX,+1		; direction x.(-1,0,+1)
MUSYA_DIREC_52:				;

	CMP	DIRYY,-1		; direction y.(-1,0,+1)
	JGE	MUSYA_DIREC_53		;
	MOV	DIRYY,-1		; direction y.(-1,0,+1)
MUSYA_DIREC_53:				;
	CMP	DIRYY,+1		; direction y.(-1,0,+1)
	JLE	MUSYA_DIREC_54		;
	MOV	DIRYY,+1		; direction y.(-1,0,+1)
MUSYA_DIREC_54:				;


	CALL	MUSRED			; マウス読み込み
	MOV	BYTE PTR MOUSE_BTN_L,DH	; mouse bottan left.
	MOV	BYTE PTR MOUSE_BTN_R,DL	; mouse bottan right.
	MOV	MOUSE_X,AX		; mouse x.
	MOV	MOUSE_Y,BX		; mouse y.

	CMP	MOUSE_BTN_L,0		; 左ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	MUSYA_DIRECTION_STOP	;
	CMP	MOUSE_BTN_R,0		; 右ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	MUSYA_DIRECTION_STOP	;

	JMP	MUSYA_DIRECTION_MOVING	;
MUSYA_DIRECTION_STOP:
	MOV	MUSDRX,0		; mouse locate direction x(+-)
	MOV	MUSDRY,0		; mouse locate direction y(+-)
	MOV	DIRXX,0			; direction x.(-1,0,+1)
	MOV	DIRYY,0			; direction y.(-1,0,+1)
	MOV	DIRFLAG,0		; direction flag. 0=stop.
	RET
MUSYA_DIRECTION_MOVING:
	MOV	DIRFLAG,1		; direction flag. 1=moving.
	RET
MUSYA_DIRECTION_EXIT:
	RET
MUSYA_DIRECTION	ENDP


; ****************************************************
;	マウスロケート退避
; ****************************************************

MOUSE_LCT_SAVE	PROC	NEAR
	CALL	MUSRED			; マウス読み込み
	MOV	MOUSE_SAVE_P_X,AX	; mouse save x.
	MOV	MOUSE_SAVE_P_Y,BX	; mouse save y.
	CALL	MUSDSP			; マウスＤＩＲのクリア
	RET
MOUSE_LCT_SAVE	ENDP


; ****************************************************
;	マウスロケート復帰
; ****************************************************

MOUSE_LCT_LOAD	PROC	NEAR
	MOV	AX,MOUSE_SAVE_P_X	; mouse save x.
	MOV	BX,MOUSE_SAVE_P_Y	; mouse save y.
	CALL	MUSSET			; マウス座標セット
	RET
MOUSE_LCT_LOAD	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	DEBUG_MONSTER_SKIP	; (R_MUSYA.ASM)デバック用モンスタースキップ
PUBLIC	DEBUG_RANDUM_DIR	; (R_MUSYA.ASM)デバック用ランダム移動モード=22

EXTRN	MUSDRX:WORD		; mouse locate direction x(+-)
EXTRN	MUSDRY:WORD		; mouse locate direction y(+-)
EXTRN	KYDRX:WORD		; key locate direction x(+-)
EXTRN	KYDRY:WORD		; key locate direction y(+-)

EXTRN	WIDSNM:WORD		; ユーザ選択番号

EXTRN	MY_GIRL_BORTH_F:WORD	; 誕生日フラグ 1=ｂｏｒｔｈｄａｙ(R_SEICHO.ASM)

EXTRN	R_KOUMKU:WORD		; 項目
EXTRN	R_NAISTR:WORD		; 内容文字列
EXTRN	R_NAIYOU:WORD		; 内容値
EXTRN	R_NYUKIN:WORD		; 入金
EXTRN	R_SYUTSU:WORD		; 出金
EXTRN	R_NISSU:WORD		; 日数

EXTRN	KETTEI:WORD		; 決定フラグ

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

EXTRN	IPLMSW:WORD		; パレットエフェクト単位時間(VSYNC)

DIRFLAG		DW	0	; direction flag. 0=stop,1=moving.
DIRMODE		DW	0	; direction mode.
DIRXX		DW	0	; direction x.(-1,0,+1)
DIRYY		DW	0	; direction y.(-1,0,+1)

DEBUG_MONSTER_SKIP DW	0	; (R_MUSYA.ASM)デバック用モンスタースキップ
DEBUG_RANDUM_DIR DW	0	; (R_MUSYA.ASM)デバック用ランダム移動モード=22
DEBUG_RANDUM_CNT DW	0	; (R_MUSYA.ASM)デバック用ランダム移動カウンタ

LOND_DAY	DW	60*7	; 昼の長さ
LOND_NIGHT	DW	60*7	; 夜の長さ
LOND_AJAST	DW	8;12	; 移動ウェイト

MOUSE_X		DW	0		; mouse x.
MOUSE_Y		DW	0		; mouse y.
MOUSE_BTN_L	DW	0		; mouse bottan left.
MOUSE_BTN_R	DW	0		; mouse bottan right.

MOUSE_SAVE_P_X	DW	0		; mouse save x.
MOUSE_SAVE_P_Y	DW	0		; mouse save y.

KEIKENCHI_OLD	DW	0	; 旧経験値
KEIKENCHI_NOW	DW	0	; 現在経験値

KAIFUKU_FLAG	DW	0	; 疲労回復フラグ
KAIFUKU_DAYCT	DW	0	; 疲労回復日数
KAIFUKU_P_DAY	DW	0	; 疲労回復ポイント／日
KAIFUKU_POINT	DW	0	; 疲労回復ポイント

DAY_COUNTER	DW	0	; 日数カウンタ
ALLDAY_COUNTER	DW	0	; 全日数カウンタ（継続日数）

QUEST_BORTH_F	DW	0	; 冒険中誕生日フラグ 1=冒険中に誕生日があった
QUEST_SCCESS	DW	0	; 冒険の成功フラグ 1=成功している,2=やられた
QUEST_GOAL	DW	0	; 冒険のゴール 1=ゴール

FLAG_IVENT	DW	0	; イベント 1=立て札,2=宝箱
FLAG_ANZEN	DW	1	; 安全地帯フラグ 1=安全地帯
WHERE_NOW	DW	1	; 場所 1=近郊,2=辺境,3=蛮地
WHEN_FLAG	DW	1	; いつ 1=昼,2=夜
SOUGU_FLAG	DW	0	; 遭遇フラグ 0=遭遇しない,1=遭遇！！
SOUGU_PAR	DW	0	; 遭遇確率
SOUGU_ENTRY_NO	DW	0	; 遭遇モンスターエントリィ番号
SOUGU_CHAR_NO	DW	0	; 遭遇モンスターキャラクタ番号
SOUGU_CHAR_MAX	DW	0	; 遭遇モンスターキャラクタ数

SOUGU_PAR_TBL	LABEL	BYTE		; 遭遇確率
		DB	40,60  ;20,30	;  近郊・昼／夜
		DB	80,90  ;40,50	;  辺境・昼／夜
		DB	80,100 ;60,80	;  蛮地・昼／夜

SOUGU_CHR_ADRS	DW	0		; 遭遇モンスタアドレス
SOUGU_CHR_TBL	LABEL	WORD		; 遭遇モンスタテーブル
		DW	OFFSET S_KINKOU_DAY_TBL		; 近郊・昼
		DW	OFFSET S_KINKOU_NIGHT_TBL	; 近郊・夜
		DW	OFFSET S_HENKYO_DAY_TBL		; 辺境・昼
		DW	OFFSET S_HENKYO_NIGHT_TBL	; 辺境・夜
		DW	OFFSET S_BANCHI_DAY_TBL		; 蛮地・昼
		DW	OFFSET S_BANCHI_NIGHT_TBL	; 蛮地・夜

S_KINKOU_DAY_TBL	LABEL	BYTE	; 遭遇モンスタ 近郊・昼
		DB	4		; max.
		DB	1,3,4,6
S_KINKOU_NIGHT_TBL	LABEL	BYTE	; 遭遇モンスタ 近郊・夜
		DB	5		; max.
		DB	1,3,4,5,6
S_HENKYO_DAY_TBL	LABEL	BYTE	; 遭遇モンスタ 辺境・昼
		DB	7		; max.
		DB	1,2,3,4,5,6,9
S_HENKYO_NIGHT_TBL	LABEL	BYTE	; 遭遇モンスタ 辺境・夜
		DB	8		; max.
		DB	1,2,3,4,5,6,7,9
S_BANCHI_DAY_TBL	LABEL	BYTE	; 遭遇モンスタ 蛮地・昼
		DB	8		; max.
		DB	2,3,5,6,7,8,9,10
S_BANCHI_NIGHT_TBL	LABEL	BYTE	; 遭遇モンスタ 蛮地・夜
		DB	8		; max.
		DB	2,3,5,6,7,8,9,10

DATA	ENDS

;*;MUSYA_DIRECTION_SET:
;*;	CMPX	MOUSE_X,MOUSE_BASE_X	; mouse x.
;*;	JL	MUSYA_DIREC_X_LOW	;
;*;	JG	MUSYA_DIREC_X_HI	;
;*;	JMP	MUSYA_DIREC_X_E		;
;*;MUSYA_DIREC_X_LOW:			;
;*;	DEC	DIRXX			; direction x.(-1,0,+1)
;*;	JMP	MUSYA_DIREC_X_E		;
;*;MUSYA_DIREC_X_HI:			;
;*;	INC	DIRXX			; direction x.(-1,0,+1)
;*;	JMP	MUSYA_DIREC_X_E		;
;*;MUSYA_DIREC_X_E:			;
;*;
;*;	CMPX	MOUSE_Y,MOUSE_BASE_Y	; mouse y.
;*;	JL	MUSYA_DIREC_Y_LOW	;
;*;	JG	MUSYA_DIREC_Y_HI	;
;*;	JMP	MUSYA_DIREC_Y_E		;
;*;MUSYA_DIREC_Y_LOW:			;
;*;	DEC	DIRYY			; direction y.(-1,0,+1)
;*;	JMP	MUSYA_DIREC_Y_E		;
;*;MUSYA_DIREC_Y_HI:			;
;*;	INC	DIRYY			; direction y.(-1,0,+1)
;*;	JMP	MUSYA_DIREC_Y_E		;
;*;MUSYA_DIREC_Y_E:			;
;*;
;*;	CMP	DIRXX,-1		; direction x.(-1,0,+1)
;*;	JGE	MUSYA_DIREC_51		;
;*;	MOV	DIRXX,-1		; direction x.(-1,0,+1)
;*;MUSYA_DIREC_51:				;
;*;	CMP	DIRXX,+1		; direction x.(-1,0,+1)
;*;	JLE	MUSYA_DIREC_52		;
;*;	MOV	DIRXX,+1		; direction x.(-1,0,+1)
;*;MUSYA_DIREC_52:				;
;*;
;*;	CMP	DIRYY,-1		; direction y.(-1,0,+1)
;*;	JGE	MUSYA_DIREC_53		;
;*;	MOV	DIRYY,-1		; direction y.(-1,0,+1)
;*;MUSYA_DIREC_53:				;
;*;	CMP	DIRYY,+1		; direction y.(-1,0,+1)
;*;	JLE	MUSYA_DIREC_54		;
;*;	MOV	DIRYY,+1		; direction y.(-1,0,+1)
;*;MUSYA_DIREC_54:				;
;*;
;*;	MOVX	MOUSE_BASE_X,MOUSE_X	; mouse x.
;*;	MOVX	MOUSE_BASE_Y,MOUSE_Y	; mouse y.
;*;
;*;	CMP	MOUSE_BTN_L,0		; 左ボタン（1：ＯＦＦ／0：ＯＮ）
;*;	JE	MUSYA_DIRECTION_STOP	;
;*;	CMP	MOUSE_BTN_R,0		; 右ボタン（1：ＯＦＦ／0：ＯＮ）
;*;	JE	MUSYA_DIRECTION_STOP	;
;*;
;*;	JMP	MUSYA_DIRECTION_MOVING	;
;*;
;*;MUSYA_DIRECTION_TOLG:
;*;	CMP	DIRFLAG,1		; direction flag. 1=moving.
;*;	JE	MUSYA_DIRECTION_STOP	;
;*;	JMP	MUSYA_DIRECTION_MOVING	;
;*;
;*;MUSYA_DIRECTION_STOP:
;*;	MOV	AX,MOUSE_BASE_X		; mouse base x.
;*;	MOV	BX,MOUSE_BASE_Y		; mouse base y.
;*;	CALL	MUSSET			; マウス座標セット

	END
;
;	end of "R_MUSYA.ASM"
;
