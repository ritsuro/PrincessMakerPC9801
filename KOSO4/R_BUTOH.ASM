; "R_BUTOH.ASM" PC-9801UV11 make by R.H 1991/01/08
;
;
;	「子育て」
;
;	武闘会
;
;
; (C) 1991 ritsurou hashimoto.


INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC
INCLUDE	..\KOSO6\KYOKU.INC

FUKI_WID_NUM	EQU	8	; 表彰式ふきだし番号

TITLE_CENTER_X	EQU	25		; タイトルＸ座標
TITLE_CENTER_Y	EQU	176-12		; タイトルＹ座標

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

LOOPX	MACRO	LBL
	LOCAL	L1,L2
	LOOP	L1
	JMP	L2
L1:
	JMP	LBL
L2:
	ENDM

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	R_BUTOH			; 武闘会
PUBLIC	R_BUTO_S		; そのころ武闘会では

EXTRN	R_OHSAMA_OHOME_BT:NEAR	; 王様の御誉め・武闘会編

EXTRN	R_SENTOU_BU_LOAD:NEAR	; 武闘会戦闘・先行ロード
EXTRN	R_SENTOU_BU_OPEN:NEAR	; 武闘会戦闘・ＯＰＥＮ
EXTRN	R_SENTOU_BU:NEAR	; 武闘会戦闘！
EXTRN	R_SENTOU_BU_CLOSE:NEAR	; 武闘会戦闘・ＣＬＯＳＥ

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	R_SR_GIRL_FULNAMGET:NEAR ; キャラクタ名+姓ＧＥＴ

EXTRN	PT_FREAM_BT_HYO:NEAR	; 武闘会対戦表フレーム
EXTRN	PT_PALET_ST:NEAR	; パレットのセット

EXTRN	RANDAM_100:NEAR		; 乱数１００

EXTRN	WIDALLOC_BUTOKAI:NEAR	; WINDOWS/キャラクタ・武闘会選出
EXTRN	WIDALLOC_TSUIKA:NEAR	; WINDOWS/キャラクタ・メンバ表へ追加

EXTRN	WIDALLOC_CHRADRS:NEAR	; WINDOWS/キャラクタ・ヘッダアドレス

EXTRN	WIDTOUR_INIT:NEAR	; WINDOWS/トーナメント初期処理
EXTRN	WIDTOUR_ENTRY:NEAR	; WINDOWS/トーナメント全エントリィ登録
EXTRN	WIDTOUR_NAME:NEAR	; WINDOWS/トーナメント全エントリィ名前
EXTRN	WIDTOUR_LINK:NEAR	; WINDOWS/トーナメント全組み合せ表示
EXTRN	WIDTOUR_KICKOFF:NEAR	; WINDOWS/トーナメント試合・キックオフ
EXTRN	WIDTOUR_1GET:NEAR	; WINDOWS/トーナメント試合・組み合せ
EXTRN	WIDTOUR_1SHOCK:NEAR	; WINDOWS/トーナメント試合・衝撃！
EXTRN	WIDTOUR_1END:NEAR	; WINDOWS/トーナメント試合・勝敗
EXTRN	WIDTOUR_OFFSIDE:NEAR	; WINDOWS/トーナメント試合・オフサイド

EXTRN	WIDFUKI:NEAR		; WINDOWS/ふきだしウインドウ
EXTRN	WIDFUKI_OPEN:NEAR	; WINDOWS/ふきだしウインドウＯＰＥＮ
EXTRN	WIDFUKI_CLOSE:NEAR	; WINDOWS/ふきだしウインドウＣＬＯＳＥ

EXTRN	WIDALLOC_TEKICHR:NEAR	; WINDOWS/敵キャラクタ・データ結合

EXTRN	PT_SYUKAK_LD:NEAR	; 収穫祭パターンロード
EXTRN	PT_SYUKAK_PUT:NEAR	; 収穫祭パターンＰＵＴ
EXTRN	PT_SYUKAK_MPT:NEAR	; 収穫祭マスクパターンＰＵＴ

EXTRN	VRMDP0:NEAR		; ＶＲＡＭ０表示
EXTRN	VRMDP1:NEAR		; ＶＲＡＭ１表示
EXTRN	VRMWT0:NEAR		; ＶＲＡＭ０アクセス
EXTRN	VRMWT1:NEAR		; ＶＲＡＭ１アクセス

