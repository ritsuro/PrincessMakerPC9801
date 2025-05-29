; "R_MAPWID.ASM" PC-9801UV11 make by R.H 1991/02/20
;
;
;	「子育て」
;
;	マップ用ウインドウ
;
;	R_MAPWID		; マップ用メッセージウインドウ
;	R_MAPITM		; マップ用アイテムウインドウ
;
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC
INCLUDE	WORDID.INC

FREAM_X1	EQU	13		; フレーム表示位置Ｘ
FREAM_Y1	EQU	72		; フレーム表示位置Ｙ
FREAM_X2	EQU	28		; フレーム大きさＸ
FREAM_Y2	EQU	60		; フレーム大きさＹ

PRTXT_X1	EQU	15		; フレーム表示位置Ｘ
PRTXT_Y1	EQU	72+16	-4	; フレーム表示位置Ｙ
PRTXT_X2	EQU	15		; フレーム表示位置Ｘ
PRTXT_Y2	EQU	72+16+20-4	; フレーム表示位置Ｙ

IPRTXT_X1	EQU	15+5		; フレーム表示位置Ｘ
IPRTXT_Y1	EQU	72+16	-4	; フレーム表示位置Ｙ
IPRTXT_X2	EQU	15+5		; フレーム表示位置Ｘ
IPRTXT_Y2	EQU	72+16+20-4	; フレーム表示位置Ｙ

ITEM_X2		EQU	15		; フレーム表示位置Ｘ
ITEM_Y2		EQU	72+16-1		; フレーム表示位置Ｙ

TXT_COL		EQU	15		; character color 0-15
TXT_SIZ		EQU	0		; 0=16x16 1=32x32 2=16x24 3=16x32

CUR_LOC_XX	EQU	25		; カーソルＸ座標
CUR_LOC_YY	EQU	72+60-6		; カーソルＹ座標


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
	JMP	L1
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

; ****************************************************
;	その他
; ****************************************************

MOVX	MACRO	DEST,SOUR
	MOV	AX,SOUR
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

R_SEG2	SEGMENT	PUBLIC	'R_SEG2'

	ASSUME	CS:R_SEG2,DS:DATA


; ****************************************************
;	マップ用メッセージウインドウ
;	-I- DX : 立て札番号
; ****************************************************

FUNC	RR_MAPWID,R_MAPWID
	MOV	NUM_TATEFUDA,DX		; 立て札番号
	CALL	FRAME_DRAW		; フレームＤＲＡＷ
	CALL	DISP_KANBAN_MESS	; 立て札メッセージ
	CALL	CUR_WAIT		; カーソルＷＡＩＴ
	RET
FEND	RR_MAPWID


; ****************************************************
;	マップ用アイテムウインドウ
;	-I- DX : 宝箱番号
;	-O- AX : 0=通常,1=いっぱいで持てない
; ****************************************************

FUNC	RR_MAPITM,R_MAPITM
	MOV	NUM_TAKARA,DX		; 宝箱番号
	CALL	FRAME_DRAW		; フレームＤＲＡＷ
	CALL	TAKARA_HAND		; 宝を手に入れた
	CALL	CUR_WAIT		; カーソルＷＡＩＴ
	MOV	AX,ITM_FLAG		; 0=通常,1=いっぱいで持てない
	RET
FEND	RR_MAPITM


; ****************************************************
;	立て札メッセージ
;	-I- NUM_TATEFUDA : 立て札番号
; ****************************************************

DISP_KANBAN_MESS	PROC	NEAR
	MOV	DX,NUM_TATEFUDA		; 立て札番号
	DEC	DX			;
	CMP	DX,KANBAN_MAX		; 立て札数
	JNB	DISP_KANBAN_MESS_EXIT	;

	MOV	BX,DX			;
	SHL	BX,1			;
	SHL	BX,1			; * 4
	MOV	AX,DS:KANBAN_TBL[BX]	; 立て札メッセージテーブル
	MOV	DX,DS:KANBAN_TBL[BX][2]	; 立て札メッセージテーブル
	MOV	MESS_ADRS1,AX		; メッセージアドレス１
	MOV	MESS_ADRS2,DX		; メッセージアドレス２
	CALL	DISP_MESS		; メッセージ表示

