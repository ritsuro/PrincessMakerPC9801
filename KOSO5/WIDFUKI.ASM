; "WIDFUKI.ASM" PC-9801UV11 make by R.H 1990/10/29
;
;
;	ＷＩＮＤＯＷＳ／テキストウインドウ
;
;
;	WIDFUKI_INIT		; WINDOWS/ふきだしウインドウ初期処理
;	WIDFUKI			; WINDOWS/ふきだしウインドウ
;	WIDFUKI_OPEN		; WINDOWS/ふきだしウインドウＯＰＥＮ
;	WIDFUKI_CLOSE		; WINDOWS/ふきだしウインドウＣＬＯＳＥ
;
;	位置
;	ミスコン
;		0:ど真中
;		1:予想発表
;		2:買収ウインドウ
;		3:左上,4:右上,5:左下,6:右下
;		7:王様ふぎだし番号
;	武闘会
;		8:表彰式ふきだし番号
;
;		9:収穫祭ＯＰＥＮ
;
;
;
; (C) 1990 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC

NORMAL_BANK	EQU	0	; 通常のパーツバンク番号
BACKSAVE_BANK	EQU	1	; 背景退避用パーツバンク番号

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

ADDX	MACRO	DEST,SOUR
	MOV	AX,SOUR
	ADD	DEST,AX
	ENDM

WINDOW	SEGMENT	PUBLIC	'WINDOW'

	ASSUME	CS:WINDOW,DS:DATA


; ****************************************************
;	WINDOWS/ふきだしウインドウ初期処理
; ****************************************************

FUNC	WWIDFUKI_INIT,WIDFUKI_INIT
	RET
FEND	WWIDFUKI_INIT


; ****************************************************
;	WINDOWS/ふきだしウインドウ
;	-I-   DX    : ふきだし番号
;	      DS:SI : 台詞
;	-I/O- WIDFUKI_AFTER_W : フラグ・処理後にＷＡＩＴをいれる=1
;				（処理後クリアされる）
; ****************************************************

FUNC	WWIDFUKI,WIDFUKI
	MOV	TBL_LOC_PNT,DX		; ふきだし・ロケートテーブルポインタ
	MOV	WDTXTSEG,DS		; 表示文字列セグメント
	MOV	WDTXTADR,SI		; 表示文字列アドレス

	PUSH	SI			;
	CALLC	TKTIN_F			; ふきだしのメッセージ（初期処理）
	POP	SI			;

	MOV	AX,1			; 口ぱくモード 1=口ぱくあり
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定

;;	MOV	AX,DS			;
;;	MOV	ES,AX			;
;;	CALLC	TKTPRN			; アドベンチャー画面のメッセージ

	CALLC	WIDTXT			; WINDOWS/テキストウインドウ

	CMP	WIDFUKI_AFTER_W,0	; フラグ・処理後にＷＡＩＴをいれる=1
	JE	WIDFUKI_55		;
	CALLC	TKWAIT			; 台詞改行のプレイヤー待ち
	MOV	WIDFUKI_AFTER_W,0	; フラグ・処理後にＷＡＩＴをいれる=1
WIDFUKI_55:
	MOV	AX,0			; 口ぱくモード 0=口ぱくなし
	CALLC	WIDTXT_MODE		; WINDOWS/テキストウインドウモード設定

	CALLC	TKTIN_F_RET		; 元の台詞表示へ戻す
	RET
FEND	WWIDFUKI


; ****************************************************
;	WINDOWS/ふきだしウインドウＯＰＥＮ
;	-I- DX : ふきだし番号
; ****************************************************

FUNC	WWIDFUKI_OPEN,WIDFUKI_OPEN
	MOV	TBL_LOC_PNT,DX		; ふきだし・ロケートテーブルポインタ

	CALL	WID_LOCATE		; ロケーション計算

	CMP	FKI_BACK_F,0		; ふきだし・退避フラグ
	JE	WIDFUKI_OPEN_5		;

	MOV	DX,BACKSAVE_BANK	; 背景退避用パーツバンク番号
	MOVX	WDX1,FKI_BACK_X1	; ふきだし・退避左上Ｘ
	MOVX	WDY1,FKI_BACK_Y1	; ふきだし・退避左上Ｙ
	MOVX	WDX2,FKI_BACK_X2	; ふきだし・退避サイズＸ
	MOVX	WDY2,FKI_BACK_Y2	; ふきだし・退避サイズＹ
	CALLC	WIDFRM_BACKSAVE		; WINDOWS/背景をセーブ
