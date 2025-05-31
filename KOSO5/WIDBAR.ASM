; "WIDBAR.ASM" PC-9801UV11 make by R.H 1990/10/18
;
;
;	ＷＩＮＤＯＷＳ／バー・セット（タイトル等々）
;
;	WIDBAR_INIT		; WINDOWS/バー・初期処理
;	WIDBAR_TITLE		; WINDOWS/バー・タイトル
;	WIDBAR_MUSYA_OPEN	; WINDOWS/バー・武者修行行き先OPEN
;	WIDBAR_MUSYA_CLOSE	; WINDOWS/バー・武者修行行き先CLOSE
;	WIDBAR_MUSYA		; WINDOWS/バー・武者修行行き先PUT
;	WIDBAR_SOUBI_OPEN	; WINDOWS/バー・装備ＯＰＥＮ
;	WIDBAR_SOUBI_CLOSE	; WINDOWS/バー・装備ＣＬＯＳＥ
;	WIDBAR_SOUBI		; WINDOWS/バー・装備ＰＵＴ
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\WINDOW.INC

OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味

COL_NAME	EQU	15		; 名前カラー
WHERE_XX	EQU	26		; 行き先表示Ｘ
WHERE_YY	EQU	14		; 行き先表示Ｙ


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

CMPX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	CMP	DEST,AX
	ENDM

MOVXBW	MACRO	DEST,SOUR_BYTE
	MOV	AH,0
	MOV	AL,SOUR_BYTE
	MOV	DEST,AX
	ENDM


WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA


; ****************************************************
;	WINDOWS/バー・初期処理
; ****************************************************

FUNC	WWIDBAR_INIT,WIDBAR_INIT
	RET
FEND	WWIDBAR_INIT


; ****************************************************
;	WINDOWS/バー・タイトル
; ****************************************************

FUNC	WWIDBAR_TITLE,WIDBAR_TITLE
	RET
FEND	WWIDBAR_TITLE


; ****************************************************
;	WINDOWS/バー・武者修行行き先OPEN
; ****************************************************

FUNC	WWIDBAR_MUSYA_OPEN,WIDBAR_MUSYA_OPEN
	MOV	WHERE_DSP,1		; 場所表示 1=近郊,2=辺境,3=蛮地
	MOV	WHERE_NOW,1		; 場所 1=近郊,2=辺境,3=蛮地
	CALL	GO_PRINT		; 行き先ＰＲＩＮＴ
	RET
FEND	WWIDBAR_MUSYA_OPEN


; ****************************************************
;	WINDOWS/バー・武者修行行き先CLOSE
; ****************************************************

FUNC	WWIDBAR_MUSYA_CLOSE,WIDBAR_MUSYA_CLOSE
	RET
FEND	WWIDBAR_MUSYA_CLOSE


; ****************************************************
;	WINDOWS/バー・武者修行行き先PUT
;	-I- DX : 場所 1=近郊,2=辺境,3=蛮地
; ****************************************************

FUNC	WWIDBAR_MUSYA,WIDBAR_MUSYA
	CMP	WHERE_DSP,DX		; 場所表示 1=近郊,2=辺境,3=蛮地
	JE	WIDBAR_MUSYA_EXIT	;

	MOV	WHERE_DSP,DX		; 場所表示 1=近郊,2=辺境,3=蛮地
	MOV	WHERE_NOW,DX		; 場所 1=近郊,2=辺境,3=蛮地
	CALL	GO_PRINT		; 行き先ＰＲＩＮＴ

WIDBAR_MUSYA_EXIT:
	RET
FEND	WWIDBAR_MUSYA


; ****************************************************
;	WINDOWS/バー・装備ＯＰＥＮ
; ****************************************************

FUNC	WWIDBAR_SOUBI_OPEN,WIDBAR_SOUBI_OPEN
	MOV	AX,ADV_BTN_XX		; ボタンＸ座標
	MOV	BX,ADV_BTN_YY		; ボタンＹ座標
	SUB	AX,3			;
	SUB	BX,8			;
	CALLC	PT_PUT_SBI_WK		; 装備枠/ＰＵＴ

	CALL	SOUBI_ALL_PUT		; 装備全ＰＵＴ
	RET
