; "R_CONTST.ASM" PC-9801UV11 make by R.H 1991/01/08
;
;
;	「子育て」
;
;	ミス･×××･コンテスト
;
;
; (C) 1991 ritsurou hashimoto.


INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	WORDID.INC

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

TITLE_CENTER_X	EQU	25		; タイトルＸ座標
TITLE_CENTER_Y	EQU	176-12		; タイトルＹ座標

TITLE_FUKI_X	EQU	17		; ふきだし内Ｘ
TITLE_FUKI_Y	EQU	160		; ふきだし内Ｙ

TITLE_SUN_X	EQU	45		; ｔｈｅ ＳＵＮ ＰＲＩＺＥ
TITLE_SUN_Y	EQU	55+2		; ｔｈｅ ＳＵＮ ＰＲＩＺＥ
TITLE_TAIYO_X	EQU	50		; 太陽の神賞
TITLE_TAIYO_Y	EQU	95-2		; 太陽の神賞

TITLE_MISS_X	EQU	5		; Ｍｉｓｓ ＫＩＮＧＤＯＭ
TITLE_MISS_Y	EQU	55+2		; Ｍｉｓｓ ＫＩＮＧＤＯＭ
TITLE_KOKUOH_X	EQU	10		; ミス王国
TITLE_KOKUOH_Y	EQU	95-2		; ミス王国


TITLE_MOON_X	EQU	5		; ｔｈｅ ＭＯＯＮ ＰＲＩＺＥ
TITLE_MOON_Y	EQU	255+2		; ｔｈｅ ＭＯＯＮ ＰＲＩＺＥ
TITLE_TSUKI_X	EQU	10		; 月の神賞
TITLE_TSUKI_Y	EQU	295-2		; 月の神賞

TITLE_STAR_X	EQU	45		; ｔｈｅ ＳＴＡＲ ＰＲＩＺＥ
TITLE_STAR_Y	EQU	255+2		; ｔｈｅ ＳＴＡＲ ＰＲＩＺＥ
TITLE_HOSHI_X	EQU	50		; 星の神賞
TITLE_HOSHI_Y	EQU	295-2		; 星の神賞


EOS	EQU	0		; end of string.


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA


PUBLIC	R_CONTST		; ミス･×××･コンテスト
PUBLIC	R_CTST_S		; そのころミス･コンテストでは

EXTRN	R_OHSAMA_OHOME:NEAR	; 王様の御誉め

EXTRN	R_KEISAN:NEAR		; 各計算処理

EXTRN	R_SR_GIRL_NAMEGET:NEAR	; キャラクタ名ＧＥＴ

EXTRN	WIDALLOC_MISSCON:NEAR	; WINDOWS/キャラクタ・ミスコン選出
EXTRN	WIDALLOC_TSUIKA:NEAR	; WINDOWS/キャラクタ・メンバ表へ追加

EXTRN	WIDFRM_MISSCON:NEAR	; WINDOWS/フレーム・ミスコン

EXTRN	WIDFACE_OPEN_M:NEAR	; WINDOWS/ミスコンフェイスＯＰＥＮ
EXTRN	WIDFACE_LOAD_M_ONLY:NEAR ; WINDOWS/ミスコンフェイスＬＯＡＤ ＯＮＬＹ
EXTRN	WIDFACE_PUT_M_ONLY:NEAR	; WINDOWS/ミスコンフェイスＰＵＴ ＯＮＬＹ

EXTRN	WIDALLOC_TEKICHR:NEAR	; WINDOWS/敵キャラクタ・データ結合

EXTRN	WIDFUKI:NEAR		; WINDOWS/ふきだしウインドウ
EXTRN	WIDFUKI_OPEN:NEAR	; WINDOWS/ふきだしウインドウＯＰＥＮ
EXTRN	WIDFUKI_CLOSE:NEAR	; WINDOWS/ふきだしウインドウＣＬＯＳＥ

EXTRN	WIDVAL_DP:NEAR		; WINDOWS/内容表示・ウインドウ外指定
EXTRN	WIDHBR_DP:NEAR		; WINDOWS/横グラフ表示・ウインドウ外指定

EXTRN	WIDSLC2:NEAR		; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
EXTRN	WID_UNIT:NEAR		; WINDOWS/単位別文字列化

EXTRN	WIDMINI_INIT:NEAR	; WINDOWS/ミニウインドウ初期処理
EXTRN	WIDMINI:NEAR		; WINDOWS/ミニウインドウ表示
EXTRN	WIDMINI_FRM:NEAR	; WINDOWS/ミニウインドウフレームのみ表示
EXTRN	WIDMINI_STRC:NEAR	; WINDOWS/ミニウインドウ定義体の設定

EXTRN	WIDHED_XSEIZA:NEAR	; WINDOWS/星座表示

EXTRN	WIDDSP_SV_F:NEAR	; WINDOWS/画面フル退避
EXTRN	WIDDSP_LD_F:NEAR	; WINDOWS/画面フル復元

EXTRN	R_SR_YOIDESUKA:NEAR	; よいですか

EXTRN	PT_SYUKAK_LD:NEAR	; 収穫祭パターンロード
EXTRN	PT_SYUKAK_PUT:NEAR	; 収穫祭パターンＰＵＴ
EXTRN	PT_SYUKAK_MPT:NEAR	; 収穫祭マスクパターンＰＵＴ

;	PT_LD_MISS:NEAR		; ミスコンパターンセットロード
;	PT_PUT_MISS_SHO:NEAR	; ミスコン各パターン

EXTRN	PT_PALET_ST:NEAR	; パレットのセット

EXTRN	MSCSRT:NEAR		; カーソルスタート
EXTRN	MSCMOV:NEAR		; カーソル移動
EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR		; カーソルストップ
EXTRN	MSCSTS:NEAR		; マウスカーソルステータス

EXTRN	MSWWAT:NEAR		; カーソルボタン待ち

EXTRN	STR_N_HNZN:NEAR		; 文字列半角を全角
EXTRN	ADDSTRSET:NEAR		; 文字列の連結

EXTRN	STRZEROC:NEAR		; 文字列バッファ０クリア
EXTRN	R_SR_GIRL_FULNAMGET:NEAR ; キャラクタ名+姓ＧＥＴ
EXTRN	KANJITUME:NEAR		; 漢字文字詰め処理


; ****************************************************
;	ミス･×××･コンテスト
; ****************************************************

R_CONTST	PROC	NEAR
	CALL	OPEN_MISS_CONTEST	; ミスコン・ＯＰＥＮ

	CALL	MEMBER_SELECT		; メンバ選出

	CALL	MISS_CON_ENTRY		; ミスコン・登場人物

	CALL	CONTEST_MAIN		; コンテスト・ＭＡＩＮ

	SELECT	"ミス王国･コンテストは終わった"

	CALL	CLOSE_MISS_CONTEST	; ミスコン・ＣＬＯＳＥ
	RET
R_CONTST	ENDP


; ****************************************************
;	そのころミス･コンテストでは
; ****************************************************

R_CTST_S	PROC	NEAR
	CALL	OPEN_MISS_CONTEST	; ミスコン・ＯＰＥＮ

	CALL	MEMBER_ANTHER_SELECT	; 娘を除くメンバ選出

	CALL	MISS_CON_ENTRY		; ミスコン・登場人物

	CALL	CONTEST_ANTHER_MAIN	; 娘を除くコンテスト・ＭＡＩＮ

	CALL	CLOSE_MISS_CONTEST	; ミスコン・ＣＬＯＳＥ

	RET
R_CTST_S	ENDP


; ****************************************************
;	ミスコン・ＯＰＥＮ
; ****************************************************

OPEN_MISS_CONTEST	PROC	NEAR
	MOV	DX,3			; 3=ミス国王
	CALL	PT_SYUKAK_LD		; 収穫祭パターンロード

	CALL	VRMWT1			; ＶＲＡＭ１アクセス
	CALL	VRMCLR			;

	MOV	AX,TITLE_CENTER_X	; タイトルＸ座標
	MOV	BX,TITLE_CENTER_Y	; タイトルＹ座標
	MOV	DX,0			; 番号 ミス国王
	CALL	PT_SYUKAK_PUT		; 収穫祭パターンＰＵＴ

	CALL	FEDOUT			; Ｆ・Ｏ（フェードアウト）
	MOV	AX,10			; 10/60秒
	CALL	TMVSET			; V-SYNC timer set.
	CALL	BLACK			; ブラックアウト
	CALL	VRMDP1			; ＶＲＡＭ１表示
	CALL	TMVEWT			; V-SYNC timer end wait.
	MOV	DX,16			; 夏のパレットのパターン番号
	CALL	PT_PALET_ST		; パレットのセット

	MOV	AX,60*2			;
	CALL	TMVWAT			; V-SYNC timer wait.

	CALL	VRMWT0			; ＶＲＡＭ０アクセス
	CALL	WIDFRM_MISSCON		; WINDOWS/フレーム・ミスコン

	MOV	AX,10			; 10/60秒
	CALL	TMVSET			; V-SYNC timer set.
	CALL	BLACK			; ブラックアウト
	CALL	VRMDP0			; ＶＲＡＭ０表示
	CALL	TMVEWT			; V-SYNC timer end wait.
	CALL	NORMIN			; ノーマルカラー

	RET
OPEN_MISS_CONTEST	ENDP


; ****************************************************
;	ミスコン・ＣＬＯＳＥ
; ****************************************************

CLOSE_MISS_CONTEST	PROC	NEAR
	RET
CLOSE_MISS_CONTEST	ENDP


; ****************************************************
;	コンテスト・ＭＡＩＮ
; ****************************************************

PUBLIC	FAR_CONTEST_MAIN

FAR_CONTEST_MAIN	PROC	FAR
	CALL	CONTEST_MAIN
	RET
FAR_CONTEST_MAIN	ENDP

CONTEST_MAIN	PROC	NEAR

	CALL	CONTEST_OPEN_SETUMEI	; コンテスト冒頭説明

	; 気品部門

	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避

	MOV	BAISYU_NIN,0		; 買収人数

	MOV	BUMON_NUMBER,1		; 1=気品部門
	MOV	DX,0			; ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ
	MOV	AX,TITLE_FUKI_X		; ふきだし内Ｘ
	MOV	BX,TITLE_FUKI_Y		; ふきだし内Ｙ
	MOV	DX,3*2			; 太陽の神賞
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	MOV	AX,20			;
	CALL	TMVWAT			; V-SYNC timer wait.
	MOV	DX,0			; ふきだし番号
	MOV	SI,OFFSET MSG_KIHINBUMON ; "気品部門"
	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ

;*;	CALL	R_SR_YOIDESUKA		; よいですか

	SELECT	"予想発表"
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元

	CALL	YOSOU_HAPPYO_MAIN	; 予想発表・ＭＡＩＮ
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元


	CALL	TOUHYOU_ST_MAIN		; 投票スタート・ＭＡＩＮ
	CMP	AX,0			; 0=投票,1=買収
	JE	CONTEST_MAIN_1		;
	CALL	BAISYU_MAIN		; 買収・ＭＡＩＮ
CONTEST_MAIN_1:

	CALL	MISS_PARA_OPEN		; ミスコン・パラメータＯＰＥＮ

	MOV	PARA_D_MODE,001B	; パラメータ表示モード bit0:気品
	CALL	MISS_PARA_PRINT		; ミスコン・パラメータ表示

	MOV	TOHYO_VAL_ADRS,OFFSET MISS_KIHIN ; 3. 気品／グラフテーブル
	MOV	TOHYO_ADRS,OFFSET TOHYO_KIHIN    ; 投票・気品
	CALL	TOUHYOU_MAIN			 ; 投票・ＭＡＩＮ

	CALL	R_SR_YOIDESUKA		; よいですか


	; プロポーション部門

	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避

	MOV	BAISYU_NIN,0		; 買収人数

	MOV	BUMON_NUMBER,2		; 2=プロポーション部門
	MOV	DX,0			; ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ
	MOV	AX,TITLE_FUKI_X		; ふきだし内Ｘ
	MOV	BX,TITLE_FUKI_Y		; ふきだし内Ｙ
	MOV	DX,1*2			; 月の神賞
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	MOV	AX,20			;
	CALL	TMVWAT			; V-SYNC timer wait.
	MOV	DX,0			; ふきだし番号
	MOV	SI,OFFSET MSG_PROPORTION ; "プロポーション部門"
	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ

;*;	CALL	R_SR_YOIDESUKA		; よいですか

	SELECT	"予想発表"
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元

	CALL	YOSOU_HAPPYO_MAIN	; 予想発表・ＭＡＩＮ
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元


	CALL	TOUHYOU_ST_MAIN		; 投票スタート・ＭＡＩＮ
	CMP	AX,0			; 0=投票,1=買収
	JE	CONTEST_MAIN_2		;
	CALL	BAISYU_MAIN		; 買収・ＭＡＩＮ
