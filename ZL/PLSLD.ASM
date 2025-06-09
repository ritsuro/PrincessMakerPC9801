; "PLSLD.ASM" 1989/3/18 R.H
;      modify 1989/12/12 R.H
;              PC-9801UV11 make by R.H 1989
; public subroutine.
;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;
;	1990/02/05  縦横バイト並べ戻し,ＶＲＡＭ偶数ライン１ビット右シフト
;
;	1990/05/10  ＺＬ用改造
;
;	ＤＳ：ＳＩ＝ＤＴＡ	圧縮データバッファ
;	ＥＳ：ＤＩ＝ＶＲＡＭ	展開データ
;	ＢＸ			ＶＲＡＭｾｸﾞﾒﾝﾄﾃｰﾌﾞﾙポインタ

;	"DISKio.ASM"のＤＴＡＬＥＮを参照して長さ指定を
;	合わせてください（DTALEN EQU 65534-44 ; DTA length.）

DTA_LENGTH	EQU	65534-44 ; "DISKio.ASM" ＤＴＡバッファ長さ
DTA		EQU	0	; "DISKio.ASM" ＤＴＡオフセット

MAX_VRAM_POINT	EQU	32000	; ＶＲＡＭ１プレーンの終わりオフセット

PLEAN_MAX	EQU	4	; vram plean number.


GET1BYTE	MACRO
	LOCAL	L1
				; "DISKIO.ASM" ＤＴＡバッファ長さ
	CMP	SI,DTA+DTA_LENGTH
	JNE	L1

	PUSH	DS
	MOV	AX,SEG DATA
	MOV	DS,AX
	CALL	DSK600
	POP	DS

	MOV	SI,DTA		; ＤＴＡ
L1:
	LODSB
ENDM


VRAMPUT	MACRO	EXITLABEL
	LOCAL	L1,L2

	CMP	DI,MAX_VRAM_POINT ;ＶＲＡＭ１プレーン終わりオフセット
	JNE	L1

	INC	BX
	INC	BX

	CMP	BX,PLEAN_MAX*2		; vram plean number.
	JNE	L2
	JMP	EXITLABEL
L2:
	PUSH	DS
	MOV	DX,SEG DATA		;
	MOV	DS,DX			;
	MOV	DX,DS:ARASEG[BX]	; ES <- vram segment.
	MOV	ES,DX			;
	POP	DS			;

	MOV	DI,0
L1:
	STOSB
ENDM




CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	LDPLS		;load pless 16 color CRT data.

	EXTRN	DSKOPN:NEAR	; file open.
	EXTRN	DSKCLS:NEAR	; file close.

	EXTRN	DSK600:NEAR	; DTA read.

	EXTRN	VCHRTW:NEAR	; 縦横バイト並べ戻し
	EXTRN	VCHSER:NEAR	; ＶＲＡＭ偶数ライン１ビット右シフト



; load pless 16 color CRT data.
; -i- SI : file name.
;          NULL = end of string.
;

LDPLS	PROC	NEAR
	PUSH	SI

	CALL	PLS_FLNSET	; 画面圧縮ファイル名セット

	MOV	SI,OFFSET FPSNAM ; ファイル名
	CALL	FLPLSOPEN	; file open.

	CMP	AX,1		; if open error then exit.
	JE	LDPLS9		;

	CALL	LDPLSDSPLY	; data read & convert.

	CALL	FLPLSCLOSE	; file close.
LDPLS9:
;*NON*;	CALL	VCHRTW		; 縦横バイト並べ戻し
;*NON*;	CALL	VCHSER		; ＶＲＡＭ偶数ライン１ビット右シフト

	POP	SI
	RET
LDPLS	ENDP




;	file read & convert.
;

LDPLSDSPLY	PROC	NEAR
	PUSH	DS

	CALL	DSK600

	CALL	VRMINI		; vram access init.

LDPLSDSPLY0:
	GET1BYTE		; <<data attrbute>>

LDPLSDSPLY1:
	CMP	AL,01		; if 01 then non pless.
	JNZ	LDPLSDSPLY2	;

	CALL	LDPLSDSP1
	CMP	AH,0		; if E.O.F then exit.
	JNZ	LDPLSDSPLY9	;

	JMP	LDPLSDSPLY55

LDPLSDSPLY2:
	CMP	AL,02		; if 02 then 0 data.
	JNZ	LDPLSDSPLY3	;

	CALL	LDPLSDSP2
	CMP	AH,0		; if E.O.F then exit.
	JNZ	LDPLSDSPLY9	;

	JMP	LDPLSDSPLY55

LDPLSDSPLY3:
	CMP	AL,03		; if 03 then same data.
	JNZ	LDPLSDSPLY4	;

	CALL	LDPLSDSP3
	CMP	AH,0		; if E.O.F then exit.
	JNZ	LDPLSDSPLY9	;

	JMP	LDPLSDSPLY55

LDPLSDSPLY4:
	CMP	AL,00		; if 00 then exit.
	JE	LDPLSDSPLY9	;

	JMP	LDPLSDSPLY9	; else exit.

LDPLSDSPLY55:
	JMP	LDPLSDSPLY0	; loop end.

