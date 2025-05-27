; "VRMMOV.ASM" PC-9801UV11 make by R.H 1989/12/27
;
;	ＶＲＡＭデータ＜－＞バッファ転送
;
; public subroutine.
;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

PUBLIC	VRMGT		; ＶＲＡＭデータＧＥＴ
PUBLIC	VRMPT		; ＶＲＡＭデータＰＵＴ

MAX_PLEAN	EQU	3	; 最大プレーン番号
ADDWIDTH	EQU	80	; 次のラインアドレス計算用



;	ＶＲＡＭデータＰＵＴ
;	（データ圧縮用ワークバッファ－＞ＶＲＡＭコピー）
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    BPNTOF : データバッファポインタ
;	    BPNTSG : データバッファセグメント
;	    BCNTMX : データ最大長さ

VRMPT	PROC	NEAR
	CALL	VRMINI		; vram access init.
	CALL	VRAMPUT		; ワークバッファ－＞ＶＲＡＭ転送
	RET
VRMPT	ENDP




;	ＶＲＡＭデータＧＥＴ
;	（ＶＲＡＭ－＞データ圧縮用ワークバッファコピー）
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

VRMGT	PROC	NEAR
	CALL	VRMINI		; vram access init.
	CALL	VRAMGET		; ＶＲＡＭ－＞ワークバッファ転送
	RET
VRMGT	ENDP





;	ＶＲＡＭ－＞ワークバッファ転送
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    BPNTOF : データバッファポインタ
;	    BPNTSG : データバッファセグメント
;	    BCNTMX : データ最大長さ

VRAMPUT	PROC	NEAR
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	SI,BPNTOF		; データバッファポインタ

	MOV	VRPLN,0			; プレーン番号
VRAMPUT2:
	CMP	WORD PTR VRPLN,MAX_PLEAN	; 最大プレーン番号
	JG	VRAMPUT9

	MOV	BX,VRPLN		; vram plean number.
	SHL	BX,1

	MOV	AX,VRLENY		; AX=Ｙライン数
	MOV	DX,VRLENX		; DX=Ｘバイト数
	MOV	BP,0			; BP=Ｙラインカウンタ

	MOV	DI,VROFSTBASE		; vram offset base.
	MOV	CX,DS:ARASEG[BX]	; ES <- vram segment.
	MOV	ES,CX			;

	PUSH	DS

	MOV	CX,BPNTSG		; データバッファセグメント
	MOV	DS,CX			;
VRAMPUT3:
	MOV	CX,DX			; DX=Ｘバイト数
	REP	MOVSB			; 転送

	ADD	DI,ADDWIDTH		; 次のライン
	SUB	DI,DX			;

	INC	BP			; もしＹラインが下の端に達して
	CMP	BP,AX			; なかったらループ
	JL	VRAMPUT3		;

	POP	DS			;

	INC	VRPLN			;
	JMP	VRAMPUT2		; ループエンド

VRAMPUT9:
	POP	DX
	POP	CX
	POP	BX
	RET
VRAMPUT	ENDP






;	ＶＲＡＭ－＞ワークバッファ転送
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

VRAMGET	PROC	NEAR
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	AX,VRLENX		;
	MOV	BX,VRLENY		; データサイズ計算
	IMUL	BX			;
	SHL	AX,1			;
	SHL	AX,1			; * 4 plean
	MOV	BCOUNT,AX		; データ長さ
	CMP	AX,BCNTMX		; データ最大長さ
	JBE	VRAMGET1		;

	MOV	AH,1			; 1=E.O.F
	POP	DX
	POP	CX
	POP	BX
	RET

VRAMGET1:
	ADD	AX,BPNTOF		; データバッファポインタ＋ﾃﾞｰﾀｻｲｽﾞ
	MOV	BPOINT,AX		; データ終わりアドレス＋１


	MOV	AX,BPNTSG		;
	MOV	ES,AX			;
	MOV	DI,BPNTOF		;

	MOV	VRPLN,0			; プレーン番号
VRAMGET2:
	CMP	WORD PTR VRPLN,MAX_PLEAN	; 最大プレーン番号
	JG	VRAMGET9

	MOV	BX,VRPLN		; vram plean number.
	SHL	BX,1

	MOV	AX,VRLENY		; AX=Ｙライン数
	MOV	DX,VRLENX		; DX=Ｘバイト数
	MOV	BP,0			; BP=Ｙラインカウンタ

	PUSH	DS

	MOV	SI,VROFSTBASE		; vram offset base.
	MOV	CX,DS:ARASEG[BX]	; ES <- vram segment.
	MOV	DS,CX			;
VRAMGET3:
	MOV	CX,DX			; DX=Ｘバイト数
	REP	MOVSB			; 転送

	ADD	SI,ADDWIDTH		; 次のライン
	SUB	SI,DX			;

	INC	BP			; もしＹラインが下の端に達して
	CMP	BP,AX			; なかったらループ
	JL	VRAMGET3		;

	POP	DS			;

	INC	VRPLN			;
	JMP	VRAMGET2		; ループエンド

VRAMGET9:
	MOV	AH,0			; 0=normal 1=E.O.F
	POP	DX
	POP	CX
	POP	BX
	RET
VRAMGET	ENDP



; vram access init.

VRMINI	PROC	NEAR

	MOV	AX,SSGR0	; visual data segment plean 0
	MOV	WORD PTR DS:ARASEG[0],AX

	MOV	AX,SSGR1	; visual data segment plean 1
	MOV	WORD PTR DS:ARASEG[2],AX

	MOV	AX,SSGR2	; visual data segment plean 2
	MOV	WORD PTR DS:ARASEG[4],AX

	MOV	AX,SSGR3	; visual data segment plean 3
	MOV	WORD PTR DS:ARASEG[6],AX

	MOV	BX,VRY		;
	SHL	BX,1		;
	SHL	BX,1		;  point address.
	SHL	BX,1		;
	SHL	BX,1		;  bx = VRY * 80 + VRX
	MOV	AX,BX		;
	SHL	BX,1		;
	SHL	BX,1		;
	ADD	BX,AX		;
	ADD	BX,VRX		;
	MOV	VROFSTBASE,BX	; vram offset base.

	RET
VRMINI	ENDP


CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

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

ARASEG		DW	0,0,0,0	; segment table.

VROFSTBASE	DW	0	; vram offset base.

VRPLN		DW	0	; vram segment.

DATA	ENDS

	END
;
;	end of "VRMMOV.ASM"
;
