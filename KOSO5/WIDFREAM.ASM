; "WIDFREAM.ASM" PC-9801UV11 make by R.H 1990/10/13
;
;
;	ＷＩＮＤＯＷＳ／フレーム
;
;
;	WIDFRM_MAIN_SRT		; WINDOWS/フレーム・メインスタート時
;	WIDFRM_MAIN_RET		; WINDOWS/フレーム・復帰（収穫祭後）
;	WIDFRM_MAIN_LDA		; WINDOWS/フレーム・ロード後
;	WIDFRM_MAIN		; WINDOWS/フレーム・メイン
;	WIDFRM_MAIN_X		; WINDOWS/フレーム・メイン（簡略版）
;	WIDFRM_MAIN_HED		; WINDOWS/フレーム・メイン・ヘッダ再表示
;	WIDDSP_SAVE		; WINDOWS/画面退避
;	WIDDSP_LOAD		; WINDOWS/画面復元
;	WIDDSP_SV_F		; WINDOWS/画面フル退避
;	WIDDSP_LD_F		; WINDOWS/画面フル復元
;	WIDDSP_SV_H		; WINDOWS/画面範囲退避
;	WIDDSP_LD_H		; WINDOWS/画面範囲復元
;	WIDDSP_SV_MN		; WINDOWS/ｍｉｎｉステータス退避
;	WIDDSP_LD_MN		; WINDOWS/ｍｉｎｉステータス復元
;	WIDDSP_SV_MYST		; WINDOWS/ＭＹステータス退避
;	WIDDSP_LD_MYST		; WINDOWS/ＭＹステータス復元
;	WIDDSP_SV_YOU		; WINDOWS/ＹＯＵヘッダー退避
;	WIDDSP_LD_YOU		; WINDOWS/ＹＯＵヘッダー復元
;	WIDDSP_SV_YOUST		; WINDOWS/ＹＯＵステータス退避
;	WIDDSP_LD_YOUST		; WINDOWS/ＹＯＵステータス復元
;	WIDDSP_ALG		; WINDOWS/季節アナログ設定
;	WIDDSP_ALG_PLT		; WINDOWS/季節アナログパレットセット
;	WIDDSP_SV_WD		; WINDOWS/ワイドアイテム退避
;	WIDDSP_LD_WD		; WINDOWS/ワイドアイテム復元
;	WIDFRM_MISSCON		; WINDOWS/フレーム・ミスコン
;	WIDFRM_BACKSAVE		; WINDOWS/背景をセーブ
;	WIDFRM_BACKLOAD		; WINDOWS/背景をロード
;	WIDFRM_MSA_OPEN		; WINDOWS/武者修行ﾏｯプﾌﾚｰﾑＯＰＥＮ
;	WIDFRM_MSA_CLOSE	; WINDOWS/武者修行ﾏｯプﾌﾚｰﾑＣＬＯＳＥ
;	WIDFRM_BACASV		; WINDOWS/バカンス部分退避
;	WIDFRM_BACALD		; WINDOWS/バカンス部分復元
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO6\KYOKU.INC



;	ＷＩＮＤＯＷ　から　ＣＯＤＥ　へ　ＣＡＬＬ

CALLC	MACRO	SUB1
	LOCAL	L1,L2
;*;	JMP	L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	EXTRN	SUB1:NEAR
	CALL	SUB1
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:WINDOW,DS:DATA
L1:	CALL	L2
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチン

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS

	ASSUME	CS:WINDOW,DS:DATA

SUBLL	PROC	FAR
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチンの終り

FEND	MACRO	SUBLL
SUBLL	ENDP
	ENDM

;	ＷＩＮＤＯＷセグメントからＣＯＤＥセグメントへ

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

;	ＣＯＤＥセグメントからＷＩＮＤＯＷセグメントへ

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:WINDOW,DS:DATA
L1:
	ENDM


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


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA


; ****************************************************
;	WINDOWS/フレーム・メインスタート時
;	処理前ＶＲＡＭ１－＞処理後ＶＲＡＭ０
;	タイマ２待つ
; ****************************************************

