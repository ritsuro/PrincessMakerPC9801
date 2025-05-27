; "PICTUER.INC" PC_9801UV11 make by R.H 1990/12/12
;
;	「子育て」
;
;	絵の表示／デモ・ＩＮＣＬＵＤＥ
;
;PUBLIC	P_RED			; 赤
;PUBLIC	P_WHITE			; 白
;
;PUBLIC	PT_C1_LD		; Ｃ１のロード
;PUBLIC	PT_C1P			; Ｃ１
;
;PUBLIC	PT_C2_LD		; Ｃ２のロード
;PUBLIC	PT_C2P			; Ｃ２
;
;PUBLIC	PT_C3_LD		; Ｃ３のロード
;PUBLIC	PT_C3P			; Ｃ３
;
;PUBLIC	PT_C4_LD		; Ｃ４のロード
;PUBLIC	PT_C4P			; Ｃ４
;
;PUBLIC	PT_C5_LD		; Ｃ５のロード
;PUBLIC	PT_C5P			; Ｃ５
;
;;*;PUBLIC PT_C12P		; Ｃ１２
;
;PUBLIC	PT_OPEN_ALL_LD		; オープニング全ロード
;
;PUBLIC	PT_OPEN_NAME		; 名前入力フレーム
;PUBLIC	PT_OPEN_BORTH		; 誕生日フレーム
;PUBLIC	PT_OPEN_CUTF		; オープニングフレーム
;
;PUBLIC	PT_END_TXT_LD		; エンディング・テキスト・ロード
;
;
;
; (C) 1990 ritsurou hashimoto.

OP_OFS_XX	EQU	12		; オープニング位置Ｘ
OP_OFS_YY	EQU	80-30		; オープニング位置Ｙ

;*;TIME_SET	MACRO	TTT
;*;	MOV	AX,TTT		; wait timer count.
;*;	EXTRN	TMVST3:NEAR	; V-SYNC timer3 set.
;*;	CALL	TMVST3		; V-SYNC timer3 set.
;*;	ENDM
;*;
;*;TIME_WAIT	MACRO
;*;	LOCAL	L1
;*;L1:
;*;	EXTRN	TMVCK3:NEAR	; V-SYNC timer3 check.
;*;	CALL	TMVCK3		; V-SYNC timer3 check.
;*;	CMP	AX,0		; 0=timer now, 1=timer end.
;*;	JE	L1		;
;*;	ENDM

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM



R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

; ***********************************************
;	パーツファイルロード
; ***********************************************

FILE_CALL	WOPENBOR		; 誕生日フレーム
FILE_CALL	XOPENBOR		;
FILE_CALL	WOPENNAM		; 名前フレーム
FILE_CALL	XOPENNAM		;
FILE_CALL	WOPENCUT		; オープニングフレーム
FILE_CALL	XOPENCUT		;

FILE_CALL	TITLE1			; Ｃ０　ＴＩＴＬＥ
FILE_CALL	TITLE2			; Ｃ０　ＴＩＴＬＥ
FILE_CALL	C1			; Ｃ１
FILE_CALL	C2			; Ｃ２
FILE_CALL	C3			; Ｃ３
FILE_CALL	C4			; Ｃ４
FILE_CALL	C5A1			; Ｃ５
FILE_CALL	C5A2			; Ｃ５
FILE_CALL	C6A1			; Ｃ６
FILE_CALL	C6A2			; Ｃ６
FILE_CALL	C12			; Ｃ１２


; ***********************************************
;	デモ
; ***********************************************


;*;;	初期ロード
;*;
;*;PT_INI_LD	PROC	NEAR
;*;	PAT_BANK	10
;*;	CALL	FILE_INIT		; ロード初期化
;*;	CALL	TITLE1			;0 Ｃ０　ＴＩＴＬＥ
;*;	CALL	TITLE2			;1 Ｃ０　ＴＩＴＬＥ
;*;	RET
;*;PT_INI_LD	ENDP
;*;
;*;
;*;;	Ｃ０（ＧＩＮＡＸ）のロード
;*;
;*;PT_C0_LD	PROC	NEAR
;*;	RET
;*;PT_C0_LD	ENDP
;*;
;*;
;*;;	Ｃ０（ＧＩＮＡＸ）
;*;
;*;PT_C0_ST	PROC	NEAR
;*;	PAT_BANK	10
;*;	PLSMD	1
;*;	PAT_PUT	0,0,0		; put.
;*;	PAT_PUT	1,0,0		; put.
;*;	RET
;*;PT_C0_ST	ENDP


