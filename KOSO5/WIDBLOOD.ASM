; "WIDBLOOD.ASM" PC-9801UV11 make by R.H 1991/04/22
;
;
;	「子育て」
;
;	血液型入力ウインドウ
;
;
;	WIDBROOD_SET			; WINDOWS/血液型入力
;
;
; (C) 1990,1991 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO4\WORDID.INC

OFFF		EQU	0FFFFH	; とりあえずＯＦＦという意味

BLOOD_A_XX	EQU	26			; Ａ・Ｘ
BLOOD_A_YY	EQU	238			; Ａ・Ｙ
BLOOD_A_XL	EQU	26+2			; Ａ・Ｘ２
BLOOD_A_YL	EQU	238+16			; Ａ・Ｙ２

BLOOD_B_XX	EQU	26+8			; Ｂ・Ｘ
BLOOD_B_YY	EQU	238			; Ｂ・Ｙ
BLOOD_B_XL	EQU	26+8+2			; Ｂ・Ｘ２
BLOOD_B_YL	EQU	238+16			; Ｂ・Ｙ２

BLOOD_AB_XX	EQU	26+8+8			; Ａ・ＢＸ
BLOOD_AB_YY	EQU	238			; Ａ・ＢＹ
BLOOD_AB_XL	EQU	26+8+8+4		; Ａ・ＢＸ２
BLOOD_AB_YL	EQU	238+16			; Ａ・ＢＹ２

BLOOD_O_XX	EQU	27+8+8+8		; Ｏ・Ｘ
BLOOD_O_YY	EQU	238			; Ｏ・Ｙ
BLOOD_O_XL	EQU	27+8+8+8+2		; Ｏ・Ｘ２
BLOOD_O_YL	EQU	238+16			; Ｏ・Ｙ２


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

; ****************************************************
;	ＷＳＥＬＥＣＴ	＜指定文字列＞
;	SELECT	"話す,渡す,行く"
;	結果は WIDSNM （ユーザ選択番号）に反映される
;	             : =FFFFH : 指定なし
; ****************************************************

WSELECT	MACRO	SSSS
	LOCAL	L1,L2
	JMP	L2
DATA	SEGMENT	PUBLIC	'DATA'
	EXTRN	WIDSNM:WORD		; セレクト・ウインドウ／ユーザ選択番号
L1	DB	SSSS,0
DATA	ENDS
L2:
	MOV	AX,DS			; テキストバッファセグメント
	MOV	ES,AX			;
	MOV	BX,OFFSET L1		; 表示単語アドレス
	CALL	WWWIDSLC2		; セレクト・ｳｲﾝﾄﾞｳ（簡易指定）
	ENDM

;	ＰＲＸＹＺ	文字列,ＶＡＬ,文字列2,ＶＡＬ2,文字列3,ＶＡＬ3
;	（改行有りワード値プリント１０進）

PRXYZ	MACRO	STRING,PARAM,STRING2,PARAM2,STRING3,PARAM3
	LOCAL	L1,L2,L3,L4
	PUSH	SI
	PUSH	DX
	JMP	L4
DATA	SEGMENT	PUBLIC	'DATA'
	EVEN
L1	DB	STRING,0
L2	DB	STRING2,0
L3	DB	STRING3,0
	EVEN
DATA	ENDS

L4:	MOV	SI,OFFSET L1
	CALL	PRINT
	MOV	DX,PARAM
	CALL	DECSTR
	CALL	PRINT
	MOV	SI,OFFSET L2
	CALL	PRINT
	MOV	DX,PARAM2
	CALL	DECSTR
	CALL	PRINT
	MOV	SI,OFFSET L3
	CALL	PRINT
	MOV	DX,PARAM3
	CALL	DECSTR
	CALL	PRINT
	POP	DX
	POP	SI
	CALL	LFPRN	; line feed.
	ENDM

