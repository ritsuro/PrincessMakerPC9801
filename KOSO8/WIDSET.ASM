; "WIDSET.ASM" PC-9801UV11 make by R.H 1991/03/09
;
;
;	ＷＩＮＤＯＷＳ／総合
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	TSTSET.INC

WTTIM	EQU	2		; wait timer count.

;	ＴＡＢＬＥ＿ＣＯＰＹ	＜転送元ｱﾄﾞﾚｽ＞，＜転送先ｱﾄﾞﾚｽ＞
;					，＜転送ワード数＞，＜転送先ワード数＞

TABLE_COPY	MACRO		SOU,DEST,WCNT,WDIM
	LOCAL	L1
	MOV	AX,DS
	MOV	ES,AX
	MOV	SI,SOU
	MOV	DI,DEST
	MOV	CX,WCNT
	CMP	CX,WDIM
	JBE	L1
	MOV	CX,WDIM
L1:
	REP	MOVSW
	ENDM


;	ＴＡＢＬＥ＿ＭＡＳＫ	＜元ｱﾄﾞﾚｽ＞，＜ＡＮＤ先ｱﾄﾞﾚｽ＞
;					，＜元ワード数＞，＜先ワード数＞

TABLE_MASK	MACRO		SOU,DEST,WCNT,WDIM
	LOCAL	L1,L2,L3
	MOV	AX,DS
	MOV	ES,AX
	MOV	SI,SOU
	MOV	DI,DEST
	MOV	CX,WCNT
	CMP	CX,WDIM
	JBE	L1
	MOV	CX,WDIM
L1:
	LODSB
	MOV	AH,0
	CMP	AL,0
	JE	L2
	MOV	AH,0FFH
L2:
	AND	ES:[DI],AH
	INC	DI

	LODSB
	MOV	AH,0
	CMP	AL,0
	JE	L3
	MOV	AH,0FFH
L3:
	AND	ES:[DI],AH
	INC	DI

	LOOP	L1
	ENDM

DSK_FRAM_X1	EQU	16			; フレーム左上Ｘ
DSK_FRAM_Y1	EQU	222			; フレーム左上Ｙ
DSK_FRAM_X2	EQU	44			; フレームサイズＸ
DSK_FRAM_Y2	EQU	142+8			; フレームサイズＹ

DSK_BACK_X1	EQU	DSK_FRAM_X1-1		; 退避左上Ｘ
DSK_BACK_Y1	EQU	DSK_FRAM_Y1-8		; 退避左上Ｙ
DSK_BACK_X2	EQU	DSK_FRAM_X2+2		; 退避サイズＸ
DSK_BACK_Y2	EQU	DSK_FRAM_Y2+16		; 退避サイズＹ

DSK_BTN_XX1	EQU	DSK_FRAM_X1+2		; ボタン左上Ｘ
DSK_BTN_YY1	EQU	DSK_FRAM_Y1+16		; ボタン左上Ｙ
DSK_BTNSIZ_X	EQU	4			; ボタンサイズＸ
DSK_BTNSIZ_Y	EQU	32			; ボタンサイズＹ

DSK_BTN_XP1	EQU	DSK_FRAM_X1+2		; ボタン左上Ｘ
DSK_BTN_YP1	EQU	(DSK_FRAM_Y1+16)/8	; ボタン左上Ｙ
DSK_BTNSTP_X1	EQU	4			; ボタンステップ左上Ｘ
DSK_BTNSTP_Y1	EQU	4			; ボタンステップ左上Ｙ

DSK_BTN_CNT_XX	EQU	10			; ボタン並びＸ
DSK_BTN_CNT_YY	EQU	4			; ボタン並びＹ

DSK_MESS_X1	EQU	DSK_FRAM_X1+2		; メッセージ１左上Ｘ
DSK_MESS_Y1	EQU	DSK_FRAM_Y1+8		; メッセージ１左上Ｙ
DSK_MESS_X2	EQU	DSK_FRAM_X1+2		; メッセージ２左上Ｘ
DSK_MESS_Y2	EQU	DSK_FRAM_Y1+8+18	; メッセージ２左上Ｙ
DSK_MESS_X3	EQU	DSK_FRAM_X1+2		; メッセージ３左上Ｘ
DSK_MESS_Y3	EQU	DSK_FRAM_Y1+8+18*2	; メッセージ３左上Ｙ

MESS_LINE_X	EQU	44			; メッセージ行大きさＸ
MESS_LINE_Y	EQU	16			; メッセージ行大きさＹ

PAT_NUM_OFF	EQU	0			; ＯＦＦ
PAT_NUM_ON	EQU	1			; ＯＮ
PAT_NUM_HI	EQU	2			; ＨＩ
PAT_NUM_ON_TCH	EQU	3			; ＯＮ－ＴＵＣＨ
PAT_NUM_OFF_TCH	EQU	4			; ＯＦＦ－ＴＵＣＨ

CALLC	MACRO	SUB1
	EXTRN	SUB1:NEAR
	CALL	SUB1
	ENDM

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


CODE	SEGMENT	PUBLIC	'CODE'

	ASSUME	CS:CODE,DS:CODE

PUBLIC	WIDDLOAD		; WINDOWS/ロードウインドウ
PUBLIC	WIDDSAVE		; WINDOWS/セーブウインドウ

EXTRN	MITPRN:NEAR		; mini string. (null=end of string)
EXTRN	MITCOL:NEAR		; mini string color.

EXTRN	DISKMX:NEAR		; セーブマトリックス検索
EXTRN	DISKFL:NEAR		; セーブファイル名

EXTRN	TIMER:NEAR		; タイマ(V-SYNC timer wait.)
EXTRN	PAT32PUT:NEAR		; ３２×３２パターンＰＵＴ
EXTRN	PAT32VRAM_LOAD:NEAR	; ＶＲＡＭ戻す
EXTRN	PAT32VRAM_SAVE:NEAR	; ＶＲＡＭ退避

EXTRN	MSCSRT:NEAR		; カーソルスタート
EXTRN	MSCMOV:NEAR		; カーソル移動
EXTRN	MSCWAT:NEAR		; カーソルボタンＯＦＦ待ち
EXTRN	MSCSTP:NEAR		; カーソルストップ
EXTRN	MSCSTS:NEAR		; マウスカーソルステータス
EXTRN	MSCPNT:NEAR		; カーソル表示位置


; ****************************************************
;	WINDOWS/ロードウインドウ
;	-I- DX       : ユーザディスクドライブ番号(1-4,0=ｶﾚﾝﾄ)
;	-O- MXFLNAME : データファイル名（パスを含む）
;	    AX       : 0=正常,1=強制終了
; ****************************************************