FEND	WWIDBAR_SOUBI_OPEN


; ****************************************************
;	WINDOWS/バー・装備ＣＬＯＳＥ
; ****************************************************

FUNC	WWIDBAR_SOUBI_CLOSE,WIDBAR_SOUBI_CLOSE
	RET
FEND	WWIDBAR_SOUBI_CLOSE


; ****************************************************
;	WINDOWS/バー・装備ＰＵＴ
; ****************************************************

FUNC	WWIDBAR_SOUBI,WIDBAR_SOUBI
	CALL	SOUBI_ALL_PUT		; 装備全ＰＵＴ
	RET
FEND	WWIDBAR_SOUBI


; ****************************************************
;	装備全ＰＵＴ
; ****************************************************

SOUBI_ALL_PUT	PROC	NEAR
	CALL	GET_SOUBI			; 装備ＧＥＴ

	MOV	PLOC,0				; ロケート番号
	CALL	PUT_ITEM			; アイテムＰＵＴ

	MOV	PLOC,1				; ロケート番号
	CALL	PUT_ITEM			; アイテムＰＵＴ

	MOV	PLOC,2				; ロケート番号
	CALL	PUT_ITEM			; アイテムＰＵＴ

	RET
SOUBI_ALL_PUT	ENDP


; ****************************************************
;	アイテムＰＵＴ
;	-I- PLOC     : ロケート番号
; ****************************************************

PUT_ITEM	PROC	NEAR
	MOV	BX,PLOC			; ロケート番号
	SHL	BX,1			; word pointer.
	MOV	AX,DS:SOBI_NEW_TBL[BX]	; 装備新たなる表示（武器，鎧，兜）
	MOV	ITEM_OFS,AX		; アイテムオフセット

	CMP	ITEM_OFS,OFFF		; アイテムオフセット
	JE	PUT_ITEM_FUTA		;

PUT_ITEM_ITEM:
	CALL	LOC_GET			; ロケーションＧＥＴ
	MOV	SI,ITEM_OFS		; アイテムオフセット
	CALLC	WIDITM_PIC		; WINDOWS/アイテム絵表示
	JMP	PUT_ITEM_EXIT		;

PUT_ITEM_FUTA:
	CALL	PUT_FUTA		; フタＰＵＴ

PUT_ITEM_EXIT:
	RET
PUT_ITEM	ENDP


; ****************************************************
;	フタＰＵＴ
;	-I- PLOC : ロケート番号
; ****************************************************

PUT_FUTA	PROC	NEAR
	MOV	PNM,0				; パターン番号
	CALL	LOC_GET				; ロケーションＧＥＴ
	MOV	CX,PNM				; パターン番号
	CALLC	PT_PUT_SBI_FT			; 装備蓋/ＰＵＴ
	RET
PUT_FUTA	ENDP


; ****************************************************
;	ロケーションＧＥＴ
;	-I- PLOC : ロケート番号
;	-O- AX   : Ｘ座標
;	    BX   : Ｙ座標
; ****************************************************

LOC_GET	PROC	NEAR
	MOV	SI,PLOC			; ロケート番号
	MOV	AH,0			;
	MOV	AL,DS:SOBI_XX[SI]	; X
	MOV	BH,0			;
	MOV	BL,DS:SOBI_YY[SI]	; Y

	ADD	AX,ADV_BTN_XX		; ボタンＸ座標
	ADD	BX,ADV_BTN_YY		; ボタンＹ座標
	SUB	BX,2			;

	RET
LOC_GET	ENDP


; ****************************************************
;	装備ＧＥＴ
; ****************************************************

