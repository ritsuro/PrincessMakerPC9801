; "WIDBG.ASM" PC-9801UV11 make by R.H 1990/10/30
;
;
;	ＷＩＮＤＯＷＳ／ＢＧウインドウ
;
;
;	WID_BG_INIT		; WINDOWS/ＢＧウインドウ初期処理
;	WID_MBG_DISP		; WINDOWS/メインＢＧウインドウ表示
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
;	WINDOWS/ＢＧウインドウ初期処理
; ****************************************************

FUNC	WWID_BG_INIT,WID_BG_INIT
	RET
FEND	WWID_BG_INIT


; ****************************************************
;	WINDOWS/メインＢＧウインドウ表示
; ****************************************************

FUNC	WWID_MBG_DISP,WID_MBG_DISP
	MOV	AX,0			; ＰＵＴ　Ｘ座標
	MOV	BX,0			; ＰＵＴ　Ｙ座標
	CALLC	PT_CHR_BG_MAIN		; メインＢＧ－ＰＵＴ
	RET
FEND	WWID_MBG_DISP

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'
DATA	ENDS

	END

;
;	end of "WIDBG.ASM"
;
