; "DATAROLL.ASM" PC-9801UV11 make by R.H 1991/05/08
;
;
;	「子育て」
;
;	データ・ロール作成
;
;	DATAROLL			; データ・ロール作成
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	KOSO3.INC

LINE_WIDTH	EQU	36		; バッファ最大長さ
MAX_V_LEN	EQU	24		; 最大パラメータ文字長さ

; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチン
; ****************************************************

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
SUBLL	PROC	FAR
	ENDM

; ****************************************************
;	ＣＯＤＥ　から　Ｒ＿ＳＥＧ２　を参照するルーチンの終り
; ****************************************************

FEND	MACRO	SUBLL

SUBLL	ENDP
	ENDM

; ****************************************************
;	Ｒ＿ＳＥＧ２セグメントからＣＯＤＥセグメントへ
; ****************************************************

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

; ****************************************************
;	ＣＯＤＥセグメントからＲ＿ＳＥＧ２セグメントへ
; ****************************************************

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
L1:
	ENDM

; ****************************************************
;	Ｒ＿ＳＥＧ２　から　ＣＯＤＥ　へ　ＣＡＬＬ
; ****************************************************

CALLC	MACRO	SUB1
	LOCAL	L1,L2
;*;	JMP	L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L2	PROC	FAR
	EXTRN	SUB1:NEAR
	CALL	SUB1
	RET
L2	ENDP
CODE	ENDS
	ASSUME	CS:R_SEG2,DS:DATA
L1:	CALL	L2	
	ENDM


TTIME_SET	MACRO	TTT
	MOV	AX,TTT		; wait timer count.
	CALL	TTMVST2		; V-SYNC timer2 set.
	ENDM


TTIME_WAIT	MACRO
	LOCAL	L1,L2
L1:
	TEST	BYTE PTR KYTBLS[0],1B		; key code「ESC」
	JNZ	L2		; skip
	CALL	TTMVCK2		; V-SYNC timer2 check.
	CMP	AX,0		; 0=timer now, 1=timer end.
	JE	L1		;
L2:
	ENDM


MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM

JMPGE	MACRO	LBL
	LOCAL	L1
	JL	L1
	JMP	LBL
L1:
	ENDM

MOVXBW	MACRO	DEST,SOUR_BYTE
	MOV	AH,0
	MOV	AL,SOUR_BYTE
	MOV	DEST,AX
	ENDM

R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA

; ****************************************************
;	データ・ロール作成
;	-I- ES : テキストセグメント
;	    BX : テキストバッファ・アドレス
; ****************************************************

FUNC	SSTFROLL,DATAROLL
	MOV	SEGTXT,ES		; テキストセグメント
	MOV	TXTTOP,BX		; テキストの先頭
	MOV	SET_POINTER,BX		; 文字列セットポインタ

	CALL	DROLL_MAIN		; データ・ロール・メイン

	MOV	ES,SEGTXT		; テキストセグメント
	MOV	DI,SET_POINTER		; 文字列セットポインタ
	MOV	BYTE PTR ES:[DI],'$'
	RET
FEND	SSTFROLL


; ****************************************************
;	データ・ロール・メイン
; ****************************************************

DROLL_MAIN	PROC	NEAR
	CALL	ROLL_HED		; ヘッダー・ロール
	CALL	ROLL_VAL		; 内容表示データ・ロール
	CALL	ROLL_GRP		; 横グラフデータ・ロール
	RET
DROLL_MAIN	ENDP


; ****************************************************
;	ヘッダー・ロール
; ****************************************************

ROLL_HED	PROC	NEAR
	CALLC	STRZEROC		; 文字列バッファ０クリア

	MOVX	R_SR_CHR_ADRS,WIDMY_GIRL_OF ; 私の娘アドレス
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,STRING_LEN		; string length.
	CALLC	R_SR_GIRL_FULNAMGET	; キャラクタ名+姓ＧＥＴ
	CALL	FULLNAME_PRN		; 姓名・表示

	CALL	BUFF_C_SET		; バッファ・セットアップ

	MOVX	ES,DS			;
	MOV	SI,OFFSET MSG_LEVEL	; "レベル"
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,6			;
	CALLC	STRSET			; 文字列バッファセット

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	CALLC	R_GET_LVL		; レベル
	MOV	DSP_VALUE,DX		; 内容表示 内容値
	MOV	DSP_UNIT,UNIT_NONE	; 内容表示 内容の単位系
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	CALL	VALUE_STR		; 数値の文字列化
	CALL	STR_TO_SET		; 文字列セット

	RET
