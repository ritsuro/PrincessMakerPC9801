; "WIDTXT.ASM" PC-9801UV11 make by R.H 1990/10/29
;
;
;	ＷＩＮＤＯＷＳ／テキストウインドウ
;
;
;	WIDTXT_INIT		; WINDOWS/テキストウインドウ初期処理
;	WIDTXT			; WINDOWS/テキストウインドウ
;	WIDTXT2			; WINDOWS/テキストウインドウ２
;	WIDTXT3			; WINDOWS/テキストウインドウ３
;	WIDTXT_OPEN		; WINDOWS/テキストウインドウＯＰＥＮ
;	WIDTXT_CLOSE		; WINDOWS/テキストウインドウＣＬＯＳＥ
;	WIDTXT_RELOC		; WINDOWS/テキストウインドウ位置変更
;	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC


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


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA

; ****************************************************
;	WINDOWS/テキストウインドウ初期処理
; ****************************************************

FUNC	WWIDTXT_INIT,WIDTXT_INIT
	RET
FEND	WWIDTXT_INIT


; ****************************************************
;	WINDOWS/テキストウインドウ
;	-I- WDTXTSEG : 表示文字列セグメント
;	    WDTXTADR : 表示文字列アドレス
; ****************************************************

FUNC	WWIDTXT,WIDTXT
;*NON*;	CALLC	MSCWAT			; カーソルボタンＯＦＦ待ち
;*NON*;	CALLC	TKRSET			; 台詞改行のカウンタリセット
	MOV	AX,WID_PAC_MODE	; ウインドウモード 0=口ぱくなし,1=口ぱくあり
	MOV	PAC_MODE,AX		; 口ぱくモード

	CMP	PAC_MODE,1		; 口ぱくモード 1=口ぱくあり
	JNE	WIDTXT_1		;
;*NON*;	CALLC	MSCWAT			; カーソルボタンＯＦＦ待ち
	CALLC	MSCWATTM	; カーソルボタンＯＦＦ待ち（待ちタイマ付き）
WIDTXT_1:

	MOV	AX,ADV_INI_X		; アドベンチャー・台詞左上Ｘ
	MOV	BX,ADV_INI_Y		; アドベンチャー・台詞左上Ｙ
	MOV	CX,ADV_SIZE_X		; アドベンチャー・台詞サイズＸ
	MOV	DX,ADV_SIZE_Y		; アドベンチャー・台詞サイズＹ
	CALLC	MS_STOP			; マウスカーソル退避

	MOV	ES,WDTXTSEG		; WINDOWS/表示文字列セグメント
	MOV	SI,WDTXTADR		; WINDOWS/表示文字列アドレス
	CALLC	TKTPRN			; 台詞表示

	CALLC	MS_START		; マウスカーソル復帰

	MOV	PAC_MODE,0		; 口ぱくモード 0=口ぱくなし
	RET
FEND	WWIDTXT


; ****************************************************
;	WINDOWS/テキストウインドウ２
;	ＰＲ＿ＴＸＴ用
;	-I- WDTXTADR : 表示文字列アドレス
; ****************************************************

FUNC	WWIDTXT2,WIDTXT2
	MOV	WDTXTSEG,DS		; 表示文字列セグメント
	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALL	FAR PTR WWIDTXT		; テキストウインドウ
	RET
FEND	WWIDTXT2


; ****************************************************
;	WINDOWS/テキストウインドウ３
;	ＰＲ＿ＴＸＴＲ用
;	-I- WDTXTADR : 表示文字列アドレス
; ****************************************************

FUNC	WWIDTXT3,WIDTXT3
	MOV	WDTXTSEG,DS		; 表示文字列セグメント
	CALL	FAR PTR WWIDTXT		; テキストウインドウ
	RET
FEND	WWIDTXT3


; ****************************************************
;	WINDOWS/テキストウインドウＯＰＥＮ
; ****************************************************