EXTRN	STRFILL:NEAR		; 文字列バッファＦＩＬＬ

; ****************************************************
;	武闘会
; ****************************************************

R_BUTOH	PROC	NEAR
	CALL	OPEN_BUTOHKAI		; 武闘会・ＯＰＥＮ

	CALL	MEMBER_SELECT		; メンバ選出

	MOV	TAG_MUSUME_OUT,0	; 0=娘頑張っている
	CALL	TOURNAMENT		; トーナメント

	SELECT	"戦いはおわった"

	CALL	HYOUSHOU_SHIKI		; 表彰式

	SELECT	"武闘会は終わった"	;

	MOV	DX,FUKI_WID_NUM		; 表彰式ふきだし番号
	CALL	WIDFUKI_CLOSE		; WINDOWS/ふきだしウインドウＣＬＯＳＥ

	CALL	CLOSE_BUTOHKAI		; 武闘会・ＣＬＯＳＥ

	RET
R_BUTOH	ENDP


; ****************************************************
;	そのころ武闘会では
; ****************************************************

R_BUTO_S	PROC	NEAR
	CALL	OPEN_BUTOHKAI		; 武闘会・ＯＰＥＮ

	CALL	EX_MEMBER_SELECT	; メンバ選出／自分の娘除く

	MOV	TAG_MUSUME_OUT,1	; 1=娘負けたからとばす
	CALL	TOURNAMENT		; トーナメント

	SELECT	"戦いはおわった"

	CALL	HYOUSHOU_SHIKI		; 表彰式
	MOV	DX,FUKI_WID_NUM		; 表彰式ふきだし番号
	CALL	WIDFUKI_CLOSE		; WINDOWS/ふきだしウインドウＣＬＯＳＥ

	CALL	CLOSE_BUTOHKAI		; 武闘会・ＣＬＯＳＥ

	RET
R_BUTO_S	ENDP


; ****************************************************
;	武闘会・ＯＰＥＮ
; ****************************************************

OPEN_BUTOHKAI	PROC	NEAR
	MOV	AX,40			; 40/60秒でロード
	CALL	TMVSET			; V-SYNC timer set.
	MOV	DX,2			; 2=武闘会
	CALL	PT_SYUKAK_LD		; 収穫祭パターンロード
	CALL	TMVEWT			; V-SYNC timer end wait.

	CALL	FEDOUT			; Ｆ・Ｏ（フェードアウト）

	MOV	AX,10			; 10/60秒でＰＵＴ
	CALL	TMVSET			; V-SYNC timer set.
	CALL	VRMCLR			;
	MOV	AX,TITLE_CENTER_X	; タイトルＸ座標
	MOV	BX,TITLE_CENTER_Y	; タイトルＹ座標
	MOV	DX,0			;
	CALL	PT_SYUKAK_PUT		; 収穫祭パターンＰＵＴ
	CALL	TMVEWT			; V-SYNC timer end wait.
	MOV	DX,16			; 夏のパレットのパターン番号
	CALL	PT_PALET_ST		; パレットのセット

	MOV	AX,60*2			;
	CALL	TMVSET			; V-SYNC timer set.
	CALL	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	PT_FREAM_BT_HYO		; 武闘会対戦表フレーム
	CALL	R_SENTOU_BU_LOAD	; 武闘会戦闘・先行ロード
	CALL	TMVEWT			; V-SYNC timer end wait.

	CALL	VRMDP1			; ＶＲＡＭ１表示

;*;	CALL	NORMIN			; ノーマルカラー

	RET
OPEN_BUTOHKAI	ENDP


; ****************************************************
;	武闘会・ＣＬＯＳＥ
; ****************************************************

CLOSE_BUTOHKAI	PROC	NEAR
	RET
CLOSE_BUTOHKAI	ENDP



; ****************************************************
;	トーナメント
;	試合を全て消化します。
;	-I/O- TAG_MUSUME_OUT : 娘アウトフラグ
;				0=娘頑張っている,1=娘負けたからとばす
;	-O- BTL_YOUSHO_C_NUM : 優勝キャラクタ番号
;	    BTL_JUN_YS_C_NUM : 準優勝キャラクタ番号
; ****************************************************