FUNC	WWIDFRM_MAIN_SRT,WIDFRM_MAIN_SRT
	CALLC	VRMWT0			; ＶＲＡＭ０アクセス

	MOV	AX,3			; Ｖ割込み処理の指定インターバル
	CALLC	PLTINTSPD		; パレット・割込み処理スピード

	CALLC	PT_FREAM		; メインフレーム
	CALLC	WID_MBG_DISP		; WINDOWS/メインＢＧウインドウ表示
	CALLC	WIDCLEN_SET		; WINDOWS/カレンダー・時間設定
	CALLC	WIDCLEN_SHOW		; WINDOWS/カレンダー・再表示

WIDFRM_MAIN_SRT_1:
	CALLC	MUSRED			; マウス読み込み
	CMP	DH,0			;
	JE	WIDFRM_MAIN_SRT_2	;
	CMP	DL,0			;
	JE	WIDFRM_MAIN_SRT_2	;
	CALLC	TMVCK2			; V-SYNC timer2 check.
	CMP	AX,0			; 0=timer now, 1=timer end.
	JE	WIDFRM_MAIN_SRT_1	;
WIDFRM_MAIN_SRT_2:

	CALLC	PLTFOS			; Ｆ・Ｏ（フェードアウト）／時分割初期
	CALLC	PLTINTSW		; パレット・割込み処理スイッチ

	MOV	KYOKU_NUM,KYOKU_F_O	; 音楽フェードアウト
	CALLC	DKYOKU			; 曲の演奏

	; Ｆ．Ｏを開始

	CALLC	WIDBTN_OPEN		; WINDOWS/ボタンオープン
	CALLC	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更
	MOV	AX,0			; ヘッダー番号
	MOV	DX,3			; オープンタイプ
	CALLC	WIDCCT_OPEN		; WINDOWS/キャラクタオープン
	CALLC	WIDPROP_OPEN		; WINDOWS/プロポ・ウインドウＯＰＥＮ

	CALLC	PLTINTWT		; パレット・割込み処理終了待ち

	; ここまで、Ｆ．Ｏ

	CALLC	VRMDP0			; ＶＲＡＭ０表示

	CALL	FAR PTR WWIDDSP_ALG_PLT	; WINDOWS/季節アナログパレットセット
	CALLC	PLTFIS			; Ｆ・Ｉ（フェードイン）／時分割初期
	CALLC	PLTINTSW		; パレット・割込み処理スイッチ

	CALLC	MUSIC_KOSODATE		; 子育てのテーマ

	; Ｆ．Ｉを開始

	CALLC	R_START_DAY		; 立上り時の処理

	CALLC	PLTINTWT		; パレット・割込み処理終了待ち

	RET
FEND	WWIDFRM_MAIN_SRT


; ****************************************************
;	WINDOWS/フレーム・復帰（収穫祭後）
;	処理前ＶＲＡＭ１－＞処理後ＶＲＡＭ０
; ****************************************************

FUNC	WWIDFRM_MAIN_RET,WIDFRM_MAIN_RET
	CALL	FAR PTR WWIDDSP_SV_F	; WINDOWS/画面フル退避
	CALLC	VRMDP1			; ＶＲＡＭ１表示

	CALLC	VRMWT0			; ＶＲＡＭ０アクセス

	MOV	AX,3			; Ｖ割込み処理の指定インターバル
	CALLC	PLTINTSPD		; パレット・割込み処理スピード

	CALLC	PLTFOS			; Ｆ・Ｏ（フェードアウト）／時分割初期

CODE_IN
	CALL	PT_FREAM		; メインフレーム
	CALL	WID_MBG_DISP		; WINDOWS/メインＢＧウインドウ表示

	; Ｆ．Ｏを開始
	CALL	PLTINTSW		; パレット・割込み処理スイッチ
	CALL	WIDCLEN_SET		; WINDOWS/カレンダー・時間設定
	CALL	R_QUICK_DAY		; 瞬時娘表示の処理
