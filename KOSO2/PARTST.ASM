; "PARTST.ASM" PC-9801UV11 make by R.H 1989/12/08
;
;
;	パーツデータＧＥＴ＆ＰＵＴ
;
;		SSGR0 : visual data segment plean 0
;		SSGR1 : visual data segment plean 1
;		SSGR2 : visual data segment plean 2
;		SSGR3 : visual data segment plean 3
;
;1991/02/06	マスクデータおよびＯＲのＰＵＴで縦圧縮が
;		扱えるようになりました。
;
;	高度なテクニックを使う場合
;
;
;	・マスクパーツのＰＵＴプレーンの設定
;		CALL PATMST(PARTT2.ASM) を呼び出して下さい
;
;	・ＯＲでＰＵＴするプレーンの設定
;		DS:BORRCL:WORD を設定して下さい
;		（詳細はPLSLD3.ASM/UNPORを参照のこと）
;
;	・オーバラップは PATEFC（パーツＰＵＴエフェクト）を使用して下さい
;	例）	MOV	AX,1		; 1=パターンＰＵＴオーバラップ
;		CALL	PATEFC		; パーツＰＵＴエフェクト
;		（オーバラップは縦圧縮時のみ可能）
;		オーバラップ単位時間の変更はBBOVTM（オーバラップタイム）を変更
;
;	・PATOPE（オペレーションセット）の
;		単プレーンパターンのＯＲＰＵＴとはデータ中の先頭の１プレーン分
;		だけのデータを全プレーンへセットする機能です
;
;	・プレーン毎のスキップを行えるようにしました。これは縦／横圧縮モード
;	　(PLSMDE=0:通常,1:縦方向) オーバラップ時(BBOVLP)のいずれでも使えます。
;	例）	MOV	DX,1000B	; スキッププレーン (bit3:plean3...)
;		CALL	PLSSKP		; パーツＰＵＴのプレーンスキップ
;
;	・縦／横圧縮方向の切り替え
;	例）	MOV	DX,0			; 圧縮モード(0:通常,1:縦方向)
;		CALL	PLSMOD(PLSLD2.ASM)	; 圧縮モード切り替え
;
;	・ハンドル対応の為、ファイル名をピリオド挿入に変更
;		FLPNAM	DB	"        .PT1",0
;
; public subroutine.

INCLUDE	TSTSET.INC

;	ＤＴＡ領域の長さと合わせてあるので
;	変更の際には注意してください

;*NON*;PARTS_BUFF_LEN	EQU	65000	; パーツデータバッファサイズ


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

PUBLIC	PATINI		; パーツセット初期処理
PUBLIC	PATCLR		; パーツセットクリア
;*NON*;PUBLIC	PATGET	; パーツＧＥＴ
PUBLIC	PATGTA		; パーツＧＥＴ圧縮無し
PUBLIC	PATGTC		; パーツＧＥＴ圧縮無し番号指定
PUBLIC	PATPUT		; パーツＰＵＴ
PUBLIC	PATPTX		; パーツＰＵＴ座標指定
PUBLIC	PATPTF		; パーツＰＵＴオフセット指定
;*NON*;PUBLIC	PATSAV	; パーツセーブ
PUBLIC	PATLOD		; パーツロード
PUBLIC	PATLDA		; パーツ追加ロード
PUBLIC	PATBNK		; バンクチェンジ
PUBLIC	PATOPE		; オペレーションセット(ｵﾍﾟﾚｰｼｮﾝ 0=normal,1=OR )
PUBLIC	PATCPY		; パーツコピー
PUBLIC	PATEFC		; パーツＰＵＴエフェクト


EXTRN	UNPLS:NEAR		; データ復元
;*NON*;EXTRN	PLESS:NEAR	; データ圧縮

EXTRN	UNPOR:NEAR		; データ復元（ＯＲ処理）
EXTRN	UNPORS:NEAR		; データ復元（ＯＲ処理）単プレーンパターン

EXTRN	VRMGT:NEAR		; ＶＲＡＭデータＧＥＴ
EXTRN	VRMPT:NEAR		; ＶＲＡＭデータＰＵＴ

EXTRN	DSKLD:NEAR		; load data.
;*NON*;EXTRN	DSKSV:NEAR	; save data.




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


