; "MUSYA.ASM" PC-9801UV11 make by R.H 1990/12/29
;
;	プリンセスメーカー版
;	MUSYA ver0.1 (C) 1991 r.hashimoto
;
;	エディット・モード
;
;	MUSYA EDIT
;
;	プリメ・プロセスの呼出し形式
;	     'PRCS'=password.
;	MUSYA PRCS
;
;	-I- BH : function.
;		1=init
;		2=move
;		3=rewrite
;	    CX : direction x.(-1,0,+1)
;	    DX : direction y.(-1,0,+1)
;	-O- BL : status.
;		1=ok.
;		2=kabe.
;		3=catch.
;		4=end.
;
; public subroutine.

INCLUDE	TSTSET.INC

FDTOOL_COM_SPC		EQU	81H		; ' '
FDTOOL_COM_P		EQU	82H		; 'P'	呼出しのスイッチ
FDTOOL_COM_R		EQU	83H		; 'R'	.
FDTOOL_COM_C		EQU	84H		; 'C'	.
FDTOOL_COM_S		EQU	85H		; 'S'	.
FDTOOL_COM_FDD		EQU	86H		; 'A'	ＦＤドライブ先頭
FDTOOL_COM_OFS		EQU	87H		; '1234'.
FDTOOL_COM_SEG		EQU	8BH		; '6543'.

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

EXTRN	MAINLOOP:NEAR			; main loop.
EXTRN	MAINEXTRN:NEAR			; main extrun process.

EXTRN	MUSSTP:NEAR			; マウスの終了

; ****************************************************
;	PROGRAM CODE
; ****************************************************

	ORG	100H
START:
	MOV	COM_PARA_BX,BX		; プリメ・プロセスの呼出しＢＸ
	MOV	COM_PARA_CX,CX		; プリメ・プロセスの呼出しＣＸ
	MOV	COM_PARA_DX,DX		; プリメ・プロセスの呼出しＤＸ

	CALL	MAIN			; main proc.

	MOV	BX,COM_RETU_BX		; プリメ・プロセスの戻り値ＢＸ
	MOV	CX,COM_RETU_CX		; プリメ・プロセスの戻り値ＣＸ
	MOV	DX,COM_RETU_DX		; プリメ・プロセスの戻り値ＤＸ

	CMP	PRINCESS_PROC,1		; プリンセスメーカーのプロセス 1=on
	JE	FINALE_PRINCESS		;
FINALE:
	MOV	AH,4CH			; return to DOS.
	MOV	AL,0			;
	INT	21H			; end.
					;
	JMP	MUGEN			;

FINALE_PRINCESS:
	MOV	AX,0			;
	JMP	AX			; return to PRINCESS.
MUGEN:					;
	JMP	MUGEN			;

; ****************************************************
;	MAIN.
; ****************************************************

MAIN	PROC	NEAR
	; (1) プリメ・プロセスかをチェック

	CMP	BYTE PTR DS:[FDTOOL_COM_SPC],' '
	JMPNE	MAIN_NORMAL_START
	CMP	BYTE PTR DS:[FDTOOL_COM_P],'P'
	JMPNE	MAIN_NORMAL_START
	CMP	BYTE PTR DS:[FDTOOL_COM_R],'R'
	JMPNE	MAIN_NORMAL_START
	CMP	BYTE PTR DS:[FDTOOL_COM_C],'C'
	JMPNE	MAIN_NORMAL_START
	CMP	BYTE PTR DS:[FDTOOL_COM_S],'S'
	JMPNE	MAIN_NORMAL_START

	MOV	PRINCESS_PROC,1		; プリンセスメーカーのプロセス 1=on

;*;	LC	0,10
;*;	PRF	"MUSYA.COM"
;*;	PRV	"BX=",BX
;*;	PRV	"CX=",CX
;*;	PRV	"DX=",DX

	CALL	MAINEXTRN		; main extrun process.

	MOV	COM_RETU_BX,BX		; プリメ・プロセスの戻り値ＢＸ
	MOV	COM_RETU_CX,CX		; プリメ・プロセスの戻り値ＣＸ
	MOV	COM_RETU_DX,DX		; プリメ・プロセスの戻り値ＤＸ
	RET

MAIN_NORMAL_START:

	; (2) エディット・モードかをチェック

	CMP	BYTE PTR DS:[FDTOOL_COM_SPC],' '
	JNE	MAIN_EXIT
	CMP	BYTE PTR DS:[FDTOOL_COM_P],'E'
	JNE	MAIN_EXIT
	CMP	BYTE PTR DS:[FDTOOL_COM_R],'D'
	JNE	MAIN_EXIT
	CMP	BYTE PTR DS:[FDTOOL_COM_C],'I'
	JNE	MAIN_EXIT
	CMP	BYTE PTR DS:[FDTOOL_COM_S],'T'
	JNE	MAIN_EXIT

	CALL	MAINLOOP		; main loop.

MAIN_EXIT:
	CALL	MUSSTP			; マウスの終了
	RET
MAIN	ENDP


; ****************************************************
;	DATA
; ****************************************************
	EVEN

PUBLIC	PRINCESS_PROC			; プリンセスメーカーのプロセス 1=on
PRINCESS_PROC	DW	0		; プリンセスメーカーのプロセス 1=on

COM_PARA_BX	DW	0		; プリメ・プロセスの呼出しＢＸ
COM_PARA_CX	DW	0		; プリメ・プロセスの呼出しＣＸ
COM_PARA_DX	DW	0		; プリメ・プロセスの呼出しＤＸ

COM_RETU_BX	DW	0		; プリメ・プロセスの戻り値ＢＸ
COM_RETU_CX	DW	0		; プリメ・プロセスの戻り値ＣＸ
COM_RETU_DX	DW	0		; プリメ・プロセスの戻り値ＤＸ

CODE	ENDS

	END	START
;
;	end of "MUSYA.ASM"
;
