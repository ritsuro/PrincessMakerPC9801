; "STFROLL.ASM" PC-9801UV11 make by R.H 1991/05/08
;
;
;	「子育て」
;
;	スタッフ・ロール
;
;	STFROLL			; スタッフ・ロール
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	..\KOSO\KOSO2.INC
INCLUDE	KOSO3.INC
INCLUDE	..\KOSO6\KYOKU.INC

SPEED_SCROLL	EQU	4		; スクロールスピード

TM_PRINT	EQU	60+30		; プリント時間

TXT_SIZ		EQU	0		; 文字サイズ 0=16x16
TXT_COL		EQU	15		; 文字色

ROLL_X_ADJST	EQU	18		; ロール位置調整
ROLL_ONE_HIGHT	EQU	400		; ロールの長さ

ROLL_BAIND	EQU	100		; ロールの継目を通る高さ
ROLL_BAIND_OUT	EQU	400		; ロールの継目を越した高さ

VIEW_START	EQU	50		; 見せる高さ位置
VIEW_HIGHT	EQU	300		; 見せる高さ

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

TTIME_SET2	MACRO	TTT
	MOV	AX,TTT		; wait timer count.
	CALL	TTMVST3		; V-SYNC timer3 set.
	ENDM

TTIME_WAIT2	MACRO
	LOCAL	L1,L2
L1:
	TEST	BYTE PTR KYTBLS[0],1B		; key code「ESC」
	JNZ	L2		; skip
	CALL	TTMVCK3		; V-SYNC timer3 check.
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
;	スタッフ・ロール
;	-I- ES : テキストセグメント
;	    BX : アドレス
;	    CX : ロール長さ
; ****************************************************

FUNC	SSTFROLL,STFROLL
	MOV	SEGTXT,ES		; テキストセグメント
	MOV	TXTTOP,BX		; テキストの先頭
	MOV	ROLL_LENGHT,CX		; ロール長さ

	CALL	ROLL_MAIN		; スタッフロール・メイン

	RET
FEND	SSTFROLL


; ****************************************************
;	スタッフロール・メイン
;	-I- SEGTXT : テキストセグメント
;	    TXTTOP : テキストの先頭
;	    ROLL_LENGHT : ロール長さ
; ****************************************************

ROLL_MAIN	PROC	NEAR

	TTIME_SET2	TM_PRINT	; プリント時間

	MOV	AX,ARA001[0]
	MOV	BX,ARA001[2]
	MOV	CX,ARA001[4]
	MOV	DX,ARA001[6]
	MOV	SSSOUR,AX		; source data segment.
	MOV	SSSOU0,AX
	MOV	SSSOU1,BX
	MOV	SSSOU2,CX
	MOV	SSSOU3,DX

	MOV	AX,ARAVRM[0]
	MOV	BX,ARAVRM[2]
	MOV	CX,ARAVRM[4]
	MOV	DX,ARAVRM[6]
	MOV	SSDEST,AX		; destination data segment.
	MOV	SSDES0,AX
	MOV	SSDES1,BX
	MOV	SSDES2,CX
	MOV	SSDES3,DX

	MOV	VR_MODE,2		; ＶＲＡＭモード 2=仮想プレーン１
	CALL	VRMSEGCHG		; 書き込みＶＲＡＭ切り替え

	MOV	VX1,0			; start point.
	MOV	VY1,0			; start point.
	MOV	VX2,79			; end point.
	MOV	VY2,399			; end point.
	MOV	CX,0			; color palet number.
	CALLC	BOXPAL			; ＢＯＸペイント

	CALL	ROLL_1_PRINT		; スタッフロール１ページＰＲＩＮＴ

	MOV	VR_MODE,1		; ＶＲＡＭモード 1=ＶＲＡＭ
	CALL	VRMSEGCHG		; 書き込みＶＲＡＭ切り替え

;*;	CALL	ROLL_1_PRINT		; スタッフロール１ページＰＲＩＮＴ

	CALLC	PLTINTWT		; パレット・割込み処理終了待ち
					; ENDING.ASM 288行を見よ
	TTIME_WAIT2

	CALLC	VRMWT1			; ＶＲＡＭ１アクセス
	CALLC	VRMCLR			;
	CALLC	VRMWT0			; ＶＲＡＭ０アクセス
	CALLC	VRMCLR			;

	CALLC	P_WHITE			; 白

	CALL	ROLL_1_SCROLL		; スタッフロール１ページスクロール
ROLL_MAIN_EXIT:
	RET