ROLL_HED	ENDP


; ****************************************************
;	姓名・表示
; ****************************************************

FULLNAME_PRN	PROC	NEAR
	MOVX	ES,DS			; 文字列アドレス
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	STRLENSPZ		; 文字列長さスペースまで

	MOV	DX,LINE_WIDTH		; バッファ最大長さ
	SUB	DX,CX			; 表示単語長さ
	SHR	DX,1			; / 2

	MOV	ES,SEGTXT		; テキストセグメント
	MOV	CX,DX			; loop counter.
	JCXZ	FULLNAME_PRN_LP_E	;
FULLNAME_PRN_LOOP:			;
	MOV	DI,SET_POINTER		; 文字列セットポインタ
	MOV	BYTE PTR ES:[DI],' '	;
	INC	SET_POINTER		; 文字列セットポインタ
	LOOP	FULLNAME_PRN_LOOP	;
FULLNAME_PRN_LP_E:
	CALL	STR_TO_SET		; 文字列セット

	MOV	ES,SEGTXT		; テキストセグメント
	MOV	DI,SET_POINTER		; 文字列セットポインタ
	MOV	BYTE PTR ES:[DI],'/'	;
	MOV	BYTE PTR ES:[DI][1],0DH	;
	MOV	BYTE PTR ES:[DI][2],0AH	;
	ADD	SET_POINTER,3		; 文字列セットポインタ
	RET
FULLNAME_PRN	ENDP


; ****************************************************
;	横グラフデータ・ロール
; ****************************************************

ROLL_GRP	PROC	NEAR
	MOV	NUM_GRP,0		; 横グラフ番号
	MOV	CX,11
ROLL_GRP_LOOP:
	PUSH	CX
	CALL	GRP_ONE_ROLL		; 横グラフデータ・１ロール
	INC	NUM_GRP			; 横グラフ番号
	POP	CX
	LOOP	ROLL_GRP_LOOP
	RET
ROLL_GRP	ENDP


; ****************************************************
;	内容表示データ・ロール
; ****************************************************

ROLL_VAL	PROC	NEAR
	MOV	NUM_VAL,0		; 内容表示番号
	MOV	CX,8
ROLL_VAL_LOOP:
	PUSH	CX
	CALL	VAL_ONE_ROLL		; 内容表示データ・１行
	INC	NUM_VAL			; 内容表示番号
	POP	CX
	LOOP	ROLL_VAL_LOOP
	RET
ROLL_VAL	ENDP


; ****************************************************
;	横グラフデータ・１行
;	-I- NUM_GRP    : 横グラフ番号
; ****************************************************

GRP_ONE_ROLL	PROC	NEAR
	MOV	BX,NUM_GRP		; 横グラフ番号
	CALLC	WIDHBR_DGET		; WINDOWS/横グラフデータＧＥＴ
	MOV	DSP_NAME,SI		; グラフ名前
	MOV	DSP_VALUE,DX		; グラフ数値

	CALL	BUFF_C_SET		; バッファ・セットアップ

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,DSP_NAME		; グラフ名前
	MOV	CX,12			; バッファ最大長さ
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	STRSET			; 文字列バッファセット

	MOV	DSP_TYPE,TYPE_VALUE	; ＶＡＬＵＥ型
	MOV	DSP_UNIT,UNIT_NONE	; 単位系 無し
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	CALL	VALUE_STR		; 数値の文字列化

	CALL	GRP_ONE_PRN		; 横グラフデータ・表示
	RET
GRP_ONE_ROLL	ENDP


; ****************************************************
;	横グラフデータ・表示
; ****************************************************

GRP_ONE_PRN	PROC	NEAR
	CALL	STR_TO_SET		; 文字列セット
	RET