MOVE_SET	MACRO	SOUID,DESTID,X1,Y1,X2,Y2,X3,Y3
	MOV	AX,WORD PTR SOUID[0]
	MOV	SSSOU0,AX
	MOV	AX,WORD PTR SOUID[2]
	MOV	SSSOU1,AX
	MOV	AX,WORD PTR SOUID[4]
	MOV	SSSOU2,AX
	MOV	AX,WORD PTR SOUID[6]
	MOV	SSSOU3,AX
	MOV	AX,WORD PTR DESTID[0]
	MOV	SSDES0,AX
	MOV	AX,WORD PTR DESTID[2]
	MOV	SSDES1,AX
	MOV	AX,WORD PTR DESTID[4]
	MOV	SSDES2,AX
	MOV	AX,WORD PTR DESTID[6]
	MOV	SSDES3,AX
	MOV	AX,X1
	MOV	WORD PTR VX1,AX
	MOV	AX,Y1
	MOV	WORD PTR VY1,AX
	MOV	AX,X2
	MOV	WORD PTR VX2,AX
	MOV	AX,Y2
	MOV	WORD PTR VY2,AX
	MOV	AX,X3
	MOV	WORD PTR VX3,AX
	MOV	AX,Y3
	MOV	WORD PTR VY3,AX
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
;	血液型入力
;	-O- AX : 0=通常,1=スキップ,2=キャンセル
; ****************************************************

FUNC	WWIDBROOD_SET,WIDBROOD_SET
	CALL	BROOD_OPEN		; 血液型入力ＯＰＥＮ

	CALL	BROOD_MAIN		; 血液型入力ＭＡＩＮ
	CMP	AX,1			; 1=キャンセル
	JE	WIDBROOD_SET_CANCEL	;

	CALL	BROOD_CLOSE		; 血液型入力ＣＬＯＳＥ

	MOV	AX,0			; 0=通常
	RET
WIDBROOD_SET_CANCEL:
	MOV	AX,2			; 2=キャンセル
	RET
FEND	WWIDBROOD_SET


; ****************************************************
;	血液型入力ＯＰＥＮ
; ****************************************************

BROOD_OPEN	PROC	NEAR
	MOV	AX,40			; 40/60秒でロード
	CALLC	TMVSET			; V-SYNC timer set.

	CALLC	VRMWT1			; ＶＲＡＭ１アクセス

	CALLC	PT_OPEN_NAME		; 名前入力フレーム

;*;	MOVE_SET ARAVRM,ARA001,13,120,53,260,13,120
	MOVE_SET ARAVRM,ARA001,0,0,80,400,0,0
	CALLC	MOVEVR			; vram to vram move.

	CALLC	VRMWT0			; ＶＲＡＭ０アクセス

;*;	MOVE_SET ARA001,ARAVRM,13,120,53,260,13,120
	MOVE_SET ARA001,ARAVRM,0,0,80,400,0,0
;*;	CALLC	OVLAP			; オーバラップ
	CALLC	TMVEWT			; V-SYNC timer end wait.
	CALLC	MOVEVR			; vram to vram move.


	MOV	DISP_BLOOD_NUM,1		; 表示中の血液型
	CALL	BLOOD_TYPE_SHOW			; 血液型の表示
	MOV	DISP_BLOOD_NUM,2		; 表示中の血液型
	CALL	BLOOD_TYPE_SHOW			; 血液型の表示
	MOV	DISP_BLOOD_NUM,3		; 表示中の血液型
	CALL	BLOOD_TYPE_SHOW			; 血液型の表示
	MOV	DISP_BLOOD_NUM,4		; 表示中の血液型
	CALL	BLOOD_TYPE_SHOW			; 血液型の表示

	MOV	DX,3			; 3="blood type  （むすめの血液型）"
	CALLC	WIDNAME_MESSAGE		; WINDOWS/名前ウインドウ・メッセージ

;*;	MOV	DX,12			;
;*;	CALLC	PT_PALET_ST		; パレットのセット

	RET
BROOD_OPEN	ENDP


; ****************************************************
;	血液型入力ＣＬＯＳＥ
; ****************************************************

BROOD_CLOSE	PROC	NEAR
	RET
BROOD_CLOSE	ENDP


; ****************************************************
;	血液型入力ＭＡＩＮ
;	-O- AX        : 1=キャンセル
; ****************************************************

BROOD_MAIN	PROC	NEAR
	CALL	WID_SLCT		; マウスセレクト
	CMP	AX,1			; 1=キャンセル
	JE	BROOD_MAIN_CANCEL	;

	CALL	BLOOD_SETER		; 血液型データベースＳＥＴ

	MOV	AX,0
	RET
BROOD_MAIN_CANCEL:
	MOV	AX,1			; 1=キャンセル
	RET
BROOD_MAIN	ENDP


