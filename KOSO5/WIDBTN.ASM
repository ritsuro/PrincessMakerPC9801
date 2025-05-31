; "WIDBTN.ASM" PC-9801UV11 make by R.H 1990/10/30
;
;
;	ＷＩＮＤＯＷＳ／ボタンセレクト（道具,技,仕事）
;
;
;	WIDBTN_INIT		; WINDOWS/ボタン初期処理
;	WIDBTN_OPEN		; WINDOWS/ボタンオープン
;	WIDBTN_CLOSE		; WINDOWS/ボタンクローズ
;	WIDBTN_TOUCH		; WINDOWS/ボタンタッチチェック
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC

BTN_XX	EQU	20


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
;	WINDOWS/ボタン初期処理
; ****************************************************

FUNC	WWIDBTN_INIT,WIDBTN_INIT
;**;	CALLC	PT_LD_BTN		; ボタンＬＯＡＤ
	RET
FEND	WWIDBTN_INIT



; ****************************************************
;	WINDOWS/ボタンオープン
; ****************************************************

FUNC	WWIDBTN_OPEN,WIDBTN_OPEN
	CALL	WIDBTN_LOCATE		; ボタンウインドウＬＯＣＡＴＥ
	CALL	ALLBTN_DRAW		; ボタン全表示

	CALLC	WIDBAR_SOUBI_OPEN	; WINDOWS/バー・装備ＯＰＥＮ
	RET
FEND	WWIDBTN_OPEN


; ****************************************************
;	WINDOWS/ボタンクローズ
; ****************************************************

FUNC	WWIDBTN_CLOSE,WIDBTN_CLOSE
	CALLC	WIDBAR_SOUBI_CLOSE	; WINDOWS/バー・装備ＣＬＯＳＥ
	RET
FEND	WWIDBTN_CLOSE



; ****************************************************
;	WINDOWS/ボタンタッチチェック
;	-I- WDMSX    : マウスＸ
;	    WDMSY    : マウスＹ
;	    WDMSL    : マウス左ボタン(1:OFF/0:ON)
;	    WDMSR    : マウス右ボタン
;	-O- WDBTNNUM : 選択ボタン番号  0=ボタンに触れてない
;			1=スケジュール
;			2=王様,3=町の評判
;			4=ステータス,5=娘と話す,6=買物
;	    WDBTNPUSH: ボタン押したフラグ
;	               0=ボタンに触れてない
;	               1=ボタンに触れた
;	               2=ボタンを押した
; ****************************************************

FUNC	WWIDBTN_TOUCH,WIDBTN_TOUCH

	CMP	WIDBDEMO,33		; デモフラグ0=通常,33=ランダムセレクト
	JNE	WIDBTN_TOUCH_1		;

	MOV	CX,6			; ボタン数=６
	CALLC	RANDAM_CX		; 乱数範囲指定＊＊＊＊＊＊＊＊＊＊
	MOV	WDBTNNUM,AX		; 選択ボタン番号
	MOV	WDBTNPUSH,2		;  2=ボタンを押した
	RET
WIDBTN_TOUCH_1:
	MOVX	MUSXX,WDMSX		; マウス座標Ｘ
	MOVX	MUSYY,WDMSY		; マウス座標Ｙ

	MOV	WDBTNNUM,0		; WINDOWS/選択ボタン番号

	CALL	TOUCH_CHK		; タッチチェック
	MOVX	WDBTNNUM,FLAG_BTN_ON	; 選択ボタン番号

	MOVX	WDBTNPUSH,FLAG_PUSH_BTN	; ボタン押した

	CALL	DISP_BOTTAN		; 押したボタン表示

	RET
FEND	WWIDBTN_TOUCH



;	ボタンウインドウ位置

WIDBTN_LOCATE	PROC	NEAR
	MOV	BTN_ON_NUM,0		; 現在ＯＮになっているボタン番号
	RET
WIDBTN_LOCATE	ENDP



;	ボタン全表示