CODE_OUT

	; ここまで、Ｆ．Ｏ

	CALLC	PLTINTWT		; パレット・割込み処理終了待ち

	CALLC	VRMDP0			; ＶＲＡＭ０表示

	CALL	FAR PTR WWIDDSP_ALG_PLT	; WINDOWS/季節アナログパレットセット

	CALLC	PLTFIS			; Ｆ・Ｉ（フェードイン）／時分割初期
	CALLC	PLTINTSW		; パレット・割込み処理スイッチ

	; Ｆ．Ｉを開始

	CALLC	WIDBTN_OPEN		; WINDOWS/ボタンオープン
	CALLC	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更

	MOV	AX,0			; ヘッダー番号
	MOV	DX,3			; オープンタイプ
	CALLC	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	CALLC	WIDPROP_OPEN		; WINDOWS/プロポ・ウインドウＯＰＥＮ

	CALLC	PLTINTWT		; パレット・割込み処理終了待ち

	; Ｆ．Ｉおわり

	RET
FEND	WWIDFRM_MAIN_RET


; ****************************************************
;	WINDOWS/フレーム・ロード後
; ****************************************************

FUNC	WWIDFRM_MAIN_LDA,WIDFRM_MAIN_LDA
	CALL	FAR PTR WWIDFRM_MAIN_RET	; WINDOWS/フレーム・復帰
	RET
FEND	WWIDFRM_MAIN_LDA


; ****************************************************
;	WINDOWS/フレーム・メイン
; ****************************************************

FUNC	WWIDFRM_MAIN,WIDFRM_MAIN
;*;	CALLC	MSCSTP			; カーソルストップ

	CALLC	PT_FREAM		; メインフレーム
	CALLC	WID_MBG_DISP		; WINDOWS/メインＢＧウインドウ表示
	CALLC	WIDBTN_OPEN		; WINDOWS/ボタンオープン
	CALLC	WIDCLEN_SET		; WINDOWS/カレンダー・時間設定
;*NON*;	CALLC	WID_GIRL		; WINDOWS/ＧＩＲＬウインドウ

	MOV	AX,0			; ヘッダー番号
	MOV	DX,3			; オープンタイプ
	CALLC	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	CALLC	WIDPROP_OPEN		; WINDOWS/プロポ・ウインドウＯＰＥＮ

	CALLC	R_QUICK_DAY		; 瞬時娘表示の処理

;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDFRM_MAIN


; ****************************************************
;	WINDOWS/フレーム・メイン（簡略版）
; ****************************************************

FUNC	WWIDFRM_MAIN_X,WIDFRM_MAIN_X
;*;	CALLC	MSCSTP			; カーソルストップ

	CALLC	PT_FREAM		; メインフレーム
	CALLC	WID_MBG_DISP		; WINDOWS/メインＢＧウインドウ表示
	CALLC	WIDCLEN_SET		; WINDOWS/カレンダー・時間設定

;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDFRM_MAIN_X


; ****************************************************
;	WINDOWS/フレーム・メイン・ヘッダ再表示
; ****************************************************

FUNC	WWIDFRM_MAIN_HED,WIDFRM_MAIN_HED
;*;	MOV	AX,0			; ヘッダー番号
;*;	MOV	DX,3			; オープンタイプ
;*;	CALLC	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

	MOV	DX,3			; オープンハンドル
	CALLC	WIDCCT_CHANGE		; WINDOWS/キャラクタチェンジ

	MOV	WDHNO,0			; ヘッダー番号
	CALLC	WIDHED_D_HP		; WINDOWS/ヘッダ・ＨＰ表示

	MOV	DX,4			; オープンハンドル
	CALLC	WIDCCT_CHANGE		; WINDOWS/キャラクタチェンジ

	RET
FEND	WWIDFRM_MAIN_HED


; ****************************************************
;	WINDOWS/画面退避
; ****************************************************

FUNC	WWIDDSP_SAVE,WIDDSP_SAVE
;*;	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,0			; 左上Ｘ
	MOV	BX,0			; 左上Ｙ
	MOV	CX,51			; サイズＸ
	MOV	DX,400			; サイズＹ
	CALLC	WIDBACK_SAVE		; WINDOWS/画面退避・ＳＡＶＥ
;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDDSP_SAVE


; ****************************************************
;	WINDOWS/画面復元
; ****************************************************

FUNC	WWIDDSP_LOAD,WIDDSP_LOAD
;*;	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,0			; 左上Ｘ
	MOV	BX,0			; 左上Ｙ
	MOV	CX,51			; サイズＸ
	MOV	DX,400			; サイズＹ
	CALLC	WIDBACK_LOAD		; WINDOWS/画面退避・ＬＯＡＤ
