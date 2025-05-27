; "PARTT2.ASM" PC-9801UV11 make by R.H 1990/01/04
;
;
;	マスクパーツデータＧＥＴ＆ＰＵＴ
;
;	高度なテクニックを使う場合
;	・マスクパーツのＰＵＴプレーンの設定
;		CALL PATMST を呼び出して下さい
;	・ＯＲでＰＵＴするプレーンの設定
;		DS:BORRCL:WORD を設定して下さい
;		（詳細はPLSLD3.ASM/UNPORを参照のこと）
;
; public subroutine.



;	パーツバッファのオフセット値
PARTS_OFST_ATR	EQU	0	; 属性(0=データ終わり,
				;      1=無圧縮データ,2=圧縮データ)
PARTS_OFST_X	EQU	2	; Ｘ座標
PARTS_OFST_Y	EQU	4	; Ｙ座標
PARTS_OFST_LNX	EQU	6	; Ｘ長さ
PARTS_OFST_LNY	EQU	8	; Ｙ長さ
PARTS_OFST_LEN	EQU	10	; データ長さ
PARTS_OFST_DAT	EQU	12	; データ開始オフセット



CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

;*NON*;PUBLIC	PATGTM	; マスクパーツＧＥＴ
PUBLIC	PATPTM		; マスクパーツＰＵＴ
PUBLIC	PATPXM		; マスクパーツＰＵＴ座標指定
PUBLIC	PATPFM		; マスクパーツＰＵＴオフセット指定

PUBLIC	PATSIZ		; パーツサイズのＧＥＴ

;*NON*;PUBLIC	PATTPD	; 先頭パターンデータの削除
;*NON*;PUBLIC	PATEDD	; 指定パターンデータ以降の削除

PUBLIC	PATMST		; マスクパーツのＰＵＴプレーン設定


EXTRN	UNPLSM:NEAR		; マスク化（マスクデータ復元）
;*NON*;EXTRN	PLESSM:NEAR	; マスクデータ圧縮



;*NON*;
;*NON*;;	マスクパーツＧＥＴ
;*NON*;;	-I- VRX		: ＶＲＡＭ　Ｘ座標
;*NON*;;	    VRY		: ＶＲＡＭ　Ｙ座標
;*NON*;;	    VRLENX	: Ｘ方向長さ
;*NON*;;	    VRLENY	: Ｙ方向長さ
;*NON*;;	-O- AX		: 0=normal end, 1=error.
;*NON*;
;*NON*;PATGTM	PROC	NEAR
;*NON*;	PUSH	CX
;*NON*;
;*NON*;	MOV	AX,PRSSEG		; バンクセグメント
;*NON*;	MOV	ES,AX			;
;*NON*;
;*NON*;	MOV	DI,PRSOFS		; パーツバッファのカレントポインタ
;*NON*;
;*NON*;	;	データ圧縮
;*NON*;	MOV	AX,VRX				; ＶＲＡＭ　Ｘ座標
;*NON*;	MOV	ES:[DI][PARTS_OFST_X],AX	; Ｘ座標
;*NON*;	MOV	AX,VRY				; ＶＲＡＭ　Ｙ座標
;*NON*;	MOV	ES:[DI][PARTS_OFST_Y],AX	; Ｙ座標
;*NON*;	MOV	AX,VRLENX			; Ｘ方向長さ
;*NON*;	MOV	ES:[DI][PARTS_OFST_LNX],AX	; Ｘ長さ
;*NON*;	MOV	AX,VRLENY			; Ｙ方向長さ
;*NON*;	MOV	ES:[DI][PARTS_OFST_LNY],AX	; Ｙ長さ
;*NON*;
;*NON*;	MOV	BPNTOF,DI		; データバッファポインタ
;*NON*;	ADD	BPNTOF,PARTS_OFST_DAT	; データ開始オフセット
;*NON*;	MOV	AX,PRSSEG		; バンクセグメント
;*NON*;	MOV	BPNTSG,AX		;
;*NON*;	MOV	AX,PRSEND		; バンクエンドオフセット
;*NON*;	SUB	AX,BPNTOF		; データ開始オフセット
;*NON*;	MOV	BCNTMX,AX		; データ最大長さ
;*NON*;
;*NON*;	PUSH	DI
;*NON*;	PUSH	ES
;*NON*;	CALL	PLESSM			; マスクデータ圧縮
;*NON*;	POP	ES
;*NON*;	POP	DI
;*NON*;
;*NON*;	CMP	AH,1	; 0 or 2 : normal end. 1:write error.
;*NON*;	JE	PATGTM_ERROR
;*NON*;
;*NON*;	MOV	AX,BCOUNT			; データ長さ
;*NON*;	MOV	ES:[DI][PARTS_OFST_LEN],AX	; データ長さ
;*NON*;
;*NON*;	MOV	AX,BCOUNT		; データ長さ
;*NON*;	ADD	AX,PARTS_OFST_DAT	;
;*NON*;	ADD	PRSSIZ,AX		; パーツバッファの使用サイズ
;*NON*;
;*NON*;	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ
;*NON*;	;	     3=マスクデータ)
;*NON*;	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 3
;*NON*;
;*NON*;	MOV	DI,BPOINT 		; データ終わりアドレス＋１
;*NON*;	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 0
;*NON*;
;*NON*;	MOV	PRSOFS,DI ; パーツバッファのカレントポインタ
;*NON*;PATGTM_EXIT:
;*NON*;	MOV	AX,0	; normal.
;*NON*;	POP	CX
;*NON*;	RET
;*NON*;PATGTM_ERROR:
;*NON*;	MOV	AX,1	; buffer full.
;*NON*;	POP	CX
;*NON*;	RET
;*NON*;PATGTM	ENDP
;*NON*;