WIDDLOAD	PROC	NEAR
	MOV	DRIVE_NUMBER,DX		; ＦＤドライブ番号

	MOV	MTRX_ADRS,OFFSET WIDBTNTBL	; ウインドウボタン・テーブル
	CALL	DISKMX			; セーブマトリックス検索

	CALL	WIDDISK_OPEN		; ウインドウＯＰＥＮ

	MOV	OFF_BTN_ACT,0		; ＯＦＦボタン選択出来る？
	CALL	FILESELECT		; ファイル選択

	CMP	FLG_BREAK,1		; 0=正常,1=強制終了
	JE	WIDDLOAD_BREAK		;

WIDDLOAD_SET:				;
	MOV	AX,0			; 0=正常
	JMP	WIDDLOAD_EXIT		;
WIDDLOAD_BREAK:				;
	MOV	AX,1			; 1=強制終了
WIDDLOAD_EXIT:				;
	CALL	WIDDISK_CLOSE		; ウインドウＣＬＯＳＥ
	RET
WIDDLOAD	ENDP


; ****************************************************
;	WINDOWS/セーブウインドウ
;	-I- DX : ユーザディスクドライブ番号(1-4,0=ｶﾚﾝﾄ)
;	-O- MXFLNAME : データファイル名（パスを含む）
;	    AX       : 0=正常,1=強制終了
; ****************************************************

WIDDSAVE	PROC	NEAR
	MOV	DRIVE_NUMBER,DX		; ＦＤドライブ番号

	MOV	MTRX_ADRS,OFFSET WIDBTNTBL	; ウインドウボタン・テーブル
	CALL	DISKMX			; セーブマトリックス検索

	CALL	WIDDISK_OPEN		; ウインドウＯＰＥＮ

	MOV	OFF_BTN_ACT,1		; ＯＦＦボタン選択出来る？
	CALL	FILESELECT		; ファイル選択

	CMP	FLG_BREAK,1		; 0=正常,1=強制終了
	JE	WIDDSAVE_BREAK		;

WIDDSAVE_SET:				;
	MOV	AX,0			; 0=正常
	JMP	WIDDSAVE_EXIT		;
WIDDSAVE_BREAK:				;
	MOV	AX,1			; 1=強制終了
WIDDSAVE_EXIT:
	CALL	WIDDISK_CLOSE		; ウインドウＣＬＯＳＥ
	RET
WIDDSAVE	ENDP


; ****************************************************
;	ウインドウＯＰＥＮ
; ****************************************************

WIDDISK_OPEN	PROC	NEAR
	MOV	WDX1,DSK_FRAM_X1	; フレーム左上Ｘ
	MOV	WDY1,DSK_FRAM_Y1	; フレーム左上Ｙ
	MOV	WDX2,DSK_FRAM_X2	; フレームサイズＸ
	MOV	WDY2,DSK_FRAM_Y2	; フレームサイズＹ
	CALL	WID_5_FLAME		; WINDOWS/フレーム５（宝石）

	CALL	BTN_KEY_START		; ボタン受け付け開始

	RET
WIDDISK_OPEN	ENDP


; ****************************************************
;	ウインドウＣＬＯＳＥ
; ****************************************************

WIDDISK_CLOSE	PROC	NEAR
	PUSH	AX
	POP	AX
	RET
WIDDISK_CLOSE	ENDP


; ****************************************************
;	ファイル選択
;	-I- DRIVE_NUMBER : ＦＤドライブ番号
;	    OFF_BTN_ACT  : ＯＦＦボタン選択出来る？
;	-O- FLG_BREAK    : 0=正常,1=強制終了
;	    MXFLNAME     : データファイル名
;	    MTRSLCBTN    : マトリックス選択ボタン種類
;			   0=触っていない,1=OFFに触った,2=ONに触った
; ****************************************************

FILESELECT	PROC	NEAR
	CALL	MSCSRT			; カーソルスタート

	MOV	MTRBTON,0		; マトリックスボタン触る
	MOV	MTRNOWBTON,0		; マトリックス現在ボタン触る
	MOV	MTRSLCBTN,0		; マトリックス選択ボタン種類

FILESELECT_LOOP:			;
	CALL	MSCMOV			; カーソル移動
	CMP	DH,0			; 左ボタン（1：ＯＦＦ／0：ＯＮ）
	JMPEQ	FILESELECT_SET		;
	CMP	DL,0			; 右ボタン（1：ＯＦＦ／0：ＯＮ）
	JMPEQ	FILESELECT_NO_SET	; 強制終了

FILESELECT_INTER:			;
	MOV	MUSXX,AX		; マウスＸ座標
	MOV	MUSYY,BX		; マウスＹ座標
	CALL	BTN_AREA_CHECK		; ボタンエリアチェック
	CMP	AX,0			; 0=一致しなかった,1=一致した
	JE	FILESELECT_NO_TUCH	;

FILESELECT_TUCH:			;
	MOV	MTRBTON,1		; マトリックスボタン触る
	CALL	BOTTAN_SET		; ボタンセット
	JMP	FILESELECT_NEXT		;

FILESELECT_NO_TUCH:			;
	MOV	MTRBTON,0		; マトリックスボタン触る（がＯＦＦ）
	CALL	BOTTAN_SET		; ボタンセット

FILESELECT_NEXT:
	JMP	FILESELECT_LOOP		;

FILESELECT_SET:
	CMP	OFF_BTN_ACT,1		; ＯＦＦボタン選択出来る？
	JE	FILESELECT_SET2		;
	CMP	MTRSLCBTN,1		; マトリックス選択ボタン種類
	JE	FILESELECT_INTER	; 1=OFFに触った
FILESELECT_SET2:
	CMP	MTRSLCBTN,0		; 0=触っていない
	JE	FILESELECT_INTER	;

	MOVX	MTRX_XX,MTRXXX		; マトリックスＸ座標
	MOVX	MTRX_YY,MTRYYY		; マトリックスＹ座標
	MOV	DX,DRIVE_NUMBER		; ＦＤドライブ番号
	CALL	DISKFL			; セーブファイル名
	MOV	FLG_BREAK,0		; 0=正常
	JMP	FILESELECT_EXIT		;

FILESELECT_NO_SET:
	MOV	MTRBTON,0		; マトリックスボタン触る（がＯＦＦ）
	CALL	BOTTAN_SET		; ボタンセット
	MOV	FLG_BREAK,1		; 1=強制終了

FILESELECT_EXIT:
	CALL	MSCSTP			; カーソルストップ
	RET
FILESELECT	ENDP


; ****************************************************
;	ボタンエリアチェック
;	-I- MUSXX : マウスＸ座標
;	    MUSYY : マウスＹ座標
;	-O- AX    : 0=一致しなかった,1=一致した
;	    MTRXXX: マトリックスＸ座標
;	    MTRYYY: マトリックスＹ座標
; ****************************************************