ALLBTN_DRAW	PROC	NEAR

	MOV	AX,ADV_BTN_XX		; ボタンＸ座標
	MOV	BX,ADV_BTN_YY		; ボタンＹ座標
	SUB	AX,3			;
	SUB	BX,8			;
	CALLC	PT_PUT_BTN_WK		; ボタン枠/ＰＵＴ

	MOV	BTNNUM,0		; ボタン番号
	CALL	BOTTAN_OFF		; ボタンＯＦＦ

	MOV	BTNNUM,1		; ボタン番号
	CALL	BOTTAN_OFF		; ボタンＯＦＦ

	MOV	BTNNUM,2		; ボタン番号
	CALL	BOTTAN_OFF		; ボタンＯＦＦ

	MOV	BTNNUM,3		; ボタン番号
	CALL	BOTTAN_OFF		; ボタンＯＦＦ

	MOV	BTNNUM,4		; ボタン番号
	CALL	BOTTAN_OFF		; ボタンＯＦＦ

	MOV	BTNNUM,5		; ボタン番号
	CALL	BOTTAN_OFF		; ボタンＯＦＦ

	RET
ALLBTN_DRAW	ENDP


;	押したボタン表示
;	-I- FLAG_BTN_ON	: 選択ボタン番号

DISP_BOTTAN	PROC	NEAR
	MOV	AX,FLAG_BTN_ON		; 選択ボタン番号
	CMP	AX,BTN_ON_NUM		; 現在ＯＮになっているボタン番号
	JE	DISP_BOTTAN_EXIT	;

	CMP	BTN_ON_NUM,0		; 現在ＯＮになっているボタン番号
	JE	DISP_BOTTAN_ON		;

	MOVX	BTNNUM,BTN_ON_NUM	;
	DEC	BTNNUM			;
	CALL	BOTTAN_OFF		; ボタンＯＦＦ

	MOV	BTN_ON_NUM,0		;
DISP_BOTTAN_ON:
	CMP	FLAG_BTN_ON,0		; 選択ボタン番号
	JE	DISP_BOTTAN_EXIT	;

	MOVX	BTNNUM,FLAG_BTN_ON	; 選択ボタン番号
	DEC	BTNNUM			;
	CALL	BOTTAN_ON		; ボタンＯＮ

	MOVX	BTN_ON_NUM,FLAG_BTN_ON	; 選択ボタン番号
DISP_BOTTAN_EXIT:
	RET
DISP_BOTTAN	ENDP


;	ボタンＯＮ
;	-I- BTNNUM : ボタン番号

BOTTAN_ON	PROC	NEAR
	MOV	SI,BTNNUM		; ボタン番号
	MOV	AH,0			;
	MOV	AL,DS:AREA_XX[SI]	; ＰＵＴ　Ｘ座標
	MOV	BH,0			;
	MOV	BL,DS:AREA_YY[SI]	; ＰＵＴ　Ｙ座標
	ADD	AX,ADV_BTN_XX		; ボタンＸ座標
	ADD	BX,ADV_BTN_YY		; ボタンＹ座標
	MOV	CX,BTNNUM		; ボタン番号
	CALLC	PT_PUT_BTN_ON		; ボタンＯＮ/ＰＵＴ
	RET
BOTTAN_ON	ENDP



;	ボタンＯＦＦ
;	-I- BTNNUM : ボタン番号

BOTTAN_OFF	PROC	NEAR
	MOV	SI,BTNNUM		; ボタン番号
	MOV	AH,0			;
	MOV	AL,DS:AREA_XX[SI]	; ＰＵＴ　Ｘ座標
	MOV	BH,0			;
	MOV	BL,DS:AREA_YY[SI]	; ＰＵＴ　Ｙ座標
	ADD	AX,ADV_BTN_XX		; ボタンＸ座標
	ADD	BX,ADV_BTN_YY		; ボタンＹ座標
	MOV	CX,BTNNUM		; ボタン番号
	CALLC	PT_PUT_BTN_OFF		; ボタンＯＦＦ/ＰＵＴ
	RET
BOTTAN_OFF	ENDP


;	タッチチェック
;	-I- MUSXX : マウス座標Ｘ
;	    MUSYY : マウス座標Ｙ
;	    WDMSL : マウス左ボタン(1:OFF/0:ON)
;	    WDMSR : マウス右ボタン
;	-O- FLAG_BTN_ON : 選択ボタン番号  0=ボタンに触れてない
;			1=スケジュール
;			2=王様,3=町の評判
;			4=ステータス,5=娘と話す,6=買物
;	    FLAG_PUSH_BTN : 0=ボタンに触れてない
;	                    1=ボタンに触れた
;	                    2=ボタンを押した