;	マスクパーツＰＵＴ
;	-I- CX : パーツ番号
;	-O- AX : 0=normal end, 1=error.

PATPTM	PROC	NEAR
	PUSH	CX

	CALL	PARTSCH		; パーツデータの検索
	CMP	AX,0		;
	JE	PATPTM1		;
	JMP	PATPTM_ERROR	;
PATPTM1:
	;	データ復元
	MOV	AX,ES:[DI][PARTS_OFST_X]	; Ｘ座標
	MOV	VRX,AX				; ＶＲＡＭ　Ｘ座標
	MOV	AX,ES:[DI][PARTS_OFST_Y]	; Ｙ座標
	MOV	VRY,AX				; ＶＲＡＭ　Ｙ座標
	MOV	AX,ES:[DI][PARTS_OFST_LNX]	; Ｘ長さ
	MOV	VRLENX,AX			; Ｘ方向長さ
	MOV	AX,ES:[DI][PARTS_OFST_LNY]	; Ｙ長さ
	MOV	VRLENY,AX			; Ｙ方向長さ

	MOV	BPNTOF,DI		; データバッファポインタ
	ADD	BPNTOF,PARTS_OFST_DAT	; データ開始オフセット

	MOV	AX,PRSSEG		; バンクセグメント
	MOV	BPNTSG,AX		;
	MOV	AX,ES:[DI][PARTS_OFST_LEN]	; データ長さ
	MOV	BCNTMX,AX			; データ最大長さ

	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 3 ; 属性(0=データ終わり,
						; 1=無圧縮データ,2=圧縮データ
						; 3=マスクデータ)
	JNE	PATPTM6				;

	MOV	AX,PMSKPL			; マスクＰＵＴプレーン指定
	MOV	BMSKCL,AX			; マスキングカラー
	CALL	UNPLSM				; マスク化（マスクデータ復元）

	JMP	PATPTM_EXIT			;
PATPTM6:

PATPTM_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATPTM_ERROR:
	MOV	AX,1	; not found.
	POP	CX
	RET
PATPTM	ENDP



;	マスクパーツＰＵＴ座標指定
;	-I- CX  : パーツ番号
;	    VRX	: ＶＲＡＭ　Ｘ座標
;	    VRY : ＶＲＡＭ　Ｙ座標
;	-O- AX  : 0=normal end, 1=error.

PATPXM	PROC	NEAR
	PUSH	CX

	CALL	PARTSCH		; パーツデータの検索
	CMP	AX,0		;
	JE	PATPXM1		;
	JMP	PATPXM_ERROR	;
PATPXM1:
	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
	MOV	DX,ES:[DI][PARTS_OFST_ATR]
	CMP	DX,0
	JNE	PATPXM44
	JMP	PATPXM_ERROR			; end of data.
PATPXM44:
	;	データ復元
	MOV	AX,ES:[DI][PARTS_OFST_LNX]	; Ｘ長さ
	MOV	VRLENX,AX			; Ｘ方向長さ
	MOV	AX,ES:[DI][PARTS_OFST_LNY]	; Ｙ長さ
	MOV	VRLENY,AX			; Ｙ方向長さ

	MOV	BPNTOF,DI		; データバッファポインタ
	ADD	BPNTOF,PARTS_OFST_DAT	; データ開始オフセット
	MOV	AX,PRSSEG		; バンクセグメント
	MOV	BPNTSG,AX		;

	MOV	AX,ES:[DI][PARTS_OFST_LEN]	; データ長さ
	MOV	BCNTMX,AX			; データ最大長さ

	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 3 ; 属性(0=データ終わり,
						; 1=無圧縮データ,2=圧縮データ
						; 3=マスクデータ)
	JNE	PATPXM6				;

	MOV	AX,PMSKPL			; マスクＰＵＴプレーン指定
	MOV	BMSKCL,AX			; マスキングカラー
	CALL	UNPLSM				; マスク化（マスクデータ復元）

	JMP	PATPXM_EXIT			;
