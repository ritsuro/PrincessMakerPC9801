; "PARTST.ASM" PC-9801UV11 make by R.H 1989/12/08
;
;
;	パーツデータＧＥＴ＆ＰＵＴ
;
;
; public subroutine.

;	ＤＴＡ領域の長さと合わせてあるので
;	変更の際には注意してください

PARTS_BUFF_LEN	EQU	65000	; パーツデータバッファサイズ


;	パーツバッファのオフセット値

PARTS_OFST_ATR	EQU	0	; 属性(0=データ終わり,
				;      1=無圧縮データ,2=圧縮データ)
PARTS_OFST_X	EQU	2	; Ｘ座標
PARTS_OFST_Y	EQU	4	; Ｙ座標
PARTS_OFST_LNX	EQU	6	; Ｘ長さ
PARTS_OFST_LNY	EQU	8	; Ｙ長さ
PARTS_OFST_LEN	EQU	10	; データ長さ
PARTS_OFST_DAT	EQU	12	; データ開始オフセット


PARTS0	SEGMENT	PUBLIC	'PARTS0'
	EVEN
TOP_OF_PARTS0	LABEL	BYTE
	DB	PARTS_BUFF_LEN DUP (0)	; パーツデータバッファサイズ
END_OF_PARTS0	LABEL	BYTE
	DB	0,0
PARTS0	ENDS


PARTS1	SEGMENT	PUBLIC	'PARTS1'
	EVEN
TOP_OF_PARTS1	LABEL	BYTE
	DB	2 DUP (0)	; パーツデータバッファサイズ
END_OF_PARTS1	LABEL	BYTE
	DB	0,0
PARTS1	ENDS


PARTS2	SEGMENT	PUBLIC	'PARTS2'
	EVEN
TOP_OF_PARTS2	LABEL	BYTE
	DB	2 DUP (0)	; パーツデータバッファサイズ
END_OF_PARTS2	LABEL	BYTE
	DB	0,0
PARTS2	ENDS




CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA

PUBLIC	PATINI		; パーツセット初期処理
PUBLIC	PATCLR		; パーツセットクリア
PUBLIC	PATGET		; パーツＧＥＴ
PUBLIC	PATGTA		; パーツＧＥＴ圧縮無し
PUBLIC	PATGTC		; パーツＧＥＴ圧縮無し番号指定
PUBLIC	PATPUT		; パーツＰＵＴ
PUBLIC	PATPTX		; パーツＰＵＴ座標指定
PUBLIC	PATPTF		; パーツＰＵＴオフセット指定
PUBLIC	PATSAV		; パーツセーブ
PUBLIC	PATLOD		; パーツロード
PUBLIC	PATLDA		; パーツ追加ロード
PUBLIC	PATBNK		; バンクチェンジ
PUBLIC	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )


EXTRN	UNPLS:NEAR		; データ復元
EXTRN	PLESS:NEAR		; データ圧縮

EXTRN	UNPOR:NEAR		; データ復元（ＯＲ処理）
EXTRN	UNPORS:NEAR		; データ復元（ＯＲ処理）単プレーンパターン

EXTRN	VRMGT:NEAR		; ＶＲＡＭデータＧＥＴ
EXTRN	VRMPT:NEAR		; ＶＲＡＭデータＰＵＴ

EXTRN	DSKLD:NEAR		; load data.
EXTRN	DSKSV:NEAR		; save data.




;	パーツセット初期処理

PATINI	PROC	NEAR
				; デフォルトのパーツバッファ＃０
	MOV	AX,SEGPAT0	; セグメント
	MOV	BX,TOPPAT0	; 先頭オフセット
	MOV	CX,ENDPAT0	; 終了オフセット

	MOV	PRSSEG,AX	; バンクセグメント
	MOV	PRSTOP,BX	; バンクトップオフセット
	MOV	PRSEND,CX	; バンクエンドオフセット

	CALL	PATCLR		; パーツセットクリア
	RET
PATINI	ENDP



;	パーツセットクリア

PATCLR	PROC	NEAR
	PUSH	ES

		; パーツバッファのカレントポインタ
	MOV	AX,PRSTOP		; バンクトップオフセット
	MOV	PRSOFS,AX		;

		; パーツバッファの使用サイズ
	MOV	PRSSIZ,0

	MOV	AX,PRSSEG		; バンクセグメント
	MOV	ES,AX			;

	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)

	MOV	ES:[PARTS_OFST_ATR],WORD PTR 0

	POP	ES
	RET