ROLL_MAIN	ENDP



; ****************************************************
;	スタッフロール１ページＰＲＩＮＴ
; ****************************************************

ROLL_1_PRINT	PROC	NEAR
	MOV	DISPXX,0		; ポイントＸ
	MOV	DISPYY,0		; ポイントＹ
	MOVX	NOWPNT,TXTTOP		; テキストの先頭
ROLL_1_PRINT_LOOP:
	CALL	STR_1LINE_GET		; 文字列１ラインＧＥＴ
	CMP	AX,1			; 1=ラスト
	JE	ROLL_1_PRINT_LP_E	;

	CALL	STR_1LINE_PRINT		; 文字列１ラインＰＲＩＮＴ

	ADD	DISPYY,20		; ポイントＹ
	CMP	DISPYY,400-20		; ポイントＹ
	JBE	ROLL_1_PRINT4		;

	MOV	DISPXX,40		; ポイントＸ
	MOV	DISPYY,0		; ポイントＹ

ROLL_1_PRINT4:
	JMP	ROLL_1_PRINT_LOOP
ROLL_1_PRINT_LP_E:
	RET
ROLL_1_PRINT	ENDP



; ****************************************************
;	スタッフロール１ページスクロール
;	-I- ROLL_LENGHT : ロール長さ
; ****************************************************

ROLL_1_SCROLL	PROC	NEAR
	MOV	ROLL_HI1,-299

	MOV	CX,ROLL_LENGHT		; ロール長さ
	ADD	CX,299			;
	SHR	CX,1			; /2
	SHR	CX,1			; /2
ROLL_1_SCROLL_LOOP:
	PUSH	CX

	CALLC	VRMDP0			; ＶＲＡＭ０表示
	CALLC	VRMWT1			; ＶＲＡＭ１アクセス

	TTIME_SET	SPEED_SCROLL	; スクロールスピード

	CALL	VRAM_MOV_CALC		; ＶＲＡＭ転送計算
	INC	ROLL_HI1		; ロール高さ位置
	INC	ROLL_HI1		; ロール高さ位置
	CALL	ROLL_1_RIGHT		; 右側ロール
	CALL	ROLL_1_LEFT		; 左側ロール

	TTIME_WAIT
	CALLC	VRMDP1			; ＶＲＡＭ１表示
	CALLC	VRMWT0			; ＶＲＡＭ０アクセス
	TTIME_SET	SPEED_SCROLL	; スクロールスピード

	CALL	VRAM_MOV_CALC		; ＶＲＡＭ転送計算
	INC	ROLL_HI1		; ロール高さ位置
	INC	ROLL_HI1		; ロール高さ位置
	CALL	ROLL_1_RIGHT		; 右側ロール
	CALL	ROLL_1_LEFT		; 左側ロール

	TTIME_WAIT

	POP	CX
	LOOP	ROLL_1_SCROLL_LOOP	;

	CALLC	VRMDP0			; ＶＲＡＭ０表示

	RET
ROLL_1_SCROLL	ENDP


; ****************************************************
;	ＶＲＡＭ転送計算
;	-I- ROLL_HI1        : ロール高さ位置
;	-O- ROLL_LEFT_FLG   : ロール左フラグ 1=スキップ
;	    ROLL_LEFT_HI    : ロール左高さ位置
;	    ROLL_LEFT_LEN   : ロール左長さ
;	    ROLL_LEFT_DEST  : ロール左の転送先
;	    ROLL_RIGHT_FLG  : ロール右フラグ 1=スキップ
;	    ROLL_RIGHT_HI   : ロール右高さ位置
;	    ROLL_RIGHT_LEN  : ロール右長さ
;	    ROLL_RIGHT_DEST : ロール右の転送先
; ****************************************************

VRAM_MOV_CALC	PROC	NEAR
	CMP	ROLL_HI1,ROLL_BAIND_OUT		; ロールの継目を越した高さ
	JMPGE	VRAM_MOV_CALC_CASE3		;

	CMP	ROLL_HI1,ROLL_BAIND		; ロールの継目を通る高さ
	JGE	VRAM_MOV_CALC_CASE2		;

	CMP	ROLL_HI1,0			; ロールの継目前
	JGE	VRAM_MOV_CALC_CASE1		;

