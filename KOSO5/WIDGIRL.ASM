; "WIDGIRL.ASM" PC-9801UV11 make by R.H 1990/10/30
;
;
;	ＷＩＮＤＯＷＳ／ＧＩＲＬウインドウ
;
;
;	WID_GIRL_INIT		; WINDOWS/ＧＩＲＬウインドウ初期処理
;	WID_GIRL		; WINDOWS/ＧＩＲＬウインドウ
;	WID_GIRL_BORTH		; WINDOWS/ＧＩＲＬウインドウ成長
;	WID_GIRL_FACE		; WINDOWS/ＧＩＲＬウインドウ顔
;	WID_GIRL_KIGAE		; WINDOWS/ＧＩＲＬウインドウ着替え
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC

GIRL_XX		EQU	-5	; 補正Ｘ
GIRL_YY		EQU	0	; 補正Ｙ


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
;	WINDOWS/ＧＩＲＬウインドウ初期処理
; ****************************************************

FUNC	WWID_GIRL_INIT,WID_GIRL_INIT
	RET
FEND	WWID_GIRL_INIT


; ****************************************************
;	WINDOWS/ＧＩＲＬウインドウ
;	-I- W_GIRL_GROW   : 少女（成長１,成長２,成長３,成長４）
;	    W_GIRL_SEASON : 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
; ****************************************************

FUNC	WWID_GIRL,WID_GIRL
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択

	CALL	PUT_SET_BASE		; キャラクタ・ベース
	CALL	PUT_SET_FACE		; 顔変化
	CALL	PUT_SET_DRESS		; 服変化（４シーズン）

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
	RET
FEND	WWID_GIRL


; ****************************************************
;	WINDOWS/ＧＩＲＬウインドウ成長
;	-I- W_GIRL_GROW   : 少女（成長１,成長２,成長３,成長４）
;	    W_GIRL_SEASON : 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
; ****************************************************

FUNC	WWID_GIRL_BORTH,WID_GIRL_BORTH
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択

	CALLC	VRMWT1			; ＶＲＡＭ１アクセス

	CALLC	WIDFRM_MAIN_X		; WINDOWS/フレーム・メイン（簡略版）

	CALL	PUT_SET_BASE		; キャラクタ・ベース
	CALL	PUT_SET_FACE		; 顔変化
	CALL	PUT_SET_DRESS		; 服変化（４シーズン）

	;	0			; 左上Ｘ
	;	0			; 左上Ｙ
	;	51			; サイズＸ
	;	400			; サイズＹ

	CODE_IN
	MOVE_IMG	ARAVRM,ARA001,0,0,53,400,0,0	; 本当は51
			; 仮想ＶＲＡＭプレーン１（ＤＯＳ＋パーツ＃０）
	CALL		VRMWT0			; ＶＲＡＭ０アクセス
	MOVE_IMG	ARA001,ARAVRM,51,357,2,43,51,357	; 本当は51
	OL_IMG		ARA001,ARAVRM,0,0,51,400,0,0
	CODE_OUT

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
	RET
FEND	WWID_GIRL_BORTH


; ****************************************************
;	WINDOWS/ＧＩＲＬウインドウ顔
;	-I- W_GIRL_GROW   : 少女（成長１,成長２,成長３,成長４）
;	    W_GIRL_SEASON : 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
; ****************************************************

FUNC	WWID_GIRL_FACE,WID_GIRL_FACE
;*;	MOV	AX,1			; 1=外部ウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択

	CODE_IN
	MOVE_IMG	ARAVRM,ARA001,0,0,51,400,0,0	;
	CALL		VRMWT1				; ＶＲＡＭ１アクセス
	MOVE_IMG	ARA001,ARAVRM,0,0,51,400,0,0	;
	CODE_OUT

	CALL	PUT_SET_FACE		; 顔変化

	CODE_IN
	MOVE_IMG	ARAVRM,ARA001,0,0,51,400,0,0	;
	CALL		VRMWT0				; ＶＲＡＭ０アクセス
	OL_IMG		ARA001,ARAVRM,0,0,51,400,0,0	;
	CODE_OUT