GRP_ONE_PRN	ENDP


; ****************************************************
;	内容表示データ・１行
;	-I- NUM_VAL : 内容表示番号
; ****************************************************

VAL_ONE_ROLL	PROC	NEAR
	MOV	BX,NUM_VAL		; 内容表示番号
	CALLC	WIDVAL_DGET		; WINDOWS/内容表示データＧＥＴ
	MOV	DSP_TORKN,SI		; 内容表示 パラメータ名
	MOV	DSP_TYPE,AX		; 内容表示 内容の型
	MOV	DSP_UNIT,CX		; 内容表示 内容の単位系
	MOV	DSP_VALUE,DX		; 内容表示 内容値

	CALL	BUFF_C_SET		; バッファ・セットアップ

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,DSP_TORKN		; 内容表示 パラメータ名
	MOV	AX,ES:[SI]		;
	CMP	AX,WORD PTR MSG_PROPR	; "プロポ"
	JNE	VAL_ONE_ROLL_3		;

	MOVX	ES,DS			;
	MOV	SI,OFFSET MSG_PROPR	; "プロポーション",0,0
	MOV	CX,14			; バッファ最大長さ
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	STRSET			; 文字列バッファセット
	JMP	VAL_ONE_ROLL_35
VAL_ONE_ROLL_3:
	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,DSP_TORKN		; 内容表示 パラメータ名
	MOV	CX,12			; バッファ最大長さ
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	CALLC	STRSET			; 文字列バッファセット
VAL_ONE_ROLL_35:

	CMPX	DSP_TYPE,TYPE_TIME	; ＴＩＭＥ型
	JE	VAL_ONE_ROLL_UNIT	;
	CMPX	DSP_UNIT,UNIT_NONE	; 単位系 無し
	JNE	VAL_ONE_ROLL_UNIT	;

	MOV	STRADRS,DI		; 文字列アドレス

	MOV	ES,SEGWID		; ＷＩＮＤＯＷＳセグメント
	MOV	SI,DSP_VALUE		; 内容表示 内容値
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	MOV	CX,MAX_V_LEN		; 最大パラメータ文字長さ
	CALLC	STRSETZ			; 文字列バッファセット

	CALL	PARA_VAL_STR_SET	; パラメータ表示値セット

	JMP	VAL_ONE_ROLL_PUT	;

VAL_ONE_ROLL_UNIT:
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	CALL	VALUE_STR		; 数値の文字列化

VAL_ONE_ROLL_PUT:
	CALL	VAL_ONE_PRN		; 横グラフデータ・表示
	RET
VAL_ONE_ROLL	ENDP


; ****************************************************
;	内容表示データ・表示
;	-I- STR_BUFF : 文字列バッファ
; ****************************************************

VAL_ONE_PRN	PROC	NEAR
	CALL	STR_TO_SET		; 文字列セット
	RET
VAL_ONE_PRN	ENDP


; ****************************************************
;	文字列セット
;	-I-   STR_BUFF    : 文字列バッファ
;	-I/O- SET_POINTER : 文字列セットポインタ
; ****************************************************

STR_TO_SET	PROC	NEAR
	MOV	ES,SEGTXT		; テキストセグメント
	MOV	SI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	DI,SET_POINTER		; 文字列セットポインタ
	MOV	AL,' '			; space.
	STOSB				;
	STOSB				;
	STOSB				;
	STOSB				;
	MOV	CX,4000			;
STR_TO_SET_LOOP:			;
	LODSB				; get 1 char.
	STOSB				; put 1 char.
	CMP	AL,0			; end of string.
	JE	STR_TO_SET_EXIT		;
	LOOP	STR_TO_SET_LOOP		;
STR_TO_SET_EXIT:
	MOV	AL,0			;
	STOSB				; put 1 char.
	MOV	SET_POINTER,DI		; 文字列セットポインタ
	RET
STR_TO_SET	ENDP



; ****************************************************
;	数値の文字列化
;	-I- DSP_VALUE : 内容表示 内容値
;	    DSP_TYPE  : 内容表示 内容の型
;	    DSP_UNIT  : 内容表示単位系
;	    DS:[DI]   : 文字列バッファ
; ****************************************************