; ****************************************************
;	マウスセレクト
;	-O- AX        : 1=キャンセル
; ****************************************************

WID_SLCT	PROC	NEAR
	MOV	DISP_SLCT_NUM,OFFF	; 表示中の血液型

	CALLC	MSCWAT			; カーソルボタンＯＦＦ待ち

	CALLC	MSCSRT			; カーソルスタート
WID_SLCT_LOOP:
	CALLC	MSCMOV			; カーソル移動
	CMP	DL,1			; 右ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	WID_SLCT_1		;
	JMP	WID_SLCT_CANCEL		;
WID_SLCT_1:				;
	CMP	DH,1			; 左ボタン（1：ＯＦＦ／0：ＯＮ）
	JE	WID_SLCT_2		;
	JMP	WID_SLCT_ON		;
WID_SLCT_2:				;
	MOV	MOUSEX,AX		; マウスＸ
	MOV	MOUSEY,BX		; マウスＹ
	MOV	MOUSEFLAG,OFFF		; マウスＯＮ／ＯＦＦフラグ

	CALL	BLOOD_SCH		; サーチ・血液型
	CALL	BLOOD_SHOW		; 血液型の選択表示
	MOVX	BLOOD_TYPE,NOW_SLCT_NUM	; 選択された血液型
WID_SLCT_NEXT:
	JMP	WID_SLCT_LOOP		;

WID_SLCT_ON:
	CMP	BLOOD_TYPE,0		; 選択された血液型
	JE	WID_SLCT_LOOP		;

	MOVX	NOW_SLCT_NUM,BLOOD_TYPE	; 選択された血液型
	CALL	BLOOD_SHOW		; 血液型の選択表示
WID_SLCT_EXIT:
	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,0			;
	RET
WID_SLCT_CANCEL:
	CALLC	MSCSTP			; カーソルストップ
	MOV	AX,1			; 1=キャンセル
	RET
WID_SLCT	ENDP



; ****************************************************
;	サーチ・血液型
;	-O- AX           : 0=無し,1=一致した
;	    NOW_SLCT_NUM : 選択された血液型(0=無し)
; ****************************************************

BLOOD_SCH	PROC	NEAR
	MOV	NOW_SLCT_NUM,0			; 選択された血液型

	MOV	CX,4				;
BLOOD_SCH_LOOP:
	INC	NOW_SLCT_NUM			; 選択された血液型

	MOV	SI,NOW_SLCT_NUM			; 選択された血液型
	SHL	SI,1				; word pointer.

	MOV	AX,MOUSEX			; マウスＸ
	MOV	BX,MOUSEY			; マウスＹ

	CMP	AX,DS:BLOOD_DSP_XX_TBL[SI]	; 血液型の表示Ｘ
	JB	BLOOD_SCH_55
	CMP	AX,DS:BLOOD_DSP_X2_TBL[SI]	; 血液型の表示Ｘ２
	JNBE	BLOOD_SCH_55
	CMP	BX,DS:BLOOD_DSP_YY_TBL[SI]	; 血液型の表示Ｙ
	JB	BLOOD_SCH_55
	CMP	BX,DS:BLOOD_DSP_Y2_TBL[SI]	; 血液型の表示Ｙ２
	JNBE	BLOOD_SCH_55
	JMP	BLOOD_SCH_SEARCH
BLOOD_SCH_55:
	LOOP	BLOOD_SCH_LOOP

	JMP	BLOOD_SCH_NONE
BLOOD_SCH_SEARCH:
	MOV	AX,1				; 1=一致した
	RET
BLOOD_SCH_NONE:
	MOV	NOW_SLCT_NUM,0			;
	MOV	AX,0				; 0=無し
	RET
BLOOD_SCH	ENDP



; ****************************************************
;	血液型の選択表示
;	-I-   NOW_SLCT_NUM : 選択された血液型
;	-I/O- DISP_SLCT_NUM: 表示中の血液型
; ****************************************************

BLOOD_SHOW	PROC	NEAR
	CMPX	DISP_SLCT_NUM,NOW_SLCT_NUM	; 選択された血液型
	JNE	BLOOD_SHOW_START		;
	RET