TOURNAMENT	PROC	NEAR
	MOV	BTL_YOUSHO_C_NUM,0	; 優勝キャラクタ番号
	MOV	BTL_JUN_YS_C_NUM,0	; 準優勝キャラクタ番号

	MOV	BX,OFFSET BUTOH_ENTRY_ALL ; トーナメント全エントリィ登録
	CALL	WIDTOUR_ENTRY		; WINDOWS/トーナメント全エントリィ登録

	CALL	FREAM_DRAW		; フレーム描画

	MOV	TAG_LEVEL,1		; 第何試合か？
TOURNAMENT_LOOP:
	MOV	DX,TAG_LEVEL		; 第何試合か？
	CALL	WIDTOUR_KICKOFF		; WINDOWS/トーナメント試合・キックオフ
	MOV	TAG_MAX,AX		; 組み合せ数
	MOV	TAG_PNT,1		; 組み合せ番号

	MOV	CX,TAG_MAX		; 組み合せ数
TOURNAMENT_LOOP_2:
	PUSH	CX			;
	MOV	DX,TAG_PNT		; 組み合せ番号
	CALL	WIDTOUR_1GET		; WINDOWS/トーナメント試合・組み合せ

	MOV	TAG_ATR,AX		; 試合属性 0=他人試合,1=甲娘,2=乙娘
	MOV	TAG_KOH,CX		; 組み合せ・甲チーム
	MOV	TAG_OTSU,DX		; 組み合せ・乙チーム
	MOV	TAG_CHAR_KOH,SI		; キャラクタ番号・甲チーム
	MOV	TAG_CHAR_OTSU,DI	; キャラクタ番号・乙チーム

	CMP	TAG_ATR,0		; 試合属性 0=他人試合,1=甲娘,2=乙娘
	JE	TOURNAMENT_ANTHER	;

	CALL	BATLE_GAMEN		; バトル画面
	JMP	TOURNAMENT_1END		;
TOURNAMENT_ANTHER:			;
	CALL	BATLE_SOKU_KETSU	; バトル即効決着
TOURNAMENT_1END:			;
	CALL	BATLE_KEKKA		; バトル結果

	INC	TAG_PNT			; 組み合せ番号
	POP	CX			;
	LOOPX	TOURNAMENT_LOOP_2	;

	CALL	WIDTOUR_OFFSIDE		; WINDOWS/トーナメント試合・オフサイド
	CMP	AX,1			; 状態 0=通常,1=全試合終了
	JE	TOURNAMENT_END		;

	INC	TAG_LEVEL		; 第何試合か？
	CMP	TAG_LEVEL,6		; 第何試合か？
	JE	TOURNAMENT_EXIT		;

	JMP	TOURNAMENT_LOOP

TOURNAMENT_END:				;
	MOV	BTL_YOUSHO_C_NUM,SI	; 優勝キャラクタ番号
	MOV	BTL_JUN_YS_C_NUM,DI	; 準優勝キャラクタ番号
TOURNAMENT_EXIT:
	RET
TOURNAMENT	ENDP


; ****************************************************
;	表彰式
;	-I- BTL_YOUSHO_C_NUM : 優勝キャラクタ番号
;	    BTL_JUN_YS_C_NUM : 準優勝キャラクタ番号
; ****************************************************

