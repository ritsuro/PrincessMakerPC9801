; "PLTPAT.ASM" PC-9801UV11 make by R.H 1990/05/11
;
;	パーツバッファからパレットデータを取り出す
;
;	パレットのサイズ (PALET_LEN) に注意すること
;	(DSKPLT.ASMと同様)

INCLUDE	TSTSET.INC

PALET	SEGMENT	PUBLIC	'PALET'

EXTRN	PLTNUM:WORD		; ハードパレットテーブル
EXTRN	PLTOFS:WORD		; パレットアドレステーブル（色相）
EXTRN	PCNOFS:WORD		; パレットアドレステーブル（彩度）
EXTRN	PBROFS:WORD		; パレットアドレステーブル（明度）

PALET	ENDS


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	PLTPAT		; パーツバッファからパレットを取り出す

EXTRN	PATBPT:NEAR	; バイナリデータ読み出し


PALET_LEN	EQU	8*2*6	; パレットのバイト数


; *******************************************
;	パーツバッファからパレットを取り出す
;	-I- CX : パーツ番号
;	    BX : パレットテーブル番号
; *******************************************

PLTPAT	PROC	NEAR
	PUSH	CX
	PUSH	BX

	MOV	AX,SEG PALET		; パレット用セグメント
	MOV	ES,AX			;
	SHL	BX,1			; dobule word pointer.
	SHL	BX,1			;
	MOV	AX,ES:PLTOFS[BX]	; パレットアドレステーブル（色相）

	MOV	DX,ES			; パレット用セグメント
	MOV	SI,AX			; パレットテーブル先頭
	CALL	PATBPT			; バイナリデータ読み出し

	POP	BX
	POP	CX
	RET
PLTPAT	ENDP

CODE	ENDS


DATA	SEGMENT	PUBLIC	'DATA'
DATA	ENDS

	END
;
;	end of "PLTPAT.ASM"
;
