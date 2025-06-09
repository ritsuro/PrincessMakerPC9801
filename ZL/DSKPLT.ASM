; "DSKPLT.ASM" PC-9801UV11 make by R.H 1989/12/08
;
;
;	パレットファイルのアクセス
;
;
; public subroutine.

PALET	SEGMENT	PUBLIC	'PALET'
PALET	ENDS

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

PUBLIC	LODPLT			; パレットファイルロード
PUBLIC	SAVPLT			; パレットファイルセーブ

EXTRN	DSKLD:NEAR		; load data.
EXTRN	DSKSV:NEAR		; save data.

PALET_LEN	EQU	8*2*6	; パレットのバイト数


;	パレットファイルロード
;	-I- DS:SI  : ファイル名 (null=end of string)
;	    BX	   : パレットテーブル番号

LODPLT	PROC	NEAR
	PUSH	SI
	PUSH	BX

	CALL	PFLNSET	 		; パレットファイル名セット

	SHL	BX,1			; パレットテーブル番号
	SHL	BX,1			; * 4

	MOV	AX,SEG PALET
	MOV	ES,AX
	MOV	AX,ES:PLTOFS[BX] ; パレットアドレステーブル（色相）

	MOV	DI,AX			; offset.
	MOV	DX,SEG PALET		; segment.
	MOV	CX,PALET_LEN		; パレットのバイト数
	MOV	SI,OFFSET FLNAME	; パレットファイル名
	CALL	DSKLD			; file load.

	POP	BX
	POP	SI
	RET
LODPLT	ENDP


;	パレットファイルセーブ
;	-I- DS:SI  : ファイル名 (null=end of string)
;	    BX	   : パレットテーブル番号

SAVPLT	PROC	NEAR
	PUSH	SI
	PUSH	BX

	CALL	PFLNSET	 		; パレットファイル名セット

	SHL	BX,1			; パレットテーブル番号
	SHL	BX,1			; * 4

	MOV	AX,SEG PALET
	MOV	ES,AX
	MOV	AX,ES:PLTOFS[BX] ; パレットアドレステーブル（色相）

	MOV	DI,AX			; offset.
	MOV	DX,SEG PALET		; segment.
	MOV	CX,PALET_LEN		; パレットのバイト数
	MOV	SI,OFFSET FLNAME	; パレットファイル名
	CALL	DSKSV			; file save.

	POP	BX
	POP	SI
	RET
SAVPLT	ENDP


;	パレットファイル名セット
;	-I- DS:SI : ファイル名

PFLNSET	PROC	NEAR
	PUSH	SI

	MOV	AX,DS
	MOV	ES,AX

	MOV	DI,OFFSET FLNAME	; ファイル名クリア
	MOV	CX,8
	MOV	AL,' '
	REP	STOSB

	MOV	DI,OFFSET FLNAME	; ファイル名
	MOV	CX,8
PFLNSET2:
	LODSB
	CMP	AL,' '			; end of string.
	JB	PFLNSET3		;
	STOSB
	LOOP	PFLNSET2
PFLNSET3:
	POP	SI
	RET
PFLNSET	ENDP

CODE	ENDS


PALET	SEGMENT	PUBLIC	'PALET'

EXTRN	PLTOFS:WORD		; パレットアドレステーブル（色相）
EXTRN	PCNOFS:WORD		; パレットアドレステーブル（彩度）
EXTRN	PBROFS:WORD		; パレットアドレステーブル（明度）

PALET	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

FLNAME	DB	"        ALG",0		; ファイル名

DATA	ENDS

	END
;
;	end of "DSKPLT.ASM"
;
