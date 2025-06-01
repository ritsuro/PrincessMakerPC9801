; "WIDMNG.ASM" PC-9801UV11 make by R.H 1990/10/22
;
;
;	ＷＩＮＤＯＷＳ／マネージャー（管理系）
;
;
;	WIDCCT_INIT			; WINDOWS/キャラクタ初期処理
;	WIDCCT_OPEN			; WINDOWS/キャラクタオープン
;	WIDCCT_CLOSE			; WINDOWS/キャラクタクローズ
;	WIDCCT_CHANGE			; WINDOWS/キャラクタチェンジ
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC


FLAG_BREAK	EQU	-1		; 表示停止のフラグ


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

MOVXBW	MACRO	DEST,SOUR_BYTE
	MOV	AL,SOUR_BYTE
	CBW
	MOV	DEST,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA


; ****************************************************
;	WINDOWS/キャラクタ初期処理
; ****************************************************

FUNC	WWIDCCT_INIT,WIDCCT_INIT
	RET
FEND	WWIDCCT_INIT


; ****************************************************
;	WINDOWS/キャラクタオープン
;	-I- DX : オープンタイプ(0=フル画面,1=上段,2=中段,3=下段)
;	    AX : オープンするヘッダー番号
;	-O- DX : オープンハンドル
; ****************************************************

FUNC	WWIDCCT_OPEN,WIDCCT_OPEN
	PUSH	DX

	MOV	WDHNO,AX		; ヘッダー番号

	CALL	WID_S_SAVE		; カレントウインドウの情報退避

	CALL	HEAD_BLOCK_PUT		; ヘッドブロックＰＵＴ

	CALL	WID_S_INIT		; カレントウインドウの情報退避

	CALL	STYLE_GET		; スタイルＧＥＴ

	CALL	WID_DISP		; 表示をする

	POP	DX			; オープンタイプをそのままハンドルへ
 	RET
FEND	WWIDCCT_OPEN



; ****************************************************
;	WINDOWS/キャラクタクローズ
;	-I- DX : オープンハンドル
; ****************************************************

FUNC	WWIDCCT_CLOSE,WIDCCT_CLOSE
	RET
FEND	WWIDCCT_CLOSE


; ****************************************************
;	WINDOWS/キャラクタチェンジ
;	-I- DX : オープンハンドル
; ****************************************************

FUNC	WWIDCCT_CHANGE,WIDCCT_CHANGE
	PUSH	DX

	CALL	WID_S_SAVE		; カレントウインドウの情報退避

	CALL	HEAD_BLOCK_GET		; ヘッドブロックＧＥＴ
	MOV	WDHNO,AX		; ヘッダー番号

	CALL	WID_S_LOAD		; カレントウインドウの情報復元

	CALL	STYLE_GET		; スタイルＧＥＴ

	CALL	WID_CHNG		; ウインドウＣＨＡＮＧＥ

	POP	DX
	RET
FEND	WWIDCCT_CHANGE


;	ヘッドブロックＧＥＴ
;	-I- DX    : オープンハンドル
;	-O- AX    : オープンするヘッダー番号

HEAD_BLOCK_GET	PROC	NEAR
	MOV	HANDLE_NOW,DX		; 最新のオープルハンドル
	MOV	SI,DX			;
	MOV	AH,0			;
	MOV	AL,DS:HEAD_BLOCK[SI]	; ヘッドブロック・テーブル
	RET
HEAD_BLOCK_GET	ENDP


;	ヘッドブロックＰＵＴ
;	-I- DX    : オープンハンドル
;	    AX    : オープンするヘッダー番号

HEAD_BLOCK_PUT	PROC	NEAR
	MOV	HANDLE_NOW,DX		; 最新のオープルハンドル
	MOV	SI,DX			; オープンハンドル
	MOV	DS:HEAD_BLOCK[SI],AL	; ヘッドブロック・テーブル
	RET
HEAD_BLOCK_PUT	ENDP


;	カレントウインドウの情報退避
;	-I- HANDLE_NOW : 最新のオープルハンドル

WID_S_INIT	PROC	NEAR
	PUSH	DX

	MOV	VARI_GRP_N,0		; 横グラフ描画開始番号（初期値）

	MOV	DX,HANDLE_NOW		; 最新のオープルハンドル
	CALL	VARI_STYLE_PUT		; 可変スタイルＰＵＴ

	POP	DX
	RET