BTN_AREA_CHECK	PROC	NEAR

	MOV	MTRYYY,0		; マトリックスＹ座標
	MOV	WDY1,DSK_BTN_YY1	; ボタン左上Ｙ
	MOV	CX,DSK_BTN_CNT_YY	; ボタン並びＹ

BTN_AREA_CHECK_LOOP_YY:
	PUSH	CX

	MOV	MTRXXX,0		; マトリックスＸ座標
	MOV	WDX1,DSK_BTN_XX1	; ボタン左上Ｘ
	MOV	CX,DSK_BTN_CNT_XX	; ボタン並びＸ

BTN_AREA_CHECK_LOOP_XX:
	PUSH	CX

	MOV	AX,WDX1			; ボタン左上Ｘ
	CMP	MUSXX,AX		; マウスＸ座標
	JL	BTN_AREA_CHECK_NEXT	;
	ADD	AX,DSK_BTNSIZ_X		; ボタンサイズＸ
	CMP	MUSXX,AX		; マウスＸ座標
	JG	BTN_AREA_CHECK_NEXT	;

	MOV	AX,WDY1			; ボタン左上Ｙ
	CMP	MUSYY,AX		; マウスＹ座標
	JL	BTN_AREA_CHECK_NEXT	;
	ADD	AX,DSK_BTNSIZ_Y		; ボタンサイズＹ
	CMP	MUSYY,AX		; マウスＹ座標
	JG	BTN_AREA_CHECK_NEXT	;

	JMP	BTN_AREA_CHECK_OK	; 一致しました！

BTN_AREA_CHECK_NEXT:
	INC	MTRXXX			; マトリックスＸ座標
	ADD	WDX1,DSK_BTNSIZ_X	; ボタンサイズＸ
	POP	CX			;
	LOOP	BTN_AREA_CHECK_LOOP_XX	;

	INC	MTRYYY			; マトリックスＹ座標
	ADD	WDY1,DSK_BTNSIZ_Y	; ボタンサイズＹ
	POP	CX			;
	LOOP	BTN_AREA_CHECK_LOOP_YY	;

	MOV	AX,0			; 0=一致しなかった
	RET
BTN_AREA_CHECK_OK:
	POP	CX			;
	POP	CX			;
	MOV	AX,1			; 1=一致した
	RET
BTN_AREA_CHECK	ENDP


; ****************************************************
;	ボタンセット
;	-I-   MTRXXX    : マトリックスＸ座標
;	      MTRYYY    : マトリックスＹ座標
;	      MTRBTON   : マトリックスボタン触る
;	-I/O- MTRNOWXXX : マトリックス現在Ｘ座標
;	      MTRNOWYYY : マトリックス現在Ｙ座標
;	      MTRNOWBTON: マトリックス現在ボタン触る
;	-O-   MTRSLCBTN : マトリックス選択ボタン種類
;				0=触っていない,1=OFFに触った,2=ONに触った
; ****************************************************

BOTTAN_SET	PROC	NEAR
	CMPX	MTRNOWBTON,MTRBTON	; マトリックス現在ボタン触る
	JNE	BOTTAN_SET_START	;
	CMP	MTRBTON,0		; マトリックスボタン触れてない
	JMPEQ	BOTTAN_SET_EXIT		;

	CMPX	MTRNOWXXX,MTRXXX	; マトリックス現在Ｘ座標
	JNE	BOTTAN_SET_START	;
	CMPX	MTRNOWYYY,MTRYYY	; マトリックス現在Ｙ座標
	JNE	BOTTAN_SET_START	;

	JMP	BOTTAN_SET_EXIT		;
BOTTAN_SET_START:

	PUSH	MTRXXX			; マトリックスＸ座標
	PUSH	MTRYYY			; マトリックスＹ座標

	MOVX	MTRXXX,MTRNOWXXX	; マトリックス現在Ｘ座標
	MOVX	MTRYYY,MTRNOWYYY	; マトリックス現在Ｙ座標

	CMP	MTRNOWBTON,0		; マトリックス現在ボタン触れてない
	JE	BOTTAN_SET_1		;

	CALL	BOTTAN_NORMAL		; ボタンＮＯＲＭＡＬ
BOTTAN_SET_1:				;

	POP	MTRYYY			; マトリックスＹ座標
	POP	MTRXXX			; マトリックスＸ座標

	CMP	MTRBTON,0		; マトリックスボタン触れてない
	JE	BOTTAN_SET_NO_TUCH	;

	CALL	BOTTAN_TUCH		; ボタンＴＵＣＨ
	CMP	AX,0			; 0=ＯＦＦ,1=ＯＮ
	JE	BOTTAN_SET_OFF		;

BOTTAN_SET_ON:
	MOV	MTRNOWBTON,1		; マトリックス現在ボタン触る
	MOV	MTRSLCBTN,2		; 2=ONに触った
	JMP	BOTTAN_SET_ED		;

BOTTAN_SET_OFF:
	MOV	MTRNOWBTON,1		; マトリックス現在ボタン触る
	MOV	MTRSLCBTN,1		; 1=OFFに触った
	JMP	BOTTAN_SET_ED		;

BOTTAN_SET_NO_TUCH:
	MOV	MTRNOWBTON,0		; マトリックス現在ボタン触れてない
	MOV	MTRSLCBTN,0		; 0=触っていない
	JMP	BOTTAN_SET_ED		;

BOTTAN_SET_ED:
	MOVX	MTRNOWXXX,MTRXXX	; マトリックス現在Ｘ座標
	MOVX	MTRNOWYYY,MTRYYY	; マトリックス現在Ｙ座標

BOTTAN_SET_EXIT:
	RET
BOTTAN_SET	ENDP


; ****************************************************
;	ボタンＮＯＲＭＡＬ
;	-I-   MTRXXX    : マトリックスＸ座標
;	      MTRYYY    : マトリックスＹ座標
; ****************************************************

BOTTAN_NORMAL	PROC	NEAR
	CALL	BTN_PATTAN_XY		; ボタン・パターン番号と座標
	CALL	MSCSTP			; カーソルストップ
	CALL	PAT32VRAM_LOAD		; ＶＲＡＭ戻す
;*;	CALL	PAT32PUT		; ３２×３２パターンＰＵＴ
	CALL	MSCSRT			; カーソルスタート
	RET
BOTTAN_NORMAL	ENDP


; ****************************************************
;	ボタンＴＵＣＨ
;	-I-   MTRXXX    : マトリックスＸ座標
;	      MTRYYY    : マトリックスＹ座標
;	-O-   AX        : 0=ＯＦＦ,1=ＯＮ
; ****************************************************