PATCLR	ENDP



;	パーツＧＥＴ圧縮無し
;	-I- VRX		: ＶＲＡＭ　Ｘ座標
;	    VRY		: ＶＲＡＭ　Ｙ座標
;	    VRLENX	: Ｘ方向長さ
;	    VRLENY	: Ｙ方向長さ
;	-O- AX		: 0=normal end, 1=error.
;	    BX    	: 格納データ番号

PATGTA	PROC	NEAR
	PUSH	CX

	MOV	CX,0FFFFH		;
	CALL	PARTSCH			; パーツデータの検索
	MOV	PRSOFS,DI		; パーツバッファのカレントポインタ
	SUB	DI,PRSTOP		; バンクトップオフセット
	MOV	PRSSIZ,DI		; パーツバッファの使用サイズ

	MOV	AX,PRSSEG		; バンクセグメント
	MOV	ES,AX			;

	MOV	DI,PRSOFS ; パーツバッファのカレントポインタ

	MOV	AX,VRX				; ＶＲＡＭ　Ｘ座標
	MOV	ES:[DI][PARTS_OFST_X],AX	; Ｘ座標
	MOV	AX,VRY				; ＶＲＡＭ　Ｙ座標
	MOV	ES:[DI][PARTS_OFST_Y],AX	; Ｙ座標
	MOV	AX,VRLENX			; Ｘ方向長さ
	MOV	ES:[DI][PARTS_OFST_LNX],AX	; Ｘ長さ
	MOV	AX,VRLENY			; Ｙ方向長さ
	MOV	ES:[DI][PARTS_OFST_LNY],AX	; Ｙ長さ

	MOV	BPNTOF,DI		; データバッファポインタ
	ADD	BPNTOF,PARTS_OFST_DAT	; データ開始オフセット
	MOV	AX,PRSSEG		; バンクセグメント
	MOV	BPNTSG,AX		;
	MOV	AX,PRSEND		; バンクエンドオフセット
	SUB	AX,BPNTOF		; データ開始オフセット
	MOV	BCNTMX,AX		; データ最大長さ

	PUSH	BX
	PUSH	DI
	PUSH	ES
	CALL	VRMGT			; ＶＲＡＭデータＧＥＴ
	POP	ES
	POP	DI
	POP	BX

	CMP	AH,1	; 0 or 2 : normal end. 1:write error.
	JE	PATGTA_ERROR

	MOV	AX,BCOUNT			; データ長さ
	MOV	ES:[DI][PARTS_OFST_LEN],AX	; データ長さ

	MOV	AX,BCOUNT		; データ長さ
	ADD	AX,PARTS_OFST_DAT	; データ開始オフセット
	ADD	PRSSIZ,AX	; パーツバッファの使用サイズ

	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 1

	MOV	DI,BPOINT 		; データ終わりアドレス＋１
	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 0

	MOV	PRSOFS,DI ; パーツバッファのカレントポインタ
PATGTA_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATGTA_ERROR:
	MOV	AX,1	; buffer full.
	POP	CX
	RET
PATGTA	ENDP



;	パーツＧＥＴ圧縮無し番号指定
;	-I- VRX		: ＶＲＡＭ　Ｘ座標
;	    VRY		: ＶＲＡＭ　Ｙ座標
;	    VRLENX	: Ｘ方向長さ
;	    VRLENY	: Ｙ方向長さ
;	    CX          :
;	-O- AX		: 0=normal end, 1=error.
;	    BX    	: 格納データ番号