WID_S_INIT	ENDP


;	カレントウインドウの情報退避
;	-I- HANDLE_NOW : 最新のオープルハンドル

WID_S_SAVE	PROC	NEAR
	PUSH	DX

	CALLC	WIDHBR_SGET		; WINDOWS/横グラフ位置情報ＧＥＴ
	MOV	VARI_GRP_N,BX		; 横グラフ描画開始番号

	MOV	DX,HANDLE_NOW		; 最新のオープルハンドル
	CALL	VARI_STYLE_PUT		; 可変スタイルＰＵＴ

	POP	DX
	RET
WID_S_SAVE	ENDP


;	カレントウインドウの情報復元
;	-I- HANDLE_NOW : 最新のオープルハンドル

WID_S_LOAD	PROC	NEAR
	PUSH	DX

	MOV	DX,HANDLE_NOW		; 最新のオープルハンドル
	CALL	VARI_STYLE_GET		; 可変スタイルＧＥＴ

	MOV	BX,VARI_GRP_N		; 横グラフ描画開始番号
	CALLC	WIDHBR_SPUT		; WINDOWS/横グラフ位置情報ＰＵＴ

	POP	DX
	RET
WID_S_LOAD	ENDP


;	可変スタイルＰＵＴ
;	-I- DX         : オープンハンドル(0=フル画面,1=上段,2=中段,3=下段)
;	    VARI_GRP_N : 横グラフ描画開始番号

VARI_STYLE_PUT	PROC	NEAR
	PUSH	DX
	MOV	BX,VARI_GRP_N		; 横グラフ描画開始番号
	MOV	SI,DX			; 最新のオープルハンドル
	MOV	DS:TBL_VARI_GRP[SI],BL	; 横グラフ描画開始番号
	POP	DX
	RET
VARI_STYLE_PUT	ENDP


;	可変スタイルＧＥＴ
;	-I- DX         : オープンハンドル(0=フル画面,1=上段,2=中段,3=下段)
;	-O- VARI_GRP_N : 横グラフ描画開始番号

VARI_STYLE_GET	PROC	NEAR
	PUSH	DX
	MOV	SI,DX			; 最新のオープルハンドル
	MOV	BH,0			;
	MOV	BL,DS:TBL_VARI_GRP[SI]	; 横グラフ描画開始番号
	MOV	VARI_GRP_N,BX		; 横グラフ描画開始番号
	POP	DX
	RET
VARI_STYLE_GET	ENDP


;	スタイルＧＥＴ
;	-I- DX : オープンタイプ(0=フル画面,1=上段,2=中段,3=下段)
;	-O- STYL_BAR_Y : バー描画開始位置
;	    STYL_HED_X : ヘッダー 描画Ｘ位置
;	    STYL_HED_Y : ヘッダー描画開始位置
;	    STYL_HED_CNT : ヘッダー描画本数
;	    STYL_VAL_X : 内容表示描画開始位置Ｘ
;	    STYL_VAL_Y : 内容表示描画開始位置Ｙ
;	    STYL_GRP_X : 横グラフ開始位置Ｘ
;	    STYL_GRP_Y : 横グラフ描画開始位置
;	    STYL_GRP_CNT : 横グラフ描画本数

STYLE_GET	PROC	NEAR
	MOV	BX,DX					;
	SHL	BX,1					;
	SHL	BX,1					; * 9
	SHL	BX,1					;
	ADD	BX,DX					;

	MOVXBW	STYL_BAR_Y,  DS:TBL_OPEN_STYLE[BX]	; バー描画開始位置
	MOVXBW	STYL_HED_X,  DS:TBL_OPEN_STYLE[BX][1]	; ヘッダー描画Ｘ位置
	MOVXBW	STYL_HED_Y,  DS:TBL_OPEN_STYLE[BX][2]	; ヘッダー描画開始位置
	MOVXBW	STYL_HED_CNT,DS:TBL_OPEN_STYLE[BX][3]	; ヘッダー描画本数
	MOVXBW	STYL_VAL_X,  DS:TBL_OPEN_STYLE[BX][4]	; 内容表示描画開始位置X
	MOVXBW	STYL_VAL_Y,  DS:TBL_OPEN_STYLE[BX][5]	; 内容表示描画開始位置Y
	MOVXBW	STYL_GRP_X,  DS:TBL_OPEN_STYLE[BX][6]	; 横グラフ開始位置Ｘ
	MOVXBW	STYL_GRP_Y,  DS:TBL_OPEN_STYLE[BX][7]	; 横グラフ描画開始位置
	MOVXBW	STYL_GRP_CNT,DS:TBL_OPEN_STYLE[BX][8]	; 横グラフ描画本数

	RET
