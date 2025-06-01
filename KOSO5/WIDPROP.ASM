; "WIDPROP.ASM" PC-9801UV11 make by R.H 1990/10/29
;
;
;	ＷＩＮＤＯＷＳ／プロポーションウインドウ
;
;
;	WIDPROP_INIT			; WINDOWS/プロポ・ウインドウ初期処理
;	WIDPROP_ALL			; WINDOWS/プロポ・ウインドウ全表示
;	WIDPROP_OPEN			; WINDOWS/プロポ・ウインドウＯＰＥＮ
;	WIDPROP_CLOSE			; WINDOWS/プロポ・ウインドウＣＬＯＳＥ
;
;
; (C) 1990 ritsurou hashimoto.

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

;	ＷＩＮＤＯＷセグメントからＣＯＤＥセグメントへ

CODE_IN		MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	SEGMENT	PUBLIC	'CODE'
	ASSUME	CS:CODE,DS:DATA
L1:
	ENDM

;	ＣＯＤＥセグメントからＷＩＮＤＯＷセグメントへ

CODE_OUT	MACRO
	LOCAL	L1
	JMP	FAR PTR L1
CODE	ENDS
	ASSUME	CS:WINDOW,DS:DATA
L1:
	ENDM

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	MOV	DEST,AX
	ENDM

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA

; ****************************************************
;	WINDOWS/プロポ・ウインドウ初期処理
; ****************************************************

FUNC	WWIDPROP_INIT,WIDPROP_INIT
	RET
FEND	WWIDPROP_INIT


; ****************************************************
;	WINDOWS/プロポ・ウインドウ全表示
; ****************************************************

FUNC	WWIDPROP_ALL,WIDPROP_ALL
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	CALLC	PT_PUT_PROP2		; プロポ高速ＰＵＴ

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	GET_PARA		; 各パラメータのＧＥＴ
	CALL	PUT_NENREI		; 年齢
	CALL	PUT_SHINCH		; 身長
	CALL	PUT_TAIJYU		; 体重
	CALL	PUT_HYOUKA		; 評価
	RET
FEND	WWIDPROP_ALL


; ****************************************************
;	WINDOWS/プロポ・ウインドウＯＰＥＮ
; ****************************************************

FUNC	WWIDPROP_OPEN,WIDPROP_OPEN
;*;	CALLC	WIDDSP_SV_MYST		; WINDOWS/ＭＹステータス退避
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	CALLC	PT_PUT_PROPR		; プロポＰＵＴ
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	CALLC	PT_PUT_PROP2		; プロポ高速ＰＵＴ

;*NON*;	CALL	FAR PTR WWIDPROP_ALL	; WINDOWS/プロポ・ウインドウ全表示

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	CALL	GET_PARA		; 各パラメータのＧＥＴ
	CALL	PUT_NENREI		; 年齢
	CALL	PUT_SHINCH		; 身長
	CALL	PUT_TAIJYU		; 体重
	CALL	PUT_HYOUKA		; 評価
	RET
FEND	WWIDPROP_OPEN


; ****************************************************
;	WINDOWS/プロポ・ウインドウＣＬＯＳＥ
; ****************************************************

FUNC	WWIDPROP_CLOSE,WIDPROP_CLOSE
;*;	CALLC	WIDDSP_LD_MYST		; WINDOWS/ＭＹステータス復元
	RET
FEND	WWIDPROP_CLOSE


; ****************************************************
;	年齢
;	-I- PARA_NENREI : 年齢
; ****************************************************

PUT_NENREI	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	ADD	AX,W_CLM1		; カラム・年齢
	ADD	BX,W_LIN1		; 行　　・年齢
	MOV	DX,PARA_NENREI		; 年齢
	CALL	DSP_VALUE		; 数値の表示
	RET
PUT_NENREI	ENDP


; ****************************************************
;	身長
;	-I- PARA_SHINCH : 身長
; ****************************************************

PUT_SHINCH	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	ADD	AX,W_CLM2		; カラム・身長
	ADD	BX,W_LIN2		; 行　　・身長
	MOV	DX,PARA_SHINCH		; 身長
	CALL	DSP_P_VALUE		; 固定小数点数値の表示
	RET
PUT_SHINCH	ENDP


; ****************************************************
;	体重
;	-I- PARA_TAIJYU : 体重
; ****************************************************

PUT_TAIJYU	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	ADD	AX,W_CLM3		; カラム・体重
	ADD	BX,W_LIN3		; 行　　・体重
	MOV	DX,PARA_TAIJYU		; 体重
	CALL	DSP_P_VALUE		; 固定小数点数値の表示
	RET
PUT_TAIJYU	ENDP


; ****************************************************
;	評価
;	-I- PARA_HYOUKA : 評価
; ****************************************************

PUT_HYOUKA	PROC	NEAR
	MOV	AX,DSP_WID_X		; ウインドウ表示位置Ｘ
	MOV	BX,DSP_WID_Y		; ウインドウ表示位置Ｙ
	ADD	AX,W_CLM4		; カラム・評価
	ADD	BX,W_LIN4		; 行　　・評価
	MOV	DX,PARA_HYOUKA		; 評価
	CALL	DSP_VALUE		; 数値の表示
	RET