CONTEST_MAIN_2:
	MOV	PARA_D_MODE,010B	; パラメータ表示モード bit1:プロポ
	CALL	MISS_PARA_PRINT		; ミスコン・パラメータ表示

	MOV	TOHYO_VAL_ADRS,OFFSET MISS_PROPRT; 7. プロポー／内容表示
	MOV	TOHYO_ADRS,OFFSET TOHYO_PROPRT	 ; 投票・プロポー
	CALL	TOUHYOU_MAIN			 ; 投票・ＭＡＩＮ

	CALL	R_SR_YOIDESUKA		; よいですか


	; 色気部門

	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避

	MOV	BAISYU_NIN,0		; 買収人数

	MOV	BUMON_NUMBER,3		; 3=色気部門
	MOV	DX,0			; ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ
	MOV	AX,TITLE_FUKI_X		; ふきだし内Ｘ
	MOV	BX,TITLE_FUKI_Y		; ふきだし内Ｙ
	MOV	DX,5*2			; 星の神賞
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	MOV	AX,20			;
	CALL	TMVWAT			; V-SYNC timer wait.
	MOV	DX,0			; ふきだし番号
	MOV	SI,OFFSET MSG_IROKE	; "色気部門"
	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ

;*;	CALL	R_SR_YOIDESUKA		; よいですか

	SELECT	"予想発表"
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元

	CALL	YOSOU_HAPPYO_MAIN	; 予想発表・ＭＡＩＮ
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元


	CALL	TOUHYOU_ST_MAIN		; 投票スタート・ＭＡＩＮ
	CMP	AX,0			; 0=投票,1=買収
	JE	CONTEST_MAIN_3		;
	CALL	BAISYU_MAIN		; 買収・ＭＡＩＮ
CONTEST_MAIN_3:
	MOV	PARA_D_MODE,100B	; パラメータ表示モード bit2:色気
	CALL	MISS_PARA_PRINT		; ミスコン・パラメータ表示

	MOV	TOHYO_VAL_ADRS,OFFSET MISS_IROKE ; 6. 色気／グラフテーブル
	MOV	TOHYO_ADRS,OFFSET TOHYO_IROKE	 ; 投票・色気
	CALL	TOUHYOU_MAIN			 ; 投票・ＭＡＩＮ

	CALL	R_SR_YOIDESUKA		; よいですか


	; 集計結果

	CALL	CONTEST_SYUBAN		; コンテスト終盤

CONTEST_MAIN_EXIT:
	RET
CONTEST_MAIN	ENDP


; ****************************************************
;	娘を除くコンテスト・ＭＡＩＮ
; ****************************************************

CONTEST_ANTHER_MAIN	PROC	NEAR
	CALL	CONTEST_OPEN_SETUMEI		; コンテスト冒頭説明

	MOV	BAISYU_NIN,0			; 買収人数

	MOV	TOHYO_VAL_ADRS,OFFSET MISS_KIHIN ; 3. 気品／グラフテーブル
	MOV	TOHYO_ADRS,OFFSET TOHYO_KIHIN    ; 投票・気品
	CALL	TOUHYOU_MAIN			 ; 投票・ＭＡＩＮ

	MOV	TOHYO_VAL_ADRS,OFFSET MISS_PROPRT; 7. プロポー／内容表示
	MOV	TOHYO_ADRS,OFFSET TOHYO_PROPRT	 ; 投票・プロポー
	CALL	TOUHYOU_MAIN			 ; 投票・ＭＡＩＮ

	MOV	TOHYO_VAL_ADRS,OFFSET MISS_IROKE ; 6. 色気／グラフテーブル
	MOV	TOHYO_ADRS,OFFSET TOHYO_IROKE	 ; 投票・色気
	CALL	TOUHYOU_MAIN			 ; 投票・ＭＡＩＮ

	CALL	CONTEST_SYUBAN		; コンテスト終盤
	RET
CONTEST_ANTHER_MAIN	ENDP


; ****************************************************
;	コンテスト冒頭説明
; ****************************************************

CONTEST_OPEN_SETUMEI	PROC	NEAR
	MOV	DX,5			; 5=各賞
	CALL	PT_SYUKAK_LD		; 収穫祭パターンロード

	CALL	R_SR_YOIDESUKA		; よいですか

	; コンテスト説明

	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避

	MOV	DX,0			; ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ
	MOV	DX,0			; ふきだし番号
	MOV	SI,OFFSET MSG_STARTSET	; "まず３つの部門賞を千人の..."
	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ

	CALL	R_SR_YOIDESUKA		; よいですか

	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元

	RET
CONTEST_OPEN_SETUMEI	ENDP


; ****************************************************
;	コンテスト終盤
; ****************************************************

CONTEST_SYUBAN	PROC	NEAR

	; 集計結果

	CALL	SYUKEI_KEKKA		; 集計結果

	CALL	WIDDSP_SV_F		; WINDOWS/画面フル退避
	MOV	DX,1			; ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ
	MOV	WIDFUKI_AFTER_W,1	; フラグ・処理後にＷＡＩＴをいれる=1
	MOV	DX,1			; ふきだし番号
	MOV	SI,OFFSET MSG_SYUKEI_END ; 集計結果
	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ
	MOV	DX,1			; ふきだし番号
	CALL	WIDFUKI_CLOSE		; WINDOWS/ふきだしウインドウＣＬＯＳＥ
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元

	SELECT	"各賞の発表へ"

	CALL	YOUSHOU_HAPPYO		; 優勝発表

	CALL	R_SR_YOIDESUKA		; よいですか

	MOV	AX,1			; 御誉めモード 0=娘を,1=敵を
	MOV	BX,YOUSHO_ENTRY		; 総合優勝エントリィ(address)
	CMP	BX,WIDMY_GIRL_OF	; 私の娘アドレス
	JNE	CONTEST_SYUBAN_88	;
	MOV	AX,0			; 御誉めモード 0=娘を,1=敵を
CONTEST_SYUBAN_88:
	CALL	R_OHSAMA_OHOME		; 王様の御誉め
	RET
CONTEST_SYUBAN	ENDP


; ****************************************************
;	各賞発表ボード
; ****************************************************

KAKUSHOU_BORD	PROC	NEAR
	MOV	DX,4			; 4=表彰式
	CALL	PT_SYUKAK_LD		; 収穫祭パターンロード

	; 各賞発表

	MOV	AX,10			; 10/60秒
	CALL	TMVSET			; V-SYNC timer set.
	CALL	BLACK			; ブラックアウト
	CALL	VRMCLR			;
	MOV	AX,TITLE_CENTER_X	; タイトルＸ座標
	MOV	BX,TITLE_CENTER_Y	; タイトルＹ座標
	MOV	DX,0			; 表彰式
	CALL	PT_SYUKAK_PUT		; 収穫祭パターンＰＵＴ
	CALL	TMVEWT			; V-SYNC timer end wait.
	CALL	NORMIN			; ノーマルカラー

	MOV	AX,60*2			;
	CALL	TMVSET			; V-SYNC timer set.
	MOV	DX,5			; 5=各賞
	CALL	PT_SYUKAK_LD		; 収穫祭パターンロード
	CALL	TMVEWT			; V-SYNC timer end wait.


	MOV	AX,10			; 10/60秒
	CALL	TMVSET			; V-SYNC timer set.
	CALL	BLACK			; ブラックアウト
	CALL	VRMCLR			;

	MOV	AX,TITLE_SUN_X		; ｔｈｅ ＳＵＮ ＰＲＩＺＥ
	MOV	BX,TITLE_SUN_Y		; ｔｈｅ ＳＵＮ ＰＲＩＺＥ
	MOV	DX,2*2			; ｔｈｅ ＳＵＮ ＰＲＩＺＥ
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	MOV	AX,TITLE_TAIYO_X	; 太陽の神賞
	MOV	BX,TITLE_TAIYO_Y	; 太陽の神賞
	MOV	DX,3*2			; 太陽の神賞
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ

	MOV	AX,TITLE_MOON_X		; ｔｈｅ ＭＯＯＮ ＰＲＩＺＥ
	MOV	BX,TITLE_MOON_Y		; ｔｈｅ ＭＯＯＮ ＰＲＩＺＥ
	MOV	DX,0*2			; ｔｈｅ ＭＯＯＮ ＰＲＩＺＥ
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	MOV	AX,TITLE_TSUKI_X	; 月の神賞
	MOV	BX,TITLE_TSUKI_Y	; 月の神賞
	MOV	DX,1*2			; 月の神賞
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ

	MOV	AX,TITLE_STAR_X		; ｔｈｅ ＳＴＡＲ ＰＲＩＺＥ
	MOV	BX,TITLE_STAR_Y		; ｔｈｅ ＳＴＡＲ ＰＲＩＺＥ
	MOV	DX,4*2			; ｔｈｅ ＳＴＡＲ ＰＲＩＺＥ
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	MOV	AX,TITLE_HOSHI_X	; 星の神賞
	MOV	BX,TITLE_HOSHI_Y	; 星の神賞
	MOV	DX,5*2			; 星の神賞
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ

	MOV	AX,5			; ＰＵＴ　Ｘ座標
	MOV	BX,50			; ＰＵＴ　Ｙ座標
	MOV	AX,TITLE_MISS_X		; Ｍｉｓｓ ＫＩＮＧＤＯＭ
	MOV	BX,TITLE_MISS_Y		; Ｍｉｓｓ ＫＩＮＧＤＯＭ
	MOV	DX,6*2			; Ｍｉｓｓ ＫＩＮＧＤＯＭ
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	MOV	AX,10			; ＰＵＴ　Ｘ座標
	MOV	BX,100			; ＰＵＴ　Ｙ座標
	MOV	AX,TITLE_KOKUOH_X	; ミス王国
	MOV	BX,TITLE_KOKUOH_Y	; ミス王国
	MOV	DX,7*2			; ミス王国
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ

	CALL	TMVEWT			; V-SYNC timer end wait.
	CALL	NORMIN			; ノーマルカラー

	RET
KAKUSHOU_BORD	ENDP


; ****************************************************
;	集計結果
;	-I- BAISYU_KIHIN : 買収人数・気品
;	    BAISYU_IROKE : 買収人数・色気
;	    BAISYU_PROPRT: 買収人数・プロポー
;	-O- YOUSHO_KIHIN_NO	; 部門別１位・気品エントリィ番号
;	    YOUSHO_KIHIN	; 部門別１位・気品エントリィ(address)
;	    YOUSHO_IROKE_NO	; 部門別１位・色気エントリィ番号
;	    YOUSHO_IROKE	; 部門別１位・色気エントリィ(address)
;	    YOUSHO_PROPRT_NO	; 部門別１位・プロポ・エントリィ番号
;	    YOUSHO_PROPRT	; 部門別１位・プロポ・エントリィ(address)
;	    YOUSHO_ENTRY_NO	; 総合優勝エントリィ番号
;	    YOUSHO_ENTRY	; 総合優勝エントリィ(address)
; ****************************************************

SYUKEI_KEKKA	PROC	NEAR
	CALL	YOUSHO_KEISAN		; 優勝計算
	CALL	MISS_TOKU_OPEN		; ミスコン・得票数ＯＰＥＮ
	RET
SYUKEI_KEKKA	ENDP


; ****************************************************
;	優勝発表
;	-I- YOUSHO_KIHIN_NO	; 部門別１位・気品エントリィ番号
;	    YOUSHO_KIHIN	; 部門別１位・気品エントリィ(address)
;	    YOUSHO_IROKE_NO	; 部門別１位・色気エントリィ番号
;	    YOUSHO_IROKE	; 部門別１位・色気エントリィ(address)
;	    YOUSHO_PROPRT_NO	; 部門別１位・プロポ・エントリィ番号
;	    YOUSHO_PROPRT	; 部門別１位・プロポ・エントリィ(address)
;	    YOUSHO_ENTRY_NO	; 総合優勝エントリィ番号
;	    YOUSHO_ENTRY	; 総合優勝エントリィ(address)
; ****************************************************

YOUSHOU_HAPPYO	PROC	NEAR