PATPXM6:

PATPXM_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATPXM_ERROR:
	MOV	AX,1	; not found.
	POP	CX
	RET
PATPXM	ENDP



;	マスクパーツＰＵＴオフセット指定
;	-I-   CX  : パーツ番号
;	-I/O- VRX : ＶＲＡＭ　Ｘ座標
;	      VRY : ＶＲＡＭ　Ｙ座標
;	-O-   AX  : 0=normal end, 1=error.

PATPFM	PROC	NEAR
	PUSH	CX

	CALL	PARTSCH		; パーツデータの検索
	CMP	AX,0		;
	JE	PATPFM1		;
	JMP	PATPFM_ERROR	;
PATPFM1:
	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
	MOV	DX,ES:[DI][PARTS_OFST_ATR]
	CMP	DX,0
	JNE	PATPFM44
	JMP	PATPFM_ERROR			; end of data.
PATPFM44:
	;	データ復元
	MOV	AX,ES:[DI][PARTS_OFST_X]	; Ｘ座標
	ADD	VRX,AX				; ＶＲＡＭ　Ｘ座標
	MOV	AX,ES:[DI][PARTS_OFST_Y]	; Ｙ座標
	ADD	VRY,AX				; ＶＲＡＭ　Ｙ座標

	MOV	AX,ES:[DI][PARTS_OFST_LNX]	; Ｘ長さ
	MOV	VRLENX,AX			; Ｘ方向長さ
	MOV	AX,ES:[DI][PARTS_OFST_LNY]	; Ｙ長さ
	MOV	VRLENY,AX			; Ｙ方向長さ

	MOV	BPNTOF,DI		; データバッファポインタ
	ADD	BPNTOF,PARTS_OFST_DAT	; データ開始オフセット
	MOV	AX,PRSSEG		; バンクセグメント
	MOV	BPNTSG,AX		;

	MOV	AX,ES:[DI][PARTS_OFST_LEN]	; データ長さ
	MOV	BCNTMX,AX			; データ最大長さ

	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 3 ; 属性(0=データ終わり,
						; 1=無圧縮データ,2=圧縮データ
						; 3=マスクデータ)
	JNE	PATPFM6				;

	MOV	AX,PMSKPL			; マスクＰＵＴプレーン指定
	MOV	BMSKCL,AX			; マスキングカラー
	CALL	UNPLSM				; マスク化（マスクデータ復元）

	JMP	PATPFM_EXIT			;
PATPFM6:

PATPFM_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATPFM_ERROR:
	MOV	AX,1	; not found.
	POP	CX
	RET
PATPFM	ENDP



;	パーツサイズのＧＥＴ
;	-I- CX : パーツ番号
;	-O- VRX		: ＶＲＡＭ　Ｘ座標
;	    VRY		: ＶＲＡＭ　Ｙ座標
;	    VRLENX	: Ｘ方向長さ
;	    VRLENY	: Ｙ方向長さ
;	    AX : 0=normal end, 1=error.

PATSIZ	PROC	NEAR
	PUSH	CX

	CALL	PARTSCH		; パーツデータの検索
	CMP	AX,0		;
	JE	PATSIZ1		;
	JMP	PATSIZ_ERROR	;
PATSIZ1:
	;	データ復元
	MOV	AX,ES:[DI][PARTS_OFST_X]	; Ｘ座標
	MOV	VRX,AX				; ＶＲＡＭ　Ｘ座標
	MOV	AX,ES:[DI][PARTS_OFST_Y]	; Ｙ座標
	MOV	VRY,AX				; ＶＲＡＭ　Ｙ座標
	MOV	AX,ES:[DI][PARTS_OFST_LNX]	; Ｘ長さ
	MOV	VRLENX,AX			; Ｘ方向長さ
	MOV	AX,ES:[DI][PARTS_OFST_LNY]	; Ｙ長さ
	MOV	VRLENY,AX			; Ｙ方向長さ
PATSIZ_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATSIZ_ERROR:
	MOV	AX,1	; not found.
	POP	CX
	RET
PATSIZ	ENDP


