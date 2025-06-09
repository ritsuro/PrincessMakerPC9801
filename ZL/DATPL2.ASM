; "DATPL2.ASM" PC-9801UV11 make by R.H 1989/12/29
;
;	マスクパターン専用データ圧縮
;
;	マスク作成のためにＤＡＴＰＬＳを改造したもの
;	各種ルーチン名が同じでも機能が違いますので注意して下さい
;	マスクパターンはＶＲＡＭプレーン０を取り出します
;	ＤＡＴＰＬＳ．ＡＳＭのＰＬＥＳＳを１プレーンだけ取り出す
;	ようにして有るだけです
;
;	PLSBUFMAX（データ圧縮用ワークバッファサイズ）をＤＡＴＰＬＳ．ＡＳＭ
;	と揃えて下さい
;
; public subroutine.
;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;

PLSBUF	SEGMENT	PUBLIC	'PLSBUF'	; データ圧縮用ワークバッファ
PLSBUF	ENDS

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	PLESSM		; マスクデータ圧縮

	EXTRN	BPLESS:NEAR	; バイナリデータ圧縮

	EXTRN	VRMGT:NEAR	; ＶＲＡＭデータＧＥＴ

	EXTRN	VCXHST:NEAR	; 縦横バイト並べ替え

PLSBUFMAX	EQU	65535	; データ圧縮用ワークバッファサイズ
MAX_PLEAN_MASK	EQU	0	; マスク用プレーン番号



;	マスクデータ圧縮
;	-I- VRX    : ＶＲＡＭ　Ｘ座標
;	    VRY    : ＶＲＡＭ　Ｙ座標
;	    VRLENX : Ｘ方向長さ
;	    VRLENY : Ｙ方向長さ
;	    BPNTOF : データバッファポインタ
;	    BPNTSG : データバッファセグメント
;	    BCNTMX : データ最大長さ
;	    PLSMDE : 圧縮モード(0:通常,1:縦方向)
;	-O- BCOUNT ; データ長さ
;	    BPOINT ; データ終わりアドレス＋１
;	    AH     : 0 or 2 : normal end. 1:write error.

PLESSM	PROC	NEAR
	PUSH	PLNSRT			;
	PUSH	PLNEND			;

	CMP	PLSMDE,1		; 圧縮モード(0:通常,1:縦方向)
	JNE	PLESSM2			;
	CALL	VCXHST			; 縦横バイト並べ替え
PLESSM2:

	MOV	AX,MAX_PLEAN_MASK	; マスク用プレーン番号
	MOV	PLNSRT,AX		; 処理開始プレーン番号
	MOV	PLNEND,AX		; 処理終了プレーン番号

	;（１）ＶＲＡＭデータをバッファへロードする

	PUSH	BPNTOF			;
	PUSH	BPNTSG			;
	PUSH	BCNTMX			;

	MOV	BPNTSG,SEG PLSBUF	; データバッファセグメント
	MOV	BPNTOF,OFFSET PLSBTP	; データバッファポインタ
	MOV	BCNTMX,PLSBUFMAX	; データ圧縮用ワークバッファサイズ
	CALL	VRMGT			; ＶＲＡＭデータＧＥＴ

	POP	BCNTMX			;
	POP	BPNTSG			;
	POP	BPNTOF			;

	CMP	AH,1			; 0=normal 1=E.O.F
	JE	PLESSM_ERROR		;

	;（２）圧縮する

	MOV	DX,SEG PLSBUF		; 圧縮対象データセグメント
	MOV	SI,OFFSET PLSBTP	; 圧縮対象データオフセット
	MOV	CX,BCOUNT		; データ長さ
	CALL	BPLESS			; バイナリデータ圧縮

	POP	PLNEND			;
	POP	PLNSRT			;
	RET				;
PLESSM_ERROR:
	MOV	AH,1			; 1:write error.
	POP	PLNEND			;
	POP	PLNSRT			;
	RET				;
PLESSM	ENDP


CODE	ENDS



;	データ圧縮用ワークバッファ

PLSBUF	SEGMENT	PUBLIC	'PLSBUF'
EXTRN	PLSBTP:BYTE
PLSBUF	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	PLSMDE:WORD		; 圧縮モード(0:通常,1:縦方向)

EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.

EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

EXTRN	BPOINT:WORD		; data buffer point.
EXTRN	BPNTOF:WORD		; データバッファポインタ
EXTRN	BPNTSG:WORD		; データバッファセグメント
EXTRN	BCNTMX:WORD		; データ最大長さ
EXTRN	BCOUNT:WORD		; データ長さ

EXTRN	PLNSRT:WORD		; 処理開始プレーン番号
EXTRN	PLNEND:WORD		; 処理終了プレーン番号

EXTRN	SSGR0:WORD		; visual data segment plean 0
EXTRN	SSGR1:WORD		; visual data segment plean 1
EXTRN	SSGR2:WORD		; visual data segment plean 2
EXTRN	SSGR3:WORD		; visual data segment plean 3

ARASEG	DW	0,0,0,0		; segment table.

VRMOFS	DW	0		; vram offset address.

PLSDATEND	DW	0	; 圧縮対象データの終わりアドレス


VRPLN		DW	0	; vram segment.
VROFST		DW	0	; vram offset.
VROFSTBASE	DW	0	; vram offset base.
VROFSTSHIFT	DW	0	; vram offset shift.

VRPX	DW	0		; x plot.
VRPY	DW	0		; y plot.

VRPLNBAK	DW	3 DUP (0)	; vram segment back.
VROFSTBAK	DW	3 DUP (0)	; vram offset back.

BUF0	LABEL	BYTE		;
BUF1	DB	0		; check buffer.
BUF2	DB	0		;
BUF3	DB	0		;
BUF4	DB	0		;
BUF5	DB	252 DUP (0)	;

DTLEN	DW	0		; data length.
DTIMG	DW	0		; data image.

DATA	ENDS

	END
;
;	end of "DATPL2.ASM"
;