;*DBG*;	PRV	"YOUSHO_KIHIN_NO=",YOUSHO_KIHIN_NO
;*DBG*;	PRV	"YOUSHO_KIHIN   =",YOUSHO_KIHIN
;*DBG*;	PRV	"YOUSHO_IROKE_NO=",YOUSHO_IROKE_NO
;*DBG*;	PRV	"YOUSHO_IROKE   =",YOUSHO_IROKE
;*DBG*;	PRV	"YOUSHO_PROPRT_NO=",YOUSHO_PROPRT_NO
;*DBG*;	PRV	"YOUSHO_PROPRT   =",YOUSHO_PROPRT
;*DBG*;	PRV	"YOUSHO_ENTRY_NO=",YOUSHO_ENTRY_NO
;*DBG*;	PRV	"YOUSHO_ENTRY   =",YOUSHO_ENTRY

	CALL	KAKUSHOU_BORD		; 各賞発表ボード


	; 気品
	SELECT	"「太陽の神賞」は"

	MOV	VEW_POSI_NUM,1		; 表示位置 0:左上,1:右上,2:左下,3:右下
	MOV	BUMON_NUMBER,1		; 部門 1=気品
	MOVX	ENTRY_ADRS,YOUSHO_KIHIN	; 部門別１位・気品エントリィ(address)
	MOVX	ENTRY_PNT,YOUSHO_KIHIN_NO ; 部門別１位・気品エントリィ番号
	CALL	GIRL_SPEC_VIEW		; 人物スペックＶＩＥＷ

	MOV	AX,YOUSHO_KIHIN		; 部門別１位・気品エントリィ(address)
	MOV	DX,1			; 1=「太陽の神賞」
	MOV	CX,TOK_KIHIN		; 投票数・気品
	MOV	S_FUNC,72		; 72=収穫祭等の評価
	CALL	R_KEISAN		; 各計算処理


	; プロポーション
	SELECT	"「月の神賞」は"

	MOV	VEW_POSI_NUM,2		; 表示位置 0:左上,1:右上,2:左下,3:右下
	MOV	BUMON_NUMBER,2		; 部門 2=プロポーション
	MOVX	ENTRY_ADRS,YOUSHO_PROPRT ; 部門別１位・プロポ・エントリィ(addr)
	MOVX	ENTRY_PNT,YOUSHO_PROPRT_NO ; 部門別１位・プロポ・エントリィ番号
	CALL	GIRL_SPEC_VIEW		; 人物スペックＶＩＥＷ

	MOV	AX,YOUSHO_PROPRT	; 部門別１位・プロポ・エントリ(address)
	MOV	DX,2			; 2=「月の神賞」
	MOV	CX,TOK_PROPRT		; 投票数・プロポー
	MOV	S_FUNC,72		; 72=収穫祭等の評価
	CALL	R_KEISAN		; 各計算処理


	; 色気
	SELECT	"「星の神賞」は"

	MOV	VEW_POSI_NUM,3		; 表示位置 0:左上,1:右上,2:左下,3:右下
	MOV	BUMON_NUMBER,3		; 部門 3=色気
	MOVX	ENTRY_ADRS,YOUSHO_IROKE	; 部門別１位・色気エントリィ(address)
	MOVX	ENTRY_PNT,YOUSHO_IROKE_NO ; 部門別１位・色気エントリィ番号
	CALL	GIRL_SPEC_VIEW		; 人物スペックＶＩＥＷ

	MOV	AX,YOUSHO_IROKE		; 部門別１位・色気エントリィ(address)
	MOV	DX,3			; 3=「星の神賞」
	MOV	CX,TOK_IROKE		; 投票数・色気
	MOV	S_FUNC,72		; 72=収穫祭等の評価
	CALL	R_KEISAN		; 各計算処理


	; 総合優勝
	SELECT	"そして「ミス王国」は"

	MOV	VEW_POSI_NUM,0		; 表示位置 0:左上,1:右上,2:左下,3:右下
	MOV	BUMON_NUMBER,4		; 部門 4=総合優勝
	MOVX	ENTRY_ADRS,YOUSHO_ENTRY	; 総合優勝エントリィ(address)
	MOVX	ENTRY_PNT,YOUSHO_ENTRY_NO ; 総合優勝エントリィ番号
	CALL	GIRL_SPEC_VIEW		; 人物スペックＶＩＥＷ

	MOV	AX,YOUSHO_ENTRY		; 総合優勝エントリィ(address)
	MOV	DX,4			; 4=「ミス王国」
	MOV	CX,TOK_GOUKEI		; 投票数・合計
	MOV	S_FUNC,72		; 72=収穫祭等の評価
	CALL	R_KEISAN		; 各計算処理

	RET
YOUSHOU_HAPPYO	ENDP


; ****************************************************
;	人物スペックＶＩＥＷ
;	-I- VEW_POSI_NUM : スペックＶＩＥＷ位置 0:左上,1:右上,2:左下,3:右下
;	    BUMON_NUMBER : 部門 1=気品,2=プロポーション,3=色気,4=総合優勝
;	    ENTRY_ADRS   : エントリ・アドレス
;	    ENTRY_PNT    : エントリ・ポインター
;	-O- TOK_KIHIN  : 投票数・気品
;	    TOK_IROKE  : 投票数・色気
;	    TOK_PROPRT : 投票数・プロポー
;	    TOK_GOUKEI : 投票数・合計
; ****************************************************

GIRL_SPEC_VIEW	PROC	NEAR
	MOV	DX,VEW_POSI_NUM		; 位置 0:左上,1:右上,2:左下,3:右下
	ADD	DX,3			; ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ

	MOV	BX,VEW_POSI_NUM		; スペックＶＩＥＷ位置
	MOVXBW	PR_DSPXX_BS,DS:VEW_POSI_XX_TBL[BX] ; (byte)スペックＶＷ位置Ｘ
	MOVXBW	PR_DSPYY_BS,DS:VEW_POSI_YY_TBL[BX] ; (byte)スペックＶＷ位置Ｙ

	MOVX	PR_DSPXX,PR_DSPXX_BS	; 表示Ｘ位置ベース
	MOVX	PR_DSPYY,PR_DSPYY_BS	; 表示Ｙ位置ベース
	ADDX	PR_DSPXX,VEW_OFS_VV_XX	; スペック値のオフセット位置Ｘ
	ADDX	PR_DSPYY,VEW_OFS_VV_YY	; スペック値のオフセット位置Ｙ
	CALL	MISS_HAPPYO		; 発表

	; フェイス先読み

	MOV	BX,ENTRY_PNT		; エントリ・ポインター
	MOVXBW	DX,DS:MISS_ENTRY_TABLE[BX] ; (byte)ミスコン・エントリー
	MOVX	WDXX,PR_DSPXX_BS	; 表示Ｘ位置ベース
	MOVX	WDYY,PR_DSPYY_BS	; 表示Ｙ位置ベース
	ADDX	WDXX,VEW_OFS_FC_XX	; スペック顔のオフセット位置Ｘ
	ADDX	WDYY,VEW_OFS_FC_YY	; スペック顔のオフセット位置Ｙ
	MOV	AX,0			; 出力形態 0=名前出さない,1=名前出す
	CALL	WIDFACE_LOAD_M_ONLY	; WINDOWS/ミスコンフェイスＬＯＡＤ

	CALL	MISS_HAPPYO_NAME	; 名前発表

	MOVX	PR_DSPXX,PR_DSPXX_BS	; 表示Ｘ位置ベース
	MOVX	PR_DSPYY,PR_DSPYY_BS	; 表示Ｙ位置ベース
	ADDX	PR_DSPXX,VEW_OFS_VL_XX	; 内容値のオフセット位置Ｘ
	ADDX	PR_DSPYY,VEW_OFS_VL_YY	; 内容値のオフセット位置Ｙ

	PUSH	WIDOFS_GRP		; グラフテーブルオフセット
	PUSH	WIDMAX_GRP		; グラフテーブルレコード数
	PUSH	WIDOFS_VAL		; 内容表示テーブルオフセット
	PUSH	WIDMAX_VAL		; 内容表示テーブルレコード数

	MOVX	WIDOFS_GRP,WIDOFS_GP_TK	; 敵・グラフテーブルオフセット
	MOVX	WIDMAX_GRP,WIDMAX_GP_TK	; 敵・グラフテーブルレコード数
	MOVX	WIDOFS_VAL,WIDOFS_VL_TK	; 敵・内容表示オフセット
	MOVX	WIDMAX_VAL,WIDMAX_VL_TK	; 敵・内容表示レコード数

	CALL	SEIZA_AND_KETSUEKI	; 星座＆血液型
	ADD	PR_DSPYY,32		; ＋３２

	MOV	WDVNO,4			; 4. 年齢
	MOVX	WDXX,PR_DSPXX		; 表示Ｘ位置
	MOVX	WDYY,PR_DSPYY		; 表示Ｙ位置
	CALL	WIDVAL_DP		; WINDOWS/内容表示・ウインドウ外指定
	ADD	PR_DSPYY,16		; ＋１６
	MOV	WDVNO,5			; 5. 身長
	MOVX	WDXX,PR_DSPXX		; 表示Ｘ位置
	MOVX	WDYY,PR_DSPYY		; 表示Ｙ位置
	CALL	WIDVAL_DP		; WINDOWS/内容表示・ウインドウ外指定
	ADD	PR_DSPYY,16		; ＋１６

	MOVX	WDXX,PR_DSPXX		; 表示Ｘ位置
	SUBX	WDXX,8			; －８
	MOVX	WDYY,PR_DSPYY		; 表示Ｙ位置

	MOV	WDGNO,3			; 3. 気品
	CALL	WIDHBR_DP		; WINDOWS/横グラフ表示ウインドウ外指定
	ADD	WDYY,16			; ＋１６
	MOV	WDGNO,6			; 6. 色気
	CALL	WIDHBR_DP		; WINDOWS/横グラフ表示ウインドウ外指定

;*;	ADDX	WDXX,2			; ＋２
	MOVX	YY1,PR_DSPYY		;
	ADDX	YY1,32			; ＋３２

	MOVE_IMG	ARAVRM,ARAVRM,WDXX,PR_DSPYY,20,32,PR_DSPXX,YY1

	MOV	WDVNO,6			; 6. 体重
	MOVX	WDXX,PR_DSPXX		; 表示Ｘ位置
	MOVX	WDYY,PR_DSPYY		; 表示Ｙ位置
	CALL	WIDVAL_DP		; WINDOWS/内容表示・ウインドウ外指定
	ADD	PR_DSPYY,16		; ＋１６
	MOV	WDVNO,7			; 7. プロポー
	MOVX	WDXX,PR_DSPXX		; 表示Ｘ位置
	MOVX	WDYY,PR_DSPYY		; 表示Ｙ位置
	CALL	WIDVAL_DP		; WINDOWS/内容表示・ウインドウ外指定
	ADD	PR_DSPYY,16		; ＋１６

	; フェイス

	CALL	WIDFACE_PUT_M_ONLY	; WINDOWS/ミスコンフェイスＰＵＴ

	; 得票数

	MOVX	FREAM_XX_T,PR_DSPXX_BS	; 表示Ｘ位置ベース
	MOVX	FREAM_YY_T,PR_DSPYY_BS	; 表示Ｙ位置ベース
	ADD	FREAM_XX_T,40-10	; 表示Ｘ位置
	ADD	FREAM_YY_T,16*3+8+2	; 表示Ｙ位置

	MOV	SI,OFFSET FREAM_STRUCT_T ; ウインドウフレーム定義体/得票
	MOV	BX,OFFSET DISP_UNIT_TOKU ; ウインドウ表示単体定義体/得票
	CALL	WIDMINI_STRC		; WINDOWS/ミニウインドウ定義体の設定
	CALL	WIDMINI_FRM		; WINDOWS/ミニウインドウフレーム表示

	MOV	AX,0			; 表示番号
	MOV	CL,0			;
	MOV	DX,OFFSET DISP_UNIT_TOKU_MSG ; "total"
	CALL	DISP_ONE		; １個表示

	MOV	SI,ENTRY_PNT		; エントリ・ポインター
	SHL	SI,1			; word pointer.
	MOV	AX,DS:TOHYO_KIHIN[SI]	; 投票・気品
	MOV	BX,DS:TOHYO_IROKE[SI]	; 投票・色気
	MOV	CX,DS:TOHYO_PROPRT[SI]	; 投票・プロポー
	MOV	DX,DS:TOHYO_GOUKEI[SI]	; 投票・合計
	MOV	TOK_KIHIN,AX		; 投票数・気品
	MOV	TOK_IROKE,BX		; 投票数・色気
	MOV	TOK_PROPRT,CX		; 投票数・プロポー
	MOV	TOK_GOUKEI,DX		; 投票数・合計

	CALL	TOKU_DISP		; 得票表示

	POP	WIDMAX_VAL		; 内容表示テーブルレコード数
	POP	WIDOFS_VAL		; 内容表示テーブルオフセット
	POP	WIDMAX_GRP		; グラフテーブルレコード数
	POP	WIDOFS_GRP		; グラフテーブルオフセット

	RET
GIRL_SPEC_VIEW	ENDP


; ****************************************************
;	星座＆血液型
;	-I- WIDOFS_VAL : 敵・内容表示オフセット
;	    PR_DSPXX   : 表示Ｘ位置
;	    PR_DSPYY   : 表示Ｙ位置
; ****************************************************