LDPLSDSPLY9:
	POP	DS
	RET
LDPLSDSPLY	ENDP


;	non pless data. = 01h

LDPLSDSP1	PROC	NEAR
	GET1BYTE		; <<data length>>

	MOV	CX,0
	MOV	CL,AL
			; ＶＲＡＭ１プレーン終わりオフセット
	CMP	DI,MAX_VRAM_POINT-256
	JNB	LDPLSDSP11
			; "DISKIO.ASM" ＤＴＡバッファ長さ
	CMP	SI,DTA+DTA_LENGTH-256
	JB	LDPLSDSP1_SPD
LDPLSDSP11:
	GET1BYTE		; <<image data>>
	VRAMPUT	LDPLSDSP19	;
	LOOP	LDPLSDSP11	;

	MOV	AH,0		; normal.
	RET
LDPLSDSP19:
	MOV	AH,1		; E.O.F
	RET
LDPLSDSP1_SPD:
	REP	MOVSB
	MOV	AH,0		; normal
	RET
LDPLSDSP1	ENDP


;	zero data. = 02h

LDPLSDSP2	PROC	NEAR
	GET1BYTE		; <<data length>>

	MOV	CX,0
	MOV	CL,AL
	MOV	AL,0		; data=0;
			; ＶＲＡＭ１プレーン終わりオフセット
	CMP	DI,MAX_VRAM_POINT-256
	JB	LDPLSDSP2_SPD
LDPLSDSP21:
	VRAMPUT	LDPLSDSP29	;
	LOOP	LDPLSDSP21	;

	MOV	AH,0		; normal.
	RET
LDPLSDSP29:
	MOV	AH,1		; E.O.F
	RET
LDPLSDSP2_SPD:
	REP	STOSB
	MOV	AH,0		; normal
	RET
LDPLSDSP2	ENDP


;	same data. = 03h

LDPLSDSP3	PROC	NEAR
	GET1BYTE		; <<data length>>

	MOV	CX,0		;
	MOV	CL,AL		; loop counter

	GET1BYTE		; <<image data>>
			; ＶＲＡＭ１プレーン終わりオフセット
	CMP	DI,MAX_VRAM_POINT-256
	JB	LDPLSDSP3_SPD
LDPLSDSP31:
	VRAMPUT	LDPLSDSP39	;
	LOOP	LDPLSDSP31	;

	MOV	AH,0		; normal.
	RET
LDPLSDSP39:
	MOV	AH,1		; E.O.F
	RET
LDPLSDSP3_SPD:
	REP	STOSB
	MOV	AH,0		; normal
	RET
LDPLSDSP3	ENDP



;	file open.
; -i- SI : file name.
;          NULL = end of string.
; -o- AX : 0:normal.
;	   1:open error.

FLPLSOPEN	PROC	NEAR
	CALL	DSKOPN		; file open.
	RET
FLPLSOPEN	ENDP


;	file close.
;

FLPLSCLOSE	PROC
	CALL	DSKCLS		; file close.
	RET
FLPLSCLOSE	ENDP



; vram access init.
; -O- old DS:[ARASEG] : VRAM segment table.
;     DS : DTA segment.
;     SI : DTA pointer.
;     ES : VRAM segment.
;     DI : VRAM pointer.
;     BX : VRAM SEG table pointer.

VRMINI	PROC	NEAR

	MOV	AX,SSGR0	; visual data segment plean 0
	MOV	WORD PTR DS:ARASEG[0],AX

	MOV	ES,AX		; init
	MOV	DI,0		; VRAM address pointer.

	MOV	AX,SSGR1	; visual data segment plean 1
	MOV	WORD PTR DS:ARASEG[2],AX

	MOV	AX,SSGR2	; visual data segment plean 2
	MOV	WORD PTR DS:ARASEG[4],AX

	MOV	AX,SSGR3	; visual data segment plean 3
	MOV	WORD PTR DS:ARASEG[6],AX


	MOV	BX,0		; VRAM SEG table pointer.

	MOV	AX,SEGDOS	; DTA segment.
	MOV	DS,AX		;
	MOV	SI,DTA		; DTA buffer pointer.

	RET
VRMINI	ENDP


;	画面圧縮ファイル名セット
;	-I- DS:SI : ファイル名

PLS_FLNSET	PROC	NEAR
	PUSH	SI

	MOV	AX,DS
	MOV	ES,AX

	MOV	DI,OFFSET FPSNAM	; ファイル名クリア
	MOV	CX,8
	MOV	AL,' '
	REP	STOSB

	MOV	DI,OFFSET FPSNAM	; ファイル名
	MOV	CX,8
PLS_FLNSET2:
	LODSB
	CMP	AL,' '			; end of string.
	JB	PLS_FLNSET3		;
	STOSB
	LOOP	PLS_FLNSET2
PLS_FLNSET3:
	POP	SI
	RET
PLS_FLNSET	ENDP


CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

EXTRN	SEGDOS:WORD		; ＤＯＳインターフェースセグメント

	EVEN

FPSNAM	DB	"        PLS",0	; ファイル名

ARASEG	DW	0,0,0,0		; segment table.

DATA	ENDS

	END
;
;	end of "PLSLD.ASM"
;