STYLE_GET	ENDP



;	表示をする
;	-I- WDHNO      : ヘッダー番号
;	    STYL_BAR_Y : バー描画開始位置
;	    STYL_HED_X : ヘッダー 描画Ｘ位置
;	    STYL_HED_Y : ヘッダー描画開始位置
;	    STYL_HED_CNT : ヘッダー描画本数
;	    STYL_VAL_X : 内容表示描画開始位置X
;	    STYL_VAL_Y : 内容表示描画開始位置
;	    STYL_GRP_X : 横グラフ描画Ｘ位置
;	    STYL_GRP_Y : 横グラフ描画開始位置
;	    STYL_GRP_CNT : 横グラフ描画本数

WID_DISP	PROC	NEAR
;*NON*;	MOV	DX,STYL_BAR_Y		; バー描画開始位置
;*NON*;	CALLC	WIDBAR_TITLE		; バー・タイトル

	CMP	STYL_HED_Y,FLAG_BREAK	; ヘッダー描画開始位置
	JE	WID_DISP_1		;
	MOV	AX,STYL_HED_X		; ヘッダー 描画Ｘ位置
	MOV	DX,STYL_HED_Y		; ヘッダー描画開始位置
	MOV	CX,STYL_HED_CNT		; ヘッダー描画本数
	CALLC	WIDHED_CAL		; WINDOWS/ヘッダー位置変更・計算のみ

	CALLC	WIDHED			; WINDOWS/ヘッダー表示
WID_DISP_1:				;

	CMP	STYL_GRP_Y,FLAG_BREAK	; 横グラフ描画開始位置
	JE	WID_DISP_3		;
	MOV	AX,STYL_GRP_X		; 横グラフ描画Ｘ位置
	MOV	DX,STYL_GRP_Y		; 横グラフ描画開始位置
	MOV	CX,STYL_GRP_CNT		; 横グラフ描画本数
	CALLC	WIDHBR_RELOC		; WINDOWS/横グラフ位置変更
WID_DISP_3:

	CMP	STYL_VAL_Y,FLAG_BREAK	; 内容表示描画開始位置
	JE	WID_DISP_4		;
	MOV	AX,STYL_VAL_X		; 内容表示描画開始位置Ｘ
	MOV	DX,STYL_VAL_Y		; 内容表示描画開始位置Ｙ
	CALLC	WIDVAL_RELOC		; WINDOWS/内容表示位置変更
WID_DISP_4:				;
	RET
WID_DISP	ENDP


;	ウインドウＣＨＡＮＧＥ
;	-I- WDHNO      : ヘッダー番号
;	    STYL_BAR_Y : バー描画開始位置
;	    STYL_HED_X : ヘッダー 描画Ｘ位置
;	    STYL_HED_Y : ヘッダー描画開始位置
;	    STYL_HED_CNT : ヘッダー描画本数
;	    STYL_VAL_Y : 内容表示描画開始位置
;	    STYL_GRP_Y : 横グラフ描画開始位置
;	    STYL_GRP_CNT : 横グラフ描画本数

WID_CHNG	PROC	NEAR
	CMP	STYL_HED_Y,FLAG_BREAK	; ヘッダー描画開始位置
	JE	WID_CHNG_1		;

	MOV	AX,STYL_HED_X		; ヘッダー 描画Ｘ位置
	MOV	DX,STYL_HED_Y		; ヘッダー描画開始位置
	MOV	CX,STYL_HED_CNT		; ヘッダー描画本数
	CALLC	WIDHED_CAL		; WINDOWS/ヘッダー位置変更・計算のみ