;	Ｃ１のロード

FUNC	PPT_C1_LD,PT_C1_LD
	PAT_BANK	0
	CALL	FILE_INIT		; ロード初期化
	CALL	C1			; Ｃ１
	RET
FEND	PPT_C1_LD

;	Ｃ１

FUNC	PPT_C1P,PT_C1P
	PAT_BANK	0
	PLSMD	1
	MOV	AX,1			; 0=通常,1=パターンＰＵＴオーバラップ
	CALLC	PATEFC			; パーツＰＵＴエフェクト
	PAT_PUT	0,OP_OFS_XX,OP_OFS_YY		; put.
	MOV	AX,0			; 0=通常,1=パターンＰＵＴオーバラップ
	CALLC	PATEFC			; パーツＰＵＴエフェクト
	RET
FEND	PPT_C1P


;	Ｃ２のロード

FUNC	PPT_C2_LD,PT_C2_LD
	PAT_BANK	0
	CALL	FILE_INIT		; ロード初期化
	CALL	C2			; Ｃ２
	RET
FEND	PPT_C2_LD

;	Ｃ２

FUNC	PPT_C2P,PT_C2P
	PAT_BANK	0
	PLSMD	1
	MOV	AX,1			; 0=通常,1=パターンＰＵＴオーバラップ
	CALLC	PATEFC			; パーツＰＵＴエフェクト
	PAT_PUT	0,OP_OFS_XX,OP_OFS_YY	; put.
	MOV	AX,0			; 0=通常,1=パターンＰＵＴオーバラップ
	CALLC	PATEFC			; パーツＰＵＴエフェクト
	RET
FEND	PPT_C2P


;	Ｃ３のロード

FUNC	PPT_C3_LD,PT_C3_LD
	PAT_BANK	0
	CALL	FILE_INIT		; ロード初期化
	CALL	C3			; Ｃ３
	RET
FEND	PPT_C3_LD

;	Ｃ３

FUNC	PPT_C3P,PT_C3P
	PAT_BANK	0
	PLSMD	1
	PAT_PUT	0,OP_OFS_XX,OP_OFS_YY		; put.
	RET
FEND	PPT_C3P


;	Ｃ４のロード

FUNC	PPT_C4_LD,PT_C4_LD
	PAT_BANK	0
	CALL	FILE_INIT		; ロード初期化
	CALL	C4			; Ｃ４
	RET
FEND	PPT_C4_LD

;	Ｃ４

FUNC	PPT_C4P,PT_C4P
	PAT_BANK	0
	PLSMD	1
	PAT_PUT	0,OP_OFS_XX,OP_OFS_YY		; put.
	RET
FEND	PPT_C4P


;	Ｃ５のロード

FUNC	PPT_C5_LD,PT_C5_LD
	PAT_BANK	0
	CALL	FILE_INIT	; ロード初期化
	CALL	C5A1
	PAT_BANK	1
	CALL	FILE_INIT	; ロード初期化
	CALL	C5A2
	RET
FEND	PPT_C5_LD


;	Ｃ５

FUNC	PPT_C5P,PT_C5P
	PAT_BANK	0
	PLSMD	1
	PAT_PUT	0,0,0		; put.
	PAT_BANK	1
	PAT_PUT	0,0,0		; put.
	RET
FEND	PPT_C5P


;*;;	Ｃ１２
;*;
;*;PT_C12P	PROC	NEAR
;*;	PAT_BANK	10
;*;	PLSMD	1
;*;	PAT_PUT	4,0,0			; put.
;*;	RET
;*;PT_C12P	ENDP


;	オープニング全ロード

FUNC	PPT_OPEN_ALL_LD,PT_OPEN_ALL_LD
	PAT_BANK	1		; ＢＡＮＫ＃１
	CALL	FILE_INIT		; ロード初期化
	CALL	WOPENNAM		; 0=名前フレーム
	CALL	XOPENNAM		;
	CALL	WOPENBOR		; 2=誕生日フレーム
	CALL	XOPENBOR		;
	CALL	WOPENCUT		; 4=オープニングフレーム
	CALL	XOPENCUT		;
	RET
FEND	PPT_OPEN_ALL_LD


;	名前入力フレーム