;*NON*;
;*NON*;;	パーツＧＥＴ
;*NON*;;	-I- VRX		: ＶＲＡＭ　Ｘ座標
;*NON*;;	    VRY		: ＶＲＡＭ　Ｙ座標
;*NON*;;	    VRLENX	: Ｘ方向長さ
;*NON*;;	    VRLENY	: Ｙ方向長さ
;*NON*;;	-O- AX		: 0=normal end, 1=error.
;*NON*;
;*NON*;PATGET	PROC	NEAR
;*NON*;	PUSH	CX
;*NON*;
;*NON*;	MOV	AX,PRSSEG		; バンクセグメント
;*NON*;	MOV	ES,AX			;
;*NON*;
;*NON*;	MOV	DI,PRSOFS ; パーツバッファのカレントポインタ
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
;*NON*;	CALL	PLESS			; データ圧縮
;*NON*;	POP	ES
;*NON*;	POP	DI
;*NON*;
;*NON*;	CMP	AH,1	; 0 or 2 : normal end. 1:write error.
;*NON*;	JE	PATGET_ERROR
;*NON*;
;*NON*;	MOV	AX,BCOUNT			; データ長さ
;*NON*;	MOV	ES:[DI][PARTS_OFST_LEN],AX	; データ長さ
;*NON*;
;*NON*;	MOV	AX,BCOUNT		; データ長さ
;*NON*;	ADD	AX,PARTS_OFST_DAT
;*NON*;	ADD	PRSSIZ,AX	; パーツバッファの使用サイズ
;*NON*;
;*NON*;	;	属性(0=データ終わり,1=無圧縮データ,2=圧縮データ)
;*NON*;	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 2
;*NON*;
;*NON*;	MOV	DI,BPOINT 		; データ終わりアドレス＋１
;*NON*;	MOV	ES:[DI][PARTS_OFST_ATR],WORD PTR 0
;*NON*;
;*NON*;	MOV	PRSOFS,DI ; パーツバッファのカレントポインタ
;*NON*;PATGET_EXIT:
;*NON*;	MOV	AX,0	; normal.
;*NON*;	POP	CX
;*NON*;	RET
;*NON*;PATGET_ERROR:
;*NON*;	MOV	AX,1	; buffer full.
;*NON*;	POP	CX
;*NON*;	RET
;*NON*;PATGET	ENDP
;*NON*;
;*NON*;


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


;*NON*;
;*NON*;;	パーツセーブ
;*NON*;;	-I- DS:SI : ファイル名
;*NON*;;	-o- AX    : 0:normal.
;*NON*;;	            1:error.
;*NON*;
;*NON*;PATSAV	PROC	NEAR
;*NON*;	CALL	PAT_FLNSET	; パーツファイル名セット
;*NON*;
;*NON*;	MOV	DI,PRSTOP		; バンクトップオフセット
;*NON*;	MOV	DX,PRSSEG		; バンクセグメント
;*NON*;	MOV	CX,PRSSIZ	; パーツバッファの使用サイズ
;*NON*;	MOV	SI,OFFSET FLPNAM	; パレットファイル名
;*NON*;	CALL	DSKSV			; file save.
;*NON*;
;*NON*;	RET
;*NON*;PATSAV	ENDP
;*NON*;


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
;	-I- DX : バンク番号（０ー３）

PATBNK	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	AX,PRSSEG		; バンクセグメント
	MOV	ES,AX			;

	MOV	PRSBNK,DX		; バンク番号

	CALL	BNKNUM			; バンクアドレスＧＥＴ

	MOV	PRSSEG,AX		; バンクセグメント
	MOV	PRSTOP,BX		; バンクトップオフセット
	MOV	PRSEND,CX		; バンクエンドオフセット

	MOV	PRSOFS,BX		;
	MOV	PRSSIZ,0		; パーツバッファの使用サイズ

	POP	DX
	POP	CX
	POP	BX
	POP	AX
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



;	パーツコピー
;	-I- AX : バンク番号コピー元
;	    BX : バンク番号コピー先
;	    CX : コピー長さ

PATCPY	PROC	NEAR

	PUSH	CX

	PUSH	AX

	MOV	DX,BX			; バンク番号コピー先
	CALL	BNKNUM			; バンクアドレスＧＥＴ

	MOV	ES,AX			; バンクセグメント
	MOV	DI,BX			; バンクトップオフセット

	POP	AX

	MOV	DX,AX			; バンク番号コピー元
	CALL	BNKNUM			; バンクアドレスＧＥＴ

	POP	CX

	PUSH	DS			;
	MOV	DS,AX			; バンクセグメント
	MOV	SI,BX			; バンクトップオフセット
	REP	MOVSB			;
	POP	DS			;

	RET
PATCPY	ENDP



;	パーツＰＵＴエフェクト
;	-I- AX : 0=通常,1=パターンＰＵＴオーバラップ