WID_CHNG_1:				;

	CMP	STYL_GRP_Y,FLAG_BREAK	; 横グラフ描画開始位置
	JE	WID_CHNG_3		;
	MOV	AX,STYL_GRP_X		; 横グラフ描画Ｘ位置
	MOV	DX,STYL_GRP_Y		; 横グラフ描画開始位置
	MOV	CX,STYL_GRP_CNT		; 横グラフ描画本数
	CALLC	WIDHBR_CAL		; WINDOWS/横グラフ位置変更・計算のみ
WID_CHNG_3:

	CMP	STYL_VAL_Y,FLAG_BREAK	; 内容表示描画開始位置
	JE	WID_CHNG_4		;

	MOV	AX,STYL_VAL_X		; 内容表示描画開始位置Ｘ
	MOV	DX,STYL_VAL_Y		; 内容表示描画開始位置
	CALLC	WIDVAL_CAL		; WINDOWS/内容表示位置変更・計算のみ
WID_CHNG_4:				;

	RET
WID_CHNG	ENDP

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

; ****************************************************
;	ヘッドブロック・テーブル
;	サイズはオープンタイプの数だけある。
; ****************************************************

HEAD_BLOCK	DB	10 DUP (0)		; ヘッドブロック・テーブル

HANDLE_NOW	DW	0			; 最新のオープルハンドル

VARI_GRP_N	DW	0			; 横グラフ描画開始番号

STYL_BAR_Y	DW	0			; バー描画開始位置
STYL_HED_X	DW	0			; ヘッダー描画Ｘ位置
STYL_HED_Y	DW	1			; ヘッダー描画開始位置
STYL_HED_CNT	DW	6			; ヘッダー描画本数
STYL_VAL_X	DW	2			; 内容表示描画開始位置Ｘ
STYL_VAL_Y	DW	18			; 内容表示描画開始位置Ｙ
STYL_GRP_X	DW	2			; 横グラフ開始位置Ｘ
STYL_GRP_Y	DW	24			; 横グラフ描画開始位置
STYL_GRP_CNT	DW	13			; 横グラフ描画本数

; ****************************************************
;	スタイルテーブル
; ****************************************************

;	オープン可変形式テーブル

TBL_VARI_GRP	DB	10 DUP (0)		; 横グラフ描画開始番号

;	オープン形式テーブル

TBL_OPEN_STYLE	LABEL	BYTE

;	0=フル画面

		DB	0			; バー描画開始位置
		DB	31			; ヘッダー描画Ｘ位置
		DB	34			; ヘッダー描画開始位置
		DB	6			; ヘッダー描画本数
		DB	2			; 内容表示描画開始位置Ｘ
		DB	18			; 内容表示描画開始位置Ｙ
		DB	0			; 横グラフ開始位置Ｘ
		DB	24			; 横グラフ描画開始位置
		DB	13			; 横グラフ描画本数

;	1=タイプ１

		DB	49			; バー描画開始位置
		DB	31			; ヘッダー描画Ｘ位置
		DB	5			; ヘッダー描画開始位置
		DB	1			; ヘッダー描画本数
		DB	0			; 内容表示描画開始位置Ｘ
		DB	0			; 内容表示描画開始位置Ｙ
		DB	0			; 横グラフ開始位置Ｘ
		DB	0			; 横グラフ描画開始位置
		DB	15			; 横グラフ描画本数

;	2=タイプ２（メイン／ステータス）

		DB	49			; バー描画開始位置
		DB	52 ;31			; ヘッダー描画Ｘ位置
		DB	1 ;37			; ヘッダー描画開始位置
		DB	1			; ヘッダー描画本数
		DB	0			; 内容表示描画開始位置Ｘ
		DB	1			; 内容表示描画開始位置Ｙ
		DB	22			; 横グラフ開始位置Ｘ
		DB	17 ;15 ;17 ;21 ;22	; 横グラフ描画開始位置
		DB	18-2			; 横グラフ描画本数


;	3=タイプ３（ヘッダーのみ）

		DB	49			; バー描画開始位置
		DB	52			; ヘッダー描画Ｘ位置
		DB	1 ;5			; ヘッダー描画開始位置
		DB	1			; ヘッダー描画本数
		DB	0			; 内容表示描画開始位置Ｘ
		DB	FLAG_BREAK		; 内容表示描画開始位置Ｙ
		DB	0			; 横グラフ開始位置Ｘ
		DB	FLAG_BREAK		; 横グラフ描画開始位置
		DB	FLAG_BREAK		; 横グラフ描画本数