SEIZA_AND_KETSUEKI	PROC	NEAR
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	BX,WIDOFS_VAL		; 敵・内容表示オフセット
	MOV	CX,ES:[BX][VAL_VALUE][VTB_KETUEKI]	; 血液型
	MOV	DX,ES:[BX][VAL_VALUE][VTB_SEIZA]	; 星座
	MOV	AX,PR_DSPXX		; 表示Ｘ位置
	MOV	BX,PR_DSPYY		; 表示Ｙ位置
	CALL	WIDHED_XSEIZA		; WINDOWS/星座表示
	RET
SEIZA_AND_KETSUEKI	ENDP



; ****************************************************
;	発表
;	-I- BUMON_NUMBER : 部門 1=気品,2=プロポーション,3=色気,4=総合優勝
;	    ENTRY_ADRS   : エントリ・アドレス
;	    ENTRY_PNT    : エントリ・ポインター
;	    PR_DSPXX   : 表示Ｘ位置
;	    PR_DSPYY   : 表示Ｙ位置
; ****************************************************

MISS_HAPPYO	PROC	NEAR
	MOVX	TXTXX,PR_DSPXX		; 表示Ｘ位置
	MOVX	TXTYY,PR_DSPYY		; 表示Ｙ位置

	MOV	AX,TXTXX		; ＰＵＴ　Ｘ座標
	MOV	BX,TXTYY		; ＰＵＴ　Ｙ座標
	ADD	BX,2			; ＋２

	CMP	BUMON_NUMBER,1		; 1=気品部門
	JE	MISS_HAPPYO_01		;
	CMP	BUMON_NUMBER,2		; 2=プロポーション部門
	JE	MISS_HAPPYO_02		;
	CMP	BUMON_NUMBER,3		; 3=色気部門
	JE	MISS_HAPPYO_03		;
	CMP	BUMON_NUMBER,4		; 4=総合優勝
	JE	MISS_HAPPYO_04		;

MISS_HAPPYO_01:
	MOV	DX,3*2			; 太陽の神賞
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	JMP	MISS_HAPPYO_05		;
MISS_HAPPYO_02:
	MOV	DX,1*2			; 月の神賞
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	JMP	MISS_HAPPYO_05		;
MISS_HAPPYO_03:
	MOV	DX,5*2			; 星の神賞
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	JMP	MISS_HAPPYO_05		;
MISS_HAPPYO_04:
	MOV	DX,7*2			; ミス王国
	CALL	PT_SYUKAK_MPT		; 収穫祭マスクパターンＰＵＴ
	JMP	MISS_HAPPYO_05		;
MISS_HAPPYO_05:
;*;	MOVX	ES,DS			;
;*;	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
;*;	MOV	CX,MSG_HAPPYO_N_LEN 	; 名前長さ
;*;	CALL	STRSETZ			; 文字列バッファセット
;*;
;*;	CALL	SPEC_STR		; スペック文字表示

	RET
MISS_HAPPYO	ENDP


; ****************************************************
;	名前発表
;	-I- BUMON_NUMBER : 部門 1=気品,2=プロポーション,3=色気,4=総合優勝
;	    ENTRY_ADRS   : エントリ・アドレス
;	    ENTRY_PNT    : エントリ・ポインター
;	    PR_DSPXX   : 表示Ｘ位置
;	    PR_DSPYY   : 表示Ｙ位置
; ****************************************************

MISS_HAPPYO_NAME	PROC	NEAR
	MOVX	TXTXX,PR_DSPXX		; 表示Ｘ位置
	MOVX	TXTYY,PR_DSPYY		; 表示Ｙ位置

	ADD	TXTYY,32-2		; 表示Ｙ位置

	; 名前

	CALL	STRZEROC		; 文字列バッファ０クリア

	MOVX	R_SR_CHR_ADRS,ENTRY_ADRS ; エントリ・アドレス
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; 名前長さ
	CALL	R_SR_GIRL_FULNAMGET	; キャラクタ名+姓ＧＥＴ

	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,20			; 表示名前の最長
	CALL	KANJITUME		; 漢字文字詰め処理

	CALL	SPEC_STR		; スペック文字表示
	ADD	TXTYY,16		; 表示Ｙ位置

;*;	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
;*;	MOV	BX,ENTRY_ADRS		; エントリ・アドレス
;*;	MOV	SI,ES:[BX][HED_NAME]	; SI=名
;*;
;*;	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
;*;	MOV	CX,MSG_HAPPYO_N_LEN 	; 名前長さ
;*;	CALL	STRSETZ			; 文字列バッファセット
;*;
;*;	CALL	SPEC_STR		; スペック文字表示
;*;	ADD	TXTYY,16		; 表示Ｙ位置
;*;
;*;	; 姓
;*;
;*;	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
;*;	MOV	BX,ENTRY_ADRS		; エントリ・アドレス
;*;	MOV	SI,ES:[BX][HED_FNAME]	; SI=姓
;*;
;*;	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
;*;	MOV	CX,MSG_HAPPYO_N_LEN 	; 名前長さ
;*;	CALL	STRSETZ			; 文字列バッファセット
;*;
;*;	CALL	SPEC_STR		; スペック文字表示
;*;	ADD	TXTYY,16		; 表示Ｙ位置
;*;
;*;	; 各パラメータ
;*;
;*;	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
;*;	MOV	BX,ENTRY_ADRS			; エントリ・アドレス
;*;	MOV	SI,ES:[BX][HED_GR_OFS]		; グラフテーブルオフセット
;*;	MOV	DI,ES:[BX][HED_VA_OFS]		; 内容表示テーブルオフセット
;*;
;*;	MOV	AX,ES:[SI][GTB_KIHIN][GRP_VALUE] ; 3. 気品／グラフテーブル
;*;	MOV	CX,ES:[SI][GTB_IROKE][GRP_VALUE] ; 6. 色気／グラフテーブル
;*;	MOV	DX,ES:[DI][VTB_PROPRT][VAL_VALUE];7.プロポー／内容表示テーブル
;*;
;*;	MOV	PRM_KIHIN,AX		; 3. 気品／グラフテーブル
;*;	MOV	PRM_IROKE,CX		; 6. 色気／グラフテーブル
;*;	MOV	PRM_PROPRT,DX		; 7. プロポー／内容表示テーブル
;*;
;*;	MOVX	PR_DSPXX,TXTXX		; 表示Ｘ位置
;*;	MOVX	PR_DSPYY,TXTYY		; 表示Ｙ位置
;*;	MOV	PARA_D_MODE,111B	; bit0:気品,bit1:プロポ,bit2:色気
;*;	CALL	PARA_DISP		; パラメータ表示
;*;


	RET
MISS_HAPPYO_NAME	ENDP


; ****************************************************
;	優勝計算
;	-I- TOHYO_KIHIN		; 投票・気品
;	    TOHYO_IROKE		; 投票・色気
;	    TOHYO_PROPRT	; 投票・プロポー
;	-O- TOHYO_GOUKEI	; 投票・合計
;	    YOUSHO_KIHIN_NO	; 部門別１位・気品エントリィ番号
;	    YOUSHO_KIHIN	; 部門別１位・気品エントリィ(address)
;	    YOUSHO_IROKE_NO	; 部門別１位・色気エントリィ番号
;	    YOUSHO_IROKE	; 部門別１位・色気エントリィ(address)
;	    YOUSHO_PROPRT_NO	; 部門別１位・プロポ・エントリィ番号
;	    YOUSHO_PROPRT	; 部門別１位・プロポ・エントリィ(address)
;	    YOUSHO_ENTRY_NO	; 総合優勝エントリィ番号
;	    YOUSHO_ENTRY	; 総合優勝エントリィ(address)
; ****************************************************

YOUSHO_KEISAN	PROC	NEAR

	; (1) 得票合計計算

	MOV	SI,OFFSET TOHYO_KIHIN	; 投票・気品
	MOV	DI,OFFSET TOHYO_IROKE	; 投票・色気
	MOV	BX,OFFSET TOHYO_PROPRT	; 投票・プロポー
	MOV	CX,OFFSET TOHYO_GOUKEI	; 投票・合計（求めるもの）
	MOV	S_FUNC,38		; 38=ミスコン投票合計計算
	CALL	R_KEISAN		; 各計算処理

	; (2) 気品部門

	MOV	DX,1			; 部門 1=気品部門
	MOV	SI,OFFSET TOHYO_KIHIN	; 投票・気品
	MOV	S_FUNC,37		; 37=ミスコン投票ソーティング
	CALL	R_KEISAN		; 各計算処理
	MOVX	YOUSHO_KIHIN_NO,DS:[DI][0] ; 部門別１位・気品エントリィ番号

	; (3) プロポーション部門

	MOV	DX,2			; 部門 2=プロポーション部門
	MOV	SI,OFFSET TOHYO_PROPRT	; 投票・プロポー
	MOV	S_FUNC,37		; 37=ミスコン投票ソーティング
	CALL	R_KEISAN		; 各計算処理
	MOVX	YOUSHO_PROPRT_NO,DS:[DI][0] ; 部門別１位・プロポ・エントリ番号

	; (4) 色気部門

	MOV	DX,3			; 部門 3=色気部門
	MOV	SI,OFFSET TOHYO_IROKE	; 投票・色気
	MOV	S_FUNC,37		; 37=ミスコン投票ソーティング
	CALL	R_KEISAN		; 各計算処理
	MOVX	YOUSHO_IROKE_NO,DS:[DI][0] ; 部門別１位・色気エントリィ番号

	; (5) 総合優勝エントリィ番号

	MOV	DX,4			; 部門 4=合計
	MOV	SI,OFFSET TOHYO_GOUKEI	; 投票・合計
	MOV	S_FUNC,37		; 37=ミスコン投票ソーティング
	CALL	R_KEISAN		; 各計算処理
	MOVX	YOUSHO_ENTRY_NO,DS:[DI][0] ; 総合優勝エントリィ番号


	MOV	BX,YOUSHO_KIHIN_NO	; 部門別１位・気品エントリィ番号
	SHL	BX,1			; word pointer.
	MOV	AX,DS:MISS_ADRS_TABLE[BX] ; ミスコン・出場者アドレス
	MOV	YOUSHO_KIHIN,AX		; 部門別１位・気品エントリィ(address)

	MOV	BX,YOUSHO_PROPRT_NO	; 部門別１位・プロポ・エントリ番号
	SHL	BX,1			; word pointer.
	MOV	AX,DS:MISS_ADRS_TABLE[BX] ; ミスコン・出場者アドレス
	MOV	YOUSHO_PROPRT,AX	; 部門別１位・プロポ・エントリィ(adrs)

	MOV	BX,YOUSHO_IROKE_NO	; 部門別１位・色気エントリィ番号
	SHL	BX,1			; word pointer.
	MOV	AX,DS:MISS_ADRS_TABLE[BX] ; ミスコン・出場者アドレス
	MOV	YOUSHO_IROKE,AX		; 部門別１位・色気エントリィ(address)

	MOV	BX,YOUSHO_ENTRY_NO	; 総合優勝エントリィ番号
	SHL	BX,1			; word pointer.
	MOV	AX,DS:MISS_ADRS_TABLE[BX] ; ミスコン・出場者アドレス
	MOV	YOUSHO_ENTRY,AX		; 総合優勝エントリィ(address)

	RET
YOUSHO_KEISAN	ENDP



; ****************************************************
;	投票スタート・ＭＡＩＮ
;	-O- AX : 0=投票,1=買収
; ****************************************************

TOUHYOU_ST_MAIN	PROC	NEAR

TOUHYOU_ST_MAIN_LOOP:
	SELECT	"投票のスタート,審査員を買収する"

	CMP	WIDSNM,0			; ユーザ選択番号
	JMPEQ	TOUHYOU_ST_MAIN_TOUHYOH		;
	CMP	WIDSNM,1			; ユーザ選択番号
	JMPEQ	TOUHYOU_ST_MAIN_BAISYU		;
	CMP	WIDSNM,OFFF			; ユーザ選択番号
	JMPEQ	TOUHYOU_ST_MAIN_LOOP		;

TOUHYOU_ST_MAIN_TOUHYOH:			; 投票
	MOV	AX,0				; 0=投票
	JMP	TOUHYOU_ST_MAIN_EXIT		;
TOUHYOU_ST_MAIN_BAISYU:				; 買収
	MOV	AX,1				; 1=買収
TOUHYOU_ST_MAIN_EXIT:
	RET
TOUHYOU_ST_MAIN	ENDP


; ****************************************************
;	投票・ＭＡＩＮ
;	-I- BUMON_NUMBER : 部門 1=気品部門,2=プロポーション部門,3=色気部門
;	    TOHYO_VAL_ADRS : 投票基準値アドレス(気品,色気,プ)
;	    TOHYO_ADRS     : 投票中アドレス
;	    BAISYU_NIN     : 買収人数
;	    BAISYU_ENTRY   : 買収エントリーＮｏ．
;	-O- [TOHYO_ADRS]   : 投票
;
;	得票数＝（（１０００－買収人数）÷全員気品）× 自分の気品
; ****************************************************