PATGTC	PROC	NEAR
	PUSH	CX

	CALL	PARTSCH			; パーツデータの検索
	MOV	PRSOFS,DI		; パーツバッファのカレントポインタ
	SUB	DI,PRSTOP		; バンクトップオフセット
	MOV	PRSSIZ,DI		; パーツバッファの使用サイズ

	MOV	AX,PRSSEG		; バンクセグメント
	MOV	ES,AX			;

	MOV	DI,PRSOFS ; パーツバッファのカレントポインタ

	MOV	AX,VRX				; ＶＲＡＭ　Ｘ座標
	MOV	ES:[DI][PARTS_OFST_X],AX	; Ｘ座標
	MOV	AX,VRY				; ＶＲＡＭ　Ｙ座標
	MOV	ES:[DI][PARTS_OFST_Y],AX	; Ｙ座標
	MOV	AX,VRLENX			; Ｘ方向長さ
	MOV	ES:[DI][PARTS_OFST_LNX],AX	; Ｘ長さ
	MOV	AX,VRLENY			; Ｙ方向長さ
	MOV	ES:[DI][PARTS_OFST_LNY],AX	; Ｙ長さ

	MOV	BPNTOF,DI		; データバッファポインタ
	ADD	BPNTOF,PARTS_OFST_DAT	; データ開始オフセット
	MOV	AX,PRSSEG		; バンクセグメント
	MOV	BPNTSG,AX		;
	MOV	AX,PRSEND		; バンクエンドオフセット
	SUB	AX,BPNTOF		; データ開始オフセット
	MOV	BCNTMX,AX		; データ最大長さ

	PUSH	BX
	PUSH	DI
	PUSH	ES
	CALL	VRMGT			; ＶＲＡＭデータＧＥＴ
	POP	ES
	POP	DI
	POP	BX

	CMP	AH,1	; 0 or 2 : normal end. 1:write error.
	JE	PATGTC_ERROR

	MOV	AX,BCOUNT			; データ長さ
	MOV	ES:[DI][PARTS_OFST_LEN],AX	; データ長さ

	MOV	AX,BCOUNT		; データ長さ
	ADD	AX,PARTS_OFST_DAT	; データ開始オフセット				ADD	PRSSIZ,AX	; パーツバッファの使用サイズ

	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 1

	MOV	DI,BPOINT 		; データ終わりアドレス＋１
	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 0

	MOV	PRSOFS,DI ; パーツバッファのカレントポインタ
PATGTC_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATGTC_ERROR:
	MOV	AX,1	; buffer full.
	POP	CX
	RET
PATGTC	ENDP



;	パーツＧＥＴ
;	-I- VRX		: ＶＲＡＭ　Ｘ座標
;	    VRY		: ＶＲＡＭ　Ｙ座標
;	    VRLENX	: Ｘ方向長さ
;	    VRLENY	: Ｙ方向長さ
;	-O- AX		: 0=normal end, 1=error.

PATGET	PROC	NEAR
	PUSH	CX

	MOV	AX,PRSSEG		; バンクセグメント
	MOV	ES,AX			;

	MOV	DI,PRSOFS ; パーツバッファのカレントポインタ

	;	データ圧縮
	MOV	AX,VRX				; ＶＲＡＭ　Ｘ座標
	MOV	ES:[DI][PARTS_OFST_X],AX	; Ｘ座標
	MOV	AX,VRY				; ＶＲＡＭ　Ｙ座標
	MOV	ES:[DI][PARTS_OFST_Y],AX	; Ｙ座標
	MOV	AX,VRLENX			; Ｘ方向長さ
	MOV	ES:[DI][PARTS_OFST_LNX],AX	; Ｘ長さ
	MOV	AX,VRLENY			; Ｙ方向長さ
	MOV	ES:[DI][PARTS_OFST_LNY],AX	; Ｙ長さ

	MOV	BPNTOF,DI		; データバッファポインタ
	ADD	BPNTOF,PARTS_OFST_DAT	; データ開始オフセット
	MOV	AX,PRSSEG		; バンクセグメント
	MOV	BPNTSG,AX		;
	MOV	AX,PRSEND		; バンクエンドオフセット
	SUB	AX,BPNTOF		; データ開始オフセット
	MOV	BCNTMX,AX		; データ最大長さ

	PUSH	DI
	PUSH	ES
	CALL	PLESS			; データ圧縮
	POP	ES
	POP	DI

	CMP	AH,1	; 0 or 2 : normal end. 1:write error.
	JE	PATGET_ERROR

	MOV	AX,BCOUNT			; データ長さ
	MOV	ES:[DI][PARTS_OFST_LEN],AX	; データ長さ

	MOV	AX,BCOUNT		; データ長さ
	ADD	AX,PARTS_OFST_DAT
	ADD	PRSSIZ,AX	; パーツバッファの使用サイズ

	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 2

	MOV	DI,BPOINT 		; データ終わりアドレス＋１
	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 0

	MOV	PRSOFS,DI ; パーツバッファのカレントポインタ
PATGET_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATGET_ERROR:
	MOV	AX,1	; buffer full.
	POP	CX
	RET
PATGET	ENDP




;	パーツＰＵＴ
;	-I- CX : パーツ番号
;	-O- AX : 0=normal end, 1=error.

PATPUT	PROC	NEAR
	PUSH	CX

	CALL	PARTSCH		; パーツデータの検索
	CMP	AX,0		;
	JE	PATPUT1		;
	JMP	PATPUT_ERROR	;
