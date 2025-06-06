; "WIDBACK.ASM" PC-9801UV11 make by R.H 1990/10/13
;
;
;	ＷＩＮＤＯＷＳ／画面退避
;
;
;	WIDBACK_SAVE		; WINDOWS/画面退避・ＳＡＶＥ
;	WIDBACK_LOAD		; WINDOWS/画面退避・ＬＯＡＤ
;
;
;	SEGDOS:WORD		; ＤＯＳインターフェースセグメント
;
;	使用時 WIDFREAM.ASM の WIDDSP_SAVE も参照して下さい
;
; (C) 1990 ritsurou hashimoto.

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

SUBX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	SUB	DEST,AX
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM

MOVE_SET	MACRO	SOUID,DESTID,X1,Y1,X2,Y2,X3,Y3
	MOV	AX,WORD PTR SOUID[0]
	MOV	SSSOU0,AX
	MOV	AX,WORD PTR SOUID[2]
	MOV	SSSOU1,AX
	MOV	AX,WORD PTR SOUID[4]
	MOV	SSSOU2,AX
	MOV	AX,WORD PTR SOUID[6]
	MOV	SSSOU3,AX
	MOV	AX,WORD PTR DESTID[0]
	MOV	SSDES0,AX
	MOV	AX,WORD PTR DESTID[2]
	MOV	SSDES1,AX
	MOV	AX,WORD PTR DESTID[4]
	MOV	SSDES2,AX
	MOV	AX,WORD PTR DESTID[6]
	MOV	SSDES3,AX
	MOV	AX,X1
	MOV	WORD PTR VX1,AX
	MOV	AX,Y1
	MOV	WORD PTR VY1,AX
	MOV	AX,X2
	MOV	WORD PTR VX2,AX
	MOV	AX,Y2
	MOV	WORD PTR VY2,AX
	MOV	AX,X3
	MOV	WORD PTR VX3,AX
	MOV	AX,Y3
	MOV	WORD PTR VY3,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA

; ****************************************************
;	WINDOWS/画面退避・ＳＡＶＥ
;	-I- AX : 左上Ｘ
;	    BX : 左上Ｙ
;	    CX : サイズＸ
;	    DX : サイズＹ
; ****************************************************

FUNC	WWIDBACK_SAVE,WIDBACK_SAVE
	MOV	XX1,AX
	MOV	YY1,BX
	MOV	XX2,CX
	MOV	YY2,DX
	MOV	XX3,AX
	MOV	YY3,BX

	CALLC	VRMWT0			; ＶＲＡＭ０アクセス
	MOVE_SET ARAVRM,ARA001,XX1,YY1,XX2,YY2,XX3,YY3
	CALLC	MOVEVR			; vram to vram move.

	CALLC	VRMWT1			; ＶＲＡＭ１アクセス
	MOVE_SET ARA001,ARAVRM,XX1,YY1,XX2,YY2,XX3,YY3
	CALLC	MOVEVR			; vram to vram move.

	CALLC	VRMWT0			; ＶＲＡＭ０アクセス
	RET
FEND	WWIDBACK_SAVE


; ****************************************************
;	WINDOWS/画面退避・ＬＯＡＤ
;	-I- AX : 左上Ｘ
;	    BX : 左上Ｙ
;	    CX : サイズＸ
;	    DX : サイズＹ
; ****************************************************

FUNC	WWIDBACK_LOAD,WIDBACK_LOAD
	MOV	XX1,AX
	MOV	YY1,BX
	MOV	XX2,CX
	MOV	YY2,DX
	MOV	XX3,AX
	MOV	YY3,BX

	CALLC	VRMWT1			; ＶＲＡＭ１アクセス
	MOVE_SET ARAVRM,ARA001,XX1,YY1,XX2,YY2,XX3,YY3
	CALLC	MOVEVR			; vram to vram move.

	CALLC	VRMWT0			; ＶＲＡＭ０アクセス
	MOVE_SET ARA001,ARAVRM,XX1,YY1,XX2,YY2,XX3,YY3
	CALLC	MOVEVR			; vram to vram move.

	RET
FEND	WWIDBACK_LOAD

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SEGDOS:WORD		; ＤＯＳインターフェースセグメント

XX1	DW	0
YY1	DW	0
XX2	DW	0
YY2	DW	0
XX3	DW	0
YY3	DW	0

DATA	ENDS

	END
;
;	end of "WIDBACK.ASM"
;
