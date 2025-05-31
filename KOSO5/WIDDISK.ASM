; "WIDDISK.ASM" PC-9801UV11 make by R.H 1991/02/12
;
;
;	ＷＩＮＤＯＷＳ／ＤＳＫＣＨＧ専用ディスクウインドウ(DSKCHG.ASM用)
;
;	WIDDISK			; WINDOWS/ディスクウインドウ(DSKCHG.ASM用)
;				; その引数
;				; -I- BX : 1=ウインドウ・オープン
;				;        : 2=ウインドウ・クローズ
;				;        : 3=ウインドウ・メッセージ／上段
;				;        : 4=ウインドウ・メッセージ／中段
;				;        : 5=ウインドウ・メッセージ／下段
;				;  DS:SI : メッセージ・アドレス
;
; (C) 1991 ritsurou hashimoto.

INCLUDE	..\KOSO\TSTSET.INC
INCLUDE	..\KOSO\WINDOW.INC
INCLUDE	..\KOSO\KOSO.INC

NORMAL_BANK	EQU	0		; 通常のパーツバンク番号
BACKSAVE_BANK	EQU	11		; 背景退避用パーツバンク番号

DSK_FRAM_X1	EQU	16		; ディスク・フレーム左上Ｘ
DSK_FRAM_Y1	EQU	182		; ディスク・フレーム左上Ｙ
DSK_FRAM_X2	EQU	48		; ディスク・フレームサイズＸ
DSK_FRAM_Y2	EQU	72		; ディスク・フレームサイズＹ

DSK_BACK_X1	EQU	16-1		; ディスク・退避左上Ｘ
DSK_BACK_Y1	EQU	182-8		; ディスク・退避左上Ｙ
DSK_BACK_X2	EQU	48+2		; ディスク・退避サイズＸ
DSK_BACK_Y2	EQU	72+16		; ディスク・退避サイズＹ

DSK_MESS_X1	EQU	16+2		; ディスク・メッセージ１左上Ｘ
DSK_MESS_Y1	EQU	182+8		; ディスク・メッセージ１左上Ｙ
DSK_MESS_X2	EQU	16+2		; ディスク・メッセージ２左上Ｘ
DSK_MESS_Y2	EQU	182+8+18	; ディスク・メッセージ２左上Ｙ
DSK_MESS_X3	EQU	16+2		; ディスク・メッセージ３左上Ｘ
DSK_MESS_Y3	EQU	182+8+18*2	; ディスク・メッセージ３左上Ｙ

MESS_LINE_X	EQU	44		; メッセージ行大きさＸ
MESS_LINE_Y	EQU	16		; メッセージ行大きさＹ

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
;	WINDOWS/ディスクウインドウ(DSKCHG.ASM用)
;	-I- BX : 1=ウインドウ・オープン
;	       : 2=ウインドウ・クローズ
;	       : 3=ウインドウ・メッセージ／上段
;	       : 4=ウインドウ・メッセージ／中段
;	       : 5=ウインドウ・メッセージ／下段
;	 DS:SI : メッセージ・アドレス
; ****************************************************

FUNC	WWIDDISK,WIDDISK
	PUSH	ES
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
	PUSH	BP

	PUSH	VRX			; ＶＲＡＭ　Ｘ座標
	PUSH	VRY			; ＶＲＡＭ　Ｙ座標
	PUSH	VRLENX			; x length.
	PUSH	VRLENY			; y length.
	PUSH	PRSBNK			; バンク番号
	PUSH	PRSSEG			; バンクセグメント
	PUSH	PRSTOP			; バンクトップオフセット
	PUSH	PRSEND			; バンクエンドオフセット
	PUSH	PRSOFS			; パーツバッファのカレントポインタ
	PUSH	PRSSIZ			; パーツバッファの使用サイズ
	PUSH	PLSMDE			; 圧縮モード(0:通常,1:縦方向)

	CMP	BX,1			; 1=ウインドウ・オープン
	JMPEQ	WIDDISK_OPN		;

	CMP	BX,2			; 2=ウインドウ・クローズ
	JMPEQ	WIDDISK_CLOS		;

	CALL	WIDDISK_MESS		; ディスクウインドウメッセージ

	JMP	WIDDISK_EXIT
WIDDISK_OPN:
	CALL	WIDDISK_OPEN		; ディスクウインドウＯＰＥＮ
	JMP	WIDDISK_EXIT
WIDDISK_CLOS:
	CALL	WIDDISK_CLOSE		; ディスクウインドウＣＬＯＳＥ
	JMP	WIDDISK_EXIT
WIDDISK_EXIT:

	POP	PLSMDE			; 圧縮モード(0:通常,1:縦方向)
	POP	PRSSIZ			; パーツバッファの使用サイズ
	POP	PRSOFS			; パーツバッファのカレントポインタ
	POP	PRSEND			; バンクエンドオフセット
	POP	PRSTOP			; バンクトップオフセット
	POP	PRSSEG			; バンクセグメント
	POP	PRSBNK			; バンク番号
	POP	VRLENY			; y length.
	POP	VRLENX			; x length.
	POP	VRY			; ＶＲＡＭ　Ｙ座標
	POP	VRX			; ＶＲＡＭ　Ｘ座標

	POP	BP
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	POP	ES
	RET
FEND	WWIDDISK


; ****************************************************
;	ディスクウインドウＯＰＥＮ
; ****************************************************

