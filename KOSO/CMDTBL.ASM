; "CMDTBL.ASM" PC-9801UV11 make by R.H 1990/10/13
;
;
;	「子育て」
;
;	各種バッファ＆テーブル
;
;
;
;
;	パーツバッファ＃２（ボタン）を１０Ｋバイト
;
;BTN      PT1     5680  91-05-02   13:14
;BTNSCD   PT1      460  91-05-02   15:52
;	total     6140
;
;	パーツバッファ＃３（飾り）を５Ｋバイト
;
;	SEGWID	ＷＩＮＤＯＷＳセグメントを７０００ｈバイトに
;
;
;	パーツバッファ＃１０ を１０Ｋバイトに
;
;F4_01    PT1     3742  91-04-08   20:17
;F5_01    PT1     3512  91-04-08   20:17
;	total     7254
;F4_02    PT1     3700  91-04-08   20:17
;F5_02    PT1     3748  91-04-08   20:17
;	total     7448
;F4_03    PT1     3764  91-04-08   20:17
;F5_03    PT1     3522  91-04-08   20:17
;	total     7286
;F4_04    PT1     3606  91-04-08   20:17
;F5_04    PT1     3812  91-04-08   20:17
;	total     7418
;
; ディレクトリは A:\ZS\PAT4
;
;CLEND    PT1     2244  91-04-16   23:17
;GRAPH    PT1      302  90-12-15   20:35
;PROPR    PT1      632  91-04-25   19:24
;VALUE    PT1      418  91-01-27   14:09
;PROP2    PT1      666  91-04-25   19:15
;	total     4262
;MONTH    PT1     2228  91-04-16   23:43
;WEEK     PT1     2134  91-04-16   23:45
;BIGNUM   PT1     1960  91-04-16   19:31
;	total    10584				(2958H) 2A00H
;
; ディレクトリは A:\ZS\PAT5
;
;PALET    PT1     2478  91-04-18    9:28
;						9B0H	.5
;        1 個のファイルがあります.
;
; ディレクトリは A:\ZS\PAT6
;
;PAT6     PT1     3208  90-12-12   19:57
;						D00H	.6
;        1 個のファイルがあります.
;
; ディレクトリは A:\ZS\PAT7
;
;PAT7     PT1     7674  91-05-03   19:57
;PAT7WK   PT1     7630  91-04-26   20:26
;	total    15304				3C00H   .7
;        1 個のファイルがあります.
;
;
; ディレクトリは A:\ZS\PAT8
;
;PAT8     PT1     4552  91-03-22   15:25
;BLOOD    PT1      838  91-04-16   17:43
;	total     5390				1510H	.8
;
;
;F4_01    PT1     3742  91-04-08   20:17
;F5_01    PT1     3512  91-04-08   20:17
;		7254
;F4_02    PT1     3700  91-04-08   20:17
;F5_02    PT1     3748  91-04-08   20:17
;		7448
;F4_03    PT1     3764  91-04-08   20:17
;F5_03    PT1     3522  91-04-08   20:17
;		7286
;F4_04    PT1     3606  91-04-08   20:17
;F5_04    PT1     3812  91-04-08   20:17
;		7418				2000H	.10
;
; (C) 1990 ritsurou hashimoto.

P_PAT4		EQU	2A0H		;.pat4
P_PAT5		EQU	09BH		;.pat5
P_PAT6		EQU	0D0H		;.pat6
P_PAT7		EQU	3C0H		;.pat7
P_PAT8		EQU	151H		;.pat8
P_WID1		EQU	780H		;.window1.com
P_PAT10		EQU	200H		;.pat10

SZ_PAT4		EQU	2A00H		;.pat4
SZ_PAT5		EQU	09B0H		;.pat5
SZ_PAT6		EQU	0D00H		;.pat6
SZ_PAT7		EQU	3C00H		;.pat7
SZ_PAT8		EQU	1510H		;.pat8
SZ_WID1		EQU	7800H		;.window1.com
SZ_PAT10	EQU	2000H		;.pat10


INCLUDE	TSTSET.INC

VRAM_SEG_G0	EQU	0A800H	; ＶＲＡＭプレーン０
VRAM_SEG_G1	EQU	0B000H	; ＶＲＡＭプレーン１
VRAM_SEG_G2	EQU	0B800H	; ＶＲＡＭプレーン２
VRAM_SEG_G3	EQU	0E000H	; ＶＲＡＭプレーン３
TEXT_VRAM_SEG	EQU	0A000H	; テキストＶＲＡＭセグメント

ATMTABLE_MAX	EQU	20	; 表示単語の上限

STRING_LEN 	EQU	255	; string length.
STR_VAL_LEN 	EQU	6	; string length.（数値表示用）
STR_VAL_LEN2	EQU	24	; string length.（数値表示拡張）


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:DATA