;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDDSP_LOAD


; ****************************************************
;	WINDOWS/画面フル退避
; ****************************************************

FUNC	WWIDDSP_SV_F,WIDDSP_SV_F
;*;	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,0			; 左上Ｘ
	MOV	BX,0			; 左上Ｙ
	MOV	CX,80			; サイズＸ
	MOV	DX,400			; サイズＹ
	CALLC	WIDBACK_SAVE		; WINDOWS/画面退避・ＳＡＶＥ
;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDDSP_SV_F


; ****************************************************
;	WINDOWS/画面フル復元
; ****************************************************

FUNC	WWIDDSP_LD_F,WIDDSP_LD_F
;*;	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,0			; 左上Ｘ
	MOV	BX,0			; 左上Ｙ
	MOV	CX,80			; サイズＸ
	MOV	DX,400			; サイズＹ
	CALLC	WIDBACK_LOAD		; WINDOWS/画面退避・ＬＯＡＤ
;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDDSP_LD_F


; ****************************************************
;	WINDOWS/画面範囲退避
;	-I- WDX1 : エリア左上座標Ｘ
;	    WDY1 : エリア左上座標Ｙ
;	    WDX2 : エリアサイズＸ
;	    WDY2 : エリアサイズＹ
; ****************************************************

FUNC	WWIDDSP_SV_H,WIDDSP_SV_H
;*;	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,WDX1			; エリア左上座標Ｘ
	MOV	BX,WDY1			; エリア左上座標Ｙ
	MOV	CX,WDX2			; エリアサイズＸ
	MOV	DX,WDY2			; エリアサイズＹ
	CALLC	WIDBACK_SAVE		; WINDOWS/画面退避・ＳＡＶＥ
;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDDSP_SV_H


; ****************************************************
;	WINDOWS/画面範囲復元
;	-I- WDX1 : エリア左上座標Ｘ
;	    WDY1 : エリア左上座標Ｙ
;	    WDX2 : エリアサイズＸ
;	    WDY2 : エリアサイズＹ
; ****************************************************

FUNC	WWIDDSP_LD_H,WIDDSP_LD_H
;*;	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,WDX1			; エリア左上座標Ｘ
	MOV	BX,WDY1			; エリア左上座標Ｙ
	MOV	CX,WDX2			; エリアサイズＸ
	MOV	DX,WDY2			; エリアサイズＹ
	CALLC	WIDBACK_LOAD		; WINDOWS/画面退避・ＬＯＡＤ
;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDDSP_LD_H


; ****************************************************
;	WINDOWS/ｍｉｎｉステータス退避
; ****************************************************

FUNC	WWIDDSP_SV_MN,WIDDSP_SV_MN
;*;	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,50 ;48 ;0		; 左上Ｘ
	MOV	BX,288 ;302		; 左上Ｙ
	MOV	CX,77-46 ;51		; サイズＸ
	MOV	DX,90+14		; サイズＹ
	CALLC	WIDBACK_SAVE		; WINDOWS/画面退避・ＳＡＶＥ
;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDDSP_SV_MN

; ****************************************************
;	WINDOWS/ｍｉｎｉステータス復元
; ****************************************************

FUNC	WWIDDSP_LD_MN,WIDDSP_LD_MN
;*;	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,50 ;48 ;0		; 左上Ｘ
	MOV	BX,288 ;302		; 左上Ｙ
	MOV	CX,77-46 ;51		; サイズＸ
	MOV	DX,90+14		; サイズＹ
	CALLC	WIDBACK_LOAD		; WINDOWS/画面退避・ＬＯＡＤ
;*;	CALLC	MSCSRT			; カーソルスタート
	RET
FEND	WWIDDSP_LD_MN



; ****************************************************
;	WINDOWS/ＭＹステータス退避
; ****************************************************

FUNC	WWIDDSP_SV_MYST,WIDDSP_SV_MYST
	MOV	AX,51-2			; 左上Ｘ
	MOV	BX,78			; 左上Ｙ
	MOV	CX,29+2			; サイズＸ
	MOV	DX,128-78		; サイズＹ
	CALLC	WIDBACK_SAVE		; WINDOWS/画面退避・ＳＡＶＥ
	RET