BOTTAN_TUCH	PROC	NEAR
	CALL	BTN_PATTAN_XY		; ボタン・パターン番号と座標
	CMP	CURNUM,PAT_NUM_OFF	; ＯＦＦ
	JE	BOTTAN_TUCH_OFF		;

BOTTAN_TUCH_ON:
	MOV	CURNUM,PAT_NUM_ON_TCH	; ＯＮ－ＴＵＣＨ
	CALL	MSCSTP			; カーソルストップ
	CALL	PAT32VRAM_SAVE		; ＶＲＡＭ退避
	CALL	PAT32PUT		; ３２×３２パターンＰＵＴ
	CALL	NUMBERING_2S		; 番号その２
	CALL	MSCSRT			; カーソルスタート
	MOV	AX,1			; 1=ＯＮ
	JMP	BOTTAN_TUCH_EXIT	;

BOTTAN_TUCH_OFF:
	MOV	CURNUM,PAT_NUM_OFF_TCH	; ＯＦＦ－ＴＵＣＨ
	CALL	MSCSTP			; カーソルストップ
	CALL	PAT32VRAM_SAVE		; ＶＲＡＭ退避
	CALL	PAT32PUT		; ３２×３２パターンＰＵＴ
	CALL	NUMBERING_2S		; 番号その２
	CALL	MSCSRT			; カーソルスタート
	MOV	AX,0			; 0=ＯＦＦ

BOTTAN_TUCH_EXIT:
	RET
BOTTAN_TUCH	ENDP


; ****************************************************
;	ボタン・パターン番号と座標
;	-I-   MTRXXX    : マトリックスＸ座標
;	      MTRYYY    : マトリックスＹ座標
;	-O-   CURNUM    : パターン番号
;	      CURX      : マトリックスＸ座標
;	      CURY      : マトリックスＹ座標
; ****************************************************

BTN_PATTAN_XY	PROC	NEAR
	MOV	AX,MTRYYY		; マトリックスＹ座標
	MOV	BX,DSK_BTN_CNT_XX	; ×ボタン並びＸ
	MUL	BX			;
	ADD	AX,MTRXXX		; マトリックスＸ座標
	MOV	BX,AX			; byte pointer.
	MOV	AL,DS:WIDBTNTBL[BX]	; ウインドウボタン・テーブル
	MOV	AH,0			;
	MOV	CURNUM,AX		; パターン番号

	MOV	AX,DSK_BTNSTP_X1	; ボタンステップ左上Ｘ
	MOV	BX,MTRXXX		; ×マトリックスＸ座標
	MUL	BX			;
	ADD	AX,DSK_BTN_XP1		; ボタン左上Ｘ
	MOV	CURX,AX			; マトリックスＸ座標

	MOV	AX,DSK_BTNSTP_Y1	; ボタンステップ左上Ｙ
	MOV	BX,MTRYYY		; ×マトリックスＹ座標
	MUL	BX			;
	ADD	AX,DSK_BTN_YP1		; ボタン左上Ｙ
	MOV	CURY,AX			; マトリックスＹ座標

	RET
BTN_PATTAN_XY	ENDP


; ****************************************************
;	ボタン受け付け開始
; ****************************************************

BTN_KEY_START	PROC	NEAR
;*;	CALL	BTN_WAVE		; ボタンＷＡＶＥ
	MOV	DX,OFFSET WIDBTNTBL	; ウインドウボタン・テーブル
	MOV	PUT_MATRIX_ADRS,DX	; マトリックス・アドレス
	CALL	BTNALL_PUTS		; ボタンＡＬＬＰＵＴ
	CALL	PAT32VRAM_SAVE		; ＶＲＡＭ退避
	RET
BTN_KEY_START	ENDP


;*;; ****************************************************
;*;;	ボタンＷＡＶＥ
;*;; ****************************************************
;*;
;*;BTN_WAVE	PROC	NEAR
;*;	MOV	LCNT1,7			; loop counter.
;*;	MOV	BX,0			; word pointer.
;*;BTN_WAVE_LOOP:
;*;	PUSH	BX			;
;*;	MOV	DX,WIDBTNANM[BX]	; 送りパタン
;*;	MOV	PUT_MATRIX_ADRS,DX	; マトリックス・アドレス
;*;	CALL	MTRX_MASK		; マトリックスＭＡＳＫ
;*;	MOV	DX,OFFSET WIDBTNWRK	; 結果
;*;	MOV	PUT_MATRIX_ADRS,DX	; マトリックス・アドレス
;*;	CALL	BTNALL_PUTS		; ボタンＡＬＬＰＵＴ
;*;	POP	BX			;
;*;	INC	BX			;
;*;	INC	BX			;
;*;	DEC	LCNT1			; loop counter.
;*;	JZ	BTN_WAVE_LP_E		;
;*;
;*;	PUSH	BX			;
;*;	MOV	AX,WTTIM		; wait timer count.
;*;	CALL	TIMER			; タイマ(V-SYNC timer wait.)
;*;	POP	BX			;
;*;	JMP	BTN_WAVE_LOOP		;
;*;BTN_WAVE_LP_E:
;*;
;*;	RET
;*;BTN_WAVE	ENDP
;*;
;*;
;*;; ****************************************************
;*;;	マトリックスＭＡＳＫ
;*;;	-I- PUT_MATRIX_ADRS : マトリックス・アドレス
;*;;	-O- WIDBTNWRK       : 結果
;*;; ****************************************************
;*;
;*;MTRX_MASK	PROC	NEAR
;*;	TABLE_COPY	PUT_MATRIX_ADRS,<OFFSET WIDBTNWRK>,10*4/2,10*4/2
;*;	TABLE_MASK	<OFFSET WIDBTNTBL>,<OFFSET WIDBTNWRK>,10*4/2,10*4/2
;*;	RET
;*;MTRX_MASK	ENDP


; ****************************************************
;	ボタンＡＬＬＰＵＴ
;	-I- PUT_MATRIX_ADRS : マトリックス・アドレス
; ****************************************************

BTNALL_PUTS	PROC	NEAR
	MOV	NUM1,0			; 番号
	MOV	SI,PUT_MATRIX_ADRS	; マトリックス・アドレス
	MOV	CURY,DSK_BTN_YP1	; ボタン左上Ｙ
	MOV	CX,DSK_BTN_CNT_YY	; ボタン並びＹ
BTNALL_PUTS_LOOP_YY:			;
	PUSH	CX			;
	MOV	CURX,DSK_BTN_XP1	; ボタン左上Ｘ
	MOV	CX,DSK_BTN_CNT_XX	; ボタン並びＸ
