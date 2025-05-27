; "PLSLD4.ASM" 1990/01/04 R.H
;              PC-9801UV11 make by R.H 1990
;
; public subroutine.
;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;
;	ＤＴＡをワークに使うのでＤＴＡが６００００バイトないと
;	困ります
;
;	ＤＳ：ＳＩ			圧縮データバッファ
;	ＥＳ：ＤＩ＝ＶＲＡＭ OR ＤＴＡ	展開データ
;	ＢＸ				ＶＲＡＭｾｸﾞﾒﾝﾄﾃｰﾌﾞﾙポインタ

MAX_VRAM_POINT	EQU	32000	; ＶＲＡＭ１プレーンの終わりオフセット

PLEAN_MAX	EQU	4	; vram plean number.

ADDWIDTH	EQU	80	; vram offset shift.

DTA		EQU	0	; SEGDOS で示される
				; ＤＯＳインターフェースセグメント内の
				; ＤＴＡ領域のオフセットアドレス
				; 詳細は'DISKRD.ASM'を参照してください

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	UNPLSM		; マスク化（マスクデータ復元）

	EXTRN	LDPLSD:NEAR	; 圧縮フォーマットデータ復元


;	マスク化（マスクデータ復元）
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    BPNTOF : データバッファポインタ
;	    BPNTSG : データバッファセグメント
;	    BCNTMX : データ最大長さ
;	    BMSKCL : マスキングカラー(bit3:plean3,bit2:plean2,bit1:1,bit0:0)
;	-O- BCOUNT ; データ長さ
;	    BPOINT ; データ終わりアドレス＋１
;	    AH     : 0=normal 1=E.O.F

UNPLSM	PROC	NEAR
	CALL	LDPLSD		; 圧縮フォーマットデータ復元

	CMP	PLSMDE,1	; 圧縮モード(0:通常,1:縦方向)
	JE	UNPLS2

	PUSH	DS
	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	DS,AX		;
	MOV	SI,DTA		; ＤＴＡトップ
	CALL	VRMPUT
	POP	DS
	JMP	UNPLS3
UNPLS2:
	PUSH	DS
	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	DS,AX		;
	MOV	SI,DTA		; ＤＴＡトップ
	CALL	VCXRTW		; 縦横バイト並べ戻し
	POP	DS
UNPLS3:
	RET
UNPLSM	ENDP


;	ＶＲＡＭＰＵＴ
;	-I- VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.
;	    DS     : データバッファセグメント
;	    SI     : データバッファポインタ
;	    BMSKCL : マスキングカラー(bit3:plean3,bit2:plean2,bit1:1,bit0:0)

VRMPUT	PROC	NEAR
	MOV	AX,SEG DATA
	MOV	ES,AX

	TEST	ES:BMSKCL,0001B	; マスキングカラー(bit0:plean0)
	JZ	VRMPUT0		;
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	PUSH	SI		;
	CALL	PLNSET		; 範囲指定１プレーンセット
	POP	SI		;
VRMPUT0:
	TEST	ES:BMSKCL,0010B	; マスキングカラー(bit1:plean1)
	JZ	VRMPUT1		;
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	PUSH	SI		;
	CALL	PLNSET		; 範囲指定１プレーンセット
	POP	SI		;
VRMPUT1:
	TEST	ES:BMSKCL,0100B	; マスキングカラー(bit2:plean2)
	JZ	VRMPUT2		;
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	PUSH	SI		;
	CALL	PLNSET		; 範囲指定１プレーンセット
	POP	SI		;
VRMPUT2:
	TEST	ES:BMSKCL,1000B	; マスキングカラー(bit3:plean3)
	JZ	VRMPUT3		;
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	PUSH	SI		;
	CALL	PLNSET		; 範囲指定１プレーンセット
	POP	SI		;
VRMPUT3:
	RET
VRMPUT	ENDP


;	範囲指定１プレーンセット
;	ワークバッファ－＞ＶＲＡＭプレーン
;	-I- DX        : ＶＲＡＭプレーンセグメント
;	    ES:VRX    : x point.
;	    ES:VRY    : y point.
;	    ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	-I/O- DS      : データバッファセグメント
;	      SI      : データバッファポインタ

PLNSET	PROC	NEAR
	PUSH	ES

	MOV	AX,ES:VRLENX	; x length.=AX
	MOV	BX,ES:VRLENY	; y length.=BX

	MOV	DI,ES:VRY	;
	SHL	DI,1		;
	SHL	DI,1		;  point address.
	SHL	DI,1		;
	SHL	DI,1		;  DI = VRY * 80 + VRX
	MOV	CX,DI		;
	SHL	DI,1		;
	SHL	DI,1		;
	ADD	DI,CX		;
	ADD	DI,ES:VRX	;
	MOV	ES,DX		; ＶＲＡＭプレーンセグメント

	MOV	DX,AX		; x length.=AX=DX

	MOV	BP,DI		; ＶＲＡＭプレーンセグメント