PATEFC	PROC	NEAR
	MOV	BBOVLP,0	; パターンＰＵＴオーバラップフラグ

	CMP	AX,1		; 1=パターンＰＵＴオーバラップフラグ
	JNE	PATEFC2		;
	MOV	BBOVLP,1	; パターンＰＵＴオーバラップフラグ
PATEFC2:			;
	RET
PATEFC	ENDP



;	バンクアドレスＧＥＴ
;	-I- DX : バンク番号
;	-O- AX : バンクセグメント
;	    BX : バンクトップオフセット
;	    CX : バンクエンドオフセット
;	    DX : 1=バンク番号該当なし

BNKNUM	PROC	NEAR
	CMP	DX,0			; パーツバッファ＃０
	JNE	BNKNUM1			;

	MOV	AX,SEGPAT0		; バンクセグメント
	MOV	BX,TOPPAT0		; バンクトップオフセット
	MOV	CX,ENDPAT0		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM1:
	CMP	DX,1			; パーツバッファ＃１
	JNE	BNKNUM2			;

	MOV	AX,SEGPAT1		; バンクセグメント
	MOV	BX,TOPPAT1		; バンクトップオフセット
	MOV	CX,ENDPAT1		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM2:
	CMP	DX,2			; パーツバッファ＃２
	JNE	BNKNUM3			;

	MOV	AX,SEGPAT2		; バンクセグメント
	MOV	BX,TOPPAT2		; バンクトップオフセット
	MOV	CX,ENDPAT2		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM3:
	CMP	DX,3			; パーツバッファ＃３
	JNE	BNKNUM4			;

	MOV	AX,SEGPAT3		; バンクセグメント
	MOV	BX,TOPPAT3		; バンクトップオフセット
	MOV	CX,ENDPAT3		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM4:
	CMP	DX,4			; パーツバッファ＃４
	JNE	BNKNUM5			;

	MOV	AX,SEGPAT4		; バンクセグメント
	MOV	BX,TOPPAT4		; バンクトップオフセット
	MOV	CX,ENDPAT4		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM5:
	CMP	DX,5			; パーツバッファ＃５
	JNE	BNKNUM6			;

	MOV	AX,SEGPAT5		; バンクセグメント
	MOV	BX,TOPPAT5		; バンクトップオフセット
	MOV	CX,ENDPAT5		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM6:
	CMP	DX,6			; パーツバッファ＃６
	JNE	BNKNUM7			;

	MOV	AX,SEGPAT6		; バンクセグメント
	MOV	BX,TOPPAT6		; バンクトップオフセット
	MOV	CX,ENDPAT6		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM7:
	CMP	DX,7			; パーツバッファ＃７
	JNE	BNKNUM8			;

	MOV	AX,SEGPAT7		; バンクセグメント
	MOV	BX,TOPPAT7		; バンクトップオフセット
	MOV	CX,ENDPAT7		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM8:
	CMP	DX,8			; パーツバッファ＃８
	JNE	BNKNUM9			;

	MOV	AX,SEGPAT8		; バンクセグメント
	MOV	BX,TOPPAT8		; バンクトップオフセット
	MOV	CX,ENDPAT8		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM9:
	CMP	DX,9			; パーツバッファ＃９
	JNE	BNKNUM10		;

	MOV	CX,400			;
BNKNUM9L:				;
	PR	"pat9."			;
	LOOP	BNKNUM9L		;

	MOV	AX,SEGPAT9		; バンクセグメント
	MOV	BX,TOPPAT9		; バンクトップオフセット
	MOV	CX,ENDPAT9		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM10:
	CMP	DX,10			; パーツバッファ＃１０
	JNE	BNKNUM11		;

	MOV	AX,SEGPAT10		; バンクセグメント
	MOV	BX,TOPPAT10		; バンクトップオフセット
	MOV	CX,ENDPAT10		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM11:
	CMP	DX,11			; パーツバッファ＃１１
	JNE	BNKNUM12		;

	MOV	AX,SEGPAT11		; バンクセグメント
	MOV	BX,TOPPAT11		; バンクトップオフセット
	MOV	CX,ENDPAT11		; バンクエンドオフセット

	JMP	BNKNUM99
BNKNUM12:
	CMP	DX,12			; パーツバッファ＃１２
	JNE	BNKNUM13		;

	MOV	AX,SEGPAT12		; バンクセグメント
	MOV	BX,TOPPAT12		; バンクトップオフセット
	MOV	CX,ENDPAT12		; バンクエンドオフセット

	JMP	BNKNUM99

BNKNUM13:
	MOV	AX,0			; バンクセグメント
	MOV	BX,0			; バンクトップオフセット
	MOV	CX,0			; バンクエンドオフセット

	MOV	DX,1			; 1=バンク番号該当なし
	RET