BTNALL_PUTS_LOOP_XX:			;
	PUSH	CX			;
	MOV	AH,0			;
	LODSB				; マトリックス・テーブル
	MOV	CURNUM,AX		; パターン番号
	PUSH	SI			;
	CALL	PAT32PUT		; ３２×３２パターンＰＵＴ
	INC	NUM1			; 番号
	CALL	NUMBERING		; 番号
	POP	SI			;
	ADD	CURX,DSK_BTNSTP_X1	; ボタンステップ左上Ｘ
	POP	CX			;
	LOOP	BTNALL_PUTS_LOOP_XX	;
	ADD	CURY,DSK_BTNSTP_Y1	; ボタンステップ左上Ｙ
	POP	CX			;
	LOOP	BTNALL_PUTS_LOOP_YY	;
	RET
BTNALL_PUTS	ENDP


; ****************************************************
;	番号その２
;	-I- CURX   : ボタンＸ
;	    CURY   : ボタンＹ
;	    MTRXXX : マトリックスＸ座標
;	    MTRYYY : マトリックスＹ座標
; ****************************************************

NUMBERING_2S	PROC	NEAR
	MOV	AX,MTRYYY		; マトリックスＹ座標
	MOV	BX,10			;
	MUL	BX			;
	ADD	AX,MTRXXX		; マトリックスＸ座標
	INC	AX			; +1
	MOV	NUM1,AX			; 番号
	CALL	NUMBERING		; 番号
	RET
NUMBERING_2S	ENDP


; ****************************************************
;	番号
;	-I- CURX : ボタンＸ
;	    CURY : ボタンＹ
;	    NUM1 : 番号
; ****************************************************

NUMBERING	PROC	NEAR
	MOV	DX,NUM1			; 番号
	CALL	DECSTR			;
	ADD	SI,3			; string.
	MOV	AX,CURX			; ボタンＸ
	ADD	AX,1			;
	MOV	BX,CURY			; ボタンＹ
	SHL	BX,1			;
	SHL	BX,1			;
	SHL	BX,1			;*8
	ADD	BX,4			;
	CALL	MITPRN			; mini string. (null=end of string)
	RET
NUMBERING	ENDP


; ****************************************************
;	ウインドウメッセージ
;	-I- BX: 3=ウインドウ・メッセージ／上段
;	        4=ウインドウ・メッセージ／中段
;	        5=ウインドウ・メッセージ／下段
;	 DS:SI : メッセージ・アドレス
; ****************************************************

WIDDISK_MESS	PROC	NEAR
	MOV	STR_ADRS,SI		; 文字列アドレス

	CALL	MESS_LINE_CLR		; メッセージ行クリア

	CMP	BX,3			; 3=ウインドウ・メッセージ／上段
	JE	WIDDISK_MESS1		;
	CMP	BX,4			; 4=ウインドウ・メッセージ／中段
	JE	WIDDISK_MESS2		;
	CMP	BX,5			; 5=ウインドウ・メッセージ／下段
	JE	WIDDISK_MESS3		;
WIDDISK_MESS1:				;
	MOVX	XX1,DSK_MESS_X1		; メッセージ１左上Ｘ
	MOVX	YY1,DSK_MESS_Y1		; メッセージ１左上Ｙ
	JMP	WIDDISK_MESS4		;
WIDDISK_MESS2:				;
	MOVX	XX1,DSK_MESS_X2		; メッセージ２左上Ｘ
	MOVX	YY1,DSK_MESS_Y2		; メッセージ２左上Ｙ
	JMP	WIDDISK_MESS4		;
WIDDISK_MESS3:				;
	MOVX	XX1,DSK_MESS_X3		; メッセージ３左上Ｘ
	MOVX	YY1,DSK_MESS_Y3		; メッセージ３左上Ｙ
	JMP	WIDDISK_MESS4		;
WIDDISK_MESS4:				;

	MOV	AX,0			; ヘッダー文字表示サイズ
	CALLC	VTXSIZ			; character size set.

	MOV	AX,0			; ヘッダー文字表示色
	CALLC	VTXCOL			; character color set.
	MOV	AX,XX1			; Ｘ座標
	MOV	BX,YY1			; Ｙ座標
	MOV	SI,STR_ADRS		; 文字列アドレス
	CALLC	VTXPOR			; vram text print OR.

	MOV	AX,15			; ヘッダー文字表示色
	CALLC	VTXCOL			; character color set.
	MOV	AX,XX1			; Ｘ座標
	MOV	BX,YY1			; Ｙ座標
	MOV	SI,STR_ADRS		; 文字列アドレス
	CALLC	VTXPOR			; vram text print OR.

	RET
WIDDISK_MESS	ENDP


; ****************************************************
;	メッセージ行クリア
;	-I- BX: 3=ウインドウ・メッセージ／上段
;	        4=ウインドウ・メッセージ／中段
;	        5=ウインドウ・メッセージ／下段
; ****************************************************

MESS_LINE_CLR	PROC	NEAR
	PUSH	SI
	PUSH	BX

	CMP	BX,3			; 3=ウインドウ・メッセージ／上段
	JE	MESS_LINE_CLR_1		;
	CMP	BX,4			; 4=ウインドウ・メッセージ／中段
	JE	MESS_LINE_CLR_2		;
	CMP	BX,5			; 5=ウインドウ・メッセージ／下段
	JE	MESS_LINE_CLR_3		;
	JMP	MESS_LINE_CLR_EXIT	;
MESS_LINE_CLR_1:			;
	MOV	AX,DSK_MESS_X1		; メッセージ１左上Ｘ
	MOV	BX,DSK_MESS_Y1		; メッセージ１左上Ｙ
	JMP	MESS_LINE_CLR_4		;
MESS_LINE_CLR_2:			;
	MOV	AX,DSK_MESS_X2		; メッセージ２左上Ｘ
	MOV	BX,DSK_MESS_Y2		; メッセージ２左上Ｙ
	JMP	MESS_LINE_CLR_4		;
MESS_LINE_CLR_3:			;
	MOV	AX,DSK_MESS_X3		; メッセージ３左上Ｘ
	MOV	BX,DSK_MESS_Y3		; メッセージ３左上Ｙ
	JMP	MESS_LINE_CLR_4		;
MESS_LINE_CLR_4:			;
	MOV	WDX1,AX			; 表示位置Ｘ
	MOV	WDY1,BX			; 表示位置Ｙ
	MOV	WDX2,MESS_LINE_X	; 大きさＸ
	MOV	WDY2,MESS_LINE_Y	; 大きさＹ
	CALL	STR_BASE_BOX		; 文字背景
MESS_LINE_CLR_EXIT:
	POP	BX
	POP	SI
	RET
MESS_LINE_CLR	ENDP


