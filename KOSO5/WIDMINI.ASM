; "WIDMINI.ASM" PC-9801UV11 make by R.H 1991/01/17
;
;
;	ＷＩＮＤＯＷＳ／ミニウインドウ
;
;
;	WIDMINI_INIT		; WINDOWS/ミニウインドウ初期処理
;	WIDMINI			; WINDOWS/ミニウインドウ表示
;	WIDMINI_FRM		; WINDOWS/ミニウインドウフレームのみ表示
;	WIDMINI_STRC		; WINDOWS/ミニウインドウ定義体の設定
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC


;	ＷＩＮＤＯＷ　から　ＣＯＤＥ　へ　ＣＡＬＬ

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
	ASSUME	CS:WINDOW,DS:DATA
L1:	CALL	L2
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチン

FUNC	MACRO	SUBLL,SUB

CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
	PUBLIC	SUB
SUB	PROC	NEAR
	CALL	FAR PTR SUBLL
	RET
SUB	ENDP
CODE	ENDS

	ASSUME	CS:WINDOW,DS:DATA

SUBLL	PROC	FAR
	ENDM

;	ＣＯＤＥ　から　ＷＩＮＤＯＷ　を参照するルーチンの終り

FEND	MACRO	SUBLL
SUBLL	ENDP
	ENDM

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

MOVXBW	MACRO	DEST,SOUR
	MOV	AH,0
	MOV	AL,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

SUBX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	SUB	DEST,AX
	ENDM

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM

DSP_OF_ATR	EQU	0		; 表示単体定義・属性
DSP_OF_1	EQU	1		; 表示単体定義・
DSP_OF_XX	EQU	2		; 表示単体定義・Ｘ
DSP_OF_YY	EQU	3		; 表示単体定義・Ｙ
DSP_OF_XX2	EQU	4		; 表示単体定義・Ｘ２
DSP_OF_YY2	EQU	5		; 表示単体定義・Ｙ２

WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA

; ****************************************************
;	WINDOWS/ミニウインドウ初期処理
; ****************************************************

FUNC	WWIDMINI_INIT,WIDMINI_INIT
	RET
FEND	WWIDMINI_INIT


; ****************************************************
;	WINDOWS/ミニウインドウ表示
;	-I- AX : 表示番号
;	    CL : 先頭の１文字
;	    DX : 内容値
; ****************************************************

FUNC	WWIDMINI,WIDMINI
	MOV	DISP_NUM,AX		; 表示ユニット番号
	MOV	DISP_VALUE,DX		; 表示数値
	MOV	DISP_NAME,CL		; 表示名

	CALL	WID_DISP_VAL		; 数値表示

	RET
FEND	WWIDMINI


; ****************************************************
;	WINDOWS/ミニウインドウフレームのみ表示
; ****************************************************

FUNC	WWIDMINI_FRM,WIDMINI_FRM
	CALL	WID_FREAM		; ウインドウフレーム
	RET
FEND	WWIDMINI_FRM


; ****************************************************
;	WINDOWS/ミニウインドウ定義体の設定
;	-I- DS:[SI] : ウインドウフレーム定義体
;	    DS:[BX] : ウインドウ表示単体定義体
; ****************************************************

FUNC	WWIDMINI_STRC,WIDMINI_STRC
	MOVX	ES,DS			;

	MOV	DI,OFFSET FREAM_STRUCT	; ウインドウフレーム定義体
	MOV	CX,FREAM_STRUCT_SZ	; ウインドウフレーム定義体サイズ
	REP	MOVSB			;

	MOV	SI,BX			;

	MOV	DI,OFFSET DISP_UNIT	; ウインドウ表示単体定義体
	MOV	CX,DISP_UNIT_SZ		; ウインドウ表示単体定義体サイズ
	REP	MOVSB			;
	RET
FEND	WWIDMINI_STRC





; ****************************************************
;	ウインドウフレーム
;	-I- FREAM_STRUCT : ウインドウフレーム定義体
; ****************************************************

WID_FREAM	PROC	NEAR

	MOVX	WDX1,FREAM_XX		; フレーム位置Ｘ
	MOVX	WDY1,FREAM_YY		; フレーム位置Ｙ
	MOVX	WDX2,FREAM_SZ_X		; フレームサイズＸ
	MOVX	WDY2,FREAM_SZ_Y		; フレームサイズＹ

	CALLC	WID_6_FLAME		; WINDOWS/フレーム６（ミニ）

	RET
WID_FREAM	ENDP


; ****************************************************
;	数値表示
;	-I- DISP_NUM   : 表示ユニット番号
;	    DISP_VALUE : 表示数値
;	    DISP_NAME  : 表示名
; ****************************************************