PUBLIC	TBLOPEN			; 各セグメントの割り当て
PUBLIC	TBLCLOSE		; 各セグメントの開放
PUBLIC	TBLSEGRET		; 各セグメント指定を初期状態にする


; ***********************************************
;	各セグメントの割り当て
;	-O- ALLOC_SEGMENT : 確保されたセグメント
;	    AX            : 0=正常,1=メモリ不足
; ***********************************************

TBLOPEN	PROC	NEAR

; Start  Stop   Length Name                   Class            Group
; 00000H 092C1H 092C2H DATA                   DATA
; 092D0H 094E5H 00216H KYICOD                 KYICOD
; 094F0H 09736H 00247H MOUSE_CODE             MOUSE_CODE
; 09740H 09828H 000E9H TMCODE                 TMCODE
; 09830H 0984BH 0001CH IOPORT                 IOPORT
; 09850H 09922H 000D3H BIOSPORT               BIOSPORT
; 09930H 0C3A6H 02A77H PMD_CODE               PMD_CODE
; 0C3B0H 0C9DDH 0062EH EMMCOD                 EMMCOD
; 0C9E0H 0CA03H 00024H EMMDAT                 EMMDAT
; 0CA10H 0CE8FH 00480H PALET                  PALET
; 0CE90H 13E12H 06F83H WINDOW                 WINDOW
; 13E14H 238A3H 0FA90H CODE                   CODE
; 238B0H 238E7H 00038H SCCCODE                SCCCODE
; 238F0H 26132H 02843H R_SEG                  R_SEG
; 26140H 29E25H 03CE6H R_SEG2                 R_SEG2
; 29E30H 305EDH 067BEH R_SEG3                 R_SEG3
; 305F0H 3158FH 00FA0H STACK                  

; 30D60H 31CFFH 00FA0H STACK                  

	MOV	AX,SEG DATA		;
	ADD	AX,031F0H		;
	MOV	ALLOC_SEGMENT,AX	; 確保されたセグメント

	CALL	TBLINI			; テーブル初期化

	MOV	AX,0			; 0=正常
	RET
TBLOPEN_ERROR:
	MOV	AX,1			; 1=メモリ不足
	RET
TBLOPEN	ENDP



; ***********************************************
;	各セグメントの開放
;	-I- ALLOC_SEGMENT : 確保されたセグメント
; ***********************************************

TBLCLOSE	PROC	NEAR
	RET
TBLCLOSE	ENDP



; ***********************************************
;	各セグメント指定を初期状態にする
; ***********************************************

TBLSEGRET	PROC	NEAR
	MOV	AX,ARAVRM[0]		; ＶＲＡＭプレーン
	MOV	BX,ARAVRM[2]		;
	MOV	CX,ARAVRM[4]		;
	MOV	DX,ARAVRM[6]		;

	MOV	SSGR0,AX		; visual data segment plean 0
	MOV	SSGR1,BX		; visual data segment plean 1
	MOV	SSGR2,CX		; visual data segment plean 2
	MOV	SSGR3,DX		; visual data segment plean 3

	MOV	SSDEST,AX		; visual data segment plean.
	MOV	SSDES0,AX		; visual data segment plean 0
	MOV	SSDES1,BX		; visual data segment plean 1
	MOV	SSDES2,CX		; visual data segment plean 2
	MOV	SSDES3,DX		; visual data segment plean 3

	MOV	SSSOUR,AX		; visual data segment plean.
	MOV	SSSOU0,AX		; visual data segment plean 0
	MOV	SSSOU1,BX		; visual data segment plean 1
	MOV	SSSOU2,CX		; visual data segment plean 2
	MOV	SSSOU3,DX		; visual data segment plean 3

	MOV	SSEFCT,AX		; visual data segment plean.
	MOV	SSEFC0,AX		; visual data segment plean 0
	MOV	SSEFC1,BX		; visual data segment plean 1
	MOV	SSEFC2,CX		; visual data segment plean 2
	MOV	SSEFC3,DX		; visual data segment plean 3
	RET
TBLSEGRET	ENDP



; ***********************************************
;	テーブル初期化
;	-I- ALLOC_SEGMENT : 確保されたセグメント
; ***********************************************

TBLINI	PROC	NEAR
	CALL	SEGLOC			; セグメント・ロケーション

	MOV	AX,SEGDOS		; ＤＯＳインターフェースセグメント
	MOV	ES,AX			;
	MOV	DI,0			;
	MOV	CX,0FFFFH/2		;
	MOV	AX,0			;
	REP	STOSW			;

	RET
TBLINI	ENDP



; ***********************************************
;	セグメント・ロケーション
;	-I- ALLOC_SEGMENT : 確保されたセグメント
; ***********************************************