GET_SOUBI	PROC	NEAR
	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	CX,WIDOFS_ITEM		; アイテムテーブル
	MOV	BX,0			; 装備種別 0=武器
	MOV	S_FUNC,73		; 73=装備・ＧＥＴ
	CALLC	R_KEISAN		; 各計算処理
	MOV	SOBI_NEW_TBL[0],DX	; 装備新たなる表示（武器，鎧，兜）

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	CX,WIDOFS_ITEM		; アイテムテーブル
	MOV	BX,1			; 装備種別 1=防具・兜
	MOV	S_FUNC,73		; 73=装備・ＧＥＴ
	CALLC	R_KEISAN		; 各計算処理
	MOV	SOBI_NEW_TBL[2],DX	; 装備新たなる表示（武器，鎧，兜）

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	CX,WIDOFS_ITEM		; アイテムテーブル
	MOV	BX,2			; 装備種別 2=防具・鎧
	MOV	S_FUNC,73		; 73=装備・ＧＥＴ
	CALLC	R_KEISAN		; 各計算処理
	MOV	SOBI_NEW_TBL[4],DX	; 装備新たなる表示（武器，鎧，兜）

	RET
GET_SOUBI	ENDP


; ****************************************************
;	行き先ＰＲＩＮＴ
;	-I- WHERE_NOW : 場所 1=近郊,2=辺境,3=蛮地
; ****************************************************

GO_PRINT	PROC	NEAR
	CMP	WHERE_NOW,1		; 場所 1=近郊
	JE	GO_PRINT_3
	CMP	WHERE_NOW,2		; 場所 2=辺境
	JE	GO_PRINT_4
	CMP	WHERE_NOW,3		; 場所 3=蛮地
	JE	GO_PRINT_5
	JMP	GO_PRINT_EXIT
GO_PRINT_3:
	MOV	SI,OFFSET MES_KINKOH	; "近郊"
	JMP	GO_PRINT_7		;
GO_PRINT_4:
	MOV	SI,OFFSET MES_HENKYO	; "辺境"
	JMP	GO_PRINT_7		;
GO_PRINT_5:
	MOV	SI,OFFSET MES_BANCHI	; "蛮地"
GO_PRINT_7:
	PUSH	SI
	MOV	AX,WHERE_XX		; 行き先表示Ｘ
	MOV	BX,WHERE_YY		; 行き先表示Ｙ
	MOV	CX,4			; 文字長さ
	MOV	DX,0			; 文字サイズ 0=16x16
	MOV	DI,4			; カラー
	MOV	SI,DI			; カラー２
	CALLC	DSPSTR_CLR		; 文字列表示クリア
	POP	SI

	MOV	AX,WHERE_XX		; 行き先表示Ｘ
	MOV	BX,WHERE_YY		; 行き先表示Ｙ
	CALLC	VTXPOR			; vram text print OR.
GO_PRINT_EXIT:
	RET
GO_PRINT	ENDP

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	ADV_BTN_XX:WORD			; ボタンＸ座標
EXTRN	ADV_BTN_YY:WORD			; ボタンＹ座標

EXTRN	S_FUNC:WORD		; 計算ファンクション

		;	  0   1   2
SOBI_XX		DB	  4,  8, 12
SOBI_YY		DB	  0,  0,  0

;*;SOBI_DSP_TBL	DW	0,0,0		; 装備現在表示（武器，鎧，兜）
SOBI_NEW_TBL	DW	0,0,0		; 装備新たなる表示（武器，鎧，兜）

PXX		DW	0		; 座標Ｘ
PYY		DW	0		; 座標Ｙ
PLOC		DW	0		; ロケート番号
PNM		DW	0		; パターン番号
ITEM_OFS	DW	0		; アイテムオフセット

WHERE_NOW	DW	0		; 場所 1=近郊,2=辺境,3=蛮地
WHERE_DSP	DW	0		; 場所表示 1=近郊,2=辺境,3=蛮地

MES_KINKOH	DB	"近郊",0
MES_HENKYO	DB	"辺境",0
MES_BANCHI	DB	"蛮地",0

DATA	ENDS

	END
;
;	end of "WIDBAR.ASM"
;