FUNC	WWIDTXT_OPEN,WIDTXT_OPEN
	MOV	AX,ADV_INI_X		; アドベンチャー・台詞左上Ｘ
	MOV	BX,ADV_INI_Y		; アドベンチャー・台詞左上Ｙ
	MOV	CX,ADV_SIZE_X		; アドベンチャー・台詞サイズＸ
	MOV	DX,ADV_SIZE_Y		; アドベンチャー・台詞サイズＹ
	CALLC	MS_STOP			; マウスカーソル退避


	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALLC	TKQZLF			; 台詞改行
	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALLC	TKQZLF			; 台詞改行
	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALLC	TKQZLF			; 台詞改行

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	SI,OFFSET MSG_OPEN_TITLE
	CALLC	TKTPRN			; 台詞表示
	CALLC	TKRSET			; 台詞改行のカウンタリセット

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWIDTXT_OPEN


; ****************************************************
;	WINDOWS/テキストウインドウＣＬＯＳＥ
; ****************************************************

FUNC	WWIDTXT_CLOSE,WIDTXT_CLOSE
	MOV	AX,ADV_INI_X		; アドベンチャー・台詞左上Ｘ
	MOV	BX,ADV_INI_Y		; アドベンチャー・台詞左上Ｙ
	MOV	CX,ADV_SIZE_X		; アドベンチャー・台詞サイズＸ
	MOV	DX,ADV_SIZE_Y		; アドベンチャー・台詞サイズＹ
	CALLC	MS_STOP			; マウスカーソル退避

	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALLC	TKQZLF			; 台詞改行
	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALLC	TKQZLF			; 台詞改行
	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALLC	TKQZLF			; 台詞改行
	CALLC	TKRSET			; 台詞改行のカウンタリセット

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	SI,OFFSET MSG_CLOSE_TITLE
	CALLC	TKTPRN			; 台詞表示

	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALLC	TKQZLF			; 台詞改行
	CALLC	TKRSET			; 台詞改行のカウンタリセット

	CALLC	MS_START		; マウスカーソル復帰
	RET
FEND	WWIDTXT_CLOSE



; ****************************************************
;	WINDOWS/テキストウインドウ位置変更
; ****************************************************

FUNC	WWIDTXT_RELOC,WIDTXT_RELOC
	MOV	AX,ADV_INI_X		; アドベンチャー・台詞左上Ｘ
	MOV	BX,ADV_INI_Y		; アドベンチャー・台詞左上Ｙ
	MOV	CX,ADV_SIZE_X		; アドベンチャー・台詞サイズＸ
	MOV	DX,ADV_SIZE_Y		; アドベンチャー・台詞サイズＹ
	CALLC	MS_STOP			; マウスカーソル退避

	CALLC	TKTIN			; 台詞表示初期処理

	MOV	AX,ADV_INI_X		; アドベンチャー・台詞左上Ｘ
	MOV	BX,ADV_INI_Y		; アドベンチャー・台詞左上Ｙ
	MOV	CX,ADV_END_X		; アドベンチャー・台詞右下Ｘ
	MOV	DX,ADV_END_Y		; アドベンチャー・台詞右下Ｙ
	DEC	CX			;
	MOV	VX1,AX			;
	MOV	VY1,BX			;
	MOV	VX2,CX			;
	MOV	VY2,DX			;
	MOV	CX,W_COL3		; カラー・暗い灰
	CALLC	BOXPAL			; ＢＯＸペイント
	MOV	CX,W_COL4		; カラー・黒
	CALLC	BOXMSS			; ＢＯＸメッシュ

	CALLC	TKRSET			; 台詞改行のカウンタリセット
	CALLC	TKQZLF			; 台詞改行
	CALLC	TKRSET			; 台詞改行のカウンタリセット

	MOVX	WDX1,ADV_INI_X		; アドベンチャー・台詞左上Ｘ
	MOVX	WDY1,ADV_INI_Y		; アドベンチャー・台詞左上Ｙ
	MOVX	WDX2,ADV_SIZE_X		; アドベンチャー・台詞サイズＸ
	MOVX	WDY2,ADV_SIZE_Y		; アドベンチャー・台詞サイズＹ

	SUB	WDX1,1			; 表示位置Ｘ
	SUB	WDY1,4			; 表示位置Ｙ

	ADD	WDX2,1			; 大きさＸ
	ADD	WDY2,8+2		; 大きさＹ

	CALLC	MS_START		; マウスカーソル復帰

