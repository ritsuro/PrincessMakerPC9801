; "PARTT3.ASM" PC-9801UV11 make by R.H 1990/05/08
;
;
;	バイナリデータＧＥＴ＆ＰＵＴ
;
;
; public subroutine.


PARTS_BUFF_LEN	EQU	65500	; パーツデータバッファサイズ


;	パーツバッファのオフセット値

PARTS_OFST_ATR	EQU	0	; 属性
		;(0=データ終わり,1=無圧縮データ,2=圧縮データ,3=バイナリデータ)

PARTS_OFST_X	EQU	2	; Ｘ座標
PARTS_OFST_Y	EQU	4	; Ｙ座標
PARTS_OFST_LNX	EQU	6	; Ｘ長さ
PARTS_OFST_LNY	EQU	8	; Ｙ長さ
PARTS_OFST_LEN	EQU	10	; データ長さ
PARTS_OFST_DAT	EQU	12	; データ開始オフセット



CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

PUBLIC	PATBGT			; バイナリデータ書き込み
PUBLIC	PATBPT			; バイナリデータ読み出し

EXTRN	BUNPLE:NEAR		; 圧縮フォーマットデータ復元
EXTRN	BPLESS:NEAR		; バイナリデータ圧縮


;	バイナリデータ書き込み
;	-I- DX:[SI] : バイナリデータ列
;	    CX      : データ長さ
;	-O- AX      : 0=normal end, 1=error.

PATBGT	PROC	NEAR
	PUSH	CX

	MOV	AX,PRSSEG			; バンクセグメント
	MOV	ES,AX				;

	MOV	DI,PRSOFS		; パーツバッファのカレントポインタ

	MOV	AX,0				;
	MOV	BX,1				;
	MOV	ES:[DI][PARTS_OFST_X],AX	; Ｘ座標
	MOV	ES:[DI][PARTS_OFST_Y],AX	; Ｙ座標
	MOV	ES:[DI][PARTS_OFST_LNX],BX	; Ｘ長さ
	MOV	ES:[DI][PARTS_OFST_LNY],BX	; Ｙ長さ

	MOV	BPNTOF,DI			; データバッファポインタ
	ADD	BPNTOF,PARTS_OFST_DAT		; データ開始オフセット
	MOV	AX,PRSSEG			; バンクセグメント
	MOV	BPNTSG,AX			;
	MOV	AX,PRSEND			; バンクエンドオフセット
	SUB	AX,BPNTOF			; データ開始オフセット
	MOV	BCNTMX,AX			; データ最大長さ

	PUSH	DI				;
	PUSH	ES				;
	CALL	DATSAV				; データセーブ
	POP	ES				;
	POP	DI				;

	CMP	AH,1			; 0 or 2 : normal end. 1:write error.
	JE	PATBGT_ERROR

	MOV	AX,BCOUNT			; データ長さ
	MOV	ES:[DI][PARTS_OFST_LEN],AX	; データ長さ

	MOV	AX,BCOUNT			; データ長さ
	ADD	AX,PARTS_OFST_DAT		;
	ADD	PRSSIZ,AX			; パーツバッファの使用サイズ

						; 属性(3=バイナリデータ)
	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 3

	MOV	DI,BPOINT			; データ終わりアドレス＋１
	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 0

	MOV	PRSOFS,DI		; パーツバッファのカレントポインタ
PATBGT_EXIT:
	MOV	AX,0				; normal.
	POP	CX				;
	RET					;
PATBGT_ERROR:
	MOV	AX,1				; buffer full.
	POP	CX				;
	RET					;
PATBGT	ENDP



;	バイナリデータ読み出し
;	-I- CX      : パーツ番号
;	    DX:SI   : バイナリデータ列アドレス
;	-O- DX:[SI] : バイナリデータ列
;	    AX      : 0=normal end, 1=error.

PATBPT	PROC	NEAR
	PUSH	CX

	PUSH	DX				;
	PUSH	SI				;
	CALL	PARTSCH				; パーツデータの検索
	POP	SI				;
	POP	DX				;
	CMP	AX,0				;
	JE	PATBPT1				;
	JMP	PATBPT_ERROR			;
