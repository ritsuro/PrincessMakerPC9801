; "PLSLD3.ASM" 1990/01/04 R.H
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

	PUBLIC	UNPOR		; データ復元（ＯＲ処理）
	PUBLIC	UNPORS		; データ復元（ＯＲ処理）単プレーンパターン

	EXTRN	LDPLSD:NEAR	; 圧縮フォーマットデータ復元


;	データ復元（ＯＲ処理）
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    BPNTOF : データバッファポインタ
;	    BPNTSG : データバッファセグメント
;	    BCNTMX : データ最大長さ
;	    BORRCL : ＯＲカラー(bit3:plean3,bit2:plean2,bit1:1,bit0:0)
;	-O- BCOUNT ; データ長さ
;	    BPOINT ; データ終わりアドレス＋１
;	    AH     : 0=normal 1=E.O.F

UNPOR	PROC	NEAR
	CALL	LDPLSD		; 圧縮フォーマットデータ復元

	CMP	PLSMDE,1	; 圧縮モード(0:通常,1:縦方向)
	JE	UNPOR2

	PUSH	DS
	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	DS,AX		;
	MOV	SI,DTA		; ＤＴＡトップ
	CALL	VRMPUT
	POP	DS
	JMP	UNPOR3
UNPOR2:
	PUSH	DS
	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	DS,AX		;
	MOV	SI,DTA		; ＤＴＡトップ
	CALL	VCXRTW		; 縦横バイト並べ戻し
	POP	DS
UNPOR3:

	RET
UNPOR	ENDP


;	データ復元（ＯＲ処理）単プレーンパターン
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    BPNTOF : データバッファポインタ
;	    BPNTSG : データバッファセグメント
;	    BCNTMX : データ最大長さ
;	    BORRCL : ＯＲカラー(bit3:plean3,bit2:plean2,bit1:1,bit0:0)
;	-O- BCOUNT ; データ長さ
;	    BPOINT ; データ終わりアドレス＋１
;	    AH     : 0=normal 1=E.O.F

UNPORS	PROC	NEAR
	CALL	LDPLSD		; 圧縮フォーマットデータ復元

	PUSH	DS
	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	DS,AX		;
	MOV	SI,DTA		; ＤＴＡトップ
	CALL	VRMPTS		; ＶＲＡＭ単プレーンパターンＰＵＴ
	POP	DS
	RET
UNPORS	ENDP



;	ＶＲＡＭＰＵＴ
;	-I- VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.
;	    DS     : データバッファセグメント
;	    SI     : データバッファポインタ
;	    BORRCL : ＯＲカラー(bit3:plean3,bit2:plean2,bit1:1,bit0:0)

VRMPUT	PROC	NEAR
	MOV	AX,SEG DATA
	MOV	ES,AX

	TEST	ES:BORRCL,0001B	; ＯＲカラー(bit0:plean0)
	JZ	VRMPUT0		;
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	CALL	PLNSET		; 範囲指定１プレーンセット
VRMPUT0:
	TEST	ES:BORRCL,0010B	; ＯＲカラー(bit1:plean1)
	JZ	VRMPUT1		;
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	CALL	PLNSET		; 範囲指定１プレーンセット
VRMPUT1:
	TEST	ES:BORRCL,0100B	; ＯＲカラー(bit2:plean2)
	JZ	VRMPUT2		;
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	CALL	PLNSET		; 範囲指定１プレーンセット
VRMPUT2:
	TEST	ES:BORRCL,1000B	; ＯＲカラー(bit3:plean3)
	JZ	VRMPUT3		;
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	CALL	PLNSET		; 範囲指定１プレーンセット
VRMPUT3:
	RET
VRMPUT	ENDP




;	ＶＲＡＭ単プレーンパターンＰＵＴ
;	-I- VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.
;	    DS     : データバッファセグメント
;	    SI     : データバッファポインタ
;	    BORRCL : ＯＲカラー(bit3:plean3,bit2:plean2,bit1:1,bit0:0)

VRMPTS	PROC	NEAR
	MOV	AX,SEG DATA
	MOV	ES,AX

	TEST	ES:BORRCL,0001B	; ＯＲカラー(bit0:plean0)
	JZ	VRMPTS0		;
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	PUSH	SI		;
	CALL	PLNSET		; 範囲指定１プレーンセット
	POP	SI		;
VRMPTS0:
	TEST	ES:BORRCL,0010B	; ＯＲカラー(bit1:plean1)
	JZ	VRMPTS1		;
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	PUSH	SI		;
	CALL	PLNSET		; 範囲指定１プレーンセット
	POP	SI		;
VRMPTS1:
	TEST	ES:BORRCL,0100B	; ＯＲカラー(bit2:plean2)
	JZ	VRMPTS2		;
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	PUSH	SI		;
	CALL	PLNSET		; 範囲指定１プレーンセット
	POP	SI		;
VRMPTS2:
	TEST	ES:BORRCL,1000B	; ＯＲカラー(bit3:plean3)
	JZ	VRMPTS3		;
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	PUSH	SI		;
	CALL	PLNSET		; 範囲指定１プレーンセット
	POP	SI		;
VRMPTS3:
	RET
VRMPTS	ENDP



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
	OR	ES:[DI],AL	; ＣＸバイト分だけＯＲコピー
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
;	    BORRCL : ＯＲカラー(bit3:plean3,bit2:plean2,bit1:1,bit0:0)

VCXRTW	PROC	NEAR
	MOV	AX,SEG DATA	;
	MOV	ES,AX		;

	TEST	ES:BORRCL,0001B	; ＯＲカラー(bit0:plean0)
	JZ	VCXRTW0		;
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
VCXRTW0:

	TEST	ES:BORRCL,0010B	; ＯＲカラー(bit1:plean1)
	JZ	VCXRTW1		;
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
VCXRTW1:			;

	TEST	ES:BORRCL,0100B	; ＯＲカラー(bit2:plean2)
	JZ	VCXRTW2		;
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
VCXRTW2:			;

	TEST	ES:BORRCL,1000B	; ＯＲカラー(bit3:plean3)
	JZ	VCXRTW3		;
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン
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
	OR	ES:[DI],AL	; ＣＸバイト分だけＯＲコピー
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
EXTRN	BORRCL:WORD		; ＯＲカラー
	EVEN

PLSDATEND	DW	0	; 圧縮対象データの終わりアドレス


VROFSTBASE	DW	0	; vram offset base.
VROFSTSHIFT	DW	0	; vram offset shift.

VRPX	DW	0		; x plot.
VRPY	DW	0		; y plot.

DATA	ENDS

	END
;
;	end of "PLSLD3.ASM"
;