DISP_KANBAN_MESS_EXIT:
	RET
DISP_KANBAN_MESS	ENDP


; ****************************************************
;	宝を手に入れた
;	-I- NUM_TAKARA : 宝箱番号
;	-O- ITM_FLAG   : 0=通常,1=いっぱいで持てない
; ****************************************************

TAKARA_HAND	PROC	NEAR
	MOV	DX,NUM_TAKARA		; 宝箱番号
	DEC	DX			;
	CMP	DX,TAKARA_MAX		; 宝箱数
	JNB	TAKARA_HAND_EXIT	;

	MOV	BX,DX			;
	SHL	BX,1			;*2
	MOV	AX,BX			;
	SHL	BX,1			;*4
	ADD	BX,AX			; * 6
	MOV	AX,DS:TAKARA_TBL[BX]	; 宝箱メッセージテーブル
	MOV	CX,DS:TAKARA_TBL[BX][2]	;
	MOV	DX,DS:TAKARA_TBL[BX][4]	;
	MOV	ITEM_NUM,AX		; アイテム番号
	MOV	ITEM_ID,CX		; アイテムＩＤ
	MOV	MESS_ADRS1,DX		; メッセージアドレス１

	CALL	ITEM_MOTSU		; アイテム持つ処理
	MOV	ITM_FLAG,AX		; 0=通常,1=いっぱいで持てない

	CALL	ITEM_PUT		; アイテムＰＵＴ

	CALL	HAVE_ITEM_MESS		; アイテム入手メッセージ
	MOV	MESS_ADRS2,SI		; メッセージアドレス２
	CALL	DISP_I_MESS		; アイテムメッセージ表示

TAKARA_HAND_EXIT:
	RET
TAKARA_HAND	ENDP


; ****************************************************
;	アイテム入手メッセージ
;	-I- ITM_FLAG : 0=通常,1=いっぱいで持てない
;	-O- SI       : メッセージアドレス
; ****************************************************

HAVE_ITEM_MESS	PROC	NEAR
	CMP	ITM_FLAG,1			; 0=通常,1=いっぱいで持てない
	JE	HAVE_ITEM_MESS_DAME		;
	MOV	SI,OFFSET MES_HAVE_01		; "を手に入れた．"
	RET
HAVE_ITEM_MESS_DAME:
	MOV	SI,OFFSET MES_HAVE_02		; "だけど、これ以上持てない"
	RET
HAVE_ITEM_MESS	ENDP


; ****************************************************
;	メッセージ表示
;	-I- MESS_ADRS1 : メッセージアドレス１
;	    MESS_ADRS2 : メッセージアドレス２
; ****************************************************

DISP_MESS	PROC	NEAR
	MOV	AX,TXT_SIZ		; 16x16
	CALLC	VTXSIZ			; character size set.
	MOV	AX,TXT_COL		; character color 0-15
	CALLC	VTXCOL			; character color set.

	MOV	AX,PRTXT_X1		; フレーム表示位置Ｘ
	MOV	BX,PRTXT_Y1		; フレーム表示位置Ｙ
	MOV	SI,MESS_ADRS1		; メッセージアドレス１
	CALLC	VTXPOR			; vram text print OR.

	MOV	AX,PRTXT_X2		; フレーム表示位置Ｘ
	MOV	BX,PRTXT_Y2		; フレーム表示位置Ｙ
	MOV	SI,MESS_ADRS2		; メッセージアドレス２
	CALLC	VTXPOR			; vram text print OR.

	RET