;	4=タイプ４（グラフのみ）

		DB	49			; バー描画開始位置
		DB	FLAG_BREAK		; ヘッダー描画Ｘ位置
		DB	FLAG_BREAK		; ヘッダー描画開始位置
		DB	1			; ヘッダー描画本数
		DB	0			; 内容表示描画開始位置Ｘ
		DB	FLAG_BREAK		; 内容表示描画開始位置Ｙ
		DB	48+2 ;0			; 横グラフ開始位置Ｘ
		DB	38 ;39 ;38		; 横グラフ描画開始位置
		DB	5			; 横グラフ描画本数

;	5=タイプ５（バトル）

		DB	49			; バー描画開始位置
		DB	52			; ヘッダー描画Ｘ位置
		DB	1			; ヘッダー描画開始位置
		DB	1			; ヘッダー描画本数
		DB	0			; 内容表示描画開始位置Ｘ
		DB	FLAG_BREAK		; 内容表示描画開始位置Ｙ
		DB	48+2			; 横グラフ開始位置Ｘ
		DB	11			; 横グラフ描画開始位置
		DB	2			; 横グラフ描画本数

;	6=タイプ６（バトル敵）

		DB	49			; バー描画開始位置
		DB	52			; ヘッダー描画Ｘ位置
		DB	34			; ヘッダー描画開始位置
		DB	1			; ヘッダー描画本数
		DB	52			; 内容表示描画開始位置Ｘ
		DB	FLAG_BREAK		; 内容表示描画開始位置Ｙ
		DB	48+2			; 横グラフ開始位置Ｘ
		DB	44			; 横グラフ描画開始位置
		DB	2			; 横グラフ描画本数

;	7=タイプ７（装備）

		DB	49			; バー描画開始位置
		DB	FLAG_BREAK		; ヘッダー描画Ｘ位置
		DB	FLAG_BREAK		; ヘッダー描画開始位置
		DB	FLAG_BREAK		; ヘッダー描画本数
		DB	0			; 内容表示描画開始位置Ｘ
		DB	FLAG_BREAK		; 内容表示描画開始位置Ｙ
		DB	0			; 横グラフ開始位置Ｘ
		DB	20 ;22			; 横グラフ描画開始位置
		DB	14			; 横グラフ描画本数

;	8=タイプ８（デバッグ／ステータス）

		DB	49			; バー描画開始位置
		DB	1			; ヘッダー描画Ｘ位置
		DB	1			; ヘッダー描画開始位置
		DB	1			; ヘッダー描画本数
		DB	0			; 内容表示描画開始位置Ｘ
		DB	10			; 内容表示描画開始位置Ｙ
		DB	49			; 横グラフ開始位置Ｘ
		DB	10 ;8+7			; 横グラフ描画開始位置
		DB	18			; 横グラフ描画本数

;	9=タイプ９（バカンス用１つグラフ）

		DB	49			; バー描画開始位置
		DB	FLAG_BREAK		; ヘッダー描画Ｘ位置
		DB	FLAG_BREAK		; ヘッダー描画開始位置
		DB	1			; ヘッダー描画本数
		DB	0			; 内容表示描画開始位置Ｘ
		DB	FLAG_BREAK		; 内容表示描画開始位置Ｙ
		DB	0			; 横グラフ開始位置Ｘ
		DB	42 ;44 ;46		; 横グラフ描画開始位置
		DB	3			; 横グラフ描画本数

;	10=タイプ１０（病気用１つグラフ）

		DB	49			; バー描画開始位置
		DB	FLAG_BREAK		; ヘッダー描画Ｘ位置
		DB	FLAG_BREAK		; ヘッダー描画開始位置
		DB	1			; ヘッダー描画本数
		DB	0			; 内容表示描画開始位置Ｘ
		DB	FLAG_BREAK		; 内容表示描画開始位置Ｙ
		DB	48+2 ;0			; 横グラフ開始位置Ｘ
		DB	39 ;38			; 横グラフ描画開始位置
		DB	1			; 横グラフ描画本数


DATA	ENDS

	END
;
;	end of "WIDMNG.ASM"
;
