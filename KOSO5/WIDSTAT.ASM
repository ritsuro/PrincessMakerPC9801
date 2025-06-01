; "WIDSTAT.ASM" PC-9801UV11 make by R.H 1990/11/02
;
;
;	ＷＩＮＤＯＷＳ／ステータス表示
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC

WD_OPEN_TYPE		EQU	2	; オープンタイプ

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

PUBLIC	WIDSTAT_INIT		; WIDNOWS/ステータスウインドウ初期処理
PUBLIC	WIDSTAT			; WINDOWS/ステータス

EXTRN	WIDHBR_SPUT:NEAR	; WINDOWS/横グラフ位置情報ＰＵＴ


EXTRN	WIDCCT_INIT:NEAR	; WINDOWS/キャラクタ初期処理
EXTRN	WIDCCT_OPEN:NEAR	; WINDOWS/キャラクタオープン
EXTRN	WIDCCT_CLOSE:NEAR	; WINDOWS/キャラクタクローズ
EXTRN	WIDCCT_CHANGE:NEAR	; WINDOWS/キャラクタチェンジ

EXTRN	WID_1_FLAME:NEAR	; WINDOWS/フレーム１
EXTRN	WID_2_FLAME:NEAR	; WINDOWS/フレーム２
EXTRN	WID_3_FLAME:NEAR	; WINDOWS/フレーム３

EXTRN	MSCSRT:NEAR		; カーソルスタート
EXTRN	MSCMOV:NEAR		; カーソル移動
EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR		; カーソルストップ
EXTRN	MSCSTS:NEAR		; マウスカーソルステータス


; ****************************************************
;	WIDNOWS/ステータスウインドウ初期処理
; ****************************************************

WIDSTAT_INIT	PROC	NEAR
	RET
WIDSTAT_INIT	ENDP


; ****************************************************
;	WINDOWS/ステータス
;	-I- W_STAT_HEAD_NO : ヘッダー番号
; ****************************************************

WIDSTAT	PROC	NEAR
;*;	CALL	MSCSTP			; カーソルストップ

	MOV	BX,0			; 横グラフ描画開始番号
	CALL	WIDHBR_SPUT		; WINDOWS/横グラフ位置情報ＰＵＴ

	MOV	AX,W_STAT_HEAD_NO	; ヘッダー番号
	MOV	DX,WD_OPEN_TYPE		; オープンタイプ
	CALL	WIDCCT_OPEN		; WINDOWS/キャラクタオープン

;*;	CALL	MSCSRT			; カーソルスタート
	RET
WIDSTAT	ENDP


CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	W_STAT_HEAD_NO		; ヘッダー番号

EXTRN	WDX1:WORD		; WINDOWS/ point x1.
EXTRN	WDY1:WORD		; WINDOWS/ point y1.
EXTRN	WDX2:WORD		; WINDOWS/ point x2.
EXTRN	WDY2:WORD		; WINDOWS/ point y2.

W_STAT_HEAD_NO	DW	0	; ヘッダー番号

DATA	ENDS

	END
;
;	end of "WIDSTAT.ASM"
;