FUNC	PPT_OPEN_NAME,PT_OPEN_NAME
	MOV	NUM1,0			; 0=名前フレーム
	CALL	FULL_FREAM_PUTS		; 全画面ＰＵＴ
	RET
FEND	PPT_OPEN_NAME


;	誕生日フレーム

FUNC	PPT_OPEN_BORTH,PT_OPEN_BORTH
	MOV	NUM1,2			; 2=誕生日フレーム
	CALL	FULL_FREAM_PUTS		; 全画面ＰＵＴ
	RET
FEND	PPT_OPEN_BORTH


;	オープニングフレーム

FUNC	PPT_OPEN_CUTF,PT_OPEN_CUTF
	MOV	NUM1,4			; 4=オープニングフレーム
	CALL	FULL_FREAM_PUTS		; 全画面ＰＵＴ
	RET
FEND	PPT_OPEN_CUTF


;	エンディング・テキスト・ロード
;	SEGPAT1:TOPPAT1(パーツバッファ＃１)へロード

FUNC	PPT_END_TXT_LD,PT_END_TXT_LD
	MOV	SI,OFFSET ENDING_TEXT_FL ; エンディング・テキストのファイル名
	MOV	DX,SEGPAT1		; パーツバッファ＃１セグメント
	MOV	DI,TOPPAT1		; 先頭オフセット
	ADD	DI,31000		; (パーツバッファ＃１後半）
	MOV	CX,33000		; data length.３３０００バイト
	CALLC	DSKLD			; load data.
	RET
FEND	PPT_END_TXT_LD


;	全画面ＰＵＴ
;	-I- NUM1 : 先頭パターン番号

FULL_FREAM_PUTS	PROC	NEAR
	PAT_BANK	1		; ＢＡＮＫ＃１
	PLSMD	1			;

	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	MOVX	NUM,NUM1		; 先頭パターン番号
	CALL	PATTAN_PUT		; パターンＰＵＴ

	MOV	XX1,0			; ＰＵＴオフセット　Ｘ座標
	MOV	YY1,0			; ＰＵＴオフセット　Ｙ座標
	MOVX	NUM,NUM1		; 先頭パターン番号
	INC	NUM			;
	CALL	PATTAN_PUT		; パターンＰＵＴ

	RET
FULL_FREAM_PUTS	ENDP


; ***********************************************
;	パレットセット
; ***********************************************

;	赤

FUNC	PP_RED,P_RED
	MOV	CLRVEW,0		; color.
	MOV	CLRCNS,100		; contrast.
	MOV	CLRBRI,100		; brightness.
	CALL	P_PALET			; パレット
	RET
FEND	PP_RED


;	白

FUNC	PP_WHITE,P_WHITE
	MOV	CLRVEW,0		; color.
	MOV	CLRCNS,0		; contrast.
	MOV	CLRBRI,100		; brightness.
	CALL	P_PALET			; パレット
	RET
FEND	PP_WHITE


;	パレット
;	-I- CLRVEW : color.
;	    CLRCNS : contrast.
;	    CLRBRI : brightness.

P_PALET	PROC	NEAR
	MOV	CLRCDE,1		; color code.
	MOV	CX,15			;
P_PALET_LOOP:
	PUSH	CX			;
	CALLC	SETCLR			; color set.
	INC	CLRCDE			; color code.
	POP	CX			;
	LOOP	P_PALET_LOOP		;
	RET
P_PALET	ENDP


; ***********************************************
;	ＴＥＸＴＭＡＳＫ横ライン消し
; ***********************************************

TXT_MASK_YL	PROC	NEAR
	MOV	VX1,638			;
	MOV	VY1,0			;
	MOV	VY2,399			;
	MOV	VCOL,0			;
	MOV	CX,2			; 太さ
	CALLC	DLINEV			; 垂直ライン描画
	RET
TXT_MASK_YL	ENDP


R_SEG2	ENDS

DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SEGPAT1:WORD		; パーツバッファ＃１セグメント
EXTRN	TOPPAT1:WORD		; 先頭オフセット
EXTRN	ENDPAT1:WORD		; 終了オフセット

NUM1	DW	0
NUM2	DW	0
XXX1	DW	0
YYY1	DW	0
XXX2	DW	0
YYY2	DW	0
XXX3	DW	0
YYY3	DW	0

ENDING_TEXT_FL	DB	"OCHITEXT.TXT",0 ; エンディング・テキストのファイル名

DATA	ENDS

	END
;
;	end of "PICTUER.INC"
;