SEGLOC	PROC	NEAR
	MOV	AX,ALLOC_SEGMENT	; 確保されたセグメント

	ADD	SEGDOS,AX		; ＤＯＳインターフェースセグメント

	ADD	SEGPAT0,AX		; パーツバッファ＃０セグメント
	ADD	SEGPAT1,AX		; パーツバッファ＃１セグメント
	ADD	SEGPAT2,AX		; パーツバッファ＃２セグメント
	ADD	SEGPAT3,AX		; パーツバッファ＃３セグメント
	ADD	SEGPAT4,AX		; パーツバッファ＃４セグメント
	ADD	SEGPAT5,AX		; パーツバッファ＃５セグメント
	ADD	SEGPAT6,AX		; パーツバッファ＃６セグメント
	ADD	SEGPAT7,AX		; パーツバッファ＃７セグメント
	ADD	SEGPAT8,AX		; パーツバッファ＃８セグメント
	ADD	SEGPAT9,AX		; パーツバッファ＃９セグメント
	ADD	SEGWID,AX		; ＷＩＮＤＯＷＳセグメント
	ADD	SEGPAT10,AX		; パーツバッファ＃１０セグメント
	ADD	SEGPAT11,AX		; パーツバッファ＃１１セグメント
	ADD	SEGPAT12,AX		; パーツバッファ＃１２セグメント
	ADD	SEGFRE,AX		; フリー領域の先頭セグメント

					; 仮想ＶＲＡＭプレーン１(ＤＯＳ＋＃０)
	ADD	ARA001[0],AX		; area plean 0.
	ADD	ARA001[2],AX		; area plean 1.
	ADD	ARA001[4],AX		; area plean 2.
	ADD	ARA001[6],AX		; area plean 3.

					; 仮想ＶＲＡＭプレーン２（＃０／＃１）
	ADD	ARA002[0],AX		; area plean 0.
	ADD	ARA002[2],AX		; area plean 1.
	ADD	ARA002[4],AX		; area plean 2.
	ADD	ARA002[6],AX		; area plean 3.

					; 仮想ＶＲＡＭプレーン３（ＤＯＳ/200）
	ADD	ARA003[0],AX		; area plean 0.
	ADD	ARA003[2],AX		; area plean 1.
	ADD	ARA003[4],AX		; area plean 2.
	ADD	ARA003[6],AX		; area plean 3.

					; 仮想ＶＲＡＭプレーン４（パーツ＃０）
	ADD	ARA004[0],AX		; area plean 0.			200
	ADD	ARA004[2],AX		; area plean 1.
	ADD	ARA004[4],AX		; area plean 2.
	ADD	ARA004[6],AX		; area plean 3.

					; 仮想ＶＲＡＭプレーン５（パーツ＃１）
	ADD	ARA005[0],AX		; area plean 0.			200
	ADD	ARA005[2],AX		; area plean 1.
	ADD	ARA005[4],AX		; area plean 2.
	ADD	ARA005[6],AX		; area plean 3.

	RET
SEGLOC	ENDP


CODE	ENDS


; ***********************************************
;	セクタバッファ（ＤＭＡバッファ）
;	ＤＭＡバウンダリエラーを避ける為、CMDTBL.ASM へ移動した
; ***********************************************

SEC_BYTE	EQU	1024		; セクタバイト数

DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	SCDATA2				; セクタバッファ
	EVEN
SCDATA2	DB	SEC_BYTE DUP (0)
	DB	0,0

DATA	ENDS


; ***********************************************
;	セグメント・ロケーション
; ***********************************************

DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	SEGDOS			; ＤＯＳインターフェースセグメント
PUBLIC	SEGPAT0			; パーツバッファ＃０セグメント
PUBLIC	SEGPAT1			; パーツバッファ＃１セグメント
PUBLIC	SEGPAT2			; パーツバッファ＃２セグメント
PUBLIC	SEGPAT3			; パーツバッファ＃３セグメント
PUBLIC	SEGPAT4			; パーツバッファ＃４セグメント
PUBLIC	SEGPAT5			; パーツバッファ＃５セグメント
PUBLIC	SEGPAT6			; パーツバッファ＃６セグメント
PUBLIC	SEGPAT7			; パーツバッファ＃７セグメント
PUBLIC	SEGPAT8			; パーツバッファ＃８セグメント
PUBLIC	SEGPAT9			; パーツバッファ＃９セグメント
PUBLIC	SEGWID			; ＷＩＮＤＯＷＳセグメント
PUBLIC	SEGPAT10		; パーツバッファ＃１０セグメント
PUBLIC	SEGPAT11		; パーツバッファ＃１１セグメント
PUBLIC	SEGPAT12		; パーツバッファ＃１２セグメント
PUBLIC	SEGFRE			; フリー領域の先頭セグメント