HYOUSHOU_SHIKI	PROC	NEAR
	MOV	DX,BTL_YOUSHO_C_NUM	; 優勝キャラクタ番号
	CALL	WIDALLOC_CHRADRS	; WINDOWS/キャラクタ・ヘッダアドレス
	MOV	BTL_YOUSHO_ENTRY,BX	; 優勝エントリィ(address)

	MOV	DX,BTL_JUN_YS_C_NUM	; 準優勝キャラクタ番号
	CALL	WIDALLOC_CHRADRS	; WINDOWS/キャラクタ・ヘッダアドレス
	MOV	BTL_JUN_YS_ENTRY,BX	; 準優勝エントリィ(address)

	MOV	DX,BTL_YOUSHO_C_NUM	; 優勝キャラクタ番号
	CALL	WIDALLOC_TEKICHR	; WINDOWS/敵キャラクタ・データ結合

	MOV	DX,4			; 4=表彰式
	CALL	PT_SYUKAK_LD		; 収穫祭パターンロード

	CALL	BLACK			; ブラックアウト

	CALL	VRMDP0			; ＶＲＡＭ０表示
	CALL	VRMWT0			; ＶＲＡＭ０アクセス

	CALL	VRMCLR			;

	MOV	AX,TITLE_CENTER_X	; タイトルＸ座標
	MOV	BX,TITLE_CENTER_Y	; タイトルＹ座標
	MOV	DX,0			;
	CALL	PT_SYUKAK_PUT		; 収穫祭パターンＰＵＴ

	CALL	NORMIN			; ノーマルカラー

	MOV	AX,60			;
	CALL	TMVWAT			; V-SYNC timer wait.

	CALL	BLACK			; ブラックアウト
	CALL	VRMCLR			;
	CALL	NORMIN			; ノーマルカラー

	CALL	HYOUSHOU_NEWS		; 表彰式のメッセージ編集

	MOV	DX,FUKI_WID_NUM		; 表彰式ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ

	MOV	DX,FUKI_WID_NUM		; 表彰式ふきだし番号
	MOV	SI,OFFSET MSG_NEWS	; 表彰式のメッセージ
	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ

	MOV	BX,BTL_YOUSHO_ENTRY	; 優勝エントリィ(address)
	MOV	CX,BTL_JUN_YS_ENTRY	; 準優勝エントリィ(address)
	CALL	R_OHSAMA_OHOME_BT	; 王様の御誉め・武闘会編


	MOV	AX,BTL_YOUSHO_ENTRY	; 優勝エントリィ(address)
	MOV	DX,5			; 5=武闘会・優勝
	MOV	CX,0			;
	MOV	S_FUNC,72		; 72=収穫祭等の評価
	CALL	R_KEISAN		; 各計算処理

	MOV	AX,BTL_JUN_YS_ENTRY	; 準優勝エントリィ(address)
	MOV	DX,6			; 6=武闘会・準優勝
	MOV	CX,0			;
	MOV	S_FUNC,72		; 72=収穫祭等の評価
	CALL	R_KEISAN		; 各計算処理

	RET
HYOUSHOU_SHIKI	ENDP


; ****************************************************
;	表彰式のメッセージ編集
;	-I- BTL_YOUSHO_ENTRY : 優勝エントリィ(address)
;	    BTL_JUN_YS_ENTRY : 準優勝エントリィ(address)
;	-O- MSG_NEWS         : 表彰式のメッセージ
; ****************************************************

HYOUSHOU_NEWS	PROC	NEAR
	MOV	DI,OFFSET MSG_NEWS_Y_NM		; 優勝
	MOV	CX,MSG_NEWS_N_LEN		; 名前長さ
	MOV	DX,' '				; 文字
	CALL	STRFILL				; 文字列バッファＦＩＬＬ

	MOV	DI,OFFSET MSG_NEWS_J_NM		; 準優勝
	MOV	CX,MSG_NEWS_N_LEN		; 名前長さ
	MOV	DX,' '				; 文字
	CALL	STRFILL				; 文字列バッファＦＩＬＬ


	MOVX	R_SR_CHR_ADRS,BTL_YOUSHO_ENTRY	; 優勝エントリィ(address)
	MOV	DI,OFFSET MSG_NEWS_Y_NM		; 優勝
	MOV	CX,MSG_NEWS_N_LEN		; 名前長さ
	CALL	R_SR_GIRL_FULNAMGET		; キャラクタ名+姓ＧＥＴ

	MOVX	R_SR_CHR_ADRS,BTL_JUN_YS_ENTRY	; 準優勝エントリィ(address)
	MOV	DI,OFFSET MSG_NEWS_J_NM		; 準優勝
	MOV	CX,MSG_NEWS_N_LEN		; 名前長さ
	CALL	R_SR_GIRL_FULNAMGET		; キャラクタ名+姓ＧＥＴ

	RET
HYOUSHOU_NEWS	ENDP


; ****************************************************
;	フレーム描画
; ****************************************************

FREAM_DRAW	PROC	NEAR
	CALL	WIDTOUR_NAME		; WINDOWS/トーナメント全エントリィ名前
	CALL	WIDTOUR_LINK		; WINDOWS/トーナメント全組み合せ表示
	RET