PATPUT1:
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

	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 1 ; 属性(0=データ終わり,
						; 1=無圧縮データ,2=圧縮データ)
	JNE	PATPUT5				;
	CALL	VRMPT				; ＶＲＡＭデータＰＵＴ
	JMP	PATPUT_EXIT			;
PATPUT5:
	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 2 ; 属性(0=データ終わり,
						; 1=無圧縮データ,2=圧縮データ)
	JNE	PATPUT6				;

	CMP	PRSOPE,0			; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
	JNE	PATPUT55			; 0=normal,1=OR,2=OR2
	CALL	UNPLS				; データ復元
	JMP	PATPUT_EXIT			;
PATPUT55:
	CMP	PRSOPE,1			; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
	JNE	PATPUT56			; 0=normal,1=OR,2=OR2
	CALL	UNPOR				; データ復元（ＯＲ処理）
	JMP	PATPUT_EXIT			;
PATPUT56:
	CMP	PRSOPE,2			; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
	JNE	PATPUT6				; 0=normal,1=OR,2=OR2
	CALL	UNPORS				; データ復元（ＯＲ処理）
						; 単プレーンパターン
	JMP	PATPUT_EXIT			;
PATPUT6:

PATPUT_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATPUT_ERROR:
	MOV	AX,1	; not found.
	POP	CX
	RET
PATPUT	ENDP



;	パーツＰＵＴ座標指定
;	-I- CX  : パーツ番号
;	    VRX	: ＶＲＡＭ　Ｘ座標
;	    VRY : ＶＲＡＭ　Ｙ座標
;	-O- AX  : 0=normal end, 1=error.

PATPTX	PROC	NEAR
	PUSH	CX

	CALL	PARTSCH		; パーツデータの検索
	CMP	AX,0		;
	JE	PATPTX1		;
	JMP	PATPTX_ERROR	;
PATPTX1:
	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
	MOV	DX,ES:[DI][PARTS_OFST_ATR]
	CMP	DX,0
	JNE	PATPTX44
	JMP	PATPTX_ERROR			; end of data.
PATPTX44:
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

	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 1 ; 属性(0=データ終わり,
						; 1=無圧縮データ,2=圧縮データ)
	JNE	PATPTX5				;
	CALL	VRMPT				; ＶＲＡＭデータＰＵＴ
	JMP	PATPTX_EXIT			;
PATPTX5:
	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 2 ; 属性(0=データ終わり,
						; 1=無圧縮データ,2=圧縮データ)
	JNE	PATPTX6				;

	CMP	PRSOPE,0			; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
	JNE	PATPTX55			; 0=normal,1=OR
	CALL	UNPLS				; データ復元
	JMP	PATPTX_EXIT			;
PATPTX55:
	CMP	PRSOPE,1			; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
	JNE	PATPTX56			; 0=normal,1=OR,2=OR2
	CALL	UNPOR				; データ復元（ＯＲ処理）
	JMP	PATPTX_EXIT			;
PATPTX56:
	CMP	PRSOPE,2			; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
	JNE	PATPTX6				; 0=normal,1=OR,2=OR2
	CALL	UNPORS				; データ復元（ＯＲ処理）
						; 単プレーンパターン
	JMP	PATPTX_EXIT			;
PATPTX6:
PATPTX_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATPTX_ERROR:
	MOV	AX,1	; not found.
	POP	CX
	RET
PATPTX	ENDP



;	パーツＰＵＴオフセット指定
;	-I-   CX  : パーツ番号
;	-I/O- VRX : ＶＲＡＭ　Ｘ座標
;	      VRY : ＶＲＡＭ　Ｙ座標
;	-O-   AX  : 0=normal end, 1=error.

PATPTF	PROC	NEAR
	PUSH	CX

	CALL	PARTSCH		; パーツデータの検索
	CMP	AX,0		;
	JE	PATPTF1		;
	JMP	PATPTF_ERROR	;
PATPTF1:
	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
	MOV	DX,ES:[DI][PARTS_OFST_ATR]
	CMP	DX,0
	JNE	PATPTF44
	JMP	PATPTF_ERROR			; end of data.
PATPTF44:
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

	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 1 ; 属性(0=データ終わり,
						; 1=無圧縮データ,2=圧縮データ)
	JNE	PATPTF5				;
	CALL	VRMPT				; ＶＲＡＭデータＰＵＴ
	JMP	PATPTF_EXIT			;