BLOOD_SHOW_START:
	CALLC	MSCSTP				; カーソルストップ
	MOVX	DISP_BLOOD_NUM,DISP_SLCT_NUM	; 表示中の血液型
	CALL	BLOOD_TYPE_SHOW			; 血液型の表示

	MOVX	DISP_BLOOD_NUM,NOW_SLCT_NUM	; 選択された血液型
	CALL	BLOOD_TYPE_GOLD			; 血液型ＧＯＬＤ

	MOVX	DISP_SLCT_NUM,NOW_SLCT_NUM	; 選択された血液型
	CALLC	MSCSRT				; カーソルスタート
	RET
BLOOD_SHOW	ENDP


; ****************************************************
;	血液型の表示
;	-I- DISP_BLOOD_NUM : 表示する血液型
; ****************************************************

BLOOD_TYPE_SHOW	PROC	NEAR
	CMP	DISP_BLOOD_NUM,0		; 表示する血液型
	JE	BLOOD_TYPE_SHOW_EXIT		;
	CMP	DISP_BLOOD_NUM,4		;
	JNBE	BLOOD_TYPE_SHOW_EXIT		;

BLOOD_TYPE_SHOW_START:
	MOV	SI,DISP_BLOOD_NUM		; 表示する血液型
	SHL	SI,1				; word pointer.
	MOV	AX,DS:BLOOD_DSP_XX_TBL[SI]	; 血液型の表示Ｘ
	MOV	BX,DS:BLOOD_DSP_YY_TBL[SI]	; 血液型の表示Ｙ
	MOV	SI,DS:BLOOD_DSP_STR_TBL[SI]	; 血液型の表示文字
	CALL	STRING_PUT			; 文字列ＰＵＴ
BLOOD_TYPE_SHOW_EXIT:
	RET
BLOOD_TYPE_SHOW	ENDP


; ****************************************************
;	血液型ＧＯＬＤ
;	-I- DISP_BLOOD_NUM : 表示する血液型
; ****************************************************

BLOOD_TYPE_GOLD	PROC	NEAR
	CMP	DISP_BLOOD_NUM,0		; 表示する血液型
	JE	BLOOD_TYPE_GOLD_EXIT		;
	CMP	DISP_BLOOD_NUM,4		;
	JNBE	BLOOD_TYPE_GOLD_EXIT		;

BLOOD_TYPE_GOLD_START:
	MOV	SI,DISP_BLOOD_NUM		; 表示する血液型
	SHL	SI,1				; word pointer.
	MOV	AX,DS:BLOOD_DSP_XX_TBL[SI]	; 血液型の表示Ｘ
	MOV	BX,DS:BLOOD_DSP_YY_TBL[SI]	; 血液型の表示Ｙ
	MOV	SI,DS:BLOOD_DSP_STR_TBL[SI]	; 血液型の表示文字
	CALL	GOLD_STR_PUT			; ＧＯＬＤ文字列ＰＵＴ
BLOOD_TYPE_GOLD_EXIT:
	RET
BLOOD_TYPE_GOLD	ENDP


; ****************************************************
;	文字列ＰＵＴ
;	-I- SI : 文字列
;	    AX : Ｘ
;	    BX : Ｙ
; ****************************************************

STRING_PUT	PROC	NEAR
	CALLC	WIDNAME_PRINT		; WINDOWS/名前ウインドウ文字列表示
	RET
STRING_PUT	ENDP


; ****************************************************
;	ＧＯＬＤ文字列ＰＵＴ
;	-I- SI : 文字列
;	    AX : Ｘ
;	    BX : Ｙ
; ****************************************************

GOLD_STR_PUT	PROC	NEAR
	CALLC	WIDNAME_PRINTG		; WINDOWS/名前ウインドウ文字列ＧＯＬＤ
	RET
GOLD_STR_PUT	ENDP


; ****************************************************
;	血液型データベースＳＥＴ
;	-I- BLOOD_TYPE : 1=Ａ型,2=Ｂ型,3=ＡＢ型,4=Ｏ型
; ****************************************************

BLOOD_SETER	PROC	NEAR
	CMP	BLOOD_TYPE,1			; 血液型
	JE	BLOOD_SETER_TYPE_A		;
	CMP	BLOOD_TYPE,2			; 血液型
	JE	BLOOD_SETER_TYPE_B		;
	CMP	BLOOD_TYPE,3			; 血液型
	JE	BLOOD_SETER_TYPE_AB		;
	CMP	BLOOD_TYPE,4			; 血液型
	JE	BLOOD_SETER_TYPE_O		;

	JMP	BLOOD_SETER_EXIT