;*;	MOV	AX,0			; 0=内部のウインドウを使う
;*;	CALLC	DKCWID			; ﾃﾞｨｽｸﾁｪﾝｼﾞ表示するウインドウの選択
	RET
FEND	WWID_GIRL_FACE


; ****************************************************
;	WINDOWS/ＧＩＲＬウインドウ着替え
; ****************************************************

FUNC	WWID_GIRL_KIGAE,WID_GIRL_KIGAE
	CALL	FAR PTR WWID_GIRL_BORTH	; WINDOWS/ＧＩＲＬウインドウ成長
	RET
FEND	WWID_GIRL_KIGAE


; ****************************************************
;	キャラクタ・ベース
;	-I- W_GIRL_GROW : 少女（成長１,成長２,成長３,成長４）
; ****************************************************

PUT_SET_BASE	PROC	NEAR
;*;	CODE_IN
;*;	PRV	"c W_GIRL_GROW=",W_GIRL_GROW
;*;	CODE_OUT
	MOV	DX,W_GIRL_GROW		; 少女（成長１,成長２,成長３,成長４）
	MOV	AX,GIRL_XX		; 補正Ｘ
	MOV	BX,GIRL_YY		; 補正Ｙ
	CALLC	PT_CHR_BASE		; キャラクタ・ベース
	RET
PUT_SET_BASE	ENDP


; ****************************************************
;	服変化（４シーズン）
;	-I- W_GIRL_GROW   : 少女（成長１,成長２,成長３,成長４）
;	    W_GIRL_SEASON : 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
; ****************************************************

PUT_SET_DRESS	PROC	NEAR
;*;	CODE_IN
;*;	PRV	"f W_GIRL_GROW=",W_GIRL_GROW
;*;	PRV	"f W_GIRL_SEASON=",W_GIRL_SEASON
;*;	CODE_OUT
	MOV	DX,W_GIRL_GROW		; 少女（成長１,成長２,成長３,成長４）
	MOV	CX,W_GIRL_SEASON	; 季節服
	CMP	CX,0			;
	JE	PUT_SET_DRESS_EXIT	;

	MOV	AX,GIRL_XX		; 補正Ｘ
	MOV	BX,GIRL_YY		; 補正Ｙ
	CALLC	PT_CHR_DRESS		; 服変化（４シーズン）
PUT_SET_DRESS_EXIT:
	RET
PUT_SET_DRESS	ENDP


; ****************************************************
;	顔変化
;	-I- W_GIRL_GROW   : 少女（成長１,成長２,成長３,成長４）
;	    W_GIRL_FACE   : 顔（１－３）
; ****************************************************

PUT_SET_FACE	PROC	NEAR
	MOV	DX,W_GIRL_GROW		; 少女（成長１,成長２,成長３,成長４）
	MOV	CX,W_GIRL_FACE		; 顔（１－３）
	MOV	AX,GIRL_XX		; 補正Ｘ
	MOV	BX,GIRL_YY		; 補正Ｙ
	CALLC	PT_CHR_FACE		; 顔変化
	RET
PUT_SET_FACE	ENDP

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	W_GIRL_SEASON		; 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
PUBLIC	W_GIRL_GROW		; 少女（成長１,成長２,成長３,成長４）
PUBLIC	W_GIRL_FACE		; 顔（１－３）

W_GIRL_SEASON	DW	1	; 季節服（0:無,1:春服，2:夏服，3:秋服，4:冬服）
W_GIRL_GROW	DW	1	; 少女（成長１,成長２,成長３,成長４）
W_GIRL_FACE	DW	1	; 顔（１－３）

DATA	ENDS

	END
;
;	end of "WIDGIRL.ASM"
;