PATPTF5:
	CMP	ES:[DI][PARTS_OFST_ATR],WORD PTR 2 ; 属性(0=データ終わり,
						; 1=無圧縮データ,2=圧縮データ)
	JNE	PATPTF6				;

	CMP	PRSOPE,0			; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
	JNE	PATPTF55			; 0=normal,1=OR
	CALL	UNPLS				; データ復元
	JMP	PATPUT_EXIT			;
PATPTF55:
	CMP	PRSOPE,1			; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
	JNE	PATPTF56			; 0=normal,1=OR,2=OR2
	CALL	UNPOR				; データ復元（ＯＲ処理）
	JMP	PATPTF_EXIT			;
PATPTF56:
	CMP	PRSOPE,2			; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
	JNE	PATPTF6				; 0=normal,1=OR,2=OR2
	CALL	UNPORS				; データ復元（ＯＲ処理）
						; 単プレーンパターン
	JMP	PATPTF_EXIT			;
PATPTF6:
PATPTF_EXIT:
	MOV	AX,0	; normal.
	POP	CX
	RET
PATPTF_ERROR:
	MOV	AX,1	; not found.
	POP	CX
	RET
PATPTF	ENDP



;	パーツセーブ
;	-I- DS:SI : ファイル名
;	-o- AX    : 0:normal.
;	            1:error.

PATSAV	PROC	NEAR
	CALL	PAT_FLNSET	; パーツファイル名セット

	MOV	DI,PRSTOP		; バンクトップオフセット
	MOV	DX,PRSSEG		; バンクセグメント
	MOV	CX,PRSSIZ	; パーツバッファの使用サイズ
	MOV	SI,OFFSET FLPNAM	; パレットファイル名
	CALL	DSKSV			; file save.

	RET
PATSAV	ENDP



;	パーツロード
;	-I- DS:SI : ファイル名
;	-o- AX    : 0:normal.
;	            1:error.

PATLOD	PROC	NEAR
	CALL	PAT_FLNSET		; パーツファイル名セット

	MOV	DI,PRSTOP		; バンクトップオフセット
	MOV	DX,PRSSEG		; バンクセグメント
	MOV	CX,PRSEND		; バンクエンドオフセット
	SUB	CX,PRSTOP		; バンクトップオフセット
					; CX=パーツデータバッファサイズ
	MOV	SI,OFFSET FLPNAM	; パレットファイル名
	CALL	DSKLD			; file load.

	PUSH	AX

	MOV	CX,0FFFFH		;
	CALL	PARTSCH			; パーツデータの検索
	MOV	PRSOFS,DI	; パーツバッファのカレントポインタ

	SUB	DI,PRSTOP		; バンクトップオフセット
	MOV	PRSSIZ,DI	; パーツバッファの使用サイズ

	POP	AX

	RET
PATLOD	ENDP


;	パーツ追加ロード
;	-I- DS:SI : ファイル名
;	-o- AX    : 0:normal.
;	            1:error.

PATLDA	PROC	NEAR
	CALL	PAT_FLNSET		; パーツファイル名セット

	MOV	CX,0FFFFH		;
	CALL	PARTSCH			; パーツデータの検索

	MOV	CX,PRSEND		; バンクエンドオフセット
	SUB	CX,DI			;

	MOV	DX,PRSSEG		; バンクセグメント

	MOV	SI,OFFSET FLPNAM	; パレットファイル名
	CALL	DSKLD			; file load.

	PUSH	AX

	MOV	CX,0FFFFH		;
	CALL	PARTSCH			; パーツデータの検索

	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 0 ; データエンド

	MOV	PRSOFS,DI	; パーツバッファのカレントポインタ

	SUB	DI,PRSTOP		; バンクトップオフセット
	MOV	PRSSIZ,DI	; パーツバッファの使用サイズ

	POP	AX

	RET
PATLDA	ENDP



;	バンクチェンジ
;	-I- DX : バンク番号（０ー１）

PATBNK	PROC	NEAR

	MOV	PRSBNK,DX		; バンク番号

;	パーツバッファ＃０

	CMP	DX,0
	JNE	PATBNK1

	MOV	AX,SEGPAT0		;
	MOV	PRSSEG,AX		; バンクセグメント

	MOV	AX,TOPPAT0		;
	MOV	PRSTOP,AX		; バンクトップオフセット

	MOV	AX,ENDPAT0		;
	MOV	PRSEND,AX		; バンクエンドオフセット

	JMP	PATBNK99