;*NON*;
;*NON*;;	先頭パターンデータの削除
;*NON*;;	-I- CX : 残す先頭のパーツ番号
;*NON*;
;*NON*;PATTPD	PROC	NEAR
;*NON*;	PUSH	CX
;*NON*;
;*NON*;	CALL	PARTSCH			; パーツデータの検索
;*NON*;
;*NON*;	MOV	SI,DI			; 残すデータの先頭=SI
;*NON*;
;*NON*;	MOV	CX,PRSEND		; バンクエンドオフセット
;*NON*;	SUB	CX,SI			; 転送データ量
;*NON*;
;*NON*;	MOV	DI,PRSTOP		; バンクトップオフセット
;*NON*;
;*NON*;	PUSH	DS
;*NON*;	MOV	AX,PRSSEG		; バンクセグメント
;*NON*;	MOV	ES,AX			;
;*NON*;	MOV	DS,AX			; PARTS_SEG 内の転送
;*NON*;	REP	MOVSB			; 転送
;*NON*;	POP	DS
;*NON*;
;*NON*;	MOV	CX,0FFFFH		;
;*NON*;	CALL	PARTSCH			; パーツデータの検索
;*NON*;	MOV	PRSOFS,DI		; パーツバッファのカレントポインタ
;*NON*;
;*NON*;	SUB	DI,PRSTOP		; バンクトップオフセット
;*NON*;	MOV	PRSSIZ,DI		; パーツバッファの使用サイズ
;*NON*;
;*NON*;	POP	CX
;*NON*;	RET
;*NON*;PATTPD	ENDP
;*NON*;
;*NON*;
;*NON*;
;*NON*;;	指定パターンデータ以降の削除
;*NON*;;	-I- CX : 削除する先頭のパーツ番号
;*NON*;
;*NON*;PATEDD	PROC	NEAR
;*NON*;	PUSH	CX
;*NON*;
;*NON*;	CALL	PARTSCH			; パーツデータの検索
;*NON*;
;*NON*;	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
;*NON*;	MOV	AX,PRSSEG		; バンクセグメント
;*NON*;	MOV	ES,AX			;
;*NON*;	MOV	WORD PTR ES:[DI][PARTS_OFST_ATR],0
;*NON*;
;*NON*;	MOV	PRSOFS,DI		; パーツバッファのカレントポインタ
;*NON*;
;*NON*;	SUB	DI,PRSTOP		; バンクトップオフセット
;*NON*;	MOV	PRSSIZ,DI		; パーツバッファの使用サイズ
;*NON*;
;*NON*;	POP	CX
;*NON*;	RET
;*NON*;PATEDD	ENDP
;*NON*;

;	マスクパーツのＰＵＴプレーン設定
;	-I- DX : ＰＵＴプレーン指定(bit0=ﾌﾟﾚｰﾝ0,bit1=ﾌﾟﾚｰﾝ1,bit2=2,bit3=3)

PATMST	PROC	NEAR
	MOV	PMSKPL,DX	; マスクＰＵＴプレーン指定
	RET
PATMST	ENDP


;	パーツデータの検索
;	-I- CX    : データ番号
;	-O- ES:DI : データ終りポインタ
;	    AX    : 0=normal 1=end of data.
;	    BX    : 検索データ番号

PARTSCH	PROC	NEAR
	PUSH	CX
	MOV	BX,0			; 検索データ番号
	MOV	AX,PRSSEG		; バンクセグメント
	MOV	ES,AX			;
	MOV	DI,PRSTOP		; バンクトップオフセット
	CMP	CX,0			;
	JE	PARTSCH3		;
PARTSCH2:
	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
	CMP	WORD PTR ES:[DI][PARTS_OFST_ATR],0
	JE	PARTSCH4_NOT			; end of data.
	MOV	DX,ES:[DI][PARTS_OFST_LEN]	; データ長さ
	ADD	DI,DX				;
	ADD	DI,PARTS_OFST_DAT		; データ開始オフセット
	INC	BX			; 検索データ番号
	LOOP	PARTSCH2
PARTSCH3:
	CMP	WORD PTR ES:[DI][PARTS_OFST_ATR],0
	JE	PARTSCH4_NOT			; end of data.
PARTSCH4:
	MOV	AX,0		; 0=normal.
	POP	CX
	RET
PARTSCH4_NOT:
	MOV	AX,1		; 1=not found.
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

EXTRN	BMSKCL:WORD		; マスキングカラー
EXTRN	BORRCL:WORD		; ＯＲカラー

	EVEN
PMSKPL	DW	1111B		; マスクＰＵＴプレーン指定
				; (bit0=ﾌﾟﾚｰﾝ0,bit1=ﾌﾟﾚｰﾝ1,bit2=2,bit3=3)

DATA	ENDS

	END
;
;	end of "PARTT2.ASM"
;