WID_DISP_VAL	PROC	NEAR
	MOV	DX,0				;
	MOV	AX,DISP_NUM			; 表示ユニット番号
	MOV	BX,DISK_UNIT_1SZ		; 単体定義体１個サイズ
	MUL	BX				;

	MOV	BX,AX				;
	MOVXBW	DISP_KIND,DS:DISP_UNIT[BX][DSP_OF_ATR]	; 表示形式
	MOVXBW	XX1,DS:DISP_UNIT[BX][DSP_OF_XX]	; 表示単体定義・Ｘ
	MOVXBW	YY1,DS:DISP_UNIT[BX][DSP_OF_YY]	; 表示単体定義・Ｙ
	MOVXBW	XX2,DS:DISP_UNIT[BX][DSP_OF_XX2] ; 表示単体定義・Ｘ２
	MOVXBW	YY2,DS:DISP_UNIT[BX][DSP_OF_YY2] ; 表示単体定義・Ｙ２

	MOV	AX,FREAM_XX			; フレーム位置Ｘ
	MOV	BX,FREAM_YY			; フレーム位置Ｙ
	ADD	XX1,AX				; 表示単体定義・Ｘ
	ADD	YY1,BX				; 表示単体定義・Ｙ
	ADD	XX2,AX				; 表示単体定義・Ｘ２
	ADD	YY2,BX				; 表示単体定義・Ｙ２

	MOVX	TXTXX,XX1			; 文字列Ｘ位置
	MOVX	TXTYY,YY1			; 文字列Ｙ位置
	MOV	AX,WORD PTR DISP_NAME[0]	; 表示名
	MOV	BX,WORD PTR DISP_NAME[2]	;
	MOV	WORD PTR STR_VAL_BUFF[0],AX	; 表示値文字列バッファ
	MOV	WORD PTR STR_VAL_BUFF[2],BX	;
	CALL	DISP_STR			; ステータス文字表示

	CMP	DISP_KIND,0			; 表示形式 0=通常
	JE	WID_DISP_VAL_NORMAL		;
	CMP	DISP_KIND,1			; 表示形式 1=％表示
	JE	WID_DISP_VAL_PARSENT		;
	CMP	DISP_KIND,2			; 表示形式 2=文字列
	JE	WID_DISP_VAL_STRING		;
WID_DISP_VAL_NORMAL:
	MOVX	TXTXX,XX2			; 文字列Ｘ位置
	MOVX	TXTYY,YY2			; 文字列Ｙ位置
	MOVX	PR_DSPVAL,DISP_VALUE		; 表示数値
	CALL	DISP_VAL			; 数値表示

	JMP	WID_DISP_VAL_EIXT		;
WID_DISP_VAL_PARSENT:
	MOVX	TXTXX,XX2			; 文字列Ｘ位置
	MOVX	TXTYY,YY2			; 文字列Ｙ位置
	MOVX	PR_DSPVAL,DISP_VALUE		; 表示数値
	CALL	DISP_PAR			; ％表示

	JMP	WID_DISP_VAL_EIXT		;
WID_DISP_VAL_STRING:
	MOVX	ES,DS				;
	MOV	SI,DISP_VALUE			; 文字列アドレス表示数値
	MOV	DI,OFFSET STR_BUFF		; 文字列バッファ
	MOV	CX,STRING_LEN			; string length.
	CALLC	STRSETZ				; 文字列バッファセット

	MOV	AX,15				; 数値表示色
	CALLC	MITCOL				; mini string color.
	MOV	AX,TXTXX			; 文字列Ｘ位置
	MOV	BX,TXTYY			; 文字列Ｙ位置
	MOV	SI,OFFSET STR_BUFF		; 文字列バッファ
	CALLC	MITPRN			; mini string. (null=end of string)

WID_DISP_VAL_EIXT:
	RET
WID_DISP_VAL	ENDP


; ****************************************************
;	数値表示
;	-I- TXTXX     : 文字列Ｘ位置
;	    TXTYY     : 文字列Ｙ位置
;	    PR_DSPVAL : 表示数値
; ****************************************************

DISP_VAL	PROC	NEAR
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ

	MOV	DX,PR_DSPVAL		; 表示数値
	CALLC	DECSTR			; dec -> string.
	CALLC	STRZTS			; zero to space.
	CALLC	STRSPL			; space pless. "  123" - > "123  "
	MOV	AX,DS:[SI]		;
	MOV	BX,DS:[SI][2]		;
	MOV	CL,DS:[SI][4]		;
	MOV	DS:[DI],AX		;
	MOV	DS:[DI][2],BX		;
	MOV	DS:[DI][4],CL		;
	MOV	DS:[DI][5],BYTE PTR 0	; 5ｹﾀ

	CALL	DISP_STR		; 文字表示

	RET