FREAM_DRAW	ENDP


; ****************************************************
;	メンバ選出
;	-O- BUTOH_ENTRY_TABLE : (byte)武闘会・エントリィ
; ****************************************************

MEMBER_SELECT	PROC	NEAR
	MOV	DX,BUTOH_ENTRY_MAX	; 武闘会・エントリィ数
	DEC	DX			; 娘の分を除いておく
	MOV	BX,OFFSET BUTOH_ENTRY_TABLE ; (byte)武闘会・エントリィ
	CALL	WIDALLOC_BUTOKAI	; WINDOWS/キャラクタ・武闘会選出
					;	自分の娘は除きます

	MOV	DX,BUTOH_ENTRY_MAX	; 武闘会・エントリィ数
	DEC	DX			; 娘の分を除いておく
	MOV	BX,OFFSET BUTOH_ENTRY_TABLE ; (byte)武闘会・エントリィ

	MOV	AX,1			; 追加するメンバ／Ｎｏ．１は自分の娘
	CALL	WIDALLOC_TSUIKA		; WINDOWS/キャラクタ・メンバ表へ追加

	RET
MEMBER_SELECT	ENDP


; ****************************************************
;	メンバ選出／自分の娘除く
;	-O- BUTOH_ENTRY_TABLE : (byte)武闘会・エントリィ
; ****************************************************

EX_MEMBER_SELECT	PROC	NEAR
	MOV	DX,BUTOH_ENTRY_MAX	; 武闘会・エントリィ数
	DEC	DX			; 娘の分を除いておく
	MOV	BX,OFFSET BUTOH_ENTRY_TABLE ; (byte)武闘会・エントリィ
	CALL	WIDALLOC_BUTOKAI	; WINDOWS/キャラクタ・武闘会選出

	MOV	DX,BUTOH_ENTRY_MAX	; 武闘会・エントリィ数
	DEC	DX			; 娘の分を除いておく
	MOV	BX,OFFSET BUTOH_ENTRY_TABLE ; (byte)武闘会・エントリィ

	MOV	AX,25			; 追加するメンバ／25アーネスト
	CALL	WIDALLOC_TSUIKA		; WINDOWS/キャラクタ・メンバ表へ追加
	RET
EX_MEMBER_SELECT	ENDP


; ****************************************************
;	バトル即効決着
;	-I- TAG_CHAR_KOH  : キャラクタ番号・甲チーム
;	    TAG_CHAR_OTSU : キャラクタ番号・乙チーム
;	    TAG_MUSUME_OUT: 娘アウトフラグ 1=娘負けたからとばす
;	-O- KATSU_FLAG    : 勝つフラグ 1=甲が勝ち,2=乙が勝ち
;	    TAG_ADRS_KOH  : キャラクタアドレス・甲
;	    TAG_ADRS_OTSU : キャラクタアドレス・乙
; ****************************************************

BATLE_SOKU_KETSU	PROC	NEAR
	CMP	TAG_MUSUME_OUT,1	; 娘アウトフラグ 1=娘負けたからとばす
	JE	BATLE_SOKU_KETSU_1	;
	CALL	WIDTOUR_1SHOCK		; WINDOWS/トーナメント試合・衝撃！
BATLE_SOKU_KETSU_1:

	CALL	WIDTOUR_1SHOCK		; WINDOWS/トーナメント試合・衝撃！

	MOV	DX,TAG_CHAR_KOH		; キャラクタ番号・甲チーム
	CALL	WIDALLOC_CHRADRS	; WINDOWS/キャラクタ・ヘッダアドレス
	MOV	TAG_ADRS_KOH,BX		; キャラクタアドレス・甲

	MOV	DX,TAG_CHAR_OTSU	; キャラクタ番号・乙チーム
	CALL	WIDALLOC_CHRADRS	; WINDOWS/キャラクタ・ヘッダアドレス
	MOV	TAG_ADRS_OTSU,BX	; キャラクタアドレス・乙

	MOV	AX,TAG_ADRS_KOH		; キャラクタアドレス・甲
	MOV	BX,TAG_ADRS_OTSU	; キャラクタアドレス・乙
	MOV	S_FUNC,39		; バトル即効計算
	CALL	R_KEISAN		; 各計算処理
	MOV	KATSU_KOH_100,AX	; 甲の勝つ確率（％）

	CALL	RANDAM_100		; 乱数１００
	CMP	KATSU_KOH_100,AX	; 甲の勝つ確率（％）
	JLE	BATLE_SOKU_KETSU_OTSU	;