FEND	WWIDDSP_SV_MYST


; ****************************************************
;	WINDOWS/ＭＹステータス復元
; ****************************************************

FUNC	WWIDDSP_LD_MYST,WIDDSP_LD_MYST
	MOV	AX,51-2			; 左上Ｘ
	MOV	BX,78			; 左上Ｙ
	MOV	CX,29+2			; サイズＸ
	MOV	DX,128-78		; サイズＹ
	CALLC	WIDBACK_LOAD		; WINDOWS/画面退避・ＬＯＡＤ
	RET
FEND	WWIDDSP_LD_MYST


; ****************************************************
;	WINDOWS/ＹＯＵヘッダー退避
; ****************************************************

FUNC	WWIDDSP_SV_YOU,WIDDSP_SV_YOU
	MOV	AX,51			; 左上Ｘ
	MOV	BX,264			; 左上Ｙ
	MOV	CX,29			; サイズＸ
	MOV	DX,344-264		; サイズＹ
	CALLC	WIDBACK_SAVE		; WINDOWS/画面退避・ＳＡＶＥ
	RET
FEND	WWIDDSP_SV_YOU


; ****************************************************
;	WINDOWS/ＹＯＵヘッダー復元
; ****************************************************

FUNC	WWIDDSP_LD_YOU,WIDDSP_LD_YOU
	MOV	AX,51			; 左上Ｘ
	MOV	BX,264			; 左上Ｙ
	MOV	CX,29			; サイズＸ
	MOV	DX,344-264		; サイズＹ
	CALLC	WIDBACK_LOAD		; WINDOWS/画面退避・ＬＯＡＤ
	RET
FEND	WWIDDSP_LD_YOU


; ****************************************************
;	WINDOWS/ＹＯＵステータス退避
; ****************************************************

FUNC	WWIDDSP_SV_YOUST,WIDDSP_SV_YOUST
	MOV	AX,51-2			; 左上Ｘ
	MOV	BX,344			; 左上Ｙ
	MOV	CX,29+2			; サイズＸ
	MOV	DX,399-344		; サイズＹ
	CALLC	WIDBACK_SAVE		; WINDOWS/画面退避・ＳＡＶＥ
	RET
FEND	WWIDDSP_SV_YOUST


; ****************************************************
;	WINDOWS/ＹＯＵステータス復元
; ****************************************************

FUNC	WWIDDSP_LD_YOUST,WIDDSP_LD_YOUST
	MOV	AX,51-2			; 左上Ｘ
	MOV	BX,344			; 左上Ｙ
	MOV	CX,29+2			; サイズＸ
	MOV	DX,399-344		; サイズＹ
	CALLC	WIDBACK_LOAD		; WINDOWS/画面退避・ＬＯＡＤ
	RET
FEND	WWIDDSP_LD_YOUST


; ****************************************************
;	WINDOWS/季節アナログ設定
;	-I- VAL_A_DATE : (now)年内合計日付
; ****************************************************

FUNC	WWIDDSP_ALG,WIDDSP_ALG
	MOV	SET_FLAG,1		; 1=表示あり
	CALL	WID_ALG_SETS		; 季節アナログ設定
	RET
FEND	WWIDDSP_ALG


; ****************************************************
;	WINDOWS/季節アナログパレットセット
;	-I- VAL_A_DATE : (now)年内合計日付
; ****************************************************

FUNC	WWIDDSP_ALG_PLT,WIDDSP_ALG_PLT
	MOV	SET_FLAG,0		; 0=パレットセットのみ
	CALL	WID_ALG_SETS		; 季節アナログ設定
	RET
FEND	WWIDDSP_ALG_PLT


; ****************************************************
;	WINDOWS/ワイドアイテム退避
; ****************************************************

FUNC	WWIDDSP_SV_WD,WIDDSP_SV_WD
	MOV	AX,0			; 左上Ｘ
	MOV	BX,0			; 左上Ｙ
	MOV	CX,51			; サイズＸ
	MOV	DX,300-7		; サイズＹ
	CALLC	WIDBACK_SAVE		; WINDOWS/画面退避・ＳＡＶＥ
	RET
FEND	WWIDDSP_SV_WD


