; "DATPLS.ASM" PC-9801UV11 make by R.H 1989/12/08
;
;	データ圧縮
;
; public subroutine.

;
;	SSGR0			; visual data segment plean 0
;	SSGR1			; visual data segment plean 1
;	SSGR2			; visual data segment plean 2
;	SSGR3			; visual data segment plean 3
;
INCLUDE	TSTSET.INC
PLSBUF	SEGMENT	PUBLIC	'PLSBUF'	; データ圧縮用ワークバッファ
PLSBUF	ENDS

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

	PUBLIC	PLESS		; データ圧縮

	EXTRN	BUNPLE:NEAR	; 圧縮フォーマットデータ復元
	EXTRN	BPLESS:NEAR	; バイナリデータ圧縮

	EXTRN	VRMGT:NEAR	; ＶＲＡＭデータＧＥＴ
	EXTRN	VRMPT:NEAR	; ＶＲＡＭデータＰＵＴ

	EXTRN	VCXHST:NEAR	; 縦横バイト並べ替え

MAX_PLEAN	EQU	3	; 最大プレーン番号
ADDWIDTH	EQU	80	; 次のラインアドレス計算用
PLSBUFMAX	EQU	65535	; データ圧縮用ワークバッファサイズ



;	データ圧縮
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

PLESS	PROC	NEAR

	CMP	PLSMDE,1		; 圧縮モード(0:通常,1:縦方向)
	JNE	PLESS2			;
	CALL	VCXHST			; 縦横バイト並べ替え
PLESS2:


	;（１）ＶＲＡＭデータをバッファへロードする

	PUSH	BPNTOF			;
	PUSH	BPNTSG			;
	PUSH	BCNTMX			;

	MOV	BPNTSG,SEG PLSBUF	 ; データバッファセグメント
	MOV	BPNTOF,OFFSET PLSBUF_TOP ; データバッファポインタ
	MOV	BCNTMX,PLSBUFMAX	 ; データ圧縮用ワークバッファサイズ
	CALL	VRMGT			 ; ＶＲＡＭデータＧＥＴ

	POP	BCNTMX			;
	POP	BPNTSG			;
	POP	BPNTOF			;

	CMP	AH,1			; 0=normal 1=E.O.F
	JE	PLESS_ERROR		;

	;（２）圧縮する

	MOV	DX,SEG PLSBUF		; 圧縮対象データセグメント
	MOV	SI,OFFSET PLSBUF_TOP	; 圧縮対象データオフセット
	MOV	CX,BCOUNT		; データ長さ
	CALL	BPLESS			; バイナリデータ圧縮

	RET
PLESS_ERROR:
	MOV	AH,1			; 1:write error.
	RET				;
PLESS	ENDP


CODE	ENDS



;	データ圧縮用ワークバッファ

PLSBUF	SEGMENT	PUBLIC	'PLSBUF'
PUBLIC	PLSBTP
PLSBUF_TOP	LABEL	BYTE
PLSBTP	DB	PLSBUFMAX DUP (0)
PLSBUF	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	PLSMDE			; 圧縮モード(0:通常,1:縦方向)
PUBLIC	BMSKCL			; マスキングカラー
PUBLIC	BORRCL			; ＯＲカラー

PUBLIC	VRX			; x point.
PUBLIC	VRY			; y point.

PUBLIC	VRLENX			; x length.
PUBLIC	VRLENY			; y length.

PUBLIC	BPOINT			; data buffer point.
PUBLIC	BPNTOF			; データバッファポインタ
PUBLIC	BPNTSG			; データバッファセグメント
PUBLIC	BCNTMX			; データ最大長さ
PUBLIC	BCOUNT			; データ長さ


PLSMDE		DW	0	; 圧縮モード(0:通常,1:縦方向)
BMSKCL	DW	1111B		; マスキングカラー
				; (bit3:plean3,bit2:plean2,bit1:1,bit0:0)
BORRCL	DW	1111B		; ＯＲカラー
				; (bit3:plean3,bit2:plean2,bit1:1,bit0:0)


BPOINT		DW	0	; data buffer point.
BPNTOF		DW	0	; データバッファポインタ
BPNTSG		DW	0	; データバッファセグメント
BCNTMX		DW	0	; データ最大長さ
BCOUNT		DW	0	; データ長さ

VRX		DW	0	; x point.
VRY		DW	0	; y point.
VRLENX		DW	0	; x length.
VRLENY		DW	0	; y length.

DATA	ENDS

	END
;
;	end of "DATPLS.ASM"
;