TOUCH_CHK	PROC	NEAR
	MOV	AX,MUSXX		; マウス座標Ｘ
	SUB	AX,ADV_BTN_XX		; ボタンＸ座標

	CMP	AX,AREA_XX_MIN		;
	JL	TOUCH_CHK_OFF		;
	CMP	AX,AREA_XX_MAX		;
	JG	TOUCH_CHK_OFF		;

	MOV	BX,MUSYY		; マウス座標Ｙ　範囲チェック
	SUB	BX,ADV_BTN_YY		; ボタンＹ座標

	CMP	BX,AREA_YY_MIN		;
	JL	TOUCH_CHK_OFF		;
	CMP	BX,AREA_YY_MAX		;
	JG	TOUCH_CHK_OFF		;

	MOV	FLAG_BTN_ON,1		;
	MOV	SI,0			; word pointer.
	MOV	CX,AREA_CNT		;
TOUCH_CHK_LOOP:
	CMP	AL,DS:AREA_XX[SI]
	JB	TOUCH_CHK_NEXT
	CMP	AL,DS:AREA_XX2[SI]
	JNBE	TOUCH_CHK_NEXT
	CMP	BL,DS:AREA_YY[SI]
	JB	TOUCH_CHK_NEXT
	CMP	BL,DS:AREA_YY2[SI]
	JNBE	TOUCH_CHK_NEXT
	JMP	TOUCH_CHK_ON_CHK
TOUCH_CHK_NEXT:
	INC	FLAG_BTN_ON		;
	INC	SI			;
	LOOP	TOUCH_CHK_LOOP		;

TOUCH_CHK_OFF:
	MOV	FLAG_BTN_ON,0		; 0=ボタンに触れてない
	MOV	FLAG_PUSH_BTN,0		; 0=ボタンに触れてない
	RET

TOUCH_CHK_ON_CHK:
	CMP	WDMSL,0			; マウス左ボタン(1:OFF/0:ON)
	JE	TOUCH_CHK_ON_PUSH	;
;*;	CMP	WDMSR,0			; マウス右ボタン
;*;	JE	TOUCH_CHK_ON_PUSH	;
TOUCH_CHK_ON_TOUCH:
	MOV	FLAG_PUSH_BTN,1		; 1=ボタンに触れた
	RET
TOUCH_CHK_ON_PUSH:
	MOV	FLAG_PUSH_BTN,2		; 2=ボタンを押した
	RET
TOUCH_CHK	ENDP


WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	WIDBDEMO		; (WIDBTN.ASM)デモフラグ
				; 0=通常,33=ランダムセレクト

EXTRN	ADV_BTN_XX:WORD		; ボタンＸ座標
EXTRN	ADV_BTN_YY:WORD		; ボタンＹ座標

WIDBDEMO	DW	0		; デモフラグ0=通常,33=ランダムセレクト

BTNNUM		DW	0		; ボタン番号
BTN_ON_NUM	DW	0		; 現在ＯＮになっているボタン番号

MUSXX		DW	0		; マウス座標Ｘ
MUSYY		DW	0		; マウス座標Ｙ

FLAG_BTN_ON	DW	0		; 0=ボタンに触れてない
					; 1=スケジュール
					; 2=王様,3=町の評判
					; 4=ステータス,5=娘と話す,6=買物

FLAG_PUSH_BTN	DW	0		; 0=ボタンに触れてない
					; 1=ボタンに触れた
					; 2=ボタンを押した

AREA_CNT	DW	6
		;	  0   1   2   3   4   5
AREA_XX		DB	  0,  0,  4,  8, 12, 16
AREA_YY		DB	 42, 73, 73, 73, 73, 73
AREA_XX2	DB	 19,  3,  7, 11, 15, 19
AREA_YY2	DB	 75,105,105,105,105,105
AREA_XX_MIN	DW	0
AREA_XX_MAX	DW	24
AREA_YY_MIN	DW	0
AREA_YY_MAX	DW	102

DATA	ENDS

	END
;
;	end of "WIDBTN.ASM"
;