; ****************************************************
;	文字背景
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

STR_BASE_BOX	PROC	NEAR
	MOVX	VX1,WDX1		; 表示位置Ｘ
	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VX2,WDX1		; 表示位置Ｘ
	MOVX	VY2,WDY1		; 表示位置Ｙ
	ADDX	VX2,WDX2		; 大きさＸ
	ADDX	VY2,WDY2		; 大きさＹ
	DEC	VX2			;
	DEC	VY2			;

	MOV	CX,W_COL3		; カラー・暗い灰
	CALLC	BOXPAL			; ＢＯＸペイント
	MOV	CX,W_COL4		; カラー・黒
	CALLC	BOXMSS			; ＢＯＸメッシュ

	RET
STR_BASE_BOX	ENDP


; ****************************************************
;	WINDOWS/フレーム５（宝石）
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

WID_5_FLAME	PROC	NEAR
	CALL	BASE_FLAME		; フレーム１
	RET
WID_5_FLAME	ENDP


; ****************************************************
;	フレーム１
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

BASE_FLAME	PROC	NEAR
;*;	MOVX	VX1,WDX1		; 表示位置Ｘ
;*;	MOVX	VY1,WDY1		; 表示位置Ｙ
;*;	MOVX	VX2,WDX1		; 表示位置Ｘ
;*;	MOVX	VY2,WDY1		; 表示位置Ｙ
;*;	ADDX	VX2,WDX2		; 大きさＸ
;*;	ADDX	VY2,WDY2		; 大きさＹ
;*;	DEC	VX2			;
;*;	DEC	VY2			;
;*;
;*;	MOV	CX,4			; 焦げ茶
;*;	CALLC	BOXPAL			; ＢＯＸペイント
;*;;*;	MOV	CX,W_COL4		; カラー・黒
;*;;*;	CALLC	BOXMSS			; ＢＯＸメッシュ

	MOVX	VX1,WDX1		; 表示位置Ｘ
	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VX2,WDX1		; 表示位置Ｘ
	MOVX	VY2,WDY1		; 表示位置Ｙ
	ADDX	VX2,WDX2		; 大きさＸ
	ADD	VY2,9			; 大きさＹ
	DEC	VX2			;
	MOV	CX,4			; 焦げ茶
	CALLC	BOXPAL			; ＢＯＸペイント

	MOVX	VX1,WDX1		; 表示位置Ｘ
	MOVX	VX2,WDX1		; 表示位置Ｘ
	ADDX	VX2,WDX2		; 大きさＸ
	DEC	VX2			;
	MOVX	VY2,WDY1		; 表示位置Ｙ
	ADDX	VY2,WDY2		; 大きさＹ
	MOVX	VY1,VY2			; 表示位置Ｙ
	SUBX	VY1,12			; 表示位置Ｙ
	MOV	CX,4			; 焦げ茶
	CALLC	BOXPAL			; ＢＯＸペイント

	MOVX	VX1,WDX1		; 表示位置Ｘ
	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VX2,WDX1		; 表示位置Ｘ
	MOVX	VY2,WDY1		; 表示位置Ｙ
	ADDX	VX2,2			; 大きさＸ
	ADDX	VY2,WDY2		; 大きさＹ
	DEC	VX2			;
	DEC	VY2			;
	MOV	CX,4			; 焦げ茶
	CALLC	BOXPAL			; ＢＯＸペイント

	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VY2,WDY1		; 表示位置Ｙ
	ADDX	VY2,WDY2		; 大きさＹ

	MOVX	VX2,WDX1		; 表示位置Ｘ
	ADDX	VX2,WDX2		; 大きさＸ
	MOVX	VX1,VX2			; 表示位置Ｘ
	SUB	VX1,2			;
	DEC	VX2			;
	MOV	CX,4			; 焦げ茶
	CALLC	BOXPAL			; ＢＯＸペイント

	CALL	WID_GAWA		; フレームの側

	RET
BASE_FLAME	ENDP


; ****************************************************
;	フレームの側
;	-I- WDX1 : 表示位置Ｘ
;	    WDY1 : 表示位置Ｙ
;	    WDX2 : 大きさＸ
;	    WDY2 : 大きさＹ
; ****************************************************

WID_GAWA	PROC	NEAR
	MOV	AX,WDX1			; 表示位置Ｘ
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX1,AX			; ヘッダー表示Ｘ位置
	MOV	AX,WDX1			; 表示位置Ｘ
	ADD	AX,WDX2			; 大きさＸ
	SHL	AX,1			;
	SHL	AX,1			;
	SHL	AX,1			; * 8
	MOV	VX2,AX			; ヘッダー表示Ｘ位置

	MOVX	VY1,WDY1		; 表示位置Ｙ
	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL2		; カラー・明るい灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	ADDX	VY1,WDY2		; 大きさＹ
	SUB	VY1,6+1			;

	MOVX	VCOL,W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL2		; カラー・明るい灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画

	INC	VY1			;
	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEH			; 水平ライン描画


	MOVX	VY1,WDY1		; 表示位置Ｙ

	MOV	AX,WDY1			; 表示位置Ｙ
	ADD	AX,WDY2			; 大きさＹ
	DEC	AX			;
	MOV	VY2,AX			;


	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	INC	VY1			;
	DEC	VY2			;
	MOVX	VCOL,W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	INC	VY1			;
	DEC	VY2			;
	MOVX	VCOL,W_COL2		; カラー・明るい灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	INC	VY1			;
	DEC	VY2			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画


	MOVX	VX1,VX2			;
	SUB	VX1,4			;

	MOVX	VCOL,W_COL1		; カラー・ハイライト
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	DEC	VY1			;
	INC	VY2			;
	MOVX	VCOL,W_COL2		; カラー・明るい灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	DEC	VY1			;
	INC	VY2			;
	MOVX	VCOL,W_COL3		; カラー・暗い灰
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	INC	VX1			;
	DEC	VY1			;
	INC	VY2			;
	MOVX	VCOL,W_COL4		; カラー・黒
	MOV	CX,1			; 太さ
	CALLC	DLINEV			; 垂直ライン描画

	RET
WID_GAWA	ENDP


