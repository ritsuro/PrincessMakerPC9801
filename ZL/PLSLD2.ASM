; "PLSLD2.ASM" 1989/12/14 R.H
;              PC-9801UV11 make by R.H 1989
;
; public subroutine.
;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;
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
ADDWIDTHB	EQU	79	; ＶＲＡＭライン計算用


DTA		EQU	0	; SEGDOS で示される
				; ＤＯＳインターフェースセグメント内の
				; ＤＴＡ領域のオフセットアドレス
				; 詳細は'DISKRD.ASM'を参照してください

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	UNPLS		; データ復元
	PUBLIC	PLSMOD		; 圧縮モード切り替え

	PUBLIC	LDPLSD		; 圧縮フォーマットデータ復元（ＤＴＡ領域）

	EXTRN	BUNPLE:NEAR	; 圧縮フォーマットデータ復元



;	データ復元
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    BPNTOF : データバッファポインタ
;	    BPNTSG : データバッファセグメント
;	    BCNTMX : データ最大長さ
;	-O- BCOUNT ; データ長さ
;	    BPOINT ; データ終わりアドレス＋１
;	    AH     : 0=normal 1=E.O.F

UNPLS	PROC	NEAR
	CALL	LDPLSD		; data read & convert.

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
UNPLS	ENDP



;	圧縮モード切り替え
;	-I- DX : 圧縮モード(0:通常,1:縦方向)

PLSMOD	PROC	NEAR
	MOV	PLSMDE,DX	; 圧縮モード(0:通常,1:縦方向)
	RET
PLSMOD	ENDP



;	圧縮フォーマットデータ復元
;	-I- BPNTOF     : データバッファポインタ
;	    BPNTSG     : データバッファセグメント
;	-O- SEGDOS:DTA : ＤＴＡ領域に展開データ

LDPLSD	PROC	NEAR
	PUSH	DS

	MOV	AX,SEGDOS	; ＤＴＡバッファ
	MOV	ES,AX		;
	MOV	DI,DTA		; ＤＴＡトップ

	CALL	BUNPLE		; 圧縮フォーマットデータ復元

	POP	DS
	RET
LDPLSD	ENDP


;	ＶＲＡＭＰＵＴ
;	    VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.
;	    DS     : データバッファセグメント
;	    SI     : データバッファポインタ

VRMPUT	PROC	NEAR
	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	CALL	PLNSET		; 範囲指定１プレーンセット

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	CALL	PLNSET		; 範囲指定１プレーンセット

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	CALL	PLNSET		; 範囲指定１プレーンセット

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	CALL	PLNSET		; 範囲指定１プレーンセット

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

	MOV	BP,DI		; ＶＲＡＭプレーンセグメント
PLNSET2:
	MOV	CX,AX		; Ｘ長さ
	REP	MOVSB		;

	SUB	DI,AX		; X length.=AX
	ADD	DI,ADDWIDTH	; ＶＲＡＭライン計算用

	DEC	BX		; Y length.=BX
	JNZ	PLNSET2		;

	RET
PLNSET	ENDP



;	縦横バイト並べ戻し
;	    VRX: x point.
;	    VRY: y point.
;	    VRLENX : x length.
;	    VRLENY : y length.
;	    DS     : データバッファセグメント
;	    SI     : データバッファポインタ

VCXRTW	PROC	NEAR

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DX,ES:SSGR0	; visual data segment plean 0
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DX,ES:SSGR1	; visual data segment plean 1
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DX,ES:SSGR2	; visual data segment plean 2
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン

	MOV	AX,SEG DATA
	MOV	ES,AX
	MOV	DX,ES:SSGR3	; visual data segment plean 3
	CALL	MTXVRF		; 縦横バイト並べ戻し範囲指定１プレーン

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

	MOV	BP,DI		; ＶＲＡＭプレーンセグメント
MTXVRF2:
	MOV	CX,BX		; Ｙ長さ
MTXVRF3:
	MOVSB			;
	ADD	DI,ADDWIDTHB	; ＶＲＡＭライン計算用
	LOOP	MTXVRF3		;

	INC	BP		;
	MOV	DI,BP		; データ圧縮用バッファの先頭オフセット

	DEC	AX		; X length.=AX
	JNZ	MTXVRF2		;

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
	EVEN

ARASEG	DW	0,0,0,0		; segment table.

PLSDATEND	DW	0	; 圧縮対象データの終わりアドレス


VROFSTBASE	DW	0	; vram offset base.
VROFSTSHIFT	DW	0	; vram offset shift.

VRPX	DW	0		; x plot.
VRPY	DW	0		; y plot.

DATA	ENDS

	END
;
;	end of "PLSLD2.ASM"
;