VRAM_MOV_CALC_CASE0:				;0.出始め
	MOV	ROLL_LEFT_FLG,0			; ロール左フラグ
	MOV	ROLL_RIGHT_FLG,1		; ロール右フラグ 1=スキップ

	MOV	ROLL_LEFT_HI,0			; ロール左高さ位置

	MOV	AX,VIEW_HIGHT			; 見せる高さ
	ADD	AX,ROLL_HI1			; ロール高さ位置(減算になる)
	MOV	ROLL_LEFT_LEN,AX		; ロール左長さ

	MOV	AX,VIEW_START			; 見せる高さ位置
	ADD	AX,VIEW_HIGHT			; 見せる高さ
	SUB	AX,ROLL_LEFT_LEN		; ロール左長さ
	MOV	ROLL_LEFT_DEST,AX		; ロール左の転送先
	JMP	VRAM_MOV_CALC_EXIT		;

VRAM_MOV_CALC_CASE1:				;1.ロールの継目前
	MOV	ROLL_LEFT_FLG,0			; ロール左フラグ
	MOV	ROLL_RIGHT_FLG,1		; ロール右フラグ 1=スキップ
	MOVX	ROLL_LEFT_HI,ROLL_HI1		; ロール左高さ位置
	MOV	ROLL_LEFT_LEN,VIEW_HIGHT	; ロール左長さ
	MOV	ROLL_LEFT_DEST,VIEW_START	; ロール左の転送先
	JMP	VRAM_MOV_CALC_EXIT		;

VRAM_MOV_CALC_CASE2:				;2.ロールの継目を通る高さ

	MOV	ROLL_LEFT_FLG,0			; ロール左フラグ
	MOV	ROLL_RIGHT_FLG,0		; ロール右フラグ

	MOVX	ROLL_LEFT_HI,ROLL_HI1		; ロール左高さ位置

	MOV	AX,ROLL_ONE_HIGHT		; －ロールの長さ
	SUB	AX,ROLL_HI1			; ロール左高さ位置
	MOV	ROLL_LEFT_LEN,AX		; ロール左長さ

	MOV	ROLL_LEFT_DEST,VIEW_START	; ロール左の転送先


	MOV	ROLL_RIGHT_HI,0		; ロール右高さ位置

	MOV	AX,VIEW_HIGHT			; 見せる高さ
	SUB	AX,ROLL_LEFT_LEN		; ロール左長さ
	MOV	ROLL_RIGHT_LEN,AX		; ロール右長さ

	MOV	AX,VIEW_START			; 見せる高さ位置
	ADD	AX,ROLL_LEFT_LEN		; ロール左長さ
	MOV	ROLL_RIGHT_DEST,AX		; ロール右の転送先

	JMP	VRAM_MOV_CALC_EXIT		;

VRAM_MOV_CALC_CASE3:				;3.ロールの継目を越した高さ
	MOV	ROLL_LEFT_FLG,1			; ロール左フラグ 1=スキップ
	MOV	ROLL_RIGHT_FLG,0		; ロール右フラグ

	MOV	AX,ROLL_HI1			; ロール高さ位置
	SUB	AX,ROLL_ONE_HIGHT		; －ロールの長さ
	MOV	ROLL_RIGHT_HI,AX		; ロール右高さ位置

	MOV	AX,ROLL_ONE_HIGHT		; ロールの長さ
	SUB	AX,ROLL_RIGHT_HI		; ロール右高さ位置
	CMP	AX,VIEW_HIGHT			; 見せる高さ
	JL	VRAM_MOV_CALC_31		;
	MOV	AX,VIEW_HIGHT			; 見せる高さ
VRAM_MOV_CALC_31:				;
	MOV	ROLL_RIGHT_LEN,AX		; ロール右長さ

	MOV	ROLL_RIGHT_DEST,VIEW_START	; ロール右の転送先

VRAM_MOV_CALC_EXIT:
	RET
VRAM_MOV_CALC	ENDP


; ****************************************************
;	左側ロール
;	-I- ROLL_LEFT_FLG   : ロール左フラグ 1=スキップ
;	    ROLL_LEFT_HI    : ロール左高さ位置
;	    ROLL_LEFT_LEN   : ロール左長さ
;	    ROLL_LEFT_DEST  : ロール左の転送先
; ****************************************************

ROLL_1_LEFT	PROC	NEAR
	CMP	ROLL_LEFT_FLG,1		; ロール左フラグ 1=スキップ
	JE	ROLL_1_LEFT_EXIT	;

	MOV	VX1,0			;
	MOVX	VY1,ROLL_LEFT_HI	; ロール左高さ位置

	MOV	VX2,40			;
	MOVX	VY2,ROLL_LEFT_LEN	; ロール左長さ

	MOV	VX3,ROLL_X_ADJST	; ロール位置調整
	MOVX	VY3,ROLL_LEFT_DEST	; ロール左の転送先

	CALL	MOVE_VRAM		; vram to vram move.