WIDFUKI_OPEN_5:

	MOVX	WDX1,FKI_FRAM_X1	; ふきだし・フレーム左上Ｘ
	MOVX	WDY1,FKI_FRAM_Y1	; ふきだし・フレーム左上Ｙ
	MOVX	WDX2,FKI_FRAM_X2	; ふきだし・フレームサイズＸ
	MOVX	WDY2,FKI_FRAM_Y2	; ふきだし・フレームサイズＹ
	CALLC	WID_5_FLAME		; WINDOWS/フレーム５（宝石）

	RET
FEND	WWIDFUKI_OPEN


; ****************************************************
;	WINDOWS/ふきだしウインドウＣＬＯＳＥ
;	-I- DX : ふきだし番号
; ****************************************************

FUNC	WWIDFUKI_CLOSE,WIDFUKI_CLOSE
	CMP	FKI_BACK_F,0		; ふきだし・退避フラグ
	JE	WIDFUKI_CLOSE_EXIT	;

	MOV	TBL_LOC_PNT,DX		; ふきだし・ロケートテーブルポインタ
	CALLC	WIDFRM_BACKLOAD		; WINDOWS/背景をロード

WIDFUKI_CLOSE_EXIT:			;
	RET
FEND	WWIDFUKI_CLOSE


; ****************************************************
;	ロケーション計算
;	-I- TBL_LOC_PNT : ふきだし・ロケートテーブルポインタ
; ****************************************************

WID_LOCATE	PROC	NEAR
	MOV	BX,TBL_LOC_PNT		; ふきだし・ロケートテーブルポインタ
	SHL	BX,1			; word pointer.
	MOVX	FKI_INI_X,DS:TBL_INI_X[BX]	; ふきだし・台詞左上Ｘ
	MOVX	FKI_INI_Y,DS:TBL_INI_Y[BX]	; ふきだし・台詞左上Ｙ
	MOVX	FKI_END_X,DS:TBL_END_X[BX]	; ふきだし・台詞右下Ｘ
	MOVX	FKI_END_Y,DS:TBL_END_Y[BX]	; ふきだし・台詞右下Ｙ
	MOVX	FKI_SIZE_X,DS:TBL_SIZE_X[BX]	; ふきだし・台詞サイズＸ
	MOVX	FKI_SIZE_Y,DS:TBL_SIZE_Y[BX]	; ふきだし・台詞サイズＹ

	MOV	BX,TBL_LOC_PNT		; ふきだし・ロケートテーブルポインタ
	MOV	AL,DS:TBL_BACK_F[BX]		; ふきだし・退避フラグ
	MOV	BYTE PTR FKI_BACK_F,AL		; ふきだし・退避フラグ

	MOV	AX,FKI_INI_X		; ふきだし・台詞左上Ｘ
	MOV	BX,FKI_INI_Y		; ふきだし・台詞左上Ｙ
	MOV	CX,FKI_SIZE_X		; ふきだし・台詞サイズＸ
	MOV	DX,FKI_SIZE_Y		; ふきだし・台詞サイズＹ

	SUB	AX,2			;
	SUB	BX,8			;

	MOV	FKI_FRAM_X1,AX		; ふきだし・フレーム左上Ｘ
	MOV	FKI_FRAM_Y1,BX		; ふきだし・フレーム左上Ｙ
	MOV	FKI_FRAM_X2,CX		; ふきだし・フレームサイズＸ
	MOV	FKI_FRAM_Y2,DX		; ふきだし・フレームサイズＹ

	SUB	AX,2			;
	SUB	BX,8			;
	ADD	CX,2*2			;
	ADD	DX,8*2			;

	MOV	FKI_BACK_X1,AX		; ふきだし・退避左上Ｘ
	MOV	FKI_BACK_Y1,BX		; ふきだし・退避左上Ｙ
	MOV	FKI_BACK_X2,CX		; ふきだし・退避サイズＸ
	MOV	FKI_BACK_Y2,DX		; ふきだし・退避サイズＹ

	MOV	FKI_MAX_FUKI_NEXT,3	; ふきだし表示最大行
	MOV	FKI_MOJI_FUKI_MAX,44	; ふきだし最大文字数＜注目！！＞

	CMP	TBL_LOC_PNT,7		; 王様ふぎだし番号
	JNE	WID_LOCATE_5		;
	MOV	AX,FACE_SHIFT_7		; フェイスシフト／王様ふぎだし編
	ADD	FKI_INI_X,AX		; ふきだし・台詞左上Ｘ
	SUB	FKI_SIZE_X,AX		; ふきだし・台詞サイズＸ

	MOV	FKI_MAX_FUKI_NEXT,5	; ふきだし表示最大行
	MOV	FKI_MOJI_FUKI_MAX,10*2	; ふきだし最大文字数＜注目！！＞
WID_LOCATE_5:

	CMP	TBL_LOC_PNT,9		; 収穫祭ＯＰＥＮ
	JNE	WID_LOCATE_6		;
	MOV	FKI_MAX_FUKI_NEXT,6	; ふきだし表示最大行