;*;	CALLC	WID_1_FLAME		; WINDOWS/フレーム１
	CALLC	WID_5_FLAME		; WINDOWS/フレーム５（宝石）

	RET
FEND	WWIDTXT_RELOC


; ****************************************************
;	WINDOWS/テキストウインドウモード設定
;	-I- AX : 口ぱくモード 0=口ぱくなし,1=口ぱくあり
; ****************************************************

FUNC	WWIDTXT_MODE,WIDTXT_MODE
	AND	AX,1		;
	MOV	WID_PAC_MODE,AX	; ウインドウモード 0=口ぱくなし,1=口ぱくあり
	MOV	AX,0		;
	CALLC	TMVST5		; V-SYNC timer5 set.
	RET
FEND	WWIDTXT_MODE

WINDOW	ENDS


CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA,ES:DATA

;	"VRTEXT.ASM"からのＣＡＬＬ

PUBLIC	VTXPAC	; ｾﾘﾌ 1ﾓｼﾞ ｺﾞﾄﾆ call ｼﾏｽﾉﾃﾞ ｸﾁﾊﾟｸ ｦ ｻｾﾃ ｸﾀﾞｻｲ｡
PUBLIC	VTXEND	; ｾﾘﾌ ﾉ ｵﾜﾘ ﾆ   call ｼﾏｽﾉﾃﾞ ｸﾁﾊﾟｸ ｦ ﾄﾒﾃ ｸﾀﾞｻｲ｡

EXTRN	TMVST5:NEAR		; V-SYNC timer5 set.
EXTRN	TMVCK5:NEAR		; V-SYNC timer5 check.
EXTRN	MUSRED:NEAR		; マウス読み込み

; ****************************************************
;	ｾﾘﾌ 1ﾓｼﾞ ｺﾞﾄﾆ call ｼﾏｽﾉﾃﾞ ｸﾁﾊﾟｸ ｦ ｻｾﾃ ｸﾀﾞｻｲ｡
; ****************************************************

VTXPAC	PROC	NEAR
	CMP	PAC_MODE,0	; 口ぱくモード 0=口ぱくなし,1=口ぱくあり
	JE	VTXPAC_EXIT	;

VTXPAC_WAIT:
	CALL	MUSRED		; マウス読み込み
	CMP	DH,0		; 左ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	VTXPAC_SKIP	;
	CMP	DL,0		; 右ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	VTXPAC_SKIP	;

	CALL	TMVCK5		; V-SYNC timer5 check.
	CMP	AX,0		; 0=timer now, 1=timer end.
	JE	VTXPAC_WAIT	;

	CALL	CNDTLK		; 声の状態

VTXPAC_SKIP:
	MOV	BX,CNDISN	; 声の状態 0=無音,1=普通,2=遅い,3=速い
	MOV	AH,0		;
	MOV	AL,DS:TWTBL[BX]	; (byte) wait timer table.
	CALL	TMVST5		; V-SYNC timer5 set.

VTXPAC_EXIT:
	RET
VTXPAC	ENDP

; ****************************************************
;	ｾﾘﾌ ﾉ ｵﾜﾘ ﾆ   call ｼﾏｽﾉﾃﾞ ｸﾁﾊﾟｸ ｦ ﾄﾒﾃ ｸﾀﾞｻｲ｡
; ****************************************************

VTXEND	PROC	NEAR
	RET
VTXEND	ENDP