; ****************************************************
;	WINDOWS/ワイドアイテム復元
; ****************************************************

FUNC	WWIDDSP_LD_WD,WIDDSP_LD_WD
	MOV	AX,0			; 左上Ｘ
	MOV	BX,0			; 左上Ｙ
	MOV	CX,51			; サイズＸ
	MOV	DX,300-7		; サイズＹ
	CALLC	WIDBACK_LOAD		; WINDOWS/画面退避・ＬＯＡＤ
	RET
FEND	WWIDDSP_LD_WD


; ****************************************************
;	WINDOWS/フレーム・ミスコン
; ****************************************************

FUNC	WWIDFRM_MISSCON,WIDFRM_MISSCON
	CALLC	PT_FREAM_MISCON		; ミスコンフレーム
	RET
FEND	WWIDFRM_MISSCON


; ****************************************************
;	WINDOWS/背景をセーブ
;	-I- DX   : 背景退避用パーツバンク番号
;	    WDX1 : 背景退避エリア左上座標Ｘ
;	    WDY1 : 背景退避エリア左上座標Ｙ
;	    WDX2 : 背景退避エリアサイズＸ
;	    WDY2 : 背景退避エリアサイズＹ
; ****************************************************

FUNC	WWIDFRM_BACKSAVE,WIDFRM_BACKSAVE
	MOV	BACKBANK,DX	; 背景退避用パーツバンク番号
	CALLC	PATBNK		; バンクチェンジ

	CALLC	PATCLR		; パーツセットクリア

	MOVX	VRX,WDX1	; 背景退避エリア左上座標Ｘ
	MOVX	VRY,WDY1	; 背景退避エリア左上座標Ｙ
	MOVX	VRLENX,WDX2	; 背景退避エリアサイズＸ
	MOVX	VRLENY,WDY2	; 背景退避エリアサイズＹ

	CALLC	PATGTA		; パーツＧＥＴ圧縮無し

	MOV	BACKPAT,0	; 背景退避用パーツ番号
	RET
FEND	WWIDFRM_BACKSAVE


; ****************************************************
;	WINDOWS/背景をロード
; ****************************************************

FUNC	WWIDFRM_BACKLOAD,WIDFRM_BACKLOAD
	MOV	DX,BACKBANK	; 背景退避用パーツバンク番号
	CALLC	PATBNK		; バンクチェンジ

	MOV	CX,BACKPAT	; 背景退避用パーツ番号
	CALLC	PATPUT		; パーツＰＵＴ

	RET
FEND	WWIDFRM_BACKLOAD


; ****************************************************
;	WINDOWS/武者修行ﾏｯプﾌﾚｰﾑＯＰＥＮ
; ****************************************************

FUNC	WWIDFRM_MSA_OPEN,WIDFRM_MSA_OPEN
;*;	MOV	WDX1,1			; 表示位置Ｘ
;*;	MOV	WDY1,32			; 表示位置Ｙ
;*;	MOV	WDX2,50			; 大きさＸ
;*;	MOV	WDY2,336		; 大きさＹ
;*;	CALLC	WID_10_FLAME		; WINDOWS/フレーム10（武者修行マップ）
	RET
FEND	WWIDFRM_MSA_OPEN


; ****************************************************
;	WINDOWS/武者修行ﾏｯプﾌﾚｰﾑＣＬＯＳＥ
; ****************************************************

FUNC	WWIDFRM_MSA_CLOSE,WIDFRM_MSA_CLOSE
	RET
FEND	WWIDFRM_MSA_CLOSE


; ****************************************************
;	WINDOWS/バカンス部分退避
; ****************************************************

FUNC	WWIDFRM_BACASV,WIDFRM_BACASV
	MOV	DX,0			; 背景退避用パーツバンク番号
	MOV	WDX1,0			; 背景退避エリア左上座標Ｘ
	MOV	WDY1,0			; 背景退避エリア左上座標Ｙ
	MOV	WDX2,35			; 背景退避エリアサイズＸ
	MOV	WDY2,395		; 背景退避エリアサイズＹ
	CALL	FAR PTR WWIDFRM_BACKSAVE	; WINDOWS/背景をセーブ
	RET
FEND	WWIDFRM_BACASV