DISP_MESS	ENDP


; ****************************************************
;	アイテムメッセージ表示
;	-I- MESS_ADRS1 : メッセージアドレス１
;	    MESS_ADRS2 : メッセージアドレス２
; ****************************************************

DISP_I_MESS	PROC	NEAR
	MOV	AX,TXT_SIZ		; 16x16
	CALLC	VTXSIZ			; character size set.
	MOV	AX,TXT_COL		; character color 0-15
	CALLC	VTXCOL			; character color set.

	MOV	AX,IPRTXT_X1		; フレーム表示位置Ｘ
	MOV	BX,IPRTXT_Y1		; フレーム表示位置Ｙ
	MOV	SI,MESS_ADRS1		; メッセージアドレス１
	CALLC	VTXPOR			; vram text print OR.

	MOV	AX,IPRTXT_X2		; フレーム表示位置Ｘ
	MOV	BX,IPRTXT_Y2		; フレーム表示位置Ｙ
	MOV	SI,MESS_ADRS2		; メッセージアドレス２
	CALLC	VTXPOR			; vram text print OR.

	RET
DISP_I_MESS	ENDP


; ****************************************************
;	アイテムＰＵＴ
;	-I- ITEM_NUM : アイテム番号
; ****************************************************

ITEM_PUT	PROC	NEAR
	MOV	AX,ITEM_X2		; フレーム表示位置Ｘ
	MOV	BX,ITEM_Y2		; フレーム表示位置Ｙ
	MOV	DX,ITEM_NUM		; アイテム番号
	CALLC	PT_PUT_ITEM		; アイテムＰＵＴ
	RET
ITEM_PUT	ENDP


; ****************************************************
;	フレームＤＲＡＷ
; ****************************************************

FRAME_DRAW	PROC	NEAR
	MOV	WDX1,FREAM_X1		; フレーム表示位置Ｘ
	MOV	WDY1,FREAM_Y1		; フレーム表示位置Ｙ
	MOV	WDX2,FREAM_X2		; フレーム大きさＸ
	MOV	WDY2,FREAM_Y2		; フレーム大きさＹ
	CALLC	WID_5_FLAME		; WINDOWS/フレーム５（宝石）
	RET
FRAME_DRAW	ENDP


; ****************************************************
;	カーソルＷＡＩＴ
; ****************************************************

CUR_WAIT	PROC	NEAR
	CMP	RRMAPWIDEMO,55		; 0=通常,55=ランダムセレクト
	JNE	CUR_WAIT_1		;
	RET
CUR_WAIT_1:
	CALLC	MSCWATTM	; カーソルボタンＯＦＦ待ち（待ちタイマ付き）
	MOV	AX,CUR_LOC_XX		; カーソルＸ座標
	MOV	BX,CUR_LOC_YY		; カーソルＹ座標
	CALLC	MSWWAT			; カーソルボタン待ち
	RET
CUR_WAIT	ENDP


; ****************************************************
;	アイテム持つ処理
;	-I- ITEM_ID : アイテムＩＤ
;	-O- AX      : 0=通常,1=いっぱいで持てない
; ****************************************************

ITEM_MOTSU	PROC	NEAR
	MOV	AX,ITEM_ID		; アイテムＩＤ
	MOV	DX,4			; 4=道具
	CALLC	R_ITEM_NMSH		; 名前でアイテム検索
	MOV	ITEM_NO,DX		; アイテムＮＯ．

	MOV	AX,WIDMY_GIRL_OF	; 私の娘アドレス
	MOV	CX,4			; 4=道具
	MOV	DX,ITEM_NO		; アイテムＮＯ．
	CALLC	R_ITM_MOCH_INS		; 持物アイテム追加

	CMP	AX,2			; 2=いっぱいで持てません
	JE	ITEM_MOTSU_NAI		;

ITEM_MOTSU_NORMAL:
	MOV	AX,0			; 0=通常
	RET