ROLL_1_LEFT_EXIT:
	RET
ROLL_1_LEFT	ENDP


; ****************************************************
;	右側ロール
;	-I- ROLL_RIGHT_FLG  : ロール右フラグ 1=スキップ
;	    ROLL_RIGHT_HI   : ロール右高さ位置
;	    ROLL_RIGHT_LEN  : ロール右長さ
;	    ROLL_RIGHT_DEST : ロール右の転送先
; ****************************************************

ROLL_1_RIGHT	PROC	NEAR
	CMP	ROLL_RIGHT_FLG,1	; ロール右フラグ 1=スキップ
	JE	ROLL_1_RIGHT_EXIT	;

	MOV	VX1,40
	MOVX	VY1,ROLL_RIGHT_HI	; ロール右高さ位置

	MOV	VX2,40
	MOVX	VY2,ROLL_RIGHT_LEN	; ロール右長さ

	MOV	VX3,ROLL_X_ADJST	; ロール位置調整
	MOVX	VY3,ROLL_RIGHT_DEST	; ロール右の転送先

	CALL	MOVE_VRAM		; vram to vram move.
ROLL_1_RIGHT_EXIT:
	RET
ROLL_1_RIGHT	ENDP


; ****************************************************
;	文字列１ラインＰＲＩＮＴ
;	-I-   STR_BUFF : 文字列
;	      DISPXX   : ポイントＸ
;	      DISPYY   : ポイントＹ
; ****************************************************

STR_1LINE_PRINT	PROC	NEAR
	MOV	AX,TXT_SIZ		; 文字サイズ 0=16x16
	CALLC	VTXSIZ			; character size set.
	MOV	AX,TXT_COL		; 文字色
	CALLC	VTXCOL			; character color set.

	MOV	SI,OFFSET STR_BUFF	; 文字列
	MOV	AX,DISPXX		;location x point.
	MOV	BX,DISPYY		;location y point.
	CALLC	VTXPOR			; vram text print OR.
	RET
STR_1LINE_PRINT	ENDP


; ****************************************************
;	文字列１ラインＧＥＴ
;	-I/O- NOWPNT   : テキストの現在位置
;	-O-   AX       : 0=通常,1=ラスト
;	      GSTLEN   : テキスト１ライン長さ
;	      STR_BUFF : 文字列
; ****************************************************

STR_1LINE_GET	PROC	NEAR
	CALLC	STRZEROC		; 文字列バッファ０クリア

	MOV	ES,SEGTXT		; テキストセグメント
	MOV	BX,NOWPNT		; テキストの現在位置

STR_1LINE_GET_LOOP00:			;
	MOV	AL,ES:[BX]		; get.
	INC	BX			;
	CMP	AL,0			;
	JE	STR_1LINE_GET_LAST	;
	CMP	AL,'$'			;
	JE	STR_1LINE_GET_LAST	;
	CMP	AL,' '			;
	JB	STR_1LINE_GET_LOOP00	;
	DEC	BX			;

	MOV	DI,0			; pointer.
	MOV	GSTLEN,0		; テキスト１ライン長さ
	MOV	CX,STRING_LEN		; string length.
STR_1LINE_GET_LOOP:			;
	MOV	AL,ES:[BX]		; get 1 char.
	INC	BX			;
	CMP	AL,0DH			; 0Dh,0Ah
	JBE	STR_1LINE_GET_LP_E	;
	CMP	AL,'/'			;
	JNE	STR_1LINE_GET_4		;
	MOV	AL,' '			;
STR_1LINE_GET_4:			;
	MOV	DS:STR_BUFF[DI],AL	; put 1 char.
	INC	DI			;
	LOOP	STR_1LINE_GET_LOOP	;
	DEC	BX			;
STR_1LINE_GET_LP_E:
	MOV	BYTE PTR DS:[DI],0	; end of string.
	INC	BX			;
	MOV	NOWPNT,BX		; テキストの現在位置
	MOV	GSTLEN,DI		; テキスト１ライン長さ

	MOV	AX,0			; 0=通常
	RET
STR_1LINE_GET_LAST:
	MOV	AX,1			; 1=ラスト
	RET
STR_1LINE_GET	ENDP