; ****************************************************
;	WINDOWS/バカンス部分復元
; ****************************************************

FUNC	WWIDFRM_BACALD,WIDFRM_BACALD
	CALL	FAR PTR WWIDFRM_BACKLOAD	; WINDOWS/背景をロード
	RET
FEND	WWIDFRM_BACALD


; ****************************************************
;	季節アナログ設定
;	-I- VAL_A_DATE : (now)年内合計日付
;	    SET_FLAG   : 0=パレットセットのみ,1=表示あり
; ****************************************************

WID_ALG_SETS	PROC	NEAR
	CMP	VAL_A_DATE,59		; (now)年内合計日付
	JG	WID_ALG_SETS_1		;
	MOV	PLT_T1,3+6		; 混合パレットテーブル番号
	MOV	PLT_T2,3+6		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	PLT_HI,0		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_1:
	CMP	VAL_A_DATE,79		; (now)年内合計日付
	JG	WID_ALG_SETS_2		;
	MOV	PLT_T1,3+6		; 混合パレットテーブル番号
	MOV	PLT_T2,3+1		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	AX,VAL_A_DATE		; (now)年内合計日付
	SUB	AX,59			;
	MOV	PLT_HI,AX		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_2:
	CMP	VAL_A_DATE,151		; (now)年内合計日付
	JG	WID_ALG_SETS_3		;
	MOV	PLT_T1,3+1		; 混合パレットテーブル番号
	MOV	PLT_T2,3+1		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	PLT_HI,0		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_3:
	CMP	VAL_A_DATE,171		; (now)年内合計日付
	JG	WID_ALG_SETS_4		;
	MOV	PLT_T1,3+1		; 混合パレットテーブル番号
	MOV	PLT_T2,3+2		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	AX,VAL_A_DATE		; (now)年内合計日付
	SUB	AX,151			;
	MOV	PLT_HI,AX		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_4:
	CMP	VAL_A_DATE,243		; (now)年内合計日付
	JG	WID_ALG_SETS_5		;
	MOV	PLT_T1,3+2		; 混合パレットテーブル番号
	MOV	PLT_T2,3+2		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	PLT_HI,0		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_5:
	CMP	VAL_A_DATE,263		; (now)年内合計日付
	JG	WID_ALG_SETS_6		;
	MOV	PLT_T1,3+2		; 混合パレットテーブル番号
	MOV	PLT_T2,3+3		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	AX,VAL_A_DATE		; (now)年内合計日付
	SUB	AX,243			;
	MOV	PLT_HI,AX		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_6:
	CMP	VAL_A_DATE,273		; (now)年内合計日付
	JG	WID_ALG_SETS_7		;
	MOV	PLT_T1,3+3		; 混合パレットテーブル番号
	MOV	PLT_T2,3+3		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	PLT_HI,0		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_7:
	CMP	VAL_A_DATE,293		; (now)年内合計日付
	JG	WID_ALG_SETS_8		;
	MOV	PLT_T1,3+3		; 混合パレットテーブル番号
	MOV	PLT_T2,3+4		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	AX,VAL_A_DATE		; (now)年内合計日付
	SUB	AX,273			;
	MOV	PLT_HI,AX		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_8:
	CMP	VAL_A_DATE,303		; (now)年内合計日付
	JG	WID_ALG_SETS_9		;
	MOV	PLT_T1,3+4		; 混合パレットテーブル番号
	MOV	PLT_T2,3+4		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	PLT_HI,0		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_9:
	CMP	VAL_A_DATE,323		; (now)年内合計日付
	JG	WID_ALG_SETS_A		;
	MOV	PLT_T1,3+4		; 混合パレットテーブル番号
	MOV	PLT_T2,3+5		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	AX,VAL_A_DATE		; (now)年内合計日付
	SUB	AX,303			;
	MOV	PLT_HI,AX		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_A:
	CMP	VAL_A_DATE,366-20	; (now)年内合計日付
	JG	WID_ALG_SETS_B		;
	MOV	PLT_T1,3+5		; 混合パレットテーブル番号
	MOV	PLT_T2,3+5		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	PLT_HI,0		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_B:
	CMP	VAL_DATE,24		; (now)日
	JL	WID_ALG_SETS_BB		;

	CMP	VAL_DATE,24		; (now)日
	JG	WID_ALG_SETS_C		;

	CMP	SET_FLAG,1		; 0=パレットセットのみ,1=表示あり
	JNE	WID_ALG_SETS_C		;