BLOOD_SETER_TYPE_A:
	WD_ADRS		ID_104,BLOOD_TYPE_ADRS	; Ａ型
	JMP	BLOOD_SETER_SET			;
BLOOD_SETER_TYPE_B:
	WD_ADRS		ID_106,BLOOD_TYPE_ADRS	; Ｂ型
	JMP	BLOOD_SETER_SET			;
BLOOD_SETER_TYPE_AB:
	WD_ADRS		ID_105,BLOOD_TYPE_ADRS	; ＡＢ型
	JMP	BLOOD_SETER_SET			;
BLOOD_SETER_TYPE_O:
	WD_ADRS		ID_107,BLOOD_TYPE_ADRS	; Ｏ型
	JMP	BLOOD_SETER_SET			;
BLOOD_SETER_SET:


	; データベース

	; (1) ヘッダー

	MOV	BX,WIDMY_GIRL_OF		; 私の娘アドレス BX=ヘッダー

	; (2) 名前

	MOV	ES,SEGWID			; ＷＩＮＤＯＷＳセグメント
	MOV	DI,ES:[BX][HED_VA_OFS]		; DI=内容表示テーブルオフセット

	; (3) 内容テーブルへアクセス

	MOV	DX,BLOOD_TYPE_ADRS		; 血液型アドレス（環境文字列）
	MOV	ES:[DI][VTB_KETUEKI][VAL_VALUE],DX	; 2. 血液型

BLOOD_SETER_EXIT:
	RET
BLOOD_SETER	ENDP



WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

BLOOD_TYPE	DW	2			; 血液型
						; 1=Ａ型,2=Ｂ型,3=ＡＢ型,4=Ｏ型
BLOOD_TYPE_ADRS	DW	0			; 血液型アドレス


NOW_SLCT_NUM	DW	0			; 選択された血液型
DISP_SLCT_NUM	DW	0			; 表示中の血液型

DISP_BLOOD_NUM	DW	0			; 表示する血液型


;		1=Ａ型
;		2=Ｂ型
;		3=ＡＢ型
;		4=Ｏ型

BLOOD_DSP_XX_TBL	LABEL	WORD		; 血液型の表示Ｘ
		DW	BLOOD_A_XX		; base0.
		DW	BLOOD_A_XX
		DW	BLOOD_B_XX
		DW	BLOOD_AB_XX
		DW	BLOOD_O_XX

BLOOD_DSP_YY_TBL	LABEL	WORD		; 血液型の表示Ｙ
		DW	BLOOD_A_YY		; base0.
		DW	BLOOD_A_YY
		DW	BLOOD_B_YY
		DW	BLOOD_AB_YY
		DW	BLOOD_O_YY

BLOOD_DSP_X2_TBL	LABEL	WORD		; 血液型の表示Ｘ２
		DW	BLOOD_A_XL		; base0.
		DW	BLOOD_A_XL
		DW	BLOOD_B_XL
		DW	BLOOD_AB_XL
		DW	BLOOD_O_XL

BLOOD_DSP_Y2_TBL	LABEL	WORD		; 血液型の表示Ｙ２
		DW	BLOOD_A_YL		; base0.
		DW	BLOOD_A_YL
		DW	BLOOD_B_YL
		DW	BLOOD_AB_YL
		DW	BLOOD_O_YL

BLOOD_DSP_STR_TBL	LABEL	WORD		; 血液型の表示文字
		DW	OFFSET STR_TYPE_A	; base0.
		DW	OFFSET STR_TYPE_A	; "Ａ",0,0
		DW	OFFSET STR_TYPE_B	; "Ｂ",0,0
		DW	OFFSET STR_TYPE_AB	; "ＡＢ",0,0
		DW	OFFSET STR_TYPE_O	; "Ｏ",0,0
STR_TYPE_A	DB	"Ａ",0,0
STR_TYPE_B	DB	"Ｂ",0,0
STR_TYPE_AB	DB	"ＡＢ",0,0
STR_TYPE_O	DB	"Ｏ",0,0

		EVEN
MOUSEFLAG	DW	0		; マウスＯＮ／ＯＦＦフラグ
MOUSEX		DW	0		; マウスＸ
MOUSEY		DW	0		; マウスＹ



DATA	ENDS

	END
;
;	end of "WIDBLOOD.ASM"
;