VALUE_STR	PROC	NEAR
	MOV	STRADRS,DI		; 文字列アドレス

	MOV	AX,DSP_TYPE		; 内容表示 内容の型
	CMP	AX,TYPE_TIME		; ＴＩＭＥ型
	JE	VALUE_STR_UNIT		;

	CMP	DSP_UNIT,UNIT_NONE	; 内容表示 内容の単位系
	JE	VALUE_STR_POINT		;

;*;	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;	MOVX	WDP_VAL,DSP_VALUE	; 内容表示 内容値
;*;	MOVX	WDP_UNIT,DSP_UNIT	; 内容表示単位系
;*;	CALLC	WID_UNIT		; WINDOWS/単位別文字列化

VALUE_STR_UNIT:
	CALL	S_UNIT_SET		; 単位系文字処理

	CALL	PARA_VAL_STR_SET	; パラメータ表示値セット

	RET

VALUE_STR_POINT:
	MOV	DX,DSP_VALUE		; 内容表示 内容値
	CALLC	DECSTR			; dec -> string.
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STR_N_HNZN		; 文字列半角を全角
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRSPL			; space pless. "  123" - > "123  "

;*;	MOVX	ES,DS			;
;*;	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
;*;	MOV	CX,MAX_V_LEN		; 最大パラメータ文字長さ
;*;	CALLC	STRSETZ			; 文字列バッファセット

	CALL	PARA_VAL_STR_SET	; パラメータ表示値セット

	RET
VALUE_STR	ENDP


; ****************************************************
;	単位系文字処理
;	-I- DSP_VALUE    : 内容表示内容値
;	    DSP_TYPE     : 内容表示 内容の型
;	    DSP_UNIT     : 内容表示単位系
;	-O- STR_VAL_BUFF : 表示値文字列バッファ
; ****************************************************

S_UNIT_SET	PROC	NEAR
	MOV	AX,DSP_TYPE		; 内容表示 内容の型
	CMP	AX,TYPE_TIME		; ＴＩＭＥ型
	JE	S_UNIT_SET_TIME		;

	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	MOVX	WDP_VAL,DSP_VALUE	; 内容表示 内容値
	MOVX	WDP_UNIT,DSP_UNIT	; 内容表示単位系
	CALLC	WID_UNIT		; WINDOWS/単位別文字列化
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRSPL			; space pless. "  123" - > "123  "


	MOV	AX,WDP_UNIT		; 内容表示単位系
	CMP	AX,UNIT_NONE		; 単位系 無し
	JMPEQ	S_UNIT_SET_EXIT		;
	CMP	AX,UNIT_ARGE		; 単位系 年齢
	JE	S_UNIT_SET_ARGE		;

	CMP	AX,UNIT_CM		; 単位系 ｃｍ
	JE	S_UNIT_SET_CM		;

	CMP	AX,UNIT_KG		; 単位系 ｋｇ
	JE	S_UNIT_SET_KG		;
	JMP	S_UNIT_SET_EXIT		;


					;  0123456789
S_UNIT_SET_TIME:			; "1659/05/04"
	MOV	ES,SEGWID		;
	MOV	SI,DSP_VALUE		; 内容表示内容値
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	MOV	CX,MAX_V_LEN		; 最大パラメータ文字長さ
	CALLC	STRSETZ			; 文字列バッファセット
	MOV	STR_VAL_BUFF[14],0	; end of string.
	MOVX	<WORD PTR STR_VAL_BUFF[12]>,<WORD PTR MSG_D>	;"日"
	MOVX	<WORD PTR STR_VAL_BUFF[10]>,<WORD PTR STR_VAL_BUFF[8]>
	MOVX	<WORD PTR STR_VAL_BUFF[8]>,<WORD PTR MSG_M>	;"月"
	MOVX	<WORD PTR STR_VAL_BUFF[6]>,<WORD PTR STR_VAL_BUFF[5]>
	MOVX	<WORD PTR STR_VAL_BUFF[4]>,<WORD PTR MSG_Y>	;"年"
	JMP	S_UNIT_SET_EXIT		;