WID_LOCATE_6:
	CMP	TBL_LOC_PNT,1		; 収穫祭ＯＰＥＮ
	JNE	WID_LOCATE_62		;
	MOV	FKI_MAX_FUKI_NEXT,2	; ふきだし表示最大行
WID_LOCATE_62:

	RET
WID_LOCATE	ENDP

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

PUBLIC	FKI_INI_X		; ふきだし・台詞左上Ｘ
PUBLIC	FKI_INI_Y		; ふきだし・台詞左上Ｙ
PUBLIC	FKI_END_X		; ふきだし・台詞右下Ｘ
PUBLIC	FKI_END_Y		; ふきだし・台詞右下Ｙ
PUBLIC	FKI_SIZE_X		; ふきだし・台詞サイズＸ
PUBLIC	FKI_SIZE_Y		; ふきだし・台詞サイズＹ
PUBLIC	FKI_MAX_FUKI_NEXT	; ふきだし表示最大行
PUBLIC	FKI_MOJI_FUKI_MAX	; ふきだし最大文字数＜注目！！＞

PUBLIC	WIDFUKI_AFTER_W		; フラグ・処理後にＷＡＩＴをいれる=1

FKI_MAX_FUKI_NEXT DW	3	; ふきだし表示最大行
FKI_MOJI_FUKI_MAX DW	46	; ふきだし最大文字数＜注目！！＞

WIDFUKI_AFTER_W	DW	0	; フラグ・処理後にＷＡＩＴをいれる=1

;		0:ど真中
;		1:予想発表
;		2:買収ウインドウ
;		3:左上,4:右上,5:左下,6:右下
;		7:王様ふぎだし番号
;		8:表彰式ふきだし番号
;		9:収穫祭ＯＰＥＮ

TBL_LOC_PNT	DW	0		; ふきだし・ロケートテーブルポインタ
TBL_INI_X	LABEL	WORD		; ふきだし・台詞左上Ｘ
	DW 18	,18	,24	,3	,43	,3	,43	,24
	DW 18	,17
TBL_INI_Y	LABEL	WORD		; ふきだし・台詞左上Ｙ
	DW 164	,176	,216	,15	,15	,215	,215	,120
	DW 50	,190
TBL_END_X	LABEL	WORD		; ふきだし・台詞右下Ｘ
	DW 18+46,18+46	,30+20	,3+38	,43+38	,3+38	,43+38	,24+34
	DW 18+48,17+46
TBL_END_Y	LABEL	WORD		; ふきだし・台詞右下Ｙ
	DW 164+60,176+40,216+60	,16+187	,16+187	,216+187,216+187,120+106
	DW 50+60,190+120
TBL_SIZE_X	LABEL	WORD		; ふきだし・台詞サイズＸ
	DW 50	,50	,32	,38	,38	,38	,38	,38
	DW 48	,50
TBL_SIZE_Y	LABEL	WORD		; ふきだし・台詞サイズＹ
	DW 20*4	,20*3	,20*3 ,16*11+11,16*11+11,16*11+11,16*11+11,20*6
	DW 20*3	,20*7
TBL_BACK_F	LABEL	BYTE		; ふきだし・退避フラグ
	DB 0	,0	,0	,0	,0	,0	,0	,0
	DB 0	,0
	EVEN
	;   0	1	2	3	4	5	6	7

FACE_SHIFT_7	DW	12		; フェイスシフト／王様ふぎだし編

FKI_INI_X	DW	0		; ふきだし・台詞左上Ｘ
FKI_INI_Y	DW	0		; ふきだし・台詞左上Ｙ
FKI_END_X	DW	0		; ふきだし・台詞右下Ｘ
FKI_END_Y	DW	0		; ふきだし・台詞右下Ｙ
FKI_SIZE_X	DW	0		; ふきだし・台詞サイズＸ
FKI_SIZE_Y	DW	0		; ふきだし・台詞サイズＹ
FKI_BACK_F	DW	0		; ふきだし・退避フラグ

FKI_FRAM_X1	DW	0		; ふきだし・フレーム左上Ｘ
FKI_FRAM_Y1	DW	0		; ふきだし・フレーム左上Ｙ
FKI_FRAM_X2	DW	0		; ふきだし・フレームサイズＸ
FKI_FRAM_Y2	DW	0		; ふきだし・フレームサイズＹ

FKI_BACK_X1	DW	0		; ふきだし・退避左上Ｘ
FKI_BACK_Y1	DW	0		; ふきだし・退避左上Ｙ
FKI_BACK_X2	DW	0		; ふきだし・退避サイズＸ
FKI_BACK_Y2	DW	0		; ふきだし・退避サイズＹ

DATA	ENDS

	END
;
;	end of "WIDFUKI.ASM"
;