PUT_HYOUKA	ENDP


; ****************************************************
;	数値の表示
;	-I- AX : Ｘ
;	    BX : Ｙ
;	    DX : 数値
; ****************************************************

DSP_VALUE	PROC	NEAR
	PUSH	AX
	PUSH	BX
	CALL	WIDVALDSP_USING		; 表示値編集
	MOV	AX,MOJI_COL		; font color.
	CALLC	MITCOL			; mini string color.
	POP	BX
	POP	AX
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	MGXPRN			; GAINAX mini string.
;*;	CALLC	MDTPRN			; MID string. (null=end of string)
;*;	CALLC	MWTPRN			; WIDE string. (null=end of string)
;*;	CALLC	MBTPRN			; BIG string. (null=end of string)
	RET
DSP_VALUE	ENDP


; ****************************************************
;	固定小数点数値の表示
;	-I- AX : Ｘ
;	    BX : Ｙ
;	    DX : 数値
; ****************************************************

DSP_P_VALUE	PROC	NEAR
	PUSH	AX
	PUSH	BX
	CALL	WIDVALDSP_P_USING	; 固定小数値編集
	MOV	AX,MOJI_COL		; font color.
	CALLC	MITCOL			; mini string color.
	POP	BX
	POP	AX
	MOV	SI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	MGXPRN			; GAINAX mini string.
;*;	CALLC	MDTPRN			; MID string. (null=end of string)
;*;	CALLC	MBTPRN			; BIG string. (null=end of string)
	RET
DSP_P_VALUE	ENDP



; ****************************************************
;	表示値編集
;	-I- DX           : 数値
;	-O- STR_VAL_BUFF : 表示値文字列バッファ
; ****************************************************

WIDVALDSP_USING	PROC	NEAR
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	DECSTR			; dec -> string.
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
;*;	CALLC	STRSPL			; space pless. "  123" - > "123  "
	MOV	AX,DS:[SI][1]		;
	MOV	BX,DS:[SI][3]		;
	MOV	DL,DS:[SI][5]		;
	MOV	DS:[DI][0],AX		;
	MOV	DS:[DI][2],BX		;
	MOV	DS:[DI][4],DL		;
	MOV	DS:[DI][5],BYTE PTR 0	;
	RET
WIDVALDSP_USING	ENDP


; ****************************************************
;	固定小数値編集
;	-I- DX           : 数値
;	-O- STR_VAL_BUFF : 表示値文字列バッファ
; ****************************************************

WIDVALDSP_P_USING	PROC	NEAR
	MOV	DI,OFFSET STR_VAL_BUFF	; 表示値文字列バッファ
	CALLC	DECSTR			; dec -> string.
	CALLC	STRZTS			; zero to space. "00123" - > "  123"
	MOV	AX,DS:[SI][0]		;
	MOV	BX,DS:[SI][2]		; "  123" -> "  12.3"
	MOV	DX,DS:[SI][4]		;
	MOV	DS:[DI][0],AX		;
	MOV	DS:[DI][2],BX		;
	MOV	DS:[DI][4],BYTE PTR '.'	;
	MOV	DS:[DI][5],DX		;
	MOV	DS:[DI][7],BYTE PTR 0	;

	RET
WIDVALDSP_P_USING	ENDP


; ****************************************************
;	各パラメータのＧＥＴ
;	-I- AX : 誰か（アドレス）
;	-O- PARA_NENREI : 年齢
;	    PARA_SHINCH : 身長
;	    PARA_TAIJYU : 体重
;	    PARA_HYOUKA : 評価
; ****************************************************

GET_PARA	PROC	NEAR
	MOV	S_FUNC,31		; 31=年齢、身長、体重、評価をみる
	CALLC	R_KEISAN		; 各計算処理
	MOV	PARA_NENREI,AX		; 年齢
	MOV	PARA_SHINCH,BX		; 身長
	MOV	PARA_TAIJYU,CX		; 体重
	MOV	PARA_HYOUKA,DX		; 評価
	RET
GET_PARA	ENDP



WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	S_FUNC:WORD		; 計算ファンクション

DSP_WID_X	DW	55		; ウインドウ表示位置Ｘ
DSP_WID_Y	DW	78		; ウインドウ表示位置Ｙ

W_CLM1		DW	4		; カラム・年齢
W_LIN1		DW	12		; 行　　・年齢

W_CLM2		DW	11		; カラム・身長
W_LIN2		DW	12		; 行　　・身長

W_CLM3		DW	11		; カラム・体重
W_LIN3		DW	12+8*2+1	; 行　　・体重

W_CLM4		DW	4		; カラム・評価
W_LIN4		DW	12+8*2+1	; 行　　・評価

MOJI_COL	DW	15 ;8		; font color.

PARA_NENREI	DW	0		; 年齢
PARA_SHINCH	DW	0		; 身長
PARA_TAIJYU	DW	0		; 体重
PARA_HYOUKA	DW	0		; 評価

DATA	ENDS

	END
;
;	end of "WIDPROP.ASM"
;