WIDDISK_OPEN	PROC	NEAR
	CALLC	VRMIE1			; 割込み中ＶＲＡＭモード

	CALL	WID_BACKSAVE		; 背景をセーブ

	MOV	WDX1,DSK_FRAM_X1	; ディスク・フレーム左上Ｘ
	MOV	WDY1,DSK_FRAM_Y1	; ディスク・フレーム左上Ｙ
	MOV	WDX2,DSK_FRAM_X2	; ディスク・フレームサイズＸ
	MOV	WDY2,DSK_FRAM_Y2	; ディスク・フレームサイズＹ
	CALLC	WID_5_FLAME		; WINDOWS/フレーム５（宝石）
	RET
WIDDISK_OPEN	ENDP


; ****************************************************
;	ディスクウインドウＣＬＯＳＥ
; ****************************************************

WIDDISK_CLOSE	PROC	NEAR
	CALL	WID_BACKLOAD		; WINDOWS/背景をロード

	CALLC	VRMID1			; 割込み復帰ＶＲＡＭモード
	RET
WIDDISK_CLOSE	ENDP


; ****************************************************
;	ディスクウインドウメッセージ
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
	MOVX	XX1,DSK_MESS_X1		; ディスク・メッセージ１左上Ｘ
	MOVX	YY1,DSK_MESS_Y1		; ディスク・メッセージ１左上Ｙ
	JMP	WIDDISK_MESS4		;
WIDDISK_MESS2:				;
	MOVX	XX1,DSK_MESS_X2		; ディスク・メッセージ２左上Ｘ
	MOVX	YY1,DSK_MESS_Y2		; ディスク・メッセージ２左上Ｙ
	JMP	WIDDISK_MESS4		;
WIDDISK_MESS3:				;
	MOVX	XX1,DSK_MESS_X3		; ディスク・メッセージ３左上Ｘ
	MOVX	YY1,DSK_MESS_Y3		; ディスク・メッセージ３左上Ｙ
	JMP	WIDDISK_MESS4		;
WIDDISK_MESS4:				;

	CODE_IN				; ここからＣＯＤＥ

	MOV	AX,0			; ヘッダー文字表示サイズ
	CALL	VTXSIZ			; character size set.

	MOV	AX,0			; ヘッダー文字表示色
	CALL	VTXCOL			; character color set.
	MOV	AX,XX1			; Ｘ座標
	MOV	BX,YY1			; Ｙ座標
	MOV	SI,STR_ADRS		; 文字列アドレス
	CALL	VTXPOR			; vram text print OR.

	MOV	AX,15			; ヘッダー文字表示色
	CALL	VTXCOL			; character color set.
	MOV	AX,XX1			; Ｘ座標
	MOV	BX,YY1			; Ｙ座標
	MOV	SI,STR_ADRS		; 文字列アドレス
	CALL	VTXPOR			; vram text print OR.

	CODE_OUT			; ＣＯＤＥ終り

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
	MOV	AX,DSK_MESS_X1		; ディスク・メッセージ１左上Ｘ
	MOV	BX,DSK_MESS_Y1		; ディスク・メッセージ１左上Ｙ
	JMP	MESS_LINE_CLR_4		;
MESS_LINE_CLR_2:			;
	MOV	AX,DSK_MESS_X2		; ディスク・メッセージ２左上Ｘ
	MOV	BX,DSK_MESS_Y2		; ディスク・メッセージ２左上Ｙ
	JMP	MESS_LINE_CLR_4		;
MESS_LINE_CLR_3:			;
	MOV	AX,DSK_MESS_X3		; ディスク・メッセージ３左上Ｘ
	MOV	BX,DSK_MESS_Y3		; ディスク・メッセージ３左上Ｙ
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

	MOV	AX,2			; wait timer count.
	CALLC	TMVWAT			; V-SYNC timer wait.

	MOV	CX,W_COL4		; カラー・黒
	CALLC	BOXMSS			; ＢＯＸメッシュ

	RET
STR_BASE_BOX	ENDP


; ****************************************************
;	背景をセーブ
; ****************************************************

WID_BACKSAVE	PROC	NEAR
	MOV	DX,BACKSAVE_BANK	; 背景退避用パーツバンク番号
	CALLC	PATBNK			; バンクチェンジ

	CALLC	PATCLR			; パーツセットクリア

	MOV	VRX,DSK_BACK_X1		; ディスク・退避左上Ｘ
	MOV	VRY,DSK_BACK_Y1		; ディスク・退避左上Ｙ
	MOV	VRLENX,DSK_BACK_X2	; ディスク・退避サイズＸ
	MOV	VRLENY,DSK_BACK_Y2	; ディスク・退避サイズＹ

	CALLC	PATGTA			; パーツＧＥＴ圧縮無し

	RET
WID_BACKSAVE	ENDP


; ****************************************************
;	背景をロード
; ****************************************************

WID_BACKLOAD	PROC	NEAR
	MOV	DX,BACKSAVE_BANK	; 背景退避用パーツバンク番号
	CALLC	PATBNK			; バンクチェンジ

	MOV	CX,0			; 背景退避用パーツ番号
	CALLC	PATPUT			; パーツＰＵＴ

	RET
WID_BACKLOAD	ENDP

WINDOW	ENDS


DATA	SEGMENT	PUBLIC	'DATA'

EXTRN	PLSMDE:WORD			; 圧縮モード(0:通常,1:縦方向)

EXTRN	PRSBNK:WORD			; バンク番号
EXTRN	PRSSEG:WORD			; バンクセグメント
EXTRN	PRSTOP:WORD			; バンクトップオフセット
EXTRN	PRSEND:WORD			; バンクエンドオフセット

EXTRN	PRSOFS:WORD			; パーツバッファのカレントポインタ
EXTRN	PRSSIZ:WORD			; パーツバッファの使用サイズ

XX1		DW	0		; Ｘ座標
YY1		DW	0		; Ｙ座標
STR_ADRS	DW	0		; 文字列アドレス

DATA	ENDS

	END
;
;	end of "WIDDISK.ASM"
;