;*;	CODE_IN
;*;	PR_TXT	"@クリスマス・イブの朝@"
;*;	CODE_OUT	

	PUSH	IPLMSW			;

	MOV	IPLMSW,2		; パレットエフェクト単位時間(VSYNC)

	MOV	AX,3+5			; オーバラップ開始パレットテーブル番号
	MOV	BX,3+6			; オーバラップ終了パレットテーブル番号
	CALLC	PLTOL			; パレット・オーバラップ

	MOV	AX,3+6			; 混合パレットテーブル番号
	MOV	BX,3+6			; 混合パレットテーブル番号
	MOV	DX,0			; セットパレットテーブル
	MOV	CX,0			; 比率（０－２０）
	CALLC	PLTMIX			; パレット・混合

;*;	MOV	BX,0			; セットパレットテーブル
;*;	CALLC	PLSET			; パレットセット
	CALLC	NORMIN		; ノーマルカラー

	POP	IPLMSW			;

	CALLC	TKRHME			; 台詞ホームポジション

	JMP	WID_ALG_SETS_EXIT		;
WID_ALG_SETS_BB:				;
	MOV	PLT_T1,3+5		; 混合パレットテーブル番号
	MOV	PLT_T2,3+5		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	PLT_HI,0		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;
WID_ALG_SETS_C:
	MOV	PLT_T1,3+6		; 混合パレットテーブル番号
	MOV	PLT_T2,3+6		; 混合パレットテーブル番号
	MOV	PLT_ST,0		; セットパレットテーブル
	MOV	PLT_HI,0		; 比率（０－２０）
	JMP	WID_ALG_SETS_SET		;

WID_ALG_SETS_SET:
	MOV	AX,PLT_T1		; 混合パレットテーブル番号
	MOV	BX,PLT_T2		; 混合パレットテーブル番号
	MOV	DX,PLT_ST		; セットパレットテーブル
	MOV	CX,PLT_HI		; 比率（０－２０）
	CALLC	PLTMIX			; パレット・混合

	CMP	SET_FLAG,1		; 0=パレットセットのみ,1=表示あり
	JNE	WID_ALG_SETS_EXIT	;

;*;	MOV	BX,PLT_ST		; セットパレットテーブル
;*;	CALLC	PLSET			; パレットセット
	CALLC	NORMIN		; ノーマルカラー

WID_ALG_SETS_EXIT:
	RET
WID_ALG_SETS	ENDP


WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	IPLMSW:WORD			; パレットエフェクト単位時間(VSYNC)

EXTRN	NOW_DATE:WORD			; (now)現在時間
EXTRN	VAL_YEAR:WORD			; (now)年
EXTRN	VAL_MONTH:WORD			; (now)月
EXTRN	VAL_WEEK:WORD			; (now)曜日
EXTRN	VAL_DATE:WORD			; (now)日
EXTRN	VAL_A_DATE:WORD			; (now)年内合計日付
EXTRN	TM_SEASON:WORD			; (now)季節（1:春,2:夏,3:秋,4:冬）
EXTRN	FLG_SHOGATSU:WORD		; (now)フラグ・正月
EXTRN	FLG_URUBI:WORD			; (now)フラグ・うるう日
EXTRN	FLG_CHRISTMAS_EVE:WORD 		; (now)フラグ・クリスマスイブ
EXTRN	FLG_BORTH:WORD			; (now)フラグ・誕生日
EXTRN	FLG_HOLIDAY:WORD		; (now)フラグ・休日

PLT_T1		DW	0		; 混合パレットテーブル番号
PLT_T2		DW	0		; 混合パレットテーブル番号
PLT_ST		DW	0		; セットパレットテーブル
PLT_HI		DW	0		; 比率（０－２０）

BACKBANK	DW	0		; 背景退避用パーツバンク番号
BACKPAT		DW	0		; 背景退避用パーツ番号

SET_FLAG	DW	0		; 0=パレットセットのみ,1=表示あり

DATA	ENDS

	END
;
;	end of "WIDFREAM.ASM"
;