BATLE_SOKU_KETSU_KOH:
	MOV	KATSU_FLAG,1		; 勝つフラグ 1=甲が勝ち
	RET
BATLE_SOKU_KETSU_OTSU:
	MOV	KATSU_FLAG,2		; 勝つフラグ 2=乙が勝ち
	RET
BATLE_SOKU_KETSU	ENDP


; ****************************************************
;	バトル画面
;	-I-   TAG_CHAR_KOH  : キャラクタ番号・甲チーム
;	      TAG_CHAR_OTSU : キャラクタ番号・乙チーム
;	      TAG_ATR       : 試合属性 0=他人試合,1=甲娘,2=乙娘
;	      TAG_LEVEL     : 第何試合か？
;	-O-   KATSU_FLAG    : 勝つフラグ 1=甲が勝ち,2=乙が勝ち
;	      TAG_MUSUME_OUT: 娘アウトフラグ 0=娘頑張っている
;					1=娘負けたからとばす
; ****************************************************

BATLE_GAMEN	PROC	NEAR
	MOV	TAG_MUSUME_OUT,0	; 娘アウトフラグ 0=娘頑張っている

	CMP	TAG_ATR,1		; 試合属性 1=甲娘
	JE	BATLE_GAMEN_KOH		;
	CMP	TAG_ATR,2		; 試合属性 2=乙娘
	JE	BATLE_GAMEN_OTSU	;

	JMP	BATLE_GAMEN_EXIT	;

BATLE_GAMEN_KOH:
	MOV	AX,TAG_CHAR_KOH		; キャラクタ番号／私の娘・甲チーム
	MOV	BX,TAG_CHAR_OTSU	; キャラクタ番号／ライバル・乙チーム
	JMP	BATLE_GAMEN_GO		;

BATLE_GAMEN_OTSU:
	MOV	BX,TAG_CHAR_KOH		; キャラクタ番号／ライバル・甲チーム
	MOV	AX,TAG_CHAR_OTSU	; キャラクタ番号／私の娘・乙チーム
	JMP	BATLE_GAMEN_GO		;

BATLE_GAMEN_GO:
	CALL	BATLE_WINDOW		; バトルウインドウ
	CMP	AX,1			; 1=合格,2=不合格
	JE	BATLE_GAMEN_K		;
	MOV	TAG_MUSUME_OUT,1	; 娘アウトフラグ 1=娘負けたからとばす
BATLE_GAMEN_K:				;

	CMP	TAG_ATR,1		; 試合属性 1=甲娘
	JE	BATLE_GAMEN_E_KOH	;
	CMP	TAG_ATR,2		; 試合属性 2=乙娘
	JE	BATLE_GAMEN_E_OTSU	;

BATLE_GAMEN_E_KOH:			;
	MOV	KATSU_FLAG,AX		; 勝つフラグ 1=甲が勝ち,2=乙が勝ち

	JMP	BATLE_GAMEN_88		;
BATLE_GAMEN_E_OTSU:			;
	MOV	KATSU_FLAG,1		; 勝つフラグ 1=甲が勝ち
	CMP	AX,1			; 1=合格,2=不合格
	JNE	BATLE_GAMEN_88		;
	MOV	KATSU_FLAG,2		; 勝つフラグ 2=乙が勝ち（娘）

BATLE_GAMEN_88:				;

BATLE_GAMEN_EXIT:			;
	RET
BATLE_GAMEN	ENDP


; ****************************************************
;	バトルウインドウ
;	-I- AX   : キャラクタ番号／私の娘
;	    BX   : キャラクタ番号／私の娘のライバル
;	    TAG_LEVEL : 第何試合か？
;	-O- AX   : 1=合格,2=不合格
; ****************************************************