TOUHYOU_MAIN	PROC	NEAR

	; 各自の得票数

	MOVX	ES,DS			;
	MOV	SI,TOHYO_VAL_ADRS	; 投票基準値アドレス
	MOV	DI,TOHYO_ADRS		; 投票中アドレス
	MOV	CX,10			;
	REP	MOVSW			;

	CMP	BUMON_NUMBER,2		; 2=プロポーション部門
	JNE	TOUHYOU_MAIN_2		;
	MOV	DI,TOHYO_ADRS		; 投票中アドレス
	MOV	CX,10			;
TOUHYOU_MAIN_1:				;
	CMP	WORD PTR DS:[DI],100	;
	JBE	TOUHYOU_MAIN_12		; if ds:[di] > 100 then
	SUB	WORD PTR DS:[DI],100	;
	NEG	WORD PTR DS:[DI]	;
	ADD	WORD PTR DS:[DI],100	;
TOUHYOU_MAIN_12:			;
	INC	DI			;
	INC	DI			; word pointer.
	LOOP	TOUHYOU_MAIN_1		;
TOUHYOU_MAIN_2:				;

	; 投票合計を（１０００－買収人数）に合わせる

TOUHYOU_MAIN_LOOP:
	MOV	GOUKEI_LOW,0		; (low word)合計
	MOV	GOUKEI_HI,0		; (hi  word)合計
	MOV	BX,TOHYO_ADRS		; 投票中アドレス
	MOV	CX,10			; １０
TOUHYOU_MAIN_ALL:			;
	ADDX	GOUKEI_LOW,DS:[BX]	; (low word)合計	合計
	ADC	GOUKEI_HI,0		; (hi  word)合計
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	TOUHYOU_MAIN_ALL	;

;*;	PRV	"-1- GOUKEI_LOW=",GOUKEI_LOW

	CMP	GOUKEI_HI,0		; (hi  word)合計
	JNE	TOUHYOU_MAIN_NEXT	;

	MOV	DX,1000			; DX=（１０００－買収人数）
	SUB	DX,BAISYU_NIN		;

	CMP	GOUKEI_LOW,DX		; (low word)合計 人数以下ならば
	JBE	TOUHYOU_MAIN_LOOP_END	;

TOUHYOU_MAIN_NEXT:
	MOV	BX,TOHYO_ADRS		; 投票中アドレス
	MOV	CX,10			; １０
TOUHYOU_MAIN_ALL2:			;
	SHR	WORD PTR DS:[BX],1	; / 2
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	TOUHYOU_MAIN_ALL2	;

	JMP	TOUHYOU_MAIN_LOOP	;
TOUHYOU_MAIN_LOOP_END:



	; 投票合計を（１０００－買収人数）に到達させる

TOUHYOU_MAIN_LOOP2:
	MOV	GOUKEI_LOW,0		; 合計
	MOV	BX,TOHYO_ADRS		; 投票中アドレス
	MOV	CX,10			; １０
TOUHYOU_MAIN_ALL_3:			;
	ADDX	GOUKEI_LOW,DS:[BX]	; 合計
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	TOUHYOU_MAIN_ALL_3	;

;*;	PRV	"-2- GOUKEI_LOW=",GOUKEI_LOW

	MOV	DX,1000			; DX=（１０００－買収人数）
	SUB	DX,BAISYU_NIN		;

	CMP	GOUKEI_LOW,DX		; 合計
	JE	TOUHYOU_MAIN_LOOP_END_2	;

	SUB	DX,GOUKEI_LOW		; DX=差

	MOV	BX,TOHYO_ADRS		; 投票中アドレス
	MOV	CX,10			; １０
	CMP	CX,DX			; 差が１０以下ならば
	JBE	TOUHYOU_MAIN_ALL_4	;
	MOV	CX,DX			;
TOUHYOU_MAIN_ALL_4:			;
	INC	WORD PTR DS:[BX]	; + 1
	INC	BX			;
	INC	BX			; word pointer.
	LOOP	TOUHYOU_MAIN_ALL_4	;

	JMP	TOUHYOU_MAIN_LOOP2	;
TOUHYOU_MAIN_LOOP_END_2:


	; 買収加算

	MOV	BX,BAISYU_ENTRY		; 買収エントリーＮｏ．
	SHL	BX,1			; word pointer.
	ADD	BX,TOHYO_ADRS		; 投票中アドレス
	ADDX	DS:[BX],BAISYU_NIN	; 買収人数


	MOV	BX,TOHYO_ADRS		; 投票中アドレス
	MOV	CX,10
TOUHYOU_MAIN_66:
;*;	PRV	"投票結果",DS:[BX]
	INC	BX
	INC	BX
	LOOP	TOUHYOU_MAIN_66

TOUHYOU_MAIN_EXIT:
	RET
TOUHYOU_MAIN	ENDP


; ****************************************************
;	買収・ＭＡＩＮ
;	-I- BUMON_NUMBER : 部門 1=気品部門,2=プロポーション部門,3=色気部門
;	-O- BAISYU_NIN   : 買収人数
;	    BAISYU_KIHIN : 買収人数・気品
;	    BAISYU_IROKE : 買収人数・色気
;	    BAISYU_PROPRT: 買収人数・プロポー
; ****************************************************

BAISYU_MAIN	PROC	NEAR
	MOV	BAISYU_NIN,0			; 買収人数

	CALL	PURCHASE			; 買収工作
	CMP	AX,0				; 0=買収をやめる,1=買収決定
	JMPEQ	BAISYU_MAIN_EXIT		;

	CALL	BAISHO_KANOU			; 所持金と買収可能の計算
	CMP	AX,0				; 0=買収をやめる,1=買収決定
	JMPEQ	BAISYU_MAIN_EXIT		;

	MOV	DX,BAISYU_NIN			; 買収人数

	CMP	BUMON_NUMBER,1			; 1=気品部門
	JE	BAISYU_MAIN_01			;
	CMP	BUMON_NUMBER,2			; 2=プロポーション部門
	JE	BAISYU_MAIN_02			;
	CMP	BUMON_NUMBER,3			; 3=色気部門
	JE	BAISYU_MAIN_03			;
BAISYU_MAIN_01:
	MOV	BAISYU_KIHIN,DX			; 買収人数・気品
	JMP	BAISYU_MAIN_04			;
BAISYU_MAIN_02:
	MOV	BAISYU_IROKE,DX			; 買収人数・色気
	JMP	BAISYU_MAIN_04			;
BAISYU_MAIN_03:
	MOV	BAISYU_PROPRT,DX		; 買収人数・プロポー
BAISYU_MAIN_04:

BAISYU_MAIN_EXIT:
	RET
BAISYU_MAIN	ENDP


; ****************************************************
;	買収工作
;	-O- AX         : 0=買収をやめる,1=買収決定
;	    BAISYU_NIN : 買収人数
; ****************************************************

PURCHASE	PROC	NEAR
	MOV	BAISYU_NIN,0		; 買収人数

PURCHASE_LOOP:
	MOV	AX,DS			; テキストバッファセグメント
	MOV	ES,AX			;
	MOV	BX,OFFSET SELECT_BAYSYU	; 表示単語アドレス
	CALL	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）

	CMP	WIDSNM,0		; ユーザ選択番号
	JE	PURCHASE_YAMERUKA	;
	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JE	PURCHASE_YAMERUKA	;

	MOV	BX,WIDSNM		; ユーザ選択番号
	SHL	BX,1			; word pointer.
	MOVX	BAISYU_NIN,DS:SELECT_BAYSYU_NINZU[BX]	; 買収人数

	JMP	PURCHASE_OK		;

PURCHASE_YAMERUKA:
	SELECT	"やめるんですね,やっぱりする！"
	CMP	WIDSNM,0		; ユーザ選択番号
	JE	PURCHASE_YAME		;
	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JE	PURCHASE_YAME		;

	JMP	PURCHASE_LOOP

PURCHASE_OK:
	MOV	AX,1			; 1=買収決定
	RET
PURCHASE_YAME:
	MOV	AX,1			; 0=買収をやめる
	RET
PURCHASE	ENDP


; ****************************************************
;	所持金と買収可能の計算	
;	-I/O- BAISYU_NIN : 買収人数
;	-O-   AX         : 0=買収をやめる,1=買収決定
; ****************************************************

BAISHO_KANOU	PROC	NEAR
	MOV	AX,BAISYU_NIN		; 買収人数
	MOV	DX,0			;
	MOV	BX,10			;
	MUL	BX			; * 10
	MOV	BAISYU_MONEY,AX		; 買収予定額 ＝ 買収人数 ＊ １０

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,34		; 34=お金見る
	CALL	R_KEISAN		; 各計算処理
	MOV	BAISYU_SHOJIKN,DX	; 所持金

	CMP	BAISYU_SHOJIKN,10	; 所持金
	JNB	BAISHO_KANOU_2		;

	MOV	DX,2			; ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ

	MOV	DX,2			; ふきだし番号
	MOV	SI,OFFSET MSG_BAISYU_NS	; "と思ったが、お金がない！"
	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ

	SELECT	"わかった・・・"	;
	JMP	BAISHO_KANOU_NONE	;

BAISHO_KANOU_2:				;
	CMP	BAISYU_MONEY,DX		; 買収予定額に対し所持金は充分？
	JNB	BAISHO_KANOU_OVER	;
	JMP	BAISHO_KANOU_NICE	; ならば買収がストレートに決定

BAISHO_KANOU_OVER:
	MOV	DX,2			; ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ

	MOV	AX,BAISYU_SHOJIKN	; 所持金
	MOV	DX,0			;
	MOV	BX,10			; 所持金を１０で割れば買収可能な人数
	DIV	BX			;
	MOV	BAISYU_NIN,AX		; 買収人数
	MOV	AX,BAISYU_NIN		; 買収人数
	MOV	DX,0			;
	MOV	BX,10			;
	MUL	BX			; * 10
	MOV	BAISYU_MONEY,AX		; 買収予定額 ＝ 買収人数 ＊ １０

	MOV	DX,BAISYU_NIN		; 買収人数
	CALL	DECSTR			; dec -> string.
	CALL	STRZTS			; zero to space. "00123" - > "  123"
	CALL	STRSPL			; space pless. "  123" - > "123  "
	MOV	DI,OFFSET MSG_BAISYU_OV_M
	CALL	STR_N_HNZN		; 文字列半角を全角

	MOV	DI,OFFSET MSG_BAISYU_OV_M ; 文字列
	MOV	SI,OFFSET MSG_BAISYU_OV_N ; 連結する文字列 "人までです。"
	CALL	ADDSTRSET		; 文字列の連結

	MOV	DX,2			; ふきだし番号
	MOV	SI,OFFSET MSG_BAISYU_OV	; "手元のお金で買収出来る人数は"
	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ


	MOV	AX,DS			; テキストバッファセグメント
	MOV	ES,AX			;
	MOV	BX,OFFSET SELECT_BAYSYU_RETRY
	CALL	WIDSLC2			; WINDOWS/セレクト・ｳｲﾝﾄﾞｳ（簡易指定）

	CMP	WIDSNM,0		; ユーザ選択番号
	JE	BAISHO_KANOU_ARUDAKE	; あるだけのお金を使う
	CMP	WIDSNM,1		; ユーザ選択番号
	JMPEQ	BAISHO_KANOU_NONE	;
	CMP	WIDSNM,OFFF		; ユーザ選択番号
	JMPEQ	BAISHO_KANOU_NONE	;

BAISHO_KANOU_ARUDAKE:			; あるだけのお金を使う
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元
;*;	MOV	DX,2			; ふきだし番号
;*;	CALL	WIDFUKI_CLOSE		; WINDOWS/ふきだしウインドウＣＬＯＳＥ

	MOV	DX,BAISYU_MONEY		; 買収予定額
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,35		; 35=お金払う
	CALL	R_KEISAN		; 各計算処理
	MOV	AX,1			; 1=買収決定
	RET


BAISHO_KANOU_NICE:			; 買収がストレートに決定
	MOV	DX,BAISYU_MONEY		; 買収予定額
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	S_FUNC,35		; 35=お金払う
	CALL	R_KEISAN		; 各計算処理
	MOV	AX,1			; 1=買収決定
	RET

BAISHO_KANOU_NONE:
	CALL	WIDDSP_LD_F		; WINDOWS/画面フル復元
;*;	MOV	DX,2			; ふきだし番号
;*;	CALL	WIDFUKI_CLOSE		; WINDOWS/ふきだしウインドウＣＬＯＳＥ

	MOV	BAISYU_NIN,0		; 買収人数

	MOV	AX,0			; 0=買収をやめる
	RET