;	パーツバッファ＃１

PATBNK1:
	CMP	DX,1
	JNE	PATBNK2

	MOV	AX,SEGPAT1		;
	MOV	PRSSEG,AX		; バンクセグメント

	MOV	AX,TOPPAT1		;
	MOV	PRSTOP,AX		; バンクトップオフセット

	MOV	AX,ENDPAT1		;
	MOV	PRSEND,AX		; バンクエンドオフセット

	JMP	PATBNK99

;	パーツバッファ＃２

PATBNK2:
	CMP	DX,2
	JNE	PATBNK3

	MOV	AX,SEGPAT2		;
	MOV	PRSSEG,AX		; バンクセグメント

	MOV	AX,TOPPAT2		;
	MOV	PRSTOP,AX		; バンクトップオフセット

	MOV	AX,ENDPAT2		;
	MOV	PRSEND,AX		; バンクエンドオフセット

	JMP	PATBNK99
PATBNK3:

PATBNK99:
	RET
PATBNK	ENDP



;	オペレーションセット
;	0:normal   通常のＰＵＴ
;	1:OR       ＯＲＰＵＴ
;	2:OR2      単プレーンパターンのＯＲＰＵＴ
;	-I- DX : ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ ( 0=normal,1=OR,2=OR2 )

PATOPE	PROC	NEAR

	MOV	PRSOPE,DX		; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
					; 0=normal,1=OR
	RET
PATOPE	ENDP



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



;	パーツファイル名セット
;	-I- DS:SI : ファイル名

PAT_FLNSET	PROC	NEAR
	PUSH	SI

	MOV	AX,DS
	MOV	ES,AX

	MOV	DI,OFFSET FLPNAM	; ファイル名クリア
	MOV	CX,8
	MOV	AL,' '
	REP	STOSB

	MOV	DI,OFFSET FLPNAM	; ファイル名
	MOV	CX,8
PAT_FLNSET2:
	LODSB
	CMP	AL,' '			; end of string.
	JB	PAT_FLNSET3		;
	STOSB
	LOOP	PAT_FLNSET2
PAT_FLNSET3:
	POP	SI
	RET
PAT_FLNSET	ENDP


CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'


;	パーツバッファ＃０

SEGPAT0	DW	SEG PARTS0		; セグメント
TOPPAT0	DW	OFFSET TOP_OF_PARTS0	; 先頭オフセット
ENDPAT0	DW	OFFSET END_OF_PARTS0	; 終了オフセット


;	パーツバッファ＃１

SEGPAT1	DW	SEG PARTS1		; セグメント
TOPPAT1	DW	OFFSET TOP_OF_PARTS1	; 先頭オフセット
ENDPAT1	DW	OFFSET END_OF_PARTS1	; 終了オフセット


;	パーツバッファ＃２

SEGPAT2	DW	SEG PARTS2		; セグメント
TOPPAT2	DW	OFFSET TOP_OF_PARTS2	; 先頭オフセット
ENDPAT2	DW	OFFSET END_OF_PARTS2	; 終了オフセット


EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.

EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

EXTRN	BPOINT:WORD		; data buffer point.
EXTRN	BPNTOF:WORD		; データバッファポインタ
EXTRN	BPNTSG:WORD		; データバッファセグメント
EXTRN	BCNTMX:WORD		; データ最大長さ
EXTRN	BCOUNT:WORD		; データ長さ


PUBLIC	PRSBNK			; バンク番号
PUBLIC	PRSSEG			; バンクセグメント
PUBLIC	PRSTOP			; バンクトップオフセット
PUBLIC	PRSEND			; バンクエンドオフセット

PUBLIC	PRSOFS			; パーツバッファのカレントポインタ
PUBLIC	PRSSIZ			; パーツバッファの使用サイズ


FLPNAM	DB	"        PT1",0	; ファイル名

		EVEN

PRSOFS		DW	0		; パーツバッファのカレントポインタ
PRSSIZ		DW	0		; パーツバッファの使用サイズ

PRSOPE		DW	0		; ＰＵＴ時ｵﾍﾟﾚｰｼｮﾝ
					; 0=normal,1=OR

PRSBNK		DW	0		; バンク番号

PRSSEG		DW	0		; バンクセグメント
PRSTOP		DW	0		; バンクトップオフセット
PRSEND		DW	0		; バンクエンドオフセット

DATA	ENDS

	END
;
;	end of "PARTST.ASM"
;