BNKNUM99:
	MOV	DX,0			;
	RET
BNKNUM	ENDP



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

	MOV	AL,'.'		; add ".PT1"
	STOSB
	MOV	AL,'P'
	STOSB
	MOV	AL,'T'
	STOSB
	MOV	AL,'1'
	STOSB
	MOV	AL,0
	STOSB

	POP	SI
	RET
PAT_FLNSET	ENDP


CODE	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

;	パーツバッファ＃０

EXTRN	SEGPAT0:WORD		; セグメント
EXTRN	TOPPAT0:WORD		; 先頭オフセット
EXTRN	ENDPAT0:WORD		; 終了オフセット

;	パーツバッファ＃１

EXTRN	SEGPAT1:WORD		; セグメント
EXTRN	TOPPAT1:WORD		; 先頭オフセット
EXTRN	ENDPAT1:WORD		; 終了オフセット

;	パーツバッファ＃２

EXTRN	SEGPAT2:WORD		; セグメント
EXTRN	TOPPAT2:WORD		; 先頭オフセット
EXTRN	ENDPAT2:WORD		; 終了オフセット

;	パーツバッファ＃３

EXTRN	SEGPAT3:WORD		; セグメント
EXTRN	TOPPAT3:WORD		; 先頭オフセット
EXTRN	ENDPAT3:WORD		; 終了オフセット

;	パーツバッファ＃４

EXTRN	SEGPAT4:WORD		; セグメント
EXTRN	TOPPAT4:WORD		; 先頭オフセット
EXTRN	ENDPAT4:WORD		; 終了オフセット

;	パーツバッファ＃５

EXTRN	SEGPAT5:WORD		; セグメント
EXTRN	TOPPAT5:WORD		; 先頭オフセット
EXTRN	ENDPAT5:WORD		; 終了オフセット

;	パーツバッファ＃６

EXTRN	SEGPAT6:WORD		; セグメント
EXTRN	TOPPAT6:WORD		; 先頭オフセット
EXTRN	ENDPAT6:WORD		; 終了オフセット

;	パーツバッファ＃７

EXTRN	SEGPAT7:WORD		; セグメント
EXTRN	TOPPAT7:WORD		; 先頭オフセット
EXTRN	ENDPAT7:WORD		; 終了オフセット

;	パーツバッファ＃８

EXTRN	SEGPAT8:WORD		; セグメント
EXTRN	TOPPAT8:WORD		; 先頭オフセット
EXTRN	ENDPAT8:WORD		; 終了オフセット

;	パーツバッファ＃９

EXTRN	SEGPAT9:WORD		; セグメント
EXTRN	TOPPAT9:WORD		; 先頭オフセット
EXTRN	ENDPAT9:WORD		; 終了オフセット

;	パーツバッファ＃１０

EXTRN	SEGPAT10:WORD		; セグメント
EXTRN	TOPPAT10:WORD		; 先頭オフセット
EXTRN	ENDPAT10:WORD		; 終了オフセット

;	パーツバッファ＃１１

EXTRN	SEGPAT11:WORD		; セグメント
EXTRN	TOPPAT11:WORD		; 先頭オフセット
EXTRN	ENDPAT11:WORD		; 終了オフセット


;	パーツバッファ＃１２

EXTRN	SEGPAT12:WORD		; セグメント
EXTRN	TOPPAT12:WORD		; 先頭オフセット
EXTRN	ENDPAT12:WORD		; 終了オフセット



EXTRN	VRX:WORD		; x point.
EXTRN	VRY:WORD		; y point.

EXTRN	VRLENX:WORD		; x length.
EXTRN	VRLENY:WORD		; y length.

EXTRN	BPOINT:WORD		; data buffer point.
EXTRN	BPNTOF:WORD		; データバッファポインタ
EXTRN	BPNTSG:WORD		; データバッファセグメント
EXTRN	BCNTMX:WORD		; データ最大長さ
EXTRN	BCOUNT:WORD		; データ長さ

EXTRN	BBOVTM:WORD		; パターンＰＵＴオーバラップタイム
EXTRN	BBOVLP:WORD		; パターンＰＵＴオーバラップフラグ


PUBLIC	PRSBNK			; バンク番号
PUBLIC	PRSSEG			; バンクセグメント
PUBLIC	PRSTOP			; バンクトップオフセット
PUBLIC	PRSEND			; バンクエンドオフセット

PUBLIC	PRSOFS			; パーツバッファのカレントポインタ
PUBLIC	PRSSIZ			; パーツバッファの使用サイズ

FLPNAM	DB	"        .PT1",0	; ファイル名

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