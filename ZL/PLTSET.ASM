; "PLTSET.ASM" PC-9801UV11 make by R.H 1989/12/08
;
;
;	パレット操作
;
;
; public table.


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	PLSET		; パレットセット
PUBLIC	PLPSET		; パレット編集セット


EXTRN	SETCLR:NEAR	; color set.
EXTRN	CLRSET:NEAR	; color register set.


;	パレットセット
;	-I- BX : パレットテーブル番号

PLSET	PROC	NEAR
	PUSH	BX

	MOV	AX,SEG PALET	; パレットテーブル
	MOV	ES,AX		;

	MOV	DI,BX		; アドレステーブルオフセット
	SHL	DI,1		;
	SHL	DI,1		;*4

	MOV	SI,0		; color table pointer.
	CALL	PLSET8COL	; 最初の８色

	INC	DI		; アドレステーブルオフセット
	INC	DI		;+2

	MOV	SI,0		; color table pointer.
	CALL	PLSET8COL	; 残りの８色

	POP	BX
	RET

PLSET8COL:		; -I- DI : アドレステーブルオフセット
	MOV	CX,8
PLSET2:
	MOV	BX,ES:PLTNUM[DI] ; ハードパレットテーブル
	MOV	AX,ES:[SI][BX]	;
	MOV	CLRCDE,AX	; color code.

	MOV	BX,ES:PLTOFS[DI] ; パレットアドレステーブル（色相）
	MOV	AX,ES:[SI][BX]	;
	MOV	CLRVEW,AX	; color.

	MOV	BX,ES:PCNOFS[DI] ; パレットアドレステーブル（彩度）
	MOV	AX,ES:[SI][BX]	;
	MOV	CLRCNS,AX	; contrast.

	MOV	BX,ES:PBROFS[DI] ; パレットアドレステーブル（明度）
	MOV	AX,ES:[SI][BX]	;
	MOV	CLRBRI,AX	; brightness.

	PUSH	SI
	PUSH	DI
	PUSH	CX
	CALL	SETCLR		; カラーセット
	POP	CX
	POP	DI
	POP	SI

	INC	SI		; カラーテーブルオフセット
	INC	SI		;

	LOOP	PLSET2
	RET
PLSET	ENDP


;	パレット編集セット
;	-I- BX     : パレットテーブル番号
;	    CRXVEW : 色相回転（０ー３６０）
;	    CRXCNS : 彩度倍率（０ー１００）
;	    CRXBRI : 明度倍率（０ー１００）

PLPSET	PROC	NEAR
	PUSH	BX

	MOV	AX,SEG PALET	; パレットテーブル
	MOV	ES,AX		;

	MOV	DI,BX		; アドレステーブルオフセット
	SHL	DI,1		;
	SHL	DI,1		;*4

	MOV	SI,0		; color table pointer.
	CALL	PLPSET8COL	; 最初の８色

	INC	DI		; アドレステーブルオフセット
	INC	DI		;+2

	MOV	SI,0		; color table pointer.
	CALL	PLPSET8COL	; 残りの８色

	POP	BX
	RET

PLPSET8COL:		; -I- DI : アドレステーブルオフセット
	MOV	CX,8
PLPSET2:
	MOV	BX,ES:PLTNUM[DI] ; ハードパレットテーブル
	MOV	AX,ES:[SI][BX]	;
	MOV	CLRCDE,AX	; color code.

	MOV	BX,ES:PLTOFS[DI] ; パレットアドレステーブル（色相）
	MOV	AX,ES:[SI][BX]	;
	CALL	ROTVEW		; 色相回転
	MOV	CLRVEW,AX	; color.

	MOV	BX,ES:PCNOFS[DI] ; パレットアドレステーブル（彩度）
	MOV	AX,ES:[SI][BX]	;
	CALL	MLTCNS		; 彩度倍率
	CALL	MLTWHC		; 彩度ホワイトレベル
	MOV	CLRCNS,AX	; contrast.

	MOV	BX,ES:PBROFS[DI] ; パレットアドレステーブル（明度）
	MOV	AX,ES:[SI][BX]	;
	CALL	MLTBRI		; 明度倍率
	CALL	MLTWHI		; 明度ホワイトレベル
	MOV	CLRBRI,AX	; brightness.

	PUSH	SI
	PUSH	DI
	PUSH	CX
	CALL	SETCLR		; カラーセット
	POP	CX
	POP	DI
	POP	SI

	INC	SI		; カラーテーブルオフセット
	INC	SI		;

	LOOP	PLPSET2
	RET