PATBPT1:
	MOV	BPNTOF,DI			; データバッファポインタ
	ADD	BPNTOF,PARTS_OFST_DAT		; データ開始オフセット

	MOV	AX,PRSSEG			; バンクセグメント
	MOV	BPNTSG,AX			;
	MOV	AX,ES:[DI][PARTS_OFST_LEN]	; データ長さ
	MOV	BCNTMX,AX			; データ最大長さ

						; 属性(3=バイナリデータ)
	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 3
	JNE	PATBPT5				;

	CALL	DATLOD				; データロード

	JMP	PATBPT_EXIT			;
PATBPT5:					;
	JMP	PATBPT_ERROR			;
PATBPT_EXIT:
	MOV	AX,0				; normal.
	POP	CX				;
	RET					;
PATBPT_ERROR:
	MOV	AX,1				; not found.
	POP	CX				;
	RET					;
PATBPT	ENDP



;	データセーブ
;	-I- BPNTOF  : データバッファポインタ
;	    BPNTSG  : データバッファセグメント
;	    BCNTMX  : データ最大長さ
;	    CX      : データ長さ
;	    DX:[SI] : データ
;	-O- BCOUNT  : データ長さ
;	    BPOINT  : データ終わりアドレス＋１
;	    AH      : 0 or 2 : normal end. 1:write error.

DATSAV	PROC	NEAR
	CALL	BPLESS				; バイナリデータ圧縮
	RET
DATSAV	ENDP



;	データロード
;	-I- BPNTOF  : データバッファポインタ
;	    BPNTSG  : データバッファセグメント
;	    BCNTMX  : 高速化のため、現在使用していない（データ最大長さ）
;	    CX      : データ長さ
;	    DX:SI   : データアドレス
;	-O- DX:[SI] : データ

DATLOD	PROC	NEAR
	PUSH	SI
	MOV	DI,SI				; データアドレス
	MOV	ES,DX				; 展開データアドレス
	CALL	BUNPLE				; 圧縮フォーマットデータ復元
	POP	SI
	RET
DATLOD	ENDP




;	パーツデータの検索
;	-I- CX    : データ番号
;	-O- ES:DI : データ終りポインタ
;	    AX    : 0=normal 1=end of data.
;	    BX    : 検索データ番号

PARTSCH	PROC	NEAR
	PUSH	CX
	MOV	BX,0				; 検索データ番号
	MOV	AX,PRSSEG			; バンクセグメント
	MOV	ES,AX				;
	MOV	DI,PRSTOP			; バンクトップオフセット
	CMP	CX,0				;
	JE	PARTSCH3			;
PARTSCH2:
	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
	CMP	WORD PTR ES:[DI][PARTS_OFST_ATR],0
	JE	PARTSCH4_NOT			; end of data.
	MOV	DX,ES:[DI][PARTS_OFST_LEN]	; データ長さ
	ADD	DI,DX				;
	ADD	DI,PARTS_OFST_DAT		; データ開始オフセット
	INC	BX				; 検索データ番号
	LOOP	PARTSCH2
PARTSCH3:
	CMP	WORD PTR ES:[DI][PARTS_OFST_ATR],0
	JE	PARTSCH4_NOT			; end of data.
PARTSCH4:
	MOV	AX,0				; 0=normal.
	POP	CX
	RET
PARTSCH4_NOT:
	MOV	AX,1				; 1=not found.
	POP	CX
	RET
PARTSCH	ENDP

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

EXTRN	PRSBNK:WORD		; バンク番号
EXTRN	PRSSEG:WORD		; バンクセグメント
EXTRN	PRSTOP:WORD		; バンクトップオフセット
EXTRN	PRSEND:WORD		; バンクエンドオフセット

EXTRN	PRSOFS:WORD		; パーツバッファのカレントポインタ
EXTRN	PRSSIZ:WORD		; パーツバッファの使用サイズ

DATA	ENDS

	END
;
;	end of "PARTT3.ASM"
;