S_UNIT_SET_ARGE:			; "18"
	MOV	STR_VAL_BUFF[4],0	; end of string.
	MOVX	<WORD PTR STR_VAL_BUFF[2]>,<WORD PTR MSG_AGE>	;"歳"
	JMP	S_UNIT_SET_EXIT		;

S_UNIT_SET_CM:				;
	MOVX	ES,DS			; 文字列アドレス
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRLENSPZ		; 文字列長さスペースまで
	MOV	DI,CX			; 長さ
	MOVX	<WORD PTR DS:STR_VAL_BUFF[DI]>,<WORD PTR MSG_CM> ; "cm"
	MOV	DS:STR_VAL_BUFF[DI][2],0	; end of string.
	JMP	S_UNIT_SET_EXIT

S_UNIT_SET_KG:				;
	MOVX	ES,DS			; 文字列アドレス
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRLENSPZ		; 文字列長さスペースまで
	MOV	DI,CX			; 長さ
	MOVX	<WORD PTR DS:STR_VAL_BUFF[DI]>,<WORD PTR MSG_KG> ; "kg"
	MOV	DS:STR_VAL_BUFF[DI][2],0	; end of string.
	JMP	S_UNIT_SET_EXIT		;

S_UNIT_SET_EXIT:
	RET
S_UNIT_SET	ENDP



; ****************************************************
;	パラメータ表示値セット
;	-I- STR_VAL_BUFF : 表示値文字列
;	    STRADRS      : セット先文字列アドレス
; ****************************************************

PARA_VAL_STR_SET	PROC	NEAR
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRSPL			; space pless. "  123" - > "123  "

	MOVX	ES,DS			; 文字列アドレス
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRLENSPZ		; 文字列長さスペースまで

	MOVX	ES,DS			;
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	MOV	DI,STRADRS		; 文字列アドレス
	ADD	DI,LINE_WIDTH		; バッファ最大長さ
	SUB	DI,CX			; 表示単語長さ
	MOV	CX,MAX_V_LEN		; 最大パラメータ文字長さ
	CALLC	STRSETZ			; 文字列バッファセット

	RET
PARA_VAL_STR_SET	ENDP


; ****************************************************
;	バッファ・セットアップ
;	-O- STR_BUFF : 文字列バッファ
; ****************************************************

BUFF_C_SET	PROC	NEAR
	CALLC	STRZEROC		; 文字列バッファ０クリア
	MOV	DH,MSG_DOT		; "・"
	MOV	DL,MSG_DOT[1]		; "・"
	MOV	DI,OFFSET STR_BUFF	; 文字列バッファ
	MOV	CX,LINE_WIDTH		; バッファ最大長さ
	CALLC	STRFILL			; 文字列バッファＦＩＬＬ
	RET
BUFF_C_SET	ENDP

R_SEG2	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	R_SR_CHR_ADRS:WORD	; 台詞・キャラクタアドレス

SEGTXT		DW	0	; テキストセグメント
TXTTOP		DW	0	; テキストの先頭

SET_POINTER	DW	0	; 文字列セットポインタ

NUM_GRP		DW	0	; 横グラフ番号
NUM_VAL		DW	0	; 内容表示番号

DSP_NAME	DW	0	; グラフ名前
DSP_VALUE	DW	0	; 数値

DSP_TORKN	DW	0	; 内容表示 パラメータ名
DSP_TYPE	DW	0	; 内容表示 内容の型
DSP_UNIT	DW	0	; 内容表示 内容の単位系

STRADRS		DW	0	; 文字列アドレス
MSG_Y		DB	"年"
MSG_M		DB	"月"
MSG_D		DB	"日"
MSG_AGE		DB	"歳"
MSG_KG		DB	"kg"
MSG_CM		DB	"cm"

MSG_DOT		DB	"･･",0,0	; "・"
MSG_LEVEL	DB	"レベル",0,0	; "レベル"
MSG_PROPR	DB	"プロポーション",0,0

DATA	ENDS

	END
;
;	end of "DATAROLL.ASM"
;