;*;; ****************************************************
;*;;	フレームの側（ＧＯＬＤ）
;*;;	-I- WDX1 : 表示位置Ｘ
;*;;	    WDY1 : 表示位置Ｙ
;*;;	    WDX2 : 大きさＸ
;*;;	    WDY2 : 大きさＹ
;*;; ****************************************************
;*;
;*;WID_GAWA_G	PROC	NEAR
;*;	MOV	AX,WDX1			; 表示位置Ｘ
;*;	SHL	AX,1			;
;*;	SHL	AX,1			;
;*;	SHL	AX,1			; * 8
;*;	MOV	VX1,AX			; ヘッダー表示Ｘ位置
;*;	MOV	AX,WDX1			; 表示位置Ｘ
;*;	ADD	AX,WDX2			; 大きさＸ
;*;	SHL	AX,1			;
;*;	SHL	AX,1			;
;*;	SHL	AX,1			; * 8
;*;	MOV	VX2,AX			; ヘッダー表示Ｘ位置
;*;
;*;	MOVX	VY1,WDY1		; 表示位置Ｙ
;*;	SUB	VY1,3			;****
;*;	MOVX	VCOL,W_COL4		; カラー・黒
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEH			; 水平ライン描画
;*;
;*;	INC	VY1			;
;*;	MOVX	VCOL,14;W_COL1		; カラー・ハイライト
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEH			; 水平ライン描画
;*;
;*;	INC	VY1			;
;*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEH			; 水平ライン描画
;*;
;*;	ADD	VY1,4			;****
;*;	ADDX	VY1,WDY2		; 大きさＹ
;*;	SUB	VY1,6+1			;
;*;	ADD	VY1,4			;****
;*;
;*;;*;	MOVX	VCOL,14;W_COL1		; カラー・ハイライト
;*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEH			; 水平ライン描画
;*;
;*;	INC	VY1			;
;*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEH			; 水平ライン描画
;*;
;*;	INC	VY1			;
;*;	MOVX	VCOL,W_COL4		; カラー・黒
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEH			; 水平ライン描画
;*;
;*;
;*;	MOVX	VY1,WDY1		; 表示位置Ｙ
;*;
;*;	MOV	AX,WDY1			; 表示位置Ｙ
;*;	ADD	AX,WDY2			; 大きさＹ
;*;	DEC	AX			;
;*;	MOV	VY2,AX			;
;*;
;*;	SUB	VX1,3			;****
;*;
;*;	MOVX	VCOL,W_COL4		; カラー・黒
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEV			; 垂直ライン描画
;*;
;*;	INC	VX1			;
;*;	INC	VY1			;
;*;	DEC	VY2			;
;*;	MOVX	VCOL,14;W_COL1		; カラー・ハイライト
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEV			; 垂直ライン描画
;*;
;*;	INC	VX1			;
;*;	INC	VY1			;
;*;	DEC	VY2			;
;*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEV			; 垂直ライン描画
;*;
;*;
;*;	MOVX	VX1,VX2			;
;*;	SUB	VX1,4			;
;*;	ADD	VX1,4			;****
;*;
;*;;*;	MOVX	VCOL,14;W_COL1		; カラー・ハイライト
;*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEV			; 垂直ライン描画
;*;
;*;	INC	VX1			;
;*;	DEC	VY1			;
;*;	INC	VY2			;
;*;	MOVX	VCOL,W_COL3		; カラー・暗い灰
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEV			; 垂直ライン描画
;*;
;*;	INC	VX1			;
;*;	DEC	VY1			;
;*;	INC	VY2			;
;*;	MOVX	VCOL,W_COL4		; カラー・黒
;*;	MOV	CX,1			; 太さ
;*;	CALLC	DLINEV			; 垂直ライン描画
;*;
;*;	RET
;*;WID_GAWA_G	ENDP


; ****************************************************
;	DATA
; ****************************************************

VRAM_SEG_G0	EQU	0A800H	; ＶＲＡＭプレーン０
VRAM_SEG_G1	EQU	0B000H	; ＶＲＡＭプレーン１
VRAM_SEG_G2	EQU	0B800H	; ＶＲＡＭプレーン２
VRAM_SEG_G3	EQU	0E000H	; ＶＲＡＭプレーン３
TEXT_VRAM_SEG	EQU	0A000H	; テキストＶＲＡＭセグメント

PUBLIC	ARAVRM			; ＶＲＡＭプレーン
ARAVRM	LABEL	WORD		; ＶＲＡＭプレーン
	DW	VRAM_SEG_G0	; ＶＲＡＭプレーン０
	DW	VRAM_SEG_G1	; ＶＲＡＭプレーン１
	DW	VRAM_SEG_G2	; ＶＲＡＭプレーン２
	DW	VRAM_SEG_G3	; ＶＲＡＭプレーン３

;	SSDESx	: used = ADVMOV.ASM/HVLINE.ASM/TALKER.ASM
;				/WIDMTRX.ASM/WIDSLCT.ASM

PUBLIC	SSDEST			; visual data segment plean.
PUBLIC	SSDES0			; visual data segment plean 0
PUBLIC	SSDES1			; visual data segment plean 1
PUBLIC	SSDES2			; visual data segment plean 2
PUBLIC	SSDES3			; visual data segment plean 3

;	SSSOUx	: used = ADVMOV.ASM/TALKER.ASM

PUBLIC	SSSOUR			; visual data segment plean.
PUBLIC	SSSOU0			; visual data segment plean 0
PUBLIC	SSSOU1			; visual data segment plean 1
PUBLIC	SSSOU2			; visual data segment plean 2
PUBLIC	SSSOU3			; visual data segment plean 3

;	SSEFCx	: used = EFECT2.ASM

PUBLIC	SSEFCT			; visual data segment plean.
PUBLIC	SSEFC0			; visual data segment plean 0
PUBLIC	SSEFC1			; visual data segment plean 1
PUBLIC	SSEFC2			; visual data segment plean 2
PUBLIC	SSEFC3			; visual data segment plean 3

EXTRN	CURNUM:WORD		; パターン番号
EXTRN	CURX:WORD		; ３２×３２パターンＸ
EXTRN	CURY:WORD		; ３２×３２パターンＹ

EXTRN	MTRX_XX:WORD		; マトリックスＸ
EXTRN	MTRX_YY:WORD		; マトリックスＹ
EXTRN	MXFLNAME:BYTE		; データファイル名
EXTRN	MTRX_ADRS:WORD		; マトリックス・アドレス

	EVEN
SSGR0	DW	VRAM_SEG_G0	; visual data segment plean 0
SSGR1	DW	VRAM_SEG_G1	; visual data segment plean 1
SSGR2	DW	VRAM_SEG_G2	; visual data segment plean 2
SSGR3	DW	VRAM_SEG_G3	; visual data segment plean 3

SSDEST	DW	VRAM_SEG_G0	; visual data segment plean.
SSDES0	DW	VRAM_SEG_G0	; visual data segment plean 0
SSDES1	DW	VRAM_SEG_G1	; visual data segment plean 1
SSDES2	DW	VRAM_SEG_G2	; visual data segment plean 2
SSDES3	DW	VRAM_SEG_G3	; visual data segment plean 3