PLNSET2:
	MOV	CX,DX		; Ｘ長さ
PLNSET22:
	LODSB			;
	AND	ES:[DI],AL	; ＣＸバイト分だけＡＮＤコピー
	INC	DI		;
	LOOP	PLNSET22	;

	SUB	DI,DX		; X length.=DX
	ADD	DI,ADDWIDTH	; ＶＲＡＭライン計算用

	DEC	BX		; Y length.=BX
	JNZ	PLNSET2		;

	POP	ES
	RET
PLNSET	ENDP


;	縦横バイト並べ戻し
;	-I- VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.
;	    DS     : データバッファセグメント
;	    SI     : データバッファポインタ
;	    BMSKCL : マスキングカラー(bit3:plean3,bit2:plean2,bit1:1,bit0:0)

VCXRTW	PROC	NEAR
	MOV	AX,SEG DATA
	MOV	ES,AX

	TEST	ES:BMSKCL,0001B	; マスキングカラー(bit0:plean0)
	JZ	VCXRTW0		;
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	PUSH	SI		; all same plean.
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
	POP	SI		;
VCXRTW0:

	TEST	ES:BMSKCL,0010B	; マスキングカラー(bit1:plean1)
	JZ	VCXRTW1		;
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	PUSH	SI		; all same plean.
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
	POP	SI		;
VCXRTW1:			;

	TEST	ES:BMSKCL,0100B	; マスキングカラー(bit2:plean2)
	JZ	VCXRTW2		;
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	PUSH	SI		; all same plean.
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
	POP	SI		;
VCXRTW2:			;

	TEST	ES:BMSKCL,1000B	; マスキングカラー(bit3:plean3)
	JZ	VCXRTW3		;
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	PUSH	SI		; all same plean.
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
	POP	SI		;
VCXRTW3:			;

	RET
VCXRTW	ENDP



;	縦横バイト並べ戻し範囲指定１プレーン
;	ワークバッファ－＞ＶＲＡＭプレーン
;	ＶＲＡＭバイトイメージの縦横入れ替えを戻します
;	-I- DX        : ＶＲＡＭプレーンセグメント
;	    ES:VRX    : x point.
;	    ES:VRY    : y point.
;	    ES:VRLENX : x length.
;	    ES:VRLENY : y length.
;	-I/O- DS      : データバッファセグメント
;	      SI      : データバッファポインタ

MTXVRF	PROC	NEAR
	PUSH	ES

	MOV	AX,ES:VRLENX	; x length.=AX
	MOV	BX,ES:VRLENY	; y length.=BX

	MOV	DI,ES:VRY	;
	SHL	DI,1		;
	SHL	DI,1		;  point address.
	SHL	DI,1		;
	SHL	DI,1		;  DI = VRY * 80 + VRX
	MOV	CX,DI		;
	SHL	DI,1		;
	SHL	DI,1		;
	ADD	DI,CX		;
	ADD	DI,ES:VRX	;
	MOV	ES,DX		; ＶＲＡＭプレーンセグメント

	MOV	DX,AX		; x length.=AX=DX

	MOV	BP,DI		; ＶＲＡＭプレーンセグメント
MTXVRF2:
	MOV	CX,BX		; Ｙ長さ
MTXVRF3:
	LODSB			;
	AND	ES:[DI],AL	; ＣＸバイト分だけＡＮＤコピー
	ADD	DI,ADDWIDTH	; vram offset shift.
	LOOP	MTXVRF3		;

	INC	BP		;
	MOV	DI,BP		; データ圧縮用バッファの先頭オフセット

	DEC	DX		; X length.=DX
	JNZ	MTXVRF2		;

	POP	ES
	RET
MTXVRF	ENDP

CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SEGDOS:WORD		; ＤＯＳインターフェースセグメント

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.

EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

EXTRN	BPOINT:WORD		; data buffer point.
EXTRN	BPNTOF:WORD		; データバッファポインタ
EXTRN	BPNTSG:WORD		; データバッファセグメント
EXTRN	BCNTMX:WORD		; データ最大長さ
EXTRN	BCOUNT:WORD		; データ長さ

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

EXTRN	PLSMDE:WORD		; 圧縮モード(0:通常,1:縦方向)
EXTRN	BMSKCL:WORD		; マスキングカラー

	EVEN

PLSDATEND	DW	0	; 圧縮対象データの終わりアドレス


VROFSTBASE	DW	0	; vram offset base.
VROFSTSHIFT	DW	0	; vram offset shift.

VRPX	DW	0		; x plot.
VRPY	DW	0		; y plot.

DATA	ENDS

	END
;
;	end of "PLSLD4.ASM"
;