PUBLIC	ARAVRM			; ＶＲＡＭプレーン
PUBLIC	ARA001			; 仮想ＶＲＡＭプレーン１（ＤＯＳ＋パーツ＃０）
PUBLIC	ARA002			; 仮想ＶＲＡＭプレーン２（パーツ＃０／＃１）
PUBLIC	ARA003			; 仮想ＶＲＡＭプレーン３（ＤＯＳ/200）
PUBLIC	ARA004			; 仮想ＶＲＡＭプレーン４（パーツ＃０/200）
PUBLIC	ARA005			; 仮想ＶＲＡＭプレーン５（パーツ＃１/200）

PUBLIC	SEGTXV			; テキストＶＲＡＭセグメント

		EVEN

ALLOC_SEGMENT	DW	0	; 確保されたセグメント
SEGDOS	DW	00000H		; ＤＯＳインターフェースセグメント
SEGPAT0	DW	01000H		; パーツバッファ＃０セグメント
SEGPAT1	DW	02000H		; パーツバッファ＃１セグメント
SEGPAT2	DW	03000H		; パーツバッファ＃２セグメント（ボタン）10K
SEGPAT3	DW	03280H		; パーツバッファ＃３セグメント（飾り）5K
SEGPAT4	DW	03400H		; パーツバッファ＃４セグメント（パレット）
SEGPAT5	DW  03400H+P_PAT4				; パーツバッファ＃５
SEGPAT6	DW  03400H+P_PAT4+P_PAT5			; パーツバッファ＃６
SEGPAT7	DW  03400H+P_PAT4+P_PAT5+P_PAT6			; パーツバッファ＃７
SEGPAT8	DW  03400H+P_PAT4+P_PAT5+P_PAT6+P_PAT7		; パーツバッファ＃８
SEGPAT9	DW	00000H					; パーツバッファ＃９
SEGWID	DW  03400H+P_PAT4+P_PAT5+P_PAT6+P_PAT7+P_PAT8	; ＷＩＮＤＯＷ１
SEGPAT10 DW 03400H+P_PAT4+P_PAT5+P_PAT6+P_PAT7+P_PAT8+P_WID1; パーツ＃１０
SEGPAT11 DW 00040H		; パーツバッファ＃１１セグメント(ＤＳＫＣＨＧ)
SEGPAT12 DW 02000H		; パーツバッファ＃１２セグメント(#1前半)
SEGFRE	DW  03400H+P_PAT4+P_PAT5+P_PAT6+P_PAT7+P_PAT8+P_WID1+P_PAT10
				; フリー領域の先頭セグメント

SEGTXV	DW	TEXT_VRAM_SEG	; テキストＶＲＡＭセグメント

ARAVRM	LABEL	WORD		; ＶＲＡＭプレーン
	DW	VRAM_SEG_G0	; ＶＲＡＭプレーン０
	DW	VRAM_SEG_G1	; ＶＲＡＭプレーン１
	DW	VRAM_SEG_G2	; ＶＲＡＭプレーン２
	DW	VRAM_SEG_G3	; ＶＲＡＭプレーン３

ARA001	LABEL	WORD		; 仮想ＶＲＡＭプレーン１（ＤＯＳ＋パーツ＃０）
	DW	00000H		; area plean 0.
	DW	00800H		; area plean 1.
	DW	01000H		; area plean 2.
	DW	01800H		; area plean 3.

ARA002	LABEL	WORD		; 仮想ＶＲＡＭプレーン２（パーツ＃０／＃１）
	DW	01000H		; area plean 0.
	DW	01800H		; area plean 1.
	DW	02000H		; area plean 2.
	DW	02800H		; area plean 3.

ARA003	LABEL	WORD		; 仮想ＶＲＡＭプレーン３（ＤＯＳ/200）
	DW	00000H		; area plean 0.
	DW	00400H		; area plean 1.
	DW	00800H		; area plean 2.
	DW	00C00H		; area plean 3.

ARA004	LABEL	WORD		; 仮想ＶＲＡＭプレーン４（パーツ＃０/200）
	DW	01000H		; area plean 0.
	DW	01400H		; area plean 1.
	DW	01800H		; area plean 2.
	DW	01C00H		; area plean 3.

ARA005	LABEL	WORD		; 仮想ＶＲＡＭプレーン５（パーツ＃１/200）
	DW	02000H		; area plean 0.
	DW	02400H		; area plean 1.
	DW	02800H		; area plean 2.
	DW	02C00H		; area plean 3.

DATA	ENDS





; ***********************************************
;	パーツデータバッファ群
;	詳細については'PARTST.ASM'を参照されたい
;	現在はバッファ＃０，バッファ＃１の２バンクのみ
; ***********************************************

DATA	SEGMENT	PUBLIC	'DATA'

;	パーツバッファ＃０

PUBLIC	TOPPAT0			; 先頭オフセット
PUBLIC	ENDPAT0			; 終了オフセット
	EVEN
TOPPAT0	DW	0		; 先頭オフセット
ENDPAT0	DW	65534		; 終了オフセット

;	パーツバッファ＃１

PUBLIC	TOPPAT1			; 先頭オフセット
PUBLIC	ENDPAT1			; 終了オフセット
	EVEN
TOPPAT1	DW	0		; 先頭オフセット
ENDPAT1	DW	65534		; 終了オフセット

;	パーツバッファ＃２

PUBLIC	TOPPAT2			; 先頭オフセット
PUBLIC	ENDPAT2			; 終了オフセット
	EVEN
TOPPAT2	DW	0		; 先頭オフセット
ENDPAT2	DW	2000H+800H	; 終了オフセット

;	パーツバッファ＃３

PUBLIC	TOPPAT3			; 先頭オフセット
PUBLIC	ENDPAT3			; 終了オフセット
	EVEN
TOPPAT3	DW	0		; 先頭オフセット
ENDPAT3	DW	2000H-800H	; 終了オフセット

;	パーツバッファ＃４

PUBLIC	TOPPAT4			; 先頭オフセット
PUBLIC	ENDPAT4			; 終了オフセット
	EVEN
TOPPAT4	DW	0		; 先頭オフセット
ENDPAT4	DW	SZ_PAT4		; 終了オフセット

;	パーツバッファ＃５

PUBLIC	TOPPAT5			; 先頭オフセット
PUBLIC	ENDPAT5			; 終了オフセット
	EVEN
TOPPAT5	DW	0		; 先頭オフセット
ENDPAT5	DW	SZ_PAT5		; 終了オフセット

;	パーツバッファ＃６

PUBLIC	TOPPAT6			; 先頭オフセット
PUBLIC	ENDPAT6			; 終了オフセット
	EVEN
TOPPAT6	DW	0		; 先頭オフセット
ENDPAT6	DW	SZ_PAT6		; 終了オフセット

;	パーツバッファ＃７

PUBLIC	TOPPAT7			; 先頭オフセット
PUBLIC	ENDPAT7			; 終了オフセット
	EVEN
TOPPAT7	DW	0		; 先頭オフセット
ENDPAT7	DW	SZ_PAT7		; 終了オフセット

;	パーツバッファ＃８

PUBLIC	TOPPAT8			; 先頭オフセット
PUBLIC	ENDPAT8			; 終了オフセット
	EVEN
TOPPAT8	DW	0		; 先頭オフセット
ENDPAT8	DW	SZ_PAT8		; 終了オフセット

;	パーツバッファ＃９

PUBLIC	TOPPAT9			; 先頭オフセット
PUBLIC	ENDPAT9			; 終了オフセット
	EVEN
TOPPAT9	DW	0		; 先頭オフセット
ENDPAT9	DW	20H		; 終了オフセット

;	パーツバッファ＃１０

PUBLIC	TOPPAT10		; 先頭オフセット
PUBLIC	ENDPAT10		; 終了オフセット
	EVEN
TOPPAT10 DW	0		; 先頭オフセット
ENDPAT10 DW	SZ_PAT10	; 終了オフセット

;	パーツバッファ＃１１

PUBLIC	TOPPAT11		; 先頭オフセット
PUBLIC	ENDPAT11		; 終了オフセット
	EVEN
TOPPAT11 DW	0		; 先頭オフセット
ENDPAT11 DW	65534-0400H	; 終了オフセット


;	パーツバッファ＃１２

PUBLIC	TOPPAT12		; 先頭オフセット
PUBLIC	ENDPAT12		; 終了オフセット
	EVEN
TOPPAT12 DW	0		; 先頭オフセット
ENDPAT12 DW	31000		; 終了オフセット

DATA	ENDS



; ***********************************************
;	ＶＲＡＭアクセス用引数
; ***********************************************

DATA	SEGMENT	PUBLIC	'DATA'

;	SSGRx	: PARTST etc..

PUBLIC	SSGR0			; visual data segment plean 0
PUBLIC	SSGR1			; visual data segment plean 1
PUBLIC	SSGR2			; visual data segment plean 2
PUBLIC	SSGR3			; visual data segment plean 3

;	SSDESx	: used = ADVMOV.ASM/HVLINE.ASM/TALKER.ASM
;				/WIDMTRX.ASM/WIDSLCT.ASM

PUBLIC	SSDEST			; visual data segment plean.
PUBLIC	SSDES0			; visual data segment plean 0
PUBLIC	SSDES1			; visual data segment plean 1
PUBLIC	SSDES2			; visual data segment plean 2
PUBLIC	SSDES3			; visual data segment plean 3

;	SSSOUx	: used = ADVMOV.ASM/TALKER.ASM

PUBLIC	SSSOUR			; visual data segment plean.
PUBLIC	SSSOU0			; visual data segment plean 0
PUBLIC	SSSOU1			; visual data segment plean 1
PUBLIC	SSSOU2			; visual data segment plean 2
PUBLIC	SSSOU3			; visual data segment plean 3

;	SSEFCx	: used = EFECT2.ASM

PUBLIC	SSEFCT			; visual data segment plean.
PUBLIC	SSEFC0			; visual data segment plean 0
PUBLIC	SSEFC1			; visual data segment plean 1
PUBLIC	SSEFC2			; visual data segment plean 2
PUBLIC	SSEFC3			; visual data segment plean 3

PUBLIC	VX1			; point x1.
PUBLIC	VY1			; point y1.
PUBLIC	VX2			; point x2.
PUBLIC	VY2			; point y2.
PUBLIC	VX3			; point x3.
PUBLIC	VY3			; point y3.
PUBLIC	ADRS			; address.
PUBLIC	NUM			; number.
PUBLIC	VCOL			; color.

PUBLIC	VRX			; x point.
PUBLIC	VRY			; y point.

PUBLIC	VRLENX			; x length.
PUBLIC	VRLENY			; y length.

PUBLIC	BPOINT			; data buffer point.
PUBLIC	BPNTOF			; データバッファポインタ
PUBLIC	BPNTSG			; データバッファセグメント
PUBLIC	BCNTMX			; データ最大長さ
PUBLIC	BCOUNT			; データ長さ

PUBLIC	PLSMDE			; 圧縮モード(0:通常,1:縦方向)
PUBLIC	BMSKCL			; マスキングカラー
PUBLIC	BORRCL			; ＯＲカラー
PUBLIC	PRSSKP			; パーツＰＵＴのスキッププレーン

	EVEN
SSGR0	DW	VRAM_SEG_G0	; visual data segment plean 0
SSGR1	DW	VRAM_SEG_G1	; visual data segment plean 1
SSGR2	DW	VRAM_SEG_G2	; visual data segment plean 2
SSGR3	DW	VRAM_SEG_G3	; visual data segment plean 3

SSDEST	DW	VRAM_SEG_G0	; visual data segment plean.
SSDES0	DW	VRAM_SEG_G0	; visual data segment plean 0
SSDES1	DW	VRAM_SEG_G1	; visual data segment plean 1
SSDES2	DW	VRAM_SEG_G2	; visual data segment plean 2
SSDES3	DW	VRAM_SEG_G3	; visual data segment plean 3

SSSOUR	DW	VRAM_SEG_G0	; visual data segment plean.
SSSOU0	DW	VRAM_SEG_G0	; visual data segment plean 0
SSSOU1	DW	VRAM_SEG_G1	; visual data segment plean 1
SSSOU2	DW	VRAM_SEG_G2	; visual data segment plean 2
SSSOU3	DW	VRAM_SEG_G3	; visual data segment plean 3

SSEFCT	DW	VRAM_SEG_G0	; visual data segment plean.
SSEFC0	DW	VRAM_SEG_G0	; visual data segment plean 0
SSEFC1	DW	VRAM_SEG_G1	; visual data segment plean 1
SSEFC2	DW	VRAM_SEG_G2	; visual data segment plean 2
SSEFC3	DW	VRAM_SEG_G3	; visual data segment plean 3

VX1	DW	0		; point x1.
VY1	DW	0		; point y1.
VX2	DW	0		; point x2.
VY2	DW	0		; point y2.
VX3	DW	0		; point x3.
VY3	DW	0		; point y3.
ADRS	DW	0		; address.
NUM	DW	0		; number.
VCOL	DW	0		; color.

VRX	DW	0		; x point.
VRY	DW	0		; y point.

VRLENX	DW	0		; x length.
VRLENY	DW	0		; y length.

BPOINT	DW	0		; data buffer point.
BPNTOF	DW	0		; データバッファポインタ
BPNTSG	DW	0		; データバッファセグメント
BCNTMX	DW	0		; データ最大長さ
BCOUNT	DW	0		; データ長さ

PLSMDE	DW	0		; 圧縮モード(0:通常,1:縦方向)

BMSKCL	DW	1111B		; マスキングカラー
				; (bit3:plean3,bit2:plean2,bit1:1,bit0:0)
BORRCL	DW	1111B		; ＯＲカラー
				; (bit3:plean3,bit2:plean2,bit1:1,bit0:0)
PRSSKP	DW	0000B		; パーツＰＵＴのスキッププレーン
				; (bit3:plean3,bit2:plean2,bit1:1,bit0:0)

DATA	ENDS





; ***********************************************
;	ＷＩＮＤＯＷ関係
; ***********************************************

DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	WDXX			; WINDOWS/point x.
PUBLIC	WDYY			; WINDOWS/point y.
PUBLIC	WDX1			; WINDOWS/point x1.
PUBLIC	WDY1			; WINDOWS/point y1.
PUBLIC	WDX2			; WINDOWS/point x2.
PUBLIC	WDY2			; WINDOWS/point y2.
PUBLIC	WDHNO			; WINDOWS/ヘッダー番号
PUBLIC	WDGNO			; WINDOWS/横グラフ番号
PUBLIC	WDVNO			; WINDOWS/内容表示番号
PUBLIC	WDSTR			; WINDOWS/表示パラメータ名
PUBLIC	WDVAL			; WINDOWS/表示値
PUBLIC	WDBLNC			; WINDOWS/表示バランス値
PUBLIC	WDNAME			; WINDOWS/表示名前
PUBLIC	WDTIME			; WINDOWS/表示時間値
PUBLIC	WDINO			; WINDOWS/アイテムオフセット
PUBLIC	WDILIST			; WINDOWS/スタイルリストオフセット
PUBLIC	WDP_VAL			; WINDOWS/内容表示値
PUBLIC	WDP_UNIT		; WINDOWS/内容表示単位系
PUBLIC	WD_NONE_CHR		; WINDOWS/無効キャラクタ
PUBLIC	WDTXTSEG		; WINDOWS/表示文字列セグメント
PUBLIC	WDTXTADR		; WINDOWS/表示文字列アドレス
PUBLIC	WDBTNNUM		; WINDOWS/選択ボタン番号
PUBLIC	WDBTNPUSH		; WINDOWS/ボタン押した
PUBLIC	WDMSX			; WINDOWS/マウスＸ
PUBLIC	WDMSY			; WINDOWS/マウスＹ
PUBLIC	WDMSL			; WINDOWS/マウス左ボタン
PUBLIC	WDMSR			; WINDOWS/マウス右ボタン
PUBLIC	WDPCLM			; WINDOWS/順序
PUBLIC	WDPLIN			; WINDOWS/行

PUBLIC	W_COL1			; WINDOWS/カラー・ハイライト
PUBLIC	W_COL2			; WINDOWS/カラー・明るい灰
PUBLIC	W_COL3			; WINDOWS/カラー・暗い灰
PUBLIC	W_COL4			; WINDOWS/カラー・黒
PUBLIC	W_COL5			; WINDOWS/カラー・暗い色

PUBLIC	ADV_INI_X		; アドベンチャー・台詞左上Ｘ
PUBLIC	ADV_INI_Y		; アドベンチャー・台詞左上Ｙ
PUBLIC	ADV_END_X		; アドベンチャー・台詞右下Ｘ
PUBLIC	ADV_END_Y		; アドベンチャー・台詞右下Ｙ
PUBLIC	ADV_SIZE_X		; アドベンチャー・台詞サイズＸ
PUBLIC	ADV_SIZE_Y		; アドベンチャー・台詞サイズＹ

PUBLIC	ADV_BTN_XX		; ボタンＸ座標
PUBLIC	ADV_BTN_YY		; ボタンＹ座標

PUBLIC	ATMSEG			; WINDOWS/テキストバッファセグメント
PUBLIC	ATMTBL			; WINDOWS/表示単語アドレス
PUBLIC	ATMTLN			; WINDOWS/表示単語長さ
PUBLIC	ATMVAL			; WINDOWS/表示単語の数値
PUBLIC	ATMMAX			; WINDOWS/表示単語の数
PUBLIC	ATMDIM	 		; WINDOWS/表示単語のテーブルサイズ

WDXX		DW	0	; WINDOWS/point x.
WDYY		DW	0	; WINDOWS/point y.
WDX1		DW	0	; WINDOWS/point x1.
WDY1		DW	0	; WINDOWS/point y1.
WDX2		DW	0	; WINDOWS/point x2.
WDY2		DW	0	; WINDOWS/point y2.
WDHNO		DW	0	; WINDOWS/ヘッダー番号
WDGNO		DW	0	; WINDOWS/横グラフ番号
WDVNO		DW	0	; WINDOWS/内容表示番号
WDSTR		DW	0	; WINDOWS/表示パラメータ名
WDVAL		DW	0	; WINDOWS/表示値
WDBLNC		DW	0	; WINDOWS/表示バランス値
WDNAME		DW	0	; WINDOWS/表示名前
WDTIME		DW	0	; WINDOWS/表示時間値
WDINO		DW	0	; WINDOWS/アイテムオフセット
WDILIST		DW	0	; WINDOWS/スタイルリストオフセット
WDP_VAL		DW	0	; WINDOWS/内容表示値
WDP_UNIT	DW	0	; WINDOWS/内容表示単位系
WD_NONE_CHR	DB	"－"	; WINDOWS/無効キャラクタ
WDTXTSEG	DW	0	; WINDOWS/表示文字列セグメント
WDTXTADR	DW	0	; WINDOWS/表示文字列アドレス
WDBTNNUM	DW	0	; WINDOWS/選択ボタン番号
WDBTNPUSH	DW	0	; WINDOWS/ボタン押した
WDMSX		DW	0	; WINDOWS/マウスＸ
WDMSY		DW	0	; WINDOWS/マウスＹ
WDMSL		DW	0	; WINDOWS/マウス左ボタン(1:OFF / 0:ON)
WDMSR		DW	0	; WINDOWS/マウス右ボタン(1:OFF / 0:ON)
WDPCLM		DW	0	; WINDOWS/順序
WDPLIN		DW	0	; WINDOWS/行

W_COL1		DW	15	; WINDOWS/カラー・ハイライト
W_COL2		DW	8	; WINDOWS/カラー・明るい灰
W_COL3		DW	2	; WINDOWS/カラー・暗い灰
W_COL4		DW	0	; WINDOWS/カラー・黒
W_COL5		DW	2	; WINDOWS/カラー・暗い色

ADV_INI_X	DW	53		; アドベンチャー・台詞左上Ｘ
ADV_INI_Y	DW	140		; アドベンチャー・台詞左上Ｙ
ADV_END_X	DW	53+26		; アドベンチャー・台詞右下Ｘ
ADV_END_Y	DW	140+112		; アドベンチャー・台詞右下Ｙ
ADV_SIZE_X	DW	26 		; アドベンチャー・台詞サイズＸ
ADV_SIZE_Y	DW	16*7		; アドベンチャー・台詞サイズＹ

ADV_BTN_XX	DW	43+12+1		; ボタンＸ座標
ADV_BTN_YY	DW	268 ;296-9	; ボタンＹ座標

ATMSEG		DW	0			; WINDOWS/ﾃｷｽﾄﾊﾞｯﾌｧｾｸﾞﾒﾝﾄ
ATMTBL		DW	ATMTABLE_MAX DUP (0)	; WINDOWS/表示単語アドレス
ATMTLN		DW	ATMTABLE_MAX DUP (0)	; WINDOWS/表示単語長さ
ATMVAL		DW	ATMTABLE_MAX DUP (0)	; WINDOWS/表示単語の数値
ATMMAX  	DW	0			; WINDOWS/表示単語の数
ATMDIM	 	DW	ATMTABLE_MAX		; WINDOWS/表示単語のﾃｰﾌﾞﾙｻｲｽﾞ

DATA	ENDS





; ***********************************************
;	その他のバッファ群
; ***********************************************

DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	DEBFLG			; デバッグフラグ(0=通常, bit on=DEBUG FLAG)
PUBLIC	DEVFLG			; 入力デバイス(1=バスマウス,2=キーボード)
PUBLIC	EXITSS			; 強制終了(1=終了)

PUBLIC	R_KOUMKU		; 項目
PUBLIC	R_NAISTR		; 内容文字列
PUBLIC	R_NAIYOU		; 内容値
PUBLIC	R_NYUKIN		; 入金
PUBLIC	R_SYUTSU		; 出金
PUBLIC	R_NISSU			; 日数
PUBLIC	R_HEIJITSU		; 平日

PUBLIC	KETTEI			; 決定フラグ

PUBLIC	STR_BUFF		; 文字列バッファ
PUBLIC	STR_VAL_BUFF		; 表示値文字列バッファ

PUBLIC	MSG_TKR_CLS		; テキストウインドウ・クリア用

PUBLIC	NAME_FIRST		; ファーストネーム
PUBLIC	NAME_SECOND		; ファミリーネーム
PUBLIC	LEN_NAME_FIRST		; ファーストネーム長さ
PUBLIC	LEN_NAME_SECOND		; ファミリーネーム長さ


DEBFLG		DW	1	; デバッグフラグ(0=通常, bit on=DEBUG FLAG)
DEVFLG		DW	0	; 入力デバイス(1=バスマウス,2=キーボード)
EXITSS		DW	0	; 強制終了(1=終了)

R_KOUMKU	DW	0	; 項目
R_NAISTR	DW	0	; 内容文字列
R_NAIYOU	DW	0	; 内容値
R_NYUKIN	DW	0	; 入金
R_SYUTSU	DW	0	; 出金
R_NISSU		DW	0	; 日数
R_HEIJITSU	DW	0	; 平日

KETTEI		DW	0	; 決定フラグ

STR_VAL_BUFF	DB	STR_VAL_LEN2 DUP (' ')	; 表示値文字列バッファ
		DB	0,0			;
STR_BUFF	DB	STRING_LEN DUP (' ')	; 文字列バッファ
		DB	0,0			;

MSG_TKR_CLS	DB	"@@@",0		; テキストウインドウ・クリア用

NAME_FIRST	DB	"あいうえおかきく",0,0	; ファーストネーム
NAME_SECOND	DB	"ラリルレロワヲン",0,0	; ファミリーネーム
LEN_NAME_FIRST	DW	16		; ファーストネーム長さ
LEN_NAME_SECOND	DW	16		; ファミリーネーム長さ

DATA	ENDS

	END
;
;	end of "CMDTBL.ASM"
;