ITEM_MOTSU_NAI:
	MOV	AX,1			; 1=いっぱいで持てない
	RET
ITEM_MOTSU	ENDP


R_SEG2	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	RRMAPWIDEMO		; (R_MAPWID.ASM)デモフラグ
				; 0=通常,55=ランダムセレクト
RRMAPWIDEMO	DW	0	; デモフラグ0=通常,55=ランダムセレクト

NUM_TATEFUDA	DW	0		; 立て札番号
NUM_TAKARA	DW	0		; 宝箱番号

MESS_ADRS1	DW	0		; メッセージアドレス１
MESS_ADRS2	DW	0		; メッセージアドレス２

ITEM_NUM	DW	0		; アイテム番号
ITEM_NO		DW	0		; アイテムＮＯ．
ITEM_ID		DW	0		; アイテムＩＤ
ITM_FLAG	DW	0		; 0=通常,1=いっぱいで持てない

;	＊立て札のメッセージ＊

KANBAN_MAX	DW	8		; 立て札数
KANBAN_TBL	LABEL	WORD		; 立て札メッセージテーブル
		DW	KANBAN1_1,KANBAN1_2
		DW	KANBAN2_1,KANBAN2_2
		DW	KANBAN3_1,KANBAN3_2
		DW	KANBAN4_1,KANBAN4_2
		DW	KANBAN5_1,KANBAN5_2
		DW	KANBAN6_1,KANBAN6_2
		DW	KANBAN7_1,KANBAN7_2
		DW	KANBAN8_1,KANBAN8_2

KANBAN1_1	DB	"＊＊＊＊＊＊＊＊",0
KANBAN1_2	DB	0

KANBAN2_1	DB	"＊＊＊＊",0
KANBAN2_2	DB	"＊＊＊＊＊＊＊＊＊",0

KANBAN3_1	DB	"＊＊＊＊＊＊＊＊＊＊",0
KANBAN3_2	DB	"＊＊＊＊＊＊＊＊＊",0

KANBAN4_1	DB	"＊＊＊＊＊＊＊＊＊",0
KANBAN4_2	DB	0

KANBAN5_1	DB	"＊＊＊＊＊＊＊＊＊",0
KANBAN5_2	DB	"＊＊＊＊＊＊＊＊",0

KANBAN6_1	DB	"＊＊＊＊＊＊＊",0
KANBAN6_2	DB	0

KANBAN7_1	DB	"＊＊＊＊＊＊＊",0
KANBAN7_2	DB	0

KANBAN8_1	DB	"＊＊＊＊＊＊＊＊",0
KANBAN8_2	DB	"＊＊＊＊＊＊＊＊＊＊＊＊",0

;	＊宝箱の中身＊

TAKARA_MAX	DW	5		; 宝箱数
TAKARA_TBL	LABEL	WORD		; 宝箱メッセージテーブル
		DW	15		; 15薬草
		DW	ID_41		; 薬草		
		DW	TAKARA1		;
		DW	16		; 16ぬいぐるみ
		DW	ID_42		; ぬいぐるみ	
		DW	TAKARA2		;
		DW	18		; 18本
		DW	ID_44		; 本		
		DW	TAKARA3		;
		DW	20		; 20ティーカップ
		DW	ID_46		; ティーカップ	
		DW	TAKARA4		;
		DW	21		; 21ドレス
		DW	ID_47		; ドレス		
		DW	TAKARA5

TAKARA1		DB	"薬草",0
TAKARA2		DB	"ぬいぐるみ",0
TAKARA3		DB	"本",0
TAKARA4		DB	"ティーカップ",0
TAKARA5		DB	"ドレス",0

MES_HAVE_01	DB	"を手に入れた．",0
MES_HAVE_02	DB	"これ以上持てない",0

DATA	ENDS

	END
;
;	end of "R_MAPWID.ASM"
;