PLPSET	ENDP


;	色相回転
;	-I/O- AX : 色相（０ー３６０）

ROTVEW	PROC	NEAR
	ADD	AX,CRXVEW	; 色相回転（０ー３６０）
	CMP	AX,360
	JLE	ROTVEW3

	SUB	AX,360
ROTVEW3:
	RET
ROTVEW	ENDP


;	彩度倍率
;	-I/O- AX : 彩度（０ー１００）

MLTCNS	PROC	NEAR
	PUSH	BX
	PUSH	DX

	MOV	BX,CRXCNS	; 彩度倍率（０ー１００）
	IMUL	BX		; AX = AX * CRXCNS

	CWD
	MOV	BX,100		; １００で割る
	IDIV	BX		; AX = AX / 100

	POP	DX
	POP	BX
	RET
MLTCNS	ENDP


;	明度倍率
;	-I/O- AX : 明度（０ー１００）

MLTBRI	PROC	NEAR
	PUSH	BX
	PUSH	DX

	MOV	BX,CRXBRI	; 明度倍率（０ー１００）
	IMUL	BX		; AX = AX * CRXBRI

	CWD
	MOV	BX,100		; １００で割る
	IDIV	BX		; AX = AX / 100

	POP	DX
	POP	BX
	RET
MLTBRI	ENDP



;	彩度ホワイトレベル
;	-I/O- AX : 彩度（０ー１００）

MLTWHC	PROC	NEAR
	PUSH	BX
	PUSH	DX

	MOV	BX,100		;
	SUB	BX,CRXWHI	; ホワイトレベル（０ー１００）
	IMUL	BX		; AX = AX * CRXBRI

	CWD
	MOV	BX,100		; １００で割る
	IDIV	BX		; AX = AX / 100

	POP	DX
	POP	BX
	RET
MLTWHC	ENDP


;	明度ホワイトレベル
;	-I/O- AX : 明度（０ー１００）

MLTWHI	PROC	NEAR
	PUSH	BX
	PUSH	DX

	MOV	BX,100		;
	SUB	BX,CRXWHI	; ホワイトレベル（０ー１００）
	IMUL	BX		; AX = AX * CRXBRI

	CWD
	MOV	BX,100		; １００で割る
	IDIV	BX		; AX = AX / 100
	ADD	AX,CRXWHI	; ホワイトレベル（０ー１００）

	POP	DX
	POP	BX
	RET
MLTWHI	ENDP



CODE	ENDS



PALET	SEGMENT	PUBLIC	'PALET'

EXTRN	PLTNUM:WORD		; ハードパレットテーブル
EXTRN	PLTOFS:WORD		; パレットアドレステーブル（色相）
EXTRN	PCNOFS:WORD		; パレットアドレステーブル（彩度）
EXTRN	PBROFS:WORD		; パレットアドレステーブル（明度）

PALET	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	CRXVEW		; 色相回転（０ー３６０）
PUBLIC	CRXCNS		; 彩度倍率（０ー１００）
PUBLIC	CRXBRI		; 明度倍率（０ー１００）
PUBLIC	CRXWHI		; ホワイトレベル（０ー１００）

EXTRN	CLRCDE:WORD	; color code.カラーコード
EXTRN	CLRVEW:WORD	; color view.色相
EXTRN	CLRCNS:WORD	; contrast.  彩度
EXTRN	CLRBRI:WORD	; brightness.明度

CRXVEW	DW	0	; 色相回転（０ー３６０）
CRXCNS	DW	100	; 彩度倍率（０ー１００）
CRXBRI	DW	100	; 明度倍率（０ー１００）
CRXWHI	DW	0	; ホワイトレベル（０ー１００）

DATA	ENDS

	END
;
;	end of "PLTSET.ASM"
;