SSSOUR	DW	VRAM_SEG_G0	; visual data segment plean.
SSSOU0	DW	VRAM_SEG_G0	; visual data segment plean 0
SSSOU1	DW	VRAM_SEG_G1	; visual data segment plean 1
SSSOU2	DW	VRAM_SEG_G2	; visual data segment plean 2
SSSOU3	DW	VRAM_SEG_G3	; visual data segment plean 3

SSEFCT	DW	VRAM_SEG_G0	; visual data segment plean.
SSEFC0	DW	VRAM_SEG_G0	; visual data segment plean 0
SSEFC1	DW	VRAM_SEG_G1	; visual data segment plean 1
SSEFC2	DW	VRAM_SEG_G2	; visual data segment plean 2
SSEFC3	DW	VRAM_SEG_G3	; visual data segment plean 3

PUBLIC	WDXX			; WINDOWS/point x.
PUBLIC	WDYY			; WINDOWS/point y.
PUBLIC	WDX1			; WINDOWS/point x1.
PUBLIC	WDY1			; WINDOWS/point y1.
PUBLIC	WDX2			; WINDOWS/point x2.
PUBLIC	WDY2			; WINDOWS/point y2.

PUBLIC	VX1			; point x1.
PUBLIC	VY1			; point y1.
PUBLIC	VX2			; point x2.
PUBLIC	VY2			; point y2.
PUBLIC	VX3			; point x3.
PUBLIC	VY3			; point y3.
PUBLIC	ADRS			; address.
PUBLIC	NUM			; number.
PUBLIC	VCOL			; color.


WDXX		DW	0		; WINDOWS/point x.
WDYY		DW	0		; WINDOWS/point y.
WDX1		DW	0		; WINDOWS/point x1.
WDY1		DW	0		; WINDOWS/point y1.
WDX2		DW	0		; WINDOWS/point x2.
WDY2		DW	0		; WINDOWS/point y2.

VX1		DW	0		; point x1.
VY1		DW	0		; point y1.
VX2		DW	0		; point x2.
VY2		DW	0		; point y2.
VX3		DW	0		; point x3.
VY3		DW	0		; point y3.
ADRS		DW	0		; address.
NUM		DW	0		; number.
VCOL		DW	0		; color.

W_COL1		DW	15		; WINDOWS/カラー・ハイライト
W_COL2		DW	8		; WINDOWS/カラー・明るい灰
W_COL3		DW	2		; WINDOWS/カラー・暗い灰
W_COL4		DW	0		; WINDOWS/カラー・黒
W_COL5		DW	2		; WINDOWS/カラー・暗い色

PUT_MATRIX_ADRS	DW	OFFSET WIDBTNTBL	; マトリックス・アドレス

WIDBTNTBL	LABEL	BYTE			; ウインドウボタン・テーブル
		DB	1,0,1,1,0,0,1,1,1,1	; 1
		DB	1,1,0,1,0,0,0,0,0,1	; 2
		DB	1,1,1,0,0,0,0,0,0,1	; 3
		DB	1,1,1,1,0,0,0,0,1,1	; 4

WIDBTNWRK	LABEL	BYTE			; ウインドウボタン・ワーク
		DB	0,0,0,0,0,0,0,0,0,0	; 1
		DB	0,0,0,0,0,0,0,0,0,0	; 2
		DB	0,0,0,0,0,0,0,0,0,0	; 3
		DB	0,0,0,0,0,0,0,0,0,0	; 4

;*;WIDBTNANM	DW	WIDBTNTBL		; 送りパタン
;*;		DW	WIDBTNAN1		;1
;*;		DW	WIDBTNAN2		;2
;*;		DW	WIDBTNAN3		;3
;*;		DW	WIDBTNAN4		;4
;*;		DW	WIDBTNAN5		;5
;*;		DW	WIDBTNTBL		;
;*;WIDBTNAN1	LABEL	BYTE
;*;		DB	1,1,1,2,2,1,1,1,1,1	; 1
;*;		DB	1,1,2,2,1,1,1,1,1,1	; 2
;*;		DB	1,2,2,1,1,1,1,1,1,1	; 3
;*;		DB	2,2,1,1,1,1,1,1,1,1	; 4
;*;WIDBTNAN2	LABEL	BYTE
;*;		DB	1,1,1,1,1,2,2,1,1,1	; 1
;*;		DB	1,1,1,1,2,2,1,1,1,1	; 2
;*;		DB	1,1,1,2,2,1,1,1,1,1	; 3
;*;		DB	1,1,2,2,1,1,1,1,1,1	; 4
;*;WIDBTNAN3	LABEL	BYTE
;*;		DB	1,1,1,1,1,1,1,2,2,1	; 1
;*;		DB	1,1,1,1,1,1,2,2,1,1	; 2
;*;		DB	1,1,1,1,1,2,2,1,1,1	; 3
;*;		DB	1,1,1,1,2,2,1,1,1,1	; 4
;*;WIDBTNAN4	LABEL	BYTE
;*;		DB	1,1,1,1,1,1,1,1,1,2	; 1
;*;		DB	1,1,1,1,1,1,1,1,2,2	; 2
;*;		DB	1,1,1,1,1,1,1,2,2,1	; 3
;*;		DB	1,1,1,1,1,1,2,2,1,1	; 4
;*;WIDBTNAN5	LABEL	BYTE
;*;		DB	1,1,1,1,1,1,1,1,1,1	; 1
;*;		DB	1,1,1,1,1,1,1,1,1,1	; 2
;*;		DB	1,1,1,1,1,1,1,1,1,2	; 3
;*;		DB	1,1,1,1,1,1,1,1,2,2	; 4

DRIVE_NUMBER	DW	0		; ＦＤドライブ番号

MUSXX		DW	0		; マウスＸ座標
MUSYY		DW	0		; マウスＹ座標
MTRXXX		DW	0		; マトリックスＸ座標
MTRYYY		DW	0		; マトリックスＹ座標
MTRNOWXXX	DW	0		; マトリックス現在Ｘ座標
MTRNOWYYY	DW	0		; マトリックス現在Ｙ座標
MTRBTON		DW	0		; マトリックスボタン触る
MTRNOWBTON	DW	0		; マトリックス現在ボタン触る
MTRSLCBTN	DW	0		; マトリックス選択ボタン種類

OFF_BTN_ACT	DW	0		; ＯＦＦボタン選択出来る？
FLG_BREAK	DW	0		; 0=正常,1=強制終了

XX1		DW	0		; Ｘ座標
YY1		DW	0		; Ｙ座標
STR_ADRS	DW	0		; 文字列アドレス
LCNT1		DW	0		; loop counter.
NUM1		DW	0		; 番号

CODE	ENDS

	END
;
;	end of "WIDSET.ASM"
;