BAISHO_KANOU	ENDP


; ****************************************************
;	予想発表・ＭＡＩＮ
;	-I- BUMON_NUMBER : 部門 1=気品部門,2=プロポーション部門,3=色気部門
; ****************************************************

YOSOU_HAPPYO_MAIN	PROC	NEAR
;*;	SELECT	"予想発表"

	MOV	DX,1			; ふきだし番号
	CALL	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ

	CALL	YOSOU_NEWS		; 予想記事作成

	MOV	DX,1			; ふきだし番号
	MOV	SI,OFFSET MSG_NEWS	;
	CALL	WIDFUKI			; WINDOWS/ふきだしウインドウ

	SELECT	"よいですか？"

	MOV	DX,1			; ふきだし番号
	CALL	WIDFUKI_CLOSE		; WINDOWS/ふきだしウインドウＣＬＯＳＥ

	RET
YOSOU_HAPPYO_MAIN	ENDP


; ****************************************************
;	予想記事作成
;	-I- BUMON_NUMBER    : 部門 1=気品部門,2=プロポーション部門,3=色気部門
;	-O- MSG_NEWS        : 予想記事作成
;	    MYOSOU_HONME_NO : 予想エントリＮｏ． 0:本命
;	    MYOSOU_TAIKO_NO : 予想エントリＮｏ． 1:対抗
;	    MYOSOU_ANA_NO   : 予想エントリＮｏ． 2:穴
; ****************************************************

YOSOU_NEWS	PROC	NEAR
	CMP	BUMON_NUMBER,1		; 1=気品部門
	JE	YOSOU_NEWS_01		;
	CMP	BUMON_NUMBER,2		; 2=プロポーション部門
	JE	YOSOU_NEWS_02		;
	CMP	BUMON_NUMBER,3		; 3=色気部門
	JE	YOSOU_NEWS_03		;
YOSOU_NEWS_01:
	MOV	SI,OFFSET MSG_TTL_1	; "気　品　部　門　"
	JMP	YOSOU_NEWS_04		;
YOSOU_NEWS_02:
	MOV	SI,OFFSET MSG_TTL_2	; "プロポｰシｮン部門"
	JMP	YOSOU_NEWS_04		;
YOSOU_NEWS_03:
	MOV	SI,OFFSET MSG_TTL_3	; "色　気　部　門　"
YOSOU_NEWS_04:
	MOVX	ES,DS			;
	MOV	DI,OFFSET MSG_NEWS_TITLE
	MOV	CX,MSG_NEWS_N_LEN	; 名前長さ
	CALL	STRSET			; 文字列バッファセット

	MOV	BX,OFFSET MISS_ADRS_TABLE ; ミスコン・出場者アドレス
	MOV	DX,BUMON_NUMBER		; 部門
	MOV	S_FUNC,33		; 33=ミスコン予想
	CALL	R_KEISAN		; 各計算処理


	MOV	BX,DS:[DI][0]		; 本命
	MOV	MYOSOU_HONME_NO,BX	; 予想エントリＮｏ． 0:本命
	SHL	BX,1			; word pointer.
	MOV	AX,DS:MISS_ADRS_TABLE[BX] ; ミスコン・出場者アドレス
	MOV	MYOSOU_HONME,AX		; 予想 0:本命

	MOV	BX,DS:[DI][2]		; 対抗
	MOV	MYOSOU_TAIKO_NO,BX	; 予想エントリＮｏ． 1:対抗
	SHL	BX,1			; word pointer.
	MOV	AX,DS:MISS_ADRS_TABLE[BX] ; ミスコン・出場者アドレス
	MOV	MYOSOU_TAIKO,AX		; 予想 1:対抗

	MOV	BX,DS:[DI][4]		; 穴
	MOV	MYOSOU_ANA_NO,BX	; 予想エントリＮｏ． 2:穴
	SHL	BX,1			; word pointer.
	MOV	AX,DS:MISS_ADRS_TABLE[BX] ; ミスコン・出場者アドレス
	MOV	MYOSOU_ANA,AX		; 予想 2:穴


	MOV	BX,MYOSOU_HONME		; 予想 本命
	MOV	DI,OFFSET MSG_NEWS_1	; セットするべき領域
	CALL	YOSOU_NAMEGET		; 予想名前ＧＥＴ

	MOV	BX,MYOSOU_TAIKO		; 予想 対抗
	MOV	DI,OFFSET MSG_NEWS_2	; セットするべき領域
	CALL	YOSOU_NAMEGET		; 予想名前ＧＥＴ

	MOV	BX,MYOSOU_ANA		; 予想 穴
	MOV	DI,OFFSET MSG_NEWS_3	; セットするべき領域
	CALL	YOSOU_NAMEGET		; 予想名前ＧＥＴ

	RET
YOSOU_NEWS	ENDP


; ****************************************************
;	本命，対抗，穴にしるしを表示
;	-I- MYOSOU_HONME_NO : 予想エントリＮｏ． 0:本命
;	    MYOSOU_TAIKO_NO : 予想エントリＮｏ． 1:対抗
;	    MYOSOU_ANA_NO   : 予想エントリＮｏ． 2:穴
; ****************************************************


;	    MYOSOU_HONME_NO : 予想エントリＮｏ． 0:本命
;	    MYOSOU_TAIKO_NO : 予想エントリＮｏ． 1:対抗
;	    MYOSOU_ANA_NO   : 予想エントリＮｏ． 2:穴


; ****************************************************
;	予想名前ＧＥＴ
;	-I- BX      : 人物のヘッダーアドレス
;	    DS:[DI] : セットするべき領域
; ****************************************************

YOSOU_NAMEGET	PROC	NEAR
	MOV	R_SR_CHR_ADRS,BX	; 台詞・キャラクタアドレス

	PUSH	DI			;
	MOVX	ES,DS			;
	MOV	SI,OFFSET MSG_NEWS_SPC	;
	MOV	CX,MSG_NEWS_N_LEN	; 名前長さ
;*;	CALL	STRSETZ			; 文字列バッファセット
	CALL	STRSET			; 文字列バッファセット
	POP	DI			;

	MOV	CX,MSG_NEWS_N_LEN	; 名前長さ
	CALL	R_SR_GIRL_NAMEGET	; キャラクタ名ＧＥＴ
	RET
YOSOU_NAMEGET	ENDP


; ****************************************************
;	ミスコン・登場人物
;	-I- MISS_ADRS_TABLE[]	: ミスコン・出場者アドレス
;	    MISS_KIHIN[]	: 3. 気品
;	    MISS_IROKE[]	: 6. 色気
;	    MISS_PROPRT[]	: 7. プロポー
; ****************************************************

MISS_CON_ENTRY	PROC	NEAR

	MOV	ENTRY_PNT,0		; エントリ・ポインター
	MOV	CX,MISS_ENTRY_MAX	; ミスコン・エントリー数
MISS_CON_ENTRY_LOOP:
	PUSH	CX

	MOV	BX,ENTRY_PNT		; エントリ・ポインター
	MOVXBW	DX,DS:MISS_ENTRY_TABLE[BX] ; (byte)ミスコン・エントリー
	MOVXBW	WDXX,DS:MISS_XX_TBL[BX]	; (byte)エントリー表示Ｘ
	MOVXBW	WDYY,DS:MISS_YY_TBL[BX]	; (byte)エントリー表示Ｙ
	MOV	AX,1			; 出力形態 0=名前出さない,1=名前出す
	CALL	WIDFACE_OPEN_M		; WINDOWS/ミスコンフェイスＯＰＥＮ

	MOV	AX,WIDTK_CHAR_OF	; 敵キャラクタアドレス
	MOV	BX,ENTRY_PNT		; エントリ・ポインター
	SHL	BX,1			; word pointer.
	MOV	DS:MISS_ADRS_TABLE[BX],AX ; ミスコン・出場者アドレス

	CALL	PARA_GET		; パラメータ取得

	MOV	BX,ENTRY_PNT		; エントリ・ポインター
	SHL	BX,1			; word pointer.
	MOV	AX,PRM_KIHIN		; 3. 気品
	MOV	CX,PRM_IROKE		; 6. 色気
	MOV	DX,PRM_PROPRT		; 7. プロポー
	MOV	DS:MISS_KIHIN[BX],AX	; 3. 気品
	MOV	DS:MISS_IROKE[BX],CX	; 6. 色気
	MOV	DS:MISS_PROPRT[BX],DX	; 7. プロポー

	INC	ENTRY_PNT		; エントリ・ポインター
	POP	CX
	LOOP	MISS_CON_ENTRY_LOOP

	RET
MISS_CON_ENTRY	ENDP


; ****************************************************
;	ミスコン・得票数ＯＰＥＮ
; ****************************************************

MISS_TOKU_OPEN	PROC	NEAR

	MOV	ENTRY_PNT,0		; エントリ・ポインター
	MOV	CX,MISS_ENTRY_MAX	; ミスコン・エントリー数
MISS_TOKU_OPEN_LOOP:
	PUSH	CX

	MOV	BX,ENTRY_PNT		; エントリ・ポインター
	MOVXBW	FREAM_XX_T,DS:MISS_XX_TBL[BX] ; (byte)エントリー表示Ｘ
	MOVXBW	FREAM_YY_T,DS:MISS_YY_TBL[BX] ; (byte)エントリー表示Ｙ
	ADDX	FREAM_XX_T,MISS_OFS_TOK_XX ; 得票のオフセット位置Ｘ
	ADDX	FREAM_YY_T,MISS_OFS_TOK_YY ; 得票のオフセット位置Ｙ

	MOV	SI,OFFSET FREAM_STRUCT_T ; ウインドウフレーム定義体/得票
	MOV	BX,OFFSET DISP_UNIT_TOKU ; ウインドウ表示単体定義体/得票
	CALL	WIDMINI_STRC		; WINDOWS/ミニウインドウ定義体の設定
	CALL	WIDMINI_FRM		; WINDOWS/ミニウインドウフレーム表示

	MOV	AX,0			; 表示番号
	MOV	CL,0			;
	MOV	DX,OFFSET DISP_UNIT_TOKU_MSG ; "total"
	CALL	DISP_ONE		; １個表示

	MOV	SI,ENTRY_PNT		; エントリ・ポインター
	SHL	SI,1			; word pointer.
	MOV	AX,DS:TOHYO_KIHIN[SI]	; 投票・気品
	MOV	BX,DS:TOHYO_IROKE[SI]	; 投票・色気
	MOV	CX,DS:TOHYO_PROPRT[SI]	; 投票・プロポー
	MOV	DX,DS:TOHYO_GOUKEI[SI]	; 投票・合計
	MOV	TOK_KIHIN,AX		; 投票数・気品
	MOV	TOK_IROKE,BX		; 投票数・色気
	MOV	TOK_PROPRT,CX		; 投票数・プロポー
	MOV	TOK_GOUKEI,DX		; 投票数・合計

	CALL	TOKU_DISP		; 得票表示

	INC	ENTRY_PNT		; エントリ・ポインター
	POP	CX
	LOOP	MISS_TOKU_OPEN_LOOP

	RET
MISS_TOKU_OPEN	ENDP



; ****************************************************
;	ミスコン・パラメータＯＰＥＮ
; ****************************************************

MISS_PARA_OPEN	PROC	NEAR

	MOV	ENTRY_PNT,0		; エントリ・ポインター
	MOV	CX,MISS_ENTRY_MAX	; ミスコン・エントリー数
MISS_PARA_OPEN_LOOP:
	PUSH	CX

	MOV	BX,ENTRY_PNT		; エントリ・ポインター
	MOVXBW	FREAM_XX,DS:MISS_XX_TBL[BX] ; (byte)エントリー表示Ｘ
	MOVXBW	FREAM_YY,DS:MISS_YY_TBL[BX] ; (byte)エントリー表示Ｙ
	ADDX	FREAM_XX,MISS_OFS_VAL_XX ; ステータスのオフセット位置Ｘ
	ADDX	FREAM_YY,MISS_OFS_VAL_YY ; ステータスのオフセット位置Ｙ

	MOV	SI,OFFSET FREAM_STRUCT	; ウインドウフレーム定義体/ステータス
	MOV	BX,OFFSET DISP_UNIT	; ウインドウ表示単体定義体/ステータス
	CALL	WIDMINI_STRC		; WINDOWS/ミニウインドウ定義体の設定
	CALL	WIDMINI_FRM		; WINDOWS/ミニウインドウフレーム表示

	MOV	AX,0			; 表示番号
	MOV	CL,0			;
	MOV	DX,OFFSET DISP_UNIT_MSG	; "ﾎﾟｲﾝﾄ"
	CALL	DISP_ONE		; １個表示

	INC	ENTRY_PNT		; エントリ・ポインター
	POP	CX
	LOOP	MISS_PARA_OPEN_LOOP

	RET