DISP_VAL	ENDP


; ****************************************************
;	％表示
;	-I- TXTXX     : 文字列Ｘ位置
;	    TXTYY     : 文字列Ｙ位置
;	    PR_DSPVAL : 表示数値
; ****************************************************

DISP_PAR	PROC	NEAR
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ

	MOVX	WDP_VAL,PR_DSPVAL	; 内容表示値
	MOV	WDP_UNIT,UNIT_PAR	; 単位系 ％
	CALLC	WID_UNIT		; WINDOWS/単位別文字列化
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRSPL			; space pless. "  123" - > "123  "

	CALL	DISP_STR		; 文字表示

	RET
DISP_PAR	ENDP


; ****************************************************
;	ステータス文字表示
;	-I- TXTXX        : 文字列Ｘ位置
;	    TXTYY        : 文字列Ｙ位置
;	    STR_VAL_BUFF : 表示値文字列バッファ
; ****************************************************

DISP_STR	PROC	NEAR
	MOV	PR_DSPCLR,15		; 数値表示色

	MOVX	ES,DS			;
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	STRLENGTH		; 文字列長さ

;*;	MOVX	VX1,TXTXX		; 文字列Ｘ位置
;*;	MOVX	VY1,TXTYY		; 文字列Ｙ位置
;*;	MOVX	VX2,TXTXX		; 文字列Ｘ位置
;*;	ADD	VX2,CX			; 表示単語長さ
;*;	SHL	VX1,1			;
;*;	SHL	VX1,1			;
;*;	SHL	VX1,1			; * 8
;*;	SHL	VX2,1			;
;*;	SHL	VX2,1			;
;*;	SHL	VX2,1			; * 8
;*;	MOV	VCOL,15			; カラー・白
;*;	MOV	CX,7			; 太さ
;*;	CALLC	DLINEH			; 水平ライン描画

	MOV	AX,PR_DSPCLR		; 数値表示色
	CALLC	MITCOL			; mini string color.
	MOV	AX,TXTXX		; 文字列Ｘ位置
	MOV	BX,TXTYY		; 文字列Ｙ位置
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	MITPRN			; mini string. (null=end of string)
;*;	CALL	MDTPRN			; MID string. (null=end of string)
	RET
DISP_STR	ENDP


WINDOW	ENDS



DATA	SEGMENT	PUBLIC	'DATA'

FREAM_STRUCT_SZ	DW	8		; ウインドウフレーム定義体サイズ
FREAM_STRUCT	LABEL	BYTE		; ウインドウフレーム定義体
FREAM_XX	DW	10		; フレーム位置Ｘ
FREAM_YY	DW	200		; フレーム位置Ｙ
FREAM_SZ_X	DW	6		; フレームサイズＸ
FREAM_SZ_Y	DW	200		; フレームサイズＹ

DISP_UNIT_SZ	DW	6*7		; ウインドウ表示単体定義体サイズ
DISK_UNIT_1SZ	DW	6		; ウインドウ表示単体定義体１個サイズ
DISP_UNIT	LABEL	BYTE		; ウインドウ表示単体定義体(byte)
		DB	0,0,	0,8*0,	2,8*0
		DB	1,0,	0,8*1,	2,8*1
		DB	0,0,	0,8*2,	2,8*2
		DB	0,0,	0,8*3,	2,8*3
		DB	0,0,	0,8*3,	2,8*3
		DB	0,0,	0,8*3,	2,8*3
		DB	0,0,	0,8*3,	2,8*3

DISP_NUM	DW	0		; 表示ユニット番号
DISP_KIND	DW	0		; 表示形式 0=通常,1=％表示,2=文字列
DISP_VALUE	DW	0		; 表示数値
DISP_NAME	DB	" :",0		; 表示名
XX1		DW	0		; Ｘ１
YY1		DW	0		; Ｙ１
XX2		DW	0		; Ｘ２
YY2		DW	0		; Ｙ２

PR_DSPVAL	DW	0		; 表示数値
PR_DSPCLR	DW	0		; 数値表示色
PR_DSPCSZ	DW	0		; パラメータ名内容文字表示サイズ

TXTXX		DW	0		; 文字列Ｘ位置
TXTYY		DW	0		; 文字列Ｙ位置


DATA	ENDS

	END
;
;	end of "WIDMINI.ASM"
;
