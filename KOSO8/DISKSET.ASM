; "DISKSET.ASM" PC-9801UV11 make by R.H 1991/03/13
;
;	ＤＩＳＫのセーブデータ管理
;
; public subroutine.

INCLUDE	TSTSET.INC

CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	DISKMX			; セーブマトリックス検索
PUBLIC	DISKFL			; セーブファイル名

EXTRN	DISKFLCHK:NEAR		; disk file search.

; ****************************************************
;	セーブマトリックス検索
;	-I- MTRX_ADRS : マトリックス・アドレス
;	    DX        : ユーザディスクドライブ番号(1-4,0=ｶﾚﾝﾄ)
; ****************************************************

DISKMX	PROC	NEAR
	MOVX	MTRX_PNT,MTRX_ADRS	; マトリックス・アドレス

	MOV	DRIVE_NUMBER,DX		; ＦＤドライブ番号

	MOV	MTRX_XX,0		; マトリックスＸ
	MOV	MTRX_YY,0		; マトリックスＹ
	MOV	CX,4
DISKMX_LOOP_YY:
	PUSH	CX
	MOV	CX,10
DISKMX_LOOP_XX:
	PUSH	CX
	CALL	DISKNM			; セーブデータ名
	CALL	FILE_CHK		; 指定ファイルがあるか検索
	CMP	AX,1			; 1=ある,2=ない
	JNE	DISKMX_4		;
	MOV	AX,1			; ありパターン
	JMP	DISKMX_5		;
DISKMX_4:				;
	MOV	AX,0			; ないパターン
DISKMX_5:				;
	MOV	SI,MTRX_PNT		; マトリックス・アドレス
	MOV	DS:[SI],AL		;
	INC	MTRX_PNT		; マトリックス・アドレス
	INC	MTRX_XX			; マトリックスＸ
	POP	CX			;
	LOOP	DISKMX_LOOP_XX		;
	INC	MTRX_YY			; マトリックスＹ
	POP	CX			;
	LOOP	DISKMX_LOOP_YY		;

	RET
DISKMX	ENDP


; ****************************************************
;	セーブファイル名
;	-I- DX      : ユーザディスクドライブ番号(1-4,0=ｶﾚﾝﾄ)
;	    MTRX_XX : マトリックスＸ
;	    MTRX_YY : マトリックスＹ
;	-O- MXFLNAME: データファイル名
; ****************************************************

DISKFL	PROC	NEAR
	MOV	DRIVE_NUMBER,DX		; ＦＤドライブ番号
	CALL	DISKNM			; セーブデータ名
	RET
DISKFL	ENDP


; ****************************************************
;	セーブデータ名
;	-I- DRIVE_NUMBER : ユーザディスクドライブ番号(1-4,0=ｶﾚﾝﾄ)
;	    MTRX_XX : マトリックスＸ
;	    MTRX_YY : マトリックスＹ
;	-O- MXFLNAME: データファイル名
; ****************************************************

DISKNM	PROC	NEAR
	CMP	DRIVE_NUMBER,0		; 0=ｶﾚﾝﾄ
	JE	DISKNM_2		;

	MOV	BX,DRIVE_NUMBER		; ＦＤドライブ番号
	DEC	BX			;
	MOV	AL,DS:DRIVE_NAME[BX]	; "ABCDEFG" ドライブ名
	MOV	MXFLDRV,AL		; ＦＤドライブ名 "A:"

DISKNM_2:
	MOV	DX,MTRX_XX		; マトリックスＸ
	CALL	DECSTR			; dec -> string.
	MOVXB	MXFLXX,DS:[SI][4]	; "00007" -> '7'

	MOV	DX,MTRX_YY		; マトリックスＹ
	CALL	DECSTR			; dec -> string.
	MOVXB	MXFLYY,DS:[SI][4]	; "00007" -> '7'

	MOVX	ES,DS			;
	MOV	DI,OFFSET MXFLNAME	; データファイル名

	MOV	SI,OFFSET MXFLDRV	; ＦＤドライブ名
	MOV	CX,14			; "A:PRCS32.GNX",0,0

	CMP	DRIVE_NUMBER,0		; 0=ｶﾚﾝﾄ
	JNE	DISKNM_7		;
	MOV	SI,OFFSET MXFLTOP	; "PRCS32.GNX",0,0
	MOV	CX,12			;
DISKNM_7:				;
	REP	MOVSB			;

	PRS	"MXFLNAME=",MXFLNAME
	RET
DISKNM	ENDP


; ****************************************************
;	指定ファイルがあるか検索
;	-I- MXFLNAME : データファイル名
;	-O- AX       : 1=ある,2=ない
; ****************************************************

FILE_CHK	PROC	NEAR
	MOV	SI,OFFSET MXFLNAME	; データファイル名
	CALL	PRINT			; print.

	MOV	SI,OFFSET MXFLNAME	; データファイル名
	CALL	DISKFLCHK		; disk file search.
	PRV	":AX=",AX
	RET
FILE_CHK	ENDP


; ****************************************************
;	ＷＯＲＫ
; ****************************************************
	EVEN
PUBLIC		MTRX_XX			; マトリックスＸ
PUBLIC		MTRX_YY			; マトリックスＹ
PUBLIC		MXFLNAME		; データファイル名
PUBLIC		MTRX_ADRS		; マトリックス・アドレス

MTRX_XX		DW	0		; マトリックスＸ
MTRX_YY		DW	0		; マトリックスＹ

MXFLNAME	LABEL	BYTE		; データファイル名
		DB	"A:PRCSyx.GNX",0,0

MXFLDRV		DB	"A:"		; ＦＤドライブ名
MXFLTOP		DB	"PRCS"		; "PRCS32.GNX"
MXFLYY		DB	"y"		; y
MXFLXX		DB	"x"		; x
		DB	".GNX",0,0	; 拡張子

MTRX_ADRS	DW	0		; マトリックス・アドレス
MTRX_PNT	DW	0		; マトリックス・ポインタ

DRIVE_NAME	DB	"ABCDEFG",0	; ドライブ名

DRIVE_NUMBER	DW	0		; ＦＤドライブ番号

CODE	ENDS

	END
;
;	end of "DISKSET.ASM"
;