MISS_PARA_OPEN	ENDP


; ****************************************************
;	ミスコン・パラメータ表示
;	-I- PARA_D_MODE : パラメータ表示モード bit0:気品,bit1:プロポ,bit2:色気
; ****************************************************

MISS_PARA_PRINT	PROC	NEAR

	MOV	ENTRY_PNT,0		; エントリ・ポインター
	MOV	CX,MISS_ENTRY_MAX	; ミスコン・エントリー数
MISS_PARA_PRINT_LOOP:
	PUSH	CX

	MOV	BX,ENTRY_PNT		; エントリ・ポインター
	MOVXBW	FREAM_XX,DS:MISS_XX_TBL[BX] ; (byte)エントリー表示Ｘ
	MOVXBW	FREAM_YY,DS:MISS_YY_TBL[BX] ; (byte)エントリー表示Ｙ
	ADDX	FREAM_XX,MISS_OFS_VAL_XX ; ステータスのオフセット位置Ｘ
	ADDX	FREAM_YY,MISS_OFS_VAL_YY ; ステータスのオフセット位置Ｙ

	MOV	SI,OFFSET FREAM_STRUCT	; ウインドウフレーム定義体/ステータス
	MOV	BX,OFFSET DISP_UNIT	; ウインドウ表示単体定義体/ステータス
	CALL	WIDMINI_STRC		; WINDOWS/ミニウインドウ定義体の設定

	MOV	BX,ENTRY_PNT		; エントリ・ポインター
	SHL	BX,1			; word pointer.
	MOV	AX,DS:MISS_KIHIN[BX]	; 3. 気品
	MOV	CX,DS:MISS_IROKE[BX]	; 6. 色気
	MOV	DX,DS:MISS_PROPRT[BX]	; 7. プロポー
	MOV	PRM_KIHIN,AX		; 3. 気品
	MOV	PRM_IROKE,CX		; 6. 色気
	MOV	PRM_PROPRT,DX		; 7. プロポー

	CALL	PARA_DISP		; パラメータ表示

	INC	ENTRY_PNT		; エントリ・ポインター
	POP	CX
	LOOP	MISS_PARA_PRINT_LOOP

	RET
MISS_PARA_PRINT	ENDP


; ****************************************************
;	得票表示
;	-I- TOK_KIHIN  : 投票数・気品
;	    TOK_IROKE  : 投票数・色気
;	    TOK_PROPRT : 投票数・プロポー
;	    TOK_GOUKEI : 投票数・合計
; ****************************************************

TOKU_DISP	PROC	NEAR

	MOV	AX,1			;
	MOV	CL,'k'			; １キャラ文字
	MOV	DX,TOK_KIHIN		; 投票数・気品
	CALL	DISP_ONE		; １個表示

	ADD	TXTYY,8			; 文字列Ｙ位置

	MOV	AX,2			;
	MOV	CL,'p'			; １キャラ文字
	MOV	DX,TOK_PROPRT		; 投票数・プロポー
	CALL	DISP_ONE		; １個表示

	ADD	TXTYY,8			; 文字列Ｙ位置

	MOV	AX,3			;
	MOV	CL,'i'			; １キャラ文字
	MOV	DX,TOK_IROKE		; 投票数・色気
	CALL	DISP_ONE		; １個表示

	ADD	TXTYY,8			; 文字列Ｙ位置

	MOV	AX,4			;
	MOV	CL,'+'			; １キャラ文字
	MOV	DX,TOK_GOUKEI		; 投票数・合計
	CALL	DISP_ONE		; １個表示

	RET
TOKU_DISP	ENDP


; ****************************************************
;	パラメータ表示
;	-I- PRM_KIHIN  : 3. 気品／グラフテーブル
;	    PRM_IROKE  : 6. 色気／グラフテーブル
;	    PRM_PROPRT : 7. プロポー／内容表示テーブル
;	    PARA_D_MODE: パラメータ表示モード bit0:気品,bit1:プロポ,bit2:色気
; ****************************************************

PARA_DISP	PROC	NEAR
	TEST	PARA_D_MODE,001B	; パラメータ表示モード bit0:気品
	JZ	PARA_DISP_2		;

	MOV	AX,1			; 表示番号
	MOV	CL,'k'			;
	MOV	DX,PRM_KIHIN		; 3. 気品／グラフテーブル
	CALL	DISP_ONE		; １個表示
PARA_DISP_2:

	ADD	TXTYY,8			; 文字列Ｙ位置

	TEST	PARA_D_MODE,010B	; パラメータ表示モード bit1:プロポ
	JZ	PARA_DISP_3		;

	MOV	AX,2			; 表示番号
	MOV	CL,'p'			;
	MOV	DX,PRM_PROPRT		; 7. プロポー／内容表示テーブル
	CALL	DISP_ONE		; １個表示
PARA_DISP_3:

	ADD	TXTYY,8			; 文字列Ｙ位置

	TEST	PARA_D_MODE,100B	; パラメータ表示モード bit2:色気
	JZ	PARA_DISP_4		;

	MOV	AX,3			; 表示番号
	MOV	CL,'i'			;
	MOV	DX,PRM_PROPRT		; 7. プロポー／内容表示テーブル
	MOV	DX,PRM_IROKE		; 6. 色気／グラフテーブル
	CALL	DISP_ONE		; １個表示
PARA_DISP_4:

	RET
PARA_DISP	ENDP



; ****************************************************
;	１個表示
;	-I- AX : 表示番号
;	    DX : 値
;	    CL : １キャラ文字
; ****************************************************

DISP_ONE	PROC	NEAR
	CALL	WIDMINI			; WINDOWS/ミニウインドウ表示
	RET
DISP_ONE	ENDP



;*;; ****************************************************
;*;;	数値表示
;*;;	-I- TXTXX     : 文字列Ｘ位置
;*;;	    TXTYY     : 文字列Ｙ位置
;*;;	    PR_DSPVAL : 表示数値
;*;; ****************************************************
;*;
;*;DISP_VAL	PROC	NEAR
;*;	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;
;*;	MOV	DX,PR_DSPVAL		; 表示数値
;*;	CALL	DECSTR			; dec -> string.
;*;	CALL	STRZTS			; zero to space.
;*;	CALL	STRSPL			; space pless. "  123" - > "123  "
;*;	MOV	AX,DS:[SI]		;
;*;	MOV	BX,DS:[SI][2]		;
;*;	MOV	CL,DS:[SI][4]		;
;*;	MOV	DS:[DI],AX		;
;*;	MOV	DS:[DI][2],BX		;
;*;	MOV	DS:[DI][4],CL		;
;*;	MOV	DS:[DI][5],BYTE PTR 0	; 5ｹﾀ
;*;
;*;	CALL	DISP_STR		; 文字表示
;*;
;*;	RET
;*;DISP_VAL	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	％表示
;*;;	-I- TXTXX     : 文字列Ｘ位置
;*;;	    TXTYY     : 文字列Ｙ位置
;*;;	    PR_DSPVAL : 表示数値
;*;; ****************************************************
;*;
;*;DISP_PAR	PROC	NEAR
;*;	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;
;*;	MOVX	WDP_VAL,PR_DSPVAL	; 内容表示値
;*;	MOV	WDP_UNIT,UNIT_PAR	; 単位系 ％
;*;	CALL	WID_UNIT		; WINDOWS/単位別文字列化
;*;	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;	CALL	STRSPL			; space pless. "  123" - > "123  "
;*;
;*;	CALL	DISP_STR		; 文字表示
;*;
;*;	RET
;*;DISP_PAR	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	ステータス文字表示
;*;;	-I- TXTXX        : 文字列Ｘ位置
;*;;	    TXTYY        : 文字列Ｙ位置
;*;;	    STR_VAL_BUFF : 表示値文字列バッファ
;*;; ****************************************************
;*;
;*;DISP_STR	PROC	NEAR
;*;	MOV	PR_DSPCLR,0		; 数値表示色
;*;
;*;	MOVX	ES,DS			;
;*;	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;	CALL	STRLENGTH		; 文字列長さ
;*;
;*;	MOVX	VX1,TXTXX		; 文字列Ｘ位置
;*;	MOVX	VY1,TXTYY		; 文字列Ｙ位置
;*;	MOVX	VX2,TXTXX		; 文字列Ｘ位置
;*;	ADD	VX2,CX			; 表示単語長さ
;*;	SHL	VX1,1			;
;*;	SHL	VX1,1			;
;*;	SHL	VX1,1			; * 8
;*;	SHL	VX2,1			;
;*;	SHL	VX2,1			;
;*;	SHL	VX2,1			; * 8
;*;	MOV	VCOL,15			; カラー・白
;*;	MOV	CX,7			; 太さ
;*;	CALL	DLINEH			; 水平ライン描画
;*;
;*;	MOV	AX,PR_DSPCLR		; 数値表示色
;*;	CALL	MITCOL			; mini string color.
;*;	MOV	AX,TXTXX		; 文字列Ｘ位置
;*;	MOV	BX,TXTYY		; 文字列Ｙ位置
;*;	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;	CALL	MITPRN			; mini string. (null=end of string)
;*;;*;	CALL	MDTPRN			; MID string. (null=end of string)
;*;	RET
;*;DISP_STR	ENDP


; ****************************************************
;	スペック文字表示
;	-I- TXTXX        : 文字列Ｘ位置
;	    TXTYY        : 文字列Ｙ位置
;	    STR_BUFF     : 表示値文字列バッファ
; ****************************************************

SPEC_STR	PROC	NEAR
	MOV	PR_DSPCSZ,0		; パラメータ名内容文字表示サイズ
	MOV	PR_DSPCLR,15		; 数値表示色

	MOV	AX,PR_DSPCSZ		; パラメータ名内容文字表示サイズ
	CALL	VTXSIZ			; character size set.

	MOV	AX,PR_DSPCLR		; パラメータ名文字表示色
	CALL	VTXCOL			; character color set.

	MOV	AX,TXTXX		; 文字列Ｘ位置
	MOV	BX,TXTYY		; 文字列Ｙ位置
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	CALL	VTXPFC			; vram text print fuchi.

	RET
SPEC_STR	ENDP


; ****************************************************
;	パラメータ取得
;	-I- WIDOFS_GP_TK : 敵・グラフテーブルオフセット
;	    WIDOFS_VL_TK : 敵・内容表示オフセット
;	-O- PRM_KIHIN  : 3. 気品／グラフテーブル
;	    PRM_IROKE  : 6. 色気／グラフテーブル
;	    PRM_PROPRT : 7. プロポー／内容表示テーブル
; ****************************************************

PARA_GET	PROC	NEAR

	; 各パラメータ

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント

	MOV	BX,WIDOFS_GP_TK			; BX=敵・グラフオフセット
	MOV	AX,ES:[BX][GTB_KIHIN][GRP_VALUE] ; 3. 気品／グラフテーブル
	MOV	CX,ES:[BX][GTB_IROKE][GRP_VALUE] ; 6. 色気／グラフテーブル

	MOV	DI,WIDOFS_VL_TK			; DI=敵・内容表示オフセット
	MOV	DX,ES:[DI][VTB_PROPRT][VAL_VALUE];7.プロポー／内容表示テーブル


	MOV	PRM_KIHIN,AX			; 3. 気品／グラフテーブル
	MOV	PRM_IROKE,CX			; 6. 色気／グラフテーブル
	MOV	PRM_PROPRT,DX			; 7. プロポー／内容表示テーブル

	RET
PARA_GET	ENDP


; ****************************************************
;	メンバ選出
; ****************************************************

MEMBER_SELECT	PROC	NEAR
	MOV	DX,MISS_ENTRY_MAX	; ミスコン・エントリー数
	DEC	DX			; 娘の分を除いておく
	MOV	BX,OFFSET MISS_ENTRY_TABLE ; (byte)ミスコン・エントリー
	CALL	WIDALLOC_MISSCON	; WINDOWS/キャラクタ・ミスコン選出

	MOV	DX,MISS_ENTRY_MAX	; ミスコン・エントリー数
	DEC	DX			; 娘の分を除いておく
	MOV	BX,OFFSET MISS_ENTRY_TABLE ; (byte)ミスコン・エントリー
	MOV	AX,1			; 追加するメンバ／Ｎｏ．１は自分の娘
	CALL	WIDALLOC_TSUIKA		; WINDOWS/キャラクタ・メンバ表へ追加

	MOV	BAISYU_ENTRY,DX		; 買収エントリーＮｏ．
	RET
MEMBER_SELECT	ENDP


; ****************************************************
;	娘を除くメンバ選出
; ****************************************************

MEMBER_ANTHER_SELECT	PROC	NEAR
	MOV	DX,MISS_ENTRY_MAX	; ミスコン・エントリー数
	MOV	BX,OFFSET MISS_ENTRY_TABLE ; (byte)ミスコン・エントリー
	CALL	WIDALLOC_MISSCON	; WINDOWS/キャラクタ・ミスコン選出

	MOV	BAISYU_ENTRY,0		; 買収エントリーＮｏ．（無し）
	RET