; ***********************************************
;	声の状態
;	-I- VTXJCD : 漢字シフトＪＩＳコード('VRTEXT.ASM')
;	-O- CNDISN : 0=無音,1=普通,2=遅い,3=速い
; ***********************************************

CNDTLK	PROC	NEAR
	CMP	VTXJCD,08140H	; スペース
	JMPEQ	CNDTLK_MUON	;

	CMP	VTXJCD,' '	;SPACE
	JMPEQ	CNDTLK_QUICK	;
	CMP	VTXJCD,8140H	;漢字スペース
	JMPEQ	CNDTLK_QUICK	;
	CMP	VTXJCD,08175H	;「
	JE	CNDTLK_MUON	;
	CMP	VTXJCD,08176H	;」
	JE	CNDTLK_MUON	;
	CMP	VTXJCD,0A2H	;｢
	JE	CNDTLK_MUON	;
	CMP	VTXJCD,0A3H	;｣
	JE	CNDTLK_MUON	;
	CMP	VTXJCD,0815BH	;ー
	JE	CNDTLK_STD	;
	CMP	VTXJCD,0815CH	;―
	JE	CNDTLK_STD	;
	CMP	VTXJCD,0815DH	;‐
	JE	CNDTLK_STD	;
	CMP	VTXJCD,0817CH	;－
	JE	CNDTLK_STD	;
	CMP	VTXJCD,08141H	;、
	JE	CNDTLK_LOW	;
	CMP	VTXJCD,08142H	;。
	JE	CNDTLK_LOW	;
	CMP	VTXJCD,0A1H	;｡
	JE	CNDTLK_LOW	;
	CMP	VTXJCD,08149H	;！
	JE	CNDTLK_LOW	;

	CMP	VTXJCD,0819EH	; 句読点等の記号文字
	JB	CNDTLK_SLOW	;

	CMP	VTXJCD,0889EH	; 当用漢字
	JNB	CNDTLK_QUICK	;

	CMP	VTXJCD,081FCH	;
	JNB	CNDTLK_STD	;

CNDTLK_MUON:
	MOV	CNDISN,0	; 0=無音
	RET
CNDTLK_STD:
	MOV	CNDISN,1	; 1=普通
	RET
CNDTLK_SLOW:
	MOV	CNDISN,2	; 2=遅い
	RET
CNDTLK_QUICK:
	MOV	CNDISN,3	; 3=速い
	RET
CNDTLK_LOW:
	MOV	CNDISN,4	; 4=もっと遅い
	RET
CNDTLK	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	VTXJCD:WORD		; talk jis code.(VRTEXT.ASM)

EXTRN	ADV_INI_X:WORD		; アドベンチャー・台詞左上Ｘ
EXTRN	ADV_INI_Y:WORD		; アドベンチャー・台詞左上Ｙ
EXTRN	ADV_END_X:WORD		; アドベンチャー・台詞右下Ｘ
EXTRN	ADV_END_Y:WORD		; アドベンチャー・台詞右下Ｙ
EXTRN	ADV_SIZE_X:WORD		; アドベンチャー・台詞サイズＸ
EXTRN	ADV_SIZE_Y:WORD		; アドベンチャー・台詞サイズＹ

MSG_CLOSE_TITLE		LABEL	BYTE
;*;	DB	" closed text window.@"
	DB	0,0

MSG_OPEN_TITLE		LABEL	BYTE
;*;	DB	"     open text window.@"
	DB	0,0

WID_PAC_MODE	DW	0	; ウインドウモード 0=口ぱくなし,1=口ぱくあり
PAC_MODE	DW	0	; 口ぱくモード 0=口ぱくなし,1=口ぱくあり
CNDISN		DW	0	; 声の状態
				; 0=無音,1=普通,2=遅い,3=速い,4=もっと遅い
TWTBL		LABEL	BYTE	; (byte) wait timer table.
		DB	0,5,12,2,20 ; 声の状態 無音,普通,遅い,速い,もっと遅い

DATA	ENDS

	END
;
;	end of "WIDTXT.ASM"
;