BATLE_WINDOW	PROC	NEAR
	PUSH	AX
	PUSH	BX
	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	CALL	R_SENTOU_BU_OPEN	; 武闘会戦闘・ＯＰＥＮ
	CALL	VRMDP0			; ＶＲＡＭ０表示
	MUSIC	KYOKU_BATLE		; バﾄﾙ
	POP	BX
	POP	AX

	MOV	DX,TAG_LEVEL		; 第何試合か？
	CALL	R_SENTOU_BU		; 武闘会戦闘！

	PUSH	AX
	CALL	R_SENTOU_BU_CLOSE	; 武闘会戦闘・ＣＬＯＳＥ
	CALL	VRMWT1			; ＶＲＡＭ１アクセス
;*;	CALL	FREAM_DRAW		; フレーム描画
	CALL	VRMDP1			; ＶＲＡＭ１表示
	MUSIC	KYOKU_BUTOHKAI		; 武闘会
	POP	AX
	RET
BATLE_WINDOW	ENDP


; ****************************************************
;	バトル結果
;	-I- KATSU_FLAG     : 勝つフラグ 1=甲が勝ち,2=乙が勝ち
;	    TAG_MUSUME_OUT : 娘アウトフラグ 1=娘負けたからとばす
; ****************************************************

BATLE_KEKKA	PROC	NEAR
	MOV	AX,KATSU_FLAG		; 勝つフラグ 1=甲が勝ち,2=乙が勝ち
	CALL	WIDTOUR_1END		; WINDOWS/トーナメント試合・勝敗

	CMP	TAG_MUSUME_OUT,1	; 娘アウトフラグ 1=娘負けたからとばす
	JE	BATLE_KEKKA_EXIT	;

	MOV	AX,30			; 待ち時間
	CALL	TMVWAT			; V-SYNC timer wait.

BATLE_KEKKA_EXIT:
	RET
BATLE_KEKKA	ENDP


CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	S_FUNC:WORD			; 計算ファンクション
EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス

BUTOH_ENTRY_MAX		DW	24	; 武闘会・エントリィ数

BUTOH_ENTRY_ALL		LABEL	BYTE	; トーナメント全エントリィ登録
			DB	24	; テーブルサイズ
BUTOH_ENTRY_TABLE	LABEL	BYTE	; (byte)武闘会・エントリィ
			DB	24 DUP (0)

TAG_LEVEL		DW	0	; 第何試合か？
TAG_MAX			DW	0	; 組み合せ数
TAG_PNT			DW	0	; 組み合せ番号
TAG_ATR			DW	0	; 試合属性 0=他人の試合
					;  1=甲自分の娘,2=乙自分の娘
TAG_KOH			DW	0	; 組み合せ・甲チーム
TAG_OTSU		DW	0	; 組み合せ・乙チーム
TAG_CHAR_KOH		DW	0	; キャラクタ番号・甲チーム
TAG_CHAR_OTSU		DW	0	; キャラクタ番号・乙チーム
TAG_ADRS_KOH		DW	0	; キャラクタアドレス・甲
TAG_ADRS_OTSU		DW	0	; キャラクタアドレス・乙

TAG_MUSUME_OUT		DW	0	; 娘アウトフラグ 0=娘頑張っている
					; 1=娘負けたからとばす

KATSU_KOH_100		DW	0	; 甲の勝つ確率（％）
KATSU_FLAG		DW	0	; 勝つフラグ 1=甲が勝ち,2=乙が勝ち

BTL_YOUSHO_ENTRY	DW	0	; 優勝エントリィ(address)
BTL_JUN_YS_ENTRY	DW	0	; 準優勝エントリィ(address)
BTL_YOUSHO_C_NUM	DW	0	; 優勝キャラクタ番号
BTL_JUN_YS_C_NUM	DW	0	; 準優勝キャラクタ番号

MSG_NEWS_N_LEN	DW	18*2		; 名前長さ
MSG_NEWS	LABEL	BYTE
		DB	"優勝は"
MSG_NEWS_Y_NM	DB	"　　　　　　　　　　　　　　　　　　@" ; 優勝
		DB	"準優勝は"
MSG_NEWS_J_NM	DB	"　　　　　　　　　　　　　　　　　　@" ; 準優勝
		DB	0,0

DATA	ENDS

	END
;
;	end of "R_BUTOH.ASM"
;