MEMBER_ANTHER_SELECT	ENDP



; ****************************************************
;	文字列長さ
;	-I- ES:DI : 文字列アドレス
;	-O- CX    : 表示単語長さ
; ****************************************************

STRLENGTH	PROC	NEAR
	PUSH	DI

	MOV	CX,256
	MOV	AL,EOS
	REPNE	SCASB

	NEG	CX
	ADD	CX,256

	DEC	CX

	POP	DI

	RET
STRLENGTH	ENDP


CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	S_FUNC:WORD			; 計算ファンクション

EXTRN	WID_MISCON_MAX:WORD		; ミスコンキャラ数
EXTRN	WID_MISCON_TBL:BYTE		; ミスコンテーブル

EXTRN	R_SR_CHR_ADRS:WORD		; 台詞・キャラクタアドレス

EXTRN	WIDFUKI_AFTER_W:WORD		; フラグ・処理後にＷＡＩＴをいれる=1

BUMON_NUMBER	DW	0		; 部門
					; 1=気品部門,2=プロポーション部門
					; 3=色気部門

PRM_KIHIN	DW	0		; 3. 気品／グラフテーブル
PRM_IROKE	DW	0		; 6. 色気／グラフテーブル
PRM_PROPRT	DW	0		; 7. プロポー／内容表示テーブル
MISS_KIHIN	DW	10 DUP (0)	; 3. 気品／グラフテーブル
MISS_IROKE	DW	10 DUP (0)	; 6. 色気／グラフテーブル
MISS_PROPRT	DW	10 DUP (0)	; 7. プロポー／内容表示テーブル

TOHYO_VAL_ADRS	DW	OFFSET MISS_KIHIN ; 投票基準値アドレス(気品,色気,プ)
TOHYO_ADRS	DW	OFFSET TOHYO_KIHIN ; 投票中アドレス

TOK_KIHIN	DW	0		; 投票数・気品
TOK_IROKE	DW	0		; 投票数・色気
TOK_PROPRT	DW	0		; 投票数・プロポー
TOK_GOUKEI	DW	0		; 投票数・合計
TOHYO_KIHIN	DW	10 DUP (0)	; 投票・気品
TOHYO_IROKE	DW	10 DUP (0)	; 投票・色気
TOHYO_PROPRT	DW	10 DUP (0)	; 投票・プロポー
TOHYO_GOUKEI	DW	10 DUP (0)	; 投票・合計

YOUSHO_KIHIN_NO	DW	0		; 部門別１位・気品エントリィ番号
YOUSHO_KIHIN	DW	0		; 部門別１位・気品エントリィ(address)
YOUSHO_IROKE_NO	DW	0		; 部門別１位・色気エントリィ番号
YOUSHO_IROKE	DW	0		; 部門別１位・色気エントリィ(address)
YOUSHO_PROPRT_NO DW	0		; 部門別１位・プロポ・エントリィ番号
YOUSHO_PROPRT	DW	0		; 部門別１位・プロポ・エントリィ(adrs)
YOUSHO_ENTRY_NO	DW	0		; 総合優勝エントリィ番号
YOUSHO_ENTRY	DW	0		; 総合優勝エントリィ(address)

MYOSOU_HONME_NO	DW	0		; 予想エントリＮｏ． 0:本命
MYOSOU_TAIKO_NO	DW	0		; 予想エントリＮｏ． 1:対抗
MYOSOU_ANA_NO	DW	0		; 予想エントリＮｏ． 2:穴

MYOSOU_HONME	DW	0		; 予想 0:本命(address)
MYOSOU_TAIKO	DW	0		; 予想 1:対抗(address)
MYOSOU_ANA	DW	0		; 予想 2:穴  (address)

BAISYU_ENTRY	DW	0		; 買収エントリーＮｏ．

BAISYU_NIN	DW	0		; 買収人数
BAISYU_KIHIN	DW	0		; 買収人数・気品
BAISYU_IROKE	DW	0		; 買収人数・色気
BAISYU_PROPRT	DW	0		; 買収人数・プロポー
BAISYU_MONEY	DW	0		; 買収予定額
BAISYU_SHOJIKN	DW	0		; 所持金

PARA_D_MODE	DW	0		; パラメータ表示モード
					; bit0:気品,bit1:プロポ,bit2:色気

ENTRY_ADRS	DW	0		; エントリ・アドレス
ENTRY_PNT	DW	0		; エントリ・ポインター

MISS_ENTRY_MAX		DW	10	; ミスコン・エントリー数
MISS_ENTRY_TABLE	LABEL	BYTE	; (byte)ミスコン・エントリー
	DB	1,12,9,4,7,14,5,8,2,13
MISS_XX_TBL	LABEL	BYTE		; (byte)エントリー表示Ｘ
	DB	16*0,16*1,16*2,16*3,16*4
	DB	16*0,16*1,16*2,16*3,16*4
MISS_YY_TBL	LABEL	BYTE		; (byte)エントリー表示Ｙ
	DB	  0,  0,  0,  0,  0	;
	DB	200,200,200,200,200	;

MISS_ADRS_TABLE	LABEL	WORD		; ミスコン・出場者アドレス
	DW	0,0,0,0,0,0,0,0,0,0

MSG_STARTSET	LABEL	BYTE
		DB	"　＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"
		DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"
		DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"
		DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

MSG_KIHINBUMON	LABEL	BYTE	;太陽の神賞
		DB	"　　　　　　　 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"
		DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"
		DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊",0

MSG_PROPORTION	LABEL	BYTE	;月の神賞
		DB	"　　　　　　 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"
		DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"
		DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊",0

MSG_IROKE	LABEL	BYTE	;星の神賞
		DB	"　　　　　　 ＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"
		DB	"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊@"
		DB	"＊＊＊＊＊＊＊＊＊",0

MSG_BAISYU_OV	DB	"手元のお金で買収出来る人数は@"
MSG_BAISYU_OV_M	DB	"　　　　　　　　　　　　　　",0
MSG_BAISYU_OV_N	DB	"人までですね。",0
MSG_BAISYU_NS	DB	"と思ったが、お金がない！",0

MSG_SYUKEI_END	LABEL	BYTE
		DB	"ミス王国コンテスト運営委員会による厳正な集計@"
		DB	"が行われた。さあ、その結果は‥‥‥",0

MSG_TTL_1	DB	"太 陽 の 神 賞　",0
MSG_TTL_2	DB	"月　の　神　賞　",0
MSG_TTL_3	DB	"星　の　神　賞　",0

MSG_NEWS_N_LEN	DW	10*2		; 名前長さ
MSG_NEWS	LABEL	BYTE
		DB	"予想："
MSG_NEWS_TITLE	DB	"　　　　　　　　"
		DB	" 本命／"
MSG_NEWS_1	DB	"　　　　　　　　@"
		DB	"対抗／"
MSG_NEWS_2	DB	"　　　　　　　　"
		DB	" 穴　／"
MSG_NEWS_3	DB	"　　　　　　　　",0

MSG_NEWS_SPC	DB	"　　　　　　　　",0

MSG_HAPPYO_N_LEN DW	14*2		; 名前長さ
MSG_HAPPYO	LABEL	BYTE			; 発表
MSG_HAPPYO_BMN	DB	"　　　　　　　　"	; 受賞内容
		DB	"："
MSG_HAPPYO_NM	DB	"　　　　　　　　",0	; 受賞者

SELECT_BAYSYU	LABEL	BYTE
		DB	"買収しない・・・"	;0
		DB	",ひとりを買収する"	;1
		DB	",１０人を買収する"	;2
		DB	",５０人を買収する"	;3
		DB	",１００人を買収する"	;4
		DB	",２００人を買収する"	;5
		DB	",３００人を買収する"	;6
		DB	",４００人を買収する"	;7
		DB	",５００人！"		;8
		DB	",８００人！！"		;9
		DB	",９００人！！！"	;10
		DB	",１０００人！！！！",0	;11
;*NON*;		DB	",細かく決めたい！！",0	;12
SELECT_BAYSYU_NINZU	LABEL	WORD		; 買収人数
		DW	0			;0
		DW	1			;1
		DW	10			;2
		DW	50			;3
		DW	100			;4
		DW	200			;5
		DW	300			;6
		DW	400			;7
		DW	500			;8
		DW	800			;9
		DW	900			;10
		DW	1000			;11
;*NON*;		DW	1000			;12

SELECT_BAYSYU_RETRY	LABEL	BYTE
		DB	"あるだけのお金を使う"	;0
		DB	",買収をやめる",0	;1

		EVEN
VEW_POSI_NUM	DW	0		; スペックＶＩＥＷ位置
					; 0:左上,1:右上,2:左下,3:右下
VEW_POSI_XX_TBL	LABEL	BYTE		; (byte)スペックＶＩＥＷ位置Ｘ
		DB	0,40,0,40	;
VEW_POSI_YY_TBL	LABEL	BYTE		; (byte)スペックＶＩＥＷ位置Ｙ
		DB	0,0,200,200	;
VEW_OFS_FC_XX	DW	2		; スペック顔のオフセット位置Ｘ
VEW_OFS_FC_YY	DW	16-6		; スペック顔のオフセット位置Ｙ
VEW_OFS_VV_XX	DW	18		; スペック値のオフセット位置Ｘ
VEW_OFS_VV_YY	DW	16-6		; スペック値のオフセット位置Ｙ
VEW_OFS_VL_XX	DW	18		; 内容値のオフセット位置Ｘ
VEW_OFS_VL_YY	DW	16-6+48		; 内容値のオフセット位置Ｙ


PR_DSPXX_BS	DW	0		; 表示Ｘ位置ベース
PR_DSPYY_BS	DW	0		; 表示Ｙ位置ベース
PR_DSPXX	DW	0		; 表示Ｘ位置
PR_DSPYY	DW	0		; 表示Ｙ位置
PR_DSPVAL	DW	0		; 表示数値
PR_DSPCLR	DW	0		; 数値表示色
PR_DSPCSZ	DW	0		; パラメータ名内容文字表示サイズ

TXTXX		DW	0		; 文字列Ｘ位置
TXTYY		DW	0		; 文字列Ｙ位置

GOUKEI_LOW	DW	0		; (low word)合計
GOUKEI_HI	DW	0		; (hi  word)合計


MISS_OFS_VAL_XX	DW	0		; ステータスのオフセット位置Ｘ
MISS_OFS_VAL_YY	DW	180-(8*5)	; ステータスのオフセット位置Ｙ

MISS_OFS_TOK_XX	DW	8		; 得票のオフセット位置Ｘ
MISS_OFS_TOK_YY	DW	180-(8*6)	; 得票のオフセット位置Ｙ

XX1		DW	0		; Ｘ
YY1		DW	0		; Ｙ


;	ＷＩＮＤＯＷＳ／ミニウインドウ

FREAM_STRUCT	LABEL	BYTE		; ウインドウフレーム定義体/ステータス
 FREAM_XX	DW	10		; フレーム位置Ｘ
 FREAM_YY	DW	200		; フレーム位置Ｙ
 FREAM_SZ_X	DW	6 + 2		; フレームサイズＸ
 FREAM_SZ_Y	DW	8*4 + 4*2	; フレームサイズＹ

FREAM_STRUCT_T	LABEL	BYTE		; ウインドウフレーム定義体/得票
 FREAM_XX_T	DW	10		; フレーム位置Ｘ
 FREAM_YY_T	DW	200		; フレーム位置Ｙ
 FREAM_SZ_X_T	DW	6 + 2		; フレームサイズＸ
 FREAM_SZ_Y_T	DW	8*5 + 4*2	; フレームサイズＹ

DISP_UNIT_MSG	DB	"point",0
DISP_UNIT	LABEL	BYTE		; ウインドウ表示単体定義体/ステータス
		DB	2,0,	1,8*0+4,	3,8*0+4		; ヘッダ
		DB	0,0,	1,8*1+4,	3,8*1+4
		DB	1,0,	1,8*2+4,	3,8*2+4
		DB	0,0,	1,8*3+4,	3,8*3+4

DISP_UNIT_TOKU_MSG	DB	"total",0
DISP_UNIT_TOKU	LABEL	BYTE		; ウインドウ表示単体定義体/得票
		DB	2,0,	1,8*0+4,	3,8*0+4		; ヘッダ
		DB	0,0,	1,8*1+4,	3,8*1+4
		DB	0,0,	1,8*2+4,	3,8*2+4
		DB	0,0,	1,8*3+4,	3,8*3+4
		DB	0,0,	1,8*4+4,	3,8*4+4

DATA	ENDS

	END
;
;	end of "R_CONTST.ASM"
;