; ****************************************************
;	書き込みＶＲＡＭ切り替え
;	-I- VR_MODE : ＶＲＡＭモード 1=ＶＲＡＭ,2=仮想プレーン１
; ****************************************************

VRMSEGCHG	PROC	NEAR
	CMP	VR_MODE,1		; ＶＲＡＭモード
	JE	VRMSEGCHG_1		;
	CMP	VR_MODE,2		; ＶＲＡＭモード
	JE	VRMSEGCHG_2		;
	JMP	VRMSEGCHG_EXIT		;

VRMSEGCHG_1:				;
	MOV	AX,ARAVRM[0]		; ＶＲＡＭプレーン
	MOV	BX,ARAVRM[2]		;
	MOV	CX,ARAVRM[4]		;
	MOV	DX,ARAVRM[6]		;
	JMP	VRMSEGCHG_77		;

VRMSEGCHG_2:				;
	MOV	AX,ARA001[0]		; 仮想ＶＲＡＭプレーン１
	MOV	BX,ARA001[2]		;
	MOV	CX,ARA001[4]		;
	MOV	DX,ARA001[6]		;
	JMP	VRMSEGCHG_77		;

VRMSEGCHG_77:
	MOV	SEGVT0,AX		; text put vram segment plean 0.
	MOV	SEGVT1,BX		; text put vram segment plean 1.
	MOV	SEGVT2,CX		; text put vram segment plean 2.
	MOV	SEGVT3,DX		; text put vram segment plean 3.

	MOV	SSEFC0,AX
	MOV	SSEFC1,BX
	MOV	SSEFC2,CX
	MOV	SSEFC3,DX

VRMSEGCHG_EXIT:
	RET
VRMSEGCHG	ENDP



;	vram to vram move.

MOVE_VRAM	PROC	NEAR
	CALLC	MOV1VR		; vram to vram move 1 plean.
;*;	CALLC	MOVEVR		; vram to vram move.
	RET
MOVE_VRAM	ENDP


;	V-SYNC timer2 set.

TTMVST2	PROC	NEAR
	CALLC	TMVST2		; V-SYNC timer2 set.
	RET
TTMVST2	ENDP


;	V-SYNC timer2 check.

TTMVCK2	PROC	NEAR
	CALLC	TMVCK2		; V-SYNC timer2 check.
	RET
TTMVCK2	ENDP


;	V-SYNC timer2 set.

TTMVST3	PROC	NEAR
	CALLC	TMVST3		; V-SYNC timer3 set.
	RET
TTMVST3	ENDP

;	V-SYNC timer2 check.

TTMVCK3	PROC	NEAR
	CALLC	TMVCK3		; V-SYNC timer3 check.
	RET
TTMVCK3	ENDP

R_SEG2	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	SEGVT0:WORD		; text put vram segment plean 0.
EXTRN	SEGVT1:WORD		; text put vram segment plean 1.
EXTRN	SEGVT2:WORD		; text put vram segment plean 2.
EXTRN	SEGVT3:WORD		; text put vram segment plean 3.

EXTRN	SSEFCT:WORD		; visual data segment plean.
EXTRN	SSEFC0:WORD		; visual data segment plean 0
EXTRN	SSEFC1:WORD		; visual data segment plean 1
EXTRN	SSEFC2:WORD		; visual data segment plean 2
EXTRN	SSEFC3:WORD		; visual data segment plean 3

SEGTXT		DW	0	; テキストセグメント
TXTTOP		DW	0	; テキストの先頭

NOWPNT		DW	0	; テキストの現在位置
GSTLEN		DW	0	; テキスト１ライン長さ

DISPXX		DW	0	; ポイントＸ
DISPYY		DW	0	; ポイントＹ

ROLL_LENGHT	DW	800	; ロール長さ

ROLL_HI1	DW	0	; ロール高さ位置

ROLL_LEFT_FLG	DW	0	; ロール左フラグ 1=スキップ
ROLL_LEFT_HI	DW	0	; ロール左高さ位置
ROLL_LEFT_LEN	DW	0	; ロール左長さ
ROLL_LEFT_DEST	DW	0	; ロール左の転送先

ROLL_RIGHT_FLG	DW	0	; ロール右フラグ 1=スキップ
ROLL_RIGHT_HI	DW	0	; ロール右高さ位置
ROLL_RIGHT_LEN	DW	0	; ロール右長さ
ROLL_RIGHT_DEST	DW	0	; ロール右の転送先

VR_MODE		DW	0	; ＶＲＡＭモード

DATA	ENDS

	END
;
;	end of "STFROLL.ASM"
;
